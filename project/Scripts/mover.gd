extends Node2D

enum Type {
	CONSTANT,
	TOGGLE
}

@export var type : Type
@export var end_position : Vector2 # Where the platform will move to and then change direction at. In local position
@export var speed : float # How fast the platform will move

var returning : bool = false # If the Platform is returning to its starting position

# Called when the node enters the scene tree for the first time.
func _ready():
	# Takes all CollisionShapes and reparents them to the Platform so they can be moved
	for c in self.get_children():
		if c is CollisionShape2D:
			c.reparent($Platform)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var distance_left : float = ($Platform.position - (end_position if not returning else Vector2.ZERO)).length()
	
	$Platform.position = $Platform.position.move_toward(Vector2.ZERO if returning else end_position, speed * delta)
	if speed * delta >= distance_left: returning = not returning
