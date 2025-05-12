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
 |  A Command Line Game by: Ancient Nimbus | Ver: 1.2.0  |
 +---+---+---+---+---+---+---+---+---+---+---+---+---+---+

 How-to-play:
  * Players take turns placing their mark ("X" or "O") in an empty square on the grid.
  * On your turn, choose any empty square and place your mark there.
  * The first player to get three of their marks in a row (across, down, or diagonally) wins.
  * If all nine squares are filled and no player has three in a row, the game is a draw.

 Mode selection:
  1) Player vs Player
  2) Player vs Computer

 You can type 'exit' to leave the game at any point.
  INFO

  FLOW = {
    keys: { exit: 'exit', yes: 'yes' },

    mode: { re: /\A[1-2]\z/, msg: 'Select a mode (1 or 2) to continue...',
            err_msg: 'Please enter a valid mode!', pvp: "\n* Player vs Player mode selected",
            pve: "\n* Player vs Computer mode selected" },

    shape: { x: 'X', o: 'O' },

    rst: { re: /\byes\b/, msg: "\n* Restart? (Type: yes)",
           err_msg: 'Please enter a valid input!' },

    player: { re: /.*/, msg: ->(num) { "Please name Player #{num}" } },

    play: { re: /\A[1-9]\z/, msg: lambda { |name|
      "It is #{name}'s turn, choose from grid number 1 to 9"
    }, err_msg: 'Invalid input, choose again!' },

    first_turn: { msg: lambda { |name|
      "\n* Randomly picking who is starting first... \n* #{name} will make the first turn"
    } },

    tie: { msg: "\n* It is a Tie!" },

    win: { msg: ->(name) { "\n* #{name} has won this round!" } }
  }.freeze

  def self.get_input(regex, msg, err_msg = nil)
    # regex {regex}
    # msg {string}
    input_value = ''
    first_entry = true

    until input_value.match?(regex) && !input_value.empty?
      message = first_entry ? msg : err_msg
      puts "\n* #{message}"
      first_entry = false

      input_value = gets.chomp
      exit if input_value == FLOW.dig(:keys, :exit)
    end
    input_value
  end
end
