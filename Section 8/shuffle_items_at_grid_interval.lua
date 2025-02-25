local MINIMUM_GRID_INTERVAL = 0.5

function main()
    -- Count selected items
    local activeProj = 0 
    local numOfSelItems = reaper.CountSelectedMediaItems(activeProj)
    
    if numOfSelItems > 0 then
        local itemsTable = {}
        
        local largestLength = 0
        
        local leftMostItem = reaper.GetSelectedMediaItem(activeProj, 0)
        local leftMostItemPos = reaper.GetMediaItemInfo_Value(leftMostItem, "D_POSITION")
    
        for i = 1, numOfSelItems do
            local j = i - 1
            
            -- Get item reference
            local item = reaper.GetSelectedMediaItem(activeProj, j)
            local itemPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            
            -- Add all selected items to a table, noting their position
            itemsTable[i] = {item = item, pos = itemPos, posIndex = i}
            
            -- Get the largest item length
            local thisItemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
            if thisItemLength > largestLength then
                largestLength = thisItemLength
            end
        end
        
        local gridInterval = largestLength + MINIMUM_GRID_INTERVAL
        
        -- Randomly swap position indices for each item
        for j = 1, 3 do
            for i, k in ipairs(itemsTable) do
                local item1 = itemsTable[math.random(1, #itemsTable)] -- #itemsTable is the number of elements in the table
                local item2 = itemsTable[i]
                
                item2.posIndex, item1.posIndex = item1.posIndex, item2.posIndex
            end
        end
        
        -- Move all items based on their newly assigned position indices
        for i, v in ipairs(itemsTable) do
            local newPos = leftMostItemPos + (gridInterval * (v.posIndex - 1))
            reaper.SetMediaItemPosition(v.item, newPos, true)
        end
    end
end



main()