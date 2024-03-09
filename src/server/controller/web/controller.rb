
module Controller
  module WEB
    def self.index request, response
      response.render 'index'
    end

    def self.serve_static_file request, response
      response.serve request.params['static_file']
    end
  end
end
