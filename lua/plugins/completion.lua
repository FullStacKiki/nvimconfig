-- Completamento automatico, pensato per scrivere veloce senza essere interrotti:
-- - nessuna voce è selezionata in partenza, quindi Invio va sempre a capo
--   (accetta solo se hai scelto una voce con Ctrl-n/Ctrl-p o le frecce);
-- - il menu compare solo dopo una breve pausa e dopo almeno 3 lettere,
--   così mentre scrivi di fila non lampeggia;
-- - Ctrl-y accetta la prima voce al volo, Ctrl-e chiude. Tab resta agli snippet (LuaSnip).
-- Fonti: parole del file, percorsi, snippet (niente LSP in questa config).
return {
  { "saghen/blink.cmp", version = "1.*", event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "L3MON4D3/LuaSnip" },
    opts = {
      keymap = { preset = "enter", ["<Tab>"] = {}, ["<S-Tab>"] = {},
        ["<C-y>"] = { "select_and_accept", "fallback" } },
      snippets = { preset = "luasnip" },
      sources = {
        default = { "path", "snippets", "buffer" },
        min_keyword_length = 3,
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        menu = { border = "rounded", auto_show_delay_ms = 250 },
        documentation = { auto_show = true, auto_show_delay_ms = 400 },
      },
      cmdline = { enabled = true },
      signature = { enabled = true },
    } },
}
