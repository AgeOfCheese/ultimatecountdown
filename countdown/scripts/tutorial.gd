extends Control

@onready var menu_button = $CanvasLayer/ScrollContainer/BoxContainer/MarginContainer2/TextureButton

const MAIN_MENU_SCENE_PATH = "res://scenes/main.tscn"  # adjust if your path differs

func _ready():
	menu_button.pressed.connect(_on_menu_pressed)

func _on_menu_pressed():
	get_tree().call_deferred("change_scene_to_file", MAIN_MENU_SCENE_PATH)
