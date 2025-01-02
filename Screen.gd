# Screen.gd
extends Node

# Variables to store viewport dimensions and game data
var map_width = 100
var map_height = 100
var viewport_width = 40
var viewport_height = 20
var steps_symbol = "→"
var coords_symbol = "𓀇"
var player_texture = "𐍈"
var gradient_chars = ["░", "▒", "▓", "█", "▓", "▒", "░"]

var player_position = Vector2(50, 50)
var steps_taken = 0
var collected_animals = []
var visited_tiles = []
var animal_brains = []
var collected_animal_info = ""
var cycles = 0
var ticks = 0
var cycle_symbols = ["⨀", "⨁", "⨂", "⨃", "⨄", "⨅", "⨆", "⨇", "⨈", "⨉"]
var ticks_per_cycle = 100

# Initialize the screen
func initialize_screen():
	randomize()
	initialize_animal_brains()
	render_viewport()

# Initialize animal brains
func initialize_animal_brains():
	var entity_data = load("res://Brains.gd").new()
	animal_brains = entity_data.get_entities()

# Update collected animal info
func update_collected_animal_info(brain):
	collected_animal_info = "Collected: %s (%s)\nSymbol: %s" % [brain.brain_name, brain.axiom, brain.symbol]

# Render the current viewport centered around the player
func render_viewport():
	var viewport_start_x = max(0, player_position.x - viewport_width / 2)
	var viewport_start_y = max(0, player_position.y - viewport_height / 2)
	var viewport_end_x = min(map_width, viewport_start_x + viewport_width)
	var viewport_end_y = min(map_height, viewport_start_y + viewport_height)
	viewport_start_x = max(0, viewport_end_x - viewport_width)
	viewport_start_y = max(0, viewport_end_y - viewport_height)

	var output = ""
	var menu_output = ""

	for y in range(viewport_start_y, viewport_end_y):
		var row = ""
		for x in range(viewport_start_x, viewport_end_x):
			var position = Vector2(x, y)
			var symbol = get_gradient_char_for_position(position)
			if position == player_position:
				symbol = player_texture
			else:
				for brain in animal_brains:
					if position == brain.position:
						symbol = brain.symbol
						break
			row += symbol
		output += row

		menu_output = generate_menu_output(y - viewport_start_y)
		output += "  " + menu_output + "\n"

	output += generate_bottom_border()
	collected_animal_info = ""
	print(output)

# Get the appropriate gradient character for a given position
func get_gradient_char_for_position(_position: Vector2) -> String:
	var gradient_index = int(float(ticks) / float(ticks_per_cycle) * (gradient_chars.size() - 1))
	return gradient_chars[gradient_index]

# Generate menu output based on the row index
func generate_menu_output(row_index: int) -> String:
	match row_index:
		0:
			return "| %s %d " % [steps_symbol, steps_taken]
		1:
			return "| %s (%03d, %03d) " % [coords_symbol, player_position.x, player_position.y]
		2:
			return "| Collected Animals: %s " % get_collected_animals_symbols()
		3:
			return "| Cycle: %s Ticks: %d" % [cycle_symbols[cycles], ticks]
		4:
			return "|" + "─".repeat(20) + "|"
		5, 6, 7:
			var lines = collected_animal_info.split("\n")
			if row_index - 5 < len(lines):
				return "| %s" % lines[row_index - 5]
			else:
				return "|"
		_:
			return ""

# Generate a bottom border with a scrolling ASCII gradient
func generate_bottom_border() -> String:
	var total_chars = viewport_width
	var gradient_progress = float(ticks) / float(ticks_per_cycle)
	var gradient_length = int(gradient_progress * total_chars)
	var gradient = ""

	for i in range(total_chars):
		if i < gradient_length:
			gradient += gradient_chars[(i % gradient_chars.size())]
		else:
			gradient += " "

	return gradient

# Get collected animals symbols
func get_collected_animals_symbols() -> String:
	var symbols = ""
	for animal in collected_animals:
		symbols += animal.symbol
	return symbols
