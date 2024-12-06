extends Control


@export var level_button_prefab : PackedScene

@onready var level_grid : Control = $"VBoxContainer/MarginContainer/GridContainer"

func _ready() -> void:
	GameManager.level_completed.connect(update)
	update(GameManager.completed_levels)


func update(id:int):
	for c in level_grid.get_children():
		c.queue_free()
	for i in GameManager.levels.size() - 1:
		var new_button = level_button_prefab.instantiate()
		new_button.text = str(i+1)
		new_button.id = i+1
		if i > id:
			new_button.disabled = true
		level_grid.add_child(new_button)


func _on_return_pressed():
	GameManager.change_menu("MainMenu")
