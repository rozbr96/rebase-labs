
require_relative 'parser'

class PGConnection
  HOST = '127.0.0.1'
  DB_NAME = 'rebase_labs'
  USERNAME = 'rebase'
  PASSWORD = 'labs'
  PORT = 5432

  def self.execute sql_command
    %x(
      PGPASSWORD=#{PASSWORD} psql -h #{HOST} \
        -U #{USERNAME} -d #{DB_NAME} -p #{PORT} \
        -c \"#{sql_command}\"
    )
  end
end
