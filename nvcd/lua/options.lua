require "nvchad.options"

-- основные знаки, которыми будут подсвечиваться сообщения
local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
-- логика использования иконок
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

