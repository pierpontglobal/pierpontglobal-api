# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require 'set'

# Manages the communication with Manheim
class DataPopulator

  def update_car_data
    url = URI.parse("https://integration1.api.manheim.com/isws-basic/listings?api_key=#{ENV['MANHEIM_API_KEY']}")
    p url
    req = Net::HTTP::Post.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port,
                          use_ssl: url.scheme == 'https') do |http|
      http.request(req)
    end
    sales_cars = JSON.parse(res.body)
    sales_cars['listings'].each do |car_sale_info|
      @car_info = car_sale_info['vehicleInformation']
      @car_sale = car_sale_info['saleInformation']
      car = Car.where(vin: @car_info['vin']).first_or_create!
      car.update!(
        year: @car_info['year'],
        sale_date: @car_sale['saleDate'],
        odometer: @car_info['mileage'],
        doors: @car_info['doorCount'],
        odometer_unit: @car_info['odometerUnits'],
        vehicle_type: look_for_type,
        engine: @car_info['engine'],
        model: look_for_model,
        fuel_type: look_for_fuel,
        interior_color: look_for_color(@car_info['interiorColor']),
        exterior_color: look_for_color(@car_info['exteriorColor']),
        body_style: look_for_body_style,
        transmission: @car_info['transmission'].eql?('Automatic') ? true : false,
        trim: @car_info['trim']
      )
      car.seller_types << look_for_seller_types
    end
  end

  def look_for_body_style
    BodyStyle.where(name: @car_info['bodyStyle']).first_or_create
  end

  def look_for_color(title)
    Color.where(name: title).first_or_create
  end

  def look_for_fuel
    fuel = @car_info['fuelType']
    FuelType.where(name: fuel).first_or_create
  end

  def look_for_type
    type = @car_info['typeCode']
    VehicleType.where(type_code: type).first_or_create
  end

  def look_for_seller_types
    types = []
    @car_info['sellerTypes'].each do |type|
      types.push(SellerType.where(title: type).first_or_create)
    end
    types
  rescue
    []
  end

  def look_for_model
    maker = Maker.where(name: @car_info['make']).first_or_create
    model = Model.where(name: @car_info['model']).first_or_create
    maker.models << model
    model
  end

end