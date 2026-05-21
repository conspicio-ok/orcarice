-- ============================================================
-- Options
-- ============================================================

local opt = vim.opt

-- Numérotation
opt.number         = true
opt.relativenumber = true

-- Indentation
opt.expandtab   = false  -- tabs réels
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.smartindent = true

-- Affichage
opt.cursorline   = true
opt.wrap         = false
opt.scrolloff    = 8
opt.signcolumn   = "yes"  -- colonne signe fixe (LSP/git évite le jitter)
opt.termguicolors = true

-- Recherche
opt.ignorecase = true
opt.smartcase  = true    -- sensible si majuscule tapée
opt.hlsearch   = true
opt.incsearch  = true

-- Comportement
opt.splitright = true
opt.splitbelow = true
opt.undofile   = true    -- undo persistant entre sessions
opt.clipboard  = "unnamedplus"  -- presse-papier système

-- ============================================================
-- Keymaps
-- ============================================================

local map = vim.keymap.set

-- Effacer le surlignage de recherche
map("n", "<Space>", "<cmd>nohlsearch<CR>", { silent = true })

-- Navigation entre splits (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Déplacement de ligne avec réindentation (Alt+Up/Down et Alt+k/j)
map("n", "<M-Down>", ":m .+1<CR>==",        { silent = true })
map("n", "<M-Up>",   ":m .-2<CR>==",        { silent = true })
map("n", "<M-j>",    ":m .+1<CR>==",        { silent = true })
map("n", "<M-k>",    ":m .-2<CR>==",        { silent = true })
map("i", "<M-Down>", "<Esc>:m .+1<CR>==gi", { silent = true })
map("i", "<M-Up>",   "<Esc>:m .-2<CR>==gi", { silent = true })
map("i", "<M-j>",    "<Esc>:m .+1<CR>==gi", { silent = true })
map("i", "<M-k>",    "<Esc>:m .-2<CR>==gi", { silent = true })
map("v", "<M-Down>", ":m '>+1<CR>gv=gv",        { silent = true })
map("v", "<M-Up>",   ":m '<-2<CR>gv=gv",        { silent = true })
map("v", "<M-j>",    ":m '>+1<CR>gv=gv",        { silent = true })
map("v", "<M-k>",    ":m '<-2<CR>gv=gv",        { silent = true })

-- ============================================================
-- Treesitter
-- ============================================================

-- Coloration syntaxique treesitter (échoue silencieusement si pas de parser)
vim.api.nvim_create_autocmd('FileType', {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- Réindentation treesitter pour svelte
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'svelte',
    callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- ============================================================
-- nvim-tree
-- ============================================================

local nvimTreeOk, nvimTree = pcall(require, "nvim-tree")
if nvimTreeOk then
    nvimTree.setup({
        view = {
            width = 32,
            side  = "left",
        },
        renderer = {
            icons = {
                show = {
                    file         = false,
                    folder       = false,
                    folder_arrow = true,
                    git          = false,
                },
            },
        },
        update_focused_file = {
            enable = true,
        },
        filters = {
            dotfiles = false,
        },
    })
end

-- ============================================================
-- gitgraph
-- ============================================================

local gitgraphOk, gitgraph = pcall(require, "gitgraph")
if gitgraphOk then
    gitgraph.setup({
        format = {
            timestamp = "%d/%m/%Y %H:%M",
            fields    = { "hash", "timestamp", "author", "branch_name", "tag" },
        },
    })
end

-- ============================================================
-- Layout : arbre (gauche haut) / git graph (gauche bas) / éditeur (droite)
-- ============================================================

local function findWin(ft)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == ft then
            return win
        end
    end
    return nil
end

local function openLayout()
    if not nvimTreeOk or not gitgraphOk then return end

    local treeWin = findWin("NvimTree")
    if treeWin == nil then
        vim.cmd("NvimTreeOpen")
        treeWin = findWin("NvimTree")
    end
    if treeWin == nil then return end

    local graphWin = findWin("gitgraph")
    if graphWin == nil then
        local isGitRepo = vim.fn.systemlist("git rev-parse --git-dir")[1] ~= nil
            and vim.v.shell_error == 0
        if isGitRepo then
            vim.api.nvim_set_current_win(treeWin)
            vim.cmd("belowright split")
            vim.cmd("resize 22")
            gitgraph.draw({}, { all = true, max_count = 256 })
            vim.cmd("redraw!")
        end
    end

    vim.cmd("wincmd l")
end

map("n", "<F2>", "<cmd>NvimTreeFocus<CR>", { silent = true })
map("n", "<F3>", openLayout,               { silent = true })
