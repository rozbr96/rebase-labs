
module PG_OUTPUT_REGEXES
  module DELETE
    SUCCESS = /DELETE (?<rows_count>\d)+/

    module Errors
      NON_EXISTENT_COLUM = /ERROR:\s*column "(?<column>\w+)" does not exist/
    end
  end

  module INSERT
    SUCCESS = /INSERT 0 (?<rows_count>\d+)/

    module Errors
      DUPLICATE_KEY_VALUE = /ERROR:\s+duplicate key value/
      DUPLICATE_KEY_VALUE_DETAIL = /DETAIL:\s+Key \((?<column>\w+)\)=\((?<value>.*?)\)/
      NON_EXISTENT_COLUM = /ERROR:\s+column "(?<column>\w+)" .* does not exist/
    end
  end

  module SELECT
    SUCCESS = /\((?<rows_count>\d+) rows?\)/

    module Errors
      NON_EXISTENT_COLUM = /ERROR:\s*column "(?<column>\w+)" does not exist/
    end
  end
end
