# frozen_string_literal: true

# This class is model of user's name
class UserName
  attr_accessor :name, :surname, :second_name, :full_name

  def initialize(full_name)
    @full_name = full_name.to_s
    words = @full_name.split
    @name = words[1].to_s
    @surname = words[0].to_s
    @second_name = words[2].to_s unless words[2].to_s.empty?
  end

  def initials
    second_name = @second_name.empty? ? '' : "#{@second_name[0]}."
    "#{@surname} #{@name[0]}.#{second_name}"
  end

  def name_secname
    "#{@name} #{@second_name}"
  end

  def to_s
    @full_name
  end
end
