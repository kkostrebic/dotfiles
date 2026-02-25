-- Bootstrap lazy.nvim (Plugin Manager for nvim)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for
-- example `:h 'number'` (Note the single quotes)

vim.g.mapleader      = ' ' -- Set <space> as the leader key

vim.o.number         = true -- Print line number in front of each line
vim.o.relativenumber = true -- Use relative line numbers
vim.o.cursorline     = true -- Highlight the line where the cursor is on
vim.o.list           = true -- Show <tab> and trailing spaces
vim.o.confirm        = true -- Prompt confirmation dialog (if changes are not saved)
vim.o.showmatch      = true -- Highlight matching brackets (regardless if there is or no plugins)
vim.o.visualbell     = true -- Use visual bell (no beeping)
vim.o.expandtab      = true -- Use spaces instead of tabs
vim.o.smartindent    = true -- Intelligently guess indentation
vim.o.smarttab       = true -- Enable smart tab
vim.o.autoindent     = true -- Copy indent from current line to next
vim.o.wrap           = false -- Do not wrap long lines
vim.o.shiftwidth     = 2 -- Number of spaces to use for each step of (auto)indent
vim.o.softtabstop    = 2 -- Number of spaces that a <Tab> counts
vim.o.tabstop        = 4 -- Number of columns regular tab will add
vim.o.background     = 'dark' -- Help colorschemes determine which pallete to use
vim.o.colorcolumn    = '80,120' -- Hightlight screen columns

