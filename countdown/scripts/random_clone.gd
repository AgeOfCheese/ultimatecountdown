extends NumberedObject


var possible_objects = [
	0,1,2,3,4,5,6,8,9,10
]


var has_randomized: bool = false
var was_following_mouse: bool = true



func _ready():

	object_number = 7



func _process(_delta):

	if has_randomized:
		return


	# Placement.gd moves the object exactly onto the mouse
	var mouse_pos = get_global_mouse_position()


	# If the object is no longer following the mouse,
	# it means it was placed
	if was_following_mouse:

		if global_position.distance_to(mouse_pos) > 20:

			was_following_mouse = false

			activate_random_object()




func activate_random_object():

	if has_randomized:
		return

	has_randomized = true


	var random_number = possible_objects.pick_random()

	print("Random block became:", random_number)


	# Create the new object
	var new_object = RoundManager.OBJECT_POOl.get(
		random_number
	).instantiate()


	# Save this object's position
	var spawn_position = global_position


	# Add the new object where Object 7 was
	get_parent().add_child(new_object)

	new_object.global_position = spawn_position


	# Remove Object 7
	queue_free()
