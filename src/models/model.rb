
class Model
  TABLE_NAME = ''

  def self.create data
    fields, values = [], []

    data.each_pair do |field, value|
      fields << field
      values << value
    end

    fields = "(#{fields.join ','})"
    values = values.map { |value| "\\\$\\\$#{value}\\\$$" }.join ','

    PGConnection.execute %(
      INSERT INTO #{self::TABLE_NAME} #{fields}
      VALUES (#{values})
    )
  end

  def self.get_or_create data
    existing_records = where data

    return existing_records.first unless existing_records.empty?

    create data

    where(data).first
  end

  def self.where data
    filters = data.each_pair.map do |field, value|
      "#{field} = \\\$\\\$#{value}\\\$$"
    end.join ' AND '

    PGParser.parse_select_output PGConnection.execute %(
      SELECT *
      FROM #{self::TABLE_NAME}
      WHERE #{filters}
    )
  end
end
