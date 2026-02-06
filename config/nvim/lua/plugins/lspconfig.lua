return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({
        float = {
          border = "rounded",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚',
            [vim.diagnostic.severity.WARN] = '󰀪',
            [vim.diagnostic.severity.HINT] = '󰙎',
            [vim.diagnostic.severity.INFO] = '󰋽',
          },
        },
      })

      vim.lsp.config('*', {
        capabilities = require("blink.cmp").get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
      })

      -- Use LspAttach autocmd instead of on_attach in config
      -- This ensures it fires for ALL LSP attachments, even if server configs have their own on_attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          local Snacks = require("snacks")
          local function map(mode, lhs, rhs, opts)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP " .. opts })
          end

          map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Display hover info")
          map("n", "gd", Snacks.picker.lsp_definitions, "[G]oto [D]efinition")
          map("n", "gD", Snacks.picker.lsp_declarations, "[G]oto [D]eclaration")
          map("n", "gi", Snacks.picker.lsp_implementations, "[G]oto [I]mplementation")
          map("n", "gt", Snacks.picker.lsp_type_definitions, "[G]oto [T]ype definition")
          map("n", "ga", vim.lsp.buf.code_action, "[G]et [A]ctions")
          map("x", "ga", vim.lsp.buf.code_action, "[G]et [A]ctions")

          map("n", "gl", vim.diagnostic.open_float, "Show diagnostics")

          map("n", "<space>gR", vim.lsp.buf.rename, "[R]ename")
          map("n", "<space>gd", Snacks.picker.diagnostics_buffer, "[G]et buffer [D]iagnostics")
          map("n", "<space>gs", Snacks.picker.lsp_symbols, "[G]et [S]ymbols (document)")
          map("n", "<space>gS", Snacks.picker.lsp_workspace_symbols, "[G]et [S]ymbols (workspace)")
          map("n", "<space>gr", Snacks.picker.lsp_references, "[G]et [R]eferences")

          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
            map("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
            end, "[T]oggle [H]int")
          end
        end,
      })

      vim.lsp.set_log_level("off")
    end
  },
}
