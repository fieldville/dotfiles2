-- 相対行番号を無効化（絶対行番号のみにする）
vim.opt.relativenumber = false

-- WSL2環境でWindowsクリップボードと共有する設定
if vim.fn.has("wsl") == 1 or vim.fn.executable("clip.exe") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).ToString().Replace("`r", ""))',
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).ToString().Replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end
