# frozen_string_literal: true

require 'colorize'
require_relative 'cli_assets'

# Main logic for the game: Tic Tac Toe
class TicTacToe
  include CliAssets

  def initialize
    welcome
    generate_grid(3)
  end

  def welcome
    puts 'Hello from TicTacToe class'.colorize(:light_yellow)
    puts CliAssets::LOGO
  end

  def generate_grid(size = 3)
    puts "Generating a #{size} x #{size} grid..."
    puts CliAssets::GRID
  end
end

# TODO: Print intro
# TODO: Generate 3 x 3 grid
# TODO: Get user input in the following number range 1 - 9
