-- Only auto-format with prettier/oxfmt when the project (or an ancestor
-- package.json, for monorepos) actually declares it as a dependency. A binary
-- can end up in node_modules/.bin as a transitive dependency of some other
-- tool, so checking for the binary alone isn't enough.
local function declares(ctx, name)
  local package_jsons = vim.fs.find("package.json", { upward = true, path = ctx.dirname, limit = math.huge })

  for _, package_json in ipairs(package_jsons) do
    local ok, content = pcall(vim.fn.readfile, package_json)
    if ok then
      local ok2, decoded = pcall(vim.json.decode, table.concat(content, "\n"))
      if ok2 and type(decoded) == "table" then
        for _, field in ipairs({ "dependencies", "devDependencies", "peerDependencies", "optionalDependencies" }) do
          if type(decoded[field]) == "table" and decoded[field][name] then
            return true
          end
        end
      end
    end
  end
  return false
end

-- Filetypes oxfmt handles (same set as LazyVim's oxc extra, minus the ones
-- this config has no language support for).
local oxfmt_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
  "vue",
}

return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = {
        condition = function(_, ctx)
          return declares(ctx, "prettier")
        end,
      }
      opts.formatters.oxfmt = {
        condition = function(_, ctx)
          return declares(ctx, "oxfmt")
        end,
      }

      -- Try oxfmt before prettier, and stop at the first one the project
      -- declares so a project with both doesn't get formatted twice.
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(oxfmt_filetypes) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], 1, "oxfmt")
        opts.formatters_by_ft[ft].stop_after_first = true
      end

      -- Without a local prettier/oxfmt dependency, don't let conform silently
      -- fall back to the buffer's LSP client for formatting (e.g. vtsls) --
      -- only skip formatting entirely for filetypes they're responsible for.
      for _, formatters in pairs(opts.formatters_by_ft) do
        if
          type(formatters) == "table"
          and (vim.tbl_contains(formatters, "prettier") or vim.tbl_contains(formatters, "oxfmt"))
        then
          formatters.lsp_format = "never"
        end
      end
    end,
  },
}
