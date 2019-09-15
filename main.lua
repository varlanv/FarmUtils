SLASH_M_DELETE_ITEMS1 = "/deleteItems"
SLASH_EXDE_SORT1 = "/exde_sort"
--SLASH_M_UI_CHECK1 = "/mUiCheck"

--local AMOUNT_OF_ITEMS_TO_DELETE = 2
itemSet = {}
local frame = CreateFrame("FRAME")
local lock
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")

function frame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "DeleteSpecificItems" then
        if ITEMS_TO_DELETE == nil then
            ITEMS_TO_DELETE = {}
        end
        itemSet = StringSet:new()
        for itemId, _ in pairs(ITEMS_TO_DELETE) do
            itemSet:add(itemId)
        end
    end

    if event == "PLAYER_LOGOUT" then
        itemSet:each(function(itemId)
            if ITEMS_TO_DELETE[tostring(itemId)] == nil then
                ITEMS_TO_DELETE[tostring(itemId)] = 0
            end
        end)
    end
end

local function checkVendor ()
    return GetMerchantItemInfo(1)
end

local function analyzeBags()
    local deleteCounter = 0
    local sellCounter = 0
    local markedToDelete = {}
    local markedToSell = {}
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemInfo = bagItemInfo(bag, slot)
            local itemId = bagItemIdFromInfo(itemInfo)

            if itemSet:contains(itemId) then
                if checkVendor() then
                    if itemInfo[11] > 0 then
                        table.insert(markedToSell, { bag = bag, slot = slot })
                        sellCounter = sellCounter + 1
                    else
                        table.insert(markedToDelete, { bag = bag, slot = slot })
                        deleteCounter = deleteCounter + 1
                    end
                else
                    table.insert(markedToDelete, { bag = bag, slot = slot })
                    deleteCounter = deleteCounter + 1
                end
            end
        end
    end
    return {
        deleteCounter = deleteCounter,
        sellCounter = sellCounter,
        markedToDelete = markedToDelete,
        markedToSell = markedToSell
    }
end

local function acquireLock()
    lock = true
end

local function releaseLock()
    lock = false
end

local function isSorted(bags)
    for i = 1, bags.itemsAmount do
        if bags[i].empty then
            return false
        end
    end
    return true
end

local function exdeSort()

    local bags = {}
    bags.itemsAmount = 0

    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local item = { bag = bag, slot = slot }
            local itemInfo = bagItemInfo(bag, slot)
            if itemInfo then
                item.empty = false
                bags.itemsAmount = bags.itemsAmount + 1
            else
                item.empty = true
            end
            table.insert(bags, item)
        end
    end

    if isSorted(bags) then
        return
    end

    print("Sorting...")
    for i = #bags, bags.itemsAmount, -1 do
        local item = bags[i]

        if item.bag and item.slot and not item.empty then
            for j = 1, bags.itemsAmount do
                local innerItem = bags[j]
                if innerItem.bag and innerItem.slot and innerItem.empty then
                    PickupContainerItem(item.bag, item.slot)
                    PickupContainerItem(innerItem.bag, innerItem.slot)
                    innerItem.empty = false
                    item.empty = true
                    break
                end
            end
        end
    end
end

local function processVendor(markedToSell, counter)
    if counter > 0 then
        for _, v in pairs(markedToSell) do
            UseContainerItem(v.bag, v.slot)
        end
    end
end

local function processDelete(markedToDelete, counter)
    if counter > 0 then
        local delay = 0
        local lockCounter = 0
        for _, v in pairs(markedToDelete) do
            lockCounter = lockCounter + 1
            delay = delay + 0.4
            if lockCounter == counter then
                _delayCall(delay, function()
                    _delayCall(0.7, function()
                        exdeSort()
                        releaseLock()
                    end)
                    deleteBagItem(v.bag, v.slot)
                end)
            else
                _delayCall(delay, deleteBagItem, v.bag, v.slot)
            end
        end
    end
end

local function deleteItems(msg)
    acquireLock()
    local statistics = analyzeBags()
    local deleteCounter = statistics.deleteCounter
    local sellCounter = statistics.sellCounter
    local markedToDelete = statistics.markedToDelete
    local markedToSell = statistics.markedToSell
    if sellCounter > 0 and deleteCounter > 0 then
        print("Found " .. tostring(sellCounter) .. " items to sell and " .. tostring(deleteCounter) .. " items to delete")
        processVendor(markedToSell, sellCounter)
        processDelete(markedToDelete, deleteCounter)
    elseif sellCounter == 0 and deleteCounter > 0 then
        print("Found " .. tostring(deleteCounter) .. " items to delete")
        processDelete(markedToDelete, deleteCounter)
    elseif sellCounter > 0 and deleteCounter == 0 then
        print("Found " .. tostring(sellCounter) .. " items to sell")
        processVendor(markedToSell, sellCounter)
        _delayCall(0.7, exdeSort)
        releaseLock()
    elseif deleteCounter == 0 and sellCounter == 0 then
        print("Nothing to delete or sell")
        releaseLock()
    end
end

--local function mUiCheck()
--    local slotButton, _, _ = GetMouseFocus()
--local bag = slotButton:GetParent():GetID()
--local slot = slotButton:GetID()
--
--sanity check
--if bag >= 0 and bag < 5 and slot > 0 and slot < 37 and string.find(slotButton:GetName(), "ContainerFrame") then
--    local link = GetContainerItemLink(bag, slot)
--    return link
--end
-- slotButton:SetWidth(200)
--end

frame:SetScript("OnEvent", frame.OnEvent)
SlashCmdList["M_DELETE_ITEMS"] = deleteItems
SlashCmdList["EXDE_SORT"] = exdeSort
SlashCmdList["M_UI_CHECK"] = mUiCheck



--BIG_F = CreateFrame("Frame", nil, UIParent)
--BIG_F:SetFrameStrata("BACKGROUND")
--BIG_F:SetWidth(128) -- Set these to whatever height/width is needed
--BIG_F:SetHeight(64) -- for your Texture
--local t = BIG_F:CreateTexture(nil, "BACKGROUND")
--t:SetTexture("Interface\\Icons\\Inv_misc_coin_17")
--t:SetAllPoints(BIG_F)
--BIG_F.texture = t
--BIG_F:SetPoint("CENTER", 0, 0)
--BIG_F:Show()







