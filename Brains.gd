# Brains.gd
extends Resource

class_name EntityData

class AnimalBrain:
	var brain_name: String
	var axiom: String
	var symbol: String
	var stats: Dictionary
	var position: Vector2
	var state: String = "IDLE"  # Add state property

	func _init(_name: String, _axiom: String, _symbol: String, _stats: Dictionary):
		self.brain_name = _name
		self.axiom = _axiom
		self.symbol = _symbol
		self.stats = _stats
		self.position = Vector2(int(randf_range(0, 100)), int(randf_range(0, 100)))  # Random initial position

	func get_next_state() -> String:
		# Logic to determine the next state based on stats and current conditions
		var total_weight = 0
		for state in stats.keys():
			total_weight += stats[state]

		var random_choice = randi() % total_weight
		var cumulative_weight = 0
		for state in stats.keys():
			cumulative_weight += stats[state]
			if random_choice < cumulative_weight:
				return state
		return "IDLE"

	func perform_action(player_position: Vector2):
		# Define actions based on the current state
		var current_state = get_next_state()
		match current_state:
			"IDLE":
				idle()
			"PATROL":
				patrol()
			"CHASE":
				chase(player_position)
			"FLEE":
				flee(player_position)
			"LOOT":
				loot()
			"ATTACK":
				attack(player_position)
			"ALLY":
				ally()

	func idle():
		print("%s is idling." % brain_name)

	func patrol():
		print("%s is patrolling." % brain_name)

	func chase(_player_position: Vector2):
		print("%s is chasing." % brain_name)

	func flee(_player_position: Vector2):
		print("%s is fleeing." % brain_name)

	func loot():
		print("%s is looting." % brain_name)

	func attack(_player_position: Vector2):
		print("%s is attacking." % brain_name)

	func ally():
		print("%s is allying." % brain_name)

	func __str__() -> String:
		return "%s (%s) with symbol %s at position (%d, %d)" % [brain_name, axiom, symbol, position.x, position.y]

func get_entities():
	return [
		AnimalBrain.new("TortoiseBrain", "Patient", "🐢", {"IDLE": 5, "PATROL": 0, "CHASE": 0, "FLEE": 1, "LOOT": 1, "ATTACK": 1, "ALLY": 2}),
		AnimalBrain.new("EagleBrain", "Majestic", "🦅", {"IDLE": 0, "PATROL": 6, "CHASE": 2, "FLEE": 1, "LOOT": 0, "ATTACK": 1, "ALLY": 0}),
		AnimalBrain.new("LionBrain", "Regal", "🦁", {"IDLE": 0, "PATROL": 0, "CHASE": 1, "FLEE": 0, "LOOT": 0, "ATTACK": 2, "ALLY": 7}),
		AnimalBrain.new("ElephantBrain", "Equanimous", "🐘", {"IDLE": 2, "PATROL": 1, "CHASE": 0, "FLEE": 0, "LOOT": 0, "ATTACK": 1, "ALLY": 6}),
		AnimalBrain.new("WolfBrain", "Audacious", "🐺", {"IDLE": 0, "PATROL": 2, "CHASE": 5, "FLEE": 0, "LOOT": 0, "ATTACK": 3, "ALLY": 0}),
		AnimalBrain.new("SnakeBrain", "Cunning", "🐍", {"IDLE": 0, "PATROL": 0, "CHASE": 0, "FLEE": 1, "LOOT": 1, "ATTACK": 7, "ALLY": 1}),
		AnimalBrain.new("FoxBrain", "Clever", "🦊", {"IDLE": 0, "PATROL": 0, "CHASE": 1, "FLEE": 1, "LOOT": 6, "ATTACK": 1, "ALLY": 1}),
		AnimalBrain.new("DolphinBrain", "Intelligent", "🐬", {"IDLE": 1, "PATROL": 1, "CHASE": 0, "FLEE": 0, "LOOT": 0, "ATTACK": 0, "ALLY": 8}),
		AnimalBrain.new("CrowBrain", "Perceptive", "🦅", {"IDLE": 0, "PATROL": 6, "CHASE": 1, "FLEE": 1, "LOOT": 1, "ATTACK": 1, "ALLY": 0}),
		AnimalBrain.new("AntBrain", "Industrious", "🐜", {"IDLE": 6, "PATROL": 1, "CHASE": 0, "FLEE": 0, "LOOT": 0, "ATTACK": 1, "ALLY": 2}),
		AnimalBrain.new("OtterBrain", "Joyful", "🦦", {"IDLE": 0, "PATROL": 1, "CHASE": 0, "FLEE": 5, "LOOT": 2, "ATTACK": 0, "ALLY": 2}),
		AnimalBrain.new("SpiderBrain", "Meticulous", "🕷️", {"IDLE": 0, "PATROL": 7, "CHASE": 1, "FLEE": 0, "LOOT": 1, "ATTACK": 1, "ALLY": 0}),
	]
