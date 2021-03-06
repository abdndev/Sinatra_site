require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers 
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
	return SQLite3::Database.new'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	db.results_as_hash = true
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = SQLite3::Database.new'barbershop.db'
	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Users"
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"username" TEXT,
		"phone" TEXT,
		"datastamp" TEXT,
		"barber" TEXT,
		"color" TEXT
	)'

	db.execute 'CREATE TABLE IF NOT EXISTS 
	"Barbers"
	(
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"name" TEXT
	)'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ermantraut']
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
	
	# вывод данных записавшихся клиентов в базу данных
	db = get_db
	db.execute 'insert into Users (username, phone, datastamp, barber, color
	) values (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	
	# возможен вывод сообщения об успешной записи на страницу
	#@message = "<h2>Спасибо, уважаемый(ая) #{@username}, мы будем ждать Вас #{@datetime}. Ваш парикмахер: #{@barber}. Мы окрасим вас в цвет #{@color}</h2>"


	# вывод данных записавшихся клиентов в текстовый файл
	f = File.open './public/users.txt', 'a'
	f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@datetime}, Master: #{@barber}, Color: #{@color}\n\n"
	f.close
	
	# или вывод сообщения на пустой странице
	erb "<h2>Спасибо? вы записались!</h2>"
	
	#erb :visit

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


get '/showusers' do
	db = get_db
	db.results_as_hash = true
	@results = db.execute 'select * from Users order by id desc'

  	erb :showusers
end


