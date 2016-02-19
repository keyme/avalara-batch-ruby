require_relative '../lib/avatax_batch.rb'

AvaTax.configure_from 'credentials.yml'

samples_config = YAML.load_file('config.yml')

batch_svc = AvaTax::BatchService.new(
  #header parameters
  :clientname => "AvaTaxBatchTest",

  #optional header parameters
  :name => "Development"
)

batch_fetch_request = {
  :fields => "Files",
  :filters => "BatchId=#{samples_config['batch_id']}"
}

batch_fetch_result = batch_svc.batch_fetch(batch_fetch_request)

puts "BatchFetch ResultCode: #{batch_fetch_result[:result_code]}"

if batch_fetch_result[:messages]
  batch_fetch_result[:messages].each { |message| puts message }
end
