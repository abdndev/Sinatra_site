settings.default_encoding = 'UTF-8'

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
   	@username = params[ :username]
	@phone     = params[ :phone]
	@datetime = params[ :datetime]
	@barber = params[:barber]

	
	@message = "<h2>Thank you, dear #{@username}, we'll be waiting for you at #{@datetime}. Your barber is: #{@barber}</h2>"

	f = File.open './public/users.txt', 'a'
	f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@datetime}, Master: #{@barber}"
	f.close

	erb :visit

end

post '/contacts' do
   	@user_name = params[ :user_name]
	@email     = params[ :email]
	@textmessage = params[ :textmessage]
	
	
	#@title = 'Thank you!'
	@message1 = "<h2>Thank you, dear #{@user_name}, we'll read your message as soon as possible</h2>"

	ff = File.open './public/contact-questions.txt', 'a'
	ff.write "User: #{@user_name}, Email: #{@email}, Message: #{@textmessage}"
	ff.close


	erb :contacts

end
