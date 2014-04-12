Lbs::App.controllers "/distance" do
  
  get '/', :provides=> [:json, :xml] do
    logger.info "calculating distance slat=#{params[:slat]} slng=#{params[:slng]} dlat=#{params[:dlat]} dlng=#{params[:dlng]}"
    response = {:status=>"FAILURE", :request=>"DISTANCE"}
    status_code = 400
    if numeric?(params[:slat]) && numeric?(params[:slng]) && numeric?(params[:dlat]) && 
      numeric?(params[:dlng])
      distance_hash = GoogleService.distance_metrics(Location.new(params[:slat], params[:slng]), 
        Location.new(params[:dlat], params[:dlng]))
      if distance_hash.present? 
        status_code = 200
        response.merge!({:status=>"SUCCESS"}).merge!(distance_hash)
      else
        response.merge!({:reason=>"Unable to calculate distance between input sourcea and dest"})
      end
    else
      response.merge!({:reason=>"Empty or invalid input source or dest lat, lng"})
    end
    logger.info "distance slat=#{params[:slat]} slng=#{params[:slng]} dlat=#{params[:dlat]} dlng=#{params[:dlng]}. status=#{status_code} response=#{response}"
    status status_code
    response.to_json
  end  
  
end
