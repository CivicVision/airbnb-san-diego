window.isAirBnBAllowed = (airBnB, homes) ->
  document.getElementById("airbnb-allowed-#{homes}").innerHTML = if airBnB.allowed then 'Allowed' else 'Not Allowed'
  document.getElementById("airbnb-allowed-#{homes}").classList.toggle('allow', airBnB.allowed)
  document.getElementById("airbnb-allowed-#{homes}").classList.toggle('permit', !airBnB.allowed)
  document.getElementById("airbnb-permit-type-#{homes}").innerHTML = airBnB.permit

window.showHumanReadableZone = (zoneCode) ->
  if zoneCode.match(/RE|RS|RX|RT|RM/)
    zone = { type: "Residential"}
    if zoneCode.match(/RE/)
      zone.sub = "Estate"
      zone.airBnb = airBnb['RE']
    if zoneCode.match(/RS/)
      zone.sub = "Single Unit"
      zone.airBnb = airBnb['RS']
    if zoneCode.match(/RX/)
      zone.sub = "Small Lot"
      zone.airBnb = airBnb['RX']
    if zoneCode.match(/RT/)
      zone.sub = "Townhouse"
      zone.airBnb = airBnb['RT']
    if zoneCode.match(/RM/)
      zone.sub = "Mulitple Unit"
      if zoneCode.match(/RM-1/)
        zone.airBnb = airBnb['RM-1']
      if zoneCode.match(/RM-2/)
        zone.airBnb = airBnb['RM-2']
      if zoneCode.match(/RM-3/)
        zone.airBnb = airBnb['RM-3']
      if zoneCode.match(/RM-4/)
        zone.airBnb = airBnb['RM-4']
      if zoneCode.match(/RM-5/)
        zone.airBnb = airBnb['RM-5']
    return zone
  if zoneCode.match(/CN|CR|CO|CV|CP/)
    zone = { type: "Commercial"}
    zone.airBnb = airBnb['Commercial']
    return zone
  if zoneCode.match(/IP|IL|IH|IS|IBT/)
    zone = { type: "Industrial"}
    zone.airBnb = airBnb['default']
    return zone
  if zoneCode.match(/OP|OC|OR|OF/)
    zone = { type: "Open Space"}
    zone.airBnb = airBnb['default']
    if zoneCode.match(/OR/)
      zone.airBnb = airBnb['OR']
    return zone
  if zoneCode.match(/AG|AR/)
    zone = { type: "Agricultural"}
    zone.airBnb = airBnb['default']
    if zoneCode.match(/AR/)
      zone.airBnb = airBnb['AR']
    return zone
  return zoneCode
findLatLng = (address) ->
  fetch("https://search.mapzen.com/v1/search?text=#{address}&boundary.country=USA&api_key=mapzen-Rxq2xk8")
  .then( (response) ->
    response.json()
  ).then( (data) ->
    data.features[0].geometry.coordinates
  )
findZoning = (lat, long) ->
  query = "SELECT * FROM city_zoning_sd WHERE ST_CONTAINS(the_geom,ST_SetSRID(ST_MakePoint({{long}},{{lat}}),4326))"
  sql = new cartodb.SQL({ user: 'milafrerichs' })
  sql.execute(query, { lat: lat, long: long})
  .done((data) ->
    if data.rows.length > 0
      zoneCode = data.rows[0].zone_name
      zoneHuman = showHumanReadableZone(zoneCode)
      isAirBnBAllowed zoneHuman.airBnb[home], home for home in ['1','3','6']
    document.getElementById('find-zone').innerHTML = 'Find my zone'
  )
  .error((errors) ->
    document.getElementById('find-zone').innerHTML = 'Find my zone'
    alert('Somethign went wrong. Please try again.')
  )
window.onload= () ->
  document.getElementById('find-zone').addEventListener("click", (event) ->
    this.innerHTML = 'Searching ...'
    event.preventDefault()
    address = document.getElementById('address').value
    unless address.match(/San Diego/)
      address += ", San Diego"
    findLatLng(address).then( (coordinates) ->
      findZoning(coordinates[1], coordinates[0])
    )
  , false)
