Item = {}

Item.new = function(itemInfo)
    _item = {}

    _item.name = itemInfo[1]
    _item.link = itemInfo[2]
    _item.rarityId = itemInfo[3]
    _item.itemLvl = itemInfo[4]
    _item.equipLvl = itemInfo[5]
    _item.type = itemInfo[6]
    _item.subType = itemInfo[7]
    _item.availableStackSize = itemInfo[8]
    _item.equipLocation = itemInfo[9]
    _item.iconLocation = itemInfo[10]
    _item.sellPricePerOne = itemInfo[11]

    if _item.rarityId == 0 then
        _item.rarity = "Poor"
    elseif _item.rarityId == 1 then
        _item.rarity = "Common"
    elseif _item.rarityId == 2 then
        _item.rarity = "Uncommon"
    elseif _item.rarityId == 3 then
        _item.rarity = "Rare"
    elseif _item.rarityId == 4 then
        _item.rarity = "Epic"
    elseif _item.rarityId == 5 then
        _item.rarity = "Legendary"
    elseif _item.rarityId == 6 then
        _item.rarity = "Artifact"
    elseif _item.rarityId == 7 then
        _item.rarity = "Heirloom"
    end

    _item.id = getItemId(itemInfo)

    meta = {
        __tostring = function(self)
            res = "Name - " .. self.name .. ",\n" ..
                    "ID - " .. self.id .. ",\n" ..
                    "Link - " .. self.link .. ",\n" ..
                    "Rarity - " .. self.rarity .. ",\n" ..
                    "Rarity ID - " .. self.rarityId .. ",\n" ..
                    "Item Level - " .. self.itemLvl .. ",\n" ..
                    "Equip Level - " .. self.equipLvl .. ",\n" ..
                    "Type - " .. self.type .. ",\n" ..
                    "Subtype - " .. self.subType .. ",\n" ..
                    "Available stack size - " .. self.availableStackSize .. ",\n" ..
                    "Equip location - " .. self.equipLocation .. ",\n" ..
                    "Icon location - " .. self.iconLocation .. ",\n" ..
                    "Sell price per one - " .. self.sellPricePerOne
            return res
        end
    }

    _item.toString = function(self)
        assert(self == _item)
        return meta.__tostring(self)
    end

    setmetatable(_item, meta)
    return _item
end
