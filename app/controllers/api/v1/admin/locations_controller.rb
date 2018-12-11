# frozen_string_literal: true

class Api::V1::Admin::LocationsController < Api::V1::AdminBaseController
  def create
    render json: Location.where(locations_parameters)
                         .first_or_create!,
           status: :ok
  end

  def show; end # TODO

  def delete; end # TODO

  def update; end # TODO

  private

  def locations_parameters
    params.require('location').permit('name', 'mh_id')
  end
end
