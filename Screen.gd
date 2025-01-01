# Screen.gd
extends Node

# Variables to store viewport dimensions and game data
var map_width = 100
var map_height = 100
var viewport_width = 40
var viewport_height = 20
var steps_symbol = "→"
var coords_symbol = "𓀇"
var soil_texture = "▒"
var player_texture = "𐍈"

var player_position = Vector2(50, 50)
var steps_taken = 0
var collected_animals = []
var visited_tiles = []
var animal_brains = []
var collected_animal_info = ""

# Initialize the screen
func initialize_screen():
	randomize()
	initialize_animal_brains()
	render_viewport()

# Initialize animal brains
func initialize_animal_brains():
	var entity_data = preload("res://Brains.gd").new()
	animal_brains = entity_data.get_entities()

# Update collected animal info
func update_collected_animal_info(brain):
	collected_animal_info = "Collected: %s (%s)\nSymbol: %s" % [brain.name, brain.axiom, brain.symbol]

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
			var symbol = soil_texture
			if position == player_position:
				symbol = player_texture
			else:
				for brain in animal_brains:
					if position == brain.position:
						symbol = brain.symbol
						break
				if position in visited_tiles:
					symbol = soil_texture
			row += symbol
		output += row

		menu_output = ""
		if y - viewport_start_y == 0:
			menu_output = "| %s %d " % [steps_symbol, steps_taken]
		elif y - viewport_start_y == 1:
			menu_output = "| %s (%03d, %03d) " % [coords_symbol, player_position.x, player_position.y]
		elif y - viewport_start_y == 2:
			menu_output = "| Collected Animals: %s " % get_collected_animals_symbols()
		elif y - viewport_start_y == 3:
			menu_output = "|" + "─".repeat(20) + "|"
		elif y - viewport_start_y >= 4 and y - viewport_start_y < 7:
			var lines = collected_animal_info.split("\n")
			if y - viewport_start_y - 4 < len(lines):
				menu_output = "| %s" % lines[y - viewport_start_y - 4]
			else:
				menu_output = "|"

		output += "  " + menu_output + "\n"

	collected_animal_info = ""
	print(output)

# Get collected animals symbols
func get_collected_animals_symbols():
	var symbols = ""
	for animal in collected_animals:
		symbols += animal.symbol
	return symbols
