-- autosave files
return {
	{
		"okuuva/auto-save.nvim",
		cmd = "ASToggle",                   -- optional for lazy loading on command
		event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
		opts = {
			enabled = true,                 -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
			execution_message = {
				enabled = true,
				message = function() -- message to print on save
					return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
				end,
				dim = 0.18,                        -- dim the color of `message`
				cleaning_interval = 1250,          -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
			},
			trigger_events = {                     -- See :h events
				immediate_save = { "BufLeave", "FocusLost" }, -- vim events that trigger an immediate save
				defer_save = { "InsertLeave", "TextChanged" }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
				cancel_defered_save = { "InsertEnter" }, -- vim events that cancel a pending deferred save
			},
			condition = nil,
			write_all_buffers = true, -- write all buffers when the current one meets `condition`
			noautocmd = true, -- do not execute autocmds when saving
			lockmarks = true, -- lock marks when saving, see `:h lockmarks` for more details
		},
	},
}
