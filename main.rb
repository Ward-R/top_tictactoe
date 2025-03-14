class Board
  attr_reader :board_grid, :token
  def initialize
    @board_grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  def board_display
    board = @board_grid.map { |row| row.join(' | ') }.join("\n--+---+--\n") 
    return board
  end

  # Checks that spot is open on board
  def valid_move?(location)
    @board_grid.each do |row|
      row.each do |cell|
        if cell == location && cell.is_a?(Integer)
          return true # Valid move
        end
      end
    end
    return false # Invalid move
  end

  def place_token(location, token)
    if valid_move?(location)
      @board_grid.each_with_index do |row, row_index|
        row.each_with_index do |cell, cell_index|
          if cell == location
            @board_grid[row_index][cell_index] = token
            return board_display # Return the updated board display
          end
        end
      end
    else
      puts "Invalid move! That space is already taken."
      return board_display
    end
  end
end

class Game
  attr_accessor :board
  def initialize
    @board = Board.new
    @human_player = HumanPlayer.new
    @computer_player = ComputerPlayer.new(@human_player)
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
    loop do
      puts "Human - Choose a location for your token"
      print ">> "
      location = gets.chomp.to_i

      if board.valid_move?(location)
        board.place_token(location, @token)
        puts board.board_display
        break # Exit after valid move
      else
        puts "Invalid move! Please choose an available location."
      end
    end
  end
end

