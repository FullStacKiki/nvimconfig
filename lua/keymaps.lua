local k = vim.keymap.set

-- Base
k({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Salva" })
k("n", "<Esc>", "<cmd>nohlsearch<cr>")
k("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Esci da tutto" })
k("n", "<leader>fn", "<cmd>enew<cr>", { desc = "Nuovo file" })

-- Finestre
k("n", "<C-h>", "<C-w>h", { desc = "Finestra a sinistra" })
k("n", "<C-j>", "<C-w>j", { desc = "Finestra sotto" })
k("n", "<C-k>", "<C-w>k", { desc = "Finestra sopra" })
k("n", "<C-l>", "<C-w>l", { desc = "Finestra a destra" })
k("n", "<C-Up>", "<cmd>resize +2<cr>")
k("n", "<C-Down>", "<cmd>resize -2<cr>")
k("n", "<C-Left>", "<cmd>vertical resize -2<cr>")
k("n", "<C-Right>", "<cmd>vertical resize +2<cr>")
-- Se il cursore è nell'explorer (o in un'altra finestra speciale) passa prima a una finestra di file
local function to_file_win()
  if vim.bo.buftype == "" then return end
  for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].buftype == "" and vim.api.nvim_win_get_config(w).relative == "" then
      vim.api.nvim_set_current_win(w)
      return
    end
  end
end
k("n", "<leader>-", function() to_file_win() vim.cmd.split() end, { desc = "Split sotto" })
k("n", "<leader>|", function() to_file_win() vim.cmd.vsplit() end, { desc = "Split a destra" })
k("n", "<leader>wd", "<C-w>c", { desc = "Chiudi finestra" })

-- Buffer
local function listed()
  return vim.tbl_filter(function(b) return vim.bo[b].buflisted end, vim.api.nvim_list_bufs())
end

-- Chiude il buffer senza distruggere il layout delle finestre
local function buf_delete(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    local choice = vim.fn.confirm("Salvare le modifiche?", "&Sì\n&No\n&Annulla")
    if choice == 0 or choice == 3 then return end
    if choice == 1 then vim.api.nvim_buf_call(buf, vim.cmd.write) end
  end
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      local alt = vim.fn.bufnr("#")
      if alt > 0 and alt ~= buf and vim.bo[alt].buflisted then
        vim.cmd.buffer(alt)
      else
        vim.cmd.bprevious()
        if vim.api.nvim_get_current_buf() == buf then vim.cmd.enew() end
      end
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then vim.cmd.bdelete({ buf, bang = true }) end
end

-- Elenco dei buffer aperti (sostituisce la tabline)
local function buf_pick()
  local cur = vim.api.nvim_get_current_buf()
  vim.ui.select(listed(), {
    prompt = "Buffer",
    format_item = function(b)
      local name = vim.api.nvim_buf_get_name(b)
      name = name == "" and "[senza nome]" or vim.fn.fnamemodify(name, ":~:.")
      return (b == cur and "● " or "  ") .. name .. (vim.bo[b].modified and " [+]" or "")
    end,
  }, function(b) if b then vim.cmd.buffer(b) end end)
end

k("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer precedente" })
k("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer successivo" })
k("n", "<leader>bd", buf_delete, { desc = "Chiudi buffer" })
k("n", "<leader>bo", function()
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(listed()) do if b ~= cur then buf_delete(b) end end
end, { desc = "Chiudi gli altri buffer" })
k("n", "[b", "<cmd>bprevious<cr>", { desc = "Buffer precedente" })
k("n", "]b", "<cmd>bnext<cr>", { desc = "Buffer successivo" })
k("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Ultimo buffer" })
k("n", "<leader>,", buf_pick, { desc = "Elenco buffer" })

-- Tab (stile LazyVim)
k("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "Nuova tab" })
k("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Chiudi tab" })
k("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Chiudi le altre tab" })
k("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Tab successiva" })
k("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Tab precedente" })

