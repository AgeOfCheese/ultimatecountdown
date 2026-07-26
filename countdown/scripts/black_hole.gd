extends NumberedObject


var player_in_range: Node = null
var player_inside_area: bool = false


@export var pull_strength: float = 10.0




func _ready():

	object_number = 8




# Runs while object exists
func _process(_delta):

	if player_inside_area and player_in_range:

		print("Player is INSIDE black hole area")

		pull_player(player_in_range)




# Pull player toward the center of the black hole
func pull_player(player):

	# Vector from player to black hole center
	var direction = global_position - player.global_position


	# Normalize direction
	direction = direction.normalized()


	# Apply force toward black hole
	player.velocity += direction * pull_strength




# Player touches the actual black hole center
func _on_kill_body_entered(body):

	print("Something touched black hole center:", body)


	if body.is_in_group("players"):

		print("Player entered black hole!")

		kill_player(body)



func kill_player(player):

	if player.has_method("take_damage"):

		player.take_damage()




# Player enters black hole area
func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:

	print("Something entered black hole area:", body)


	if body.is_in_group("players"):

		player_in_range = body

		player_inside_area = true

		print("Player entered black hole area")




# Player exits black hole area
func _on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:

	print("Something exited black hole area:", body)


	if body == player_in_range:

		player_in_range = null

		player_inside_area = false

		print("Player left black hole area")
