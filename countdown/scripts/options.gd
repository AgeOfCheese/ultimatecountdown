extends Control

@onready var fullscreen_button = $VBoxContainer/MarginContainer/HBoxContainer/TextureButton
@onready var mute_button = $VBoxContainer/MarginContainer2/HBoxContainer/TextureButton
@onready var menu_button = $VBoxContainer/MarginContainer3/TextureButton

const MAIN_MENU_SCENE_PATH = "res://scenes/main.tscn"  # adjust if your path differs

func _ready():
	# reflect current actual state on load, in case player already toggled these before
	fullscreen_button.button_pressed = (
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	)
	mute_button.button_pressed = AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))

	fullscreen_button.toggled.connect(_on_fullscreen_toggled)
	mute_button.toggled.connect(_on_mute_toggled)
	menu_button.pressed.connect(_on_menu_pressed)

func _on_fullscreen_toggled(is_pressed: bool):
	if is_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_mute_toggled(is_pressed: bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), is_pressed)

func _on_menu_pressed():
	get_tree().call_deferred("change_scene_to_file", MAIN_MENU_SCENE_PATH)

func _process(delta):
	pass
