require_relative './pig'

class Hog < Pig
  def take_turn player
    print "How many dice to roll? > "
    dice = gets.chomp.to_i
    rolls = []
    dice.times { rolls.push rand 1..6 }
    puts "You rolled: #{rolls.join ', '}"
    if rolls.include? 1
      puts "You rolled a 1. No points for you!"
    else
      rolls.each { |r| player.score += r }
      puts "Your total is now #{player.score}"
    end
  end
end
