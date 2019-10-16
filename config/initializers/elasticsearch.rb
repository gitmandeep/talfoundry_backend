if Rails.env == 'production'
  url = 'http://localhost:9200/'
  transport_options = { request: { timeout: 250 } }
  options = { hosts: url, retry_on_failure: true, transport_options: transport_options }
  Searchkick.client = Elasticsearch::Client.new(options)
end