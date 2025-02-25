plugin_map = { -- you CAN have multiple different keys mapping to the same value
    r = 'Pro-R 2', -- you CANNOT have the same keys mapping to different values
    q = 'Pro-Q 4',
    d = 'ValhallaDelay',
    s = 'Saturn 2',
    m = 'Pro-MB',
    c = 'Pro-C 2',
    serum = 'Serum',
    morph = 'MORPH',
    volcano = 'Volcano 3',
    ir1 = 'IR1 Mono/Stereo',
    a = 'Aurora',
    aurora = 'Aurora',
    l = 'Ozone 11 Vintage Limiter',
    limiter = 'Ozone 11 Vintage Limiter',
    maximiser = 'Ozone 11 Maximizer',
    p = 'Plasma',
    e = 'Excalibur',
    split = 'SplitEQ',
    timeless = 'Timeless 3',
    sine = "Tone Generator",
    pink = "Pink Noise Generator",
    gate = "Neutron 5 Gate",
    g = "Neutron 5 Gate",
    neutron = 'Neutron 5',
    soothe = 'soothe2',
    cascadia = 'Cascadia',
    cas = 'Cascadia',
    chorus = 'kHs Chorus',
    vvv = 'ValhallaVintageVerb',
    formant = 'kHs Formant Filter',
    phaseplant = 'Phase Plant',
    horizon = 'Stratus (iZotope)',
    trash = 'Trash',
}


function print_list()
    -- For each row in our key/ value (plugin_map), print out the key: value

    for key, value in pairs(plugin_map) do
        local msg = key .. ': ' .. value .. '\n'
        -- .. means concatenate, basically adding a string with another string
        reaper.ShowConsoleMsg(msg)
    end
end

num_of_sel_items = reaper.CountSelectedMediaItems(active_project)

if num_of_sel_items == 1 then

    -- prompt the user for which plugin we want
    ret_val, user_input = reaper.GetUserInputs('Insert plugin to Track', 1, 
                                         'type help for key list', '')

    if ret_val == true then

        if user_input == 'help' then
            print_list()
        end

        -- find the plugin name from the map (above) for the key that the user put in
        plugin_name = plugin_map[user_input]
        --  if user_input is not found as a key in plugin_map, plugin_name will be nil

        -- Get a reference to the selected item and then its active take
        item = reaper.GetSelectedMediaItem(activeProj, 0)
        take = reaper.GetActiveTake(item)

        recFX = false
        if plugin_name then -- this is a nil check for plugin_name
            instantiate = -1
            fx_index = reaper.TakeFX_AddByName(take, plugin_name, instantiate)
            
            show_fx = 1
            reaper.TakeFX_Show(take, fx_index, show_fx)
        else
            -- if plugin_name IS nil, we enter in here
            print_list()
        end
    end
end