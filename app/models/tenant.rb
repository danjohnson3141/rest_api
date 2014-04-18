class Tenant

  # This whole mechanism should be refactor to handle dynamically of adding new clients.

  def initialize(request=nil)
    @request = request
    @tenants = {}
    setup_tenants
  end

  def get_database_name
    return nil if token_from_request.nil? 
    @tenants[token_from_request][:database]
  end

  def get_client_host
    return nil if token_from_request.nil? 
    @tenants[token_from_request][:host]
  end

  def token
    token_from_request
  end

  # used for generating uniq tenant keys - memcached
  def name_space(data)
    data.unshift(token) if data.is_a?(Array)
    data = token + data if data.is_a?(String)
    data
  end

  private
  def token_from_request
    @request.env["HTTP_X_API_TENANT"] if !@request.nil?
  end

  # Hard coded tenants for now.
  def setup_tenants

    @tenants["y130Kq3146iaPHvF6o2KTktUiHMgwG2L"] = { database: "EvantaAccess_Test", host: "http://localhost:3000" }


    case Rails.env
    when "development"
      @tenants["18i09H5ylZ0n1dkfW8v2DJNw080sh30D"] = { database: "EvantaAccess", host: "http://localhost:1337" }
    when "staging"
      @tenants["18i09H5ylZ0n1dkfW8v2DJNw080sh30D"] = { database: "EvantaAccess", host: "https://stage-access.evanta.com" }
    when "production"
      # Todo
    end


  end


end