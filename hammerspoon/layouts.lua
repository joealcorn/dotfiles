local laptopScreen = "Color LCD"
local thunderboltScreen = "Thunderbolt Display"

local workLayout = {
    {"Google Chrome", nil, thunderboltScreen, hs.layout.left50, nil, nil},
    {"Sublime Text", nil, thunderboltScreen, hs.layout.right50, nil, nil},
    {"iTerm2", nil, laptopScreen, {x=0, y=0, w=0.75, h=0.85}, nil, nil},
}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "1", function()
    hs.layout.apply(workLayout)
    local terminal = hs.application.get('iTerm2', 1)
    terminal:activate()
    local menuItem = {'View', 'Toggle Full Screen'}
    local fullScreen = terminal:findMenuItem(menuItem)
    if (fullScreen and not fullScreen['ticked']) then
        terminal:selectMenuItem(menuItem)
    end
end)

