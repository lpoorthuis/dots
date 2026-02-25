# Neovim Configuration Cheatsheet

> **Neovim version:** v0.11.6  
> **Plugin manager:** lazy.nvim  
> **Leader key:** `<Space>`  
> **Colorscheme:** gruvbox (dark)

---

## 🗂 Config Structure

```
~/.config/nvim/
├── init.lua                      # Entry point → requires lpoorthuis
├── lua/lpoorthuis/
│   ├── init.lua                  # Loads set, remap, lazy.nvim, then colorscheme
│   ├── lazy.lua                  # lazy.nvim bootstrap + plugin specs
│   ├── remap.lua                 # Custom keymaps
│   └── set.lua                   # Vim options
├── after/plugin/                 # Plugin-specific configs (loaded after plugins)
│   ├── fugitive.lua              # Git integration keymaps
│   ├── harpoon.lua               # Quick file navigation (Harpoon2)
│   ├── lsp.lua                   # Native LSP + Mason + nvim-cmp completion
│   ├── telescop.lua              # Fuzzy finder keymaps
│   ├── treesitter.lua            # Syntax highlighting (parsers via :TSInstall)
│   └── undotree.lua              # Undo history keymaps
└── plugin/
    └── colors.lua                # Colorscheme setup (gruvbox)
```

**Load order:** `set.lua` → `remap.lua` → `lazy.lua` (plugins) → `colorscheme` → `after/plugin/*`

---

## ⌨️ Keybindings

### General Navigation
| Keybind | Mode | Action |
|---------|------|--------|
| `<Space>pv` | Normal | Open netrw file explorer for the current directory |

**netrw basics** (once inside the explorer):
- `Enter` — open file/directory
- `-` — go up one directory
- `%` — create a new file
- `d` — create a new directory
- `D` — delete file under cursor

---

### Telescope (Fuzzy Finder)

Telescope lets you search files, text, and git objects with a fuzzy matching UI.

| Keybind | Mode | Action |
|---------|------|--------|
| `<Space>pf` | Normal | **Find files** — searches all files in the working directory recursively. Use this when you know part of a filename. |
| `<Ctrl-p>` | Normal | **Find git files** — like find files but only shows files tracked by git (faster in large repos, respects `.gitignore`). |
| `<Space>ps` | Normal | **Live grep** — prompts for a search string, then searches file contents across the entire project. Use this to find where a function/variable/string is used. |

**Inside the Telescope picker:**
| Keybind | Action |
|---------|--------|
| `<Ctrl-n>` / `<Ctrl-p>` | Move down/up in the results list |
| `<Enter>` | Open the selected file |
| `<Ctrl-x>` | Open in a horizontal split |
| `<Ctrl-v>` | Open in a vertical split |
| `<Esc>` | Close Telescope |
| `<Ctrl-u>` / `<Ctrl-d>` | Scroll the preview window up/down |

**Workflow — "I need to find something":**
1. Know the **filename**? → `<Space>pf` and type part of it
2. Know it's **in git**? → `<Ctrl-p>` (faster, ignores untracked files)
3. Know a **string/function name**? → `<Space>ps`, type the search term

---

### Harpoon (Quick File Switching)

Harpoon lets you pin up to 4 files and instantly jump between them. Think of it as bookmarks for your most-used files in a coding session.

| Keybind | Mode | Action |
|---------|------|--------|
| `<Space>a` | Normal | **Add current file** to the harpoon list (pins it) |
| `<Ctrl-e>` | Normal | **Toggle quick menu** — shows all pinned files, lets you reorder or remove them |
| `<Ctrl-h>` | Normal | **Jump to file 1** (first pinned file) |
| `<Ctrl-t>` | Normal | **Jump to file 2** |
| `<Ctrl-n>` | Normal | **Jump to file 3** |
| `<Ctrl-s>` | Normal | **Jump to file 4** |

**Inside the quick menu** (`<Ctrl-e>`):
- Edit the list like a normal buffer (delete a line to remove a file, reorder lines to change slots)
- `<Enter>` — open the file under cursor
- `<Esc>` or `q` — close the menu

**Workflow — "I keep jumping between the same files":**
1. Open your main file → `<Space>a` to pin it (slot 1)
2. Open your test file → `<Space>a` to pin it (slot 2)
3. Now use `<Ctrl-h>` / `<Ctrl-t>` to instantly switch between them
4. Need to check the list? → `<Ctrl-e>` to see/edit all pinned files

---

### LSP (Language Server Protocol)

The LSP provides IDE-like features: go-to-definition, diagnostics, refactoring, and more. These keybinds only activate in buffers where a language server is attached.

