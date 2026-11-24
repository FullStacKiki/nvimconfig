-- Temi retrò. mrrobot: un solo colore, stessa struttura per ogni tavolozza (M.load).
-- Le parti del codice si distinguono con luminosità, grassetto, corsivo e sottolineato.
local M = {}

M.palettes = {
  -- bianco e nero puro, stile terminale di fsociety
  mrrobot = {
    bg = "#000000", bg1 = "#0d0d0d", bg2 = "#1a1a1a", bg3 = "#262626",
    g1 = "#3a3a3a", g2 = "#5c5c5c", g3 = "#8a8a8a", g4 = "#b3b3b3",
    fg = "#e6e6e6", white = "#ffffff",
  },
  -- phosphor: verde su nero con qualche tinta pastello, come i terminali "riced" del 2013
  -- (font Pixel 4x7). Usa i suoi gruppi in colors/phosphor.lua: qui solo la tavolozza,
  -- che serve a barra in basso e schermata iniziale.
  phosphor = {
    bg = "#000000", bg1 = "#0b1a0b", bg2 = "#112811", bg3 = "#1a3a1a",
    g1 = "#2a4a2a", g2 = "#446644", g3 = "#66cccc", g4 = "#9988dd",
    fg = "#88ff88", white = "#ccffa9",
    lime = "#aaff66", cyan = "#66cccc", violet = "#9988dd", blue = "#88aaff",
    navy = "#6688bb", rust = "#b87457", red = "#ff5f5f", blood = "#5f0000",
    cloud = { "#446644", "#66cccc", "#9988dd", "#88ff88", "#aaff66" },
  },
}

