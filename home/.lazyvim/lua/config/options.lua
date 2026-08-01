-- 相対行番号を無効化（絶対行番号のみにする）
vim.opt.relativenumber = false

vim.opt.clipboard = ""

vim.g.clipboard = {
  name = "socat-bridge",
  copy = {
    ["+"] = "nc -w 1 host.docker.internal 2489",
    ["*"] = "nc -w 1 host.docker.internal 2489",
  },
  paste = {
    ["+"] = "true",
    ["*"] = "true",
  },
  cache_enabled = 1,
}
