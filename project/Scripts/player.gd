extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

@export var player_id : int

func _physics_process(delta):
	#region Movement
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump" + str(player_id)) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left" + str(player_id), "Right" + str(player_id))
	if direction:
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	#endregion
	#region Interact
	if Input.is_action_just_pressed("Interact" + str(player_id)) and $Interactor.has_overlapping_areas():
		$Interactor.get_overlapping_areas()[0].interact()
	#endregion
