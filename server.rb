require "sinatra"
require "pry"
require 'sinatra/flash'

use Rack::Session::Cookie, {
  secret: "secret_cookie!"
}

GAME_OPTIONS = [ 'Rock', 'Paper', 'Scissors' ]
WINNING_COMBOS = { "Rock" => "Scissors", "Paper" => "Rock", "Scissors" => "Paper" }

def cpu_output
  session[:cpu_output] = GAME_OPTIONS.sample
end

def round_winner(player_choice, cpu_choice)
  if player_choice == cpu_choice
    session[:winner] = "Tie!"
  elsif WINNING_COMBOS[player_choice] == cpu_choice
    session[:player_score] += 1
    session[:winner] = "Player"
  else
    session[:computer_score] += 1
    session[:winner] = "Computer"
  end
end

def game_winner
  if session[:player_score] == 2
    session[:game_winner] = "Player"
    flash[:success] = "CONGRATULATIONS YOU WON! Go ahead, play again!"
    redirect "/play_again"
    return "Game over - Player Wins"
  elsif session[:computer_score] == 2
    session[:game_winner] = "Computer"
    flash[:warning] = "WOMP WOMP, You lost to the Computer!"
    redirect "/play_again"
    return "Game over - Computer wins"
  else
    return "First to 2 wins!"
  end
end

def reset
  session[:player_score] = 0
  session[:computer_score] = 0
  session[:winner] = nil
end


get "/" do
  redirect "/mmorps"
end

get "/mmorps" do
  if session[:player_score].nil? || session[:computer_score].nil? || session[:winner].nil?
    reset
  else
    game_summary = "CPU threw: #{session[:cpu_output]} - Player threw: #{session[:player_choice]} --> \n Round winner: #{session[:winner]}"
  end

  erb :index, locals: { game_summary: game_summary }
end

post "/mmorps" do
  session[:player_choice] = params[:player_choice]

  round_winner(session[:player_choice], cpu_output)

  redirect "/mmorps"
end

get "/play_again" do
  game_summary = "#{session[:game_winner]} WINS!!!!! CPU threw: #{session[:cpu_output]} - Player threw: #{session[:player_choice]} --> \n Round winner: #{session[:winner]}"
  erb :play_again, locals: { game_summary: game_summary }
end

post '/reset' do
  reset
  redirect '/mmorps'
end
