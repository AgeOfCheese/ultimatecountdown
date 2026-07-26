extends Node2D

const GRID_SIZE : int = 14
const BUTTON_SIZE : int = 50
const TOP_BAR_HEIGHT : int = 60

var current_object : int = -1
var current_node : Node2D

var available_objects = [
	10,9,8,7,6,5,4,3,2,1,0
]


func _ready():
	pass


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

			# Check if clicking the top object bar
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

	current_object = available_objects[index]

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

	# Leave the object in the scene
	current_node = null
	current_object = -1



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

		draw_string(
			ThemeDB.fallback_font,
			rect.position + Vector2(18,35),
			str(available_objects[i]),
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			24
		)
