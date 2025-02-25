local active_proj = 0
local increment_value = 0.1
local percentage_value = 0.9
local direction = -1

-- Verify that at least 1 item is selected
local num_of_sel_tracks = reaper.CountSelectedMediaItems(active_proj)

if num_of_sel_tracks > 0 then

    -- For each item that is selected do
    for i = 0, num_of_sel_tracks - 1 do

        -- Get a reference to the media item
        local this_item = reaper.GetSelectedMediaItem(active_proj, i)

        -- Get a reference to the active take
        local active_take = reaper.GetActiveTake(this_item)

        -- Get the current playrate of the item
        local current_playrate = reaper.GetMediaItemTakeInfo_Value(active_take, 'D_PLAYRATE')        
        
        -- Set the 'preserve pitch' tickbox to either true or false
        local preserve_pitch_true = 1
        reaper.SetMediaItemTakeInfo_Value(active_take, 'B_PPITCH', preserve_pitch_true)
        -- Set the 'loop source' to off/false
        local loop_source_false = 0
        reaper.SetMediaItemInfo_Value(this_item, 'B_LOOPSRC', loop_source_false)
        

        -- When the current value is greater than one, simply subtract the increment_value
        -- But when the current value is 1 or less, we want to take away 10%
        -- to achieve a reduction of 10%, multiply the current value by 0.9

        local new_playrate = nil

        if current_playrate > 1 then
            new_playrate = current_playrate + (increment_value * direction)
        else
            new_playrate = current_playrate * percentage_value
        end

        -- set the playrate of the item to the new value
        reaper.SetMediaItemTakeInfo_Value(active_take, 'D_PLAYRATE', new_playrate)
    end

    reaper.UpdateTimeline()
end