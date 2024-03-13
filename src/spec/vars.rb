
def api_host
  '127.0.0.1'
end

def api_port
  ENV['API_PORT']
end

def url base_url, params: {}
  query_string = params.each_pair.map do |key, value|
    "#{key}=#{value}"
  end.join '&'

  "#{base_url}?#{query_string}"
end

def root_url params: {}
  url "http://#{api_host}:#{api_port}", params:
end

def api_v1_tests_url params: {}
  url "http://#{api_host}:#{api_port}/api/v1/tests", params:
end

def api_v2_tests_url params: {}
  url "http://#{api_host}:#{api_port}/api/v2/tests", params:
end

def api_v2_test_url token, params: {}
  url "http://#{api_host}:#{api_port}/api/v2/tests/#{token}", params:
end
