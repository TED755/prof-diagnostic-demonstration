# frozen_string_literal: true

# This class is model with information about user's job
class JobInfo
  attr_accessor :category, :teaching_exp, :position, :raion, :school, :programm

  def initialize(category, teaching_exp, position, raion, school, programm)
    @category = category.to_s
    @teaching_exp = teaching_exp.to_s
    @position = position.to_s
    @raion = raion
    @school = school
    @programm = programm
  end

  def nil?
    @category.empty? && @teaching_exp.empty? && @position.empty? &&
      @raion.empty? && @school.empty?
  end

  def to_a
    [@position, @teaching_exp, @category, @raion, @school, @programm]
  end

  def to_s
    "#{@category} | #{@teaching_exp} | #{@position} | #{@raion} | #{@school}"
  end
end
