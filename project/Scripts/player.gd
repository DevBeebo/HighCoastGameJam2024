extends CharacterBody2D

signal died(why) # Emitted when the player dies and what killed them (why)

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@export var player_id : int # "0" for player #1 and "1" for player #2

@onready var player_size : Vector2 = $CollisionShape2D.shape.get_rect().size # Used by squich_check for it to determine if the player got squished to death

func _ready():
	$"HurtBox/CollisionShape2D".shape.get_rect().size = player_size

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
	# Check if the player should die of being squished
	squish_check()
	animation_handling()


func animation_handling():
	if self.velocity.x == 0 or not is_on_floor():
		$Sprite.play("Idle")
	else:
		$Sprite.play("Run")
		if self.velocity.x > 1:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
	pass


func squish_check():
	# Shots 4 hit scans to see if 2 on a axis both hit something, if they do the player dies
	for a in range(2):
		var hits : int = 0 # If this value becomes 2 the player will die
		for d in range(2):
			$RayCast2D.target_position = ((Vector2.RIGHT * player_size.x/2) if a == 0 else (Vector2.DOWN * player_size.y/2)) * (1 if d == 0 else -1)
			$RayCast2D.force_raycast_update()
			if $RayCast2D.is_colliding(): hits += 1
		if hits == 2: 
			print("Player ", player_id + 1, " Deaded")
			died.emit("Squished")
			GameManager.player_died(player_id, "Squished")
			break


func hit_danger(_area):
	died.emit("Spikes")
	GameManager.player_died(player_id, "Spikes")
