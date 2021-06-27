# frozen_string_literal: true

# This class creates recomendation DPO
class RecomendationDPO
  attr_accessor :question, :growpoint, :recomendation

  def initialize(question, lvl, recomend_dpo)
    @competence = [1, 2, 3, 1, 2, 2, 3, 3, 3, 1, 2, 3, 3, 1, 2, 3, 3, 1, 1, 2,
                   2, 3, 3, 2, 2, 3, 1, 2, 3, 3, 1, 2, 2, 3, 3, 3, 1, 2, 2, 2,
                   3, 3, 1, 2, 3]
    @recomend_dpo = recomend_dpo
    @question = question
    @lvl = lvl
    @growpoint = ''
    @recomendation = ''
    find_growpoint
    create_recomendation
  end

  def find_growpoint
    @growpoint = if @competence[@question.number - 1] < @lvl
                   'Дефицит'
                 else
                   'Перспектива'
                 end
  end

  def create_recomendation
    case @lvl
    when 1
      @recomendation = @recomend_dpo.first_lvl
    when 2
      @recomendation = @recomend_dpo.second_lvl
    when 3
      @recomendation = @recomend_dpo.third_lvl
    end
  end

  def to_a
    [@question, @recomendation, @growpoint]
  end

  def to_s
    str = ''
    str += "#{@question}|"
    str += @growpoint

    str
  end
end
