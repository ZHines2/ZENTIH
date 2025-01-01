# Brains.gd
extends Resource

enum State { IDLE, PATROL, CHASE, FLEE, LOOT, ATTACK, ALLY }

class AnimalBrain:
	var name: String
	var axiom: String
	var symbol: String
	var stats: Dictionary
	var position: Vector2

	func _init(_name: String, _axiom: String, _symbol: String, _stats: Dictionary):
		self.name = _name
		self.axiom = _axiom
		self.symbol = _symbol
		self.stats = _stats
		self.position = Vector2(int(randf_range(0, 100)), int(randf_range(0, 100)))  # Random initial position

	func __str__() -> String:
		return "%s (%s) with symbol %s at position (%d, %d)" % [self.name, self.axiom, self.symbol, self.position.x, self.position.y]

func get_entities():
	return [
		AnimalBrain.new("TortoiseBrain", "Patient", "🐢", {State.IDLE: 5, State.PATROL: 0, State.CHASE: 0, State.FLEE: 1, State.LOOT: 1, State.ATTACK: 1, State.ALLY: 2}),
		AnimalBrain.new("EagleBrain", "Majestic", "🦅", {State.IDLE: 0, State.PATROL: 6, State.CHASE: 2, State.FLEE: 1, State.LOOT: 0, State.ATTACK: 1, State.ALLY: 0}),
		AnimalBrain.new("LionBrain", "Regal", "🦁", {State.IDLE: 0, State.PATROL: 0, State.CHASE: 1, State.FLEE: 0, State.LOOT: 0, State.ATTACK: 2, State.ALLY: 7}),
		AnimalBrain.new("ElephantBrain", "Equanimous", "🐘", {State.IDLE: 2, State.PATROL: 1, State.CHASE: 0, State.FLEE: 0, State.LOOT: 0, State.ATTACK: 1, State.ALLY: 6}),
		AnimalBrain.new("WolfBrain", "Audacious", "🐺", {State.IDLE: 0, State.PATROL: 2, State.CHASE: 5, State.FLEE: 0, State.LOOT: 0, State.ATTACK: 3, State.ALLY: 0}),
		AnimalBrain.new("SnakeBrain", "Cunning", "🐍", {State.IDLE: 0, State.PATROL: 0, State.CHASE: 0, State.FLEE: 1, State.LOOT: 1, State.ATTACK: 7, State.ALLY: 1}),
		AnimalBrain.new("FoxBrain", "Clever", "🦊", {State.IDLE: 0, State.PATROL: 0, State.CHASE: 1, State.FLEE: 1, State.LOOT: 6, State.ATTACK: 1, State.ALLY: 1}),
		AnimalBrain.new("DolphinBrain", "Intelligent", "🐬", {State.IDLE: 1, State.PATROL: 1, State.CHASE: 0, State.FLEE: 0, State.LOOT: 0, State.ATTACK: 0, State.ALLY: 8}),
		AnimalBrain.new("CrowBrain", "Perceptive", "🦅", {State.IDLE: 0, State.PATROL: 6, State.CHASE: 1, State.FLEE: 1, State.LOOT: 1, State.ATTACK: 1, State.ALLY: 0}),
		AnimalBrain.new("AntBrain", "Industrious", "🐜", {State.IDLE: 6, State.PATROL: 1, State.CHASE: 0, State.FLEE: 0, State.LOOT: 0, State.ATTACK: 1, State.ALLY: 2}),
		AnimalBrain.new("OtterBrain", "Joyful", "🦦", {State.IDLE: 0, State.PATROL: 1, State.CHASE: 0, State.FLEE: 5, State.LOOT: 2, State.ATTACK: 0, State.ALLY: 2}),
		AnimalBrain.new("SpiderBrain", "Meticulous", "🕷️", {State.IDLE: 0, State.PATROL: 7, State.CHASE: 1, State.FLEE: 0, State.LOOT: 1, State.ATTACK: 1, State.ALLY: 0})
	]
