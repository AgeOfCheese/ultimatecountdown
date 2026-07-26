extends Control

@onready var start_button = $VBoxContainer/Control2/TextureButton
@onready var options_button = $VBoxContainer/Control3/TextureButton
@onready var tutorial_button = $VBoxContainer/Control4/TextureButton
@onready var quit_button = $VBoxContainer/Control5/TextureButton

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	tutorial_button.pressed.connect(_on_tutorial_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().call_deferred("change_scene_to_file", RoundManager.PLACEMENT_SCENE_PATH)

func _on_options_pressed():
	print("Options menu not implemented yet")
	# TODO: change_scene_to_file to an options scene once it exists

func _on_tutorial_pressed():
	print("Tutorial not implemented yet")
	# TODO: change_scene_to_file to a tutorial scene once it exists

func _on_quit_pressed():
	get_tree().quit()
