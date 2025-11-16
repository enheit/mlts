-- Menu UI - bottom split theme selector

local scanner = require('mlts.scanner')
local preview = require('mlts.preview')
local persistence = require('mlts.persistence')

local M = {}

-- UI state
local state = {
  buf = nil,
  win = nil,
  themes = {},
  selected_index = 1,
}

-- Render the menu
local function render_menu()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return
  end

  local lines = {}

  -- Theme list (just the names)
  if #state.themes == 0 then
    table.insert(lines, "")
    table.insert(lines, "  No themes found")
    table.insert(lines, "")
  else
    for i, theme in ipairs(state.themes) do
      table.insert(lines, "  " .. theme.name)
    end
  end

  -- Set buffer content
  vim.api.nvim_buf_set_option(state.buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(state.buf, 'modifiable', false)

  -- Clear previous highlights
  vim.api.nvim_buf_clear_namespace(state.buf, -1, 0, -1)

  -- Highlight selected line
  if #state.themes > 0 then
    vim.api.nvim_buf_add_highlight(
      state.buf,
      -1,
      'PmenuSel',
      state.selected_index - 1,
      0,
      -1
    )
  end
end

-- Move selection down
local function move_down()
  if #state.themes == 0 then
    return
  end

  state.selected_index = state.selected_index + 1
  if state.selected_index > #state.themes then
    state.selected_index = #state.themes
  end

  -- Preview theme
  local theme = state.themes[state.selected_index]
  preview.apply_preview(theme.path)

  render_menu()
end

-- Move selection up
local function move_up()
  if #state.themes == 0 then
    return
  end

  state.selected_index = state.selected_index - 1
  if state.selected_index < 1 then
    state.selected_index = 1
  end

  -- Preview theme
  local theme = state.themes[state.selected_index]
  preview.apply_preview(theme.path)

  render_menu()
end

-- Select and save current theme
local function select_theme()
  if #state.themes == 0 then
    vim.notify("No themes available", vim.log.levels.WARN)
    M.close()
    return
  end

  local theme = state.themes[state.selected_index]

  -- Apply theme
  preview.apply_preview(theme.path)

  -- Save selection
  persistence.save_selection(theme.name)

  vim.notify(string.format("Theme '%s' selected and saved", theme.name), vim.log.levels.INFO)

  -- Close menu
  M.close()
end

-- Setup keymaps for the menu
local function setup_keymaps()
  local opts = {noremap = true, silent = true, buffer = state.buf}

  -- Navigation
  vim.keymap.set('n', 'j', move_down, opts)
  vim.keymap.set('n', 'k', move_up, opts)
  vim.keymap.set('n', '<Down>', move_down, opts)
  vim.keymap.set('n', '<Up>', move_up, opts)

  -- Select
  vim.keymap.set('n', '<CR>', select_theme, opts)
  vim.keymap.set('n', '<Space>', select_theme, opts)

  -- Close
  vim.keymap.set('n', 'q', function() M.close() end, opts)
  vim.keymap.set('n', '<Esc>', function() M.close() end, opts)
end

-- Open the menu
function M.open()
  -- Scan themes
  state.themes = scanner.scan_themes()

  -- Set selected index to saved theme if exists
  local saved_theme = persistence.load_selection()
  if saved_theme then
    for i, theme in ipairs(state.themes) do
      if theme.name == saved_theme then
        state.selected_index = i
        break
      end
    end
  end

  -- Create buffer
  state.buf = vim.api.nvim_create_buf(false, true)

  -- Set buffer options
  vim.api.nvim_buf_set_option(state.buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(state.buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(state.buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(state.buf, 'filetype', 'mlts')

  -- Calculate height based on number of themes
  local height = #state.themes > 0 and math.min(#state.themes + 2, 20) or 5

  -- Create bottom split
  vim.cmd('botright ' .. height .. 'split')
  state.win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(state.win, state.buf)

  -- Set window options
  vim.api.nvim_win_set_option(state.win, 'number', false)
  vim.api.nvim_win_set_option(state.win, 'relativenumber', false)
  vim.api.nvim_win_set_option(state.win, 'cursorline', false)
  vim.api.nvim_win_set_option(state.win, 'wrap', false)

  -- Setup keymaps and render
  setup_keymaps()
  render_menu()

  -- Preview current theme
  if #state.themes > 0 then
    local theme = state.themes[state.selected_index]
    preview.apply_preview(theme.path)
  end
end

-- Close the menu
function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  -- Reset state
  state.buf = nil
  state.win = nil
  state.themes = {}
  state.selected_index = 1
end

return M
