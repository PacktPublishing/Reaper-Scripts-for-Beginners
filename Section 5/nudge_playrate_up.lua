local active_proj = 0
local increment_value = 0.1
local percentage_value = 1.1
local direction = 1

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

        local new_playrate

        -- If the current_playrate is less than 1, we want to increase the value by 10%
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