vim.keymap.set({ "n", "v" }, "<leader>p", function()
	local handle = io.popen("nc -w 1 host.docker.internal 2490")
	if handle then
		local content = handle:read("*a")
		handle:close()
		if content and content ~= "" then
			-- 改行コードの調整（CRLF -> LF）
			content = content:gsub("\r\n", "\n")
			-- 無名レジスタ ("") に格納して貼り付け
			vim.fn.setreg('"', content)
			vim.cmd('normal! ""p')
		end
	end
end, { desc = "Paste from Host Clipboard" })

vim.keymap.set("v", "<leader>y", function()
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	if text and #text > 0 then
		local pipe = io.popen("nc -w 1 host.docker.internal 2489", "w")
		if pipe then
			pipe:write(text)
			pipe:close()
			vim.notify("Yanked to Host Clipboard!", vim.log.levels.INFO)
		end
	end
end, { desc = "Yank to Host Clipboard", remap = false })
