local active_proj = 0

-- verify that exactly 1 item is selected
if reaper.CountSelectedMediaItems(active_proj) == 1 then

    -- get reference to the media item
    local item = reaper.GetSelectedMediaItem(active_proj, 0)

    -- get reference to the active take
    local take = reaper.GetActiveTake(item)

    -- set a random pitch value between -30 and 30
    local new_pitch = math.random(-30, 30)-- (math.random(1, 61)-30)
    reaper.SetMediaItemTakeInfo_Value(take, 'D_PITCH', new_pitch)

    -- set a random play rate value
    -- rand between 1 and 120    and then divide by 20
    local new_playrate = math.random(1, 120) / 20
    reaper.SetMediaItemTakeInfo_Value(take, 'D_PLAYRATE', new_playrate)

    -- randomly choose between preserve pitch
    local preserve_pitch
    -- math.random() gives a random between 0 and 1
    if math.random() < 0.5 then
        preserve_pitch = 1
    else
        preserve_pitch = 0
    end
    reaper.SetMediaItemTakeInfo_Value(take, 'B_PPITCH', preserve_pitch)
--[[
    if math.random() < 0.5 then
        local toggle_reverse_cmd_id = 41051
        reaper.Main_OnCommandEx(41051, 0, active_proj)
    end
]]
    reaper.UpdateTimeline()
end