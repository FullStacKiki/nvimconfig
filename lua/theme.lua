-- Temi: selettore con anteprima (Spazio uc), tema ricordato tra un avvio e l'altro,
-- e kitty allineato al tema (sfondo, colori e — per mrrobot e phosphor — anche il font).
local M = {}
local SAVE = vim.fn.stdpath("state") .. "/colorscheme"
local KITTY = vim.fn.expand("~/.config/kitty/nvim-theme.conf")
local DEFAULT = "tokyonight-storm"
local FAVORITES = { "tokyonight-storm", "tokyonight-night", "tokyonight-moon", "tokyonight-day", "mrrobot", "phosphor" }

-- impostazioni extra di kitty per tema: in kitty_themes.lua, riletto ogni volta
local EXTRA_FILE = vim.fn.stdpath("config") .. "/lua/kitty_themes.lua"
local function kitty_extra(name)
  local ok, t = pcall(dofile, EXTRA_FILE)
  return ok and t[name] or {}
end

local function hex(group, key)
  local v = vim.api.nvim_get_hl(0, { name = group, link = false })[key]
  return v and string.format("#%06x", v) or nil
end

local function sync_kitty(name)
  local lines = { "# Scritto da nvim (Spazio uc) — tema: " .. name, "# Non modificare a mano: viene riscritto a ogni cambio tema." }
  local bg, fg = hex("Normal", "bg"), hex("Normal", "fg")
  if bg then lines[#lines + 1] = "background " .. bg end
  if fg then lines[#lines + 1] = "foreground " .. fg end
  vim.list_extend(lines, kitty_extra(name))
  local old = vim.uv.fs_stat(KITTY) and vim.fn.readfile(KITTY) or {}
  if table.concat(old, "\n") == table.concat(lines, "\n") then return end
  vim.fn.writefile(lines, KITTY)
  -- kitty rilegge la config (font compresi) con SIGUSR1
  if vim.env.KITTY_PID then
    vim.uv.kill(tonumber(vim.env.KITTY_PID), "sigusr1")
  else
    vim.system({ "pkill", "-USR1", "-x", "kitty" })
  end
end

local function devicons(color)
  pcall(function() require("nvim-web-devicons").setup({ color_icons = color }) end)
end

function M.apply(name, save)
  local ok = pcall(vim.cmd.colorscheme, name)
  if not ok then return false end
  local mono = require("mono").palettes[name] ~= nil
  devicons(not mono)
  -- mrrobot/phosphor: cursore a blocco che lampeggia anche dentro nvim; gli altri temi tornano al normale
  vim.o.guicursor = mono and "a:block-blinkwait300-blinkon500-blinkoff500"
    or vim.api.nvim_get_option_info2("guicursor", {}).default
  if save then
    vim.fn.writefile({ name }, SAVE)
    sync_kitty(name)
  end
  return true
end

function M.startup()
  local saved = vim.uv.fs_stat(SAVE) and vim.fn.readfile(SAVE)[1] or DEFAULT
  if not M.apply(saved, false) then M.apply(DEFAULT, false) end
  sync_kitty(vim.g.colors_name)
end

function M.list()
  local out, seen = {}, {}
  for _, n in ipairs(FAVORITES) do out[#out + 1] = n; seen[n] = true end
  for _, n in ipairs(vim.fn.getcompletion("", "color")) do
    if not seen[n] and n ~= "tokyonight" then out[#out + 1] = n; seen[n] = true end
  end
  return out
end

-- finestrella con l'elenco: muovendo il cursore si vede subito il tema,
-- Invio lo tiene (e aggiorna kitty), Esc/q torna a quello di prima
function M.pick()
  local names, original = M.list(), vim.g.colors_name
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {}
  for _, n in ipairs(names) do lines[#lines + 1] = "  " .. n end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  local width = 28
  local height = math.min(#names, vim.o.lines - 6)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor", width = width, height = height, style = "minimal", border = "rounded",
    row = math.floor((vim.o.lines - height) / 2) - 1, col = math.floor((vim.o.columns - width) / 2),
    title = " Tema ", title_pos = "center",
    footer = " Invio tieni · Esc annulla ", footer_pos = "center",
  })
  vim.wo[win].cursorline = true
  for i, n in ipairs(names) do
    if n == original then vim.api.nvim_win_set_cursor(win, { i, 0 }) end
  end
  local done = false
  local function close(keep)
    if done then return end
    done = true
    local choice = names[vim.api.nvim_win_get_cursor(win)[1]]
    pcall(vim.api.nvim_win_close, win, true)
    if keep then M.apply(choice, true) else M.apply(original, false) end
  end
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function() M.apply(names[vim.api.nvim_win_get_cursor(win)[1]], false) end,
  })
  vim.api.nvim_create_autocmd("WinLeave", { buffer = buf, once = true, callback = function() close(false) end })
  local o = { buffer = buf, nowait = true }
  vim.keymap.set("n", "<CR>", function() close(true) end, o)
  for _, k in ipairs({ "<Esc>", "q" }) do vim.keymap.set("n", k, function() close(false) end, o) end
end

return M
