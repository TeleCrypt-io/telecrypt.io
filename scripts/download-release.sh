#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."
tag="${1:?release tag required}"
sha="${2:?release commit required}"
directory="${3:?download directory required}"
RELEASE_TAG="$tag" RELEASE_SHA="$sha" bash scripts/verify-source.sh
export GITHUB_REPOSITORY=TeleCrypt-io/telecrypt.io
asset="$tag.tar.gz"
metadata="$(mktemp)"
trap 'rm -f -- "$metadata"' EXIT
gh api "repos/$GITHUB_REPOSITORY/releases/tags/$tag" >"$metadata"
jq -e --arg tag "$tag" --arg sha "$sha" --arg asset "$asset" '
  .id > 0 and .tag_name == $tag and .target_commitish == $sha and
  .draft == false and .prerelease == false and .immutable == true and
  (.assets | length == 1) and .assets[0].name == $asset and
  .assets[0].state == "uploaded" and .assets[0].size > 0 and
  (.assets[0].digest | test("^sha256:[a-f0-9]{64}$"))' "$metadata" >/dev/null
mkdir -p "$directory"
gh api --header 'Accept: application/octet-stream'   "repos/$GITHUB_REPOSITORY/releases/assets/$(jq -r '.assets[0].id' "$metadata")" >"$directory/$asset"
test "$(wc -c <"$directory/$asset")" = "$(jq -r '.assets[0].size' "$metadata")"
test "sha256:$(sha256sum "$directory/$asset" | cut -d' ' -f1)" = "$(jq -r '.assets[0].digest' "$metadata")"
