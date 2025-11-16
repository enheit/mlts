-- Persistence - save and load theme selection

local M = {}

-- Path to persistence file
M.selection_file = vim.fn.stdpath('data') .. '/mlts_selection.txt'

-- Save selected theme
-- @param theme_name string: theme name to save
function M.save_selection(theme_name)
  local file = io.open(M.selection_file, 'w')
  if file then
    file:write(theme_name)
    file:close()
  else
    vim.notify("Failed to save theme selection", vim.log.levels.ERROR)
  end
end

-- Load saved theme selection
-- @return string|nil: saved theme name or nil if none
function M.load_selection()
  local file = io.open(M.selection_file, 'r')
  if file then
    local theme_name = file:read('*l')
    file:close()
    return theme_name
  end
  return nil
end

-- Check if a selection exists
-- @return boolean: true if selection exists
function M.has_selection()
  return vim.fn.filereadable(M.selection_file) == 1
end

-- Clear saved selection
function M.clear_selection()
  if vim.fn.filereadable(M.selection_file) == 1 then
    vim.fn.delete(M.selection_file)
  end
end

return M
