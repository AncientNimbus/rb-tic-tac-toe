# frozen_string_literal: true

require 'colorize'
require_relative 'cli_helper'
require_relative 'player'

# Main logic for the game: Tic Tac Toe
class TicTacToe
  include CliHelper

  attr_accessor :mode, :p1, :p2, :p1_turn, :has_won, :round

  GRID_SLOT = [*1..9].freeze
  WIN_SEQ = [123, 456, 789, 147, 258, 369, 159, 357].freeze
  WIN_SEQ_ARR = WIN_SEQ.map { |seq| seq.to_s.chars }

  def initialize
    # welcome
    @mode = CliHelper.get_input(FLOW.dig(:mode, :re), FLOW.dig(:mode, :prompt_msg)).to_i
    @p1 = create_player

    mode_selection
  end

  def welcome
    puts LOGO.colorize(:light_yellow)
    puts INFO
  end

  def create_player
    Player.new(CliHelper.get_input(FLOW.dig(:player, :re),
                                   FLOW.dig(:player, :prompt_msg).call("Player #{Player.total_player + 1}")))
  end

  def mode_selection
    mode == 1 ? pvp : pve
  end

  def display_grid
    size = 3
    puts "Generating a #{size} x #{size} grid..."
    puts GRID
  end

  def init_game
    @round = 0
    @p1_turn = [true, false].sample
    @has_won = false

    puts "#{p1_turn ? p1.name : p2.name} will take the first turn"
  end

  def play(player)
    player.add_move(CliHelper.get_input(FLOW.dig(:play, :re), FLOW.dig(:play, :prompt_msg)))
    # self.round += 0.5
  end

  def check_data
    if p1.move_check >= 3 || p2.move_check >= 3
      # only start checking from round 3
      puts "p1: #{p1.data}"
      puts "p2: #{p2.data}"
      true
    else
      false
    end
  end

  def game_loop
    until has_won
      if p1_turn
        play(p1)
        self.p1_turn = false
      else
        play(p2)
        self.p1_turn = true
      end
      self.has_won = check_data
    end
  end

  def pvp
    puts 'Player vs Player'
    self.p2 = create_player

    init_game
    game_loop
  end

  def pve
    puts 'Player vs Computer'
    self.p2 = Computer.new
  end
end

# TODO: Generate 3 x 3 grid
# TODO: Mode selection: PvP or PvE
# TODO: Get user input in the following number range 1 - 9
