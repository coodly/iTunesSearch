Pod::Spec.new do |s|
  s.name = 'iTunesSearch'
  s.version = '0.2.1'
  s.license = 'Apache 2'
  s.summary = 'Swift interface for iTunes Search'
  s.homepage = 'https://github.com/coodly/iTunesSearch'
  s.authors = { 'Jaanus Siim' => 'jaanus@coodly.com' }
  s.source = { :git => 'git@github.com:coodly/iTunesSearch.git', :tag => s.version }

  s.tvos.deployment_target = '9.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/*.swift'

  s.requires_arc = true
end
