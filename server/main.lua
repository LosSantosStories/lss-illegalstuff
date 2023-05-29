lib.versionCheck('LosSantosStories/lss-illegalstuff')

RegisterNetEvent('lss-illegalpack:server:RemoveLockPick', function ()
    exports.ox_inventory:RemoveItem(source, Config.SettingsLockpick.Item, 1)
end)

AddEventHandler('entityCreated', function(entity)
    if GetEntityType(entity) ~= 2 or GetEntityPopulationType(entity) == 7 then return end
    SetVehicleDoorsLocked(entity, 2)
end)