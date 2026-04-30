return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        -- カスタマイズが必要な場合はここに設定を追加
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
