local colorscheme = "PaperColor"
local ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
vim.o.background = "light" -- or "light" for light mode
if not ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
