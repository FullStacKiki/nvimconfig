local o = vim.opt

-- Aspetto minimal
o.cursorline = true
o.laststatus = 3          -- una sola status bar in fondo (la disegna lualine)
o.showmode = false        -- il modo lo mostra già il colore della barra
o.showtabline = 0         -- niente tabline
-- tratti "a penna": separatori tratteggiati, bordi arrotondati
o.fillchars = { eob = "~", vert = "┊", horiz = "┄", fold = "┄" }
o.winborder = "rounded"
o.signcolumn = "no"
o.termguicolors = true
o.wrap = false
o.scrolloff = 6
o.sidescrolloff = 8

-- Indentazione: 2 spazi
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true
o.shiftround = true

-- Ricerca
o.ignorecase = true
o.smartcase = true

-- Finestre e buffer
o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"
o.confirm = true          -- chiede di salvare invece di dare errore
o.undofile = true
o.updatetime = 250
o.timeoutlen = 400
o.mouse = "a"

-- :find cerca in tutte le sottocartelle (Spazio ff, con Tab per completare)
o.path:append("**")
o.wildignore:append({ "*/node_modules/*", "*/.git/*", "*/target/*", ".DS_Store" })

-- Appunti di sistema: y / d / p usano gli stessi appunti del resto del Mac
o.clipboard = "unnamedplus"

-- ~ a sinistra di ogni riga, anche di quelle con contenuto (solo nei file, non in tree/terminale)
local tilde = "%#EndOfBuffer#%{v:virtnum == 0 ? '~' : ' '} "
o.statuscolumn = tilde
vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType", "TermOpen" }, {
  callback = function()
    vim.wo.statuscolumn = vim.bo.buftype == "" and tilde or ""
  end,
})
