
class PGParser
  def self.parse_select_output command_output
    lines = command_output.lines
    columns = lines.shift.split('|').map(&:strip)
    lines.shift
    lines.pop 2

    lines.reduce [] do |items, line|
      values = line.split('|').map(&:strip)

      items << columns.zip(values).reduce({}) do |item, (column, value)|
        item.update column => value
      end
    end
  end
end
