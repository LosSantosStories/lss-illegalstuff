
RegisterNetEvent('lss-illegalstuff:client:HotWiring', function ()
    if cache.vehicle == false or cache.seat ~= -1 or GetIsVehicleEngineRunning(cache.vehicle) == 1 then return end
    local Networked = NetworkGetNetworkIdFromEntity(cache.vehicle)
    local Obj = Entity(NetToVeh(Networked))

    if Obj.state.HotWire_Failed then
        lib.notify({
            title = locale('notification_title'),
            description = locale('already_tried'),
            type = 'inform'
        })
        return
    end

    lib.requestAnimDict('veh@break_in@0h@p_m_one@')

    TaskPlayAnim(cache.ped, 'veh@break_in@0h@p_m_one@', 'low_force_entry_ds', 8.0, 8.0 , -1, 16)

    local success = lib.skillCheck(Config.SettingsHotwire.Skillcheck, {'w', 'a', 's', 'd'})

    if success then
        if lib.progressCircle({
            duration = 5000,
            label = locale('hotwiring_progress'),
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                combat = true,
                car = true,
            },
            anim = {
                dict = 'veh@break_in@0h@p_m_one@',
                clip = 'low_force_entry_ds'
            },
        }) then
            SetVehicleEngineOn(cache.vehicle, true)
            lib.notify({
                title = locale('notification_title'),
                description = locale('hotwiring_success'),
                type = 'inform'
            })

        else
            Obj.state:set('HotWire_Failed', true, true)
            lib.notify({
                title = locale('notification_title'),
                description = locale('progress_cancel'),
                type = 'inform'
            })
        end
    else
        Obj.state:set('HotWire_Failed', true, true)
        lib.notify({
            title = locale('notification_title'),
            description = locale('hotwiring_failed'),
            type = 'inform'
        })
    end
end)
