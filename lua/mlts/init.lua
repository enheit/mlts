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

-- Select and apply a random theme
function M.select_random()
  local themes = scanner.scan_themes()

  if #themes == 0 then
    vim.notify("No themes found in: " .. scanner.themes_dir, vim.log.levels.WARN)
    return
  end

  -- Select random theme
  math.randomseed(os.time())
  local random_index = math.random(1, #themes)
  local theme = themes[random_index]

  -- Apply theme
  preview.apply_preview(theme.path)

  -- Save selection
  persistence.save_selection(theme.name)

  vim.notify(string.format("Random theme '%s' applied", theme.name), vim.log.levels.INFO)
end

-- Create user commands
vim.api.nvim_create_user_command('MLTSSelect', function()
  M.select()
end, {
  desc = 'Open MLTS theme selector',
})

vim.api.nvim_create_user_command('MLTSSelectRandom', function()
  M.select_random()
end, {
  desc = 'Select and apply a random theme',
})

return M
