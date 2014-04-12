class Location
  attr_accessor :lat, :lng, :address
  
  def initialize(lat, lng, address="")
    self.lat = lat
    self.lng = lng
    self.address = address  
  end
    
  def to_s
    "lat: #{lat} lng: #{lng} address: #{address.to_s}".downcase
  end
end