extends Button

var id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(call_load_level)
	
func call_load_level():
	GameManager.load_level(id)
