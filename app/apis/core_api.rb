class CoreAPI < Grape::API
  logger.formatter = GrapeLogging::Formatters::Default.new
  use GrapeLogging::Middleware::RequestLogger, { logger: logger }

  format :json

  helpers do
    def authenticate!
      # TODO API Authentication
    end
  end

  desc "Get Digital Address"
  params do
    requires :longitude, type: Float, desc: 'Longitude'
    requires :latitude, type: Float, desc: 'Latitude'
  end

  post "getaddress" do
    da = DigitalAddress.new
    if da.processed?(params[:latitude], params[:longitude])
      {
          status: "OK",
          data: {
              digital_address: da.address,
              formatted_address: da.formatted_address,
              latitude: da.latitude.to_f.round(6),
              longitude: da.longitude.to_f.round(6),
              region: da.region,
              city: da.city,
              district: da.district
          }
      }
    else
      {
          status: "FAIL",
          error_message: "TODO: Error message pipe",
          data: {}
      }
    end
  end
end