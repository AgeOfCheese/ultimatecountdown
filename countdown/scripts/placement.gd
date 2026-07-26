extends Node2D

var current_object : int

func _ready():

	get_next_object()
	
func get_next_object():

	if RoundManager.objects_to_place.is_empty():

		print("Placement Finished!")
		RoundManager.end_placement()
		return

	current_object = RoundManager.objects_to_place.pop_front()

	print("Now placing:", current_object)

func _unhandled_input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				place_object()

func place_object():

	var mouse_pos = get_global_mouse_position()

	mouse_pos = mouse_pos.snapped(Vector2(32,32))

	RoundManager.level_objects.append(
		{
			"number": current_object,
			"position": mouse_pos
		}
	)

	print(
		"Placed ",
		current_object,
		" at ",
		mouse_pos
	)

	get_next_object()
