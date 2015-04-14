require 'asciidoctor'  
require 'asciidoctor-diagram'
require 'erb'  
      
# 'unsafe' designation is equivalent to executing  
#  asciidoctor from the command line  
guard 'shell' do  
  watch(/^.*\.adoc$/)
  watch(/^.*\.asciidoc$/) {|m|  
    Asciidoctor.render_file(m[0], :in_place => true,  
            :safe => 'unsafe')  
  }  
end  
