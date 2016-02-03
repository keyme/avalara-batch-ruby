require_relative '../lib/avatax_batch.rb'

AvaTax.configure_from 'credentials.yml'

filename = 'avalara_sample.csv'
file = File.binread(filename)
content = Base64.strict_encode64(file)
size = file.size

batch_svc = AvaTax::BatchService.new(
  #header parameters
  :clientname => "AvaTaxBatchTest",

  #optional header parameters
  :name => "Development"
)

batch_save_request = {
  :batchtypeid => "TransactionImport",
  :name => filename,

  #batchfile
  :content => content, #base64Binary
  :contenttype => "application/CSV",
  :ext => ".csv",
  :filepath => filename,
  :size => size #integer size of byte array
}

batch_save_result = batch_svc.batch_save(batch_save_request)

puts "BatchSaveTest ResultCode: #{batch_save_result[:result_code]}"

if batch_save_result[:messages]
  batch_save_result[:messages].each { |message| puts message }
end
