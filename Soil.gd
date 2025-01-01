extends Node

# Map dimensions
var map_width = 100
var map_height = 100

# Viewport dimensions
var viewport_width = 40
var viewport_height = 20

# Textures
var soil_texture = "▒"
var player_texture = "𐍈"  # Rare Unicode for the player

# Player state
var player_position = Vector2(50, 50)  # Centered in the larger map
var steps_taken = 0

# Track visited tiles
var visited_tiles = []

# Unicode symbols for stats
var steps_symbol = "→"  # Represents steps
var coords_symbol = "𓀇"  # Rare glyph for coordinates

func _ready():
	render_viewport()

# Handle player movement
func _input(event):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
	elif Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)

	if direction != Vector2.ZERO:
		move_player(direction)

# Move the player and update the state
func move_player(direction):
	var new_position = player_position + direction
	# Ensure the new position is within map bounds
	if new_position.x >= 0 and new_position.x < map_width and new_position.y >= 0 and new_position.y < map_height:
		# Mark the current tile as visited before moving
		if player_position not in visited_tiles:
			visited_tiles.append(player_position)
		player_position = new_position
		steps_taken += 1
		render_viewport()

# Render the current viewport centered around the player
func render_viewport():
	# Calculate viewport bounds
	var viewport_start_x = max(0, player_position.x - viewport_width / 2)
	var viewport_start_y = max(0, player_position.y - viewport_height / 2)
	var viewport_end_x = min(map_width, viewport_start_x + viewport_width)
	var viewport_end_y = min(map_height, viewport_start_y + viewport_height)
	viewport_start_x = max(0, viewport_end_x - viewport_width)  # Adjust if near the edge
	viewport_start_y = max(0, viewport_end_y - viewport_height)

	# Render the viewport
	for y in range(viewport_start_y, viewport_end_y):
		var row = ""
		for x in range(viewport_start_x, viewport_end_x):
			var position = Vector2(x, y)
			if position == player_position:
				row += player_texture
			elif position in visited_tiles:
				row += soil_texture
			else:
				row += soil_texture

		# Add stats to the right of the current row
		var stats_row = ""
		if y == viewport_start_y:  # First row
			stats_row = "| %s %d " % [steps_symbol, steps_taken]  # Steps counter
		elif y == viewport_start_y + 1:  # Second row
			stats_row = "| %s (%03d, %03d) " % [coords_symbol, player_position.x, player_position.y]  # Padded Coordinates
		elif y == viewport_start_y + 2:  # Third row
			stats_row = "|" + "─".repeat(20) + "|"  # Horizontal divider

		# Align and pad the stats for a clean layout
		if stats_row != "":
			while len(stats_row) < 30:
				stats_row += " "

		# Combine the row and stats
		print(row + "  " + stats_row)

	# Add a clean footer below the map
	print(" ".repeat(viewport_width) + "|" + "═".repeat(30) + "|")
