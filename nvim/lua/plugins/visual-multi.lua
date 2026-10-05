return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    -- vim-visual-multi is a vimscript plugin; avoid lazy-loading so its
    -- autocmds are ready from the start.
    lazy = false,
    init = function()
      -- Default "Find Under" / "Find Subword Under" is <C-n>, which
      -- conflicts with nvim-tree's toggle. Move it to <C-y> instead
      -- (default scroll-up-one-line, rarely used).
      vim.g.VM_maps = {
        ["Find Under"] = "<C-y>",
        ["Find Subword Under"] = "<C-y>",
      }
    end,
  },
}
