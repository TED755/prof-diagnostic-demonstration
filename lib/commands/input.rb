# frozen_string_literal: true

require 'yaml'
require 'csv'
require_relative '../testing/question'
require_relative '../testing/levels'

# This module solves some monotonic operations
module Input
  FILE_QUESTIONS = File.expand_path('../../data/questions_list.yaml', __dir__)
  FILE_DPO = File.expand_path('../../data/DPO_text.yaml', __dir__)
  FILE_UM = File.expand_path('../../data/UM_text.yaml', __dir__)

  def self.read_questions
    exit unless File.exist?(FILE_QUESTIONS)
    questions = []
    all_info = Psych.load_file(FILE_QUESTIONS)
    all_info.each do |quest|
      questions << Question.new(quest['Text'], quest['Number'])
    end
    questions
  end

  def self.create_recomend_dpo
    exit unless File.exist?(FILE_DPO)
    dpo = []
    all_info = Psych.load_file(FILE_DPO)
    all_info.each_with_index do |str, _i|
      f = str['f']
      s = str['s']
      t = str['t']

      dpo << Levels.new(f, s, t)
    end
    dpo
  end

  def self.create_config_file(app_dir)
    "server {
      listen 80 default_server;
      listen [::]:80 default_server;
      root #{app_dir}/public;
      index index.html index.htm index.nginx-debian.html;
      server_name _;
      location @app {
              proxy_pass http://127.0.0.1:9292;
              include proxy_params;
      }
      location / {
              try_files $uri $uri.html @app;
      }
    }"
  end
end
