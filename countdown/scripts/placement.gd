extends Node2D

const GRID_SIZE : int = 14
const BUTTON_SIZE : int = 50
const TOP_BAR_HEIGHT : int = 60

const SKIP_BUTTON_SIZE = Vector2(120, 50)
const SKIP_BUTTON_POSITION = Vector2(700, 5)


var current_object : int = -1
var current_node : Node2D


# Stores objects that have already been placed
var placed_objects = []


var available_objects = [
	10,9,8,7,6,5,4,3,2,1,0
]



func _ready():
	sync_with_round_manager()



func _process(_delta):

	if current_node:

		current_node.global_position = get_snapped_mouse_pos()



func get_snapped_mouse_pos() -> Vector2:

	var mouse_pos = get_global_mouse_position()

	return mouse_pos.snapped(
		Vector2(GRID_SIZE, GRID_SIZE)
	)



func _unhandled_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:


			var mouse_pos = event.position


			# Skip button
			if Rect2(
				SKIP_BUTTON_POSITION,
				SKIP_BUTTON_SIZE
			).has_point(mouse_pos):

				print("Skipping placement")


				# Delete held object if there is one
				if current_node:

					current_node.queue_free()

					current_node = null
					current_object = -1


				RoundManager.end_placement()

				return



			# Top object bar
			if mouse_pos.y < TOP_BAR_HEIGHT:

				select_object(mouse_pos)

			else:

				place_object()




func select_object(mouse_pos : Vector2):


	# Don't allow selecting another object while holding one
	if current_node:

		print("Already holding an object!")

		return



	var index = int(mouse_pos.x / BUTTON_SIZE)


	if index >= available_objects.size():

		return



	var selected_object = available_objects[index]



	# Don't allow selecting already placed objects
	if selected_object in placed_objects:

		print("Object already placed:", selected_object)

		return



	current_object = selected_object



	current_node = RoundManager.OBJECT_POOl.get(
		current_object
	).instantiate()



	add_child(current_node)



	current_node.global_position = get_snapped_mouse_pos()



	print("Selected object:", current_object)




func place_object():


	if current_node == null:

		return



	var grid_pos = get_snapped_mouse_pos()



	RoundManager.add_object(
		str(current_object),
		grid_pos,
		current_node.rotation
	)



	print(
		"Placed ",
		current_object,
		" at ",
		grid_pos
	)



	# Remember this object was placed
	placed_objects.append(current_object)



	current_node = null

	current_object = -1



	queue_redraw()



	# Start game after all objects are placed
	if placed_objects.size() == available_objects.size():

		print("All objects placed! Starting game...")

		RoundManager.end_placement()




func _draw():


	var color = Color(1, 1, 1, 0.2)


	var screen_size = get_viewport_rect().size



	# Grid
	for x in range(int(screen_size.x / GRID_SIZE) + 1):

		var start = Vector2(x * GRID_SIZE, TOP_BAR_HEIGHT)

		var end = Vector2(x * GRID_SIZE, screen_size.y)


		draw_line(
			start,
			end,
			color,
			1.0
		)



	for y in range(int(screen_size.y / GRID_SIZE) + 1):

		var start = Vector2(0, y * GRID_SIZE)

		var end = Vector2(screen_size.x, y * GRID_SIZE)


		draw_line(
			start,
			end,
			color,
			1.0
		)




	# Top object bar
	for i in range(available_objects.size()):


		var rect = Rect2(
			i * BUTTON_SIZE,
			0,
			BUTTON_SIZE,
			TOP_BAR_HEIGHT
		)



		draw_rect(
			rect,
			Color(0.2,0.2,0.2,0.8)
		)



		var text_color = Color.WHITE


		if available_objects[i] in placed_objects:

			text_color = Color.GREEN



		draw_string(
			ThemeDB.fallback_font,
			rect.position + Vector2(18,35),
			str(available_objects[i]),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24,
			text_color
		)



	# Skip button
	draw_rect(
		Rect2(
			SKIP_BUTTON_POSITION,
			SKIP_BUTTON_SIZE
		),
		Color(0.8,0.2,0.2,0.8)
	)



	draw_string(
		ThemeDB.fallback_font,
		SKIP_BUTTON_POSITION + Vector2(15,32),
		"SKIP",
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		24,
		Color.WHITE
	)
	
func sync_with_round_manager():
	placed_objects.clear()
	for object_data in RoundManager.level_objects:
		var id = int(object_data.get("id"))
		var pos = object_data.get("position")
		placed_objects.append(id)

		var scene = RoundManager.OBJECT_POOl.get(id)
		if scene == null:
			push_warning("No scene found in OBJECT_POOl for id: %s" % id)
			continue

		var node = scene.instantiate()
		add_child(node)
		node.global_position = pos
	queue_redraw()
