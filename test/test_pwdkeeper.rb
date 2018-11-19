require 'minitest/autorun'
require 'pwdkeeper'
require 'stringio'

class PwdkeeperTest < Minitest::Test
  def setup
    string_io = StringIO.new
    string_io.puts '123'
    string_io.puts '123'
    string_io.rewind         #Start form first stub
    $stdin = string_io
    out, err = capture_io do
      @pwd = PwdKeeper.new
    end
    $stdin = STDIN
    string_io.close
    assert_match "No password detected, creating one at #{Dir.home}/.pwdkeeper\nPlease enter a new master password: \nPlease enter a new master password again: \n", out
  end

  def teardown
    system("rm -f ~/.pwdkeeper")
  end

  def test_pwd_show
    out, err = capture_io do
      @pwd.show
    end
    assert_match "Website: Username \n***Empty***\n", out
  end

  def test_pwd_add
    string_io = StringIO.new
    string_io.puts 'www'
    string_io.rewind
    $stdin = string_io
    out, err = capture_io do
      @pwd.add("123","456")
    end
    $stdin = STDIN
    assert_match "Please enter a password: \n", out
  end

  def test_pwd_get
    string_io = StringIO.new
    string_io.puts 'www'
    string_io.rewind
    $stdin = string_io
    out, err = capture_io do
      @pwd.add("123","456")
      $stdin = STDIN
      #to let Clipboard.paste run without waiting
      Process.fork do
        @pwd.get("123", 2)
      end
    end
    out, err = capture_io do
      sleep 1
      puts Clipboard.paste
    end
    assert_match "www\n", out
  end

  def test_pwd_change
    string_io = StringIO.new
    string_io.puts '1234'
    string_io.puts '1234'
    string_io.rewind
    $stdin = string_io
    out, err = capture_io do
      @pwd.change
    end
    $stdin = STDIN
    assert_match "Please enter a new master password: \nPlease enter a new master password again: \n", out
  end
end
