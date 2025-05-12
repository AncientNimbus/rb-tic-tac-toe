# frozen_string_literal: true

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
  def initialize
    super('Computer')
  end

  def rand_num
    p 'Pick a random number between 1-9'
  end
end
