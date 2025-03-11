class Board
  attr_accessor :board, :player_position, :computer_position
  def initialize(player_position = 0, computer_position = 0)
    @player_position = player_position
    @computer_position = computer_position
    @board_grid = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  def board_display
    #board = "#{@board_grid[0][0]} | #{@board_grid[0][1]} | #{@board_grid[0][2]}\n--+---+--\n#{@board_grid[1][0]} | #{@board_grid[1][1]} | #{@board_grid[1][2]}\n--+---+--\n#{@board_grid[2][0]} | #{@board_grid[2][1]} | #{@board_grid[2][2]}"
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


game_1 = Board.new()
puts game_1.board_display
game_1.place_x(5)
puts "\n\n"
puts game_1.board_display
game_1.place_o(8)
puts "\n\n"
puts game_1.board_display


# new_game.board_grid[0][2] = O 
# puts new_game


#class player
# human player
# Computer player

#class HumanPlayer
#get the human player choice and give it to game

#class ComputerPlayer
#run the computer choice logic

#class Game
#run the game logic
# update and display board