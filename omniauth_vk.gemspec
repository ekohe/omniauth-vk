require File.expand_path('../lib/omniauth/vk/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'omniauth-vk'
  s.version = OmniAuth::Vk::VERSION
  s.authors = ['Yuri S', 'Roman S.']
  s.email = ['fudoshiki.ari@gmail.com', 'rs.mything@gmail.com']

  s.summary = 'OmniAuth strategy for vk.com'
  s.description = 'Authorization OmniAuth strategy for https://vk.com'
  s.homepage = 'https://github.com/Sharevari-Inc/omniauth-vk'
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'omniauth-oauth2', '~> 1.0'

  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'minitest', '~> 5.0'
end
