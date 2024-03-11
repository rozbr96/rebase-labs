
def root_url
  "http://127.0.0.1:#{ENV['API_PORT']}"
end

def api_v1_tests_url
  "http://localhost:#{ENV['API_PORT']}/api/v1/tests"
end

def api_v2_tests_url
  "http://localhost:#{ENV['API_PORT']}/api/v2/tests"
end