| Keybind | Mode | Action |
|---------|------|--------|
| `gd` | Normal | **Go to definition** — jump to where a function/variable/type is defined. Use `<Ctrl-o>` to jump back. |
| `gi` | Normal | **Go to implementation** — jump to the implementation of an interface/abstract method. |
| `K` | Normal | **Hover docs** — show documentation for the symbol under the cursor in a floating window. Press `K` again to enter the floating window. |
| `<Space>vws` | Normal | **Workspace symbol** — search for a symbol (function, class, variable) across the entire project by name. |
| `<Space>vd` | Normal | **Show diagnostic** — open a float with the full error/warning message for the current line. Use this when you see a ⚠️ or ❌ in the gutter. |
| `[d` | Normal | **Previous diagnostic** — jump to the previous error/warning in the buffer. |
| `]d` | Normal | **Next diagnostic** — jump to the next error/warning in the buffer. |
| `<Space>vca` | Normal | **Code action** — show available fixes/refactors (e.g., auto-import, extract function, fix lint error). |
| `<Space>vrr` | Normal | **Show references** — list all locations where the symbol under the cursor is used. |
| `<Space>vrn` | Normal | **Rename symbol** — rename a variable/function everywhere it's used across the project. |
| `<Ctrl-h>` | Insert | **Signature help** — while typing a function call, show the parameter names and types. |

**Configured language servers** (auto-installed via Mason):
- `pyright` — Python
- `gopls` — Go
- `ts_ls` — TypeScript/JavaScript
- `rust_analyzer` — Rust
- `lua_ls` — Lua (with Neovim API support)

**Workflow — "I see a yellow W in the gutter":**
1. Move cursor to the line → `<Space>vd` to read the full warning
2. `<Space>vca` to see if there's an auto-fix available
3. `]d` / `[d` to jump through all diagnostics in the file

**Workflow — "I want to understand this code":**
1. Cursor on a function call → `gd` to jump to its definition
2. `K` to read its documentation
3. `<Space>vrr` to see everywhere it's called
4. `<Ctrl-o>` to jump back to where you were

**Workflow — "I want to refactor":**
1. Cursor on the symbol → `<Space>vrn` to rename it everywhere
2. Or → `<Space>vca` for other refactoring options

---

### Completion (nvim-cmp)

Autocompletion pops up automatically as you type. It pulls suggestions from the LSP, current buffer, file paths, Lua API, and snippets.

