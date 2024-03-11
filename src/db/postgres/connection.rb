
class PGConnection
  HOST = ENV['DB_HOST']
  DB_NAME = ENV['DB_NAME']
  USERNAME = ENV['DB_USERNAME']
  PASSWORD = ENV['DB_PASSWORD']
  PORT = ENV['DB_PORT']

  def self.execute sql_command
    %x(
      PGPASSWORD=#{PASSWORD} psql -h #{HOST} \
        -U #{USERNAME} -d #{DB_NAME} -p #{PORT} \
        -c \"#{sql_command}\"
    )
  end
end
