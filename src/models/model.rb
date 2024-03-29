
class Model
  TABLE_NAME = ''
  TABLE_COLUMNS = []

  def self.all
    where({})
  end

  def self.create data, foreign_keys: {}
    create_multiple [data], foreign_keys:
  end

  def self.create_multiple data, foreign_keys: {}
    values = data.map do |row_data|
      row_values = self::TABLE_COLUMNS.map do |column|
        next escaped_value row_data[column] unless foreign_keys.key? column

        table = foreign_keys[column][:get_from]
        filter = foreign_keys[column][:using].map do |field|
          "#{field} = '#{row_data[field]}'"
        end.join ' AND '

        "(SELECT id FROM #{table} WHERE #{filter})"
      end.join ','

      "(#{row_values})"
    end.join ', '

    PGConnection.execute %(
      INSERT INTO #{self::TABLE_NAME} (#{self::TABLE_COLUMNS.join ', '})
      VALUES #{values}
    )
  end

  def self.delete_all
    PGConnection.execute %(
      DELETE FROM #{self::TABLE_NAME}
    )
  end

  def self.get_or_create data
    existing_records = where data

    return existing_records.first unless existing_records.empty?

    create data

    where(data).first
  end

  def self.select joins:, fields_selection:, where: {}, offset: nil, limit: nil
    selected_fields = fields_selection.each_pair.map do |model, fields|
      fields.map do |field|
        "#{model::TABLE_NAME}.#{field} #{model::TABLE_NAME}_#{field}"
      end.join ', '
    end.join ', '

    joinings = joins.each_pair.map do |model, (key, foreign_key)|
      %(
        JOIN #{model::TABLE_NAME}
        ON #{model::TABLE_NAME}.#{foreign_key} = #{key}
      )
    end.join ' '

    filters = where.each_pair.map do |field, where_data|
      value = escaped_value where_data[:value]
      ignore_case = where_data[:ignore_case]
      partial_match = where_data[:partial_match]

      next "#{field} ILIKE #{value}" if ignore_case
      next %(#{field} LIKE "%#{value}%") if partial_match

      "#{field} = #{value}"
    end.join ' AND '

    PGParser.parse_select_output PGConnection.execute(%(
      SELECT #{selected_fields}
      FROM #{self::TABLE_NAME}
      #{ joinings }
      #{ "WHERE #{filters}" unless filters.empty? }
      ORDER BY #{self::TABLE_NAME}.id
      #{ "OFFSET #{offset}" if /\d+/.match? offset.to_s }
      #{ "LIMIT #{limit}" if /\d+/.match? limit.to_s }
    )).first
  end

  def self.where data
    filters = data.each_pair.map do |field, value|
      "#{field} = #{escaped_value value}"
    end.join ' AND '

    PGParser.parse_select_output PGConnection.execute(%(
      SELECT *
      FROM #{self::TABLE_NAME}
      #{"WHERE #{filters}" unless filters.empty?}
    )).first
  end

  private

  def self.escaped_value value
    "\\\$\\\$#{value}\\\$$"
  end
end
