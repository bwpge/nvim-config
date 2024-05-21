local dapui_keys = {
    {
        "<leader>du",
        function()
            require("dapui").toggle({})
        end,
        desc = "Debug: Toggle UI",
    },
    {
        "<leader>de",
        function()
            require("dapui").eval()
        end,
        desc = "Debug: Evaluate Expression",
        mode = { "n", "v" },
    },
}

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            dependencies = { "nvim-neotest/nvim-nio" },
            keys = dapui_keys,
            opts = {},
            config = function(_, opts)
                -- setup dap config by VsCode launch.json file
                -- require("dap.ext.vscode").load_launchjs()
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup(opts)
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open({})
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close({})
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close({})
                end
            end,
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
        },
        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = "mason.nvim",
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                automatic_installation = true,
                ensure_installed = {
                    "delve",
                    "python",
                },
            },
        },
        {
            "leoluz/nvim-dap-go",
            dependencies = "mason-nvim-dap.nvim",
            config = function()
                -- delve installed by mason doesn't get found in path
                require("dap-go").setup({
                    delve = {
                        path = vim.fn.exepath("dlv"),
                        detached = vim.fn.has("win32") == 0,
                        args = { "." },
                    },
                })
            end,
        },
    },
    keys = {
        {
            "<F5>",
            function()
                require("dap").continue()
            end,
            desc = "Debug: Start/Continue",
        },
        {
            "<F6>",
            function()
                require("dap").step_over()
            end,
            desc = "Debug: Step Over",
        },
        {
            "<F7>",
            function()
                require("dap").step_into()
            end,
            desc = "Debug: Step Into",
        },
        {
            "<F8>",
            function()
                require("dap").step_out()
            end,
            desc = "Debug: Step Out",
        },
        {
            "<F9>",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Debug: toggle breakpoint",
        },
        {
            "<S-F9>",
            function()
                vim.ui.input({ prompt = "Enter breakpoint condition:" }, function(x)
                    require("dap").set_breakpoint(x)
                end)
            end,
            desc = "Debug: toggle conditional breakpoint",
        },
        {
            "<leader>dq",
            function()
                require("dap").terminate()
            end,
            desc = "Debug: Stop",
        },
    },

    config = function()
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

        local icons = {
            Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
            Breakpoint = { " ", "DiagnosticError" },
            BreakpointCondition = " ",
            BreakpointRejected = { " ", "DiagnosticError" },
            LogPoint = ".>",
        }
        for name, sign in pairs(icons) do
            sign = type(sign) == "table" and sign or { sign } --[[@as table]]
            vim.fn.sign_define("Dap" .. name, {
                text = sign[1],
                texthl = sign[2] or "DiagnosticInfo",
                linehl = sign[3],
                numhl = sign[3],
            })
        end
    end,
}
