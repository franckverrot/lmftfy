# We require the bundled gems
begin
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require "rubygems"
  require "bundler"
  Bundler.setup
end

# We require the application
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')

require 'lmftfy'
require 'sinatra'
require 'json'

get '/' do 
  @result = nil
  erb :index
end

post '/' do
  forker = Lmftfy::Forker.new params[:gh_login], params[:gh_password]
  begin
    @error = nil
    @result = JSON.parse(forker.fork(params[:gh_repo_owner], params[:gh_repo_name]))['repository']['url']
  rescue
    @error = "An error occured, please verify both your credentials and the repository you wanna fork"
  end
  erb :index
end
