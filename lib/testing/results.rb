# frozen_string_literal: true

require_relative 'recomendation_dpo'
require_relative 'recomendation_um'
require_relative '../commands/input'

# This class generates results
# rubocop:disable Metrics/ClassLength
class Results
  attr_accessor :competence_lvl, :recomendations_dpo, :recomendations_um

  def initialize(answers, questions)
    @questions = questions
    @answers = answers
    @competence_count = 0
    @competence_lvl = 'No info'
    @competence_lvl_num = 0
    @recomendations_dpo = []
    @recomendations_um = []
    find
  end

  def find
    count_competence
    find_competence_lvl
    find_recomendations_dpo
    find_recomendations_um
  end

  def count_competence
    @answers.each_with_index do |ans, index|
      @competence_count += ans unless @answers[index].zero?
    end
  end

  def find_competence_lvl
    case @competence_count
    when 0..9
      @competence_lvl = 'ниже базового'
      @competence_lvl_num = 1
    when 10..20
      @competence_lvl = 'базовый'
      @competence_lvl_num = 2
    when 21..44
      @competence_lvl = 'достаточный'
      @competence_lvl_num = 3
    when 45
      @competence_lvl = 'высокий'
      @competence_lvl_num = 4
    end
  end

  def find_recomendations_dpo
    dpo = Input.create_recomend_dpo
    @answers.each_with_index do |answer, index|
      if answer.zero?
        rec = RecomendationDPO.new(@questions[index], @competence_lvl_num, dpo[index])
        @recomendations_dpo << rec
      end
    end
  end

  def find_recomendations_um
    um = create_um
    @answers.each_with_index do |answer, index|
      if answer.zero?
        rec = RecomendationUM.new(@questions[index], @competence_lvl_num, um)
        @recomendations_um << rec
      end
    end
  end

  # rubocop:disable Metrics/MethodLength, Layout/LineLength
  def create_um
    recomend_um = Array.new(24) { [] }
    recomend_um[1][0] = 'Модуль 1. Сущность, содержание и развитие профессиональной компетентности педагога'
    recomend_um[1][1] = 'Т1.1 Сущность и содержание профессиональной компетентности педагога'
    recomend_um[1][2] =
      'Т1.2 Построение и анализ индивидуального профиля специалиста на основе самооценивания профессиональной компетентности'
    recomend_um[1][3] = 'Т1.3 Разработка индивидуальной программы развития профессиональной компетентности'

    recomend_um[2][0] =
      'Модуль 2. Теоретико-методологические основы федерального государственного образовательного стандарта'
    recomend_um[3][0] = 'Модуль 3. Концептуальные основы современного НОО'
    recomend_um[4][0] = 'Модуль 4. Современные требования к планируемым результатам образования'
    recomend_um[5][0] =
      'Модуль 5. Системно-деятельностный подход как стратегическое средство достижения метапредметных и личностных результатов'
    recomend_um[6][0] = 'Модуль 6. ООП как со-бытийная модель организации образовательного процесса'

    recomend_um[7][0] = 'Модуль 7. Возрастные особенности младшего школьника'
    recomend_um[7][1] = 'Т7.1 Основные периоды развития личности (характеристика) и их преемственность'
    recomend_um[7][2] = 'Т7.2 Ведущие виды деятельности, их взаимосвязь, «полифония» видов деятельностей'
    recomend_um[7][3] = 'Т7.3 Учебная деятельность младшего школьника'

    recomend_um[8][0] =
      'Модуль 8. Психолого-педагогические основы организации учебной деятельности современных школьников'

    recomend_um[9][0] = 'Модуль 9. Психолого-педагогические основы готовности ребенка к школьному обучению'
    recomend_um[9][1] = 'Т9.1 Виды готовности, общая характеристика'
    recomend_um[9][2] = 'Т9.2 Диагностика готовности  ребенка к школьному обучению'
    recomend_um[9][3] = 'Т9.3 Роль семейного воспитания в формировании готовности ребенка к школьному обучению'
    recomend_um[9][4] = 'Т9.4 Психологические основы работы со взрослыми'

    recomend_um[10][0] = 'Модуль 10. Общая характеристика методов обучения и воспитания'

    recomend_um[11][0] = 'Модуль 11. Методика преподавания предметных областей НОО'
    recomend_um[11][1] = 'Т11.1 Методика преподавания предметных областей «русский язык» и литературное чтение'
    recomend_um[11][2] = 'Т11.2 Методика преподавания предметной области «математика и информатика»'
    recomend_um[11][3] = 'Т11.3 Методика преподавания предметной области «естествознание»'
    recomend_um[11][4] = 'Т11.4 Методика преподавания предметной области «физическая культура»'
    recomend_um[11][5] = 'Т11.5 Методика преподавания предметной области «технология»'
    recomend_um[11][6] = 'Т11.6 Методика преподавания предметной области «искусство»'

    recomend_um[12][0] = 'Модуль 12. Методическое обеспечение НОО'

    recomend_um[13][0] = 'Модуль 13. Педагогические подходы к организации образовательной деятельности'
    recomend_um[13][1] = 'Т13.1 Деятельностный подход как основа организации образовательного процесса'
    recomend_um[13][2] = 'Т13.2 Технологический подход к НОО'
    recomend_um[13][3] = 'Т13.3 Со-бытийный подход к организации образовательной деятельности'

    recomend_um[14][0] = 'Модуль 14. Технологии формирующего оценивания'

    recomend_um[15][0] = 'Модуль 15. Формы и способы организации образовательной деятельности'
    recomend_um[15][1] = 'Т15.1 Урок и внеурочная деятельность'
    recomend_um[15][2] =
      'Т15.2 Адаптация тематического планирования к условиям личностно-ориентированного образования (на основе образовательного со-бытия)'
    recomend_um[15][3] = 'Т15.3 Педагогическое сопровождение проектной и исследовательской деятельности учащихся'

    recomend_um[16][0] = 'Модуль 16. Составление индивидуальной программы развития учащегося'
    recomend_um[16][1] = 'Т16.1 Организация педагогической диагностики'
    recomend_um[16][2] = 'Т16.2 Разработка индивидуальной программы развития ребенка'

    recomend_um[17][0] = 'Модуль 17. Формирование универсальных учебных действий в начальном образовании'
    recomend_um[18][0] =
      'Модуль 18. Способы достижения метапредметных и личностных результатов средствами предметных областей'
    recomend_um[19][0] = 'Модуль 19. Основы педагогического проектирования'
    recomend_um[20][0] = 'Модуль 20. Проектирование урока на основе формирующего оценивания'
    recomend_um[21][0] = 'Модуль 21. Проектирование образовательного со-бытия'
    recomend_um[22][0] = 'Модуль 22. Технологии оценивания эффективности урока'

    recomend_um[23][0] = 'Модуль 23. Личность учителя начальных классов'
    recomend_um[23][1] = 'Т23.1 Коммуникативная компетентность учителя начальных классов'
    recomend_um[23][2] = 'Т23.2 Личностные профессиональные качества учителя начальных классов'
    recomend_um[23][3] = 'Т23.3 Основы педагогической рефлексии'

    recomend_um
  end
  # rubocop:enable Metrics/MethodLength, Layout/LineLength
end
# rubocop:enable Metrics/ClassLength
