# ZENITH.gd
extends Node

# Reference to the screen script
@onready var screen = preload("res://Screen.gd").new()
@onready var time = preload("res://Time.gd").new()

func _ready():
	add_child(screen)
	add_child(time)
	screen.initialize_screen()
	time.connect("tick_updated", Callable(self, "_on_tick_updated"))

# Handle player movement and ticks
func _input(event):
	var direction = Vector2.ZERO

	if event.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
	elif event.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
	elif event.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
	elif event.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
	elif event.is_action_pressed("ui_accept"):  # Space key for ticking forward
		time.tick()
		return

	if direction != Vector2.ZERO:
		move_player(direction)

# Move the player and update the state
func move_player(direction):
	var new_position = screen.player_position + direction
	if new_position.x >= 0 and new_position.x < screen.map_width and new_position.y >= 0 and new_position.y < screen.map_height:
		for brain in screen.animal_brains:
			if brain.position == new_position:
				screen.collected_animals.append(brain)
				screen.animal_brains.erase(brain)
				screen.update_collected_animal_info(brain)
				break
		if screen.player_position not in screen.visited_tiles:
			screen.visited_tiles.append(screen.player_position)
		screen.player_position = new_position
		screen.steps_taken += 1
		
		# Update state and perform actions for each animal brain when the player moves
		time.tick()

# Handle tick updates
func _on_tick_updated(ticks, cycles, symbol):
	print("Tick Updated: %d, Cycle: %d, Symbol: %s" % [ticks, cycles, symbol])

	# Update state and perform actions for each animal brain
	for brain in screen.animal_brains:
		brain.state = brain.get_next_state()
		brain.perform_action(screen.player_position)
	
	# Render the updated viewport
	screen.cycles = cycles
	screen.ticks = ticks
	screen.render_viewport()
