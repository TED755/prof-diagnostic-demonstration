# frozen_string_literal: true

require 'securerandom'
require_relative 'user_name'
require_relative 'job_info'

# This class describes user
class User
  attr_accessor :name, :job_information, :password, :id, :res_info, :data_sends, :email

  def initialize(name, job_information, email)
    @name = UserName.new(name)
    @email = email
    @job_information = job_information
    @password = password
    @id = SecureRandom.uuid
    @data_sends = false
  end

  def check_password(password)
    @password == password
  end

  def initials
    @name.initials
  end

  def to_s
    initials
  end
end
