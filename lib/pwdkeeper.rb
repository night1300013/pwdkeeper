require 'sqlite3'

class PwdKeeper
  def initialize
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
    #encrypt the password and put it into the database
    system "clear"
    puts "New entry created"
  end

  def search_all

  end

  def search_one

  end

end
