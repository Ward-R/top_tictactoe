class Board
  attr_reader :board_grid
  def initialize()
    # @player_position = player_position
    # @computer_position = computer_position
    @board_grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  def board_display
    board = @board_grid.map { |row| row.join(' | ') }.join("\n--+---+--\n") 
    return board
  end

  def place_x(location)
    @board_grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        if cell == location
          @board_grid[row_index][cell_index] = "X"
          return board_display # Return the updated board display
        end
      end
    end
    return board_display
  end

  def place_o(location)
    @board_grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        if cell == location
          @board_grid[row_index][cell_index] = "O"
          return board_display # Return the updated board display
        end
      end
    end
    return board_display
  end
end


class Game
  attr_accessor :board, :player_position, :computer_position
  def initialize(player_position = 0, computer_position = 0)
    @player_position = player_position
    @computer_position = computer_position #not sure where to put these yet...
    @board = Board.new
    @human_player = HumanPlayer.new
    @computer_player = ComputerPlayer.new
    @game_over = false
  end

  def run
    # Main game loop
    puts "Welcome to Tic-Tac-Toe!"
    puts "Lets roll to see who goes first"
    goes_first
    puts "Human is #{@human_player.token}"
    puts "Computer is #{@computer_player.token}"
    puts @board.board_display
    until @game_over
      puts "Human - Choose a location for your token"
      print ">> "
      @board.place_x(gets.chomp.to_i)
      puts @board.board_display
      win_condition
      
      #input
      #update
      #display board
    end
    #display game over
  end


  def user_input
    #get input from player
  end

  def goes_first
    random_binary = rand(2) # outputs 0 or 1
    if random_binary == 0
      puts "Human got heads and goes first as 'X'"
      @human_player.is_first = true
    else
      puts "Computer got heads and goes first as 'X'"
      @computer_player.is_first = true
    end
  end

  # The following 3 checks check rows, columns, and diagonals for 3 consecutive tokens
  def check_rows(player_token)
    @board.board_grid.each do |row|
      if row.all? { |cell| cell == player_token } == true
        return true
      end
    end
    return false
  end

  def check_columns(player_token)
    @board.board_grid.transpose.each do |row| # This flips the columns into rows to make it easy to iterate and check
      if row.all? { |cell| cell == player_token } == true
        return true
      end
    end
    return false
  end

  def check_diagonals(player_token)
    if @board.board_grid[0][0] == player_token && @board.board_grid[1][1] == player_token && @board.board_grid[2][2] == player_token
      return true
    elsif @board.board_grid[0][2] == player_token && @board.board_grid[1][1] == player_token && @board.board_grid[2][0] == player_token
      return true
    end
    return false
  end

  def win_condition
    if check_rows("X")
      puts "X wins"
      @game_over = true
    elsif check_columns("X")
      puts "X wins"
      @game_over = true
    elsif check_diagonals("X")
      puts "X wins"
      @game_over = true
    end
  end
end

class Player 
  attr_accessor :is_first
  def initialize
    @is_first = false
  end
end

class HumanPlayer < Player
  attr_reader :token #so token can be accessed outside of class
  def token
    if @is_first == true
      @token = "X"
    else
      @token = "O"
    end
  end
end

class ComputerPlayer < Player
  attr_reader :token #so token can be accessed outside of class
  def token
    if @is_first == true
      @token = "X"
    else
      @token = "O"
    end
  end

  def computer_logic
    # code AI here
  end



end

game = Game.new
game.run





# game_1 = Board.new()
# puts game_1.board_display
# game_1.place_x(5)
# puts "\n\n"
# puts game_1.board_display
# game_1.place_o(8)
# puts "\n\n"
# puts game_1.board_display
