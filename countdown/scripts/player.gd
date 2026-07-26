extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CROUCH_FACTOR = 0.8
const WALL_JUMP_FACTOR = 0.7
const WALL_JUMP_SLIDE_FACTOR = 0.4

var orig_scale: Vector2 = scale
@onready var animated_sprite_2d = $AnimatedSprite2D


#flags
var is_crouching = false

func _ready():
	add_to_group("players")
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if is_on_wall():
			if velocity.y <= 0:
				velocity += get_gravity() * delta
			else:
				velocity += get_gravity() * delta * WALL_JUMP_SLIDE_FACTOR
		else:
			velocity += get_gravity() * delta
	if is_crouching: #Temporary visual but will replace with animation and scale hitbox
		scale.y = orig_scale.y * CROUCH_FACTOR
	else:
		scale.y = orig_scale.y
	# Handle jump.
	if Input.is_action_just_pressed("up"):
		animated_sprite_2d.play("jump")
		if is_on_floor():
			if is_crouching:
				velocity.y = JUMP_VELOCITY * CROUCH_FACTOR
			else:
				velocity.y = JUMP_VELOCITY
		if is_on_wall():
			velocity.y = JUMP_VELOCITY * WALL_JUMP_FACTOR
	#wall_jump
	if is_on_wall() and $WallJumpTimer.is_stopped():
		$WallJumpTimer.start()
	
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		if !animated_sprite_2d.is_playing():
			animated_sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	#temporary animation fix
	if is_on_floor() and velocity.y == 0:
		if animated_sprite_2d.animation == "jump":
			animated_sprite_2d.stop()
	move_and_slide()

func take_damage():
	animated_sprite_2d.play("dead")
	queue_free() #temp

func _unhandled_input(event):
	if Input.is_action_just_pressed("crouch"):
		if !is_on_wall(): #check if causes issues later
			is_crouching = true
	if Input.is_action_just_released("crouch"):
		is_crouching = false
