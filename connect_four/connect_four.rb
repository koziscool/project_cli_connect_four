require './player.rb'
require './board.rb'
require './disk.rb'

require "highline"
CLI = HighLine.new

class ConnectFour
  def initialize
    @player_1 = Player.new
    @player_2 = Player.new
    @board = Board.new
    @current_player = true
    #true = player 1 turn, false = player 2 turn
  end

  def print_intro
    puts
    puts "Welcome to Connect Four!"
    puts "Enter number of players (1 or 2):"
    puts
  end

  def play
    print_intro

    loop do
      #prints board
      @board.render
      #prints current player turn
      puts @current_player  ?  "Player 1's  turn" : "Player 2's turn"
      #obtain valid user move
      player_move = get_user_input
      until @board.valid_move? ( player_move )
          player_move = get_user_input
      end
      #process move and update board
      if @current_player
        @board.place_disk( Disk.make_player_1_disk,  player_move  - 1)
      else
        @board.place_disk( Disk.make_player_2_disk, player_move  - 1 )
      end
      #check end game conditions (winner or full board)
      break if end_conditions?
      #swap turns
      @current_player = !@current_player
      #clear screen
      system("clear")
    end
  end

  #checks all end game conditions
  def end_conditions?
    #checks winner
    if @board.win_conditions?
      if @current_player
          puts "Congratulations! Player 1 wins!!"
      else
          puts "Congratulations! Player 2 wins!!"
      end
      @board.render
      return true
    end
    #return true if game over
    if @board.grid_full?
      puts "It's a draw! GAME OVER."
      @board.render
      return true
    end
    false
  end

  #obtain valid user move
  def get_user_input
    loop do
        input = CLI.ask "Please enter a valid column from 1 to 7:"
        case input
        when /^[1-7]$/
            return input.to_i
        else
            puts "INVALID INPUT!"
            puts
            next
        end
    end
  end
end

game = ConnectFour.new
game.play
