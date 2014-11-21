Gem::Specification.new do |s|
	s.name = 'wst'
	s.version = '0.9.0'
	s.date = '2014-12-12'
	s.summary = 'Web Site Today'
	s.description = 'A nice web site generator'
	s.authors = ['Yves Brissaud']
	s.email = 'yves.brissaud@gmail.com'
	all_files       = `git ls-files -z`.split("\x0")
	s.files         = all_files.grep(%r{^(bin|lib)/})
	s.executables   = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
	s.require_paths = ['lib']
	s.homepage = 'https://github.com/eunomie/wst'
	s.license = 'MIT'

	s.add_runtime_dependency 'haml', "~>4.0"
	s.add_runtime_dependency 'sass', "~>3.4"
	s.add_runtime_dependency 'coffee-script', "~>2.3"
	s.add_runtime_dependency 'redcarpet', "~>3.2"
	s.add_runtime_dependency 'pygments.rb', "~>0.6"
	s.add_runtime_dependency 'html_truncator', "~>0.2"
	s.add_runtime_dependency 'uglifier', "~>2.4"
	s.add_runtime_dependency 'serve', "~>1.5"
end
