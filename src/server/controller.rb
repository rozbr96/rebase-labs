
class Controller
  def self.tests request
    request.client.close
  end
end
