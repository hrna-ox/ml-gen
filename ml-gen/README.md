## 🚀 Installation & Environment Setup

This project uses [uv](https://github.com/astral-sh/uv) for fast, reproducible Python environments with modern dependency resolution.

### ✅ Requirements

- Python 3.11 or newer
- [`uv`](https://github.com/astral-sh/uv) (install via `curl` or `pipx`)
- Optional: `pipx`, `fzf`, `zoxide`, `neovim`, etc.

### 📦 Installing `uv`

```bash
curl -Ls https://astral.sh/uv/install.sh | sh
```

or

`pipx install uv`


### Activating the Environment
Run

``` bash
uv venv
source .venv/bin/activate
```

to activate the environment.

### Environment updates

Whenever environment is updated, please run the `.update-lock.sh` file from within the corresponding folder.