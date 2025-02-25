active_project = 0
mute_item_command_id = 40719
unmute_item_command_id = 40720


-- verify that items are selected
num_of_sel_items = reaper.CountSelectedMediaItems(active_project)

if num_of_sel_items > 0 then

    first_sel_item = 0
    item = reaper.GetSelectedMediaItem(active_project, first_sel_item)
    -- find out whether the item is muted or not


    -- with strings, there is a difference between 'b_mute' and 'B_MUTE'

    -- when booleans are represnted numerically, 0 is false, 1 is true
    is_muted = reaper.GetMediaItemInfo_Value(item, 'B_MUTE')
    -- is_muted = 1 if it IS muted. is_muted = 0 if it is NOT muted

    if is_muted == 1 then
        -- unmute the item
        reaper.Main_OnCommandEx(unmute_item_command_id, 0, active_project)
    elseif is_muted == 0 then
        -- mute the item
        reaper.Main_OnCommandEx(mute_item_command_id, 0, active_project)
    end
end