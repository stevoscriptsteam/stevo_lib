

return {
  HasKeys = function(vehicle)
    if not DoesEntityExist(vehicle) then return error('Could not check for keys, vehicle does not exist!') end

    local plate = GetVehicleNumberPlateText(vehicle)
    return exports.wasabi_carlock:HasKey(plate)
  end
}