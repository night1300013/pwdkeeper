require 'json'
require 'encryptor'
require 'securerandom'
require 'base64'
require 'yaml'

class PwdKeeper
  def initialize
    config = YAML.load_file("./key.yml")
    @cipher = OpenSSL::Cipher.new(config["cipher"])
    @cipher.encrypt # Required before '#random_key' or '#random_iv' can be called. http://ruby-doc.org/stdlib-2.0.0/libdoc/openssl/rdoc/OpenSSL/Cipher.html#method-i-encrypt
    @secret_key = config["secret_key"] # Insures that the key is the correct length respective to the algorithm used.
    @iv = config["iv"] # Insures that the IV is the correct length respective to the algorithm used.
    @salt = config["salt"]
  end

  def main
    puts "Password Keeper: Keep your password nice and safe"
    puts "0 - Enter website's username and password"
    puts "1 - View all websites' usernames and passwords"
    puts "2 - Search for a wesite's username and password"
    puts "3 - Exit"
    print "Enter your selection: "

    selection = gets.to_i

    case selection
      when 0
        system "clear"
        enter_info
        main
      when 1
        system "clear"
        search_all
        main
      when 2
        system "clear"
        search_one
        main
      when 3
        puts "Bye!"
        exit(0)
      else
        system "clear"
        puts "I'm Sorry, that is not a valid input"
        main
    end
  end

  def enter_info
    puts "New Website Entry"
    print "Website: "
    website = gets.chomp
    print "username: "
    username = gets.chomp
    print "password: "
    password = gets.chomp
    # print "key to decrypt: "
    # key = gets.chomp

    encrypted_password = Encryptor.encrypt(value: password, key: @secret_key, iv: @iv, salt: @salt)
    encoded = Base64.encode64(encrypted_password).encode('utf-8')
#    puts encoded
#    decoded = Base64.decode64 encoded.encode('ascii-8bit')
#    puts Encryptor.decrypt(value: decoded, key: @secret_key, iv: @iv, salt: @salt)
    #encrypt the password and put it into the database
    json = JSON.parse(File.read('info.json')) if File.file?('info.json')
    hash = {
      "website" => website,
      "username" => username,
      "password" => encoded
    }
    #An array to store all the hashed information
    hashes = []
    if File.file?('info.json')
      json.each {|h| hashes << h}
    end
    #Append the new hash to the last
    hashes << hash

    File.open("info.json", "w") do |f|
      f.write JSON.pretty_generate(hashes)
    end
    system "clear"
    puts "New entry created"
  end

  def search_all
    if File.file?('info.json')
      puts "Show all website's username and password"
      data = JSON.parse(File.read('info.json'))
      #encoded = data[0]["password"]
      #decoded = Base64.decode64 (encoded).encode('ascii-8bit')
      i = 1
      data.each do |hash|
        puts "#{i}: {"
        hash.each do |key, value|
          puts "#{key}: #{value}"
        end
        puts "}"
        i += 1
      end
    else
      puts "No Entry"
    end
  end

  def search_one
    if File.file?('info.json')
      puts "Please enter the website's name:"
      print "Website: "
      website = gets.chomp
      arr = JSON.parse(File.read('info.json'))
      result =  arr.find {|h1| h1['website'] == website}
      if result.nil?
        puts "No Entry"
      else
        system "clear"
        result.each do |key, value|
          if key != "password"
            puts "#{key}: #{value}"
          else
            decoded = Base64.decode64 (value).encode('ascii-8bit')
            clear_text = Encryptor.decrypt(value: decoded, key: @secret_key, iv: @iv, salt: @salt)
            puts "#{key}: #{clear_text}"
          end
        end
      end
    else
      puts "No Entry"
    end
  end
end
