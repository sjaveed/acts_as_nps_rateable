# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_nps_rateable/version'

Gem::Specification.new do |gem|
  gem.name          = 'acts_as_nps_rateable'
  gem.version       = ActsAsNpsRateable::VERSION
  gem.authors       = ['Shahbaz Javeed']
  gem.email         = ['sjaveed@gmail.com']
  gem.description   = %q{Rails gem that provides Net Promoter Score (NPS) ratings and analysis for ActiveRecord models.  It can be used as a regular 0 to 10 rating scale and you can just ignore the NPS analysis methods.}
  gem.summary       = %q{Net Promoter Score ratings and analysis for ActiveRecord models}
  gem.homepage      = 'https://github.com/sjaveed/acts_as_nps_rateable'

  gem.add_dependency 'activerecord', '>= 3.0.0'
  gem.add_dependency 'rails', '>= 3.0.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
