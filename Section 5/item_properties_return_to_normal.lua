local active_proj = 0

-- verify that exactly 1 item is selected
if reaper.CountSelectedMediaItems(active_proj) == 1 then

    -- get reference to the media item
    local item = reaper.GetSelectedMediaItem(active_proj, 0)

    -- get reference to the active take
    local take = reaper.GetActiveTake(item)

    -- set the play rate to 1.0
    local new_playrate = 1
    reaper.SetMediaItemTakeInfo_Value(take, 'D_PLAYRATE', new_playrate)

    -- set the pitch to 0
    local new_pitch = 0
    reaper.SetMediaItemTakeInfo_Value(take, 'D_PITCH', new_pitch)

    -- set the item volume to 1
    local new_vol = 1
    reaper.SetMediaItemTakeInfo_Value(take, 'D_VOL', new_vol)

    -- This is one of those scripts whose changes don't immediately
    -- show on screen. So this forces the changes to be immediately visible
    reaper.UpdateTimeline()
end