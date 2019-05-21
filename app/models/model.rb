class Model < ApplicationRecord

  belongs_to :maker, optional: true

  scope :sanitized, lambda {
    select("#{Model.table_name}.name AS car_model")
      .left_joins(:maker)
      .merge(Maker.sanitized)
  }

  def sanitazed_info
    {
        id: id,
        maker: ::Maker.where(:id => maker_id).map(&:sanitazed_info)[0],
        name: name
    }
  end

end
