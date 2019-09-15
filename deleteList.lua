SLASH_ADD_TO_DELETE_LIST1 = "/addToDeleteList"
SLASH_REMOVE_FROM_DELETE_LIST1 = "/removeFromDeleteList"
SLASH_PRINT_DELETE_LIST1 = "/printDeleteList"

local function addToDeleteList()
    local itemId = getMouseoverItemId()
    if itemSet:add(itemId) then
        print("Adding item with id " .. itemId .. " to list")
        ITEMS_TO_DELETE[tostring(itemId)] = itemIdb
    else
        print("Item with id " .. itemId .. " is already in list")
    end
end

local function removeFromDeleteList()
    local itemId = getMouseoverItemId()
    if itemSet:remove(itemId) then
        ITEMS_TO_DELETE[tostring(itemId)] = nil
        print("Removing item with id " .. itemId .. " from list")
    else
        print("Cannot find item with id " .. itemId .. " in list")
    end
end

local function printDeleteList()
    if itemSet:isEmpty() then
        print("Your list is empty")
    else
        itemSet:each(function(itemId)
            local itemInfo = { GetItemInfo(itemId) }
            print("Item id: " .. itemId .. ",  Item link: " .. itemInfo[2])
        end)
    end
end

SlashCmdList["PRINT_DELETE_LIST"] = printDeleteList;
SlashCmdList["ADD_TO_DELETE_LIST"] = addToDeleteList;
SlashCmdList["REMOVE_FROM_DELETE_LIST"] = removeFromDeleteList;


