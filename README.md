# 📖 Neovim Shortcuts Guide (Personal Configuration)

## Index
- [📂 Directory Navigation](#-directory-navigation)
- [📋 System Clipboard](#-system-clipboard)
- [🩺 Diagnostics & Formatting](#-diagnostics--formatting)
- [✍️ Insert Mode](#-insert-mode)
- [🪟 Window Management (Splits)](#-window-management-splits)
- [🗂️ Tab Management](#-tab-management)
- [💾 Session Management (auto-session)](#-session-management-auto-session)
- [🔍 Searching with FZF-Lua](#-searching-with-fzf-lua)
- [🧠 LSP (Language Server Protocol)](#-lsp-language-server-protocol)
- [🌳 Treesitter Textobjects](#-treesitter-textobjects)
- [📝 Todo Comments](#-todo-comments)
- [🔎 Vim-Maximizer](#-vim-maximizer)
- [❓ Which-Key](#-which-key)

---

## 📂 Directory Navigation
- `-` → **Open parent directory in Oil** (floating mode)

---

## 📋 System Clipboard
### Yank (copy)
- `<leader>y` → Copy selection/motion to system clipboard  
- `<leader>Y` → Copy entire line to system clipboard  

### Delete (cut)
- `<leader>d` → Cut selection/motion to system clipboard  
- `<leader>D` → Cut entire line to system clipboard  

### Paste
- `<leader>p` → Paste after cursor from system clipboard  
- `<leader>P` → Paste before cursor from system clipboard  

---

## 🩺 Diagnostics & Formatting
- `gl` → Open diagnostic in floating window  
- `<leader>cf` → Format current file (using `conform`, fallback to LSP)

---

## ✍️ Insert Mode
- `jk` → Exit Insert mode and return to Normal

---

## 🪟 Window Management (Splits)
- `<leader>sv` → Split window vertically  
- `<leader>sh` → Split window horizontally  
- `<leader>se` → Equalize split sizes  
- `<leader>sx` → Close current split  
- `<leader>sm` → Maximize current split  
- `<leader>sr` → Restore split sizes  

### Move between splits (using `s` + arrow keys)
- `s + ←` → Move to left split  
- `s + ↓` → Move to bottom split  
- `s + ↑` → Move to top split  
- `s + →` → Move to right split  

---

## 🗂️ Tab Management
- `<leader>to` → Open new tab  
- `<leader>tx` → Close current tab  
- `<leader>tn` → Go to next tab  
- `<leader>tp` → Go to previous tab  
- `<leader>tf` → Open current buffer in new tab  

---

## 💾 Session Management (auto-session)
- `<leader>wr` → Search saved sessions  
- `<leader>ws` → Save current session  
- `<leader>wa` → Toggle auto-save mode  

---

## 🔍 Searching with FZF-Lua
- `<leader>ff` → Find files in project  
- `<leader>fg` → Search text in project (*live grep*)  
- `<leader>fc` → Find files in Neovim config  
- `<leader>fh` → Find in help (`helptags`)  
- `<leader>fk` → Find keymaps  
- `<leader>fb` → Access FZF builtins  
- `<leader>fw` → Find current word under cursor  
- `<leader>fW` → Find current WORD under cursor  
- `<leader>fd` → Find diagnostics in current document  
- `<leader>fr` → Resume last FZF search  
- `<leader>fo` → Find recent files (*oldfiles*)  
- `<leader><leader>` → Find among open buffers  
- `<leader>/` → Live grep in current buffer  

---

## 🧠 LSP (Language Server Protocol)
- `gd` → Go to definition  
- `gr` → Find references  
- `gI` → Go to implementation  
- `<leader>D` → Go to type definition  
- `<leader>ds` → Find document symbols  
- `<leader>wss` → Find workspace symbols  
- `<leader>cr` → Rename variable/symbol  
- `<leader>ca` → Execute code action  
- `gD` → Go to declaration  
- `<leader>th` → Toggle inlay hints  

### Diagnostic Configuration
- Custom icons:  
  - Error → `󰅚`  
  - Warning → `󰀪`  
  - Info → `󰋽`  
  - Hint → `󰌶`  

### Enabled Servers
- `bashls`, `marksman`, `tailwindcss`, `pyright`, `clangd`, `ts_ls`, `lua_ls`

### Extra Tools
- `stylua`, `prettier`, `prettierd`

---

## 🌳 Treesitter Textobjects
### Selection
- `af` → Select entire function  
- `if` → Select inside function  
- `ac` → Select entire class  
- `ic` → Select inside class  
- `ao` → Select entire comment  
- `as` → Select local scope  

### Parameter Swapping
- `<leader>a` → Swap with next parameter  
- `<leader>A` → Swap with previous parameter  

---

## 📝 Todo Comments
- `]t` → Jump to next TODO/FIX/NOTE comment  
- `[t` → Jump to previous TODO/FIX/NOTE comment  

---

## 🔎 Vim-Maximizer
- `<leader>sm` → Toggle maximize/restore current split  

---

## ❓ Which-Key
- `<leader>?` → Show buffer-local keymaps with **which-key**  

---

# 🗨️ Comment.nvim
- **Plugin:** `numToStr/Comment.nvim` (with `nvim-ts-context-commentstring` for context-aware comments)  
- **Purpose:** Easily comment/uncomment code, with smart detection for mixed-language files (JSX, TSX, HTML, Svelte).  

### Basic Commands
- `gc` → Toggle comment on a line (Normal mode)  
- `gcc` → Comment/uncomment the current line  
- `gc{motion}` → Comment a text object or motion (e.g., `gcw` for a word)  
- `gb` → Toggle block comment  
- `gbc` → Comment/uncomment current block  
- `gco` → Insert comment to the next line and enters INSERT mode
- `gcO` → Insert comment to the previous line and enters INSERT mode
- `gcA` → Insert comment to end of the current line and enters INSERT mode
- Visual mode: select text and press `gc` or `gb` to comment/uncomment selection 
