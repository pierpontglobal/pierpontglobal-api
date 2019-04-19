# frozen_string_literal: true

require 'semantic_logger'
require 'securerandom'

begin
  require 'aws-sdk-elasticsearchservice'
rescue LoadError
  raise 'Gem aws-sdk-elasticsearchservice is required for logging to AWS ElasticsearchService. Please add the gem "aws-sdk-elasticsearchservice" to your Gemfile.'
end

# Forward all log messages to an elasticsearch service hosted in AWS.
#
# Example:
#
#   SemanticLogger.add_appender(
#     appender:
#       ElasticsearchAWS.new(
#         url: ENV['ELASTICSEARCH_URL'] e.g. https://my-domain.region.es.com,
#         access_key_id: ENV['AWS_ACCESS_KEY_ID'],
#         secrete_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
#         region: ENV['AWS_REGION']
#     )
#   )

class ElasticsearchAWS < SemanticLogger::Subscriber
  attr_accessor :type, :index, :url, :level, :access_key_id, :secrete_access_key, :region

  def initialize(level: nil,
                 type: 'log',
                 index: 'semantic_logger',
                 url: 'http://localhost:9200',
                 access_key_id: nil,
                 secrete_access_key: nil,
                 region: nil,
                 &block)

    @level = level
    @type = type
    @index = index
    @url = url
    @access_key_id = access_key_id
    @secrete_access_key = secrete_access_key
    @region = region

    super(level: level, &block)
  end

  def log(log)
    return false if (level_index > (log.level_index || 0))

    formatted_log = formatter.call(log, self)
    route = "#{url}/#{index}/#{type}/#{SecureRandom.hex(10)}"

    signer = Aws::Sigv4::Signer.new(
      service: 'es',
      region: region,
      access_key_id: access_key_id,
      secret_access_key: secrete_access_key
    )

    signature = signer.sign_request(
      http_method: 'PUT',
      url: route,
      body: formatted_log.to_json
    )

    uri = URI(route)

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Put.new uri
      request.body = formatted_log.to_json
      request['Host'] = signature.headers['host']
      request['X-Amz-Date'] = signature.headers['x-amz-date']
      request['X-Amz-Security-Token'] = signature.headers['x-amz-security-token']
      request['X-Amz-Content-Sha256'] = signature.headers['x-amz-content-sha256']
      request['Authorization'] = signature.headers['authorization']
      request['Content-Type'] = 'application/json'
      http.request request
    end
  end

  private

  def default_formatter
    SemanticLogger::Formatters::Raw.new(time_format: :iso_8601, time_key: :timestamp)
  end
end
