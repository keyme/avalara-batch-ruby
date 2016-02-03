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

if is_authorized_result[:messages]
  is_authorized_result[:messages].each { |message| puts message }
end
