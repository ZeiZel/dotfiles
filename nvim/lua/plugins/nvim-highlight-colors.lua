return {
	"brenoprata10/nvim-highlight-colors",
	event = "VeryLazy",
	config = function()
		vim.opt.termguicolors = true

		require("nvim-highlight-colors").setup({
			enable_var_usage = false,
			-- Project color | TODO: Find a way to link/load that for a specefic project.

			-- !! PROMPT CHAT GPT !!
			-- Il faudra convertir l'objet json suivant: {PASTE json color du projet}
			-- Dans un format qui doit ressemble à l'exemple suivant: {PASTE custom_colors}
			-- Sort moi la liste complète et n'arrête pas tant que ce n'est pas terminé.

			custom_colors = {
				{ label = "bg%-accent", color = "#3D27C2FF" },
				{ label = "bg%-accent%-inverted", color = "#3D27C2FF" },
				{ label = "bg%-accent%-keep", color = "#3D27C2FF" },
				{ label = "bg%-accent%-keep%-inverted", color = "#3D27C2FF" },
				{ label = "bg%-elevated%-primary", color = "#FFFDF7FF" },
				{ label = "bg%-elevated%-primary%-inverted", color = "#19191CFF" },
				{ label = "bg%-elevated%-primary%-keep", color = "#FFFDF7FF" },
				{ label = "bg%-elevated%-primary%-keep%-inverted", color = "#19191CFF" },
				{ label = "bg%-elevated%-secondary", color = "#FFFBE9FF" },
				{ label = "bg%-elevated%-secondary%-inverted", color = "#1F1F25FF" },
				{ label = "bg%-elevated%-secondary%-keep", color = "#FFFBE9FF" },
				{ label = "bg%-elevated%-secondary%-keep%-inverted", color = "#1F1F25FF" },
				{ label = "bg%-elevated%-tertiary", color = "#FFFDF7FF" },
				{ label = "bg%-elevated%-tertiary%-inverted", color = "#26262EFF" },
				{ label = "bg%-elevated%-tertiary%-keep", color = "#FFFDF7FF" },
				{ label = "bg%-elevated%-tertiary%-keep%-inverted", color = "#26262EFF" },
				{ label = "bg%-primary", color = "#FFFDF7FF" },
				{ label = "bg%-primary%-inverted", color = "#131313FF" },
				{ label = "bg%-primary%-keep", color = "#FFFDF7FF" },
				{ label = "bg%-primary%-keep%-inverted", color = "#131313FF" },
				{ label = "bg%-secondary", color = "#FFFBE9FF" },
				{ label = "bg%-secondary%-inverted", color = "#19191CFF" },
				{ label = "bg%-secondary%-keep", color = "#FFFBE9FF" },
				{ label = "bg%-secondary%-keep%-inverted", color = "#19191CFF" },
				{ label = "bg%-tertiary", color = "#FFFDF7FF" },
				{ label = "bg%-tertiary%-inverted", color = "#1F1F25FF" },
				{ label = "bg%-tertiary%-keep", color = "#FFFDF7FF" },
				{ label = "bg%-tertiary%-keep%-inverted", color = "#1F1F25FF" },
				{ label = "border%-accent", color = "#3D27C2FF" },
				{ label = "border%-accent%-inverted", color = "#979DFFFF" },
				{ label = "border%-accent%-keep", color = "#3D27C2FF" },
				{ label = "border%-accent%-keep%-inverted", color = "#979DFFFF" },
				{ label = "border%-contrast%-max", color = "#131313FF" },
				{ label = "border%-contrast%-max%-2", color = "#131313FF" },
				{ label = "border%-contrast%-max%-2%-inverted", color = "#393A3FFF" },
				{ label = "border%-contrast%-max%-2%-keep", color = "#131313FF" },
				{ label = "border%-contrast%-max%-2%-keep%-inverted", color = "#393A3FFF" },
				{ label = "border%-contrast%-max%-inverted", color = "#FCFBFFFF" },
				{ label = "border%-contrast%-max%-keep", color = "#131313FF" },
				{ label = "border%-contrast%-max%-keep%-inverted", color = "#FCFBFFFF" },
				{ label = "border%-contrast%-mid", color = "#BBBAC1FF" },
				{ label = "border%-contrast%-mid%-inverted", color = "#5F606AFF" },
				{ label = "border%-contrast%-mid%-keep", color = "#BBBAC1FF" },
				{ label = "border%-contrast%-mid%-keep%-inverted", color = "#5F606AFF" },
				{ label = "border%-error", color = "#FF2123FF" },
				{ label = "border%-error%-inverted", color = "#FF7B6AFF" },
				{ label = "border%-error%-keep", color = "#FF2123FF" },
				{ label = "border%-error%-keep%-inverted", color = "#FF7B6AFF" },
				{ label = "border%-success", color = "#259E4DFF" },
				{ label = "border%-success%-inverted", color = "#62D37FFF" },
				{ label = "border%-success%-keep", color = "#259E4DFF" },
				{ label = "border%-success%-keep%-inverted", color = "#62D37FFF" },
				{ label = "btn%-primary", color = "#FFCD1FFF" },
				{ label = "btn%-primary%-disabled", color = "#BBBAC1FF" },
				{ label = "btn%-primary%-disabled%-inverted", color = "#6C6E79FF" },
				{ label = "btn%-primary%-disabled%-keep", color = "#BBBAC1FF" },
				{ label = "btn%-primary%-disabled%-keep%-inverted", color = "#6C6E79FF" },
				{ label = "btn%-primary%-hover", color = "#F8D477FF" },
				{ label = "btn%-primary%-hover%-inverted", color = "#F8D477FF" },
				{ label = "btn%-primary%-hover%-keep", color = "#F8D477FF" },
				{ label = "btn%-primary%-hover%-keep%-inverted", color = "#F8D477FF" },
				{ label = "btn%-primary%-inverted", color = "#F5C32CFF" },
				{ label = "btn%-primary%-keep", color = "#FFCD1FFF" },
				{ label = "btn%-primary%-keep%-inverted", color = "#F5C32CFF" },
				{ label = "btn%-primary%-pressed", color = "#F8D477FF" },
				{ label = "btn%-primary%-pressed%-inverted", color = "#F8D477FF" },
				{ label = "btn%-primary%-pressed%-keep", color = "#F8D477FF" },
				{ label = "btn%-primary%-pressed%-keep%-inverted", color = "#F8D477FF" },
				{ label = "btn%-secondary", color = "#3D27C2FF" },
				{ label = "btn%-secondary%-disabled", color = "#BBBAC1FF" },
				{ label = "btn%-secondary%-disabled%-inverted", color = "#6C6E79FF" },
				{ label = "btn%-secondary%-hover", color = "#3205ADFF" },
				{ label = "btn%-secondary%-hover%-inverted", color = "#3204AEFF" },
				{ label = "btn%-secondary%-pressed", color = "#3205ADFF" },
				{ label = "btn%-secondary%-pressed%-inverted", color = "#3204AEFF" },
				{ label = "ctn%-accent", color = "#514DD8FF" },
				{ label = "ctn%-accent%-2", color = "#D59856FF" },
				{ label = "ctn%-accent%-2%-inverted", color = "#D59856FF" },
				{ label = "ctn%-accent%-2%-keep", color = "#D59856FF" },
				{ label = "ctn%-accent%-2%-keep%-inverted", color = "#D59856FF" },
				{ label = "ctn%-accent%-3", color = "#FFEB9DFF" },
				{ label = "ctn%-accent%-3%-inverted", color = "#26262EFF" },
				{ label = "ctn%-accent%-3%-keep", color = "#FFEB9DFF" },
				{ label = "ctn%-accent%-3%-keep%-inverted", color = "#26262EFF" },
				{ label = "ctn%-accent%-inverted", color = "#3D27C2FF" },
				{ label = "ctn%-accent%-keep", color = "#3D27C2FF" },
				{ label = "ctn%-accent%-keep%-inverted", color = "#3D27C2FF" },
				{ label = "ctn%-error", color = "#FF2123FF" },
				{ label = "ctn%-error%-inverted", color = "#FF2123FF" },
				{ label = "ctn%-error%-keep", color = "#FF2123FF" },
				{ label = "ctn%-error%-keep%-inverted", color = "#FF2123FF" },
				{ label = "ctn%-error%-light", color = "#FFD9D1FF" },
				{ label = "ctn%-error%-light%-inverted", color = "#580204FF" },
				{ label = "ctn%-error%-light%-keep", color = "#FFD9D1FF" },
				{ label = "ctn%-error%-light%-keep%-inverted", color = "#580204FF" },
				{ label = "ctn%-neutral", color = "#E8E7F0FF" },
				{ label = "ctn%-neutral%-inverted", color = "#26262EFF" },
				{ label = "ctn%-neutral%-keep", color = "#E8E7F0FF" },
				{ label = "ctn%-neutral%-keep%-inverted", color = "#26262EFF" },
				{ label = "ctn%-success", color = "#57BC71FF" },
				{ label = "ctn%-success%-hard", color = "#08813AFF" },
				{ label = "ctn%-success%-hard%-inverted", color = "#62D37FFF" },
				{ label = "ctn%-success%-hard%-keep", color = "#08813AFF" },
				{ label = "ctn%-success%-hard%-keep%-inverted", color = "#62D37FFF" },
				{ label = "ctn%-success%-inverted", color = "#357C48FF" },
				{ label = "ctn%-success%-keep", color = "#57BC71FF" },
				{ label = "ctn%-success%-keep%-inverted", color = "#357C48FF" },
				{ label = "ctn%-warning", color = "#F76C14FF" },
				{ label = "ctn%-warning%-inverted", color = "#F76C14FF" },
				{ label = "ctn%-warning%-keep", color = "#F76C14FF" },
				{ label = "ctn%-warning%-keep%-inverted", color = "#F76C14FF" },
				{ label = "icon%-accent", color = "#3D27C2FF" },
				{ label = "icon%-accent%-inverted", color = "#979DFFFF" },
				{ label = "icon%-accent%-keep", color = "#3D27C2FF" },
				{ label = "icon%-accent%-keep%-inverted", color = "#979DFFFF" },
				{ label = "icon%-disable", color = "#8D8C91FF" },
				{ label = "icon%-disable%-inverted", color = "#47484FFF" },
				{ label = "icon%-disable%-keep", color = "#8D8C91FF" },
				{ label = "icon%-disable%-keep%-inverted", color = "#47484FFF" },
				{ label = "icon%-primary", color = "#131313FF" },
				{ label = "icon%-primary%-inverted", color = "#FCFBFFFF" },
				{ label = "icon%-primary%-keep", color = "#131313FF" },
				{ label = "icon%-primary%-keep%-inverted", color = "#FCFBFFFF" },
				{ label = "txt%-accent", color = "#3D27C2FF" },
				{ label = "txt%-accent%-inverted", color = "#979DFFFF" },
				{ label = "txt%-accent%-keep", color = "#3D27C2FF" },
				{ label = "txt%-accent%-keep%-inverted", color = "#979DFFFF" },
				{ label = "txt%-error", color = "#E20000FF" },
				{ label = "txt%-error%-inverted", color = "#FF7B6AFF" },
				{ label = "txt%-error%-keep", color = "#E20000FF" },
				{ label = "txt%-error%-keep%-inverted", color = "#FF7B6AFF" },
				{ label = "txt%-inactif", color = "#8D8C91FF" },
				{ label = "txt%-inactif%-inverted", color = "#47484FFF" },
				{ label = "txt%-inactif%-keep", color = "#8D8C91FF" },
				{ label = "txt%-inactif%-keep%-inverted", color = "#47484FFF" },
				{ label = "txt%-primary", color = "#131313FF" },
				{ label = "txt%-primary%-inverted", color = "#FCFBFFFF" },
				{ label = "txt%-primary%-keep", color = "#131313FF" },
				{ label = "txt%-primary%-keep%-inverted", color = "#FCFBFFFF" },
				{ label = "txt%-secondary", color = "#19191CFF" },
				{ label = "txt%-secondary%-inverted", color = "#E8E7F0FF" },
				{ label = "txt%-secondary%-keep", color = "#19191CFF" },
				{ label = "txt%-secondary%-keep%-inverted", color = "#E8E7F0FF" },
				{ label = "txt%-success", color = "#08813AFF" },
				{ label = "txt%-success%-inverted", color = "#62D37FFF" },
				{ label = "txt%-success%-keep", color = "#08813AFF" },
				{ label = "txt%-success%-keep%-inverted", color = "#62D37FFF" },
			},
		})
	end,
}
