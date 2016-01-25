require 'spec_helper'

describe "Ping" do

  before :each do
    AvaTax.configure_from 'credentials.yml'
  end

  context "request credentials" do
    let(:faultcode) { "a:InvalidSecurity" }

    it 'authenticates successfully when username and password are valid' do
      service = AvaTax::BatchService.new
      response = service.ping
      expect(response[:result_code]).to eq("Success")
    end

    it 'is invalid when username is empty' do
      AvaTax.configuration.username = ""

      service = AvaTax::BatchService.new
      response = service.ping
      expect(response[:result_code]).to eq("Error")
      expect(response[:messages].first).to eq(faultcode)
    end

    it 'is invalid when password is empty' do
      AvaTax.configuration.password = ""

      service = AvaTax::BatchService.new
      response = service.ping
      expect(response[:result_code]).to eq("Error")
      expect(response[:messages].first).to eq(faultcode)
    end

    it 'is invalid when username is incorrect' do
      AvaTax.configuration.username = "invalid_username"

      service = AvaTax::BatchService.new
      response = service.ping
      expect(response[:result_code]).to eq("Error")
      expect(response[:messages].first).to eq(faultcode)
    end

    it 'is invalid when password is incorrect' do
      AvaTax.configuration.password = "invalid_password"

      service = AvaTax::BatchService.new
      response = service.ping
      expect(response[:result_code]).to eq("Error")
      expect(response[:messages].first).to eq(faultcode)
    end

    it 'returns error when url is empty' do
      AvaTax.configuration.service_url = ""

      expect{ AvaTax::BatchService.new.ping }.to raise_error(ArgumentError)
    end 
  end
end
