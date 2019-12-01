# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?

$secret_number = rand(101)
$too_high = $secret_number + 5
$too_low = $secret_number - 5
$guesses_left = 5
$guesses = []
$guess_messege_pairs = {}

get '/' do
  reset_guesses
  guess = params["guess"]
  cheat_toggle = params["cheat"]
  messege = "Please enter a valid number between 0 and 100."
  erb :index, locals: { messege: messege, guesses_left: $guesses_left, cheat_mode: cheat_toggle, secret_number: $secret_number, guess_messege_pairs: $guess_messege_pairs }
end

post '/' do
  guess = params["guess"]
  cheat_toggle = params["cheat"]
  messege = check_guess(guess)
  $guess_messege_pairs[guess.match(/(\d+)/)[1]] = messege if messege.match?(/(High|Low)/)
  erb :index, locals: { messege: messege, guesses_left: $guesses_left, cheat_mode: cheat_toggle, secret_number: $secret_number, guess_messege_pairs: $guess_messege_pairs }
end

def check_guess(guess)
  guess = guess.match(/(\d+)/) unless guess.nil?
  return "Please enter a valid number" if guess.nil?
  guess = guess[1]
  return "You already guessed that number" if $guesses.include? guess

  $guesses << guess
  $guesses_left -= 1
  valid_guess(guess)
end

def valid_guess(guess)
  if guess.to_i == $secret_number
    reset_guesses
    "Guess Correct! secret number has been reset"
  elsif $guesses_left == 0
    number = $secret_number
    reset_guesses
    "Out of guesses number has been reset.\nThe number was #{number}"
  elsif guess.to_i > $secret_number
    guess.to_i > $too_high ? "Guess way too High" : "Guess too High"
  elsif guess.to_i < $secret_number
    guess.to_i < $too_low ? "Guess way too Low" : "Guess too Low"
  end
end

def reset_guesses
  $guesses_left = 5
  $secret_number = rand(101)
  $too_high = $secret_number + 5
  $too_low = $secret_number - 5
  $guesses = []
  $guess_messege_pairs = {}
end