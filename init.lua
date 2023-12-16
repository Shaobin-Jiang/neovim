Ice = {}

require "core.init"
require "plugins.init"

-- Load user configuration files
local config_root = string.gsub(vim.fn.stdpath "config", "\\", "/")
if not vim.api.nvim_get_runtime_file("lua/custom/", false)[1] then
    os.execute("mkdir \"" .. config_root .. "/lua/custom\"")
end
pcall(require, "custom.init")

-- Define keymap
local keymap = Ice.keymap.general
require("core.utils").group_map(keymap)

-- Load plugins
local config = {}
for _, plugin in pairs(Ice.plugins) do
    config[#config + 1] = plugin
end
require("lazy").setup(config)

require("core.utils").group_map(Ice.keymap.plugins)

-- Define colorscheme
if not Ice.colorscheme then
    local colorscheme_cache = vim.fn.stdpath "data" .. "/colorscheme"
    local f = io.open(colorscheme_cache, "r")
    if f ~= nil then
        local colorscheme = f:read "*a"
        f:close()
        Ice.colorscheme = Ice.colorschemes[colorscheme]
    else
        Ice.colorscheme = Ice.colorschemes["tokyonight"]
    end
end

require("plugins.utils").colorscheme(Ice.colorscheme)
