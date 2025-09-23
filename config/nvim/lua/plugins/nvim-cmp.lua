return {
  {
    "hrsh7th/nvim-cmp", -- core plugin
    config = function()
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        return
      end

      local snip_status_ok, luasnip = pcall(require, "luasnip")
      if not snip_status_ok then
        return
      end

      local check_backspace = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      local icons = {
        Class = "󰠱",
        Color = "󰏘",
        Constant = "󰏿",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "󰇽",
        File = "󰈙",
        Folder = "󰉋",
        Function = "󰊕",
        Interface = "",
        Keyword = "󰌋",
        Method = "󰆧",
        Module = "",
        Operator = "󰆕",
        Property = "󰜢",
        Reference = "",
        Snippet = "",
        Struct = "",
        Text = "",
        TypeParameter = "󰅲",
        Unit = "",
        Value = "󰎠",
        Variable = "󰂡",
      }

      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          documentation = cmp.config.window.bordered({
            winhighlight = 'Normal:Normal,FloatBorder:CmpFloatBorder,CursorLine:Visual,Search:None'
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<m-o>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
          -- ['<C-Space>'] = cmp.mapping.complete(),
          -- ['<C-e>'] = cmp.mapping.abort(),
          -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          -- Accept currently selected item. If none selected, `select` first item.
          -- Set `select` to `false` to only confirm explicitly selected items.
          ["<CR>"] = cmp.mapping.confirm { select = false },
          -- Tab completion. Yeah, I know. But you should read `:help ins-completion` first.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.jumpable(1) then
              luasnip.jump(1)
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif luasnip.expandable() then
              luasnip.expand({})
            elseif check_backspace() then
              -- cmp.complete()
              fallback()
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        }),
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s ", icons[vim_item.kind])
            vim_item.menu = ({
              nvim_lsp = "∙lsp∙",
              nvim_lua = "∙lua∙",
              luasnip = "∙snip∙",
              buffer = "∙buf∙",
              path = "∙path∙",
              copilot = "∙∙"
            })[entry.source.name]

            return vim_item
          end,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp', keyword_length = 3 },
          { name = 'nvim_lua', keyword_length = 3 },
          { name = 'luasnip',  keyword_length = 3 },
          { name = 'buffer',   keyword_length = 3 },
          { name = 'copilot' },
          { name = 'path' },
        }),
        experimental = {
          native_menu = false,
        },
      })

      local M = {}

      local function setup_diagnostics()
        local signs = {
          { name = "DiagnosticSignError", text = "󰅚" },
          { name = "DiagnosticSignWarn", text = "󰀪" },
          { name = "DiagnosticSignHint", text = "󰙎" },
          { name = "DiagnosticSignInfo", text = "󰋽" },
        }

        for _, sign in ipairs(signs) do
          vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
        end

        vim.diagnostic.config({
          virtual_text = {
            prefix = "",
          },
          signs = { active = signs },
          update_in_insert = false,
          underline = true,
          severity_sort = false,
          float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = true,
            header = "",
            prefix = "",
          },
        })
      end

      local function lsp_keymaps(bufnr)
        local opts = { silent = true, remap = false, buffer = bufnr }

        -- Generate LSP functionality
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gR", Snacks.picker.lsp_references, opts)
        vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)

        -- Navigate diagnotis errors/mesages
        vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1, float = false }) end, opts)
        vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1, float = false }) end, opts)

        -- Helpers for listing symbols and diagnostics
        vim.keymap.set("n", "<leader>gs", Snacks.picker.lsp_symbols, opts)
        vim.keymap.set("n", "<leader>gd", Snacks.picker.diagnostics, opts)
      end

      M.on_attach = function(bufnr)
        setup_diagnostics()
        lsp_keymaps(bufnr)
      end

      vim.lsp.config("*", {
        capabilities = M.capabilities,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_lsp_loaded, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_lsp_loaded then
        M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach-config", { clear = true }),
        callback = function(ev)
          M.on_attach(ev.buf)
        end
      })
    end
  },
  "hrsh7th/cmp-buffer",   -- completes words from the current buffer
  "hrsh7th/cmp-nvim-lsp", -- LSP support
  "hrsh7th/cmp-nvim-lua", -- neovim Lua completion
  "hrsh7th/cmp-path",     -- complete files
  "saadparwaiz1/cmp_luasnip",
}
