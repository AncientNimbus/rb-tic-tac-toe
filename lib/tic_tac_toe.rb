# frozen_string_literal: true

require 'colorize'
require_relative 'cli_helper'
require_relative 'player'

# Main logic for the game: Tic Tac Toe
class TicTacToe
  include CliHelper

  attr_accessor :mode, :p1, :p2, :p1_turn, :has_won, :open_slots, :display_slots, :tie

  GRID_SLOTS = [*1..9].freeze
  WIN_SEQ = [123, 456, 789, 147, 258, 369, 159, 357].freeze
  WIN_SEQ_ARR = WIN_SEQ.map { |seq| seq.to_s.chars }

  def initialize
    puts LOGO.colorize(:green)
    puts INFO.colorize(:green)

    @mode = CliHelper.get_input(FLOW.dig(:mode, :re), FLOW.dig(:mode, :msg),
                                FLOW.dig(:mode, :err_msg)).to_i
    mode_selection
  end

  def create_player
    Player.new(CliHelper.get_input(FLOW.dig(:player, :re), FLOW.dig(:player, :msg).call(Player.total_player + 1),
                                   FLOW.dig(:player, :err_msg)))
  end

  def mode_selection
    puts mode == 1 ? FLOW.dig(:mode, :pvp) : FLOW.dig(:mode, :pve)
    @p1 = create_player
    self.p2 = if mode == 1
                create_player
              else
                Computer.new
              end
    new_game
  end

  def display_grid
    row_formatter = ->(i) { "| #{display_slots[i]} | #{display_slots[i + 1]} | #{display_slots[i + 2]} |" }

    grid = <<~GRID
      +---+---+---+
      #{row_formatter.call(6)}
      +---+---+---+
      #{row_formatter.call(3)}
      +---+---+---+
      #{row_formatter.call(0)}
      +---+---+---+
    GRID

    puts grid
  end

  def init_game
    @open_slots = GRID_SLOTS.dup
    @display_slots = GRID_SLOTS.dup
    @p1_turn = [true, false].sample
    @has_won = false
    @tie = false
    p1.clear_save
    p2.clear_save

    puts FLOW.dig(:first_turn, :msg).call(p1_turn ? p1.name : p2.name)
  end

  def game_loop
    until has_won
      p1_turn ? play_turn(p1) : play_turn(p2)
      self.has_won = check_data?
    end
    announce_result
  end

  def new_game
    init_game
    game_loop
  end

  def play_turn(player)
    display_grid
    slot = if player.is_a?(Computer)
             # Computer's choice
             player.rand_num(open_slots)
           else
             CliHelper.get_input(/\A#{open_slots}\z/, FLOW.dig(:play, :msg).call(player.name),
                                 FLOW.dig(:play, :err_msg))
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
    display_slots[slot - 1] = p1_turn ? FLOW.dig(:shape, :x).colorize(:yellow) : FLOW.dig(:shape, :o).colorize(:magenta)
  end

  # rubocop:disable Metrics/AbcSize
  def check_data?
    return unless p1.move_check >= 3 || p2.move_check >= 3

    # only start checking from round 3
    WIN_SEQ_ARR.each do |seq|
      return true if (seq - p1.data).empty?
      return true if (seq - p2.data).empty?
    end

    if open_slots.empty?
      self.tie = true
      return true
    end
    false
  end
  # rubocop:enable Metrics/AbcSize

  def announce_result
    display_grid

    if tie
      puts FLOW.dig(:tie, :msg)
    else
      puts !p1_turn ? FLOW.dig(:win, :msg).call(p1.name) : FLOW.dig(:win, :msg).call(p2.name)
    end

    restart
  end

  def restart
    CliHelper.get_input(FLOW[:rst][:re], FLOW[:rst][:msg], FLOW[:rst][:err_msg]) == FLOW[:keys][:yes] ? new_game : exit
  end
end
