extends Area2D

signal state_changed(new_state) # New state is "true" for on and "false" for off

@export var normally_closed : bool # If set to true, pressing the button will disable things

var state = false # Wether the button is stepped on or not. "True" if it is, "False" if not


func _ready():
	state_changed.emit(normally_closed)

# Triggered when something touches the button
func _on_area_entered(_area):
	# Skips if it was already stood on
	if state: return
	state = true
	state_changed.emit(not normally_closed)

# Triggered when something leaves the button
func _on_area_exited(_area):
	# Skips if there are things still on the button
	if self.has_overlapping_areas(): return
	state = false
	state_changed.emit(normally_closed)
	
