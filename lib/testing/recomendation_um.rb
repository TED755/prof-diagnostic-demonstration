# frozen_string_literal: true

# This class creates recomendation IOM
class RecomendationUM
  attr_accessor :question, :growpoint, :recomendation, :hour_count

  def initialize(question, lvl, recomend_um)
    @competence = [1, 2, 3, 1, 2, 2, 3, 3, 3, 1, 2, 3, 3, 1, 2, 3, 3, 1, 1, 2,
                   2, 3, 3, 2, 2, 3, 1, 2, 3, 3, 1, 2, 2, 3, 3, 3, 1, 2, 2, 2,
                   3, 3, 1, 2, 3]

    @recomend_um = recomend_um

    @question = question
    @lvl = lvl
    @growpoint = ''
    @recomendation = ''
    @hour_count = ''

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

  def to_s
    str = ''
    str += "#{@question}|"
    str += "#{@recomendation}|"
    str += "#{@hour_count}|"
    str += @growpoint

    str
  end

  def to_a
    [@question, @recomendation, @hour_count, @growpoint]
  end

  def create_recomendation
    case @question.number
    when 1
      @recomendation = @recomend_um[2][0]
      @hour_count = if @lvl == 1
                      '6'
                    else
                      '4'
                    end
    when 2
      @recomendation = @recomend_um[3][0]
      @recomendation = "#{@recomend_um[5][0]}, #{@recomend_um[6][0]}" if @lvl == 3
      @hour_count = @lvl == 3 ? '6 + 20' : '18'
    when 3
      @recomendation = @recomend_um[4][0] if @lvl == 1 || @lvl == 2
      @recomendation = "#{@recomend_um[5][0]}, #{@recomend_um[6][0]}" if @lvl == 3
      @hour_count = @lvl == 3 ? '6 + 20' : '24'
    when 4
      @recomendation = @recomend_um[7][1]
      @recomendation = "#{@recomend_um[7][1]}, #{@recomend_um[8][0]}" if @lvl == 3
      @hour_count = @lvl == 3 ? '2 + 6' : '3'
    when 5
      @recomendation = @recomend_um[7][2]
      @recomendation = "#{@recomend_um[7][2]}, #{@recomend_um[8][0]}" if @lvl == 3
      @hour_count = @lvl == 3 ? '2 + 6' : '3'
    when 6
      @recomendation = @recomend_um[9][3]
      @hour_count = '2'
    when 7
      @recomendation = @recomend_um[7][3]
      @recomendation = "#{@recomend_um[7][3]}, #{@recomend_um[8][0]}" if @lvl == 3
      @hour_count = @lvl == 3 ? '2 + 6' : '6'
    when 8
      @recomendation = "#{@recomend_um[9][1]}, #{@recomend_um[9][2]}"
      if @lvl == 3
        @recomendation = "#{@recomend_um[9][1]}, #{@recomend_um[9][2]}, "
        + @recomend_um[8][0]
      end
      @hour_count = @lvl == 3 ? '2 + 2 + 6' : '2 + 2'
    when 9
      @recomendation = @recomend_um[9][4]
      @hour_count = '6'
    when 10
      if @lvl == 2
        @recomendation = @recomend_um[10][0]
        @hour_count = '6'
      end

      if @lvl == 1
        @recomendation = "#{@recomend_um[10][0]}, НА ВЫБОР: Методика преподавания предметных областей
        «русский язык и литературное чтение»,
        «математика и информатика»,
        «естествознание»,
        «физическая культура»,
        «технология»,
        «искусство», #{@recomend_um[12][0]}"
        @hour_count = '6 + 6 + 6'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[10][0]}, #{@recomend_um[13][1]}, #{@recomend_um[13][3]}"
        @hour_count = '6 + 6 + 6'
      end

    when 11
      if @lvl == 1
        @recomendation = @recomend_um[13][2]
        @hour_count = '6'
      end

      if @lvl == 2 || @lvl == 3
        @recomendation = @recomend_um[14][0]
        @hour_count = '18'
      end

    when 12
      @recomendation = @recomend_um[13][0]
      @hour_count = '18'
    when 13
      @recomendation = @recomend_um[13][3]
      @hour_count = '18'
    when 14
      if @lvl == 1 || @lvl == 2
        @recomendation = @recomend_um[19][0]
        @hour_count = '12'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '42 + 24'
      end

    when 15
      if @lvl == 1
        @recomendation = @recomend_um[19][0]
        @hour_count = '12'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[19][0]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]},
        #{@recomend_um[22][0]}"
        @hour_count = '12 + 42 + 24 + 12'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}, #{@recomend_um[22][0]}"
        @hour_count = '42 + 24 + 12'
      end

    when 16
      if @lvl != 3
        @recomendation = @recomend_um[21][0]
        @hour_count = '24'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[21][0]}, #{@recomend_um[22][0]}"
        @hour_count = '24 + 12'
      end

    when 17
      @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
      @hour_count = '42 + 24'
    when 18
      if @lvl == 1
        @recomendation = @recomend_um[16][1]
        @hour_count = '6'
      end

      @recomendation = "#{@recomend_um[16][1]}, #{@recomend_um[17][0]}" if @lvl != 1
      @hour_count = '6 + 12'

    when 19
      @recomendation = "#{@recomend_um[15][1]}, #{@recomend_um[19][0]}" if @lvl == 1 || @lvl == 2
      @recomendation = "#{@recomend_um[15][1]}, #{@recomend_um[18][0]}" if @lvl == 3
      @hour_count = '10 + 12'
    when 20
      if @lvl == 1
        @recomendation = @recomend_um[15][1]
        @hour_count = '10'
      end

      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[15][1]}, #{@recomend_um[21][0]}"
        @hour_count = '10 + 24'
      end

    when 21
      if @lvl == 1
        @recomendation = @recomend_um[15][2]
        @hour_count = '6'
      end

      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[15][2]}, #{@recomend_um[15][3]}, #{@recomend_um[21][0]}"
        @hour_count = '18 + 18 + 24'
      end

    when 22
      if @lvl == 1
        @recomendation = @recomend_um[15][3]
        @hour_count = '6'
      end

      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[15][3]}, #{@recomend_um[21][0]}"
        @hour_count = '18 + 24'
      end

    when 23
      @recomendation = @recomend_um[16][0]
      @hour_count = @lvl == 3 ? '18' : '12'
    when 24
      if @lvl == 1
        @recomendation = @recomend_um[23][1]
        @hour_count = '6'
      end

      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[23][1]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '6 + 42 + 24'
      end

    when 25
      if @lvl == 1
        @recomendation = @recomend_um[23][1]
        @hour_count = '6'
      end

      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[23][1]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '6 + 42 + 24'
      end

    when 26
      if @lvl == 1
        @recomendation = @recomend_um[23][1]
        @hour_count = '6'
      end

      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[23][1]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '6 + 42 + 24'
      end

    when 27
      if @lvl == 1
        @recomendation = @recomend_um[19][0]
        @hour_count = '12'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[19][0]}, #{@recomend_um[21][0]}, #{@recomend_um[23][1]}"
        @hour_count = '12 + 24 + 6'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[21][0]}, #{@recomend_um[23][1]}"
        @hour_count = '24 + 6'
      end

    when 28
      @recomendation = @recomend_um[23][1]
      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[23][1]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
      end
      @hour_count = @lvl == 1 ? '6' : '6 + 42 + 24'
    when 29
      @recomendation = @recomend_um[23][1]
      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[23][1]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
      end
      @hour_count = @lvl == 1 ? '6' : '6 + 42 + 24'
    when 30
      @recomendation = @recomend_um[23][1]
      if @lvl == 2 || @lvl == 3
        @recomendation = "#{@recomend_um[23][1]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
      end
      @hour_count = @lvl == 1 ? '6' : '6 + 42 + 24'
    when 31
      if @lvl == 1
        @recomendation = "#{@recomend_um[23][2]}, #{@recomend_um[19][0]}"
        @hour_count = '6 + 12'
      else
        @recomendation = @recomend_um[23][2]
        @hour_count = '6'
      end

    when 32
      if @lvl == 1
        @recomendation = "#{@recomend_um[23][2]}, #{@recomend_um[19][0]}"
        @hour_count = '6 + 12'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[23][2]}, #{@recomend_um[19][0]},
        #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '6 + 12 + 42 + 24'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[23][2]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '6 + 42 + 24'
      end

    when 33
      if @lvl == 1
        @recomendation = "#{@recomend_um[23][2]}, #{@recomend_um[19][0]}"
        @hour_count = '6 + 12'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[23][2]}, #{@recomend_um[19][0]},
        #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '6 + 12 + 42 + 24'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[23][2]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '6 + 42 + 24'
      end

    when 34
      if @lvl == 1
        @recomendation = @recomend_um[23][2]
        @hour_count = '6'

      else
        @recomendation = @recomend_um[21][0]
        @hour_count = '24'
      end

    when 35
      @recomendation = @recomend_um[23][2] if @lvl == 1
      @recomendation = "#{@recomend_um[21][0]}, #{@recomend_um[23][2]}" if @lvl == 2
      @recomendation = "#{@recomend_um[21][0]}, #{@recomend_um[23][2]}" if @lvl == 3
      @hour_count = @lvl == 1 ? '6' : '24 + 6'
    when 36
      if @lvl == 1
        @recomendation = @recomend_um[23][2]
        @hour_count = '6'

      else
        @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '42 + 24'
      end

    when 37
      if @lvl == 1
        @recomendation = @recomend_um[19][0]
        @hour_count = '12'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[19][0]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '12 + 42 + 24'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '42 + 24'
      end

    when 38
      if @lvl == 1
        @recomendation = @recomend_um[19][0]
        @hour_count = '12'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[19][0]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '12 + 42 + 24'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '42 + 24'
      end

    when 39
      if @lvl == 1
        @recomendation = @recomend_um[23][0]
        @hour_count = '18'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[23][0]}, #{@recomend_um[21][0]}"
        @hour_count = '18 + 24'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[23][0]}, #{@recomend_um[21][0]}"
        @hour_count = '18 + 24'
      end

    when 40
      if @lvl == 1
        @recomendation = @recomend_um[19][0]
        @hour_count = '12'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[19][0]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '12 + 42 + 24'
      end

      if @lvl == 3
        @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '42 + 24'
      end

    when 41
      if @lvl == 1
        @recomendation = @recomend_um[23][2]
        @hour_count = '6'

      else
        @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '42 + 24'
      end

    when 42
      if @lvl == 1
        @recomendation = @recomend_um[23][3]
        @hour_count = '6'

      else
        @recomendation = "#{@recomend_um[20][0]}, #{@recomend_um[21][0]}"
        @hour_count = '42 + 24'
      end

    when 43
      @recomendation = "#{@recomend_um[1][1]}, #{@recomend_um[23][3]}" if @lvl == 1
      @recomendation = "#{@recomend_um[1][1]}, #{@recomend_um[23][3]}" if @lvl == 2
      @recomendation = "#{@recomend_um[1][1]}, #{@recomend_um[23][3]}" if @lvl == 3
      @hour_count = '2 + 6'
    when 44
      if @lvl == 1
        @recomendation = "#{@recomend_um[1][2]}, #{@recomend_um[19][0]}, #{@recomend_um[23][3]}"
        @hour_count = '2 + 12 + 6'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[1][2]}, #{@recomend_um[19][0]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]},
        #{@recomend_um[22][0]}, #{@recomend_um[23][3]}"
        @hour_count = '2 + 12 + 42 + 24 + 12 + 6'
      end
      if @lvl == 3
        @recomendation = "#{@recomend_um[1][2]}, #{@recomend_um[20][0]},
        #{@recomend_um[21][0]}, #{@recomend_um[22][0]}, #{@recomend_um[23][3]}"
        @hour_count = '2 + 42 + 24 + 12 + 6'
      end
    when 45
      if @lvl == 1
        @recomendation = "#{@recomend_um[1][3]}, #{@recomend_um[23][3]}"
        @hour_count = '8 + 6'
      end

      if @lvl == 2
        @recomendation = "#{@recomend_um[1][3]}, #{@recomend_um[20][0]}, #{@recomend_um[21][0]},
        #{@recomend_um[22][0]}, #{@recomend_um[23][3]}"
        @hour_count = '8 + 42 + 24 + 12 + 6'
      end
      if @lvl == 3
        @recomendation = "#{@recomend_um[1][3]}, #{@recomend_um[20][0]},
        #{@recomend_um[21][0]}, #{@recomend_um[22][0]}, #{@recomend_um[23][3]}"
        @hour_count = '8 + 42 + 24 + 12 + 6'
      end
    end
  end
end
