extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.level_change.connect(on_level_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and GameManager.current_level != -1:
		print(get_tree().root.get_tree_string_pretty())
		GameManager.level_scene.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		self.visible = true


func on_level_change(new_id:int):
	if new_id == -1:
		self.visible = false


func _on_resume_pressed() -> void:
	GameManager.level_scene.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	self.visible = false


func _on_exit_level_pressed() -> void:
	GameManager.change_menu("MainMenu")
