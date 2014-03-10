#!/usr/bin/env ruby
require 'fileutils'

# xcode base template
SOURCE = "source_template"
VERBOSE = false

@owner = ARGV[0]
@author = ARGV[1]

# checking arguments
if @owner.nil? or @author.nil?
	puts "Usage: ruby gen_template.rb Owner Author"
end

puts "################################################"
puts "Creating Xcode template for Owner: #{@owner} and Author: #{@author}"

# new xcode template location
gen_template = "#{@owner}_template"

#cleanup and generating new template
FileUtils.rmdir gen_template, :verbose => VERBOSE
FileUtils.cp_r "#{SOURCE}/.", gen_template, :verbose => VERBOSE

success = true
Dir.glob("#{gen_template}/**/*.{h,m,py,sh,exp}") do |source_file|
	cmd_owner = "perl -pi -w -e 's/#OWNER#/#{@owner}/g;' '#{source_file}'"
	success = system cmd_owner
	cmd_author = "perl -pi -w -e 's/#AUTHOR#/#{@author}/g;' '#{source_file}'"
	success = system cmd_author
end

if success
	puts "---"
	puts "New Xcode template generated at #{gen_template}"
	puts "---"
	puts "In order to install the template, you must copy" 
	puts " the template folder at ~/Library/Developer/Xcode/Templates/"
	puts " NOTE: you might have to create the 'Templates' folder"
	puts "################################################"
end
