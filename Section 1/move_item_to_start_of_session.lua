-- This script will take the selected item and move it to the start of the timeline


-- First we need to verify that we have an item highlighted
-- Count how many items we have selected. And only proceed with the script
-- if the number of items we have selected is more than 0 then proceed
num_of_sel_items = reaper.CountSelectedMediaItems(0)

if num_of_sel_items > 0 then

    -- code in here
    -- if the conditional statement is false, all of this will be skipped
    
    
    -- If we do indeed have an item highlighted, we store a reference to that media item
    ref_to_media_item = reaper.GetSelectedMediaItem(0, 0)
    
    -- Set the item's start position to be 0 seconds
    -- when something is 'surrounded by quotes' or "quotes like this" it is a STRING
    
    reaper.SetMediaItemInfo_Value(ref_to_media_item, "D_POSITION", 0)
    
    -- Optional: Make sure the view includes the start of the session

else
    
    -- if the conditional is false, we enter the else section
    reaper.ShowConsoleMsg('No items are selected, dummy!')

end



