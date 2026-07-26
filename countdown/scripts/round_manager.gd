extends Node

#constants
const PLACEMENT_SCENE_PATH = "res://scenes/placement.tscn"
const LEVEL_SCENE_PATH = "res://scenes/level.tscn"
const OBJECT_POOl: Array[PackedScene] = [
preload("res://scenes/numbered_objects/Portal.tscn"), 
preload("res://scenes/numbered_objects/StandardWall.tscn"),
preload("res://scenes/numbered_objects/BlockWithSpikes.tscn"),
preload("res://scenes/numbered_objects/Flamethrower.tscn"),
preload("res://scenes/numbered_objects/ShieldBlock.tscn"),
preload("res://scenes/numbered_objects/JumpPad.tscn"),
preload("res://scenes/numbered_objects/StandardPlatform.tscn"),
preload("res://scenes/numbered_objects/RandClone.tscn"),
preload("res://scenes/numbered_objects/BlackHole.tscn"),
preload("res://scenes/numbered_objects/DamagePlatform.tscn"),
preload("res://scenes/numbered_objects/Cloud.tscn")]

#signals
signal round_complete

#variables
var level_objects: Array[Dictionary] = []
#var objects_to_place = [ 10,9,8,7,6,5,4,3,2,1,0 ] 
var objects_to_place = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


# Called when the node enters the scene tree for the first time.
func _ready():
	round_complete.connect(advance_round)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#ends the round phase, placement will have to pull objects from here as well
func advance_round():
	get_tree().call_deferred("change_scene_to_file", PLACEMENT_SCENE_PATH)
	
#ends the placement phase, level will have to pull new objects from placement
func end_placement():
	get_tree().call_deferred("change_scene_to_file", LEVEL_SCENE_PATH)

# Called by placement.tscn when a player places an item
func add_object(object_id: String, pos: Vector2, rot: float = 0.0):
	var new_object_data = {
		"id": object_id,       # e.g., "spike_trap", "wood_platform"
		"position": pos,       # Vector2(x, y)
		"rotation": rot        # Storing rotation is usually important for UCH!
	}
	level_objects.append(new_object_data)

# Called by level.tscn in its _ready() function to spawn everything
func get_level_objects() -> Array[Dictionary]:
	return level_objects
