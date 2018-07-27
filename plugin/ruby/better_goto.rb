class BetterGoto
  def goto_definition(cursor, buffer)
    y, x = cursor

    puts word_at_index(buffer[y], x)

    goto_block_start(cursor, buffer)
  end

  private

  def word_at_index(string, idx)
    to_the_right = string[idx..-1].index(/[^\w]|$/)
    to_the_left = string[0..idx].reverse.index(/[^\w]|$/)
    string[idx-to_the_left...idx+to_the_right]
  end

  def goto_block_start(cursor, buffer)
    y, x = cursor
    balance = 0

    y.downto(0).each do |j|
      line = j == y ? buffer[j][0...x] : buffer[j]
      line.reverse.each_char.with_index do |c, i|
        balance += 1 if c == '}'
        balance -= 1 if c == '{'

        return j, line.length - i if balance < 0
      end
    end

    [1, 0]
  end
end

