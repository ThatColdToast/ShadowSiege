extends CharacterBody2D


const SPEED = 300.0
const ACCELERATION = 2500.0
const DECCELERATION = 1500.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_vector("move_left", "move_right", "move_down", "move_up")
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		# velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, DECCELERATION * delta)

	move_and_slide()
