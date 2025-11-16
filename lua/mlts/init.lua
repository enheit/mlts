-- MLTS - My Lovely Theme Selector
-- Main plugin entry point

local scanner = require('mlts.scanner')
local menu = require('mlts.menu')
local preview = require('mlts.preview')
local persistence = require('mlts.persistence')

local M = {}

-- Plugin configuration
M.config = {
  themes_dir = vim.fn.stdpath('config') .. '/themes',
  auto_apply = true,  -- Auto-apply saved theme on startup
}

-- Setup function
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_extend('force', M.config, opts)

  -- Update scanner config
  scanner.themes_dir = M.config.themes_dir

  -- Auto-apply saved theme on startup
  if M.config.auto_apply then
    M.auto_apply_saved()
  end
end

-- Auto-apply saved theme (called on startup)
function M.auto_apply_saved()
  local saved_theme = persistence.load_selection()

  if saved_theme and scanner.theme_exists(saved_theme) then
    local theme_path = scanner.get_theme_path(saved_theme)
    preview.apply_preview(theme_path)
  end
end

-- Open theme selector menu
function M.select()
  menu.open()
end

-- Create user commands
vim.api.nvim_create_user_command('MLTSSelect', function()
  M.select()
end, {
  desc = 'Open MLTS theme selector',
})

return M
