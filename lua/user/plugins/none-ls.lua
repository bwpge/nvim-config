local severities = {
    error = vim.lsp.protocol.DiagnosticSeverity.Error,
    warning = vim.lsp.protocol.DiagnosticSeverity.Warning,
    ignored = vim.lsp.protocol.DiagnosticSeverity.Information,
}

---A better `on_output` function for staticcheck, since most diagnostics return
---with end line/col at 0:0.
---@param line string
---@return table
local function staticcheck_on_output(line)
    local decoded = vim.json.decode(line)
    local end_row = decoded["end"]["line"]
    local end_col = decoded["end"]["column"]

    -- 0:0 end location creates weird diagnostics that span the whole screen
    if end_row == 0 and end_col == 0 then
        end_row = decoded.location.line
        end_col = decoded.location.column
    end

    return {
        row = decoded.location.line,
        col = decoded.location.column,
        end_row = end_row,
        end_col = end_col,
        source = "staticcheck",
        code = decoded.code,
        message = decoded.message,
        severity = severities.warning,
        filename = decoded.location.file,
    }
end

return {
    {
        "nvimtools/none-ls.nvim",
        event = "LazyFile",
        opts = function()
            local staticcheck = require("null-ls").builtins.diagnostics.staticcheck
            staticcheck._opts.on_output = staticcheck_on_output

            return {
                sources = { staticcheck },
            }
        end,
    },
}
