local default = {
    ID = "00000000-0000-0000-0000-000000000000",
    Name = "Default",
    ThemeColors = {
        ["Accent1"] = "#2c3156",
        ["Background"] = "#49529A",
        ["Accent2"] = "#7777bc",
        ["Highlight"] = "#8C0000",
        ["Header"] = "#913535",
        ["MainHover"] = "#118b67",
        ["MainActive"] = "#1E8146",
        ["MainText"] = "#d6f7f3",
        ["Main"] = "#F1D099",
        ["MainActive2"] = "#52284c",
        ["Grey"] = "#696969",
        ["DarkGrey"] = "#505050",
        ["Black1"] = "#0b1420",
        ["Black2"] = "#0c0c0c",
    },
}
local skizRed = {
    ID = "44b9b09d-589a-4303-8b01-07f450e7b4b6",
    Name = "SkizRed",
    ThemeColors = {
        ["Accent1"] = "#140404",
        ["Accent2"] = "#641717",
        ["Background"] = "#581212",
        ["Black1"] = "#5B1212",
        ["Black2"] = "#000000",
        ["Grey"] = "#696969",
        ["DarkGrey"] = "#505050",
        ["Header"] = "#984242",
        ["Highlight"] = "#940000",
        ["Main"] = "#FFFFFF",
        ["MainActive"] = "#B34848",
        ["MainActive2"] = "#000000",
        ["MainHover"] = "#FFFFFF",
        ["MainText"] = "#FFFFFF",
    }
}
local easyTheme = {
    ID = "dd5c0be7-3117-408f-b354-f9b1611592d8",
    Name = "EasyTheme",
    ThemeColors = {
        ["Accent1"] = "#463257",
        ["Background"] = "#5e397e",
        ["Accent2"] = "#95724B",
        ["Highlight"] = "#8C0000",
        ["Header"] = "#913535",
        ["MainHover"] = "#5599FF",
        ["MainActive"] = "#267dff",
        ["MainText"] = "#DBCAAE",
        ["Main"] = "#F1D099",
        ["MainActive2"] = "#523c28",
        ["Grey"] = "#696969",
        ["DarkGrey"] = "#505050",
        ["Black1"] = "#242424",
        ["Black2"] = "#0c0c0c",
    }
}
local highContrast = {
    ID = "d67de5a9-727c-4c92-9ec2-2181a56921e4",
    Name = "HighContrast",
    ThemeColors = {
        ["Accent1"] = "#EBEBEB",
        ["Background"] = "#C8C8C8",
        ["Accent2"] = "#505050",
        ["Highlight"] = "#FFFFFF",
        ["Header"] = "#FFFFFF",
        ["MainHover"] = "#1a1a1a",
        ["MainActive"] = "#FFFFFF",
        ["MainText"] = "#000000",
        ["Main"] = "#1a1a1a",
        ["MainActive2"] = "#FFFFFF",
        ["Grey"] = "#696969",
        ["DarkGrey"] = "#505050",
        ["Black1"] = "#7b7b7b",
        ["Black2"] = "#0c0c0c",
    },
}

-- TODO https://venngage.com/tools/accessible-color-palette-generator
local colorBlind1 = {
    ID = "6f530990-f42d-44e3-82cb-ffda22fac4a5",
    Name = "ColorBlind1",
    ThemeColors = {
        ["Accent1"] = "#EBEBEB",
        ["Background"] = "#C8C8C8",
        ["Accent2"] = "#505050",
        ["Highlight"] = "#FFFFFF",
        ["Header"] = "#FFFFFF",
        ["MainHover"] = "#1a1a1a",
        ["MainActive"] = "#FFFFFF",
        ["MainText"] = "#000000",
        ["Main"] = "#1a1a1a",
        ["MainActive2"] = "#FFFFFF",
        ["Grey"] = "#696969",
        ["DarkGrey"] = "#505050",
        ["Black1"] = "#7b7b7b",
        ["Black2"] = "#0c0c0c",
    },
}
local defaultImguiThemes = {
    default,
    skizRed,
    easyTheme,
    highContrast,
    colorBlind1,
}
return defaultImguiThemes