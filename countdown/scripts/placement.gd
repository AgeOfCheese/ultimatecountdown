extends Node2D

const GRID_SIZE : int = 32
const GRID_WIDTH : int = 20   # number of columns to draw (adjust to your level size)
const GRID_HEIGHT : int = 15  # number of rows to draw

var current_object : int
var current_node : Node2D  # the instantiated object currently following the mouse

func _ready():
	get_next_object()

func get_next_object():
	if RoundManager.objects_to_place.is_empty():
		print("Placement Finished!")
		RoundManager.end_placement()
		return
	current_object = RoundManager.objects_to_place.pop_front()
	current_node = RoundManager.OBJECT_POOl.get(current_object).instantiate()
	add_child(current_node)
	current_node.global_position = get_snapped_mouse_pos()
	print("Now placing:", current_object)

func _process(_delta):
	if current_node:
		current_node.global_position = get_snapped_mouse_pos()

func get_snapped_mouse_pos() -> Vector2:
	var mouse_pos = get_global_mouse_position()
	return mouse_pos.snapped(Vector2(GRID_SIZE, GRID_SIZE))

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			place_object()

func place_object():
	if current_node == null:
		return

	var grid_pos = get_snapped_mouse_pos()
	RoundManager.add_object(str(current_object), grid_pos, current_node.rotation)

	print("Placed ", current_object, " at ", grid_pos)

	current_node.global_position = grid_pos
	current_node = null

	get_next_object()

func _draw():
	var color = Color(1, 1, 1, 0.2)  # light, semi-transparent grid lines

	# vertical lines
	for x in range(GRID_WIDTH + 1):
		var start = Vector2(x * GRID_SIZE, 0)
		var end = Vector2(x * GRID_SIZE, GRID_HEIGHT * GRID_SIZE)
		draw_line(start, end, color, 1.0)

	# horizontal lines
	for y in range(GRID_HEIGHT + 1):
		var start = Vector2(0, y * GRID_SIZE)
		var end = Vector2(GRID_WIDTH * GRID_SIZE, y * GRID_SIZE)
		draw_line(start, end, color, 1.0)
