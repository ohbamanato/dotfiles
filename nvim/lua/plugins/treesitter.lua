return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- 新しいnvim-treesitterではsetupは最小限
      require("nvim-treesitter").setup({})

      -- パーサーを自動インストール
      local parsers = {
        "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "python", "rust", "go",
        "html", "css", "json", "yaml",
        "markdown", "markdown_inline", "bash",
      }

      -- インストール済みパーサーを取得
      local installed = require("nvim-treesitter").get_installed()
      local installed_set = {}
      for _, p in ipairs(installed) do
        installed_set[p] = true
      end

      -- 未インストールのパーサーをインストール
      local to_install = {}
      for _, p in ipairs(parsers) do
        if not installed_set[p] then
          table.insert(to_install, p)
        end
      end

      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      -- ハイライトを有効化
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
