# frozen_string_literal: true

# Player class
class Player
  attr_accessor :name

  def initialize(name = 'Player 1')
    @name = name
  end
end
