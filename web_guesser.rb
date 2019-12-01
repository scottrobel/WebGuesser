# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

SECRET_NUMBER = rand(101)
TOO_HIGH = SECRET_NUMBER + 5
TOO_LOW = SECRET_NUMBER - 5
get '/' do
  guess = params["guess"]
  messege = check_guess(guess)
  erb :index, locals: { messege: messege }
end
def check_guess(guess)
  guess = guess.match(/(\d+)/)
  if !guess
    "Please enter a valid number"
  elsif guess[1].to_i > SECRET_NUMBER
    guess[1].to_i > TOO_HIGH ? "Guess way too High" : "Guess too High"
  elsif guess[1].to_i < SECRET_NUMBER
    guess[1].to_i < TOO_LOW ? "Guess way too Low" : "Guess too Low"
  elsif guess[1].to_i == SECRET_NUMBER
    "Guess Correct"
  end
end