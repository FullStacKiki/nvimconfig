return {
  { "folke/tokyonight.nvim", lazy = false, priority = 1000,
    opts = {
      style = "storm",
      -- stile "disegnato a mano": corsivo calligrafico (Maple Mono) dove ha senso
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
      },
      on_highlights = function(hl, c)
        hl.EndOfBuffer = { fg = c.fg_gutter }             -- le ~ restano visibili
        hl.WinSeparator = { fg = c.fg_gutter }            -- tratteggio visibile tra le finestre
        -- explorer: stesso fondo dell'editor, cartelle blu, file nascosti in corsivo spento
        hl.NeoTreeNormal = { fg = c.fg, bg = c.bg }
        hl.NeoTreeNormalNC = { fg = c.fg, bg = c.bg }
        hl.NeoTreeEndOfBuffer = { fg = c.bg, bg = c.bg }
        hl.NeoTreeWinSeparator = { fg = c.fg_gutter, bg = c.bg }
        hl.NeoTreeRootName = { fg = c.blue, bold = true }
        hl.NeoTreeDirectoryName = { fg = c.blue }
        hl.NeoTreeDirectoryIcon = { fg = c.blue }
        hl.NeoTreeExpander = { fg = c.fg_gutter }
        hl.NeoTreeDotfile = { fg = c.comment, italic = true }
        hl.NeoTreeCursorLine = { bg = c.bg_highlight }
        hl.NeoTreeGitModified = { fg = c.yellow, bold = true }
        hl.NeoTreeGitUntracked = { fg = c.green, bold = true }
        hl.NeoTreeTabActive = { fg = c.fg, bg = c.bg, bold = true }
        hl.NeoTreeTabInactive = { fg = c.comment, bg = c.bg }
        hl.NeoTreeTabSeparatorActive = { fg = c.bg, bg = c.bg }
        hl.NeoTreeTabSeparatorInactive = { fg = c.bg, bg = c.bg }
        hl.FloatBorder = { fg = c.blue, bg = c.bg_float }
        hl.String = { fg = c.green, italic = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      require("theme").startup()   -- l'ultimo tema scelto con Spazio uc (di base tokyonight-storm)
    end },

  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x", lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "nvim-tree/nvim-web-devicons" },
    opts = {
      close_if_last_window = true,
      window = { position = "left", width = 32 },
      -- titolo "Explorer" in cima
      source_selector = {
        winbar = true,
        content_layout = "center",
        sources = { { source = "filesystem", display_name = "Explorer" } },
      },
      default_component_configs = {
        -- niente guide: solo le freccette accanto alle cartelle
        indent = { with_markers = false, with_expanders = true,
          expander_collapsed = "›", expander_expanded = "⌄", indent_size = 2 },
        icon = { folder_closed = "", folder_open = "", folder_empty = "" },
        modified = { symbol = "●" },
        -- lo stato git si vede dal colore del nome, senza simboli a destra
        git_status = { symbols = {
          added = "", modified = "", deleted = "", renamed = "",
          untracked = "", ignored = "", unstaged = "", staged = "", conflict = "",
        } },
      },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "disabled",   -- con `nvim .` il tree resta nascosto finché non premi Spazio e
        use_libuv_file_watcher = true,   -- il tree si aggiorna da solo quando cambiano i file su disco
        -- i file nascosti (.git, .gitignore…) si vedono, in corsivo spento
        filtered_items = { hide_dotfiles = false, hide_gitignored = false, never_show = { ".DS_Store" } },
        -- in cima solo il nome della cartella, non tutto il percorso
        components = {
          name = function(config, node, state)
            local r = require("neo-tree.sources.common.components").name(config, node, state)
            if node:get_depth() == 1 then r.text = vim.fn.fnamemodify(node.path, ":t") .. "/" end
            return r
          end,
        },
      },
    } },

  { "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "markdown", "markdown_inline", "bash",
        "c", "cpp", "python", "ocaml", "ocaml_interface",
        "javascript", "typescript", "tsx", "html", "css", "json",
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
      })
    end },

  -- status bar in basso: modo, ramo git, modifiche | tipo di file, posizione, avanzamento
  { "nvim-lualine/lualine.nvim", lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- i colori della barra seguono il tema attivo (si ricalcolano a ogni cambio tema)
      local function palette()
        local m = require("mono").palettes[vim.g.colors_name]   -- mrrobot, phosphor
        if m then
          return { bg = m.bg, bg_dark = m.bg, fg_dark = m.lime and m.g2 or m.g4, blue = m.blue or m.white,
            green = m.fg, magenta = m.violet or m.g4, red = m.rust or m.white, yellow = m.lime or m.white,
            teal = m.cyan or m.g3 }
        end
        local style = (vim.g.colors_name or ""):match("^tokyonight%-(%a+)$") or "storm"
        return require("tokyonight.colors").setup({ style = style })
      end
      local function opts()
      local c = palette()
      local function block(color) return { fg = c.bg_dark, bg = color, gui = "bold" } end
      local plain = { fg = c.fg_dark, bg = c.bg }
      local function mode(color) return { a = block(color), b = { fg = c.blue, bg = c.bg }, c = plain, z = block(color) } end
      return {
        options = {
          theme = {
            normal = mode(c.green), insert = mode(c.blue), visual = mode(c.magenta),
            replace = mode(c.red), command = mode(c.yellow), terminal = mode(c.teal),
            inactive = { a = plain, b = plain, c = plain },
          },
          globalstatus = true,                       -- una sola barra, in fondo
          component_separators = "", section_separators = "",
          disabled_filetypes = { statusline = { "intro" } },   -- barra vuota sulla schermata iniziale
        },
        sections = {
          lualine_a = { { function() return "" end } },
          lualine_b = { { "branch", icon = "" } },
          lualine_c = { { "diff", symbols = { added = " ", modified = " ", removed = " " } } },
          lualine_x = { { "filetype" } },
          lualine_y = { { "location", padding = { left = 1, right = 1 } } },
          lualine_z = { { function()
            local cur, total = vim.fn.line("."), vim.fn.line("$")
            local pos = cur == 1 and "Top" or cur == total and "Bot" or math.floor(cur / total * 100) .. "%%"
            return pos .. "/" .. total
          end } },
        },
      }
      end
      require("lualine").setup(opts())
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function() require("lualine").setup(opts()) end,
      })
    end },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  { "folke/which-key.nvim", event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "codice" },
        { "<leader>n", group = "appunti LaTeX" },
        { "<leader>u", group = "opzioni/tema" },
        { "<leader>f", group = "file/terminale" },
        { "<leader>q", group = "esci" },
        { "<leader>s", group = "cerca" },
        { "<leader>w", group = "finestre" },
        { "<leader><tab>", group = "tab" },
      },
    } },
}
