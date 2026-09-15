# TeleCrypt.io — landing

Static landing site for **TeleCrypt.io**, published at
`https://www.telecrypt.io/` through GitHub Pages.

This repository is production-only. Its public host is fixed at `www.telecrypt.io`; it has no
environment or server-name input and does not publish a `www.stage.telecrypt.io` variant.

> Secure transport for agents and human beings.

Built with [Astro](https://astro.build) and published as a fully static build.

## Content

The site contains the landing page, pricing, technology, About, support, privacy, and export pages.
The canonical machine-readable [`llms.txt`](https://www.telecrypt.io/llms.txt) lives in
`public/llms.txt` and is published with the site. `export.txt` is served verbatim, and
`privacy.txt` is generated from the same source as the privacy page.

The framework-neutral shared product stylesheet lives in `shared/ui/product.css`. Applications
vendor reviewed copies and record the exact source commit and content hash. The canonical brand
mark is `public/logo-mark.png`.

## Develop

Use Node.js 22.23.2 and pnpm 11.22.0, as declared by `.node-version` and `package.json`.

```sh
pnpm install --frozen-lockfile
pnpm run check
pnpm run lint
pnpm run dev      # http://localhost:4321
```

## Deploy

This repo holds **source only**; `dist/` is gitignored. Pushes and pull requests to `main` only
verify the source. An exact annotated `www-v*` tag is tested and built once, then published with its
static artifact as an immutable GitHub Release. The same workflow promotes that
verified release artifact to GitHub Pages without rebuilding, so every deployment identifies its
exact source release rather than a branch. Configure
the repository's Pages custom domain as `www.telecrypt.io`. The site URL is a committed production
constant, not a deployment-time setting.

These public workflows verify and publish the static artifact; acceptance of the deployed site is
operator-managed outside this repository.

The release job uses GitHub CLI to publish the archive and GitHub's Release API to check its tag,
asset name, size, and digest. If a retry finds a release already published for the tag, it verifies
that release against the archive built by the same run before promotion. Pages receives those exact
verified bytes through GitHub's Pages artifact and deployment actions; no custom API client or
release-recovery workflow is involved.

## License

The inherited Astro Sienna site source is licensed under [MIT](./LICENSE).
`public/llms.txt` is licensed under its original
[BUSL-1.1 terms](./LICENSES/llms-authority-BUSL-1.1.txt). `shared/ui/product.css` and
`public/logo-mark.png` are licensed under their original
[BUSL-1.1 terms](./LICENSES/shared-ui-BUSL-1.1.txt).
