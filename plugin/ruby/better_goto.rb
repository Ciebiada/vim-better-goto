class BetterGoto
  FUNCTION_DEF = /(\(.+=>)|([^\w]\w+\s*=>)|(function)/

  def goto_definition(cursor, buffer)
    word = word_at_cursor(cursor, buffer)

    definition = find_definition(cursor, word, buffer)
    return cursor if definition.nil?
    definition
  end

  private

  def find_definition(cursor, word, buffer)
    start = scope_start(cursor, buffer)
    found = find_word(start, cursor, word, buffer)

    if found.nil?
      return find_definition(start, word, buffer) if start != [1, 0]
      return nil
    end

    found
  end

  def find_word(from, to, word, buffer)
    y1, x1 = from
    y2, x2 = to

    (y1..y2).each do |y|
      line = y == y2 ? buffer[y][0...x2] : buffer[y]

      x = line.index(/[^\w]#{word}[^\w]/)
      unless x.nil?
        return y, x + 1
      end
    end

    nil
  end

  def word_at_cursor(cursor, buffer)
    y, x = cursor
    string = buffer[y]

    to_the_right = string[x..-1].index(/[^\w]|$/)
    to_the_left = string[0...x].reverse.index(/[^\w]|$/)
    string[x-to_the_left...x+to_the_right]
  end

  def scope_start(cursor, buffer)
    y, x = cursor
    balance = 0

    y.downto(0).each do |j|
      line = j == y ? buffer[j][0...x] : buffer[j]

      arrow_fun = line.rindex(/(\(.+=>)|([^\w]\w+\s*=>)/)

      return j, arrow_fun unless arrow_fun.nil?

      line.reverse.each_char.with_index do |c, i|
        balance += 1 if c == '}'
        balance -= 1 if c == '{'

        if balance < 0 
          fun_def = line.rindex(FUNCTION_DEF)

          return fun_def.nil? ? [j, line.length - i] : [j, fun_def]
        end
      end
    end

    [1, 0]
  end
end

