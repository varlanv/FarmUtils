StringSet = {}

StringSet.new = function()
    local _StringSet = {}

    _StringSet.length = 0

    local meta = {
        __tostring = function(t)
            local result = "{"

            for k, _ in pairs(t.innerArr) do
                if type(k) == "function" or "table" then
                    k = tostring(k)
                end
                result = result .. k .. ", "

            end
            if #t > 0 then
                result = string.sub(result, 1, #result - 2)
            end
            return result .. "}"
        end,

        __len = function(t)
            return t.length
        end,

        __index = function(t, key)
            return t.get(t, key)
        end
    }

    _StringSet.add = function(self, val)
        assert(self == _StringSet)
        --print("-------------------add--------------------")
        if self.contains(self, val) then
            return false
        else
            self.innerArr[tostring(val)] = 0
            self.length = self.length + 1
            return true
        end
    end
    --_StringSet.getFirst = function(self)
    --    assert(self == _List)
    --    print("-------------------get first--------------------")
    --return self.innerArr[1]
    --end

    --_StringSet.get = function(self, index)
    --    assert(self == _List)
    --print("-------------------get by index--------------------")
    --if index <= self.length then
    --    return self.innerArr[index]
    --else
    --    error("Array index out of bound")
    --end
    --end

    _StringSet.remove = function(self, val)
        assert(self == _StringSet)
        --print("-------------------get by index--------------------")

        if val and self.contains(self, val) then
            --print("removing value with index ")
            --print(index)
            --print(" - ")
            --print(self.innerArr[index])
            self.innerArr[tostring(val)] = nil
            self.length = self.length - 1
            return true
        else
            return false
        end
    end

    _StringSet.removeAll = function(self)
        assert(self == _StringSet)

        for key, _ in pairs(self.innerArr) do
            self.innerArr[tostring(key)] = nil
            self.length = self.length - 1
        end
    end

    _StringSet.toString = function(self)
        assert(self == _StringSet)
        return meta.__tostring(self)
    end

    --_StringSet.addAll = function(self, ...)
    --    assert(self == _List)
    --    local t = table.pack(...)
    --    t.n = nil
    --
    --    for _, v in pairs(t) do
    --        if type(v) == "table" and #v > 0 then
    --            _List.addAll(self, table.unpack(v))
    --        else
    --            self.add(self, v)
    --        end
    --    end
    --end

    _StringSet.each = function(self, callback)
        assert(self == _StringSet)
        assert(type(callback) == "function")

        for k, _ in pairs(self.innerArr) do
            callback(k)
        end
    end

    _StringSet.map = function(self, callback)
        assert(self == _StringSet)
        assert(type(callback) == "function")

        local mapResult = StringSet:new()

        for k, _ in pairs(self.innerArr) do
            mapResult:add(callback(k))
        end
        return mapResult
    end

    _StringSet.filter = function(self, callback)
        assert(self == _StringSet)
        assert(type(callback) == "function")

        local filterResult = _StringSet:new()

        for k, _ in pairs(self.innerArr) do
            if callback(k) == true then
                filterResult:add(k)
            end
        end
        return filterResult
    end

    _StringSet.contains = function(self, val)
        assert(self == _StringSet)
        if val and self.innerArr[tostring(val)] == 0 then
            return true
        end
        return false
    end

    _StringSet.isEmpty = function(self)
        return self.length == 0
    end

    --- TODO  !!!
    --_StringSet.containsAll = function(self, ...)
    --    assert(self == _StringSet)
    --    local t = table.pack(...)
    --    t.n = nil
    --
    --    for _, v in pairs(t) do
    --        if not self.contains(self, v) then
    --            return false
    --        end
    --    end
    --    return true
    --end

    --_List.containsOnly = function(self, ...)
    --    assert(self == _List)
    --    print(table.pack(...))
    --local t = table.pack(...)
    --t.n = nil
    --
    --print(self["__MARKER"])
    --
    --for i, v in pairs(t) do
    --    print(tostring(i) .. "    " .. tostring(v))
    --end



    --if #self.innerArr ~= #t then
    --    return false
    --end
    --for _, v in pairs(t) do
    --    if not self.contains(self, v) then
    --        return false
    --    end
    --end
    --return true
    --end

    --_List.sorted = function(self, callback)
    --    assert(self == _List)
    --    local t = List:of(self.innerArr)
    --
    --    if callback and type(callback) == "function" then
    --        table.sort(t.innerArr, callback)
    --    else
    --        table.sort(t.innerArr)
    --    end
    --
    --    return t
    --end

    setmetatable(_StringSet, meta)
    _StringSet.innerArr = {}

    _StringSet["___MARKER"] = 0
    return _StringSet
end

--List.of = function(self, ...)
--    local args = table.pack(...)
--    args.n = nil
--    local result = List:new()
--    if self and self ~= List then
--        result:add(self)
--    end
--    result:addAll(args)
--
--    return result
--end

--
--local set = StringSet:new()
--
--assert(set:add("abc") == true)
--assert(set:add("abc") == false)
--assert(set:add(1) == true)
--assert(set:add(1) == false)
--assert(set:remove(1) == true)
--assert(set:remove(1) == false)
--assert(set.length == 1)
--assert(set:toString() == "{abc}")
--assert(set:remove("abc") == true)
--assert(set:toString() == "{}")
--
--local temp = 0
--set:each(function()
--    temp = 1
--end)
--assert(temp == 0)
--
--set:add("something")
--set:each(function()
--    temp = 1
--end)
--assert(temp == 1)
--
--set:add(1)
--set:add(3)
--set:add(2)
--set:removeAll()
--
--assert(set.length == 0)
--assert(set:toString() == "{}")
--
--set:add("qwe")
