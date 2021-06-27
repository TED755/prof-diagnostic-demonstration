# frozen_string_literal: true

require 'sinatra'
require 'csv'
require 'google_drive'
require 'spreadsheet'
require_relative 'lib/user/user'
require_relative 'lib/user/job_info'
require_relative 'lib/testing/testing'

configure do
  enable :sessions
  set :session_secret,
      '3598f4a7f12cc6181c49bb252663c075b650f4a316df4040a8e
      fac669f98530e30633a04a4ad84b218c639a60f08794bd28e73d3908dc41cefc15bcfb01eb09d'
  set :user_list, {}
  set :tests_list, {}
  set :test, nil
end

KEY_FILE = 'client_secret.json'

FILE_URL_DIAGNOSTIC = 'https://docs.google.com/spreadsheets/d/1E7xXd18F1oH8rSod0J7UB-n4Vzdup1S1QEoGHAXY8c0/edit#gid=0'

def profession_sheet
  session ||= GoogleDrive::Session.from_service_account_key(KEY_FILE)
  spreadsheet ||= session.spreadsheet_by_url(FILE_URL_DIAGNOSTIC)
  @profession_sheet ||= spreadsheet.worksheets[1]
end

def testing_sheet
  session ||= GoogleDrive::Session.from_service_account_key(KEY_FILE)
  spreadsheet ||= session.spreadsheet_by_url(FILE_URL_DIAGNOSTIC)
  @testing_sheet ||= spreadsheet.worksheets[0]
end

def send_data(new_row_first, new_row_second)
  profession_sheet.insert_rows(profession_sheet.num_rows + 1, [new_row_second])
  profession_sheet.save

  testing_sheet.insert_rows(testing_sheet.num_rows + 1, [new_row_first])
  testing_sheet.save
end

def create_data
  data = []
  competence = [1, 2, 3, 1, 2, 2, 3, 3, 3, 1, 2, 3, 3, 1, 2, 3, 3, 1, 1, 2,
                2, 3, 3, 2, 2, 3, 1, 2, 3, 3, 1, 2, 2, 3, 3, 3, 1, 2, 2, 2,
                3, 3, 1, 2, 3]
  data << @user.name
  @test.answers.each_with_index do |answer, index|
    data << if answer == 1
              competence[index]
            else
              0
            end
  end
  data
end

def create_job_data
  data = []

  data << @user.name
  data << @user.email
  @user.job_information.to_a.each do |el|
    data << el
  end
  data
end

get '/' do
  erb :main
end

get '/registration' do
  erb :registration
end

post '/registration' do
  name = "#{params['lastName']} #{params['firstName']} #{params['secondName']}"
  job_info = JobInfo.new(params['category'], params['experience'], params['position'], params['raion'],
                         params['school'], params['programm'])
  email = params['email']

  user = User.new(name, job_info, email)
  settings.user_list[user.id] = user
  user_id = user.id
  session[:user_id] = user_id
  settings.tests_list[user_id] = Testing.new

  redirect('/')
end

before do
  @session_id = session[:session_id]
  user_id = session[:user_id]
  @user = settings.user_list[user_id]
  @test = settings.tests_list[user_id]
  puts "User: #{@user}"
  puts "Testing: #{@test}"
end

get '/autologin' do
  user = User.new('Тихомиров Евгений Дмитриевич',
                  JobInfo.new('Не аттестован', 'до 1 года', 'Учитель НОО',
                              'Ярославль гор.', 'МОУ СОШ № 36', 'Тьюторский центр'), 'developer@dev.kit')
  settings.user_list[user.id] = user
  session[:user_id] = user.id
  settings.tests_list[user.id] = Testing.new
  redirect to('/results/auto')
end

get '/download/files/dpo/:id' do
  @res = @test.results
  name = "files/dpo/#{@user.name.surname}_#{@user.name.name}_#{@user.name.second_name}_ДПО.csv"

  name = create_file(name)
  puts(name)
  send_file("files/dpo/#{@user.name.surname}_#{@user.name.name}_#{@user.name.second_name}_ДПО.xls")
end

