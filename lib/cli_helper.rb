# frozen_string_literal: true

# A module containing string assets for the game Tic Tac Toe
module CliHelper
  LOGO = <<-'LOGO'
 +---+---+---+---+---+---+---+---+---+---+---+---+---+---+
 |   ______ _        ______             ______           |
 |  /_  __/(_)____  /_  __/___ _ ____  /_  __/___  ___   |
 +   / /  / // __/   / /  / _ `// __/   / /  / _ \/ -_)  +
 |  /_/  /_/ \__/   /_/   \_,_/ \__/   /_/   \___/\__/   |
 |                                                       |
 +---+---+---+---+---+---+---+---+---+---+---+---+---+---+
  LOGO

  INFO = <<-'INFO'
 +---+---+---+---+---+---+---+---+---+---+---+---+---+---+
 |  A Command Line Game by: Ancient Nimbus | Ver: 1.1.0  |
 +---+---+---+---+---+---+---+---+---+---+---+---+---+---+

 How-to-play:
  * Players take turns placing their mark ("X" or "O") in an empty square on the grid.
  * On your turn, choose any empty square and place your mark there.
  * The first player to get three of their marks in a row (across, down, or diagonally) wins.
  * If all nine squares are filled and no player has three in a row, the game is a draw.

 Mode selection:
  1) Player vs Player
  2) Player vs Computer
  INFO

  FLOW = {
    mode: { re: /\A[1-2]\z/, prompt_msg: 'Select a mode (1 or 2) to continue...',
            error_msg: 'Please enter a valid mode' },
    player: { re: /.*/, prompt_msg: ->(name) { "Please name #{name}" } },
    play: { re: /\A[1-9]\z/, prompt_msg: lambda { |name|
      "It is #{name}'s turn, choose from grid number 1 to 9"
    }, error_msg: 'Invalid input, choose again!' },
    first_turn: { msg: lambda { |name|
      "\n* Randomly picking who is starting first... \n* #{name} will make the first turn"
    } }
  }.freeze

  def self.get_input(regex, prompt_msg, error_msg = nil)
    # regex {regex}
    # prompt_msg {string}
    input_value = ''
    first_entry = true

    until input_value.match?(regex) && !input_value.empty?
      message = first_entry ? prompt_msg : error_msg
      puts "\n* #{message}"
      first_entry = false

      input_value = gets.chomp
      exit if input_value == 'exit'
    end
    input_value
  end
end
