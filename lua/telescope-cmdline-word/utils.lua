local M = {}

function M.join_two_arrays(tableA, tableB)
	local newTable = {}

	for _, v in ipairs(tableA) do
		table.insert(newTable, v)
	end

	for _, v in ipairs(tableB) do
		table.insert(newTable, v)
	end

	return newTable
end

return M
