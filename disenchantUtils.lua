--local frame = CreateFrame("FRAME")
--frame:RegisterEvent("ADDON_LOADED")
--frame:RegisterEvent("PLAYER_LOGOUT")
--local disenchantSet
--
--function frame:OnEvent (event, arg1)
--    if event == "ADDON_LOADED" then
--        if M_DISENCHANT_LIST == nil then
--            M_DISENCHANT_LIST = {}
--        end
--        disenchantSet = StringSet:new()
--        for itemId, _ in pairs(M_DISENCHANT_LIST) do
--            disenchantSet:add(itemId)
--        end
--    end
--    if event == "PLAYER_LOGOUT" then
--        disenchantSet:each(function(itemId)
--            if M_DISENCHANT_LIST[tostring(itemId)] == nil then
--                M_DISENCHANT_LIST[tostring(itemId)] = 0
--            end
--        end)
--    end
--end
--
--local function addToDisenchantList()
--    local itemId = getMouseoverItemId()
--    if disenchantSet:add(itemId) then
--        print("Adding item with id " .. itemId .. " to disenchant list")
--        M_DISENCHANT_LIST[tostring(itemId)] = 0
--    else
--        print("Item with id " .. itemId .. " is already in disenchant list")
--    end
--end
--
--local function removeFromDisenchantList()
--    local itemId = getMouseoverItemId()
--    if disenchantSet:remove(itemId) then
--        M_DISENCHANT_LIST[tostring(itemId)] = 0
--        print("Removing item with id " .. itemId .. " from disenchant list")
--    else
--        print("Cannot find item with id " .. itemId .. " in disenchant list")
--    end
--end
--
--function m_disenchant ()
--    --for bag = 0, 4 do
--    --    for slot = 1, GetContainerNumSlots(bag) do
--    --        local itemId = bagItemId(bag, slot)
--    --        if disenchantSet:contains(itemId) then
--    --        end
--    --    end
--    --end
--    return { a = "b", c = "d" }
--end
--
--SLASH_M_DISENCHANT1 = "/m_disenchant"
--SlashCmdList["M_DISENCHANT"] = m_disenchant
--
--
--
--btn = CreateFrame("Button", nil, UIParent, "SecureActionButtonTemplate")
--btn:SetAttribute("type", "spell")
--btn:SetAttribute("spell", "Disenchant")
--btn:SetAttribute("target-item", "1 1")