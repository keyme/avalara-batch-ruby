require_relative '../lib/avatax_batch.rb'

AvaTax.configure_from 'credentials.yml'

batch_svc = AvaTax::BatchService.new(
  #header parameters
  :clientname => "AvaTaxBatchTest",

  #optional header parameters
  :name => "Development"
)

ping_request = {
  :message => "test message"
}

ping_result = batch_svc.ping(ping_request)

puts "PingTest ResultCode: #{ping_result[:result_code]}"

if ping_result[:messages]
  ping_result[:messages].each { |message| puts message }
end
