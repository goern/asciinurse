require 'asciidoctor'  
require 'asciidoctor-diagram'
require 'erb'  
      
# 'unsafe' designation is equivalent to executing  
#  asciidoctor from the command line  
guard 'shell' do  
  watch(/^.*\.adoc$/)
  watch(/^.*\.asciidoc$/) { |m|
    Asciidoctor.render_file(m[0], :in_place => true,  
            :safe => 'unsafe')  
  }  

  callback(:start_begin) { 
    print "Am I supossed to generate a PDF now?!"
  }
end

guard 'livereload' do
  watch(%r{^.+\.(css|js|html)$})
end  
