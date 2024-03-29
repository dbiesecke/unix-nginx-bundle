-- Copyright (C) 2012 Yichun Zhang (agentzh)


local sub = string.sub
local req_socket = ngx.req.socket
local insert = table.insert
local concat = table.concat
local len = string.len
local null = ngx.null
local match = string.match
local setmetatable = setmetatable
local error = error
local get_headers = ngx.req.get_headers
-- local print = print


module(...)

_VERSION = '0.06'


local MAX_LINE_SIZE = 512

local STATE_BEGIN = 1
local STATE_READING_HEADER = 2
local STATE_READING_BODY = 3
local STATE_EOF = 4


local mt = { __index = _M }

local state_handlers


local function get_boundary()
    local header = get_headers()["content-type"]
    if not header then
        return nil
    end

    local m = match(header, ";%s+boundary=\"([^\"]+)\"")
    if m then
        return m
    end

    return match(header, ";%s+boundary=([^\",;]+)")
end


function new(self, chunk_size)
    local boundary = get_boundary()

    -- print("boundary: ", boundary)

    if not boundary then
        return nil, "no boundary defined in Content-Type"
    end

    -- print('boundary: "', boundary, '"')

    local sock, err = req_socket()
    if not sock then
        return nil, err
    end

    local read2boundary, err = sock:receiveuntil("--" .. boundary)
    if not read2boundary then
        return nil, err
    end

    local read_line, err = sock:receiveuntil("\r\n")
    if not read_line then
        return nil, err
    end

    return setmetatable({
        sock = sock,
        size = chunk_size or 4096,
        read2boundary = read2boundary,
        read_line = read_line,
        boundary = boundary,
        state = STATE_BEGIN
    }, mt)
end


function set_timeout(self, timeout)
    local sock = self.sock
    if not sock then
        return nil, "not initialized"
    end

    return sock:settimeout(timeout)
end


local function discard_line(self)
    local read_line = self.read_line

    local line, err = self.read_line(MAX_LINE_SIZE)
    if not line then
        return nil, err
    end

    local dummy, err = self.read_line(1)
    if dummy then
        return nil, concat({"line too long: ", line, dummy, "..."}, "")
    end

    if err then
        return nil, err
    end

    return 1
end


local function discard_rest(self)
    local sock = self.sock
    local size = self.size

    while true do
        local dummy, err = sock:receive(size)
        if err and err ~= 'closed' then
            return nil, err
        end

        if not dummy then
            return 1
        end
    end
end


local function read_body_part(self)
    local read2boundary = self.read2boundary

    local chunk, err = read2boundary(self.size)
    if err then
        return nil, nil, err
    end

    if not chunk then
        local sock = self.sock

        local data = sock:receive(2)
        if data == "--" then
            local ok, err = discard_rest(self)
            if not ok then
                return nil, nil, err
            end

            self.state = STATE_EOF
            return "part_end"
        end

        if data ~= "\r\n" then
            local ok, err = discard_line(self)
            if not ok then
                return nil, nil, err
            end
        end

        self.state = STATE_READING_HEADER
        return "part_end"
    end

    return "body", chunk
end


local function read_header(self)
    local read_line = self.read_line

    local line, err = read_line(MAX_LINE_SIZE)
    if err then
        return nil, nil, err
    end

    local dummy, err = read_line(1)
    if dummy then
        return nil, nil, concat({"line too long: ", line, dummy, "..."}, "")
    end

    if err then
        return nil, nil, err
    end

    -- print("read line: ", line)

    if line == "" then
        -- after the last header
        self.state = STATE_READING_BODY
        return read_body_part(self)
    end

    local key, value = match(line, "([^: \t]+)%s*:%s*(.+)")
    if not key then
        return 'header', line
    end

    return 'header', {key, value, line}
end


local function eof()
    return "eof", nil
end


function read(self)
    local size = self.size

    local handler = state_handlers[self.state]
    if handler then
        return handler(self)
    end

    return nil, nil, "bad state: " .. self.state
end


local function read_preamble(self)
    local sock = self.sock
    if not sock then
        return nil, nil, "not initialized"
    end

    local size = self.size
    local read2boundary = self.read2boundary

    while true do
        local preamble, err = read2boundary(size)
        if not preamble then
            break
        end

        -- discard the preamble data chunk
        -- print("read preamble: ", preamble)
    end

    local ok, err = discard_line(self)
    if not ok then
        return nil, nil, err
    end

    local read2boundary, err = sock:receiveuntil("\r\n--" .. self.boundary)
    if not read2boundary then
        return nil, nil, err
    end

    self.read2boundary = read2boundary

    self.state = STATE_READING_HEADER
    return read_header(self)
end


state_handlers = {
    read_preamble,
    read_header,
    read_body_part,
    eof
}


local class_mt = {
    -- to prevent use of casual module global variables
    __newindex = function (table, key, val)
        error('attempt to write to undeclared variable "' .. key .. '"')
    end
}

setmetatable(_M, class_mt)

