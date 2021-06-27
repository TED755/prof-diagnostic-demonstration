# frozen_string_literal: true

# This class is structure of competence level
class Levels
  attr_accessor :first_lvl, :second_lvl, :third_lvl

  def initialize(first, second, third)
    @first_lvl = first
    @second_lvl = second
    @third_lvl = third
  end

  def to_s
    "#{first_lvl}->#{second_lvl}->#{third_lvl}"
  end
end
