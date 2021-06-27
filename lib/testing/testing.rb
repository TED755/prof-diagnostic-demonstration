# frozen_string_literal: true

require_relative 'question'
require_relative '../commands/input'
require_relative 'results'
require_relative 'control_quest_list'

# Class with diagnostic processing
class Testing
  attr_accessor :curr_question, :questions, :control_quest_list, :answers

  def initialize
    @answers = []
    @questions = Input.read_questions
    @i = 0
    @curr_question = @questions[@i]
    @control_quest_list = ControlQuestList.new
  end

  def next(answer)
    @answers << answer
    @i += 1
    @curr_question = @questions[@i]
  end

  def end?
    return true if @answers.size == 45

    false
  end

  def results
    Results.new(@answers, @questions)
  end

  def control?
    puts @control_quest_list.include_index?(@i)
    return true if @control_quest_list.include_index?(@i + 1)

    false
  end

  def auto_res
    @answers = [1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1,
                1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    # @answers = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    # 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    # @answers = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    # 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1]
    # @answers = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    # 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0]
    # @answers = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    # 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    results
  end
end
