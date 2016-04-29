STORE_WINDOW.ShouldAddItemToList = function(self, itemData)
    if(self.currentFilter == ITEMFILTERTYPE_ALL) then return true end

    local additionalFilter = self.additionalFilter
    
    if type(additionalFilter) == "function" then
        additionalFilter = additionalFilter(itemData)
    else
        additionalFilter = true
    end

    for i = 1, #itemData.filterData do
        if(itemData.filterData[i] == self.currentFilter) then
            return additionalFilter and true
        end
    end
    
    return false
end