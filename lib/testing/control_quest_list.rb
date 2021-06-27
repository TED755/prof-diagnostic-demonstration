# frozen_string_literal: true

require 'yaml'
require_relative 'control_quest'

# This class is responsible for saving list of control questions
class ControlQuestList
  def initialize
    @list = read_questions
  end

  FILE = File.expand_path('../../data/control_quest.yaml', __dir__)
  def read_questions
    exit unless File.exist?(FILE)

    list = []
    all_info = Psych.load_file(FILE)
    all_info.each do |quest|
      list << ControlQuestion.new(quest['Quest'], quest['Answer'], quest['True_answers'], quest['Index'])
    end

    list
  end

  def include_index?(index)
    @list.include?(find_by_index(index))
  end

  def find_by_index(index)
    @list.each do |quest|
      return quest if quest.index == index
    end
    nil
  end

  def to_s
    @list.to_s
  end
end
