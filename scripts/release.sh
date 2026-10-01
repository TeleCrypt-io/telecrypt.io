#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
mode="${1:?usage: bash scripts/release.sh prepare|publish TAG}"
tag="${2:?release tag required}"
case "$mode" in prepare|publish) ;; *) echo 'Expected prepare or publish' >&2; exit 2;; esac
sha="$(git rev-parse HEAD)"
test -z "$(git status --porcelain)"
export RELEASE_TAG="$tag" RELEASE_SHA="$sha"
bash scripts/verify-source.sh
test "${tag#www-v}" = "$(node -p 'require("./package.json").version')"
directory="release/$tag"
asset="$tag.tar.gz"
if [[ "$mode" == prepare ]]; then
test "$(node --version)" = "v$(node -p 'require("./package.json").engines.node')"
test "$(pnpm --version)" = "$(node -p 'require("./package.json").packageManager.replace(/^pnpm@/u, "")')"
test "$(head -n 1 LICENSE)" = 'MIT License'
pnpm --reporter=append-only install --frozen-lockfile --ignore-scripts
pnpm --reporter=append-only run lint
pnpm --reporter=append-only run build
python3 scripts/validate-generated-site.py dist
mkdir -p "$directory"
tar -czf "$directory/$asset" -C dist .
jq -n --arg sha "$sha" --arg asset "$asset" --arg digest "sha256:$(sha256sum "$directory/$asset" | cut -d' ' -f1)" --argjson size "$(wc -c <"$directory/$asset")" '{sha:$sha,asset:$asset,digest:$digest,size:$size}' >"$directory/manifest.json"
printf 'Prepared %s/%s; publish with: bash scripts/release.sh publish %s\n' "$directory" "$asset" "$tag"
else
test "$(jq -r .sha "$directory/manifest.json")" = "$sha"
test "$(jq -r .asset "$directory/manifest.json")" = "$asset"
digest="$(jq -r .digest "$directory/manifest.json")"
size="$(jq -r .size "$directory/manifest.json")"
test "sha256:$(sha256sum "$directory/$asset" | cut -d' ' -f1)" = "$digest"
test "$(wc -c <"$directory/$asset")" = "$size"
if ! gh release create "$tag" "$directory/$asset" --repo TeleCrypt-io/telecrypt.io --verify-tag --target "$sha" --generate-notes; then
  echo "Release creation did not succeed; checking whether the exact archive was already published." >&2
fi
verified="$(mktemp -d)"
trap 'rm -rf -- "$verified"' EXIT
bash scripts/download-release.sh "$tag" "$sha" "$verified"
cmp "$directory/$asset" "$verified/$asset"
fi
