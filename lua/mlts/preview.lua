-- Theme preview - temporarily apply themes

local M = {}

-- Store original colorscheme for restoration
local original_colorscheme = nil

-- Apply a theme for preview
-- @param theme_path string: path to theme file
function M.apply_preview(theme_path)
  -- Execute the theme file
  local ok, err = pcall(vim.cmd.source, theme_path)
  if not ok then
    vim.notify("Failed to load theme: " .. err, vim.log.levels.ERROR)
  end
end

-- Apply a theme by name
-- @param theme_name string: theme name (without .lua extension)
function M.apply_by_name(theme_name)
  -- Use Neovim's colorscheme command
  local ok, err = pcall(vim.cmd.colorscheme, theme_name)
  if not ok then
    vim.notify("Failed to load theme: " .. err, vim.log.levels.ERROR)
  end
end

-- Save current colorscheme before previewing
function M.save_current()
  original_colorscheme = vim.g.colors_name
end

-- Restore original colorscheme
function M.restore_original()
  if original_colorscheme then
    pcall(vim.cmd.colorscheme, original_colorscheme)
  end
end

return M
