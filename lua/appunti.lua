-- "Nuovo appunto": chiede materia, titolo e modello, crea il file da
-- ~/Appunti/_preset/modelli e lo apre. Non sovrascrive mai: se il nome
-- esiste già aggiunge -2, -3…
local M = {}
local APPUNTI = vim.fn.expand("~/Appunti")
local MODELLI = APPUNTI .. "/_preset/modelli"
local AUTORE = "Alessandro Ravanelli"

local function slug(s)
  s = s:lower():gsub("[àáâä]", "a"):gsub("[èéêë]", "e"):gsub("[ìíîï]", "i"):gsub("[òóôö]", "o"):gsub("[ùúûü]", "u")
  return (s:gsub("[^%w]+", "-"):gsub("^-+", ""):gsub("-+$", ""))
end

local function materie()
  local out = {}
  for name, kind in vim.fs.dir(APPUNTI) do
    if kind == "directory" and not name:match("^[_.]") then out[#out + 1] = name end
  end
  table.sort(out)
  out[#out + 1] = "+ nuova materia…"
  return out
end

local function crea(materia, titolo, modello)
  local dir = APPUNTI .. "/" .. materia
  vim.fn.mkdir(dir, "p")
  local base = os.date("%Y-%m-%d") .. "-" .. slug(titolo)
  local path, n = dir .. "/" .. base .. ".tex", 2
  while vim.uv.fs_stat(path) do
    path = dir .. "/" .. base .. "-" .. n .. ".tex"
    n = n + 1
  end
  local lines = vim.fn.readfile(MODELLI .. "/" .. modello .. ".tex")
  -- caratteri speciali di LaTeX nel titolo (% & # _ $) → \% \& …; poi %% per gsub
  local titolo_tex = titolo:gsub("([%%&#_%$])", "\\%1"):gsub("%%", "%%%%")
  local row, col = 1, 0
  for i, l in ipairs(lines) do
    l = l:gsub("{{TITOLO}}", titolo_tex):gsub("{{AUTORE}}", AUTORE):gsub("{{DATA}}", "\\today")
    local c = l:find("{{CURSORE}}", 1, true)
    if c then row, col = i, c - 1; l = l:gsub("{{CURSORE}}", "") end
    lines[i] = l
  end
  vim.fn.writefile(lines, path)
  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.api.nvim_win_set_cursor(0, { row, col })
  vim.cmd.startinsert()
end

function M.nuovo()
  vim.ui.select(materie(), { prompt = "Materia" }, function(materia)
    if not materia then return end
    local function avanti(m)
      vim.ui.input({ prompt = "Titolo: " }, function(titolo)
        if not titolo or titolo == "" then return end
        local modelli = {}
        for name in vim.fs.dir(MODELLI) do
          if name:match("%.tex$") then modelli[#modelli + 1] = name:gsub("%.tex$", "") end
        end
        table.sort(modelli)
        vim.ui.select(modelli, { prompt = "Modello" }, function(modello)
          if modello then crea(m, titolo, modello) end
        end)
      end)
    end
    if materia == "+ nuova materia…" then
      vim.ui.input({ prompt = "Nome materia: " }, function(m)
        if m and m ~= "" then avanti(m) end
      end)
    else
      avanti(materia)
    end
  end)
end

return M
