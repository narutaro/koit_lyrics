#!/usr/bin/ruby

require 'open-uri'

open("http://www.ruby-lang.org/") {|f|
	f.each_line {|line| p line}
}
