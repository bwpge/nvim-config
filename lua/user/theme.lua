local M = {}

-- use this field to change colorscheme for editor and plugins
M.name = 'dracula'

-- returns the yellow color of the selected theme
function M.yellow()
    if M.name == 'dracula' then
        return require("dracula").colors().yellow
    elseif M.name == 'onedark' then
        return require("onedark.palette").dark.yellow
    end
end

return M
