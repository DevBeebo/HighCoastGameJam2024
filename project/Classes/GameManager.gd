extends Node

signal level_change(new_id) # Emitted when the level changes and says to which ID. -1 means no level

var levels = [ # An array with all the levels in order. 0 is a test level
	preload("res://Scenes/Levels/TestLevel.tscn"),
]
var current_level : int = -1 # The ID of the current level to reset on death. -1 means no level is currently being played
var current_menu : String = "MainMenu" # The name of the current menus node
var level_scene : Node2D # The root node of the current level

@onready var menu_canvas := $"../MainScene/CanvasLayer"

func _ready():
	change_menu(current_menu)
	pass

func change_menu(menu:String):
	if current_level != -1:
		unload_level()
	if menu_canvas.has_node(menu):
		menu_canvas.get_node(current_menu).visible = false
		current_menu = menu
		menu_canvas.get_node(menu).visible = true

func load_level(id):
	# Skip if id does not refer to a Level
	if id >= levels.size(): return
	# Hide level select menu
	menu_canvas.get_node("LevelSelect").visible = false
	# Unload the current level and make the new one load next frame instead
	if level_scene != null:
		level_scene.queue_free()
	# Load the new level
	level_scene = levels[id].instantiate()
	current_level = id # Sets current level to the ID of the new level
	get_tree().root.call_deferred("add_child", level_scene)
	level_change.emit(id)
	
func unload_level():
	if level_scene == null: return
	level_scene.queue_free()
	current_level = -1 # Sets it to -1 as it means no level is being played
	level_change.emit(-1)

func player_died(id:int, why:String):
	print("Player ", id + 1, " died because ", why)
	level_scene.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	load_level(current_level)
