class Model < ApplicationRecord
  scope :search_import, -> { includes(:maker) }
  searchkick word_middle: [:name]

  belongs_to :maker, optional: true

  scope :sanitized, lambda {
    select("#{Model.table_name}.name AS car_model")
      .left_joins(:maker)
      .merge(Maker.sanitized)
  }

  def search_data
    {
      name: name
    }
  end

end
