local M = {}

local default_config = {
    initialization_options = {},
    settings = {}
}

local config = vim.tbl_deep_extend('force', default_config, {})

-- Get extended capabilities from nvim-cmp if available
local function get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    return capabilities
end

function M.setup(opts)
    opts = opts or {} -- Important: handle nil opts
    config = vim.tbl_deep_extend('force', config, opts)

    local has_lspconfig, lspconfig = pcall(require, 'lspconfig')
    if not has_lspconfig then
        error('nvim-lspconfig is required for cargo-appraiser.nvim')
        return
    end

    local configs = require('lspconfig.configs')

    -- Register the config if it doesn't exist yet
    if not configs.cargo_appraiser then
        configs.cargo_appraiser = {
            default_config = {
                cmd = { "cargo-appraiser", "--renderer", "inlayHint" },
                root_dir = lspconfig.util.root_pattern("Cargo.lock"),
                filetypes = { "toml" },
                settings = config.settings,
                single_file_support = false,
                capabilities = get_capabilities()
            }
        }
    end

    -- Set up the LSP
    lspconfig.cargo_appraiser.setup({
        initialization_options = config.initialization_options,
        settings = config.settings,
        capabilities = get_capabilities(),
        on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        end,
        handlers = {
            ["workspace/inlayHint/refresh"] = function(err, result, ctx)
                -- Re-enable inlay hints for all buffers
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(bufnr) then
                        vim.lsp.inlay_hint.enable(true)
                    end
                end
                -- Send response using the proper LSP response mechanism
                return vim.NIL
            end
        }
    })
end

return M
