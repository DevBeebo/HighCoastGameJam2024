extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(player_entered)


func player_entered(_area):
	print("yo")
	if self.get_overlapping_bodies().size() == 2:
		GameManager.complete_level()
