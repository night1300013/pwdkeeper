Gem::Specification.new do |s|
  s.name	= 'pwdkeeper'
  s.version	= '0.0.1'
  s.date	= '2018-10-28'
  s.summary = 'Password keeper'
  s.description = 'a gem to keep password'
  s.authors	= ["ShangMing Cherng"]
  s.email	= 'night1300013@gmail.com'
  s.files	= Dir['lib/**/*.rb']
  s.require_paths = ["lib"]
  s.homepage	=
    'http://rubygems.org/gems/pwdkeeper'
  s.license	= 'MIT'
  s.executables = ['pwdkeeper']
  s.add_runtime_dependency 'encryptor', '~> 3.0'
  s.add_dependency 'clipboard', '~> 1.0'
end
