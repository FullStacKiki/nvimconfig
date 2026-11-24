-- Completamento automatico (come in LazyVim): menu mentre scrivi.
-- Invio accetta, Ctrl-n/Ctrl-p si muove, Ctrl-e chiude. Tab resta agli snippet (LuaSnip).
-- Fonti: parole del file, percorsi, snippet (niente LSP in questa config).
return {
  { "saghen/blink.cmp", version = "1.*", event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      keymap = { preset = "enter", ["<Tab>"] = {}, ["<S-Tab>"] = {} },
      snippets = { preset = "luasnip" },
      sources = { default = { "path", "snippets", "buffer" } },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { border = "rounded" },
      },
      cmdline = { enabled = true },
      signature = { enabled = true },
    } },
}
