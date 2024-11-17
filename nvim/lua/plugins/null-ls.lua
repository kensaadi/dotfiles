return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local null_ls = require("null-ls")
      return {
        sources = {
          null_ls.builtins.code_actions.eslint, -- Suggerimenti e fix
          null_ls.builtins.completion.tags, -- Completamento automatico
          null_ls.builtins.diagnostics.eslint, -- Diagnostica avanzata
          null_ls.builtins.formatting.prettier, -- Formattazione
        },
      }
    end,
  },
}
