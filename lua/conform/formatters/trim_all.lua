return {
    meta = {
        description = "Trim trailing whitespace and empty lines at the end of the file.",
    },
    format = function(_, _, lines, callback)
        local out_lines = {}
        for _, line in ipairs(lines) do
            local trimmed = line:gsub("%s+$", "")
            table.insert(out_lines, trimmed)
        end

        while #out_lines > 0 and out_lines[#out_lines] == "" do
            table.remove(out_lines)
        end

        callback(nil, out_lines)
    end,
}
