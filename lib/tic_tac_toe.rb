# frozen_string_literal: true

require 'colorize'
require_relative 'cli_helper'
require_relative 'player'

# Main logic for the game: Tic Tac Toe
class TicTacToe
  include CliHelper

  GRID_COMBOS = [123, 456, 789, 147, 258, 369, 159, 357].freeze
  COMBOS_ARR = GRID_COMBOS.map { |combo| combo.to_s.chars }

  def initialize
    # welcome
    mode_selection
  end

  def welcome
    puts LOGO.colorize(:light_yellow)
    puts INFO
  end

  def mode_selection
    num = CliHelper.get_input(FLOW.dig(:mode, :re), FLOW.dig(:mode, :prompt_msg)).to_i
    num == 1 ? pvp : pve
  end

  def generate_grid(size = 3)
    puts "Generating a #{size} x #{size} grid..."
    puts GRID
  end

  def pvp
    puts 'Player vs Player'
  end

  def pve
    puts 'Player vs Computer'
  end
end

# TODO: Generate 3 x 3 grid
# TODO: Mode selection: PvP or PvE
# TODO: Get user input in the following number range 1 - 9
