
def api_host
  '127.0.0.1'
end

def api_port
  ENV['API_PORT']
end

def root_url
  "http://#{api_host}:#{api_port}"
end

def api_v1_tests_url
  "http://#{api_host}:#{api_port}/api/v1/tests"
end

def api_v2_tests_url
  "http://#{api_host}:#{api_port}/api/v2/tests"
end

def api_v2_test_url token
  "http://#{api_host}:#{api_port}/api/v2/tests/#{token}"
end
