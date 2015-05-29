require_relative '../db/setup'
require_relative '../lib/pig'
require_relative '../lib/hog'
require_relative '../lib/leaderboard'
require_relative '../lib/save'

class Play_game
  attr_reader :current_game
  def play!
    begin
          #Pig and Hog are class constants
      game_classes = {
        1 => Pig,
        2 => Hog
      }

      disp_header
      game_class = select_from(game_classes)

      puts "Playing a game of #{game_class}"
      @current_game = game_class.new
      #       ^ game class is either Pig or Hog. The constant of a class can be assigned to a local variable and be used like any other local variable

      @current_game.get_players

      @current_game.play_round until winner_name = @current_game.winner

      puts "#{winner_name} wins!"
      update_records(winner_name)
      print "play again (y/n)? > "
      exit unless gets.chomp.upcase == "Y"
      rescue Interrupt
        save_and_exit
    end
  end

  def save_and_exit
      puts "\ngame saved!"
      players_state = @current_game.players
      player_names_joined = ""
      player_scores_joined = ""
      players_state.each do |player|
        player_names_joined += player.name + "||"
        player_scores_joined += player.score.to_s + "||"
      end
      Save.create(player_names: player_names_joined, player_scores: player_scores_joined, game_mode: "#{players_state.class}")
      exit
  end

  def select_from(hash)
    puts "0) Display Leaderboard"
    loop do
      hash.each do |key, value|
        puts "#{key}) #{value}"
      end
      print "? > "
      input = gets.chomp
      if input.to_i == 0
        disp_leaderboard
        select_from(hash)
      end
      found = hash.find { |k,v| k.to_s == input || v.to_s == input }
      if found
        return found.last
      else
        puts "Invalid selection: #{input}. Please try again."
      end
    end
  end

  def disp_leaderboard
    disp_header
    pig_hog_disp = get_leaders_disp

    pad_pig = pig_hog_disp[0][0].size - 6
    pad_hog = pig_hog_disp[0][1].size - 12
    pad = ' ' * (((pad_pig + pad_hog) - '  |__|   \\___/ |__|       |__| |____||___,_| \\___|'.size)/ 2)

    puts center_message('', '_') +
"""
#{pad} ______   ___   ____       ____ ____   ____  _____
#{pad}|      | /   \\ |    \\     |    \\    | /    |/ ___/
#{pad}|      ||     ||  o  )    |  o  )  | |   __(   \\_
#{pad}|_|  |_||  O  ||   _/     |   _/|  | |  |  |\\__  |
#{pad}  |  |  |     ||  |       |  |  |  | |  |_ |/  \\ |
#{pad}  |  |  |     ||  |       |  |  |  | |     |\\    |
#{pad}  |__|   \\___/ |__|       |__| |____||___,_| \\___|
"""

    puts " " * ((pad_pig - 3) / 2) + "Pig" + " " * (pad_pig - (" " * ((pad_pig - 3) / 2) + "Pig").size) + " " * ((pad_hog - 3) / 2) + "Hog"
    puts " " * ((pad_pig - 3) / 2) + "¯¯¯" + " " * (pad_pig - (" " * ((pad_pig - 3) / 2) + "¯¯¯").size) + " " * ((pad_hog - 3) / 2) + "¯¯¯"
    puts " " * @pad0[0] + "wins" + " " * (@pad1[0] + 2) + "w/l" + " " * (pad_pig - (" " * @pad0[0] + "wins" + " " * (@pad1[0] + 1) + "w/l").size + 5) + " " * (@pad0[1]) + "wins" + " " * (@pad1[1] + 2) + "w/l"
    puts " " * @pad0[0] + "¯¯¯¯" + " " * (@pad1[0] + 2) + "¯¯¯" + " " * (pad_pig - (" " * @pad0[0] + "¯¯¯¯" + " " * (@pad1[0] + 1) + "¯¯¯").size + 5) + " " * (@pad0[1]) + "¯¯¯¯" + " " * (@pad1[1] + 2) + "¯¯¯"
    pig_hog_disp[0].each.with_index { |x, ind| puts pig_hog_disp[0][ind] + pig_hog_disp[1][ind] }
    puts center_message('', '_')
    puts " "
  end

  def get_leaders_disp
    rank_shown = 5
    top_pigs = Leaderboard.where(game_mode: 'Pig').order(num_wins: :desc).first(rank_shown)
    top_hogs = Leaderboard.where(game_mode: 'Hog').order(num_wins: :desc).first(rank_shown)
    top_pigs_and_hogs = [top_pigs, top_hogs]
    pig_hog_disp = [[],[]]
    @pad0 = []
    @pad1 = []

    top_pigs_and_hogs.each.with_index do |top_pigs_or_hogs, ind|
      player_names = []
      size_player_names = []
      num_wins = []
      size_num_wins = []
      win_lose = []
      size_win_lose = []
      pad1 = {}
      pad2 = {}
      pad3 = {}

      top_pigs_or_hogs.each.with_index do |top_pig, rank|
        player_names << top_pig.player_name
        size_player_names << top_pig.player_name.size
        num_wins << top_pig.num_wins
        size_num_wins << top_pig.num_wins.to_s.size
        win_lose << (top_pig.num_wins.to_f * 100 / top_pig.num_played.to_f).round(2)
        size_win_lose << win_lose[rank].to_s.size
      end

      space = 6
      (0...rank_shown).to_a.map! do |rank|
        pad1[rank] = " " * (size_player_names.max - size_player_names[rank] + space)
        pad2[rank] = " " * (size_num_wins.max - size_num_wins[rank] + space)
        pad3[rank] = " " * (size_win_lose.max - size_win_lose[rank] + space)
      end
        @pad0 << 3 + size_player_names.max + space
        @pad1 << size_num_wins.max

      top_pigs_or_hogs.each.with_index do |top_pig, rank|
        pig_hog_disp[ind] << "#{rank + 1}) #{top_pig.player_name}#{pad1[rank]}#{top_pig.num_wins}#{pad2[rank]}#{win_lose[rank]} %#{pad3[rank]}|     "
      end
    end
    pig_hog_disp
  end

  def disp_header
    system('clear')
    pad = ' ' * ((`tput cols`.chomp.to_i - ' ____  __  ___ '.size)/ 2)
    puts ''
    puts center_message('Welcome to...', ' ')
    puts '' +
"""
#{pad} ____  __  ___
#{pad}(  _ \\(  )/ __)
#{pad} ) __/ )(( (_ \\
#{pad}(__)  (__)\\___/
"""
  end

  def center_message(message,pad_char)
    width = `tput cols`.chomp.to_i
    padding = width / 2 -  (message.length / 2)
    if message.length.even?
      pad_char * padding + message + pad_char * padding
    else
      pad_char * padding + message + pad_char * (padding - 1)
    end
  end

  def update_records(winner_name)
    winner_lb_entry = Leaderboard.find_by(player_name: winner_name, game_mode: "#{@current_game.class}")
    winner_lb_entry.num_wins += 1
    winner_lb_entry.save
    @current_game.players_all.each do |player|
      entry = Leaderboard.find_by(player_name: player.name, game_mode: "#{@current_game.class}")
      entry.num_played += 1
      entry.save
    end
  end
end






play_game = Play_game.new.play!










