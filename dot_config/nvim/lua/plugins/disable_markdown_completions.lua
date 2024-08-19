return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.enabled = function()
        return vim.bo.filetype ~= "markdown"
      end
      return opts
    end,
  },
}
