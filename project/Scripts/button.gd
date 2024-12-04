extends Area2D

signal state_changed(new_state) # New state is "true" for on and "false" for off

@export var normally_closed : bool # If set to true, pressing the button will disable things
@export var reset_time : float # Time for the button to change back to unpressed/"normally_closed"

var state = false # Wether the button is stepped on or not. "True" if it is, "False" if not

func _ready():
	state_changed.emit(normally_closed)
	$Timer.wait_time = reset_time

# Triggered when something touches the button
func interact():
	# Skips if it was already stood on
	if $Timer.is_stopped():
		state = true
		state_changed.emit(not normally_closed)
		$Timer.start()

# Triggered when something leaves the button
func reset():
	# Skips if there are things still on the button
	state = false
	state_changed.emit(normally_closed)
