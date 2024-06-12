extends CharacterBody3D


const WALK_SPEED = 3.0
const SPRINT_SPEED = 6.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

const BOB_FREQ = 2.0
const BOB_AMP = 0.08

const RUNE = preload("res://rune_decal.tscn")
var t_bob = 0.0
var speed = WALK_SPEED
@onready var gestures = $GestureNode
@onready var head = $Head2
@onready var camera = $Head2/Camera3D
@onready var ray = $Head2/Camera3D/RayCast3D
@onready var marker = $Head2/Camera3D/Marker3D
@onready var home = $"../Home"

enum{
	ACT,
	DRAW
}

var state = ACT

func _ready():
	gestures.gesture_classified.connect(on_gesture_classified)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and state != DRAW:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	match state:
		ACT:
			act_state(delta)
		DRAW:
			draw_state()

func act_state(delta):
	# Handle jump.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	gestures.can_draw = false
	if Input.is_action_just_pressed("ui_accept") and ray.is_colliding():
		state = DRAW
	
	#if Input.is_action_pressed("sprint"):
		#speed = SPRINT_SPEED
	#else:
		#speed = WALK_SPEED
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
	
func _on_gesture_node_draw_sent(stroke) -> void:
	var new_rune = RUNE.instantiate()
	print(stroke)
	new_rune.texture_albedo = stroke.get_texture()
	get_tree().get_root().add_child(new_rune)
	new_rune.global_position = marker.global_position

func on_gesture_classified(gesture_name : StringName):
	var space_state = get_world_3d().direct_space_state
	var screen_center = get_viewport().size/2
	var origin = camera.project_ray_origin(screen_center)
	var end = origin + camera.project_ray_normal(screen_center) * 1000
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_bodies = true
	var result = space_state.intersect_ray(query)
	if result:
		_spawn_rune(result.get("position"), result.get("normal"), gesture_name)
	
	#new_rune.texture_albedo = load("res://images/%s.png" % gesture_name)
	#get_tree().get_root().add_child(new_rune)
	#new_rune.global_transform.origin = ray.get_collision_point()
	#new_rune.look_at(ray.get_collision_normal())
	if gesture_name == "Time":
		print("za warudo")
		speed = 100
	elif gesture_name == "Tele":
		self.global_position = home.global_position
		#new_rune.setup(ray.get_collision_point(), ray.get_collision_normal())
	
		
		
func _spawn_rune(position : Vector3, normal: Vector3, gesture_name: String) -> void:
	var new_rune = RUNE.instantiate()
	new_rune.texture_albedo = load("res://images/%s.png" % gesture_name)
	new_rune.texture_emission = load("res://images/%s.png" % gesture_name)
	get_tree().get_root().add_child(new_rune)
	new_rune.global_position = position
	new_rune.look_at((new_rune.global_transform.origin + normal), Vector3.UP)
	new_rune.rotate_object_local(Vector3(1,0,0), 90)
