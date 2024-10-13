---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "radium",

transparency = false,
  statusline = {
    theme = "vscode_colored",
  },
nvdash = {
	load_on_startup = true,

	header = {
		"           ",
		"           ",
		"           ",
		"           ",
		"           ",
		"  ⟋|､      ",
		" (°､ ｡ 7   ",
		" |､  ~ヽ   ",
		" じしf_,)〳",
	},

	buttons = {
		{ "  Projects", "", "Telescope projects" },
		{ "  Themes  ", "", "Telescope themes" },
		{ "  Mappings", "", "NvCheatsheet" },
	},
},
  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
    DiffChange = {
      bg = "#464414",
      fg = "none",
    },
    DiffAdd = {
      bg = "#103507",
      fg = "none",
    },
    DiffRemoved = {
      bg = "#461414",
      fg = "none",
    },
  },
}

return M
