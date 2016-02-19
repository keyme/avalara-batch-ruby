require_relative '../lib/avatax_batch.rb'

AvaTax.configure_from 'credentials.yml'

samples_config = YAML.load_file('config.yml')

batch_svc = AvaTax::BatchService.new(
  #header parameters
  :clientname => "AvaTaxBatchTest",

  #optional header parameters
  :name => "Development"
)

batch_file_fetch_request = {
  :fields => "*,Content",
  :filters => "BatchFileId=#{samples_config['batch_file_id']}"
}

batch_file_fetch_result = batch_svc.batch_file_fetch(batch_file_fetch_request)

puts "BatchFileFetch ResultCode: #{batch_file_fetch_result[:result_code]}"

if batch_file_fetch_result[:messages]
  batch_file_fetch_result[:messages].each { |message| puts message }
end
