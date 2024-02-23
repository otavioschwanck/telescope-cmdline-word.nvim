local M = {}

local config = require("telescope-cmdline-word.config")
local picker = require("telescope-cmdline-word.picker")
local find_word = require("telescope-cmdline-word.find_word")
local utils = require("telescope-cmdline-word.utils")

local enabled_regexp = {
	"^%s*%d*%,?%d*[,%%<'>]*substitute/",
	"^%s*%d*%,?%d*[,%%<'>]*s/",
	"^%s*%d*%,?%d*[,%%<'>]*g/",
	"^%s*%d*%,?%d*[,%%<'>]*%global/",
}

function M.setup(opts)
	opts = opts or {}

	config.setState("find_word_function", opts.find_word_function or find_word.find_word)
	config.setState("picker_options", opts.picker_options or picker.picker_options)
	config.setState("wildchar_new_map", opts.wildchar_new_map or "<C-t>")
	config.setState("enabled_regexp", utils.join_two_arrays(enabled_regexp, opts.enabled_regexp or {}))
	config.setState("dont_use_ivy_theme", opts.dont_use_ivy_theme or false)

	vim.cmd("set wildchar=" .. (opts.wildchar_new_map or "<C-t>"))

	if opts.add_mappings then
		vim.keymap.set("c", opts.wildchar_map or "<tab>", picker.find_word, { silent = true, noremap = true })
	end
end

return M
