List = {}

List.new = function()
    local _List = {}

    _List.length = 0

    local meta = {
        __tostring = function(t)
            local result = "{"

            for _, v in pairs(t.innerArr) do
                if type(v) == "function" or "table" then
                    v = tostring(v)
                end
                result = result .. v .. ", "

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

    _List.add = function(self, val, index)
        assert(self == _List)
        if index then
            --print("-------------------add with index--------------------")
            table.insert(self.innerArr, index, val)
            self.length = self.length + 1
        else
            --print("-------------------add--------------------")
            table.insert(self.innerArr, val)
            self.length = self.length + 1
        end
    end

    _List.getFirst = function(self)
        assert(self == _List)
        --print("-------------------get first--------------------")
        return self.innerArr[1]
    end

    _List.get = function(self, index)
        assert(self == _List)
        --print("-------------------get by index--------------------")
        if index <= self.length then
            return self.innerArr[index]
        else
            error("Array index out of bound")
        end
    end

    _List.remove = function(self, index)
        assert(self == _List)
        --print("-------------------get by index--------------------")

        if index <= self.length then
            --print("removing value with index ")
            --print(index)
            --print(" - ")
            --print(self.innerArr[index])
            table.remove(self.innerArr, index)
            self.length = self.length - 1
        else
            error("Array index out of bound")
        end
    end

    _List.toString = function(self)
        assert(self == _List)
        return meta.__tostring(self)
    end

    _List.addAll = function(self, ...)
        assert(self == _List)
        local t = table.pack(...)
        t.n = nil

        for _, v in pairs(t) do
            if type(v) == "table" and #v > 0 then
                _List.addAll(self, table.unpack(v))
            else
                self.add(self, v)
            end
        end
    end

    _List.each = function(self, callback)
        assert(self == _List)
        assert(type(callback) == "function")

        for _, v in pairs(self.innerArr) do
            callback(v)
        end
    end

    _List.map = function(self, callback)
        assert(self == _List)
        assert(type(callback) == "function")

        local mapResult = List:new()

        for _, v in pairs(self.innerArr) do
            mapResult:add(callback(v))
        end
        return mapResult
    end

    _List.filter = function(self, callback)
        assert(self == _List)
        assert(type(callback) == "function")

        local filterResult = List:new()

        for _, v in pairs(self.innerArr) do
            if callback(v) == true then
                filterResult:add(v)
            end
        end
        return filterResult
    end

    _List.contains = function(self, val)
        assert(self == _List)
        for _, v in pairs(self.innerArr) do
            if v == val then
                return true
            end
        end
        return false
    end

    --- TODO  !!!
    _List.containsAll = function(self, ...)
        assert(self == _List)
        local t = table.pack(...)
        t.n = nil

        for _, v in pairs(t) do
            if not self.contains(self, v) then
                return false
            end
        end
        return true
    end

    _List.containsOnly = function(self, ...)
        assert(self == _List)
        --print(table.pack(...))
        local t = table.pack(...)
        t.n = nil

        print(self["__MARKER"])

        --for i, v in pairs(t) do
        --    print(tostring(i) .. "    " .. tostring(v))
        --end



        if #self.innerArr ~= #t then
            return false
        end
        for _, v in pairs(t) do
            if not self.contains(self, v) then
                return false
            end
        end
        return true
    end

    ---------------------------------TODO optimize-------------------------------
    _List.unique = function(self)
        assert(self == _List)
        local t = {}

        for i = 1, #self.innerArr do
            t[self.innerArr[i]] = 0
        end

        local result = List:new()

        for k, _ in pairs(t) do
            result:add(k)
        end
        return result
    end

    _List.sorted = function(self, callback)
        assert(self == _List)
        local t = List:of(self.innerArr)

        if callback and type(callback) == "function" then
            table.sort(t.innerArr, callback)
        else
            table.sort(t.innerArr)
        end

        return t
    end

    setmetatable(_List, meta)
    _List.innerArr = {}

    _List["___MARKER"] = 0
    return _List
end

List.of = function(self, ...)
    local args = table.pack(...)
    args.n = nil
    local result = List:new()
    if self and self ~= List then
        result:add(self)
    end
    result:addAll(args)

    return result
end



















-- TESTS

--
--local coolList = List:new()
--
--coolList:add("kulval1")
--coolList:add("kulval2")
--coolList:add("kulval3")
--
--assert(#coolList == 3)
--assert(coolList:getFirst() == "kulval1", "List.getFirst() should return first value of list")
--assert(coolList:get(1) == "kulval1", "List.get() should return value by index")
--assert(coolList:get(2) == "kulval2")
--assert(coolList:get(3) == "kulval3")
--assert(coolList:toString() == "{kulval1, kulval2, kulval3}", "List.toString() should build proper list")
--assert(assert(coolList[1] == "kulval1"))
--assert(assert(coolList[2] == "kulval2"))
--assert(assert(coolList[3] == "kulval3"))
--
--coolList:remove(2)
--
--assert(#coolList == 2)
--assert(coolList:toString() == "{kulval1, kulval3}")
--assert(pcall(coolList.remove, coolList, 4) == false)
--assert(pcall(coolList.remove, coolList, 3) == false)
--assert(pcall(coolList.remove, coolList, 2) == true)
--assert(pcall(coolList.get, coolList, 5) == false)
--assert(#coolList == 1)
--assert(coolList[1] == "kulval1")
--
--coolList:addAll("val2", "val3")
--
--assert(#coolList == 3)
--assert(coolList[1] == "kulval1")
--assert(coolList[2] == "val2")
--assert(coolList[3] == "val3")
--
--coolList:addAll({ "val4" })
--
--assert(#coolList == 4)
--assert(coolList[4] == "val4")
--
--coolList:add(function()
--end)
--coolList:add({})
--coolList:addAll(function()
--end, {})
--
--assert(#coolList == 8)
--assert(type(coolList[5] == "function"))
--assert(type(coolList[6] == "table"))
--assert(type(coolList[7] == "function"))
--assert(type(coolList[8] == "table"))
--
----print("------------------- test \"each\" method--------------------")
----coolList:each(function(val)
----    print(val)
----end)
----print("------------------- test \"each\" method--------------------")
--
--coolList:remove(8)
--coolList:remove(7)
--coolList:remove(6)
--coolList:remove(5)
--
--local mappedList = coolList:map(function(val)
--    return val .. "kek"
--end)
--
--mappedList:each(function(val)
--    assert(string.match(val, "kek", #val - 2))
--end)
--
--local list = List:new()
--
--list:add(34)
--list:add(2)
--list:add(6)
--
--list:addAll(1, 2, 3)
--
--assert(list:contains(1) == true)
--assert(list:contains(2) == true)
--assert(list:contains(3) == true)
--assert(list:contains(34) == true)
--assert(list:contains(6) == true)
--
--assert(list:containsAll(1, 3, 2, 6, 34) == true)
--assert(List:of("abc", "bca"):toString() == "{abc, bca}")
--assert(List:of({ "abc", "bca" }):toString() == "{abc, bca}")
--
--local fList = List:new()
--
--fList:addAll("qqq", "aaa", "bbb", "ccc")
--
--assert(#fList == 4)
--
--fList = fList:filter(function(val)
--    return val == "qqq" or val == "aaa"
--end)
--
--assert(#fList == 2)
--assert(fList:containsAll("qqq", "aaa"))
--assert(fList:containsAll("aaa"))
--assert(fList:containsOnly("qqq", "aaa"))
--assert(not fList:containsOnly("aaa"))
--assert(not fList:containsOnly("bbb"))
--
--local uList = List:of("qwe", "qwe", "a", "b", "a")
--
--uList = uList:unique()
--
--assert(#uList == 3)
--assert(uList:containsOnly("b", "a", "qwe"))
--
--local uuList = List:new()
--
--for i = 1, 20 do
--    uuList:add(i .. "kek")
--end
--
--uuList:addAll("9kek", "4kek")
--uuList = uuList:unique()
--
--assert(#uuList == 20)
--
--local uu = List:new()
--for i = 1, 20 do
--    uu:add(i .. "kek")
--end
--
----for i, v in pairs(uu.innerArr) do
----    print(tostring(i) .. "  " .. tostring(v))
----end
----
----for i, v in pairs(uu.innerArr) do
----    print(tostring(i) .. "  " .. tostring(v))
----end
--
--assert(#uu == #uuList)
--for i = 1, #uu do
--    assert(uuList:contains(uu:get(i)))
--end
--
--
----print(uu)
----print(uuList)
----print(uuList:sorted())
--
--
----assert(uuList:containsOnly(uu))
----assert(uuList:containsAll(uu))
