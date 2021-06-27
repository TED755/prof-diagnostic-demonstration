# frozen_string_literal: true

# This class is responsible for control question
class ControlQuestion
  attr_accessor :question, :answers, :true_answers, :index

  def initialize(question, answers, true_answers, index)
    @question = question
    @answers = answers
    @true_answers = true_answers
    @index = index
  end

  def true?(answers)
    @true_answers == answers ? 1 : 0
  end

  def to_s
    @question
  end
end
