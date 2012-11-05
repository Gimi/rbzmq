Gem::Specification.new do |s|
  s.name = 'zmq_bundled'
  s.version = '2.1.4'
  s.date = '2011-09-14'
  s.authors = ['Martin Sustrik', 'Brian Buchanan', 'Gimi Liang']
  s.email = %w[sustrik@250bpm.com bwb@holo.org liang.gimi@gmail.com]
  s.description = 'This gem provides a Ruby API for the ZeroMQ messaging library. It has the zeromq library bundled, so there is no need to install zeromq to your system.'
  s.homepage = 'http://www.zeromq.org/bindings:ruby'
  s.summary = 'Ruby API for ZeroMQ'
  s.extensions = 'extconf.rb'
  s.files = Dir['Makefile'] + Dir['*.c'] + Dir['vendor/*']
  s.has_rdoc = true
  s.extra_rdoc_files = Dir['*.c']
end
