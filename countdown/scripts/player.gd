extends CharacterBody2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CROUCH_FACTOR = 0.8
const WALL_JUMP_FACTOR = 0.7
const WALL_JUMP_SLIDE_FACTOR = 0.4
const CLOUD_RISE_SPEED = -16.0  # how fast the player floats upward in a cloud
var orig_scale: Vector2 = scale
@onready var animated_sprite_2d = $AnimatedSprite2D
#flags
var is_crouching = false
var shield = false
var in_cloud = false  # set/cleared by AntiGravityCloud
var score = 0

signal died

func _ready():
	add_to_group("players")

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false

	# Add the gravity.
	if in_cloud:
		velocity.y = -CLOUD_RISE_SPEED
	elif not is_on_floor():
		if is_on_wall():
			if velocity.y <= 0:
				velocity += get_gravity() * delta
			else:
				velocity += get_gravity() * delta * WALL_JUMP_SLIDE_FACTOR
		else:
			velocity += get_gravity() * delta

	if is_crouching:
		scale.y = orig_scale.y * CROUCH_FACTOR
	else:
		scale.y = orig_scale.y

	# Handle jump.
	var jumped_this_frame = false
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jumped_this_frame = true
			animated_sprite_2d.play("jump")
			if is_crouching:
				velocity.y = JUMP_VELOCITY * CROUCH_FACTOR
			else:
				velocity.y = JUMP_VELOCITY
		if is_on_wall():
			jumped_this_frame = true
			velocity.y = JUMP_VELOCITY * WALL_JUMP_FACTOR
			animated_sprite_2d.play("slide")

	#wall_jump
	if is_on_wall() and $WallJumpTimer.is_stopped():
		$WallJumpTimer.start()

	# Get the input direction and handle the movement/deceleration.
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor() and not jumped_this_frame and animated_sprite_2d.animation != "walk":
			animated_sprite_2d.play("walk")
	else:
		if is_on_floor() and not jumped_this_frame and animated_sprite_2d.animation != "idle":
			animated_sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#temporary animation fix
	if is_on_floor() and velocity.y == 0:
		if animated_sprite_2d.animation == "jump":
			animated_sprite_2d.stop()

	move_and_slide()

func take_damage():
	if shield:
		shield = false
		return
	animated_sprite_2d.play("dead")
	died.emit() 
	queue_free()

func _unhandled_input(event):
	if Input.is_action_just_pressed("crouch"):
		if !is_on_wall():
			is_crouching = true
	if Input.is_action_just_released("crouch"):
		is_crouching = false

func add_shield():
	shield = true

func add_score():
	score+=1
