return {
  {
    "neovim/nvim-lspconfig",
    dependencies = "mason-lspconfig.nvim",
    config = function()
      local function on_lsp_attach(client, bufnr)
        local function map(mode, lhs, rhs, opts)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "LSP " .. opts })
        end

        map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Display hover info")
        map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("n", "gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        map("n", "gt", vim.lsp.buf.type_definition, "[G]oto [T]ype definition")
        map("n", "ga", vim.lsp.buf.code_action, "[G]et [A]ctions")
        map("x", "ga", vim.lsp.buf.code_action, "[G]et [A]ctions")

        map("n", "gl", vim.diagnostic.open_float, "Show diagnostics")

        map("n", "<space>gr", vim.lsp.buf.rename, "[R]ename")
        map("n", "<space>gd", Snacks.picker.diagnostics_buffer, "[G]get buffer [D]iagnostics")
        map("n", "<space>gs", Snacks.picker.lsp_symbols, "[G]et [S]ymbols (document)")
        map("n", "<space>gr", Snacks.picker.lsp_references, "[G]et [R]eferences")
        map("n", "<space>gS", Snacks.picker.lsp_workspace_symbols, "[G]et [S]ymbols (workspace)")

        if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
          map("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
          end, "[T]oggle [H]int")
          client.server_capabilities.semanticTokensProvider = nil
        end
      end

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
        on_attach = on_lsp_attach,
      })

      vim.lsp.set_log_level("off")
    end
  },
}
