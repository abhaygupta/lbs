Lbs::App.controllers '/geocode' do
  
  get '/', :provides=> [:json, :xml] do
    logger.info "geocode called for address=#{params[:address]}"
    response = {:status=>"FAILURE", :request=>"GEOCODE"}
    status_code = 400
    if params[:address].present?
      geocode_hash = GoogleService.location(params[:address])
      if geocode_hash.present? 
        status_code = 200
        response.merge!({:status=>"SUCCESS"}).merge!(geocode_hash)
      else
        response.merge!({:reason=>"Unable to geocode input address"})
      end
    else
      response.merge!({:reason=>"Empty or invalid address input"})
    end
    logger.info "geocode address=#{params[:address]}. status=#{status_code} response=#{response}"
    status status_code
    response.to_json
  end
  
end
