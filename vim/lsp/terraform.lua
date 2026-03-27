---@type vim.lsp.Config
return {
    cmd = { "terraform-ls", "serve" },
    root_markers = { "go.work", "go.mod", ".git" },
    filetypes = { "terraform" },
}
