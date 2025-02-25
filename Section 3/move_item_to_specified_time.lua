active_project = 0
num_of_sel_items = reaper.CountSelectedMediaItems(active_project)

if num_of_sel_items > 0 then

    -- If we do indeed have an item highlighted, we store a reference to that media item
    selected_item_index = 0
    ref_to_media_item = reaper.GetSelectedMediaItem(active_project, selected_item_index)

    return_val, user_input = reaper.GetUserInputs("Destination Time", 1, "", "")

    -- we want to take user_input, convert it to a number (if possible), 
    -- store that number as start_time_chosen
    -- use that number as the position to move the item to

    start_time_chosen = tonumber(user_input) 
    -- if tonumber() fails, its value will be nil
    
    if start_time_chosen then -- this is called a nil check
        -- if start_time_chosen is a number then the code will enter this section
        reaper.SetMediaItemInfo_Value(ref_to_media_item, "D_POSITION", start_time_chosen)
    else
        -- if start_time_chosen is nil then the code will enter this section
    end

end