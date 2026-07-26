extends CharacterBody2D
signal died
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CROUCH_FACTOR = 0.8
const WALL_JUMP_FACTOR = 0.7
const WALL_JUMP_SLIDE_FACTOR = 0.4
const CLOUD_RISE_SPEED = -16.0
const MAX_FALL_SPEED = 1200.0
var orig_scale: Vector2 = scale
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_sound = $JumpSound   # NEW
@onready var die_sound = $DieSound     # NEW
@onready var walk_sound = $WalkSound   # NEW
var is_crouching = false
var shield = false
var in_cloud = false

func _ready():
	add_to_group("players")

func _physics_process(delta: float) -> void:
	if shield:
		$GPUParticles2D.show()
	else:
		$GPUParticles2D.hide()
	var direction := Input.get_axis("left", "right")
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false
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
	if velocity.y > MAX_FALL_SPEED:
		take_damage()
		return
	if is_crouching:
		scale.y = orig_scale.y * CROUCH_FACTOR
	else:
		scale.y = orig_scale.y
	var jumped_this_frame = false
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			jumped_this_frame = true
			animated_sprite_2d.play("jump")
			jump_sound.play()  # NEW
			if is_crouching:
				velocity.y = JUMP_VELOCITY * CROUCH_FACTOR
			else:
				velocity.y = JUMP_VELOCITY
		if is_on_wall():
			jumped_this_frame = true
			velocity.y = JUMP_VELOCITY * WALL_JUMP_FACTOR
			animated_sprite_2d.play("slide")
			jump_sound.play()  # NEW — wall jump counts as a jump too
	if is_on_wall() and $WallJumpTimer.is_stopped():
		$WallJumpTimer.start()
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor() and not jumped_this_frame and animated_sprite_2d.animation != "walk":
			animated_sprite_2d.play("walk")
		if is_on_floor() and not jumped_this_frame and not walk_sound.playing:  # NEW
			walk_sound.play()
	else:
		if is_on_floor() and not jumped_this_frame and animated_sprite_2d.animation != "idle":
			animated_sprite_2d.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		walk_sound.stop()  # NEW — stop footsteps immediately when input releases
	if is_on_floor() and velocity.y == 0:
		if animated_sprite_2d.animation == "jump":
			animated_sprite_2d.stop()
	move_and_slide()

func take_damage():
	if shield:
		shield = false
		return
	
	set_physics_process(false)
	animated_sprite_2d.play("dead")
	die_sound.play()  # NEW
	
	await get_tree().create_timer(2.0).timeout
	
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
