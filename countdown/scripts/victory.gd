extends Control

@onready var texture_button = $MarginContainer2/TextureButton

const FADE_DURATION = 2.0  # seconds — adjust to taste
const FADE_DELAY = 5    # optional pause before it starts appearing
const MAIN_MENU_SCENE_PATH = "res://scenes/main.tscn"  # adjust path if different

func _ready():
	texture_button.modulate.a = 0.0
	texture_button.disabled = true

	texture_button.pressed.connect(_on_button_pressed)

	var tween = create_tween()
	tween.tween_interval(FADE_DELAY)
	tween.tween_property(texture_button, "modulate:a", 1.0, FADE_DURATION)
	tween.tween_callback(func(): texture_button.disabled = false)

func _on_button_pressed():
	get_tree().call_deferred("change_scene_to_file", MAIN_MENU_SCENE_PATH)

func _process(delta):
	pass
