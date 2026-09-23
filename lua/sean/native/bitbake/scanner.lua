local M = {}

local extensions = {
    bbclass = "_classes",
    inc = "_includes",
    bb = "_recipes",
    conf = "_confFiles",
}

---Resolve ${VAR} placeholders in a string using the given variables.
---@param s string
---@param variables table<string, string>
---@return string
local function resolve_variables(s, variables)
    return (s:gsub("%${([^}]+)}", function(name)
        local value = variables[name]
        if value then
            return value
        end
        return "${" .. name .. "}"
    end))
end

---Find the project root by walking up for a directory containing bblayers.conf.
---Accepts <root>/build/conf/bblayers.conf or <root>/conf/bblayers.conf.
---@param start string Absolute path to start from (a directory)
---@return string|nil, string|nil # root, buildDir
function M.detect(start)
    local current = vim.fs.normalize(start)
    local seen = {}

    while current and current ~= "/" and not seen[current] do
        seen[current] = true
        local buildConf = current .. "/build/conf/bblayers.conf"
        local conf = current .. "/conf/bblayers.conf"

        if vim.fn.filereadable(buildConf) == 1 then
            return current, current .. "/build"
        elseif vim.fn.filereadable(conf) == 1 then
            return current, current
        end

        current = vim.fs.dirname(current)
    end

    return nil, nil
end

---Parse BBLAYERS from bblayers.conf, handling multi-line `\` continuations.
---@param buildDir string
---@return string[] layerPaths absolute paths
function M.parse_layers(buildDir)
    local confFile = buildDir .. "/conf/bblayers.conf"
    if vim.fn.filereadable(confFile) ~= 1 then
        return {}
    end

    local lines = vim.fn.readfile(confFile)
    local variables = {
        ["TOPDIR"] = buildDir,
        ["BSPDIR"] = buildDir,
    }

    -- Collect the BBLAYERS assignment, joining continuation lines.
    local raw = {}
    local in_bblayers = false
    for _, line in ipairs(lines) do
        if not in_bblayers then
            local start = line:match("^%s*BBLAYERS%s*%??=%s*(.*)$")
            if start then
                in_bblayers = true
                raw[#raw + 1] = start
            end
        else
            raw[#raw + 1] = line
        end
        if in_bblayers and not line:match("\\%s*$") then
            in_bblayers = false
        end
    end

    if #raw == 0 then
        return {}
    end

    local joined = table.concat(raw, " ")
    -- Strip enclosing double quotes
    joined = joined:match('^%s*"(.*)"%s*$') or joined

    local layers = {}
    for token in joined:gmatch("%S+") do
        if token:sub(1, 1) ~= "#" and token ~= "\\" then
            layers[#layers + 1] = token
        end
    end

    local resolved = {}
    for _, layer in ipairs(layers) do
        local abs = vim.fn.fnamemodify(resolve_variables(layer, variables), ":p")
        abs = vim.fn.resolve(abs)
        resolved[#resolved + 1] = abs
    end

    return resolved
end

---Recursively collect files by extension under a directory (async).
---@param dir string
---@param ext string e.g. "bbclass"
---@param on_exit fun(paths: string[])
local function collect_files(dir, ext, on_exit)
    vim.system(
        { "find", dir, "-type", "f", "-name", "*." .. ext },
        { text = true },
        function(out)
            local paths = {}
            if out.stdout then
                for line in out.stdout:gmatch("[^\r\n]+") do
                    paths[#paths + 1] = line
                end
            end
            on_exit(paths)
        end
    )
end

---Build an ElementInfo from an absolute file path.
---@param path string
---@param layerPath string|nil
---@return table
local function element_info(path, layerPath)
    local dir, base = vim.fn.fnamemodify(path, ":h"), vim.fn.fnamemodify(path, ":t")
    local name = base:match("^(.*)%.[^.]+$") or base
    return {
        name = name,
        path = {
            dir = dir,
            base = base,
        },
        layerInfo = layerPath and { path = layerPath } or nil,
    }
end

---Scan the project and produce a BitbakeScanResult-shaped table.
---@param buildDir string
---@param layers string[]
---@param on_complete fun(result: table)
function M.scan(buildDir, layers, on_complete)
    local result = {
        _layers = {},
        _classes = {},
        _includes = {},
        _recipes = {},
        _overrides = {},
        _confFiles = {},
        _workspaces = {},
        _bitbakeVersion = "",
    }

    local bitbakeInit = buildDir .. "/layers/bitbake/lib/bb/__init__.py"
    if vim.fn.filereadable(bitbakeInit) == 1 then
        for _, line in ipairs(vim.fn.readfile(bitbakeInit)) do
            local version = line:match("^__version__%s*=%s*[\"']([^\"']+)[\"']")
            if version then
                result._bitbakeVersion = version
                break
            end
        end
    end

    local pending = 0
    local finished = false

    local function finish()
        if not finished then
            finished = true
            on_complete(result)
        end
    end

    for _, layer in ipairs(layers) do
        local layerInfo = {
            name = vim.fn.fnamemodify(layer, ":t"),
            path = layer,
            priority = 0,
        }
        result._layers[#result._layers + 1] = layerInfo

        for _, ext in ipairs({ "bbclass", "inc", "bb", "conf" }) do
            pending = pending + 1
            collect_files(layer, ext, function(paths)
                local list = result[extensions[ext]]
                for _, p in ipairs(paths) do
                    list[#list + 1] = element_info(p, layer)
                end
                pending = pending - 1
                if pending == 0 then
                    finish()
                end
            end)
        end
    end

    if pending == 0 then
        finish()
    end
end

return M