class ComputerPlayer < Player
  attr_reader :token, :human_player #so token can be accessed outside of class
  
  def initialize(human_player) # Accept human_player as an argument
    super()
    @human_player = human_player # Store the human_player
  end

  def computer_move(board)
    puts "Computer turn"
    sleep(1)
    
    # *************************************************************************************
    # Below are the methods for the computer token placement
    if place_to_win_hor(board)
      # logic to place token in remaining spot
      board.board_grid.each_with_index do |row, row_index|
        if row.count(@token) == 2
          empty_cell = row.find { |cell| cell.is_a?(Integer) }
          if empty_cell && board.valid_move?(empty_cell)
            board.place_token(empty_cell, @token)
            puts board.board_display
            return
          end
        end
      end

    elsif place_to_win_vert(board)
      board.board_grid.transpose.each_with_index do |row, row_index|
        if row.count(@token) == 2
          empty_cell = row.find { |cell| cell.is_a?(Integer) }
          if empty_cell && board.valid_move?(empty_cell)
            board.place_token(empty_cell, @token)
            puts board.board_display
            return
          end
        end
      end

    elsif place_to_win_diag(board)
      if [board.board_grid[0][0] == @token, board.board_grid[1][1] == @token, board.board_grid[2][2] == @token].count(true) == 2
        left_diagonal = [board.board_grid[0][0], board.board_grid[1][1], board.board_grid[2][2]]
        empty_cell = left_diagonal.find { |cell| cell.is_a?(Integer) }
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif [board.board_grid[0][2] == @token, board.board_grid[1][1] == @token, board.board_grid[2][0] == @token].count(true) == 2
        right_diagonal = [board.board_grid[0][2], board.board_grid[1][1], board.board_grid[2][0]]
        empty_cell = right_diagonal.find { |cell| cell.is_a?(Integer) }
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      end

    elsif place_to_block_win_hor(board)
      # logic to place token to block win block win
      board.board_grid.each_with_index do |row, row_index|
        if row.count(@human_player.token) == 2
          empty_cell = row.find { |cell| cell.is_a?(Integer) }
          if empty_cell && board.valid_move?(empty_cell)
            board.place_token(empty_cell, @token)
            puts board.board_display
            return
          end
        end
      end
    elsif place_to_block_win_vert(board)
      board.board_grid.transpose.each_with_index do |row, row_index|
        if row.count(@human_player.token) == 2
          empty_cell = row.find { |cell| cell.is_a?(Integer) }
          if empty_cell && board.valid_move?(empty_cell)
            board.place_token(empty_cell, @token)
            puts board.board_display
            return
          end
        end
      end
    elsif place_to_block_win_diag
    
    elsif place_to_block_fork
    
    elsif place_centre(board)
      board.place_token(5, @token)
      puts board.board_display
      return

    elsif place_opposite_corner(board)
      if board.board_grid[0][0] == @human_player.token || board.board_grid[2][2] == @human_player.token
        left_diagonal = [board.board_grid[0][0], board.board_grid[2][2]]
        empty_cell = left_diagonal.find { |cell| cell.is_a?(Integer) }
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif board.board_grid[0][2] == @human_player.token || board.board_grid[2][0] == @human_player.token
        right_diagonal = [board.board_grid[0][2], board.board_grid[2][0]]
        empty_cell = right_diagonal.find { |cell| cell.is_a?(Integer) }
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      end

    elsif place_empty_corner(board)
      all_corners = [board.board_grid[0][0], board.board_grid[0][2], board.board_grid[2][0], board.board_grid[2][2]]
      empty_cell = all_corners.find { |cell| cell.is_a?(Integer) }
      all_corners.each do |cell|
        if cell.is_a?(Integer) && board.valid_move?(cell)
          board.place_token(cell, @token)
          puts board.board_display
          return
        end
      end
      
      # if empty_cell && board.valid_move?(empty_cell)
      #   board.place_token(empty_cell, @token)
      #   puts board.board_display
      #   return
      # end

    elsif place_empty_side


    else # currently this is a test method to make the comp to something
      temp_comp_move(board)
    end
  end

  # This is a temporary method just to test the computer while i make other methods for logid
  def temp_comp_move(board)
    board.board_grid.flatten.each do |cell|
      if cell.is_a?(Integer) && board.valid_move?(cell)
        board.place_token(cell, @token)
        puts board.board_display
        puts "temp_comp_move default executed" #debug
        return # Exit after placing the token
      end
    end
    puts "Error: No valid moves found." # Should rarely happen
  end
  

  # ****************************************************************************************
  # Below are the methods for the computer to check for potential moves
  def place_to_win_hor(board)
    # checks if horizontal move will win game
    board.board_grid.each do |row|
      if row.count { |cell| cell == @token} == 2 && row.any? { |cell| cell.is_a?(Integer) }
        puts "place_to_win_hor is true" #debug
        return true
      end
    end
    return false
  end

  def place_to_win_vert(board)
    # checks if vertical move will win game
    board.board_grid.transpose.each do |row|
      if row.count { |cell| cell == @token} == 2 && row.any? { |cell| cell.is_a?(Integer) }
        puts "place_to_win_vert is true" #debug
        return true
      end
    end
    return false
  end

  def place_to_win_diag(board)
    left_diagonal = [board.board_grid[0][0], board.board_grid[1][1], board.board_grid[2][2]]
    right_diagonal= [board.board_grid[0][2], board.board_grid[1][1], board.board_grid[2][0]]
    if left_diagonal == 2 && left_diagonal.any? { |cell| cell.is_a?(Integer) }
      puts "place_to_win_diagL is true" #debug
      return true
    elsif right_diagonal == 2 && right_diagonal.any? { |cell| cell.is_a?(Integer) }
      puts "place_to_win_diagr is true" #debug
      return true
    end
    return false
  end

  def place_to_block_win_hor(board)
    # opposite of place_to_win
    board.board_grid.each do |row|
      if row.count { |cell| cell == @human_player.token} == 2 && row.any? { |cell| cell.is_a?(Integer) }
        puts "place_to_block_win_hor is true" #debug
        return true
      end
    end
    return false
  end
  def place_to_block_win_vert(board)
    board.board_grid.transpose.each do |row|
      if row.count { |cell| cell == @human_player.token} == 2 && row.any? { |cell| cell.is_a?(Integer) }
        puts "place_to_block_win_vert is true" #debug
        return true
      end
    end
    return false
  end

  def place_to_block_win_diag#(board)
    # opposite of place_to_win
  end

  def place_to_block_fork#(board)
    # place in location to block a fork
  end

  def place_centre(board)
    # Place if centre is open
    if board.valid_move?(5) == true
      puts "place_centre is true" #debug
      return true
    end
    return false
  end

  def place_opposite_corner(board)
    left_corners = [board.board_grid[0][0], board.board_grid[2][2]]
    right_corners = [board.board_grid[0][2], board.board_grid[2][0]]
    if left_corners.any? { |cell| cell == @human_player.token } && left_corners.any? { |cell| is_a?(Integer) }
      puts "place_opp_cornerL is true" #debug
      return true
    elsif right_corners.any? { |cell| cell == @human_player.token } && left_corners.any? { |cell| is_a?(Integer) }
      puts "place_opp_cornerR is true" #debug
      return true
    end
    return false
  end

  def place_empty_corner(board) # Could improve to use .sample and randomly assign corner. takes first currently.
    all_corners = [board.board_grid[0][0], board.board_grid[0][2], board.board_grid[2][0], board.board_grid[2][2]]
    if all_corners.any? { |cell| cell.is_a?(Integer) }
      puts "place_empty_corner is true" #debug
      return true
    end
    return false
  end

  def place_empty_side#(board)
    # top/bottom/left/right sides
  end
end

game = Game.new
game.run