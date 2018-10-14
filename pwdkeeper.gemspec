Gem::Specification.new do |s|
  s.name	= 'pwdkeeper'
  s.version	= '0.0.1'
  s.date	= '2018-10-07'
  s.summary = 'Password keeper'
  s.description = 'a gem to keep password'
  s.authors	= ["ShangMing Cherng"]
  s.email	= 'night1300013@gmail.com'
  #s.files	= ['lib/pwdkeeper.rb']
  s.files	= Dir['lib/**/*.rb']
  s.require_paths = ["lib"]
  s.homepage	=
    'http://rubygems.org/gems/pwdkeeper'
  s.license	= 'MIT'
  s.add_runtime_dependency 'sqlite3', '~> 1.3'
  s.add_runtime_dependency 'activerecord', '~> 5.0'
end
