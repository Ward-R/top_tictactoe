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
    if first_move_if_go_first(board)
      random_number = rand(1..3)
      case random_number
      when 1
        all_sides = [board.board_grid[0][1], board.board_grid[1][0], board.board_grid[1][2], board.board_grid[2][1]]
        empty_sides = all_sides.select { |cell| cell.is_a?(Integer) } # makes new array of availble corners
        if empty_sides.any?
          random_sides = empty_sides.sample
          if board.valid_move?(random_sides)
            board.place_token(random_sides, @token)
            puts board.board_display
          end
        end
        puts "case 1" #debug
      when 2
        all_corners = [board.board_grid[0][0], board.board_grid[0][2], board.board_grid[2][0], board.board_grid[2][2]]
        empty_corners = all_corners.select { |cell| cell.is_a?(Integer) } # makes new array of availble corners
        if empty_corners.any?
          random_corner = empty_corners.sample
          if board.valid_move?(random_corner)
            board.place_token(random_corner, @token)
            puts board.board_display
          end
        end
        puts "case 2" #debug
      when 3
        board.place_token(5, @token)
        puts board.board_display
        puts "case 3" #debug
      end
    elsif first_move_if_go_second(board)
      #if player corner
      all_corners = [board.board_grid[0][0], board.board_grid[0][2], board.board_grid[2][0], board.board_grid[2][2]]
      all_sides = [board.board_grid[0][1], board.board_grid[1][0], board.board_grid[1][2], board.board_grid[2][1]]
      if all_corners.any? { |cell| cell == @human_player.token }
        #put center
        board.place_token(5, @token)
        puts board.board_display
        puts "second move center due to corner" #debug
        return
        #elsif player center
      elsif board.valid_move?(5) == false
        all_corners = [board.board_grid[0][0], board.board_grid[0][2], board.board_grid[2][0], board.board_grid[2][2]]
        empty_corners = all_corners.select { |cell| cell.is_a?(Integer) } # makes new array of availble corners
        if empty_corners.any?
          random_corner = empty_corners.sample
          if board.valid_move?(random_corner) # respond with corner
            board.place_token(random_corner, @token)
            puts board.board_display
            puts "second move corner due to centre"
            return
          end
        end
      elsif all_sides.any? { |cell| cell == @human_player.token  }
        #elsif player side
        random_number = rand(1..3)
        player_side_location = all_sides.find { |cell| cell == @human_player.token }
        case random_number
        when 1
          board.place_token(5, @token)
          puts board.board_display
          puts "second move center due to side case 1" #debug
        when 2
          if board.board_grid[1][0] == @human_player.token
            board.place_token(1, @token)
            puts board.board_display
            return
          elsif board.board_grid[1][2] == @human_player.token
            board.place_token(9, @token)
            puts board.board_display
            return
          elsif board.board_grid[0][1] == @human_player.token
            board.place_token(3, @token)
            puts board.board_display
            return
          elsif board.board_grid[2][1] == @human_player.token
            board.place_token(7, @token)
            puts board.board_display
            return
          end
        when 3
          if board.board_grid[1][0] == @human_player.token
            board.place_token(6, @token)
            puts board.board_display
            return
          elsif board.board_grid[1][2] == @human_player.token
            board.place_token(4, @token)
            puts board.board_display
            return
          elsif board.board_grid[0][1] == @human_player.token
            board.place_token(8, @token)
            puts board.board_display
            return
          elsif board.board_grid[2][1] == @human_player.token
            board.place_token(2, @token)
            puts board.board_display
            return
          end
        end
      end 
    elsif place_to_win_hor(board)
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
    elsif place_to_block_win_diag(board)
      left_diagonal = [board.board_grid[0][0], board.board_grid[1][1], board.board_grid[2][2]]
      right_diagonal= [board.board_grid[0][2], board.board_grid[1][1], board.board_grid[2][0]]
      if left_diagonal.count { |cell| cell == @human_player.token} == 2 && left_diagonal.any? { |cell| cell.is_a?(Integer) }
        empty_cell = left_diagonal.find { |cell| cell.is_a?(Integer) }
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif right_diagonal.count { |cell| cell == @human_player.token} == 2 && right_diagonal.any? { |cell| cell.is_a?(Integer) }
        empty_cell = right_diagonal.find { |cell| cell.is_a?(Integer) }
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      end

    elsif place_to_fork(board)
      left_corners = [board.board_grid[0][0], board.board_grid[2][2]] # this name is poor, they are diagonal corners starting from the top left
      right_corners = [board.board_grid[0][2], board.board_grid[2][0]]
      top_left_v = [board.board_grid[1][0], board.board_grid[0][0], board.board_grid[0][1]]
      bottom_right_v = [board.board_grid[2][1], board.board_grid[2][2], board.board_grid[1][2]]
      top_right_v = [board.board_grid[0][1], board.board_grid[0][2], board.board_grid[1][2]]
      bottom_left_v = [board.board_grid[1][0], board.board_grid[2][0], board.board_grid[2][1]]
      if left_corners.all? { |cell| cell == @token } && top_right_v.all? { |cell| cell.is_a?(Integer)}
        empty_cell = board.board_grid[0][2]
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif left_corners.all? { |cell| cell == @token } && bottom_left_v.all? { |cell| cell.is_a?(Integer)}
        empty_cell = board.board_grid[2][0]
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif right_corners.all? { |cell| cell == @token } && top_left_v.all? { |cell| cell.is_a?(Integer)}
        empty_cell = board.board_grid[0][0]
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif right_corners.all? { |cell| cell == @token } && bottom_right_v.all? { |cell| cell.is_a?(Integer)}
        empty_cell = board.board_grid[2][2]
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      end
    
    elsif place_to_block_fork(board)
      left_corners = [board.board_grid[0][0], board.board_grid[2][2]] # this name is poor, they are diagonal corners starting from the top left
      right_corners = [board.board_grid[0][2], board.board_grid[2][0]]
      top_left_v = [board.board_grid[1][0], board.board_grid[0][0], board.board_grid[0][1]]
      bottom_right_v = [board.board_grid[2][1], board.board_grid[2][2], board.board_grid[1][2]]
      top_right_v = [board.board_grid[0][1], board.board_grid[0][2], board.board_grid[1][2]]
      bottom_left_v = [board.board_grid[1][0], board.board_grid[2][0], board.board_grid[2][1]]
      if left_corners.all? { |cell| cell == @human_player.token } && top_right_v.all? { |cell| cell.is_a?(Integer)}
        empty_cell = board.board_grid[0][2]
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif left_corners.all? { |cell| cell == @human_player.token } && bottom_left_v.all? { |cell| cell.is_a?(Integer)}
        empty_cell = board.board_grid[2][0]
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif right_corners.all? { |cell| cell == @human_player.token } && top_left_v.all? { |cell| cell.is_a?(Integer)}
        empty_cell = board.board_grid[0][0]
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      elsif right_corners.all? { |cell| cell == @human_player.token } && bottom_right_v.all? { |cell| cell.is_a?(Integer)}
        empty_cell = board.board_grid[2][2]
        if empty_cell && board.valid_move?(empty_cell)
          board.place_token(empty_cell, @token)
          puts board.board_display
          return
        end
      end
    
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
      empty_corners = all_corners.select { |cell| cell.is_a?(Integer) } # makes new array of availble corners
      if empty_corners.any?
        random_corner = empty_corners.sample
        if board.valid_move?(random_corner)
          board.place_token(random_corner, @token)
          puts board.board_display
          return
        end
      end

    elsif place_empty_side(board)
      all_sides = [board.board_grid[0][1], board.board_grid[1][0], board.board_grid[1][2], board.board_grid[2][1]]
      empty_sides = all_sides.select { |cell| cell.is_a?(Integer) } # makes new array of availble corners
      if empty_sides.any?
        random_sides = empty_sides.sample
        if board.valid_move?(random_sides)
          board.place_token(random_sides, @token)
          puts board.board_display
          return
        end
      end

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
    right_diagonal = [board.board_grid[0][2], board.board_grid[1][1], board.board_grid[2][0]]
    if left_diagonal.count { |cell| cell == @token} == 2 && left_diagonal.any? { |cell| cell.is_a?(Integer) } 
      puts "place_to_win_diagL is true" #debug
      return true
    elsif right_diagonal.count { |cell| cell == @token} == 2 && right_diagonal.any? { |cell| cell.is_a?(Integer) } 
      puts "place_to_win_diagL is true" #debug
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
  def place_to_block_win_diag(board)
    # opposite of place_to_win
    left_diagonal = [board.board_grid[0][0], board.board_grid[1][1], board.board_grid[2][2]]
    right_diagonal= [board.board_grid[0][2], board.board_grid[1][1], board.board_grid[2][0]]
    if left_diagonal.count { |cell| cell == @human_player.token} == 2 && left_diagonal.any? { |cell| cell.is_a?(Integer) } 
      puts "place_to_block_win_diagL is true" #debug
      return true
    elsif right_diagonal.count { |cell| cell == @human_player.token} == 2 && right_diagonal.any? { |cell| cell.is_a?(Integer) } 
      puts "place_to_block_win_diagL is true" #debug
      return true
    end
    return false
  end

  def place_to_fork(board) # basic fork scenario considered only. may be others?
    left_corners = [board.board_grid[0][0], board.board_grid[2][2]] # this name is poor, they are diagonal corners starting from the top left
    right_corners = [board.board_grid[0][2], board.board_grid[2][0]]
    top_left_v = [board.board_grid[1][0], board.board_grid[0][0], board.board_grid[0][1]]
    bottom_right_v = [board.board_grid[2][1], board.board_grid[2][2], board.board_grid[1][2]]
    top_right_v = [board.board_grid[0][1], board.board_grid[0][2], board.board_grid[1][2]]
    bottom_left_v = [board.board_grid[1][0], board.board_grid[2][0], board.board_grid[2][1]]
    if left_corners.all? { |cell| cell == @token } && top_right_v.all? { |cell| cell.is_a?(Integer)}
      puts "place_to_fork true" #debug
      return true
    elsif left_corners.all? { |cell| cell == @token } && bottom_left_v.all? { |cell| cell.is_a?(Integer)}
      puts "place_to_fork true" #debug
      return true
    elsif right_corners.all? { |cell| cell == @token } && top_left_v.all? { |cell| cell.is_a?(Integer)}
      puts "place_to_fork true" #debug
      return true
    elsif right_corners.all? { |cell| cell == @token } && bottom_right_v.all? { |cell| cell.is_a?(Integer)}
      puts "place_to_fork true" #debug
      return true
    end
  end

  def place_to_block_fork(board)
    left_corners = [board.board_grid[0][0], board.board_grid[2][2]] # this name is poor, they are diagonal corners starting from the top left
    right_corners = [board.board_grid[0][2], board.board_grid[2][0]]
    top_left_v = [board.board_grid[1][0], board.board_grid[0][0], board.board_grid[0][1]]
    bottom_right_v = [board.board_grid[2][1], board.board_grid[2][2], board.board_grid[1][2]]
    top_right_v = [board.board_grid[0][1], board.board_grid[0][2], board.board_grid[1][2]]
    bottom_left_v = [board.board_grid[1][0], board.board_grid[2][0], board.board_grid[2][1]]
    if left_corners.all? { |cell| cell == @human_player.token } && top_right_v.all? { |cell| cell.is_a?(Integer)}
      puts "place_to_block_fork true" #debug
      return true
    elsif left_corners.all? { |cell| cell == @human_player.token } && bottom_left_v.all? { |cell| cell.is_a?(Integer)}
      puts "place_to_block_fork true" #debug
      return true
    elsif right_corners.all? { |cell| cell == @human_player.token } && top_left_v.all? { |cell| cell.is_a?(Integer)}
      puts "place_to_block_fork true" #debug
      return true
    elsif right_corners.all? { |cell| cell == @human_player.token } && bottom_right_v.all? { |cell| cell.is_a?(Integer)}
      puts "place_to_block_fork true" #debug
      return true
    end
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

  def place_empty_corner(board)
    all_corners = [board.board_grid[0][0], board.board_grid[0][2], board.board_grid[2][0], board.board_grid[2][2]]
    if all_corners.any? { |cell| cell.is_a?(Integer) }
      puts "place_empty_corner is true" #debug
      return true
    end
    return false
  end

  def place_empty_side(board)
    all_sides = [board.board_grid[0][1], board.board_grid[1][0], board.board_grid[1][2], board.board_grid[2][1]]
    if all_sides.any? { |cell| cell.is_a?(Integer) }
      puts "place_empty_side is true" #debug
      return true
    end
    return false
  end

  def first_move_if_go_first(board)
    if board.board_grid.flatten.all? { |cell| cell.is_a?(Integer)}
      puts "first move if go first true" #debug
      return true
    end
    return false
  end

  def first_move_if_go_second(board)
    if board.board_grid.flatten.count { |cell| cell == @human_player.token} == 1
      puts "first move if go second is true" #debug
      return true
    end
    return false
  end
end

game = Game.new
game.run