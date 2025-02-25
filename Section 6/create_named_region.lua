local active_proj = 0

-- count selected items
num_of_sel_items = reaper.CountSelectedMediaItems(active_proj)

if num_of_sel_items == 0 then
    -- get the loop region start and end
    local isSet, isLoop = false, false
    region_start, region_end = reaper.GetSet_LoopTimeRange2(active_proj, isSet, isLoop, -1, -1, false)
else

    -- if there are multiple selected items
    -- figure out the left most start point and the right-most end point

    -- we are going to loop through all selected items and take note of their position and end point
    -- and we are going to compare these values to a running value that stays in scope
    local leftmost_position = math.huge
    local rightmost_position = 0

    for i = 0, num_of_sel_items - 1 do
        local this_item = reaper.GetSelectedMediaItem(active_proj, i)

        local this_start_pos = reaper.GetMediaItemInfo_Value(this_item, 'D_POSITION')
        local this_length = reaper.GetMediaItemInfo_Value(this_item, 'D_LENGTH')
        local this_end_pos = this_start_pos + this_length

        if this_start_pos < leftmost_position then
            leftmost_position = this_start_pos
        end

        if this_end_pos > rightmost_position then
            rightmost_position = this_end_pos
        end
    end

    region_start = leftmost_position
    region_end = rightmost_position

end


function desired_region_name_is_conflicted(name_to_check)

    -- check to see if the region name that the user has selected has already been used in the session
    local _, num_markers, num_regions = reaper.CountProjectMarkers(active_proj)
    local total_markers = num_markers + num_regions
    -- in the above usage, a region is not considered a marker

    for i = 0, total_markers - 1 do
        local _, isrgn, pos, rgnend, this_region_name, mrkr_id, _ = reaper.EnumProjectMarkers3(active_proj, i)
        if isrgn == true then
            -- Check to see if the region name already exists
            if name_to_check == this_region_name then
                return true
            end
        end
    end

    return false
end


function increment_desired_region_name(desired_name)
    local desired_name_chopped -- this will be the string with the numbers taken off the end

    local last_char = desired_name:sub(-1, -1)
    local last_two_chars = desired_name:sub(-2, -1)
    local last_three_chars = desired_name:sub(-3, -1)
    local last_four_chars = desired_name:sub(-4, -1)

    local final_numeric_chars = nil

    if tonumber(last_four_chars) then
        final_numeric_chars = last_four_chars
        desired_name_chopped = desired_name:sub(1, -5)
    elseif tonumber(last_three_chars) then
        final_numeric_chars = last_three_chars
        desired_name_chopped = desired_name:sub(1, -4)
    elseif tonumber(last_two_chars) then
        final_numeric_chars = last_two_chars
        desired_name_chopped = desired_name:sub(1, -3)
    elseif tonumber(last_char) then
        final_numeric_chars = last_char
        desired_name_chopped = desired_name:sub(1, -2)
    end

    if final_numeric_chars then
        -- we want to convert this to a number and then add 1
        final_numeric_chars = tonumber(final_numeric_chars)
        new_number = final_numeric_chars + 1

        new_desired_name = desired_name_chopped .. new_number

        return new_desired_name
    else -- the name in question is non-numeric
        return desired_name..'_1'
    end
end

-- prompt the user for a region name
local retval, user_input = reaper.GetUserInputs('New Region Name', 1, '', '')

if retval == true then
    local desired_region_name = user_input
    


    local safety = 1
    local conflict_found = false
    while desired_region_name_is_conflicted(desired_region_name) == true do
        conflict_found = true
        desired_region_name = increment_desired_region_name(desired_region_name)
        safety = safety + 1
        if safety > 100 then
            reaper.ShowConsoleMsg('safety while loop break hit. Something wrong!')
            break
        end
    end

    if conflict_found then
        -- why does this work? desired_region_name doesn't get rewritten? TODO
        retval, user_input = reaper.GetUserInputs('CONFLICTED', 1, 'suggested: ', desired_region_name)
        if retval then
            if user_input then
                desired_region_name = user_input
            end
        end
    end

    if retval then

        -- Optional feature: Prompt the user for an 'end pad' which will put the region end point slightly to the right
        -- useful if the mix contains delays or reverbs
        retval, user_input = reaper.GetUserInputs('End pad?', 1, '', '')
        if retval then
            if tonumber(user_input) then
                region_end = region_end + tonumber(user_input)
            end
        end


        local isrgn = true
        local colour = 0
        local wantidx = -1
        reaper.AddProjectMarker2(active_proj, isrgn, region_start, region_end, desired_region_name, wantidx, colour)
    end
end