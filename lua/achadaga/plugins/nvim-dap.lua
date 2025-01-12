return {
  "mfussenegger/nvim-dap",
  dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
  config = function()
    local dap = require("dap")
    local widgets = require("dap.ui.widgets")
    vim.keymap.set("n", "<F5>", function()
      dap.continue()
    end)
    vim.keymap.set("n", "<F10>", function()
      dap.step_over()
    end)
    vim.keymap.set("n", "<F11>", function()
      dap.step_into()
    end)
    vim.keymap.set("n", "<F12>", function()
      dap.step_out()
    end)
    vim.keymap.set("n", "<Leader>b", function()
      dap.toggle_breakpoint()
    end)
    vim.keymap.set("n", "<Leader>B", function()
      dap.set_breakpoint()
    end)
    vim.keymap.set("n", "<Leader>lp", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end)
    vim.keymap.set("n", "<Leader>dr", function()
      dap.repl.open()
    end)
    vim.keymap.set("n", "<Leader>dl", function()
      dap.run_last()
    end)
    vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
      dap.hover()
    end)
    vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
      dap.preview()
    end)
    vim.keymap.set("n", "<Leader>df", function()
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set("n", "<Leader>ds", function()
      widgets.centered_float(widgets.scopes)
    end)

    dapui = require("dap")
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- python
  end,
}
