class Player
	DANGER_HEALTH = 15
	MIN_HEALTH = 20
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
	# Defines if you can shoot in any direction without killing captives
	def clear_shot? warrior
		look = warrior.look :forward
		distance_to_enemy2 = look.index { |space| space.enemy? == true } || MAX_LOOK
		distance_to_captive2 = look.index { |space| space.captive? == true } || MAX_LOOK
		@direction = :forward if distance_to_enemy2 < distance_to_captive2
		look = warrior.look :backward
		distance_to_enemy = look.index { |space| space.enemy? == true } || MAX_LOOK
		distance_to_captive = look.index { |space| space.captive? == true } || MAX_LOOK
		@direction = :backward if distance_to_enemy < distance_to_captive
		!@took_damage && ((distance_to_enemy < distance_to_captive) || (distance_to_enemy2 < distance_to_captive2)) 
	end
end
