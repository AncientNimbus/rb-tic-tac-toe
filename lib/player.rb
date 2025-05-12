# frozen_string_literal: true

require_relative 'cli_helper'

# Player class
class Player
  @number_of_player = 0
  attr_accessor :name, :data

  def initialize(name)
    @name = name
    @data = []
    Player.count_player
  end

  def add_move(grid_num)
    data.push(grid_num)
  end

  def move_check
    data.length
  end

  def clear_save
    self.data = []
  end

  def self.count_player
    @number_of_player += 1
  end

  def self.total_player
    @number_of_player
  end
end

# Computer player class
class Computer < Player
  include CliHelper

  def initialize
    super(FLOW.dig(:ai, :name))
  end

  def rand_num(arr)
    puts FLOW.dig(:ai, :feedback_msg1).call(name)
    slot = arr.sample
    puts FLOW.dig(:ai, :feedback_msg2).call(name, slot)
    slot.to_s
  end
end
