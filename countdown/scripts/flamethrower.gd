extends NumberedObject

@onready var animation_player = $AnimationPlayer
@onready var kill_timer = $KillTimer

var player_in_range: Node = null  # track which player is currently inside, so we know who to kill

func _ready():
	object_number = 3
	animation_player.play("flame")

func apply_effect(player):
	if player.is_in_group("players"):
		player_in_range = player
		kill_timer.start()

func _on_area_2d_body_entered(body):
	apply_effect(body)

func _on_area_2d_body_exited(body):
	if body == player_in_range:
		kill_timer.stop()
		player_in_range = null

func _on_kill_timer_timeout():
	if player_in_range:
		kill_player(player_in_range)

func kill_player(player):
	if player.has_method("take_damage"):
		player.take_damage()
