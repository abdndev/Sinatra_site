require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new'barbershop.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS 
	"Users"
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"username" TEXT,
		"phone" TEXT,
		"datastamp" TEXT,
		"barber" TEXT,
		"color" TEXT
	)'
end

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
	@color = params[:color]

	# хеш
	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end
	
	@message = "<h2>Спасибо, уважаемый(ая) #{@username}, мы будем ждать Вас #{@datetime}.       Ваш парикмахер: #{@barber}. Мы окрасим вас в цвет #{@color}</h2>"
	f = File.open './public/users.txt', 'a'
	f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@datetime}, Master: #{@barber}, Color: #{@color}\n\n"
	f.close
	
	
	erb :visit

end

post '/contacts' do
   	@user_name = params[ :user_name]
	@email     = params[ :email]
	@textmessage = params[ :textmessage]
	
	
	#@title = 'Thank you!'
	@message1 = "<h2>Спасибо, уважаемый(ая) #{@user_name}, мы прочтем ваше сообщение так скоро как это только возможно</h2>"

	ff = File.open './public/contact-questions.txt', 'a'
	ff.write "User: #{@user_name}, Email: #{@email}, Message: #{@textmessage}"
	ff.close


	erb :contacts

end
