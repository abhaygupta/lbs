Lbs::App.controllers '/reverse-geocode' do
  
  get '/', :provides=> [:json, :xml] do
    logger.info "reverse-geocode called for lat=#{params[:lat]} lng=#{params[:lng]}"
    response = {:status=>"FAILURE", :request=>"REVERSE_GEOCODE"}
    status_code = 400
    if params[:lat].present? && params[:lng].present? && numeric?(params[:lat]) && numeric?(params[:lng])
      rev_geocode_hash = GoogleService.address(Location.new(params[:lat], params[:lng]))
      if rev_geocode_hash.present? 
        status_code = 200
        response.merge!({:status=>"SUCCESS"}).merge!(rev_geocode_hash)
      else
        response.merge!({:reason=>"Unable to reverse-geocode input lat, lng"})
      end
    else
      response.merge!({:reason=>"Empty or invalid input lat, lng"})
    end
    logger.info "reverse-geocode for lat=#{params[:lat]} lng=#{params[:lng]} status=#{status_code} response=#{response}"
    status status_code
    response.to_json
  end
  
end
