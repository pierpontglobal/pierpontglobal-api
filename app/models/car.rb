# frozen_string_literal: true

class Car < ApplicationRecord
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
      .joins(:model).merge(Model.sanitized)
      .joins(:fuel_type).merge(FuelType.sanitized)
      .joins(:interior_color).merge(Color.sanitized('colors', 'interior'))
      .joins(:exterior_color).merge(Color.sanitized('exterior_colors_cars',
                                                    'exterior'))
      .joins(:body_style).merge(BodyStyle.sanitized)
      .joins(:vehicle_type).merge(VehicleType.sanitized)
      .joins(:seller_types).merge(SellerType.sanitized)
  }

  scope :newest, lambda {
    order('id DESC')
  }
end