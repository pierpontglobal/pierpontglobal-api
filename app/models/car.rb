# frozen_string_literal: true

# Defines the cars model
class Car < ApplicationRecord
  searchkick word_middle: [:car_search_identifiers],
             callbacks: :async

  def search_data
    {
      color: exterior_color.try(:name),
      model_name: model.try(:name),
      maker_name: model.try(:maker).try(:name),
      car_type: vehicle_type.try(:type_code),
      body_type: body_style.try(:name),
      year: year.to_s,
      doors: doors,
      engine: engine,
      fuel: fuel_type.try(:name),
      transmission: transmission,
      odometer: odometer.to_i,
      car_search_identifiers: "#{exterior_color.name} #{year} #{model.maker.name} #{model.name} #{vehicle_type.type_code}",
      timestamp: Time.now
    }
  end

  belongs_to :model, optional: true
  belongs_to :fuel_type, optional: true
  belongs_to :exterior_color, class_name: 'Color', optional: true
  belongs_to :interior_color, class_name: 'Color', optional: true
  belongs_to :body_style, optional: true
  belongs_to :vehicle_type, optional: true
  has_and_belongs_to_many :seller_types

  scope :limit_search, lambda { |offset = 0, limit = 100|
    offset(offset)
      .limit(limit)
      .distinct
  }

  scope :sanitized, lambda {
    select(:id,
           :year,
           :odometer,
           :odometer_unit,
           :displacement,
           :transmission,
           :vin,
           :doors,
           :sale_date,
           :condition,
           :engine,
           :trim)
      .left_joins(:model).merge(Model.sanitized)
      .left_joins(:fuel_type).merge(FuelType.sanitized)
      .left_joins(:interior_color).merge(Color.sanitized('colors', 'interior'))
      .left_joins(:exterior_color).merge(Color.sanitized('exterior_colors_cars',
                                                         'exterior'))
      .left_joins(:body_style).merge(BodyStyle.sanitized)
      .left_joins(:vehicle_type).merge(VehicleType.sanitized)
      .left_joins(:seller_types).merge(SellerType.sanitized)
      .group(
        'cars.id',
        :car_model,
        :car_maker,
        :car_fuel,
        :color_name_interior,
        :color_hex_interior,
        :color_name_exterior,
        :color_hex_exterior,
        :car_body_style,
        :car_vehicle_type,
        :car_type_code
      )
  }

  scope :newest, lambda {
    order('id DESC')
  }
end
