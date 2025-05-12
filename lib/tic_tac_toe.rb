# frozen_string_literal: true

require 'colorize'
require_relative 'cli_helper'
require_relative 'player'

# Main logic for the game: Tic Tac Toe
class TicTacToe
  include CliHelper

  attr_accessor :mode, :p1, :p2, :p1_turn, :has_won, :open_slots, :display_slots

  GRID_SLOTS = [*1..9].freeze
  WIN_SEQ = [123, 456, 789, 147, 258, 369, 159, 357].freeze
  WIN_SEQ_ARR = WIN_SEQ.map { |seq| seq.to_s.chars }

  def initialize
    welcome
    @mode = CliHelper.get_input(FLOW.dig(:mode, :re), FLOW.dig(:mode, :prompt_msg), FLOW.dig(:mode, :error_msg)).to_i
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

  # rubocop:disable Metrics/AbcSize
  # Disable warning as the intend for this method is clear
  def display_grid
    grid = <<~GRID
      +---+---+---+
      | #{display_slots[6]} | #{display_slots[7]} | #{display_slots[8]} |
      +---+---+---+
      | #{display_slots[3]} | #{display_slots[4]} | #{display_slots[5]} |
      +---+---+---+
      | #{display_slots[0]} | #{display_slots[1]} | #{display_slots[2]} |
      +---+---+---+
    GRID
    puts grid
  end
  # rubocop:enable Metrics/AbcSize

  def init_game
    @open_slots = GRID_SLOTS.dup
    @display_slots = GRID_SLOTS.dup
    @p1_turn = [true, false].sample
    @has_won = false

    puts FLOW.dig(:first_turn, :msg).call(p1_turn ? p1.name : p2.name)
  end

  def play(player)
    display_grid
    slot = if player.is_a?(Player)
             CliHelper.get_input(/\A#{open_slots}\z/, FLOW.dig(:play, :prompt_msg).call(player.name),
                                 FLOW.dig(:play, :error_msg))
           else
             # Computer's choice
             open_slots.sample
           end
    player.add_move(slot)
    remove_slot_option(slot.to_i)
    self.p1_turn = !p1_turn
  end

  def remove_slot_option(slot)
    update_display(slot)
    self.open_slots = open_slots.reject { |open_slot| open_slot == slot }
  end

  def update_display(slot)
    display_slots[slot - 1] = p1_turn ? 'X' : 'O'
  end

  def check_data
    return unless p1.move_check >= 3 || p2.move_check >= 3

    # only start checking from round 3
    # puts "p1: #{p1.data}"
    # puts "p2: #{p2.data}"
    WIN_SEQ_ARR.each do |seq|
      return true if (seq - p1.data).empty?
      return true if (seq - p2.data).empty?
    end
    false
  end

  def game_loop
    until has_won
      if p1_turn
        play(p1)
      else
        play(p2)
      end
      self.has_won = check_data
      # puts "Has someone won? #{has_won}"
    end
    announce_result
  end

  def announce_result
    display_grid
    if !p1_turn
      puts 'P1 Won'
    else
      puts 'P2 Won'
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
