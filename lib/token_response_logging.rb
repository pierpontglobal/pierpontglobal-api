module TokenResponseLogging
  def body
    additional_data = {
        'source' => 'rails'
    }
    # call original `#body` method and merge its result with the additional data hash
    super.merge(additional_data)
  end
end