def create_file(name)
  @res = @test.results

  CSV.open(name, 'w') do |csv|
    csv << ['Позиция анкеты', 'Рекомендуемое содержание ДПО', 'Точки роста']
    @res.recomendations_dpo.each do |r|
      csv << r.to_a
    end
    csv << ['']
    csv << [@user.name.to_s]
    csv << [@user.job_information.to_s]
  end

  csv2xls(name)
end

def csv2xls(input_path)
  book = Spreadsheet::Workbook.new
  sheet1 = book.create_worksheet

  CSV.open(input_path, 'r') do |csv|
    csv.each_with_index do |row, i|
      sheet1.row(i).replace(row)
    end
  end
  name = "files/dpo/#{@user.name.surname}_#{@user.name.name}_#{@user.name.second_name}_ДПО.xls"
  book.write(name)
  system("rm #{input_path}")
  name
end

def csv2xls_um(input_path)
  book = Spreadsheet::Workbook.new
  sheet1 = book.create_worksheet

  CSV.open(input_path, 'r') do |csv|
    csv.each_with_index do |row, i|
      sheet1.row(i).replace(row)
    end
  end
  name = "files/um/#{@user.name.surname}_#{@user.name.name}_#{@user.name.second_name}_ИОМ.xls"
  book.write(name)
  system("rm #{input_path}")
  name
end

get '/download/files/um/:id' do
  @res = @test.results
  name = "files/um/#{@user.name.surname}_#{@user.name.name}_#{@user.name.second_name}_ИОМ.csv"

  send_file(create_um_file(name))
end

def create_um_file(name)
  @res = @test.results
  CSV.open(name, 'w') do |csv|
    csv << ['Позиция анкеты', 'Рекомендуемое содержание ИОМ', 'Количество часов', 'Точки роста']
    @res.recomendations_um.each do |r|
      csv << r.to_a
    end
    csv << ['']
    csv << [@user.name.to_s]
    csv << [@user.job_information.to_s]
  end

  csv2xls_um(name)
end

get '/testing' do
  redirect('/') if @test.nil?
  redirect('/results') if @test.end?
  erb :testing
end

get '/yes' do
  redirect('/') if @test.nil?
  redirect('/results') if @test.end?
  redirect '/control_question' if @test.control?
  @test.next(1)
  redirect('/testing')
end

get '/control_question' do
  redirect '/' if @test.nil?
  redirect('/testing') unless @test.control?
  @quest = @test.control_quest_list.find_by_index(@test.curr_question.number)
  erb :control_quest
end

post '/control_question' do
  redirect '/' if @test.nil?
  redirect('/testing') unless @test.control?
  user_id = session[:user_id]
  @test = settings.tests_list[user_id]
  @quest = @test.control_quest_list.find_by_index(@test.curr_question.number)

  answers_array = Array.new(@quest.answers.size) { 0 }
  if params['checkbox'].nil?
    @error = 'Пожалуйста, отметьте те варианты, которые считаете правильными или пропустите этот вопрос'
  end

  if @error.nil?
    data = params['checkbox']
    data.each do |el|
      answers_array[el.to_i] = 1
    end
    @test.next(@quest.true?(answers_array))
    redirect('/testing')
  else
    erb :control_quest
  end
end

get '/no' do
  redirect('/') if @test.nil?
  redirect('/results') if @test.end?
  @test.next(0)
  redirect('/testing')
end

get '/results' do
  redirect('/') if @test.nil?
  if @test.end?
    @res = @test.results

    unless @user.data_sends
      @user.data_sends = true
      send_data(create_data, create_job_data)
    end

    erb :result_page
  else
    redirect('/testing')
  end
end

get '/results/show_dpo' do
  redirect('/') if @test.nil?
  @res = @test.results
  @user.res_info = @res

  @file_name = "#{@user.name.surname}_#{@user.name.name}_#{@user.name.second_name}_ДПО.xls"
  erb :dpo
end

get '/results/show_um' do
  redirect('/') if @test.nil?
  redirect('/results') unless @user.job_information.position == 'Учитель НОО'
  @res = @test.results
  @user.res_info = @res

  @file_name = "#{@user.name.surname}_#{@user.name.name}_#{@user.name.second_name}_ИОМ.xls"
  erb :um
end

get '/results/auto' do
  @res = @test.auto_res
  redirect('/results')
end

get '/more_info' do
  erb :more_info
end

get '/*' do
  erb :error
end
