return {
	{
		"amitds1997/remote-nvim.nvim",
		version = "*",
		config = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = {
			"RemoteCleanup",
			"RemoteConfigDel",
			"RemoteInfo",
			"RemoteLog",
			"RemoteStart",
			"RemoteStop",
		},
	},
}
