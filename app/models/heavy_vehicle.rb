class HeavyVehicle < ApplicationRecord
  searchkick word_middle: [:heavy_vehicle_identifier],
             callbacks: :async

  def search_data
    {
        heavy_vehicle_identifier: "",
        release: release,
        fielddata: true
    }
  end

end
