-- Schermata iniziale con la nuvola: compare quando apri nvim senza un file
-- (anche con `nvim .`) e sparisce appena apri qualcosa.
-- Tre blocchi, ciascuno centrato per conto suo: nuvola, titolo, comandi.

-- La nuvola è calcolata come il "donut" in ASCII: tante sfere illuminate dall'alto a sinistra;
-- la luminosità di ogni punto sceglie il carattere (dal più leggero al più denso).
-- Viene ridisegnata alla grandezza della finestra: più è grande, più è dettagliata.
local RAMP = [[.',:";~-+/=*#%@]]
local SPHERES = {            -- { x, y, raggio }  in unità astratte: larga ~38, alta ~16
  -- base lunga e bassa
  { -15, 2.3, 3 }, { -10, 3.2, 4.2 }, { -4, 3.8, 4.8 }, { 2.5, 3.6, 4.6 }, { 8.5, 3.2, 4.2 },
  { 13.5, 2.5, 3.4 }, { 17, 1.8, 2.3 },
  -- corpo
  { -8, 7.5, 4 }, { -2, 8.5, 4.6 }, { 4.5, 7, 3.8 }, { 10, 5.8, 3 },
  -- torre spostata a sinistra
  { -9.5, 10, 2.2 }, { -5.5, 11.5, 3.2 }, { -0.5, 12.5, 2.9 },
}
local W, H = 38, 16
-- colori di tokyonight, dall'ombra alla luce: grigio-blu → blu → viola → azzurro → bianco
local cloud_colors = { "#565f89", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" }
local LX, LY, LZ = -0.45, 0.72, 0.53      -- direzione della luce

local cache = {}
local function make_cloud(k)              -- k = righe per unità
  if cache[k] then return cache[k] end
  local rows, nrows, ncols = {}, math.floor(H * k), math.floor(W * 2 * k)
  for yi = 0, nrows - 1 do
    local y = (nrows - yi - 0.5) / k
    local line = {}
    for xi = 0, ncols - 1 do
      local x = -W / 2 + (xi + 0.5) / (2 * k)
      local best, lum
      for _, sp in ipairs(SPHERES) do
        local dx, dy = x - sp[1], y - sp[2]
        local d2 = sp[3] * sp[3] - dx * dx - dy * dy
        if d2 > 0 then
          local z = math.sqrt(d2)
          if not best or z > best then
            best, lum = z, (dx * LX + dy * LY + z * LZ) / sp[3]
          end
        end
      end
      if best then
        local i = math.floor(math.max(0, math.min(0.999, (lum + 0.25) / 1.25)) * #RAMP) + 1
        line[#line + 1] = RAMP:sub(i, i)
      else
        line[#line + 1] = " "
      end
    end
    rows[#rows + 1] = (table.concat(line):gsub("%s+$", ""))
  end
  while rows[1] == "" do table.remove(rows, 1) end
  cache[k] = rows
  return rows
end

-- titolo (disegno scelto dall'autore), colorato con la palette tokyonight
local title = {
  [[                   ▄▀▀▄                 ]],
  [[                   ▌■▀▐▌                ]],
  [[▀▓▄▄   ▄▄▄  ▄▓     ▀■▓▀ ▀▓▄▄░▄▓█▄▄   ▄▄▄]],
  [[ ▓▓█▀ ▀▓▓▌ ▓▓▀   ▓  ▄▄▓▀ ▓▓█▀ ▀▓▓█▀ ▀▓▓▌]],
  [[▐▒▒   ▐▒▒ ▐▒▌   ▐▓▌ ▐▓▓ ▐▒▒   ▐▒▒   ▐▒▒ ]],
  [[░░▌   ░░▌  █░▄ ▄▒▒   ▒▒▌░░▌   ░░▌   ░░▌ ]],
  [[██   ▀░█    ▀░█░▀   ▐░░ █░   ▀██   ▀██  ]],
  [[  ▀    ░▀     ▀     ██▀   ▀     ▀     ▀ ]],
  [[                    ▀▄                  ]],
}
-- le parti sfumate (░ ▒ ▓) diventano puntini veri: kitty le disegnerebbe come macchie uniformi
for i, l in ipairs(title) do
  title[i] = l:gsub("░", "⠡"):gsub("▒", "⢕"):gsub("▓", "⣿")
end
-- sfumatura dall'alto in basso: azzurro → blu → viola (colori di tokyonight)
local title_colors = { "#7dcfff", "#7dcfff", "#7dcfff", "#7aa2f7", "#7aa2f7", "#7aa2f7", "#bb9af7", "#bb9af7", "#bb9af7" }
local hints = {
  "Spazio e    explorer         Spazio ff   apri file",
  "Spazio fn   nuovo file       Spazio /    cerca",
  "Spazio ft   terminale        Spazio qq   esci",
}

local ns = vim.api.nvim_create_namespace("intro")

local function block_width(lines)
  local m = 0
  for _, l in ipairs(lines) do m = math.max(m, vim.fn.strdisplaywidth(l)) end
  return m
end

local function render(buf, win)
  if not (vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_win_is_valid(win)) then return end
  local w, h = vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win)
  local T, Hn = { title, "IntroTitle", rows = true }, { hints, "Comment" }
  if w < block_width(hints) then Hn = nil end

  -- la nuvola prende tutto lo spazio che resta (entro certi limiti); se è poco, si omette
  local blocks = { T, Hn }
  local rest = #title + (Hn and #hints + 1 or 0) + 4
  local k = math.min((w - 4) / (W * 2), (h - rest) / H, 0.9)     -- 0.9 = grandezza massima
  if k >= 0.55 then
    blocks = { { make_cloud(math.floor(k * 20) / 20), "Normal", shade = true }, T, Hn }
  end

  local list = {}
  for _, b in pairs(blocks) do list[#list + 1] = b end
  table.sort(list, function(a, b) return (a.shade and 0 or a == T and 1 or 2) < (b.shade and 0 or b == T and 1 or 2) end)
  local total = #list - 1            -- una riga vuota tra i blocchi
  for _, b in ipairs(list) do total = total + #b[1] end
  local out, marks = {}, {}
  for _ = 1, math.max(0, math.floor((h - total) / 2)) do out[#out + 1] = "" end
  for i, b in ipairs(list) do
    local pad = string.rep(" ", math.max(0, math.floor((w - block_width(b[1])) / 2)))
    for n, l in ipairs(b[1]) do
      out[#out + 1] = pad .. l
      marks[#marks + 1] = { #out - 1, b.rows and ("IntroTitle" .. n) or b[2], b.shade, #pad }
    end
    if i < #list then out[#out + 1] = "" end
  end

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
  vim.bo[buf].modifiable = false
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  for _, m in ipairs(marks) do
    local row, hl, shade, pad = m[1], m[2], m[3], m[4]
    local line = out[row + 1]
    if not shade then
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, { end_col = #line, hl_group = hl })
    else               -- parti in ombra azzurre, parti in luce bianche, come nel wallpaper
      local start, group
      for col = pad, #line do
        local ch = line:sub(col + 1, col + 1)
        local lvl = ch ~= "" and ch ~= " " and RAMP:find(ch, 1, true)
        local g = lvl and ("IntroCloud" .. math.ceil(lvl / 3)) or nil      -- 15 caratteri → 5 colori
        if g ~= group then
          if group then
            vim.api.nvim_buf_set_extmark(buf, ns, row, start, { end_col = col, hl_group = group })
          end
          start, group = col, g
        end
      end
    end
  end
end

local function open()
  -- solo se nvim è partito senza file (o con una cartella)
  if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 0 then return end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local b = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(b)
    local is_dir = name ~= "" and vim.fn.isdirectory(name) == 1
    if vim.bo[b].buftype == "" and (name == "" or is_dir)
      and not vim.bo[b].modified and vim.api.nvim_buf_line_count(b) == 1 then
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].bufhidden = "wipe"
      vim.bo[buf].filetype = "intro"
      vim.api.nvim_win_set_buf(win, buf)
      if is_dir then pcall(vim.api.nvim_buf_delete, b, { force = true }) end   -- il buffer vuoto della cartella
      vim.wo[win][0].cursorline = false
      vim.wo[win][0].statuscolumn = ""
      local m = require("mono").palettes[vim.g.colors_name]   -- temi a un colore: sfumature della loro tinta
      if m then
        cloud_colors = m.cloud or { m.g1, m.g2, m.g3, m.g4, m.white }
        title_colors = { m.white, m.white, m.white, m.fg, m.fg, m.g4, m.g3, m.g2, m.g1 }
      end
      for n, color in ipairs(title_colors) do
        vim.api.nvim_set_hl(0, "IntroTitle" .. n, { fg = color })
      end
      for n, color in ipairs(cloud_colors) do
        vim.api.nvim_set_hl(0, "IntroCloud" .. n, { fg = color })
      end
      render(buf, win)
      vim.api.nvim_create_autocmd({ "WinResized", "VimResized" }, {
        callback = function()
          if not vim.api.nvim_buf_is_valid(buf) then return true end
          local w = vim.fn.bufwinid(buf)
          if w ~= -1 then render(buf, w) end
        end,
      })
      -- i / a / o iniziano un file nuovo
      for _, key in ipairs({ "i", "a", "o" }) do
        vim.keymap.set("n", key, "<cmd>enew<cr><cmd>startinsert<cr>", { buffer = buf })
      end
      return
    end
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function() vim.defer_fn(open, 60) end,
})
