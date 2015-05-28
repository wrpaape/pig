require_relative './player'

class Pig
  attr_reader :players

  def initialize
    @players   = []
    @max_score = 10
    @leaderboard = Leaderboard.new
  end

  def get_players
    puts "Getting player names. Type q when done."
    loop do
      print "Player #{@players.count + 1}, what is your name? > "
      input = gets.chomp
      if input == "q" || input == ""
        return
      else
        @players.push Player.new(input)
        unless Leaderboard.find_by(player_name: input, game_mode: "#{self.class}")
            Leaderboard.create(player_name: input, game_mode: "#{self.class}", num_played: 0, num_wins: 0)
            puts "created new entry!"
        end
      end
    end
  end

  def play_round
    @players.each do |p|
      puts "\n\nIt is #{p.name}'s turn! You have #{p.score} points. (Press ENTER)"
      gets
      take_turn p
    end
    remove_losing_players!
  end

  def remove_losing_players!
    if @players.any? { |p| p.score > @max_score }
      max_score = @players.map { |p| p.score }.max
      @players = @players.select { |p| p.score == max_score }
    end
  end

  def winner
    if @players.length == 1
      winning_player = @players.first
      winner_lb_entry = Leaderboard.find_by(player_name: winning_player.name, game_mode: "#{self.class}")
      winner_lb_entry.num_wins += 1
      winner_lb_entry.save
      winning_player.name
    end
  end

  def take_turn player
    turn_total = 0
    loop do
      roll = rand 1..6
      if roll == 1
        puts "You rolled a 1. No points for you!"
        return
      else
        turn_total += roll
        puts "You rolled a #{roll}. Turn total is #{turn_total}. Again?"
        if gets.chomp.downcase == "n"
          puts "Stopping with #{turn_total} for the turn."
          player.score += turn_total
          return
        end
      end
    end
  end
end
