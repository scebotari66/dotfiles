return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local on_attach = opts.on_attach
      opts.on_attach = function(buffer)
        if on_attach then
          on_attach(buffer)
        end

        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
        end

        -- Move hunk navigation from ]h/[h to ]g/[g
        for _, lhs in ipairs({ "]h", "[h", "]H", "[H" }) do
          pcall(vim.keymap.del, "n", lhs, { buffer = buffer })
        end

        -- stylua: ignore start
        map("n", "]g", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[g", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]G", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[G", function() gs.nav_hunk("first") end, "First Hunk")
        -- stylua: ignore end
      end
    end,
  },
}
