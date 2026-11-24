-- Formattazione automatica a ogni salvataggio (formattatori esterni, niente LSP).
-- Un formattatore non installato viene semplicemente saltato.
-- Spazio uf la accende/spegne; Spazio cf formatta a mano.
return {
  { "stevearc/conform.nvim", event = "BufWritePre", cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ timeout_ms = 3000 }) end,
        mode = { "n", "v" }, desc = "Formatta" },
      { "<leader>uf", function()
          vim.g.no_autoformat = not vim.g.no_autoformat
          vim.notify("Formattazione al salvataggio: " .. (vim.g.no_autoformat and "spenta" or "accesa"))
        end, desc = "Formattazione al salvataggio sì/no" },
    },
    opts = function()
      local prettier = { "prettier" }
      local clang = vim.fn.executable("clang-format") == 1 and "clang-format"
        or "/opt/homebrew/opt/llvm/bin/clang-format"
      -- ocamlformat arriva da opam: lo trova anche se la shell non ha fatto `eval $(opam env)`
      local ocamlformat = vim.fn.executable("ocamlformat") == 1 and "ocamlformat"
        or vim.fn.expand("~/.opam/default/bin/ocamlformat")
      return {
        formatters_by_ft = {
          c = { "clang-format" }, cpp = { "clang-format" },
          python = { "ruff_format" },
          ocaml = { "ocamlformat" },
          lua = { "stylua" },
          javascript = prettier, javascriptreact = prettier,
          typescript = prettier, typescriptreact = prettier,
          html = prettier, css = prettier, json = prettier, markdown = prettier,
          ["_"] = { "trim_whitespace" },   -- tutti gli altri: toglie solo gli spazi a fine riga
        },
        formatters = {
          ["clang-format"] = { command = clang },
          ocamlformat = { command = ocamlformat },
        },
        notify_no_formatters = false,
        format_on_save = function()
          if vim.g.no_autoformat then return end
          return { timeout_ms = 3000 }
        end,
      }
    end },
}
