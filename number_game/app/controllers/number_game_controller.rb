class NumberGameController < ApplicationController
	@@counter = 0
	def index
		# If a random number is not yet present, generate by calling the private function: generate_random_number
		generate_random_number if !session[:random].present?
		if session[:status] == nil
			@div_color = "new_game"
		elsif session[:status] == true
			@div_color = "correct_guess"
		elsif session[:status] == false
			@div_color = "wrong_guess"
		end

		@counter = @@counter
		@rand_num = session[:random]
		if @rand_num%2 == 0
			flash[:hint] ="even"
		else
			flash[:hint] ="odd"
		end

		puts "Fetching guess database..."
		puts session[:status]
		@fetch_guess = Guess.all.order(id: :desc)
		puts "Loading INDEX page..."
		render "index"
	end

	def new_game
		puts "Deleting all user guesses.."
		Guess.destroy_all
		session[:status] = nil
		@@counter = 0
		session.clear
		redirect_to "/"
	end

	def guess
		@@counter += 1 
		puts "Adding user guess to database..."
		@guess_db = Guess.create(user_guess: params[:user_guess])
		puts "Comparing user guess to number..."
		if (params[:user_guess].to_i == session[:random])
			flash[:guess_result] = "You guessed correctly! The number was %s" % [session[:random]]
			session[:status] = true
		elsif (params[:user_guess].to_i > session[:random])
			flash[:guess_result] = "Your guess was high, guess again..."
			session[:status] = false
		elsif (params[:user_guess].to_i < session[:random])
			flash[:guess_result] = "Your guess was low, guess again..."
			session[:status] = false
		end
		puts "Redirecting to INDEX page..."
		redirect_to "/"
	end

	private
	# Generate random number from 1 - 100
	def generate_random_number
		puts "Generating random number..."
		session[:random] = rand(1..100)
		puts session[:random]
	end
end
