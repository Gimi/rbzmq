# encoding: utf-8
#
#    Copyright (c) 2007-2010 iMatix Corporation
#
#    This file is part of 0MQ.
#
#    0MQ is free software; you can redistribute it and/or modify it under
#    the terms of the Lesser GNU General Public License as published by
#    the Free Software Foundation; either version 3 of the License, or
#    (at your option) any later version.
#
#    0MQ is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    Lesser GNU General Public License for more details.
#
#    You should have received a copy of the Lesser GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'mkmf'

def sys(cmd, err_msg)
  p cmd
  system(cmd) || fail(err_msg)
end

def fail(msg)
  STDERR.puts msg
  exit(1)
end

def has_header?
  have_header('zmq.h') ||
    find_header('zmq.h', '/opt/local/include', '/usr/local/include', '/usr/include')
end

RbConfig::MAKEFILE_CONFIG['CC'] = ENV['CC'] if ENV['CC']

# XXX fallbacks specific to Darwin for JRuby (does not set these values in RbConfig::CONFIG)
LIBEXT = RbConfig::CONFIG['LIBEXT'] || 'a'
DLEXT = RbConfig::CONFIG['DLEXT'] || 'bundle'

cwd = File.expand_path '..', __FILE__
dst_path = File.join cwd, 'dst'
libs_path = File.join dst_path, 'lib'
vendor_path = File.join cwd, 'vendor'
zmq_path = File.join vendor_path, 'zeromq'
zmq_include_path = File.join zmq_path, 'include'

# extract dependencies
unless File.directory?(zmq_path)
  fail "The 'tar' (creates and manipulates streaming archive files) utility is required to extract dependencies" unless system('which tar')
  Dir.chdir(vendor_path) {
    sys "tar xvzf zeromq.tar.gz", "Could not extract the ZeroMQ archive!"
  }
end

# build libzmq
lib = File.join libs_path, "libzmq.#{LIBEXT}"
Dir.chdir zmq_path do
  sys "./autogen.sh", "ZeroMQ autogen failed!" unless File.exist?(File.join(zmq_path, 'configure'))
  sys "./configure --prefix=#{dst_path} --without-documentation --enable-shared && make && make install", "ZeroMQ compile error!"
end unless File.exist?(lib)

dir_config('zmq')

$INCFLAGS << " -I#{zmq_include_path}" if find_header("zmq.h", zmq_include_path)

$LIBPATH << libs_path.to_s

fail "Error compiling and linking libzmq" unless have_library("zmq")

create_makefile("zmq")
