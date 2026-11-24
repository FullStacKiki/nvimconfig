-- Snippet LaTeX: scrivi la parola e premi Tab. Tab salta al campo successivo, Shift+Tab torna indietro.
-- Quelli marcati "math" funzionano solo dentro $…$, \[…\], align…; fuori resta la parola com'è.
local ls = require("luasnip")
local s, i, t, f = ls.snippet, ls.insert_node, ls.text_node, ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local function math() return vim.fn["vimtex#syntax#in_mathzone"]() == 1 end
local function text() return not math() end
local function env(trig, name, desc)
  return s({ trig = trig, desc = desc }, fmta("\\begin{" .. name .. "}\n  <>\n\\end{" .. name .. "}", { i(0) }),
    { condition = text })
end
local function env_title(trig, name, desc)    -- con titolo facoltativo tra [ ]
  return s({ trig = trig, desc = desc },
    fmta("\\begin{" .. name .. "}<>\n  <>\n\\end{" .. name .. "}", {
      ls.choice_node(1, { t(""), ls.snippet_node(nil, { t("["), i(1, "titolo"), t("]") }) }), i(0) }),
    { condition = text })
end
local function m(trig, body, nodes, desc)     -- snippet solo in modalità matematica
  return s({ trig = trig, desc = desc, wordTrig = false }, fmta(body, nodes or {}), { condition = math })
end

return {
  -- struttura
  s({ trig = "sec", desc = "\\section" }, fmta("\\section{<>}\n\n<>", { i(1), i(0) }), { condition = text }),
  s({ trig = "ssec", desc = "\\subsection" }, fmta("\\subsection{<>}\n\n<>", { i(1), i(0) }), { condition = text }),
  s({ trig = "beg", desc = "ambiente qualsiasi" }, fmta("\\begin{<>}\n  <>\n\\end{<>}", { i(1), i(0), rep(1) }), { condition = text }),
  s({ trig = "item", desc = "elenco puntato" }, fmta("\\begin{itemize}\n  \\item <>\n\\end{itemize}", { i(0) }), { condition = text }),
  s({ trig = "enum", desc = "elenco numerato" }, fmta("\\begin{enumerate}\n  \\item <>\n\\end{enumerate}", { i(0) }), { condition = text }),
  s({ trig = "bf", desc = "grassetto" }, fmta("\\textbf{<>}", { i(1) }), { condition = text }),
  s({ trig = "it", desc = "corsivo" }, fmta("\\emph{<>}", { i(1) }), { condition = text }),
  s({ trig = "todo", desc = "da ripassare" }, fmta("\\todo{<>}", { i(1) }), { condition = text }),

  -- teoremi & co. (Tab sul primo campo sceglie se mettere il titolo)
  env_title("thm", "theorem", "teorema"),
  env_title("lem", "lemma", "lemma"),
  env_title("cor", "corollary", "corollario"),
  env_title("prop", "proposition", "proposizione"),
  env_title("def", "definition", "definizione"),
  env_title("ex", "example", "esempio"),
  env_title("exe", "exercise", "esercizio"),
  env("rem", "remark", "osservazione"),
  env("prf", "proof", "dimostrazione"),
  env("sol", "solution", "soluzione"),
  env("scr", "scratch", "brutta copia"),

  -- entrare in matematica
  s({ trig = "mk", desc = "$…$" }, fmta("$<>$<>", { i(1), i(0) }), { condition = text }),
  s({ trig = "dm", desc = "\\[ … \\]" }, fmta("\\[\n  <>\n\\]\n<>", { i(1), i(0) }), { condition = text }),
  s({ trig = "ali", desc = "align*" }, fmta("\\begin{align*}\n  <>\n\\end{align*}", { i(0) }), { condition = text }),
  s({ trig = "cases", desc = "funzione a tratti" }, fmta("\\begin{cases}\n  <> & <> \\\\\n  <> & <>\n\\end{cases}", { i(1), i(2), i(3), i(4) }), { condition = math }),

  -- dentro la matematica
  m("ff", "\\frac{<>}{<>}", { i(1), i(2) }, "frazione"),
  m("sq", "\\sqrt{<>}", { i(1) }, "radice"),
  m("sr", "^2", nil, "al quadrato"),
  m("td", "^{<>}", { i(1) }, "esponente"),
  m("__", "_{<>}", { i(1) }, "pedice"),
  m("sum", "\\sum_{<>}^{<>} ", { i(1, "i=1"), i(2, "n") }, "sommatoria"),
  m("prod", "\\prod_{<>}^{<>} ", { i(1, "i=1"), i(2, "n") }, "produttoria"),
  m("int", "\\int_{<>}^{<>} <> \\dd <>", { i(1), i(2), i(3), i(4, "x") }, "integrale"),
  m("lim", "\\lim_{<> \\to <>} ", { i(1, "n"), i(2, "\\infty") }, "limite"),
  m("set", "\\set{<>}", { i(1) }, "insieme { }"),
  m("abs", "\\abs{<>}", { i(1) }, "valore assoluto"),
  m("ooo", "\\infty", nil, "infinito"),
  m("<=>", "\\iff ", nil, "se e solo se"),   -- prima di => e <=, che sono suoi pezzi
  m("->", "\\to ", nil, "freccia"),
  m("=>", "\\implies ", nil, "implica"),
  m("!=", "\\neq ", nil, "diverso"),
  m("<=", "\\leq ", nil, "minore o uguale"),
  m(">=", "\\geq ", nil, "maggiore o uguale"),
  m("inn", "\\in ", nil, "appartiene"),
  m("notin", "\\notin ", nil, "non appartiene"),
  m("sub", "\\subseteq ", nil, "sottoinsieme"),
  m("cup", "\\cup ", nil, "unione"),
  m("cap", "\\cap ", nil, "intersezione"),
  m("AA", "\\forall ", nil, "per ogni"),
  m("EE", "\\exists ", nil, "esiste"),
  m("RR", "\\R", nil, "reali"), m("NN", "\\N", nil, "naturali"), m("ZZ", "\\Z", nil, "interi"),
  m("QQ", "\\Q", nil, "razionali"), m("CC", "\\C", nil, "complessi"),
  m("...", "\\dots ", nil, "puntini"),
  m("xx", "\\times ", nil, "per"),
  m("**", "\\cdot ", nil, "punto"),
  m("bar", "\\overline{<>}", { i(1) }, "barra sopra"),
  m("hat", "\\hat{<>}", { i(1) }, "cappello"),
  m("lr(", "\\left( <> \\right)", { i(1) }, "parentesi che si adattano"),
  m("mod", "\\pmod{<>}", { i(1) }, "modulo"),
}
