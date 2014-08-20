class Player
	def play_turn(warrior)
		if warrior.feel.empty?
			if (warrior.health < 15) 
				if (warrior.health >= @last_health)
					warrior.rest!
				else
					warrior.walk!
				end
			else
				warrior.walk!
			end
		else
			warrior.attack!
		end
		@last_health = warrior.health
	end
end
