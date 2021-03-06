# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name                  = 'tkwrapper'
  s.version               = '1.7.3'
  s.required_ruby_version = '>= 3.0'
  s.summary               = 'Extensions/Wrapper ruby Tk'
  s.authors               = ['Benjamin Schnitzler']
  s.email                 = 'reception@e.mail.de'
  s.files                 = Dir['lib/**/*']
  s.homepage              = 'https://github.com/bschnitz/tkwrapper'
  s.license               = 'MIT'
  s.add_dependency          'tk', '~> 0.4'
end
