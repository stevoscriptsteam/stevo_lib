

return {
  AddKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not add keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports.wasabi_carlock:GiveKey(source, plate)
  end, 
  
  RemoveKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not remove keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports.wasabi_carlock:RemoveKey(source, plate)
  end,

  HasKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not check for keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports.wasabi_carlock:HasKey(source, plate)
  end
}