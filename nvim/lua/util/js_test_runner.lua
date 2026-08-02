local M = {}

local excluded_directories = {
	[".git"] = true,
	[".nx"] = true,
	coverage = true,
	dist = true,
	node_modules = true,
}

local test_extensions = {
	coffee = true,
	js = true,
	jsx = true,
	ts = true,
	tsx = true,
}

---@param package table
---@return "jest"|"vitest"?
local function runner_from_package(package)
	local has_jest = package.jest ~= nil
	local has_vitest = false
	for _, section in ipairs({ "dependencies", "devDependencies" }) do
		for name in pairs(type(package[section]) == "table" and package[section] or {}) do
			has_jest = has_jest or name == "jest" or name == "react-scripts"
			has_vitest = has_vitest or name == "vitest" or vim.startswith(name, "@vitest/")
		end
	end

	local script_has_jest = false
	local script_has_vitest = false
	for _, command in pairs(type(package.scripts) == "table" and package.scripts or {}) do
		if type(command) == "string" then
			script_has_jest = script_has_jest
				or command:find("jest", 1, true) ~= nil
				or (
					command:find("react-scripts", 1, true) ~= nil
					and command:find("test", 1, true) ~= nil
				)
			script_has_vitest = script_has_vitest or command:find("vitest", 1, true) ~= nil
		end
	end

	if (has_vitest or script_has_vitest) and not (has_jest or script_has_jest) then
		return "vitest"
	end
	if (has_jest or script_has_jest) and not (has_vitest or script_has_vitest) then
		return "jest"
	end
	if script_has_vitest ~= script_has_jest then
		return script_has_vitest and "vitest" or "jest"
	end
	if has_vitest and has_jest then
		-- A project that intentionally carries both runners can disambiguate
		-- with the nearest explicit config. Vitest is the stable fallback.
		return "vitest"
	end
end

---@async
---@param file_path string
---@return "jest"|"vitest"?, string?
local function package_runner(file_path)
	local files = require("neotest.lib").files
	local root = files.match_root_pattern("package.json")(file_path)
	if not root then
		return nil
	end
	local ok, contents = pcall(files.read, vim.fs.joinpath(root, "package.json"))
	if not ok then
		return nil, root
	end
	local decoded, package = pcall(vim.json.decode, contents)
	if not decoded or type(package) ~= "table" then
		return nil, root
	end
	return runner_from_package(package), root
end

---@async
---@param file_path string?
---@return "jest"|"vitest"?
function M.select(file_path)
	if not file_path then
		return nil
	end
	local files = require("neotest.lib").files
	local package_choice, package_root = package_runner(file_path)
	local jest_root = files.match_root_pattern("jest.config.*")(file_path)
	local vitest_root = files.match_root_pattern("vitest.config.*")(file_path)

	local best_runner
	local best_root = ""
	local best_priority = 0
	local function consider(root, runner, priority)
		if not root then
			return
		end
		if #root > #best_root or (#root == #best_root and priority > best_priority) then
			best_root = root
			best_runner = runner
			best_priority = priority
		elseif #root == #best_root and priority == best_priority and runner == "vitest" then
			best_runner = runner
		end
	end

	consider(package_root and package_choice and package_root or nil, package_choice, 1)
	consider(jest_root, "jest", 2)
	consider(vitest_root, "vitest", 2)
	return best_runner
end

---@param file_path string?
---@return boolean
function M.is_test_file(file_path)
	if not file_path or not test_extensions[file_path:match("%.([^.]+)$")] then
		return false
	end
	if file_path:find("/__tests__/", 1, true) then
		return true
	end
	for _, kind in ipairs({
		"e2e",
		"e2e%-spec",
		"integration",
		"regression",
		"spec",
		"test",
		"unit",
	}) do
		if file_path:match("%." .. kind .. "%.[^.]+$") then
			return true
		end
	end
	return false
end

---@param name string
---@return boolean
function M.filter_dir(name)
	return not excluded_directories[name]
end

return M
