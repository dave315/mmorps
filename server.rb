require "sinatra"
require "pry"

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
    return "Round Winner! Round tied!"
  elsif WINNING_COMBOS[player_choice] == cpu_choice
    session[:player_score] += 1
    session[:winner] = "Player"
    return "Player Wins! Player threw: #{player_choice} CPU threw: #{cpu_choice}"
  else
    session[:computer_score] += 1
    session[:winner] = "Computer"
    return "Computer Winner! Player threw: #{player_choice} CPU threw: #{cpu_choice}"
  end
end

def game_winner
  if session[:player_score] == 2
    session[:player_score] = 0
    session[:computer_score] = 0
    session[:winner] = nil
    return "Game over - Player Wins"
  elsif session[:computer_score] == 2
    session[:player_score] = 0
    session[:computer_score] = 0
    session[:winner] = nil
    return "Game over - Computer wins"
  else
    return "First to 2 wins!"
  end
end

get "/" do
  redirect "/mmorps"
end

get "/mmorps" do
  if session[:player_score].nil? || session[:computer_score].nil? || session[:winner].nil?
    session[:player_score] = 0
    session[:computer_score] = 0
    session[:winner] = nil
    session[:player_choice] = nil
    session[:cpu_output] = nil
  else
    game_summary = "CPU threw: #{session[:cpu_output]} - Player threw: #{session[:player_choice]} --> \n Round winner: #{session[:winner]}"
  end

  erb :index, locals: { game_summary: game_summary }
end

post "/mmorps" do
  session[:player_choice] = params[:player_choice]

  round_winner(session[:player_choice], cpu_output)
  # puts results
  # if results == "Player Wins!"
  #   session[:player_score] += 1
  # elsif results == "Computer Winner!"
  #   session[:computer_score] += 1
  # end

  redirect "/mmorps"
end
