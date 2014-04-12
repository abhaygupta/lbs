lbs
===

Location based service

- Configure google api key at app.rb (google_api_key). You can obtain api key from https://code.google.com/apis/console.
- Uses following google api's - so access need to be enabled for same from google api console (may require server restart to take into affect)
        - Geocoding API
        - Distance Matrix API
- Also, uses haversine formulae to calculate distance/duration between given locations. Usefule in case goole api limit is reached.
	- haversine distance is linear distance between two location, to normalize it. Can be configured in app.rb haversine_distance_normalizer (currently set to 1.3)
	- to calculate duration to travel, we assume speed to be 12 kmph ( :) as per bangalore). Can be configure in app.rb approx_avg_speed (currently set to 3 meter /sec)

Supported api's

1. Geocode api
	- Signature: http://localhost:3000/geocode?address=RMZ+Ecospace
	- Input param: address - String address (url encoded) - mandatory
	- Request: GET
	- Return:
		- status: 200 (success)
		- response :
				{
				status: "SUCCESS"
				request: "GEOCODE"
				lat: 12.9262541
				lng: 77.6811184
				viewport: {
					northeast: {
						lat: 12.9278609
						lng: 77.68231378029151
						}
					southwest: {
					lat: 12.9246889
					lng: 77.6796158197085
					}
				}
				address: "RMZ Ecospace Internal Road, Adarsh Palm Retreat, Bellandur, Bangalore, Karnataka 560103, India"
				} 
		
		- status: 400 (failure)
			{
			status: "FAILURE"
			request: "GEOCODE"
			reason: "Empty or invalid address input"
			}

2. Reverse geocode api 
	- Signature: http://localhost:3000/reverse-geocode?lat=12.9262541&lng=77.6811184
	- Input param: lat (latitude) , lng (longitude) - both mandatory
	- Request: GET
	- Return:
		- status: 200 (success)
		- response:
			{
			status: "SUCCESS"
			request: "REVERSE_GEOCODE"
			address: "RMZ Ecospace Internal Road, Adarsh Palm Retreat, Bellandur, Bangalore, Karnataka 560103, India"
			}
		- status: 400 (failue)
		- response: 
			{
			status: "FAILURE"
			request: "REVERSE_GEOCODE"
			reason: "Unable to reverse-geocode input lat, lng"
			}

3. Distance api
	- Signature: http://localhost:3000/distance?slat=12&slng=13&dlat=12&dlng=14
	- Input param: slat (source latitude) , slng (source longitude), dlat (dest latitude), dlng (dest longitude)- all mandatory
        - Request: GET 
	- Return:
		- status: 200 (success)
		- response:
			{
			status: "SUCCESS"
			request: "DISTANCE"
			distance: 141445.0741583552
			distance_unit: "METER"
			duration: 47148.358052785065
			duration_unit: "SECONDS"
			}
		- status: 400 (failure)
		- response:
			{
			status: "FAILURE"
			request: "DISTANCE"
			reason: "Empty or invalid input source or dest lat, lng"
			}
