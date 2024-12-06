extends Node2D

enum Type {
	CONSTANT,
	TOGGLE
}

@export var type : Type
@export var end_position : Vector2 # Where the platform will move to and then change direction at. In local position
@export var speed : float # How fast the platform will move
@export var trigger : Node2D # The thing that tells the Platform to move and stop. (button.gd or trigger.gd)

var moving : bool = false # If the Platform should be moving or not
var returning : bool = false # If the Platform is returning to its starting position

# Called when the node enters the scene tree for the first time.
func _ready():
	# Takes all CollisionShapes and reparents them to the Platform so they can be moved
	for c in self.get_children():
		if c is CollisionShape2D or c is TileMapLayer:
			c.reparent($Platform)
	
	# If type == TOGGLE then it should always be moving as direction is all that need to flip
	if type == Type.TOGGLE:
		moving = true
		returning = true
	
	# Connects signal with the trigger to make itself controllable
	trigger.connect("state_changed", trigger_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta : float):
	var distance_left : float = ($Platform.position - (end_position if not returning else Vector2.ZERO)).length()
	
	if moving or type == Type.TOGGLE:
		$Platform.position = $Platform.position.move_toward(Vector2.ZERO if returning else end_position, speed * delta)
	if speed * delta >= distance_left and type == Type.CONSTANT: returning = not returning
	
func trigger_changed(state : bool):
	match type:
		Type.CONSTANT:
			moving = state
		Type.TOGGLE:
			returning = not state
