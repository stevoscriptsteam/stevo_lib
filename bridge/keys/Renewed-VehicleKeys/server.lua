

return {
  AddKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not add keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['Renewed-Vehiclekeys']:addKey(source, plate)
  end, 
  
  RemoveKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not remove keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['Renewed-Vehiclekeys']:removeKey(source, plate)
  end,

  HasKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not check for keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['Renewed-Vehiclekeys']:hasKey(source, plate)
  end
}