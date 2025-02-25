active_project = 0
num_of_sel_items = reaper.CountSelectedMediaItems(active_project)
USE_BEATS_AND_MEASURES = true -- set this to true to use the more complex version
SHOW_CONSOLE_MESSAGES = false -- set this to true to see a step by step of the complex version

function use_just_beats()
    return_val, user_input = reaper.GetUserInputs("Type Beats", 1, "", "")

    user_input_to_num = tonumber(user_input)

    -- After some experimenting it seems that reaper is wrong by 1, so correct for that here
    user_input_to_num = user_input_to_num - 1

    -- if tonumber() fails, its user_input_to_num will be nil
    if user_input_to_num then
        measuresIn = nil
        time_in_sec = reaper.TimeMap2_beatsToTime(active_project, user_input_to_num, measuresIn)
    
        reaper.SetMediaItemInfo_Value(ref_to_media_item, "D_POSITION", time_in_sec)
    end
end

function use_beats_and_measures() -- harder!

    return_val, user_input = reaper.GetUserInputs("Type Bars and Beats", 2, "Bar (top) Beat (bottom)", "")

    -- This is the tricky part. user_input is a 'comma separated list' (csv)
    if SHOW_CONSOLE_MESSAGES then
        reaper.ShowConsoleMsg('csv: '..user_input..'\n') --use this to see what that looks like
    end

    index_of_comma = string.find(user_input, ',') -- find the position in the string that has a comma
    if SHOW_CONSOLE_MESSAGES then 
        reaper.ShowConsoleMsg('index_of_comma: '..index_of_comma..'\n')
    end

    user_input_bars = user_input:sub(1, index_of_comma-1)
    if SHOW_CONSOLE_MESSAGES then
        reaper.ShowConsoleMsg('user_input_bars: '..user_input_bars..'\n')
    end

    user_input_beats = user_input:sub(index_of_comma+1, -1)
    if SHOW_CONSOLE_MESSAGES then
        reaper.ShowConsoleMsg('user_input_beats: '..user_input_beats..'\n')
    end

    if tonumber(user_input_beats) then
        if tonumber(user_input_bars) then

            -- Overwrite these values with a number version
            user_input_beats = tonumber(user_input_beats)
            user_input_bars = tonumber(user_input_bars)

            -- After some experimenting it seems that reaper is wrong by 1
            user_input_beats = user_input_beats - 1
            user_input_bars = user_input_bars - 1

            time_in_sec = reaper.TimeMap2_beatsToTime(active_project, user_input_beats, user_input_bars)
        
            reaper.SetMediaItemInfo_Value(ref_to_media_item, "D_POSITION", time_in_sec)
        end
    end

end

if num_of_sel_items > 0 then

    selected_item_index = 0
    ref_to_media_item = reaper.GetSelectedMediaItem(active_project, selected_item_index)

    -- Easiest way is to just have beats. A trickier version of the script uses bars and beats
    -- I've done both versions in here and separated them into different functions
    -- change the value of USE_BEATS_AND_MEASURES to activate the alternative version of the script
    if USE_BEATS_AND_MEASURES then
        use_beats_and_measures()
    else
        use_just_beats()
    end
end