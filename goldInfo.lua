SLASH_M_MONEY_INFO1 = "/m_moneyInfo"
SLASH_M_MONEY_INFO_RESET1 = "/m_moneyInfoReset"

local moneyFrame = CreateFrame("FRAME")
moneyFrame:RegisterEvent("CHAT_MSG_MONEY")
moneyFrame:RegisterEvent("PLAYER_LOGOUT")
moneyFrame:RegisterEvent("PLAYER_MONEY")
moneyFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local _nullable = {
}

_nullable.new = function(arg)
    tab = {}
    tab.val = arg
    tab.orElse = function(self, newVal)
        if self.val then
            return self.val
        else
            return newVal
        end
    end

    return tab
end

local function nullable(arg)
    return _nullable.new(arg)
end

local function formatMoney(money)
    local gold, silver, copper, len
    len = string.len(money)
    if len > 4 then
        gold = string.sub(money, 0, len - 4)
        silver = string.sub(money, len - 3, len - 2)
        copper = string.sub(money, len - 1, len)
    elseif len > 2 and len < 5 then
        gold = 0
        silver = string.sub(money, 0, len - 2)
        copper = string.sub(money, len - 1, len)
    elseif len < 3 then
        gold = 0
        silver = 0
        copper = money
    end
    return string.format("%sg %ss %sc", gold, silver, copper)
end

local function initTable()
    M_MONEY_TABLE = {}
    M_MONEY_TABLE.totalGold = 0
    M_MONEY_TABLE.lootedGold = 0
    M_MONEY_TABLE.loginGold = GetMoney()
    M_MONEY_TABLE.lastGoldAmount = GetMoney()
    M_MONEY_TABLE.spentMoney = 0
end

function moneyFrame:onLoot(event, arg1)
    if event == "PLAYER_ENTERING_WORLD" then
        if M_MONEY_TABLE == nil then
            initTable()
        end
        if M_TIME_SINCE_LAST_LOGOUT == nil then
            M_TIME_SINCE_LAST_LOGOUT = time()
            M_MONEY_TABLE.loginGold = GetMoney()
        elseif M_TIME_SINCE_LAST_LOGOUT ~= nil then
            local lastLogoutHour = (time() - M_TIME_SINCE_LAST_LOGOUT) / (1000 * 60 * 60)
            if lastLogoutHour > 2 then
                M_MONEY_TABLE = nil
            end
        end
    end

    if event == "CHAT_MSG_MONEY" then
        local moneyStr = ""
        for match in arg1:gmatch("%d+") do
            if string.len(match) == 1 then
                match = "0" .. match
            end
            moneyStr = moneyStr .. match
        end

        local lootedMoney = tonumber(moneyStr)
        M_MONEY_TABLE.lootedGold = M_MONEY_TABLE.lootedGold + lootedMoney
    end
    if event == "PLAYER_LOGOUT" then
        M_TIME_SINCE_LAST_LOGOUT = time()
    end

    if event == "PLAYER_MONEY" then
        local currentMoney = GetMoney()
        if currentMoney > M_MONEY_TABLE.lastGoldAmount then
            local moneyReceived = currentMoney - M_MONEY_TABLE.lastGoldAmount
            M_MONEY_TABLE.totalGold = M_MONEY_TABLE.totalGold + moneyReceived
        else
            local spentMoney = math.abs(currentMoney - M_MONEY_TABLE.lastGoldAmount)
            M_MONEY_TABLE.spentMoney = M_MONEY_TABLE.spentMoney + spentMoney
        end
        M_MONEY_TABLE.lastGoldAmount = currentMoney

    end
end

local function printMoneyInfo()
    print("Since last session you earned: ")
    print("Gold looted: " .. formatMoney(M_MONEY_TABLE.lootedGold))
    print("Total gold earned: " .. formatMoney(M_MONEY_TABLE.totalGold))
    print("Spent gold: " .. formatMoney(M_MONEY_TABLE.spentMoney))
end

local function resetMoneyInfo ()
    initTable()
end

SlashCmdList["M_MONEY_INFO"] = printMoneyInfo
SlashCmdList["M_MONEY_INFO_RESET"] = resetMoneyInfo

moneyFrame:SetScript("OnEvent", moneyFrame.onLoot)
