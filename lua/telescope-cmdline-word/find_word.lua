local M = {}

function M.find_word()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	local words = {}

	for _, line in ipairs(lines) do
		for word in string.gmatch(line, "%w+[_%w]*%w+") do
			words[word] = true
		end

		for word in line:gmatch("[%w_]+%.") do
			words[word:sub(1, -2)] = true
		end
	end

	return vim.tbl_keys(words)
end

return M
