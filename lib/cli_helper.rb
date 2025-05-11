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
 |  A Command Line Game by: Ancient Nimbus | Ver: 0.0.1  |
 +---+---+---+---+---+---+---+---+---+---+---+---+---+---+

 How-to-play:
  * some instruction
  * some more instruction
  * some more instruction

 Mode selection:
  1) Player vs Player
  2) Player vs Computer
  INFO

  GRID = <<~GRID
    +---+---+---+
    | 7 | 8 | 9 |
    +---+---+---+
    | 4 | 5 | 6 |
    +---+---+---+
    | 1 | 2 | 3 |
    +---+---+---+
  GRID

  FLOW = {
    mode: { re: /\A[1-2]\z/, prompt_msg: 'Select a mode (1 or 2) to continue...' },
    p1: { re: /.*/, prompt_msg: 'Please name Player 1' },
    p2: { re: /.*/, prompt_msg: 'Please name Player 2' },
    play: { re: /\A[1-9]\z/, prompt_msg: 'Pick a grid number (1 to 9)' }

  }.freeze

  def self.get_input(regex, prompt_msg)
    # regex {regex}
    # prompt_msg {string}
    input_value = ''
    until input_value =~ regex && input_value.empty? == false
      puts "\n* #{prompt_msg}"
      input_value = gets.chomp
      # Keyword to quit the program early
      exit if input_value == 'exit'
    end
    input_value
  end
end
