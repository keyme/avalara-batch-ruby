require_relative '../lib/avatax_batch.rb'

AvaTax.configure_from 'credentials.yml'

batch_svc = AvaTax::BatchService.new(
  #header parameters
  :clientname => "AvaTaxBatchTest",

  #optional header parameters
  :name => "Development"
)

is_authorized_request = {
  :operations => "Ping,BatchSave,BatchFetch"
}

is_authorized_result = batch_svc.is_authorized(is_authorized_request)

puts "IsAuthorizedTest ResultCode: #{is_authorized_result[:result_code]}"
if is_authorized_result[:result_code] == "Error"
  is_authorized_result[:messages][:message].each { |k,v| puts "#{k}: #{v}" }
elsif is_authorized_result[:fault]
  is_authorized_result[:fault].each { |k,v| puts "#{k.to_s}: #{v}" }
end
