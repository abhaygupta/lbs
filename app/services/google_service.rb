class GoogleService
  include HTTParty
  format :json
  
  attr_accessor :response_object
  def initialize(response_object = nil)
    self.response_object = response_object
  end

  class << self
    def distance_metrics(start, dest)
      distance_metric_hash = {}
      begin
        logger.info "distance between start=#{start.to_s} end=#{dest.to_s}"
        response = GoogleService.new(GoogleService.get("#{Lbs::App.settings.google_url}/distancematrix/json?origins=#{start.lat},#{start.lng}&destinations=#{dest.lat},#{dest.lng}&sensor=false&language=en&key=#{Lbs::App.settings.google_api_key}"))
        distance_metric_hash = response.success? ? response.get_distance_metrics : nil 
        #if google doesn't return distance metrics use haversinse formula
        distance_metric_hash = response.get_distance_using_haversine(start, dest) if distance_metric_hash.blank?
      rescue Exception => e
        logger.info "Google Service get distance metrics failed for start=#{start.to_s} dest=#{dest.to_s}. Exception : #{e.message}"
     end
     distance_metric_hash
    end

    def address(location)
      begin
        logger.info "Google Service adress called with location=#{location.to_s}"
        response = GoogleService.new(GoogleService.get("#{Lbs::App.settings.google_url}/geocode/json?latlng=#{location.lat},#{location.lng}&sensor=false&key=#{Lbs::App.settings.google_api_key}"))
        response.success? ? response.get_address : nil
      rescue Exception => e
        logger.info "Google Service address translation failed for location=#{location.to_s}. Exception=#{e.message}"
        nil
      end
    end
    
    def location(address) 
      begin
        logger.info "Google Service location called with address=#{address.to_s}"
        response = GoogleService.new(GoogleService.get("#{Lbs::App.settings.google_url}/geocode/json?address=#{CGI::escape(address.to_s)}&sensor=false&key=#{Lbs::App.settings.google_api_key}"))
        response.success? ? response.get_location : nil
      rescue Exception => e
        logger.info "Google Service location translation failed for address=#{address.to_s}. Exception=#{e.message}"
        nil
      end
    end
  end
  
  def success?
    %w(ok success).include?(response_object.parsed_response["status"].try(:downcase))
  end

  def get_address
    address_hash = {:address=> nil}
    begin
      if (result = response_object.parsed_response["results"]).present?
          if (addresses = result.collect{|r| r.try(:[], "formatted_address")}).present?
            addresses = addresses.sort {|addr1, addr2| addr1.size <=> addr2.size}.reverse
            address_hash[:address] = addresses.first
          end
        end
    rescue Exception => e
      logger.error "Error getting the address, Exception=#{e.message}"
    end
    address_hash    
  end
  
  def get_distance_metrics
    distance_metrics = {}
    begin
      if (rows = response_object.parsed_response.try(:[], "rows"))
        if rows.present? && rows.size > 0 && (elements = rows[0].try(:[], "elements")).present? && elements.size > 0 
          if (distance_hash = elements[0].try(:[], "distance")).present? && distance_hash["value"].present?
            distance_metrics.merge!({:distance =>  distance_hash["value"], :distance_unit=>'METER'})
          end
          if (duration_hash = elements[0].try(:[], "duration")).present? && duration_hash["value"].present?
            distance_metrics.merge!({:duration => duration_hash["value"], :duration_unit=>'SECONDS'})
          end          
        end
      end
    rescue Exception => e
      logger.error "Error getting the address, Exception=#{e.message}"
    end
    logger.info "distance metrics found #{distance_metrics}"
    distance_metrics
  end
  
  def get_distance_using_haversine(start, dest)
    logger.info "Using haversine to calculate distance metrics from start=#{start.to_s} dest=#{dest.to_s}"
    distance_metrics = {:distance=> nil, :distance_unit=>'METER', :duration=> nil, :duration_unit=>'SECONDS'}
    distance_metrics[:distance] = GeoDistance::Haversine.geo_distance(start.lat, start.lng, dest.lat, dest.lng).to_meters * Lbs::App.settings.haversine_distance_normalizer
    distance_metrics[:duration] = distance_metrics[:distance].to_f/Lbs::App.settings.approx_avg_speed
    distance_metrics
  end
  
  def get_location
    location_hash = {:lat=>nil, :lng=>nil, :viewport=>nil, :address=>nil}
    begin
      if (results = response_object.parsed_response.try(:[],"results")).present? && results.size > 0 
        if (geometry=results[0].try(:[],"geometry")).present? && (location = geometry.try(:[], "location")).present? 
          location_hash[:lat] = location.try(:[], "lat")
          location_hash[:lng] = location.try(:[], "lng")
        end
        location_hash[:viewport] = geometry.try(:[], "viewport")
        location_hash[:address] = results[0].try(:[], "formatted_address")
      end
    rescue Exception => e
      logger.error "Error getting location from address, Exception=#{e.message}"
    end
    logger.info "location found #{location_hash}"
    location_hash
  end
end