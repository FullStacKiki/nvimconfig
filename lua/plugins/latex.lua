-- Appunti in LaTeX: vimtex compila in continuo, Skim mostra il PDF a destra.
-- Cartella appunti: ~/Appunti (preambolo e modelli in ~/Appunti/_preset).
local APPUNTI = vim.fn.expand("~/Appunti")

return {
  { "lervag/vimtex", lazy = false,   -- vimtex va caricato subito (lo dice la sua guida)
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1          -- il PDF segue il cursore dopo ogni compilazione
      vim.g.vimtex_view_skim_activate = 0      -- il focus resta su nvim
      vim.g.vimtex_view_skim_reading_bar = 1   -- evidenzia la riga corrispondente nel PDF
      vim.g.vimtex_compiler_latexmk = {
        aux_dir = ".aux",
        options = { "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode" },
      }
      vim.g.vimtex_quickfix_open_on_warning = 0   -- la lista si apre solo per gli errori veri
      vim.g.vimtex_quickfix_mode = 2              -- …e senza rubare il cursore
      vim.g.vimtex_syntax_conceal_disable = 1
      vim.g.vimtex_mappings_disable = { n = { "K" } }
    end,
    config = function()
      local group = vim.api.nvim_create_augroup("appunti_latex", { clear = true })

      -- negli appunti la compilazione parte da sola all'apertura
      vim.api.nvim_create_autocmd("User", {
        group = group, pattern = "VimtexEventInitPost",
        callback = function()
          local file = vim.api.nvim_buf_get_name(0)
          -- i modelli in _preset non si compilano (hanno solo segnaposto)
          if vim.startswith(file, APPUNTI .. "/") and not file:find("/_preset/", 1, true) then
            vim.cmd("VimtexCompile")
          end
        end,
      })

      -- AeroSpace: niente spostamenti a mano (litigherebbero col tiling).
      -- Si porta Skim nello stesso workspace di kitty, AeroSpace lo mette a destra.
      local function aerospace(args)
        local r = vim.system(vim.list_extend({ "aerospace" }, args), { text = true }):wait()
        return r.code == 0 and r.stdout or ""
      end
      local function tile_with_aerospace(me, first)
        local my_id, ws = me:match("^(%d+)|(.-)%s*$")
        if not ws then return end
        local moved = false
        for line in aerospace({ "list-windows", "--all", "--format", "%{window-id}|%{app-name}|%{workspace}" }):gmatch("[^\n]+") do
          local id, app, w = line:match("^(%d+)%s*|%s*(.-)%s*|%s*(.-)%s*$")
          if app == "Skim" and w ~= ws then
            aerospace({ "move-node-to-workspace", "--window-id", id, ws })
            moved = true
          end
        end
        if moved or first then aerospace({ "balance-sizes", "--workspace", ws }) end
        aerospace({ "focus", "--window-id", my_id })
      end

      -- una sola preview: Skim chiude i PDF degli altri appunti
      local KEEP_ONE = [[function run(argv) { const s = Application("Skim");
        s.documents().forEach(d => { try { if (d.file().toString() !== argv[0]) d.close() } catch (e) {} }) }]]

      local placed = false
      vim.api.nvim_create_autocmd("User", {
        group = group, pattern = "VimtexEventView",
        callback = function()
          local pdf = vim.fn.fnamemodify(vim.fn.eval("b:vimtex.tex"), ":r") .. ".pdf"
          vim.system({ "osascript", "-l", "JavaScript", "-e", KEEP_ONE, pdf })
          local first = not placed
          placed = true
          if vim.fn.executable("aerospace") == 1 then
            local me = aerospace({ "list-windows", "--focused", "--format", "%{window-id}|%{workspace}" })
            vim.defer_fn(function() tile_with_aerospace(me, first) end, 800)
            return
          end
          -- senza AeroSpace, solo la prima volta: Skim a destra, kitty a sinistra
          if not first then return end
          vim.defer_fn(function()
            vim.system({ "osascript", "-l", "JavaScript", vim.fn.stdpath("config") .. "/scripts/affianca.js" },
              { text = true }, function(r)
                if r.code ~= 0 or vim.trim(r.stdout or "") == "kitty-no" then
                  vim.schedule(function()
                    vim.notify("Skim è a destra; per spostare anche kitty a sinistra serve il permesso "
                      .. "Accessibilità a kitty (Impostazioni di Sistema → Privacy e sicurezza).", vim.log.levels.INFO)
                  end)
                end
              end)
          end, 700)
        end,
      })

      -- testo che va a capo da solo, come in un quaderno
      vim.api.nvim_create_autocmd("FileType", {
        group = group, pattern = "tex",
        callback = function()
          vim.opt_local.wrap = true
          vim.opt_local.linebreak = true
          vim.opt_local.breakindent = true
        end,
      })

      local function cmd(c) return function() vim.cmd(c) end end
      vim.keymap.set("n", "<leader>nv", cmd("VimtexView"), { desc = "Mostra il PDF (Skim)" })
      vim.keymap.set("n", "<leader>nc", cmd("VimtexCompile"), { desc = "Compilazione continua sì/no" })
      vim.keymap.set("n", "<leader>ne", cmd("VimtexErrors"), { desc = "Errori LaTeX" })
      vim.keymap.set("n", "<leader>nx", cmd("VimtexClean"), { desc = "Pulisci file temporanei" })
      vim.keymap.set("n", "<leader>nt", cmd("VimtexTocToggle"), { desc = "Indice dell'appunto" })
      vim.keymap.set("n", "<leader>nn", function() require("appunti").nuovo() end, { desc = "Nuovo appunto" })
      vim.keymap.set("n", "<leader>no", function()
        vim.cmd("Neotree reveal left dir=" .. vim.fn.fnameescape(APPUNTI))
      end, { desc = "Apri la cartella Appunti" })
    end },

  -- snippet: si espandono solo premendo Tab (nessun completamento automatico)
  { "L3MON4D3/LuaSnip", event = "InsertEnter",
    config = function()
      local ls = require("luasnip")
      ls.config.set_config({ enable_autosnippets = false, update_events = "TextChanged,TextChangedI" })
      require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
      vim.keymap.set({ "i", "s" }, "<Tab>", function()
        if ls.expand_or_jumpable() then return "<Plug>luasnip-expand-or-jump" end
        return "<Tab>"
      end, { expr = true, silent = true, desc = "Espandi snippet / salta al campo dopo" })
      vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
        if ls.jumpable(-1) then return "<Plug>luasnip-jump-prev" end
        return "<S-Tab>"
      end, { expr = true, silent = true })
    end },
}
