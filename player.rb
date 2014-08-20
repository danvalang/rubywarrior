class Player
	DANGER_HEALTH = 7
	MIN_HEALTH = 15
	MAX_LOOK = 4
	def play_turn(warrior)
		# setup
		@last_health ||= warrior.health
		@took_damage = @last_health > warrior.health
		@direction ||= :forward
		# warrior possible actions
		if warrior.feel(@direction).empty?
			if clear_shot? warrior
				warrior.shoot!(@direction)
			elsif should_flee? warrior
				@direction = :backward
				warrior.walk! @direction
			elsif should_rest? warrior
				warrior.rest!
			else
				warrior.walk! @direction
			end
		elsif warrior.feel(@direction).captive?
			warrior.rescue!(@direction)
		elsif warrior.feel(@direction).wall?
			@direction = :forward
			warrior.pivot!
		else
			warrior.attack!(@direction)
		end
		@last_health = warrior.health
	end
	private
	# If warrior should rest
	def should_rest?(warrior)
		!@took_damage && warrior.health < MIN_HEALTH
	end
	# if warrior should flee
	def should_flee?(warrior)
		bad_health = warrior.health < DANGER_HEALTH
		@took_damage && bad_health
	end
	def clear_shot? warrior
		look = warrior.look @direction
		distance_to_enemy = look.index { |space| space.enemy? == true } || MAX_LOOK
		distance_to_captive = look.index { |space| space.captive? == true } || MAX_LOOK
		distance_to_enemy < distance_to_captive
		
	end
end
