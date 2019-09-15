SLASH_M_GET_FULL_ITEM_INFO1 = "/fullItemInfo"

function getMouseoverItemLink()
    local slotButton, _, _ = GetMouseFocus()
    local bag = slotButton:GetParent():GetID()
    local slot = slotButton:GetID()

    --sanity check
    if bag >= 0 and bag < 5 and slot > 0 and slot < 37 and string.find(slotButton:GetName(), "ContainerFrame") then
        local link = GetContainerItemLink(bag, slot)
        return link
    end
end

function getItemId(itemInfo)
    return itemInfo[2]:match("item:(%d+):")
end

function getMouseOverItemInfo()
    local itemLink = getMouseoverItemLink()
    return { GetItemInfo(itemLink) }
end

function getMouseoverItemId()
    local itemInfo = getMouseOverItemInfo()
    return getItemId(itemInfo)
end

function getMouseoverFullItemInfo()
    local itemInfo = getMouseOverItemInfo()
    local item = Item.new(itemInfo)
    ---print(gsub(itemLink, "\124", "\124\124")) EXTRACT ITEM STRING FROM LINK
    print(item)
    return item
end

SlashCmdList["M_GET_FULL_ITEM_INFO"] = getMouseoverFullItemInfo;
