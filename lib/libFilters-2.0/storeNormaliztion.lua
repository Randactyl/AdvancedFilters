STORE_WINDOW.ShouldAddItemToList = function(self, itemData)
    if(self.currentFilter == ITEMFILTERTYPE_ALL) then return true end

    local additionalFilter = self.additionalFilter
    local result = true
    
    if type(additionalFilter) == "function" then
        result = self.additionalFilter(itemData)
    end

    for i = 1, #itemData.filterData do
        if(itemData.filterData[i] == self.currentFilter) then
            return result and true
        end
    end
    
    return false
end