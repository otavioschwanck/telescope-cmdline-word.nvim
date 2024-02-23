local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local config = require("telescope-cmdline-word.config")

M.picker_options = {
	prompt_title = "Find Word to Insert on cmdline",
}

local before_substitute_text = ""
local cursor_position = 0

local function cancel_selection()
	local go_back = #before_substitute_text - cursor_position

	vim.fn.feedkeys(":" .. before_substitute_text)

	if go_back > 0 then
		vim.api.nvim_input(string.rep("<Left>", go_back + 1))
	end
end

local function add_selection(selection)
	local first_part_selection = before_substitute_text:sub(1, cursor_position - 1)
	local second_part_selection = before_substitute_text:sub(cursor_position, #before_substitute_text)

	local go_back = #before_substitute_text - cursor_position

	if selection then
		vim.fn.feedkeys(":" .. first_part_selection .. selection .. second_part_selection)

		if go_back > 0 then
			vim.api.nvim_input(string.rep("<Left>", go_back + 1))
		end

		vim.api.nvim_input("<space>")
		vim.api.nvim_input("<BS>")
	else
		vim.api.nvim_input(":" .. before_substitute_text)
	end
end

function M.find_word()
	before_substitute_text = vim.fn.getcmdline()

	local ok = false
	local test_strings = config.getState("enabled_regexp")

	print(vim.inspect(test_strings))

	for _, pattern in ipairs(test_strings) do
		if before_substitute_text:find(pattern) then
			ok = true
			break
		end
	end

	if ok then
		vim.api.nvim_input("<esc>")

		cursor_position = vim.fn.getcmdpos()

		local words = config.getState("find_word_function")()

		M.find_word_picker(words)
	else
		vim.api.nvim_input(config.getState("wildchar_new_map"))
	end
end

function M.find_word_picker(words)
	vim.schedule(function()
		local picker_opts = config.getState("picker_options")

		picker_opts.finder = finders.new_table({
			results = words,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry,
					ordinal = entry,
				}
			end,
		})

		picker_opts.sorter = conf.generic_sorter({})
		picker_opts.previewer = conf.file_previewer({})
		picker_opts.attach_mappings = function(prompt_bufnr, map)
			map("i", "<Esc>", function()
				actions.close(prompt_bufnr)

				cancel_selection()
			end)

			map("n", "<Esc>", function()
				actions.close(prompt_bufnr)

				cancel_selection()
			end)

			map("i", "<C-c>", function()
				actions.close(prompt_bufnr)

				cancel_selection()
			end)

			map("i", "<C-f>", function()
				actions.close(prompt_bufnr)

				local selection = action_state.get_selected_entry().value

				if selection then
					add_selection("\\<" .. selection .. "\\>")
				else
					add_selection(nil)
				end
			end)

			actions.select_default:replace(function()
				actions.close(prompt_bufnr)

				add_selection(action_state.get_selected_entry().value)
			end)

			return true
		end

		if not (config.getState("dont_use_ivy_theme")) then
			picker_opts = require("telescope.themes").get_ivy(picker_opts)
			picker_opts.previewer = false
			picker_opts.layout_config = {
				height = 12,
			}
		end

		pickers.new({}, picker_opts):find()
	end)
end

return M
