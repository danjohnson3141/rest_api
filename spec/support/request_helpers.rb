module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end

  module Extensions

    def set_headers(incoming_headers)
      incoming_headers = {} if incoming_headers.nil?
      tenant_token = "y130Kq3146iaPHvF6o2KTktUiHMgwG2L"
      headers ||= {'HTTP_X_API_TENANT' => "#{tenant_token}"}
      headers.merge(incoming_headers)
    end

    def set_auth_headers(headers_or_env)
      incoming_headers = set_headers(headers_or_env)
      incoming_headers['HTTP_AUTHORIZATION'] = 'Token token="54321"'
      incoming_headers['HTTP_X_API_EMAIL'] = 'generic_user@evanta.com'
      incoming_headers
    end

    def post(path, parameters = nil, headers_or_env = nil)
      headers_or_env = set_headers(headers_or_env)
      super(path, parameters, headers_or_env)
    end    

    def patch(path, parameters = nil, headers_or_env = nil)
      headers_or_env = set_headers(headers_or_env)
      super(path, parameters, headers_or_env)
    end    

    def put(path, parameters = nil, headers_or_env = nil)
      headers_or_env = set_headers(headers_or_env)
      super(path, parameters, headers_or_env)
    end

    def get(path, parameters = nil, headers_or_env = nil)
      headers_or_env = set_headers(headers_or_env)
      super(path, parameters, headers_or_env)
    end    

    def delete(path, parameters = nil, headers_or_env = nil)
      headers_or_env = set_headers(headers_or_env)
      super(path, parameters, headers_or_env)
    end

    def patch_auth(path, parameters = nil, headers_or_env = nil)
      patch(path, parameters, set_auth_headers(headers_or_env))
    end    

    def put_auth(path, parameters = nil, headers_or_env = nil)
      put(path, parameters, set_auth_headers(headers_or_env))
    end

    def post_auth(path, parameters = nil, headers_or_env = nil)
      post(path, parameters, set_auth_headers(headers_or_env))
    end

    def get_auth(path, parameters = nil, headers_or_env = nil)
      get(path, parameters, set_auth_headers(headers_or_env))
    end    

    def delete_auth(path, parameters = nil, headers_or_env = nil)
      delete(path, parameters, set_auth_headers(headers_or_env))
    end

  end

end