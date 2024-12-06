extends Control


var level_button_prefab : PackedScene = preload("res://Scenes/Prefabs/level_button.tscn")

@onready var level_grid : Control = $"VBoxContainer/MarginContainer/GridContainer"

func _ready():
	GameManager.level_completed.connect(update)


func update(id:int):
	# Delete old buttons
	for c in level_grid.get_children():
		c.queue_free()
	# Make new buttons
	for i in GameManager.levels.size() - 1:
		var new_button = level_button_prefab.instantiate()
		new_button.text = str(i+1)
		new_button.id = i+1
		if i > GameManager.completed_levels:
			new_button.disabled = true
		level_grid.add_child(new_button)


func _on_return_pressed():
	GameManager.change_menu("MainMenu")
