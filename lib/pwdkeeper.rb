require 'encryptor'
require 'openssl'
require 'yaml'
require 'clipboard'
require 'fileutils'

class PwdKeeper
  def initialize(filename = nil)
    @pwd_file = File.expand_path(filename || '~/.pwdkeeper')
    access
    read
  end

  def add(key, username = nil)
    @pwd_data[key] = {}
    @pwd_data[key][:password] = ask_for_password("please enter a password")
    @pwd_data[key][:username] = username
    write
  end

  def get(key, seconds = 10)
    if @pwd_data[key] && pwd_plaintext = @pwd_data[key][:password]
      original_clipboard_content = Clipboard.paste
      Clipboard.copy pwd_plaintext
      puts "The password has been copied to your clipboard for #{seconds} seconds"
      begin
        sleep seconds.to_i
      rescue Interrupt
        Clipboard.copy original_clipboard_content
        puts "Interrupt detected. Bye!"
        exit
      end
      Clipboard.copy original_clipboard_content
      return true
    else
      puts "The requested password does not exist."
    end
  end

  def show
    puts "Website: Username \n"
    if @pwd_data.empty?
      puts "***Empty***"
    else
      @pwd_data.map{ |key, pwdentry|
        puts "#{key}: #{pwdentry[:username]}"
      }
    end
  end

  def change
    create_password
    write
  end

  private

  def read
    pwd_data_encrypted = File.read @pwd_file
    begin
      pwd_data_dump = Encryptor.decrypt(value: pwd_data_encrypted.force_encoding(Encoding::ASCII_8BIT), key: @pwd[0..31], iv: @pwd[0..11])
    rescue
      puts "The password is not correct."
      exit
    end
    @pwd_data = Marshal.load(pwd_data_dump) || {}
  end

  def write
    pwd_data_dump = Marshal.dump @pwd_data || {}
    begin
      pwd_data_encrypted = Encryptor.encrypt(value: pwd_data_dump, key: @pwd[0..31], iv: @pwd[0..11])
    rescue
      puts "The password is not correct."
      exit
    end
    File.open(@pwd_file, 'w'){ |f| f.write pwd_data_encrypted }
  end

  def access
    if !File.file? @pwd_file
      puts "No password detected, creating one at #{@pwd_file}"
      FileUtils.touch @pwd_file
      create_password
      write
    else
      @pwd = hash(ask_for_password 'Please enter the master password')
    end
  end

  def create_password
    begin
      @pwd = hash(ask_for_password 'Please enter a new master password')
      @pwd_again = hash(ask_for_password 'Please enter a new master password again')
      if @pwd_again != @pwd
        puts "The password does not match, please try again."
      end
    end until @pwd_again == @pwd
  end

  def ask_for_password(prompt = 'new password')
    print "#{prompt}: ".capitalize
    system 'stty -echo'
    pwd_plaintext = ($stdin.gets||'').chop
    system 'stty echo'
    puts
    pwd_plaintext
  end

  def hash(password)
    OpenSSL::Digest::SHA512.new(password).digest
  end
end
