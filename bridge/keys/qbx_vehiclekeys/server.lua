return {
  AddKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not add keys, vehicle does not exist!') return false end

    exports.qbx_vehiclekeys:GiveKeys(source, vehicle, true)
  end, 
  
  RemoveKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not remove keys, vehicle does not exist!') return false end

    exports.qbx_vehiclekeys:RemoveKeys(source, vehicle, false)
  end,

  HasKeys = function(source, vehicle)
    if not DoesEntityExist(vehicle) then lib.print.error('Could not check for keys, vehicle does not exist!') return false end

    return exports.qbx_vehiclekeys:HasKeys(source, vehicle)
  end
}