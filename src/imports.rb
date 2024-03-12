
require 'csv'
require 'json'
require 'open3'
require 'socket'
require 'tempfile'
require 'net/http'

require_relative 'db/postgres/regexes'
require_relative 'db/postgres/connection'
require_relative 'db/postgres/parser'

require_relative 'models/model'
require_relative 'models/doctor'
require_relative 'models/exam'
require_relative 'models/exam_type'
require_relative 'models/patient'

require_relative 'libs/data_extractor'
require_relative 'libs/importer'

require_relative 'server/route'
require_relative 'server/router'
require_relative 'server/request'
require_relative 'server/response'
require_relative 'server/controller/api/v1/controller'
require_relative 'server/controller/api/v2/controller'
require_relative 'server/controller/web/controller'
