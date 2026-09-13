#!/usr/bin/env bash
set -euo pipefail

: "${RELEASE_TAG:?RELEASE_TAG is required}"
: "${RELEASE_SHA:?RELEASE_SHA is required}"
[[ "$RELEASE_TAG" =~ ^www-v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]

test "$(git cat-file -t "refs/tags/$RELEASE_TAG")" = tag
test "$(git rev-parse "refs/tags/$RELEASE_TAG^{commit}")" = "$RELEASE_SHA"
test "$(git rev-parse HEAD)" = "$RELEASE_SHA"
git merge-base --is-ancestor "$RELEASE_SHA" refs/remotes/origin/main
