-- Yazi plugin setup
-- https://yazi-rs.github.io/docs/configuration/overview

-- Git status signs in the file list
require("git"):setup({
  order = 1500,
})

-- Clean borders around panes
require("full-border"):setup()

-- smart-enter / smart-paste / smart-filter / what-size / chmod / toggle-pane
-- load via keymaps; no extra setup required
