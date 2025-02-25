active_project = 0

-- Verify that there is at least 1 track selected
num_of_sel_tracks = reaper.CountSelectedTracks(active_project)

coloursTable = { -- in other coding languages this might represent a key/value map
    r = reaper.ColorToNative(255, 0, 0),
    g = reaper.ColorToNative(38, 159, 75),
    b = reaper.ColorToNative(51, 51, 237),
    y = reaper.ColorToNative(210, 208, 41),
}

if num_of_sel_tracks > 0 then

    -- Prompt the user to input a colour as a string
    return_val, user_input = reaper.GetUserInputs("Input a Colour", 1, "", "")

    -- Forward declaring a variable and giving it a nil value, 
    -- the intention is that we will give it a proper value later
    chosen_colour = nil

    -- coloursTable[key] = value
    chosen_colour = coloursTable[user_input]
    -- if user_input is not found as a key in coloursTable then chosen_colour will be nil

    -- Get the colour data as per the users choice

    -- Set the track colour to the selected colour for all selected tracks

    -- if the user selects 'random' set a flag for random to use in the for loop
    random_colour_chosen = false
    if user_input == 'random' then -- if 'random' was written, chosen_colour will be nil
        random_colour_chosen = true
    end
    
    for i = 1, num_of_sel_tracks do

        -- Reaper indexes the selected tracks starting from 0
        -- But lua starts its for loops from index 1
        j = i - 1 -- when i is 1, j will be 0, etc.

        track = reaper.GetSelectedTrack(active_project, j)

        if chosen_colour then
    
            reaper.SetTrackColor(track, chosen_colour)
    
        elseif random_colour_chosen == true then
            -- get a random colour
            r_value = math.random(1, 255)
            g_value = math.random(1, 255)
            b_value = math.random(1, 255)

            --msg = 'r_value: '..r_value .. ', g_value: '..g_value..', b_value: '..b_value..'\n'
            --reaper.ShowConsoleMsg(msg)

            random_colour = reaper.ColorToNative(r_value, g_value, b_value)
            
            -- colour the track
            reaper.SetTrackColor(track, random_colour)

        end
    end



end