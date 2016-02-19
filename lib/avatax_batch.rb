require 'savon'
require 'erb'

module AvaTax
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.configure_from(yaml_file)
    require 'yaml'
    config_file = YAML.load_file(yaml_file)

    configure do |config|
      config.username = config_file['username']
      config.password = config_file['password']
      config.accountid = config_file['accountid']
      config.companyid = config_file['companyid']
      config.service_url = config_file['service_url']
    end
  end

  class Configuration
    attr_accessor :username, :password, :accountid, :companyid, :service_url

    def initialize
      @username = ENV['AVATAX_USERNAME'] || ""
      @password = ENV['AVATAX_PASSWORD'] || ""
      @accountid = ENV['AVATAX_ACCOUNTID'] || ""
      @companyid = ENV['AVATAX_COMPANYID'] || ""
      @service_url = ENV['AVATAX_SERVICE_URL'] || ""
    end
  end

  class BatchService
    def initialize(credentials = {})

      username = AvaTax.configuration.username
      password = AvaTax.configuration.password
      service_url = AvaTax.configuration.service_url

      @soap_header = {
        "ser:Profile" => {
          "ser:Name" => credentials[:name] || "",
          "ser:Client" => credentials[:clientname] || "AvataxBatchRuby",
          "ser:Adapter" => credentials[:adapter] || "",
          "ser:Machine" => credentials[:machine] || ""
        }
      }

      @client = Savon.client(
        wsdl: "#{self.class.lib}/batchservice.wsdl",
        endpoint: URI.parse("#{service_url}/Batch/BatchSvc.asmx"),
        wsse_auth: [username, password],
        namespaces: { "xmlns:ser" => "http://avatax.avalara.com/services" },
        namespace_identifier: :ser,
        convert_request_keys_to: :camelcase
      )
    end

    def self.root
      File.dirname(__dir__)
    end

    def self.lib
      File.join(root, 'lib')
    end

    def ping(message = {})
      message = { :Message => message[:message] }

      call_service("ping", message)
    end

    def is_authorized(message = {})
      message = { :Operations => message[:operations] }

      call_service("is_authorized", message)
    end

    def batch_fetch(message = {})
      message = {
        :FetchRequest => {
          :Fields => message[:fields],
          :Filters => message[:filters]
        }
      }

      call_service("batch_fetch", message)
    end

    def batch_file_fetch(message = {})
      message = {
        :FetchRequest => {
          :Fields => message[:fields],
          :Filters => message[:filters] 
        }
      }

      call_service("batch_file_fetch", message)
    end

    def batch_save(message = {})
      message = {
        :Batch => {
          :AccountId => AvaTax.configuration.accountid,
          :CompanyId => AvaTax.configuration.companyid,
          :Name => message[:name],
          :BatchTypeId => message[:batchtypeid],
          :Files => {
            :BatchFile => {
              :Content => message[:content],
              :ContentType => message[:contenttype],
              :Ext => message[:ext],
              :Name => message[:name],
              :Size => message[:size],
              :FilePath => message[:filepath]
            }
          }
        }
      }
      call_service("batch_save", message)
    end

    private

    def call_service(service, message)
      begin
        response = @client.call(service.to_sym, :soap_header => @soap_header, :message => message).to_hash

        return response["#{service}_response".to_sym]["#{service}_result".to_sym]
      rescue Savon::Error => error
        return format_error(error)
      end
    end

    def format_error(response)
      response = response.to_hash

      return response if !response[:fault]

      response = {
        result_code: "Error",
        messages: response[:fault].values
      }
    end
  end
end
