function bagItemLink(bag, slot)
    if checkProperBagValues(bag, slot) then
        return GetContainerItemLink(bag, slot)
    end
end

function bagItemInfo(bag, slot)
    if checkProperBagValues(bag, slot) then
        local itemLink = bagItemLink(bag, slot)
        if itemLink then
            return { GetItemInfo(itemLink) }
        end
    end
end

function bagItemIdFromInfo(itemInfo)
    if itemInfo then
        return itemInfo[2]:match("item:(%d+):")
    end
end

function bagItemId(bag, slot)
    if checkProperBagValues(bag, slot) then
        local itemInfo = bagItemInfo(bag, slot)
        if itemInfo then
            return bagItemIdFromInfo(itemInfo)
        end
    end
end

function deleteBagItem(bag, slot)
    checkProperBagValues(bag, slot)
    PickupContainerItem(bag, slot)
    DeleteCursorItem()
end

function checkProperBagValues(bag, slot)
    return bag and slot and bag >= 0 and bag < 5 and slot < 37 and slot > 0
end
