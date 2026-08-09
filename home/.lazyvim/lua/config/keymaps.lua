vim.keymap.set({ "n", "v" }, "<leader>p", function()
	local handle = io.popen("nc -w 2 host.docker.internal 2490")
	if handle then
		local content = handle:read("*a")
		handle:close()
		if content and content ~= "" then
			content = content:gsub("\r\n", "\n")
			local lines = vim.split(content, "\n", { plain = true })
			if #lines > 1 and lines[#lines] == "" then
				table.remove(lines)
			end
			vim.api.nvim_put(lines, "c", true, true)
		else
			vim.notify("クリップボードが空かタイムアウトしました", vim.log.levels.WARN)
		end
	else
		vim.notify("socat ブリッジへの接続に失敗しました", vim.log.levels.ERROR)
	end
end, { desc = "Paste from Host Clipboard" })

vim.keymap.set("v", "<leader>y", function()
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	if text and #text > 0 then
		local pipe = io.popen("nc -w 2 host.docker.internal 2489", "w")
		if pipe then
			pipe:write(text)
			pipe:close()
			vim.notify("Yanked to Host Clipboard!", vim.log.levels.INFO)
		end
	end
end, { desc = "Yank to Host Clipboard", remap = false })