| Keybind | Mode | Action |
|---------|------|--------|
| `<Ctrl-p>` | Insert | Move to **previous** item in the completion menu |
| `<Ctrl-n>` | Insert | Move to **next** item in the completion menu |
| `<Ctrl-y>` | Insert | **Confirm** — insert the selected completion |
| `<Ctrl-Space>` | Insert | **Trigger completion** manually (if it didn't appear automatically) |

**Completion sources** (in priority order):
1. **path** — file paths (starts when you type `./` or `/`)
2. **nvim_lsp** — LSP suggestions (functions, variables, types)
3. **nvim_lua** — Neovim Lua API (`vim.api.`, `vim.fn.`, etc.)
4. **luasnip** — snippets (after typing 2+ chars)
5. **buffer** — words from the current buffer (after typing 2+ chars)

---

### Git (vim-fugitive)

Fugitive is a full Git client inside Neovim. The custom keybind opens the status view, and from there you can do everything.

#### Custom Keybind
| Keybind | Mode | Action |
|---------|------|--------|
| `<Space>gs` | Normal | **Open Git status** — opens the fugitive summary window (equivalent to `:Git`) |

#### Fugitive Status Window (`<Space>gs`)

This is your Git dashboard. It shows staged, unstaged, and untracked files.

| Keybind | Action |
|---------|--------|
| `s` | **Stage** the file under cursor (like `git add`) |
| `u` | **Unstage** the file under cursor (like `git reset`) |
| `-` | **Toggle** stage/unstage (works on single files or visual selections) |
| `=` | **Toggle inline diff** for the file under cursor |
| `Enter` | **Open** the file under cursor |
| `o` | **Open** in a horizontal split |
| `gO` | **Open** in a vertical split |
| `cc` | **Commit** — opens a commit message buffer. Write your message, then `:wq` to commit. |
| `ca` | **Amend** the last commit |
| `ce` | **Amend** without editing the message |
| `cw` | **Reword** the last commit message |
| `X` | **Discard** changes (checkout -- file). ⚠️ Cannot be undone! |
| `dv` | **Diff** the file in a vertical split (vimdiff) |
| `P` | **Push** |
| `q` | **Close** the status window |

#### Fugitive Commands

Run these from any buffer:

```vim
:Git                    " Open status window (same as <Space>gs)
:Git add %              " Stage the current file
:Git commit             " Commit staged changes
:Git commit -m "msg"    " Commit with inline message
:Git push               " Push to remote
:Git pull               " Pull from remote
:Git log                " View commit log
:Git log --oneline      " Compact commit log
:Git blame              " Show git blame for current file (who changed each line)
:Git diff               " Show diff of unstaged changes
:Git diff --staged      " Show diff of staged changes
:Git stash              " Stash current changes
:Git stash pop          " Pop the last stash
:Git merge <branch>     " Merge a branch
:Git rebase <branch>    " Rebase onto a branch
:Git branch             " List branches
:Git checkout <branch>  " Switch branch
:Git checkout -b <name> " Create and switch to new branch
```

#### Fugitive Diff / Merge Conflicts

When viewing a diff (`dv` from status) or resolving merge conflicts:

| Keybind | Action |
|---------|--------|
| `]c` | Jump to next conflict/change hunk |
| `[c` | Jump to previous conflict/change hunk |
| `:diffget` | Accept changes from the other side |
| `:diffput` | Push your changes to the other side |
| `dp` | Shortcut for `:diffput` |
| `do` | Shortcut for `:diffget` ("diff obtain") |

**Workflow — "I want to commit my changes":**
1. `<Space>gs` to open the status window
2. Move cursor to each file → `s` to stage it (or `-` to toggle)
3. `=` to preview the diff of a file if needed
4. `cc` to commit → write your message → `:wq`
5. `P` to push

**Workflow — "I want to check what changed":**
1. `<Space>gs` to open status
2. Move to a file → `=` to see the inline diff
3. Or `dv` for a full side-by-side vimdiff
4. `:Git blame` to see who changed each line

**Workflow — "Quick stage and commit":**
1. `:Git add %` — stage current file
2. `:Git commit -m "fix: description"` — commit with message
3. `:Git push` — push

---

### Undo Tree

Undotree visualizes your entire undo history as a tree (Vim keeps branching undo history, not just linear). Your undo history persists across sessions because `undofile` is enabled.

| Keybind | Mode | Action |
|---------|------|--------|
| `<Space>u` | Normal | **Toggle undo tree** panel — shows the full undo history on the left side |

**Inside the undo tree panel:**
- Navigate with `j`/`k` to move between undo states
- `Enter` to preview/jump to that state
- `q` to close

---

### GitHub Copilot

Copilot provides AI-powered inline suggestions as you type.

| Keybind | Mode | Action |
|---------|--------|--------|
| `Tab` | Insert | Accept the current Copilot suggestion |
| `<Ctrl-]>` | Insert | Dismiss the current suggestion |
| `<Alt-]>` | Insert | Next suggestion |
| `<Alt-[>` | Insert | Previous suggestion |

```vim
:Copilot status         " Check if Copilot is connected
:Copilot enable         " Enable Copilot
:Copilot disable        " Disable Copilot
:Copilot setup          " First-time authentication
```

---

## 🛠 Essential Commands

### Plugin Management (lazy.nvim)
```vim
:Lazy                " Open lazy.nvim dashboard — shows all plugins, status, and actions
:Lazy sync           " Install missing + update all + clean removed plugins (do this regularly)
:Lazy update         " Update all plugins to latest versions
:Lazy check          " Check for updates without installing them
:Lazy clean          " Remove plugins that are no longer in your lazy.lua spec
:Lazy health         " Run health checks on lazy.nvim
:Lazy profile        " Show startup profiling — find which plugins are slow to load
```

### LSP & Language Servers
```vim
:LspInfo             " Show which language servers are attached to the current buffer
:LspLog              " Open the LSP log file (useful for debugging server issues)
:LspRestart          " Restart all LSP clients (try this when things feel broken)
:Mason               " Open Mason UI — install, update, or remove language servers
:MasonInstall <srv>  " Install a specific language server (e.g., :MasonInstall pyright)
:MasonUpdate         " Update all installed servers
:checkhealth vim.lsp " Run LSP health checks
```

### Treesitter (Syntax Highlighting)
```vim
:TSInstall <lang>             " Install a parser (e.g., :TSInstall go python typescript)
:TSUpdate                     " Update all installed parsers
:TSUninstall <lang>           " Remove a parser
:checkhealth nvim-treesitter  " Check treesitter health and installed parsers
```
> **Requirement:** `tree-sitter-cli` must be installed: `brew install tree-sitter-cli`

**Installed parsers:** c, lua, vim, vimdoc, query, go, python, typescript

### Python Virtual Environments
```vim
:VenvSelect          " Open a picker to select a Python virtual environment
```
Once selected, the LSP (pyright) will use that environment for completions and diagnostics.

### General Maintenance
```bash
# Update Neovim
brew update && brew upgrade neovim

# Update tree-sitter CLI (required for parser compilation)
brew upgrade tree-sitter-cli

# Full health check (run this if something feels off)
nvim +checkhealth

# Update everything at once inside Neovim
# :Lazy sync       → update plugins
# :TSUpdate        → update parsers
# :MasonUpdate     → update language servers

# Clear cache if things get weird (nuclear option)
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim

# Backup config before big changes
cp -r ~/.config/nvim ~/.config/nvim.bak
```

---

## 📋 Vim Options Summary (from set.lua)

| Option | Value | Description |
|--------|-------|-------------|
| `nu` | `true` | Show line numbers |
| `tabstop` | `4` | A tab character displays as 4 spaces wide |
| `softtabstop` | `4` | Pressing Tab inserts 4 spaces |
| `shiftwidth` | `4` | Indentation (e.g., `>>`, auto-indent) uses 4 spaces |
| `expandtab` | `true` | Insert spaces instead of tab characters |
| `swapfile` | `false` | No `.swp` files (avoids "swap file exists" warnings) |
| `backup` | `false` | No backup files |
| `undofile` | `true` | Persist undo history to disk (survives closing/reopening files) |
| `undodir` | `~/.vim/undodir` | Where undo files are stored |
| `hlsearch` | `false` | Don't keep search results highlighted after searching |
| `incsearch` | `true` | Show matches as you type a search pattern |
| `termguicolors` | `true` | Use 24-bit RGB colors (required for gruvbox) |
| `scrolloff` | `8` | Keep 8 lines visible above/below cursor when scrolling |
| `signcolumn` | `yes` | Always show the sign column (prevents layout shift from diagnostics) |
| `updatetime` | `50` | Faster CursorHold events (snappier diagnostics) |
| `colorcolumn` | `80` | Show a vertical guide at column 80 |

---

## 🔌 Installed Plugins

| Plugin | Purpose | Status |
|--------|---------|--------|
| lazy.nvim | Plugin manager | ✅ Active |
| telescope.nvim | Fuzzy finder (files, grep, git) | ✅ Active |
| plenary.nvim | Lua utilities (telescope/harpoon dependency) | ✅ Active |
| gruvbox.nvim | Colorscheme | ✅ Active |
| nvim-treesitter | Syntax highlighting via tree-sitter parsers | ✅ Active |
| harpoon | Quick file navigation (Harpoon2 API) | ✅ Active |
| undotree | Visualize branching undo history | ✅ Active |
| vim-fugitive | Full Git client inside Neovim | ✅ Active |
| mason.nvim | Install/manage language servers | ✅ Active |
| mason-lspconfig.nvim | Auto-setup bridge between Mason and LSP | ✅ Active |
| nvim-lspconfig | LSP server configurations | ✅ Active |
| nvim-cmp | Autocompletion engine | ✅ Active |
| cmp-nvim-lsp | LSP completion source | ✅ Active |
| cmp-nvim-lua | Neovim Lua API completion source | ✅ Active |
| cmp-buffer | Current buffer word completion | ✅ Active |
| cmp-path | File path completion | ✅ Active |
| LuaSnip | Snippet engine | ✅ Active |
| cmp_luasnip | Snippet completion source | ✅ Active |
| friendly-snippets | Pre-built snippet collection (many languages) | ✅ Active |
| copilot.vim | GitHub Copilot AI suggestions | ✅ Active |
| venv-selector.nvim | Python virtual environment picker | ✅ Active |

---

## 🧭 Common Navigation Patterns

### "I just opened a project, now what?"
1. `<Space>pf` → find and open a file by name
2. `<Space>a` → pin it to harpoon
3. Repeat for your other key files
4. Use `<Ctrl-h>`/`<Ctrl-t>`/`<Ctrl-n>`/`<Ctrl-s>` to jump between them all session

### "I need to find where something is defined/used"
1. Cursor on the symbol → `gd` to go to definition
2. `<Space>vrr` to see all references
3. `<Ctrl-o>` to jump back to where you were

### "I want to fix all the errors in this file"
1. `]d` to jump to the first diagnostic
2. `<Space>vd` to read the full message
3. `<Space>vca` to see if there's an auto-fix
4. `]d` again to move to the next one

### "I need to commit and push"
1. `<Space>gs` → stage files with `s` → `cc` to commit → `:wq` → done
2. Or quick: `:Git add %` → `:Git commit -m "msg"` → `:Git push`
