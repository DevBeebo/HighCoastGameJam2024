extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_level_select_pressed():
	GameManager.change_menu("LevelSelect")

func _on_controls_pressed():
	GameManager.change_menu("Controls")

func _on_exit_pressed():
	exit_prompt_toggle(true)

func _on_confirm_exit_pressed():
	get_tree().quit()

func _on_decline_exit_pressed():
	exit_prompt_toggle(false)

# Shows and hides the exit prompt and menu. If "show_exit" is true, the exit prompt will be shown instead of the menu
func exit_prompt_toggle(show_exit:bool):
	$Menu.visible = not show_exit
	$ExitPrompt.visible = show_exit
