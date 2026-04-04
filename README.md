# my-site

Monorepo for **dkritarth.com** (hub), **portfolio.dkritarth.com**, and **notebook.dkritarth.com**, plus LaTeX sources in [`docs/`](docs/) and dotfiles in [`config/`](config/).

## Sites

| Host | What | Source in this repo |
|------|------|---------------------|
| [dkritarth.com](https://dkritarth.com) | Short hub + **configs** (browse/download) | [`hub/`](hub/) + [`config/`](config/) |
| [portfolio.dkritarth.com](https://portfolio.dkritarth.com) | Academic portfolio (React + Vite) | [`portfolio`](./portfolio) submodule |
| [notebook.dkritarth.com](https://notebook.dkritarth.com) | Learning notes (static HTML) | [`notebook`](./notebook) submodule |

## Contents

| Path | Description |
|------|-------------|
| [`hub/`](hub/) | Static hub pages and [`hub/configs/index.html`](hub/configs/index.html) listing (overlaid on deploy with real files from `config/`). |
| [`config/`](config/) | Published under the hub at `/configs/` (Neovim, zsh, etc.). Commit this directory when you want it deployed. |
| [`docs/`](docs/) | CV, personal statement, and SOP LaTeX; sync portfolio copy from here as needed. |
| [`portfolio`](./portfolio) | [Kritarth-Dandapat/portfolio](https://github.com/Kritarth-Dandapat/portfolio) |
| [`notebook`](./notebook) | [Kritarth-Dandapat/notebook](https://github.com/Kritarth-Dandapat/notebook) |

## GitHub Pages (autodeploy)

Each GitHub repo uses **Actions** → **Pages** with source **GitHub Actions**:

| Repo | Workflow |
|------|----------|
| **my-site** | [`.github/workflows/deploy-hub.yml`](.github/workflows/deploy-hub.yml) |
| **portfolio** | [`portfolio/.github/workflows/deploy-pages.yml`](portfolio/.github/workflows/deploy-pages.yml) |
| **notebook** | [`notebook/.github/workflows/deploy-pages.yml`](notebook/.github/workflows/deploy-pages.yml) |

One-time setup per repository: **Settings → Pages → Build and deployment → Source: GitHub Actions**. Add **custom domain** and `CNAME` files are included (`hub/CNAME`, `portfolio/public/CNAME`, `notebook/CNAME`). DNS should follow [GitHub’s Pages DNS docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site).

You can re-run a deploy from the **Actions** tab via **workflow_dispatch** where enabled.

## Clone

```bash
git clone --recurse-submodules https://github.com/Kritarth-Dandapat/my-site.git
cd my-site
```

Without submodules initially:

```bash
git submodule update --init --recursive
```

## Submodules

Commit and push **inside** `portfolio/` or `notebook/`, then bump the submodule pointer in the parent repo:

```bash
cd portfolio   # or notebook
git add -A && git commit -m "Describe change" && git push
cd ..
git add portfolio
git commit -m "Bump portfolio submodule"
git push
```

### Portfolio (local)

Requires Node/npm:

```bash
cd portfolio
npm install
npm run dev
```

### Preview all three locally

From the repo root (needs **Python 3** and **npm** for the portfolio):

```bash
./scripts/serve-all.sh
```

Defaults: hub **8081**, notebook **8082**, portfolio **3000** (override with `HUB_PORT`, `NOTEBOOK_PORT`, `PORTFOLIO_PORT`). The script writes `hub/local-preview-ports.json` and `notebook/local-preview-ports.json` (gitignored) and passes matching `VITE_LOCAL_*` vars into Vite so **Hub, Notebook, and Portfolio** all link to each other on `127.0.0.1` instead of production. On macOS, three browser tabs open automatically. Stopping the script deletes the JSON files.

If you run the three servers manually, either copy the same ports into those JSON files or rely on the built-in defaults (8081 / 8082 / 3000) for hub and notebook scripts; for the portfolio run:

`VITE_LOCAL_HUB_PORT=8081 VITE_LOCAL_NOTEBOOK_PORT=8082 VITE_LOCAL_PORTFOLIO_PORT=3000 npm run dev`

### Notebook (local)

Serve `notebook/` with any static server, or open `notebook/index.html`. See `notebook/CONTENT_GUIDE.md`.

## License

Refer to each submodule repository for license terms.
