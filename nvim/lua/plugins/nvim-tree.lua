return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- disable netrw at the very start
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        -- follow the current buffer (e.g. files opened via Telescope)
        update_focused_file = {
          enable = true,
        },
      })

      -- Keymaps
      vim.keymap.set(
        "n",
        "<C-n>",
        ":NvimTreeFindFileToggle<CR>",
        { desc = "Toggle file explorer at current file", silent = true }
      )
      vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus file explorer", silent = true })
    end,
  },
}
