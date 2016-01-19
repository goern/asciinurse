require 'sinatra'
require 'haml'
require 'asciidoctor'
require 'git'

set :bind, '0.0.0.0'
set :port, 8080
set :haml, :format => :html5

before do
  @dir = Dir.mktmpdir
end

def render_repository(branch = 'master', file = 'README.asciidoc')
  Dir.chdir @dir

  g = Git.open(@dir, :log => Logger.new(STDOUT))
  g.branch(branch).checkout

  Asciidoctor.render_file(file,
                            :in_place => true,
                            :header_footer => true,
                            :safe => 'unsafe')
end

get '/' do
  haml :index
end

get '/:user/:repo/*.png' do
  filename = "#{@dir}/#{params[:splat].first}"

  print filename

  if File.exist?(filename)
    send_file :"#{viewname}"
  else
    status 404
    "File not found - #{filename}"
  end
end

get '/:user/:repo/:filename' do
  # clone the github repository
  g = Git.init @dir
  g.config('user.name', 'default')
  g.config('user.email', 'clone-user@example.com')
  # g.checkout('master')

  g.add_remote('upstream', "https://github.com/#{params['user']}/#{params['repo']}.git")
  g.remote('upstream').fetch
  g.remote('upstream').merge('master')

  # check if filename ends with .adoc or .asciidoc

  # render what we got
  if params['branch'].nil?
    render_repository(params['filename'])
  else # if no brnach given, use master
    render_repository(params['branch'], params['filename'])
  end

  # send back the generated html5
  send_file params['filename'].gsub(/adoc/, 'html').gsub(/asciidoc/, 'html')

  #  `rm -rf ` + @dir
end
