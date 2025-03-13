class Board
  attr_reader :board_grid, :token
  def initialize
    @board_grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  def board_display
    board = @board_grid.map { |row| row.join(' | ') }.join("\n--+---+--\n") 
    return board
  end

  def place_token(location, token)
    @board_grid.each_with_index do |row, row_index|
      row.each_with_index do |cell, cell_index|
        if cell == location
          @board_grid[row_index][cell_index] = token
          return board_display # Return the updated board display
        end
      end
    end
    return board_display
  end
end

class Game
  attr_accessor :board
  def initialize
    @board = Board.new
    @human_player = HumanPlayer.new
    @computer_player = ComputerPlayer.new
    @game_over = false
  end

  def run
    # Main game loop
    count = 0 # turn counter for draw condition
    puts "Welcome to Tic-Tac-Toe!"
    puts "Lets roll to see who goes first"
    goes_first
    puts "Human is #{@human_player.token}"
    puts "Computer is #{@computer_player.token}"
    puts @board.board_display
    
    #sets starting order
    if @human_player.is_first 
      current_player = @human_player
    else
      current_player = @computer_player
    end

    until @game_over

      # Runs a player logic to set a token
      if current_player == @human_player
        @human_player.human_move(@board)
      else
        @computer_player.computer_move(@board)
      end
      count += 1

      # Check if there is a win condition, ends game if so.
      if win_condition
        break
      end

      # End game if draw
      if count == 9
        puts "Game is a draw"
        break
      end

      # Switches players for next round of token placement
      if current_player == @human_player
        current_player = @computer_player
      else
        current_player = @human_player
      end
    end
    puts "Game over, thanks for playing!"
  end

  def goes_first
    random_binary = rand(2) # outputs 0 or 1
    if random_binary == 0
      puts "Human got heads and goes first as 'X'"
      @human_player.is_first = true
      @human_player.assign_token("X")
      @computer_player.assign_token("O")
    else
      puts "Computer got heads and goes first as 'X'"
      @computer_player.is_first = true
      @computer_player.assign_token("X")
      @human_player.assign_token("O")
    end
  end

  #*************** change this player_token in the future. it is confusing with the other token********
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
    elsif check_rows("O")
      puts "O wins"
      @game_over = true
    elsif check_columns("O")
      puts "O wins"
      @game_over = true
    elsif check_diagonals("O")
      puts "O wins"
      @game_over = true
    end
  end
end

class Player 
  attr_accessor :is_first, :token
  def initialize
    @is_first = false
    @token = nil
  end

  def assign_token(token)
    @token = token
  end
end

class HumanPlayer < Player
  attr_reader :token #so token can be accessed outside of class
  
  def human_move(board)
    puts "Human - Choose a location for your token"
    print ">> "
    board.place_token(gets.chomp.to_i, @token)
    puts board.board_display
  end
end

class ComputerPlayer < Player
  attr_reader :token #so token can be accessed outside of class
  
  def computer_move(board)
    #temporary human input simulating computer move
    puts "Computer (human simulated) - Choose a location for your token"
    print ">> "
    board.place_token(gets.chomp.to_i, @token)
    puts board.board_display
    
    #win if next move completes 3 computer tokens in a row do that
    # def check_rows(player_token)
    #   @board.board_grid.each do |row|
    #     if row.all? { |cell| cell == player_token } == true
    #       return true
    #     end
    #   end
    #   return false
    # end

    #block elsif human has any 2 in one row block code:

    #block fork

    #center
    # if @board.board_grid[1][1] == 5
    #   board.place
    #Opposite corner

    #empty corner

    #empty side top/bottom/left/right maybe split this?
    
  end
end

game = Game.new
game.run