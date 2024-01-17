extends CharacterBody2D


const SPEED = 10.0
const MAX_VERT_SPEED = 15
const ACCELERATION = 150.0
const DECCELERATION = 100.0
const JETPACK_TIME = 0.35
const JETPACK_ACCELERATION = -55
const JUMP_VELOCITY = -15.0

@export var RIGHT_TEXTURE: Texture2D
@export var LEFT_TEXTURE: Texture2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jetpack_timer: Timer
var jetpack_enabled = false

func _ready():
	jetpack_timer = Timer.new()
	jetpack_timer.connect("timeout", jetpack_timer_timeout)
	add_child(jetpack_timer)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle jetpack
	if Input.is_action_just_pressed("move_up"):
		jetpack_timer.start(JETPACK_TIME)
		print("start")
	
	if Input.is_action_just_released("move_up"):
		print("stop")
		jetpack_timer.stop()
		jetpack_enabled = false
	
	if jetpack_enabled:
		#velocity.y = move_toward(velocity.y, velocity.y + JETPACK_ACCELERATION * delta, )
		velocity.y += JETPACK_ACCELERATION * delta
	
	velocity.y = clamp(velocity.y, -MAX_VERT_SPEED, MAX_VERT_SPEED)
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_vector("move_left", "move_right", "move_down", "move_up")
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
		if direction.x > 0:
			$Sprite2D.set_texture(RIGHT_TEXTURE)
		else:
			$Sprite2D.set_texture(LEFT_TEXTURE)
	else:
		velocity.x = move_toward(velocity.x, 0, DECCELERATION * delta)
	
	move_and_slide()

func jetpack_timer_timeout():
	print("boost")
	jetpack_enabled = true