function M.load(name)
  local p = M.palettes[name]
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
  vim.o.background = "dark"
  vim.g.colors_name = name
  local function hl(name, spec) vim.api.nvim_set_hl(0, name, spec) end

  -- editor
  hl("Normal", { fg = p.fg, bg = p.bg })
  hl("NormalNC", { fg = p.fg, bg = p.bg })
  hl("NormalFloat", { fg = p.fg, bg = p.bg1 })
  hl("FloatBorder", { fg = p.g3, bg = p.bg1 })
  hl("FloatTitle", { fg = p.white, bg = p.bg1, bold = true })
  hl("Cursor", { fg = p.bg, bg = p.white })
  hl("CursorLine", { bg = p.bg2 })
  hl("CursorColumn", { bg = p.bg2 })
  hl("ColorColumn", { bg = p.bg1 })
  hl("LineNr", { fg = p.g1 })
  hl("CursorLineNr", { fg = p.white, bold = true })
  hl("SignColumn", { bg = p.bg })
  hl("EndOfBuffer", { fg = p.g2 })
  hl("NonText", { fg = p.g1 })
  hl("Whitespace", { fg = p.g1 })
  hl("WinSeparator", { fg = p.g1 })
  hl("VertSplit", { link = "WinSeparator" })
  hl("StatusLine", { fg = p.fg, bg = p.bg })
  hl("StatusLineNC", { fg = p.g2, bg = p.bg })
  hl("WinBar", { fg = p.fg, bg = p.bg, bold = true })
  hl("WinBarNC", { fg = p.g2, bg = p.bg })
  hl("TabLine", { fg = p.g3, bg = p.bg1 })
  hl("TabLineSel", { fg = p.bg, bg = p.white, bold = true })
  hl("TabLineFill", { bg = p.bg })
  hl("Visual", { fg = p.bg, bg = p.g4 })
  hl("Search", { fg = p.bg, bg = p.g4 })
  hl("IncSearch", { fg = p.bg, bg = p.white, bold = true })
  hl("CurSearch", { link = "IncSearch" })
  hl("MatchParen", { fg = p.white, bold = true, underline = true })
  hl("Pmenu", { fg = p.fg, bg = p.bg2 })
  hl("PmenuSel", { fg = p.bg, bg = p.white, bold = true })
  hl("PmenuSbar", { bg = p.bg3 })
  hl("PmenuThumb", { bg = p.g3 })
  hl("Folded", { fg = p.g3, bg = p.bg1, italic = true })
  hl("Title", { fg = p.white, bold = true })
  hl("Directory", { fg = p.white, bold = true })
  hl("Question", { fg = p.white, bold = true })
  hl("MoreMsg", { fg = p.white, bold = true })
  hl("ModeMsg", { fg = p.white, bold = true })
  hl("ErrorMsg", { fg = p.bg, bg = p.white, bold = true })
  hl("WarningMsg", { fg = p.white, bold = true, underline = true })
  hl("QuickFixLine", { bg = p.bg3, bold = true })
  hl("SpellBad", { undercurl = true, sp = p.white })
  hl("SpellCap", { undercurl = true, sp = p.g3 })
  hl("Conceal", { fg = p.g3 })
  hl("DiffAdd", { bg = p.bg3 })
  hl("DiffChange", { bg = p.bg2 })
  hl("DiffDelete", { fg = p.g2, bg = p.bg1 })
  hl("DiffText", { bg = p.g1, bold = true })

  -- codice: luce = importante, grigio = contorno
  hl("Comment", { fg = p.g2, italic = true })
  hl("Constant", { fg = p.g4 })
  hl("String", { fg = p.g4, italic = true })
  hl("Character", { link = "String" })
  hl("Number", { fg = p.white })
  hl("Boolean", { fg = p.white, bold = true })
  hl("Float", { link = "Number" })
  hl("Identifier", { fg = p.fg })
  hl("Function", { fg = p.white, bold = true })
  hl("Statement", { fg = p.white, bold = true })
  hl("Keyword", { fg = p.white, bold = true })
  hl("Conditional", { link = "Keyword" })
  hl("Repeat", { link = "Keyword" })
  hl("Operator", { fg = p.g3 })
  hl("Exception", { fg = p.white, bold = true, underline = true })
  hl("PreProc", { fg = p.g4, bold = true })
  hl("Include", { fg = p.g3, bold = true })
  hl("Type", { fg = p.fg, italic = true })
  hl("Special", { fg = p.g4 })
  hl("Delimiter", { fg = p.g2 })
  hl("Underlined", { fg = p.white, underline = true })
  hl("Error", { fg = p.bg, bg = p.white })
  hl("Todo", { fg = p.bg, bg = p.g4, bold = true })

  -- treesitter
  hl("@variable", { fg = p.fg })
  hl("@variable.builtin", { fg = p.g4, italic = true })
  hl("@variable.parameter", { fg = p.g4 })
  hl("@variable.member", { fg = p.fg })
  hl("@property", { fg = p.fg })
  hl("@punctuation.bracket", { fg = p.g2 })
  hl("@punctuation.delimiter", { fg = p.g2 })
  hl("@constructor", { fg = p.white })
  hl("@tag", { fg = p.white, bold = true })
  hl("@tag.attribute", { fg = p.g3, italic = true })
  hl("@tag.delimiter", { fg = p.g2 })
  hl("@markup.heading", { fg = p.white, bold = true, underline = true })
  hl("@markup.link", { fg = p.g4, underline = true })
  hl("@markup.raw", { fg = p.g4, bg = p.bg1 })
  hl("@markup.strong", { bold = true })
  hl("@markup.italic", { italic = true })

  -- diagnostica e git (senza colori)
  hl("DiagnosticError", { fg = p.white, bold = true })
  hl("DiagnosticWarn", { fg = p.g4 })
  hl("DiagnosticInfo", { fg = p.g3 })
  hl("DiagnosticHint", { fg = p.g2 })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.white })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.g3 })
  hl("Added", { fg = p.white })
  hl("Changed", { fg = p.g4 })
  hl("Removed", { fg = p.g2, strikethrough = true })

  -- neo-tree
  hl("NeoTreeNormal", { fg = p.fg, bg = p.bg })
  hl("NeoTreeNormalNC", { fg = p.fg, bg = p.bg })
  hl("NeoTreeEndOfBuffer", { fg = p.bg, bg = p.bg })
  hl("NeoTreeWinSeparator", { fg = p.g1, bg = p.bg })
  hl("NeoTreeRootName", { fg = p.white, bold = true, underline = true })
  hl("NeoTreeDirectoryName", { fg = p.white, bold = true })
  hl("NeoTreeDirectoryIcon", { fg = p.white })
  hl("NeoTreeFileName", { fg = p.g4 })
  hl("NeoTreeFileIcon", { fg = p.g3 })
  hl("NeoTreeExpander", { fg = p.g2 })
  hl("NeoTreeDotfile", { fg = p.g2, italic = true })
  hl("NeoTreeCursorLine", { fg = p.bg, bg = p.white, bold = true })
  hl("NeoTreeGitModified", { fg = p.white, italic = true })
  hl("NeoTreeGitUntracked", { fg = p.white, underline = true })
  hl("NeoTreeModified", { fg = p.white })
  hl("NeoTreeTabActive", { fg = p.white, bg = p.bg, bold = true })
  hl("NeoTreeTabInactive", { fg = p.g2, bg = p.bg })
  hl("NeoTreeTabSeparatorActive", { fg = p.bg, bg = p.bg })
  hl("NeoTreeTabSeparatorInactive", { fg = p.bg, bg = p.bg })
  hl("NeoTreeFloatBorder", { fg = p.g3, bg = p.bg1 })

  -- which-key
  hl("WhichKey", { fg = p.white, bold = true })
  hl("WhichKeyGroup", { fg = p.g4, italic = true })
  hl("WhichKeyDesc", { fg = p.fg })
  hl("WhichKeySeparator", { fg = p.g2 })
  hl("WhichKeyNormal", { bg = p.bg1 })
  hl("WhichKeyBorder", { fg = p.g3, bg = p.bg1 })

  -- icone dei file in grigio, non a colori
  for _, g in ipairs(vim.fn.getcompletion("DevIcon", "highlight")) do hl(g, { fg = p.g3 }) end

  -- terminale integrato
  local term = { p.bg, p.g3, p.g4, p.fg, p.g4, p.g3, p.fg, p.fg, p.g2, p.white, p.white, p.white, p.white, p.white, p.white, p.white }
  for i, c in ipairs(term) do vim.g["terminal_color_" .. (i - 1)] = c end

end

return M
