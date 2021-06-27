#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/ssh'
require 'net/scp'

require 'erb'
require 'tmpdir'
require 'optparse'

require_relative '../lib/commands/input'

REQUIRED_RUBY_VERSION = '2.6.6'
APP_DIR = '/srv/Proftest'
SERVICE_NAME = 'application'
APP_USER = 'Proftest'

# This class is responsible for deployment application on server
# rubocop:disable Metrics/ClassLength
class Deploy
  def deploy(host, user, password)
    Net::SSH.start(host, user, password: password) do |connection|
      @connection = connection
      @scp = connection.scp
      install_ruby
      copy_application_files
      install_required_gems(APP_DIR)
      create_app_user(APP_USER, APP_DIR)
      setup_systemd_service(APP_DIR)
      enable_systemd_service
      restart_systemd_service
      install_nginx
      setup
    end
  end

  def install_ruby
    checked_run('sudo', 'apt-get', 'update')
    checked_run('sudo', 'apt-get', 'install', '-y', 'build-essential')
    unless valid_command?('which', 'ruby-install')
      archive_path = '/tmp/ruby-install-0.7.0.tar.gz'
      checked_run('wget', '-O', archive_path, 'https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz')
      checked_run('tar', '-C', '/tmp', '-xzvf', archive_path)
      ruby_install_dir = '/tmp/ruby-install-0.7.0'
      checked_run('sudo', 'make', 'install', dir: ruby_install_dir)
    end
    checked_run('sudo', 'ruby-install', '-L')
    checked_run('sudo', 'ruby-install', '--no-reinstall', '--jobs=4', 'ruby', REQUIRED_RUBY_VERSION)
  end

  def checked_run(*args, dir: nil)
    command = args.join(' ')
    puts "Running #{command}"
    command = "cd #{dir} && #{command}" unless dir.nil?
    @connection.exec!(command) do |_ch, _channel, data|
      print data
    end
  end

  def valid_command?(*args)
    command = args.join(' ')
    puts "Checking #{command}"
    result = @connection.exec!(command)
    result.exitstatus.zero?
  end

  def copy_application_files
    temp_dir = '/tmp/temp-app-dir'
    checked_run('sudo', 'rm', '-rf', temp_dir)
    puts 'Uploading application files'
    @scp.upload!(File.expand_path('..', __dir__), temp_dir, recursive: true)
    checked_run('sudo', 'mkdir', '-p', APP_DIR)
    checked_run('sudo', 'cp', '-R', File.join(temp_dir, '*'), APP_DIR)
    checked_run('sudo', 'rm', '-rf', temp_dir)
  end

  def ruby_installation_path
    "/opt/rubies/ruby-#{REQUIRED_RUBY_VERSION}/bin"
  end

  def install_required_gems(application_directory)
    checked_run('sudo', File.join(ruby_installation_path, 'bundle'),
                'install', '--gemfile', File.join(application_directory, 'Gemfile'),
                '--jobs=4', '--retry=3',
                '--without=development deployment')
  end

  def create_app_user(user_name, application_directory)
    unless valid_command?('id', user_name)
      checked_run('sudo', 'useradd', user_name, '--home-dir', application_directory,
                  '-M', '-s', '/bin/bash')
    end
    checked_run('sudo', 'chown', "#{user_name}:", '-R', application_directory)
  end

  def setup_systemd_service(application_directory)
    template = File.read(File.expand_path('application.service.erb', __dir__))
    path = [ruby_installation_path, '/usr/local/bin',
            '/usr/bin', '/bin'].join(':')
    bundle_path = File.join(ruby_installation_path, 'bundle')

    clojure = binding
    baked_template = ERB.new(template).result(clojure)

    service_file_name = "#{SERVICE_NAME}.service"
    file_path = File.join(__dir__, service_file_name)
    File.write(file_path, baked_template)
    remote_service_file = '/tmp/systemd.service'
    @scp.upload(file_path, remote_service_file)
    checked_run('sudo', 'mv', remote_service_file,
                File.join('/etc/systemd/system', "#{SERVICE_NAME}.service"))
    checked_run('sudo', 'systemctl', 'daemon-reload')
  end

  def enable_systemd_service
    checked_run('sudo', 'systemctl', 'enable', SERVICE_NAME)
  end

  def restart_systemd_service
    checked_run('sudo', 'systemctl', 'restart', SERVICE_NAME)
  end

  def install_nginx
    checked_run('sudo', 'apt', 'install', '-y', 'nginx')
  end

  def setup
    configure_file_name = 'proftest_config'
    configure_file_path = File.join(__dir__, configure_file_name)

    data = Input.create_config_file(APP_DIR)

    File.write(configure_file_path, data)
    nginx_configure_path = '/tmp/nginx_configure'
    @scp.upload!(configure_file_path, nginx_configure_path)

    checked_run('sudo', 'rm', '/etc/nginx/sites-available/default')
    checked_run('sudo', 'rm', '/etc/nginx/sites-enabled/default')
    checked_run('sudo', 'cp', nginx_configure_path, File.join('/etc/nginx/sites-available', configure_file_name))
    checked_run('sudo', 'ln', '-s', "/etc/nginx/sites-available/#{configure_file_name}",
                "/etc/nginx/sites-enabled/#{configure_file_name}")
    checked_run('sudo', 'systemctl', 'start', 'nginx')
    checked_run('sudo', 'systemctl', 'restart', 'nginx')
  end
end

if __FILE__ == $PROGRAM_NAME
  deployer = Deploy.new

  options = {}
  OptionParser.new do |opts|
    opts.on('--user USER') do |v|
      options[:user] = v
    end
    opts.on('--host HOST') do |v|
      options[:host] = v
    end
    opts.on('--password PASSWORD') do |v|
      options[:password] = v
    end
  end.parse!

  deployer.deploy(options[:host], options[:user], options[:password])
end
# rubocop:enable Metrics/ClassLength
