require_relative '../db/setup'
require_relative '../lib/pig'
require_relative '../lib/hog'
require_relative '../lib/leaderboard'

def select_from(hash)
  loop do
    hash.each do |key, value|
      puts "#{key}) #{value}"
    end
    print "? > "
    input = gets.chomp
    found = hash.find { |k,v| k.to_s == input || v.to_s == input }
    if found
      return found.last
    else
      puts "Invalid selection: #{input}. Please try again."
    end
  end
end

#Pig and Hog are class constants
game_classes = {
  1 => Pig,
  2 => Hog
}

game_class = select_from(game_classes)

puts "Playing a game of #{game_class}"
game = game_class.new
#       ^ game class is either Pig or Hog. The constant of a class can be assigned to a local variable and be used like any other local variable

game.get_players

game.play_round until winner_name = game.winner
puts "#{winner_name} wins!"
puts Leaderboard.find_by(player_name: winner_name).inspect
