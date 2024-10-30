return {
  HasKeys = function(vehicle)
    if not DoesEntityExist(vehicle) then return error('Could not check for keys, vehicle does not exist!') end
    
    return exports.qbx_vehiclekeys:HasKeys(vehicle)
  end
}