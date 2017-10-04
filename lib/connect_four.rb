class Board
  attr_accessor :board
  attr_reader :turn, :identifier

  def initialize
    @board = [
      [0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0]
    ]
    @turn = 0
    @identifier = 1
  end

  def choose_column(col)
    5.downto(0) do |i|
      if board[i][col-1] == 0
        board[i][col-1] = identifier
        break
      end
    end
    false
  end

  def win?
    return true if check_rows?
    return true if check_columns?
    return true if check_diagonal?
  end

  def check_validity(sum,num)
    if num == 1
      sum = 0 if sum < 0
      sum += 1
    elsif num == -1
      sum = 0 if sum > 0
      sum -= 1
    else
      sum = 0
    end
  end

  def check_rows?
    6.times do |i|
      board[i].inject(0) do |sum, num|
        sum = check_validity(sum,num)
        return true if sum.abs == 4
        sum
      end
    end
    false
  end

  def check_columns?
    7.times do |i|
      column = []
      board.each { |row| column.push(row[i]) }
      column.inject(0) do |sum, num|
        sum = check_validity(sum,num)
        return true if sum.abs == 4
        sum
      end
    end
    false
  end

  def check_diagonal?
    board[0..2].each_with_index do |row, row_i|
      row.each_with_index do |column, col_i|
        if col_i <=3
          sum = board[row_i][col_i]
          1.upto(3) { |i| sum += board[row_i+i][col_i+i] }
          return true if sum.abs == 4
        end
        if col_i >= 3
          sum = board[row_i][col_i]
          1.upto(3) { |i| sum += board[row_i+i][col_i-i] }
          return true if sum.abs == 4
        end
      end
    end
    false
  end

  def new_game
    @turn = 1
  end

  def game_flow
    new_game
    while turn < 43
      assign_player
      player = @identifier == 1 ? 1 : 2
      puts draw_board
      print "Round #{@turn}. Player #{player}'s turn. Choose column (1-7): "
      input = gets.chomp
      while !validate_input(input) || check_full?(input)
        print "Invalid column number. Try again: "
        input = gets.chomp
      end
      input = validate_input(input)
      choose_column(input)
      if win?
        puts draw_board
        puts "Congratulations. Player #{player} won"
        break
      end
      @turn += 1
    end
    puts "Draw!" unless win?
    return true  
  end

  def assign_player
    @identifier = @turn.odd? ? 1 : -1
  end

  def validate_input(input)
    return input !~ /^[1-7]$/ ? false : input.to_i
  end

  def check_full?(column)
    column = column.to_i
    column -= 1
    return board[0][column] != 0
  end

  def draw_board
    rep = { 0 => " ", 1 => "O", -1 => "X" }
    drawing = ''
    board.each do |row|
      drawing << "#{rep[row[0]]}|#{rep[row[1]]}|#{rep[row[2]]}|#{rep[row[3]]}|#{rep[row[4]]}|#{rep[row[5]]}|#{rep[row[6]]}\n"
    end
    drawing << "1 2 3 4 5 6 7"
  end
end

board = Board.new
board.game_flow
