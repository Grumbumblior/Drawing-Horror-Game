extends CharacterBody3D


const WALK_SPEED = 3.0
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

const BOB_FREQ = 2.0
const BOB_AMP = 0.08

var t_bob = 0.0
var speed = WALK_SPEED
@onready var gestures = $GestureNode
@onready var head = $Head2
@onready var camera = $Head2/Camera3D

enum{
	ACT,
	DRAW
}

var state = ACT

#func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and state != DRAW:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	match state:
		ACT:
			act_state(delta)
		DRAW:
			draw_state()

func act_state(delta):
	# Handle jump.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	gestures.can_draw = false
	if Input.is_action_just_pressed("ui_accept"):
		state = DRAW
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI  actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
	t_bob += delta * velocity.length()
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func draw_state():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	gestures.can_draw = true
	if Input.is_action_just_pressed("ui_accept"):
		state = ACT
	
