-- Theme scanner - finds all available themes

local M = {}

-- Default themes directory
M.themes_dir = vim.fn.stdpath('config') .. '/themes'

-- Ensure themes directory exists
function M.ensure_themes_dir()
  if vim.fn.isdirectory(M.themes_dir) == 0 then
    vim.fn.mkdir(M.themes_dir, 'p')
  end
end

-- Scan and list all available themes
-- @return table: list of theme info {name, path}
function M.scan_themes()
  M.ensure_themes_dir()

  local themes = {}
  local files = vim.fn.glob(M.themes_dir .. '/*.lua', false, true)

  for _, filepath in ipairs(files) do
    local filename = vim.fn.fnamemodify(filepath, ':t:r')
    table.insert(themes, {
      name = filename,
      path = filepath,
    })
  end

  -- Sort by name
  table.sort(themes, function(a, b)
    return a.name < b.name
  end)

  return themes
end

-- Check if a theme file exists
-- @param theme_name string: theme name (without .lua extension)
-- @return boolean: true if exists
function M.theme_exists(theme_name)
  local filepath = M.themes_dir .. '/' .. theme_name .. '.lua'
  return vim.fn.filereadable(filepath) == 1
end

-- Get theme file path
-- @param theme_name string: theme name (without .lua extension)
-- @return string: full path to theme file
function M.get_theme_path(theme_name)
  return M.themes_dir .. '/' .. theme_name .. '.lua'
end

return M
