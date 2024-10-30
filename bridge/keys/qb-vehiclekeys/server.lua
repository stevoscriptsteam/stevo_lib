return {
  AddKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not add keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['qb-vehiclekeys']:GiveKeys(source, plate)
  end, 
  
  RemoveKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not remove keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['qb-vehiclekeys']:RemoveKeys(source, plate)
  end,

  HasKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not check for keys, vehicle does not exist!') return false end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports['qb-vehiclekeys']:HasKeys(source, plate)
  end
}