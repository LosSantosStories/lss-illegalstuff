lib.locale()
--IF YOU DONT KNOW WHAT ARE YOU DOING JUST DONT TOUCH ANYTHING :)

function LockpickVehicle(entity)
    local Driver = GetPedInVehicleSeat(entity, -1)
    if IsPedAPlayer(Driver) then return end
    Wait(1000)
    lib.requestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    TaskPlayAnim(cache.ped, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer', 8.0, 8.0 , -1, 1)

    local success = lib.skillCheck(Config.SettingsLockpick.Skillcheck, {'w', 'a', 's', 'd'})

    if success then
        if lib.progressCircle({
            duration = Config.SettingsLockpick.Duration,
            label = locale('lockpicking'),
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                combat = true,
                move = true,
                car = true,
            },
            anim = {
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                clip = 'machinic_loop_mechandplayer',
                flag = 16
            },
        }) 
        then
            lib.notify({
                title = locale('notification_title'),
                description = locale('unlocked_door'),
                type = 'inform'
            })
            if IsPedAPlayer(Driver) then return end
            while NetworkGetEntityOwner(entity) ~= PlayerId() do
                NetworkRequestControlOfEntity(entity)
                Wait(10)
            end

            SetVehicleEngineOn(entity, false, true ,true)
            ClearPedTasks(cache.ped)
            SetVehicleDoorsLocked(entity, 1)
            TriggerServerEvent('lss-illegalpack:server:RemoveLockPick')
            
            local Seats = GetVehicleModelNumberOfSeats(GetEntityModel(entity))
            for i = -1, Seats do
                if not IsVehicleSeatFree(entity, i) then
                    local NPC = GetPedInVehicleSeat(entity, i)
                    TaskLeaveVehicle(NPC, entity, 0)
                    Wait(1500)
                    TaskSmartFleePed(NPC, cache.ped, 1000.0, -1, false, false)
                end
            end
        else         
            lib.notify({
                title = locale('notification_title'),
                description = locale('progress_cancel'),
                type = 'error'
            })
            ClearPedTasks(cache.ped)
        end
        FreezeEntityPosition(entity, false)
    else
        lib.notify({
            title = locale('notification_title'),
            description = locale('lockpick_failed'),
            type = 'inform'
        })
        TriggerServerEvent('lss-illegalpack:server:RemoveLockPick')
        ClearPedTasks(cache.ped)
        FreezeEntityPosition(cache.ped, false)
        FreezeEntityPosition(entity, false)
    end
end

local function SetTarget()
    local TargetOptions = {
        {
            name = 'lss-lockpick',
            icon = 'fa-solid '..Config.SettingsLockpick.Icon,
            items = Config.SettingsLockpick.Item,
            onSelect = function (data)

                local DoorOffset = GetOffsetFromEntityInWorldCoords(data.entity, -1.0, -1.0, 0.0)
                FreezeEntityPosition(data.entity, true)
                TaskGoToCoordAnyMeans(cache.ped, DoorOffset.x, DoorOffset.y, DoorOffset.z, 1.0, 0.0, false, -1, 0)
                while true do
                    if IsEntityAtCoord(cache.ped, DoorOffset.x, DoorOffset.y, DoorOffset.z, 0.8, 0.8, 0.8, 0, 1, 0) then
                        TaskTurnPedToFaceEntity(cache.ped, data.entity)
                        LockpickVehicle(data.entity)
                        break
                    end
                    Wait(100)
                end
            end,
            label = locale('target_lockpick'),
            canInteract = function(entity)
                local Job = ESX.PlayerData.job.name

                for k,v in pairs(Config.BlacklistedJobs) do
                    if Job == v then
                        return false
                    end
                end
                return GetVehicleDoorLockStatus(entity) == 2 and GetEntitySpeed(entity) == 0.0
            end
        }
    }
    exports.ox_target:addGlobalVehicle(TargetOptions)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    Wait(100)
    SetTarget()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Wait(100)
    SetTarget()
end)

