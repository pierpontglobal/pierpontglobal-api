# frozen_string_literal: true

# Base controller for the version 1 of the API
class Api::V1::BaseController < ApplicationController

  def version
    render json: { version: 1 }, status: :ok
  end

end
