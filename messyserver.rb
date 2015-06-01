require "sinatra"
require "pry"

enable :sessions

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}


WINNING_COMBOS = { r: :s, p: :r, s: :p }
GAME_OPTIONS = [ :r, :p, :s ]

def cpu_output
  @cpu_output = GAME_OPTIONS.sample
end


def play_game
  # puts "ROUND #{@round} START! ".center(72)
  # puts "ROCK, PAPER, SCISSORS SAYS... SHOOT! "
  cpu_output
  # puts "===> #{@player_name} CHOSE #{RPS_CONVERTER[@player_input]}!"
  # puts "===> CPU CHOSE #{RPS_CONVERTER[@cpu_output]}!"
  game_logic
end

def game_logic
  if @player_input == @cpu_output
    puts "Round tied!"
  elsif WINNING_COMBOS[@player_input] == @cpu_output
    puts "#{@player_name} wins!"
    @player_score +=1
  else
    puts "CPU Wins!"
    @cpu_score += 1
  end
  scoreboard
end

def scoreboard
  @cpu_score
  @player_score
  round +=1
end

def declare_winner
  @cpu_score == 2 ? "CPU is Victorious!" : "Player is Victorious!"
end


################ OLD STUFF ####################
class RockPaperScissors
  attr_accessor :player_input, :cpu_output, :cpu, :player_score, :round
  WINNING_COMBOS = { r: :s, p: :r, s: :p }
  RPS_CONVERTER = { r: "ROCK", p: "PAPER", s: "SCISSORS" }
  GAME_OPTIONS = [ :r, :p, :s ]

  def initialize(player_name = "Player")
    @player_name = player_name
    @cpu_score = 0
    @player_score = 0
    @round = 1
  end

  def cpu_output
    @cpu_output = GAME_OPTIONS.sample
  end

  def player_input
    @player_input = gets.chomp.to_sym
    until GAME_OPTIONS.include?( @player_input )
      puts "Please input only 'r', 'p', 's'"
      player_input
    end
  end

  def game_start
    puts "ROCK, PAPER, SCISSORS: #{@player_name} VS CPU".center(72)
    puts "First player to win 2 rounds, wins the game!".center(72)
    puts "SELECT:\n'r' for ROCK\n'p' for PAPER\n's' for SCISSORS"
    play_game until ( @cpu_score == 2 || @player_score == 2 )
    puts declare_winner
  end

  def play_game
    puts "ROUND #{@round} START! ".center(72)
    puts "ROCK, PAPER, SCISSORS SAYS... SHOOT! "
    player_input
    cpu_output

    puts "===> #{@player_name} CHOSE #{RPS_CONVERTER[@player_input]}!"
    puts "===> CPU CHOSE #{RPS_CONVERTER[@cpu_output]}!"
    game_logic
  end

  def game_logic
    if @player_input == @cpu_output
      puts "Round tied!"
    elsif WINNING_COMBOS[@player_input] == @cpu_output
      puts "#{@player_name} wins!"
      @player_score +=1
    else
      puts "CPU Wins!"
      @cpu_score += 1
    end
    scoreboard
  end

  def scoreboard
    puts "\n Score: CPU #{@cpu_score} - #{@player_name} #{player_score}"
    puts "------------------------------------------------------------------------\n"
    @round += 1
  end

  def declare_winner
    @cpu_score == 2 ? "CPU is Victorious!" : "Player is Victorious!"
  end

end

get "/" do
  redirect "/mmorps"
end

get "/mmorps" do
  erb :index
end

post "/mmorps" do
  binding.pry
end

# dave = RockPaperScissors.new("ZAC")
# dave.game_start
