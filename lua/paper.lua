-- paper: tema chiaro monocromatico, come codice stampato su carta.
-- Niente colori saturi né corsivi: le keyword si distinguono solo col grassetto.
local M = {}

M.p = {
  bg = "#F4F3EF",      -- carta (bianco caldo)
  cursorline = "#EAE8E2",
  visual = "#DDDAD2",
  linenr = "#B5B2AA",
  comment = "#8A8A8A",
  fg = "#2B2B2B",
  ink = "#1E1E1E",     -- keyword, funzioni
  dark = "#3A3A3A",    -- tipi, costanti
  mid = "#555555",     -- stringhe, numeri, punteggiatura
  soft = "#6E6E6E",
  border = "#C9C6BE",
}

function M.load()
  local p = M.p
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
  vim.o.background = "light"
  vim.g.colors_name = "paper"
  local function hl(name, spec) vim.api.nvim_set_hl(0, name, spec) end

  -- editor
  hl("Normal", { fg = p.fg, bg = p.bg })
  hl("NormalNC", { fg = p.fg, bg = p.bg })
  hl("NormalFloat", { fg = p.fg, bg = p.bg })
  hl("FloatBorder", { fg = p.linenr, bg = p.bg })
  hl("FloatTitle", { fg = p.ink, bg = p.bg, bold = true })
  hl("FloatFooter", { fg = p.comment, bg = p.bg })
  hl("Cursor", { fg = p.bg, bg = p.ink })
  hl("CursorLine", { bg = p.cursorline })
  hl("CursorColumn", { bg = p.cursorline })
  hl("ColorColumn", { bg = p.cursorline })
  hl("LineNr", { fg = p.linenr })
  hl("CursorLineNr", { fg = p.fg, bold = true })
  hl("SignColumn", { bg = p.bg })
  hl("EndOfBuffer", { fg = p.linenr })
  hl("NonText", { fg = p.linenr })
  hl("Whitespace", { fg = p.border })
  hl("WinSeparator", { fg = p.border })
  hl("VertSplit", { link = "WinSeparator" })
  hl("StatusLine", { fg = p.fg, bg = p.bg })
  hl("StatusLineNC", { fg = p.comment, bg = p.bg })
  hl("WinBar", { fg = p.fg, bg = p.bg, bold = true })
  hl("WinBarNC", { fg = p.comment, bg = p.bg })
  hl("TabLine", { fg = p.comment, bg = p.cursorline })
  hl("TabLineSel", { fg = p.ink, bg = p.bg, bold = true })
  hl("TabLineFill", { bg = p.cursorline })
  hl("Visual", { bg = p.visual })
  hl("Search", { fg = p.ink, bg = p.visual, bold = true })
  hl("IncSearch", { fg = p.bg, bg = p.ink, bold = true })
  hl("CurSearch", { link = "IncSearch" })
  hl("MatchParen", { fg = p.ink, bg = p.visual, bold = true })
  hl("Pmenu", { fg = p.fg, bg = p.cursorline })
  hl("PmenuSel", { fg = p.ink, bg = p.visual, bold = true })
  hl("PmenuSbar", { bg = p.cursorline })
  hl("PmenuThumb", { bg = p.linenr })
  hl("Folded", { fg = p.comment, bg = p.cursorline })
  hl("Title", { fg = p.ink, bold = true })
  hl("Directory", { fg = p.ink, bold = true })
  hl("Question", { fg = p.ink, bold = true })
  hl("MoreMsg", { fg = p.ink, bold = true })
  hl("ModeMsg", { fg = p.ink, bold = true })
  hl("ErrorMsg", { fg = p.ink, bold = true, underline = true })
  hl("WarningMsg", { fg = p.dark, bold = true })
  hl("QuickFixLine", { bg = p.visual })
  hl("SpellBad", { undercurl = true, sp = p.mid })
  hl("SpellCap", { undercurl = true, sp = p.linenr })
  hl("Conceal", { fg = p.comment })
  hl("DiffAdd", { bg = "#E3E6DC" })
  hl("DiffChange", { bg = p.cursorline })
  hl("DiffDelete", { fg = p.linenr, bg = "#EBE3E0" })
  hl("DiffText", { bg = p.visual, bold = true })

  -- codice: tutto grigio scuro, keyword in grassetto
  hl("Comment", { fg = p.comment })
  hl("Constant", { fg = p.dark })
  hl("String", { fg = p.mid })
  hl("Character", { link = "String" })
  hl("Number", { fg = p.mid })
  hl("Boolean", { fg = p.dark, bold = true })
  hl("Float", { link = "Number" })
  hl("Identifier", { fg = p.fg })
  hl("Function", { fg = p.ink })
  hl("Statement", { fg = p.ink, bold = true })
  hl("Keyword", { fg = p.ink, bold = true })
  hl("Conditional", { link = "Keyword" })
  hl("Repeat", { link = "Keyword" })
  hl("Exception", { link = "Keyword" })
  hl("Label", { link = "Keyword" })
  hl("Operator", { fg = p.dark })
  hl("PreProc", { fg = p.dark, bold = true })
  hl("Include", { link = "PreProc" })
  hl("Type", { fg = p.dark })
  hl("StorageClass", { link = "Keyword" })
  hl("Special", { fg = p.dark })
  hl("Delimiter", { fg = p.mid })
  hl("Underlined", { fg = p.fg, underline = true })
  hl("Error", { fg = p.ink, bold = true, undercurl = true, sp = p.ink })
  hl("Todo", { fg = p.ink, bg = p.visual, bold = true })

  -- treesitter
  hl("@variable", { fg = p.fg })
  hl("@variable.builtin", { fg = p.dark })
  hl("@variable.parameter", { fg = p.fg })
  hl("@variable.member", { fg = p.fg })
  hl("@property", { fg = p.fg })
  hl("@constant", { link = "Constant" })
  hl("@constant.builtin", { fg = p.dark, bold = true })
  hl("@string", { link = "String" })
  hl("@string.escape", { fg = p.dark })
  hl("@number", { link = "Number" })
  hl("@function", { link = "Function" })
  hl("@function.call", { link = "Function" })
  hl("@function.builtin", { link = "Function" })
  hl("@function.method", { link = "Function" })
  hl("@function.method.call", { link = "Function" })
  hl("@constructor", { fg = p.ink })
  hl("@keyword", { link = "Keyword" })
  hl("@keyword.function", { link = "Keyword" })
  hl("@keyword.return", { link = "Keyword" })
  hl("@keyword.operator", { link = "Keyword" })
  hl("@type", { link = "Type" })
  hl("@type.builtin", { link = "Type" })
  hl("@module", { fg = p.dark })
  hl("@operator", { link = "Operator" })
  hl("@punctuation.bracket", { fg = p.mid })
  hl("@punctuation.delimiter", { fg = p.mid })
  hl("@punctuation.special", { fg = p.mid })
  hl("@comment", { link = "Comment" })
  hl("@tag", { fg = p.ink, bold = true })
  hl("@tag.attribute", { fg = p.dark })
  hl("@tag.delimiter", { fg = p.mid })
  hl("@markup.heading", { fg = p.ink, bold = true })
  hl("@markup.link", { fg = p.dark, underline = true })
  hl("@markup.raw", { fg = p.mid, bg = p.cursorline })
  hl("@markup.strong", { bold = true })
  hl("@markup.italic", { italic = true })

  -- diagnostica LSP: grigi tenui
  hl("DiagnosticError", { fg = p.ink })
  hl("DiagnosticWarn", { fg = p.mid })
  hl("DiagnosticInfo", { fg = p.comment })
  hl("DiagnosticHint", { fg = p.linenr })
  hl("DiagnosticOk", { fg = p.comment })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.mid })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.comment })
  hl("DiagnosticUnderlineInfo", { underline = true, sp = p.linenr })
  hl("DiagnosticUnderlineHint", { underline = true, sp = p.linenr })
  hl("DiagnosticVirtualTextError", { fg = p.comment })
  hl("DiagnosticVirtualTextWarn", { fg = p.comment })
  hl("DiagnosticVirtualTextInfo", { fg = p.linenr })
  hl("DiagnosticVirtualTextHint", { fg = p.linenr })
  hl("LspReferenceText", { bg = p.cursorline })
  hl("LspReferenceRead", { bg = p.cursorline })
  hl("LspReferenceWrite", { bg = p.visual })
  hl("Added", { fg = p.dark })
  hl("Changed", { fg = p.mid })
  hl("Removed", { fg = p.comment })

  -- neo-tree
  hl("NeoTreeNormal", { fg = p.fg, bg = p.bg })
  hl("NeoTreeNormalNC", { fg = p.fg, bg = p.bg })
  hl("NeoTreeEndOfBuffer", { fg = p.bg, bg = p.bg })
  hl("NeoTreeWinSeparator", { fg = p.border, bg = p.bg })
  hl("NeoTreeRootName", { fg = p.ink, bold = true })
  hl("NeoTreeDirectoryName", { fg = p.ink })
  hl("NeoTreeDirectoryIcon", { fg = p.dark })
  hl("NeoTreeFileName", { fg = p.fg })
  hl("NeoTreeFileIcon", { fg = p.mid })
  hl("NeoTreeExpander", { fg = p.linenr })
  hl("NeoTreeDotfile", { fg = p.comment })
  hl("NeoTreeCursorLine", { bg = p.cursorline })
  hl("NeoTreeGitModified", { fg = p.ink, bold = true })
  hl("NeoTreeGitUntracked", { fg = p.ink, underline = true })
  hl("NeoTreeModified", { fg = p.ink })
  hl("NeoTreeTabActive", { fg = p.ink, bg = p.bg, bold = true })
  hl("NeoTreeTabInactive", { fg = p.comment, bg = p.bg })
  hl("NeoTreeTabSeparatorActive", { fg = p.bg, bg = p.bg })
  hl("NeoTreeTabSeparatorInactive", { fg = p.bg, bg = p.bg })
  hl("NeoTreeFloatBorder", { fg = p.linenr, bg = p.bg })

  -- which-key
  hl("WhichKey", { fg = p.ink, bold = true })
  hl("WhichKeyGroup", { fg = p.dark })
  hl("WhichKeyDesc", { fg = p.fg })
  hl("WhichKeySeparator", { fg = p.linenr })
  hl("WhichKeyNormal", { bg = p.bg })
  hl("WhichKeyBorder", { fg = p.linenr, bg = p.bg })

  -- menu di completamento (blink.cmp)
  hl("BlinkCmpMenu", { link = "Pmenu" })
  hl("BlinkCmpMenuBorder", { fg = p.linenr, bg = p.cursorline })
  hl("BlinkCmpMenuSelection", { link = "PmenuSel" })
  hl("BlinkCmpLabelMatch", { fg = p.ink, bold = true })
  hl("BlinkCmpKind", { fg = p.comment })

  -- icone dei file in grigio
  for _, g in ipairs(vim.fn.getcompletion("DevIcon", "highlight")) do hl(g, { fg = p.mid }) end

  -- terminale integrato
  local term = { p.ink, p.dark, p.dark, p.mid, p.dark, p.mid, p.mid, p.visual,
    p.comment, p.ink, p.ink, p.dark, p.ink, p.dark, p.dark, p.bg }
  for i, c in ipairs(term) do vim.g["terminal_color_" .. (i - 1)] = c end
end

return M
