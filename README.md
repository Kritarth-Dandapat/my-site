# my-site

Personal site monorepo: this repository ties together separate GitHub projects as [Git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) so you can version and clone them together.

## Contents

| Path | Description |
|------|-------------|
| [`portfolio`](./portfolio) | React + Vite academic portfolio (research, projects, timeline). Source: [Kritarth-Dandapat/portfolio](https://github.com/Kritarth-Dandapat/portfolio). Deployed via GitHub Pages (`homepage` in `portfolio/package.json`). |
| [`notebook`](./notebook) | Static notebook / long-form articles (HTML templates and content). Source: [Kritarth-Dandapat/notebook](https://github.com/Kritarth-Dandapat/notebook). |

## Clone this repository

Include submodules on first clone:

```bash
git clone --recurse-submodules https://github.com/Kritarth-Dandapat/my-site.git
cd my-site
```

If you already cloned without submodules:

```bash
git submodule update --init --recursive
```

## Working on a submodule

Each submodule is its own Git repository. Commit and push changes **inside** `portfolio/` or `notebook/`, then in the parent repo record the new submodule commit:

```bash
cd portfolio   # or notebook
git pull
# ... make changes ...
git add -A && git commit -m "Your message" && git push
cd ..
git add portfolio
git commit -m "Bump portfolio submodule"
git push
```

### Portfolio (local development)

```bash
cd portfolio
npm install
npm run dev
```

Build and preview:

```bash
npm run build
npm run preview
```

Deploy (requires `gh-pages` setup and permissions for the portfolio repo):

```bash
npm run deploy
```

### Notebook

Open `notebook/index.html` in a browser or serve the folder with any static file server. For authoring conventions, see `notebook/CONTENT_GUIDE.md` in that submodule.

## License

Refer to each submodule repository for license terms.
