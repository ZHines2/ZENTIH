# ZENITH.gd
extends Node

# Reference to the screen script
@onready var screen = preload("res://Screen.gd").new()

func _ready():
	add_child(screen)  # Add the screen instance to the scene tree
	screen.initialize_screen()

# Handle player movement
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
		screen.render_viewport()

# Main game loop
func _process(delta):
	pass