-- How whitespace chars will be shown with `:set list` command
vim.opt.listchars      = {
  nbsp = '␣',
  extends = '⮩',
  precedes = '⮨', 
}

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter`
-- because it can increase startup-time. Remove this option if you want your OS
-- clipboard to remain independent.
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

--------------------------------------------------------------------------------
-- Search logic
--------------------------------------------------------------------------------
-- Case-insensitive searching UNLESS \C or one or more capital letters in the
-- search term
vim.o.ignorecase = true
vim.o.smartcase  = true
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Scrolling logic
--------------------------------------------------------------------------------
vim.o.scrolloff     = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.sidescroll    = 1  -- Minimal number of columns to scroll horizontally
vim.o.sidescrolloff = 5  -- Minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Folding logic
--------------------------------------------------------------------------------
-- Use syntax (through treesitter) folding for file types where it makes sense
vim.api.nvim_create_autocmd("FileType", {
  -- TODO: what file types should i put here?
  pattern = { "ruby", "javascript", "go", "php", "c", "cpp", "rust", "lua" },
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
})

-- Use indent folding for file types where it makes sense
vim.api.nvim_create_autocmd("FileType", {
  -- TODO: what file types should i put here?
  pattern = { "python", "yaml", "vim" },
  callback = function()
    vim.opt_local.foldmethod = "indent"
  end,
})

-- Keep all folds open by default when opening a file
vim.o.foldlevelstart = 99
--------------------------------------------------------------------------------

-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- Map <C-j>, <C-k>, <C-h>, <C-l> to navigate between windows in any modes
-- Default nvim configuration is to use Alt key (e.g. <A-h>), but since that
-- one is already mapped and used by i3wm, changed to Control
vim.keymap.set({ 'n' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<C-l>', '<C-w>l')

-- Exit terminal insert mode on mouse scroll
vim.keymap.set('t', '<ScrollWheelUp>', [[<C-\><C-n><C-w>N]])
vim.keymap.set('t', '<ScrollWheelDown>', [[<C-\><C-n><C-w>N]])

-- Move lines (https://vim.fandom.com/wiki/Moving_lines_up_or_down)
vim.keymap.set('n', '<C-j>', [[:m .+1<CR>==]])
vim.keymap.set('n', '<C-k>', [[:m .-2<CR>==]])
vim.keymap.set('i', '<C-j>', [[<Esc>:m .+1<CR>==gi]])
vim.keymap.set('i', '<C-k>', [[<Esc>:m .-2<CR>==gi]])
vim.keymap.set('v', '<C-j>', [[:m '>+1<CR>gv=gv]])
vim.keymap.set('v', '<C-k>', [[:m '<-2<CR>gv=gv]])

-- Pressing Escape in Normal Mode clears search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><Esc>')

-- Setup (plugins via) lazy.nvim
require("lazy").setup({
  spec = {
    -- automatically toggle between relative and absolute line numbers
    -- Relative numbers are used in a buffer that has focus and is in
    -- normal mode since that's where you move around. They're turned off
    -- when you switch out of Vim, switch to another split, or go into
    -- insert and command modes.
    "sitiom/nvim-numbertoggle",

    -- Alignment plugin
    "junegunn/vim-easy-align",

    -- Git plugin
    "tpope/vim-fugitive",

    -- Modern Colorizer (show actual color based on hash, name, etc)
    "NvChad/nvim-colorizer.lua",

    -- Support for expanding abbreviations for html & css
    "mattn/emmet-vim",

    -- Multiple cursors plugin for vim/neovim
    "mg979/vim-visual-multi",

    -- LSP configurations
    "neovim/nvim-lspconfig",

    -- Buffer removing (unshow, delete, wipeout), which saves window layout
    { 'nvim-mini/mini.bufremove', version = '*' },

    -- Wisely add "end" in Ruby, Lua, Bash, Vimscript, etc.
    { "RRethy/nvim-treesitter-endwise", event = "InsertEnter" },
 
    -- vim-matchup plugin that lets you highlight, navigate, and operate on sets
    -- of matching text e.g. HTML tags, if/else/endif blocks, and other
    -- language-specific keywords
    {
      'andymass/vim-matchup',
      setup = function()
        -- Disable virtual text/highlighter if things get slow
        vim.g.matchup_matchparen_enabled = 0 
      end
    },

    -- Fzf (fuzzy finder) plugin
    {
      'ibhagwan/fzf-lua',
      opts = {
        winopts = {
          split = "belowright 20new",
          preview = { hidden = "hidden" },
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 --sort path --vimgrep -e"
        }
      },
      keys = {
        -- Grep in files
        { "<leader>f", "<cmd>FzfLua live_grep<cr>", mode = "n", { desc = "Fzf Live Grep" } },
        -- Grep selection in files
        { "<leader>f", "<cmd>FzfLua grep_visual<cr>", mode = "v", { desc = "Fzf Grep Visual" } },
        -- Find file
        { "<C-p>", "<cmd>FzfLua files<cr>", mode = "n", { desc = "Fzf Files" } },
        -- Find buffer
        { "<leader>b", "<cmd>FzfLua buffers<cr>", mode = "n", { desc = "Fzf Buffers" } },
      }
    },
   
    -- Autopairs plugin
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      opts = {
        check_ts = true, -- uses treesitter to check for pairs
      }
    },
   
    -- Completion plugin with support for LSPs, cmdline, signature help, and
    -- snippets
    {
      'saghen/blink.cmp',
      version = '*', -- Download pre-built binaries
      opts = {
        keymap = { preset = 'super-tab' },
        -- appearance = {
        --   use_nvim_cmp_as_default = true, -- Better icon compatibility
        --   nerd_font_variant = 'mono'
        -- },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
      },
    },
   
    -- Linter plugin 
    {
      "mfussenegger/nvim-lint",
      event = { "BufReadPost", "BufWritePost", "InsertLeave" },
      config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
          bash = { "shellcheck" },
          sh = { "shellcheck" },
          -- javascript = { "eslint_d" },
          -- typescript = { "eslint_d" },
          -- ruby = { "rubocop" },
          -- python = { "flake8" },
        }

        vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
          callback = function() lint.try_lint() end,
        })
      end,
    },
   
    -- Code navigation
    {
      "stevearc/aerial.nvim",
      keys = {{ "<F8>", "<cmd>AerialToggle!<CR>", desc = "Outline" }},
    },
   
    -- {
    --   "luispflamminger/git-sync.nvim",
    --   opts = {
    --  repos = {
    --   -- The absolute path to your Vimwiki repository
    --   path = "~/vimwiki",
    --   sync_interval = 0,  -- 0 = disable, in minutes
    --   commit_template = "[{hostname}] vault sync: {timestamp}",
    --  }
    --   }
    -- },

    -- Status line
    { 
      'nvim-lualine/lualine.nvim',
      opts = {
        options = {
          theme = 'auto', -- Automatically matches selected colorscheme
          section_separators = '',
          component_separators = '|',
        },
        sections = {
          lualine_a = {'filename'}, -- filename
          lualine_b = {},
          lualine_c = {},
          lualine_x = {"'0x%B'", 'encoding', 'filetype'},  -- unicode value of the char under the cursor | file encoding
          lualine_y = {'%l/%L:%c'}, -- current-line / total-lines : column
          lualine_z = {},
        }
      }
    },
         
    {
      "olimorris/codecompanion.nvim",
      version = "^18.0.0",
      opts = {},
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "ravitemer/mcphub.nvim",
      },
      config = function()
        require("codecompanion").setup({
          interactions = {
              chat = {
                adapter = "cagent",  -- use ACP adapter cagent
              },
            },
          adapters = {
            acp = {
              cagent = function()
                return require("codecompanion.adapters").extend("cagent", {
                  commands = {
                    default = {
                      "cagent",
                      "acp",
                      "writer.yaml"
                    },
                  },
                  env = {
                    OPENAI_API_KEY = "key",
                  }
                })
              end,
            },
          },
        })
      end
    },

    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "codecompanion" }
    },

    {
      "HakonHarnes/img-clip.nvim",
      opts = {
        filetypes = {
          codecompanion = {
            prompt_for_file_name = false,
            template = "[Image]($FILE_PATH)",
            use_absolute_path = true,
          },
        },
      },
    },

    -- Color scheme
    {
      "rebelot/kanagawa.nvim", 
      lazy = false,
      -- opts ={},
      config = function()
        vim.cmd("colorscheme kanagawa-wave") 
      end
    },

    -- Personal wiki
    { 
      "vimwiki/vimwiki",
      init = function() 
        vim.g.vimwiki_list = {
          {
            name             = 'Wiki',
            path             = '~/projects/wiki/',
            syntax           = 'markdown',
            ext              = '.md',
            links_space_char = '-',
            index            = 'index',
            table_mappings   = 0,
          },
        }
      end,
    },
  },

  -- automatically check for plugin updates
  checker = { enabled = true }
})


-- Make the update feel faster (default is 4000ms, which is too slow)
vim.opt.updatetime = 300

-- Set global defaults for ALL language servers
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities()
})

-- Now enable your servers individually (they inherit the above)
-- vim.lsp.enable('gopls')
-- vim.lsp.enable('lua_ls')
-- Define the specific config for the Go binary
-- vim.lsp.config('dockerls', {
--   cmd = { "docker-language-server", "start", "--stdio" },
--   -- Optional: ensure filetypes match
--   filetypes = { "dockerfile" },
--   root_markers = { "Dockerfile" },
-- })

-- Activate it
-- vim.lsp.config('docker-language-server', {})
vim.lsp.enable('docker_language_server')
-- local lspconfig = require('lspconfig')
-- -- 1. Get the generic default config from lspconfig
-- local lspconfig_defaults = require('lspconfig').util.default_config
--
-- lspconfig.dockerls.setup({
--   -- Use the Go binary name + the 'start' sub-command
--   cmd = { "docker-language-server", "start", "--stdio" },
-- })
-- -- 2. Merge blink's capabilities into the default config
-- lspconfig_defaults.capabilities = vim.tbl_deep_extend(
--   'force',
--   lspconfig_defaults.capabilities,
--   require('blink.cmp').get_lsp_capabilities()
-- )

-- lspconfig.bashls.setup({
--   -- Automatically tells the server what blink.cmp supports
--   capabilities = require('blink.cmp').get_lsp_capabilities()
-- })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local fzf = require('fzf-lua')

    local opts = function(desc)
      return { buffer = event.buf, desc = desc }
    end

    -- Navigation (lists → fzf)
    vim.keymap.set("n", "gd", fzf.lsp_definitions, opts("Go to definition"))
    vim.keymap.set("n", "gr", fzf.lsp_references, opts("References"))
    vim.keymap.set("n", "gi", fzf.lsp_implementations, opts("Implementations"))
    vim.keymap.set("n", "gt", fzf.lsp_typedefs, opts("Type definitions"))

    -- Symbols
    vim.keymap.set("n", "<leader>ds", fzf.lsp_document_symbols, opts("Document symbols"))
    vim.keymap.set("n", "<leader>ws", fzf.lsp_workspace_symbols, opts("Workspace symbols"))

    -- Diagnostics
    vim.keymap.set("n", "<leader>ld", fzf.diagnostics_document, opts("Document diagnostics"))
    vim.keymap.set("n", "<leader>lD", fzf.diagnostics_workspace, opts("Workspace diagnostics"))
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts("Line diagnostics"))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts("Previous diagnostic"))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts("Next diagnostic"))

    -- Code actions
    vim.keymap.set({ "n", "v" }, "<leader>ca", fzf.lsp_code_actions, opts("Code actions"))

    -- Info
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover docs"))
  end,
})

-- Adds a nice border to the 'K' hover window
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { border = "rounded" }
)

-- Adds a border to diagnostic popups (the "I" info)
vim.diagnostic.config({
  virtual_lines = true,  -- Use virtual lines for showing diagnostic messages
  float = { border = "rounded" },
})

-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     -- This echoes the current line's diagnostic to the message area
--     local _, diagnostic = pcall(vim.diagnostic.get, 0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
--     if diagnostic and #diagnostic > 0 then
--       vim.api.nvim_echo({{ diagnostic[1].message, "Normal" }}, false, {})
--     end
--   end,
-- })

