# frozen_string_literal: true

# This class describes question
class Question
  attr_accessor :text, :number

  def initialize(text, number)
    @text = text
    @number = number
  end

  def to_s
    @text
  end
end
