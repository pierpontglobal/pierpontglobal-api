# frozen_string_literal: true

# Defines the cars model
class Car < ApplicationRecord
  searchkick word_middle: %i[model_name maker_name car_type]

  def search_data
    {
      model_name: model.name,
      maker_name: model.maker.name,
      car_type: vehicle_type.type_code,
      year: year,
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