-- Sposta righe (Alt+j/k)
k("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Sposta riga giù" })
k("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Sposta riga su" })
k("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi")
k("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi")
k("v", "<A-j>", ":m '>+1<cr>gv=gv")
k("v", "<A-k>", ":m '<-2<cr>gv=gv")

-- Indenta in visual senza perdere la selezione
k("v", "<", "<gv")
k("v", ">", ">gv")

-- Copia negli appunti
k({ "n", "v" }, "<leader>y", '"+y', { desc = "Copia negli appunti" })
k("n", "<leader>Y", '"+Y', { desc = "Copia riga negli appunti" })

-- Terminale sotto al file (Spazio ft / Ctrl+/): apre e chiude, la shell resta viva
local term = { buf = nil, win = nil }
local function toggle_term()
  if term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_hide(term.win)
    term.win = nil
    return
  end
  to_file_win()
  local new = not (term.buf and vim.api.nvim_buf_is_valid(term.buf))
  vim.cmd("belowright 12split")
  term.win = vim.api.nvim_get_current_win()
  if new then
    term.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(term.win, term.buf)
    vim.fn.jobstart(vim.o.shell, { term = true })
    vim.bo[term.buf].buflisted = false
  else
    vim.api.nvim_win_set_buf(term.win, term.buf)
  end
  vim.wo[term.win].winfixheight = true
  vim.wo[term.win].cursorline = false
  vim.wo[term.win].winhighlight = "Normal:NormalFloat"   -- fondo un po' più scuro del file
  vim.cmd.startinsert()
end
k({ "n", "t" }, "<C-/>", toggle_term, { desc = "Terminale" })
k({ "n", "t" }, "<C-_>", toggle_term, { desc = "which_key_ignore" })
k("n", "<leader>ft", toggle_term, { desc = "Terminale" })
k("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Esci dalla modalità terminale" })

-- Ctrl+h/j/k/l dal terminale cambiano finestra
for _, key in ipairs({ "h", "j", "k", "l" }) do
  k("t", "<C-" .. key .. ">", "<cmd>wincmd " .. key .. "<cr>")
end

-- Neo-tree
k("n", "<leader>e", "<cmd>Neotree toggle left<cr>", { desc = "Explorer" })
k("n", "<leader>E", "<cmd>Neotree toggle left dir=%:p:h<cr>", { desc = "Explorer (cartella del file)" })

-- Ricerca (risultati in una lista: Invio per saltare, ]q / [q successivo/precedente)
local function ask(prompt, fn)
  vim.ui.input({ prompt = prompt }, function(text)
    if text and text ~= "" then fn(text) end
  end)
end
local function in_file(text)
  if vim.api.nvim_buf_get_name(0) == "" then return end
  local ok = pcall(vim.cmd, "silent lvimgrep /\\V" .. vim.fn.escape(text, "/\\") .. "/j %")
  if ok then vim.cmd("lopen") else vim.notify("Nessun risultato: " .. text) end
end
local function in_project(text)
  vim.cmd("silent grep! -F -- " .. vim.fn.shellescape(text, true))
  if #vim.fn.getqflist() > 0 then vim.cmd("botright copen") else vim.notify("Nessun risultato: " .. text) end
end
k("n", "<leader>sb", function() ask("Cerca nel file: ", in_file) end, { desc = "Cerca nel file" })
k("n", "<leader>sg", function() ask("Cerca nel progetto: ", in_project) end, { desc = "Cerca nel progetto" })
k("n", "<leader>/", function() ask("Cerca nel progetto: ", in_project) end, { desc = "Cerca nel progetto" })
k("n", "<leader>sw", function() in_project(vim.fn.expand("<cword>")) end, { desc = "Cerca la parola sotto il cursore" })
k("n", "<leader>ff", function()
  ask("Apri file: ", function(t) vim.cmd.find(vim.fn.fnameescape(t)) end)
end, { desc = "Apri file per nome" })

-- Tema: elenco con anteprima, Invio per tenerlo (aggiorna anche kitty)
k("n", "<leader>uc", function() require("theme").pick() end, { desc = "Cambia tema" })
