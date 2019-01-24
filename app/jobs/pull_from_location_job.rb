# frozen_string_literal: true

require 'uri'
require 'net/http'

class PullFromLocationJob
  include Sidekiq::Worker
  sidekiq_options queue: 'car_pulling'

  def perform(*args)
    # register_worker(obtain_token)
    params = args.first

    url = URI("https://api.manheim.com/isws-basic/listings?api_key=#{ENV['MANHEIM_API_KEY']}")

    req = Net::HTTP::Post.new(url.to_s)
    req['Content-Type'] = 'application/x-www-form-urlencoded'
    req.body = "pageSize=#{params['chunks_size']}&INVENTORY_SOURCE=57&YEAR=#{params['year']}&LOCATION=#{params['location']}&pageNumber=#{params['index']}"
    res = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
      http.request(req)
    end

    create_or_update JSON.parse(res.body)
  end

  private

  def register_worker(token)
    url = URI.parse('https://api.pierpontglobal.com/api/v1/admin/configuration/register_ip')
    req = Net::HTTP::Get.new(url.to_s)
    req['Authorization'] = "Bearer #{token}"

    res = Net::HTTP.start(url.host, url.port,
                          use_ssl: url.scheme == 'https') do |http|
      http.request(req)
    end
    res.body
  end

  def obtain_token
    url = URI.parse('https://api.pierpontglobal.com/oauth/token')
    req = Net::HTTP::Post.new(url.to_s)
    req['Content-Type'] = 'application/json'
    req.body = {
      username: 'admin',
      password: 'WefrucaT7TAhl4weNUdr',
      grant_type: 'password'
    }.to_json

    res = Net::HTTP.start(url.host, url.port,
                          use_ssl: url.scheme == 'https') do |http|
      http.request(req)
    end
    JSON.parse(res.body)['access_token']
  end

  # Creates or updates cars
  def create_or_update(sales_cars)
    return if sales_cars['listings'].nil?
    sales_cars['listings'].each do |car_sale_info|
      @car_info = car_sale_info['vehicleInformation']
      @car_sale = car_sale_info['saleInformation']
      next if @car_info['images'].blank?

      car = Car.where(vin: @car_info['vin']).first_or_create!
      car_sale_object = SaleInformation.where(car_id: car.id).first_or_create!
      car_sale_object.update(
        current_bid: @car_info['currentBidPrice'],
        channel: @car_sale['channel'],
        sale_date: @car_sale['saleDate'],
        auction_id: @car_sale['auctionId'],
        auction_start_date: @car_sale['auctionStartDate'],
        auction_end_date: @car_sale['auctionEndDate'],
        action_location: @car_sale['auctionLocation']
      )

      images_directories = FileDirection.where(car_id: car.id)
      unless @car_info['images'].blank?
        if images_directories.length != @car_info['images'].try(:length)
          images_directories.each(&:destroy!)
          @car_info['images'].each do |image|
            FileDirection.create!(
              car_id: car.id,
              route: image['largeUrl'],
              order: image['sequence'],
              description: image['description']
            )
          end
        end
      end

      car.update(
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
        trim: @car_info['trim'],
        condition_report: @car_info['conditionGradeNumDecimal']
      )

      seller_types = look_for_seller_types
      seller_types.each do |seller_type|
        (car.seller_types.push seller_types) unless car.seller_types.include? seller_type
      end
    end
  end

  def look_for_body_style
    BodyStyle.where(name: @car_info['bodyStyle']).first_or_create!
  end

  def look_for_color(title)
    Color.where(name: title).first_or_create!
  end

  def look_for_fuel
    fuel = @car_info['fuelType']
    FuelType.where(name: fuel).first_or_create!
  end

  def look_for_type
    type = @car_info['typeCode']
    VehicleType.where(type_code: type).first_or_create!
  end

  def look_for_seller_types
    types = []
    @car_info['sellerTypes'].each do |type|
      types.push(SellerType.where(title: type.strip).first_or_create!)
    end
    types
  rescue StandardError
    []
  end

  def look_for_model
    maker = Maker.where(name: @car_info['make']).first_or_create!
    model = Model.where(name: @car_info['model']).first_or_create!
    maker.models << model
    model
  end
end
