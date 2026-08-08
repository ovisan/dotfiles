-- Yazi plugin setup
-- https://yazi-rs.github.io/docs/configuration/overview

-- Git status signs in the file list
require("git"):setup({
  order = 1500,
})

-- Optional: smart plugins load via keymaps; no extra setup required
