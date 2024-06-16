extends CharacterBody3D

const WALK_SPEED = 2.0
const SPRINT_SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
const STAMINA_MAX = 200

const BOB_FREQ = 2.0
const BOB_AMP = 0.16

const SPELLIGHT = preload("res://spell_light.tscn")
const RUNE = preload("res://environment/Items/rune_decal.tscn")
var t_bob = 0.0
var speed = WALK_SPEED
var stamina = STAMINA_MAX

@export var spells_dict = {"Eye" : 0, "Time" : 0, "Tele" : 0, "Light" : 0}

var G = GameManager
@onready var gestures = $GestureNode
@onready var head = $Head2
@onready var camera = $Head2/Camera3d
@onready var ray = $Head2/Camera3d/RayCast3D
@onready var marker = $Head2/Camera3d/Marker3D
@onready var home = $"../Home"
@onready var center_mass = $CenterMass
@onready var aura = $Aura

enum{
	ACT,
	DRAW
}

var state = ACT

func _ready():
	G.game_won.connect(_on_game_won)
	gestures.gesture_classified.connect(on_gesture_classified)
	G.spell_collected.connect(_on_spell_collected)
	G.game_lost.connect(_on_game_lost)
	G.jump_scare.connect(_on_jump_scare)
	G.rune_collected.connect(_on_rune_collected)
	
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
	
	if Input.is_action_pressed("sprint") && stamina > 0:
		if stamina > 0:
			stamina -= 1
			speed = SPRINT_SPEED
		elif stamina == 0:
			print("pant")
			
			speed = WALK_SPEED
	else:
		#print(stamina)
		speed = WALK_SPEED
	if !Input.is_action_pressed("sprint"):
		$Pant.play()
		if stamina < STAMINA_MAX:
			stamina += 1
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
	#print(stroke)
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
	check_valid_rune(gesture_name)
	#new_rune.texture_albedo = load("res://images/%s.png" % gesture_name)
	#get_tree().get_root().add_child(new_rune)
	#new_rune.global_transform.origin = ray.get_collision_point()
	#new_rune.look_at(ray.get_collision_normal())
	if gesture_name in spells_dict && spells_dict[gesture_name] > 0:
		cast_spell(gesture_name)
	state = ACT
	
func check_valid_rune(gesture_name):
	if gesture_name in G.allRunes:
		if gesture_name == G.runeSequence[G.runeIndex]:
			G.castRunes.append(gesture_name.replace("&", ""))
			G.runeIndex = G.runeIndex + 1
			G.check_won()
	print(G.castRunes)
	
func _spawn_rune(position : Vector3, normal: Vector3, gesture_name: String) -> void:
	var new_rune = RUNE.instantiate()
	new_rune.texture_albedo = load("res://images/%s.png" % gesture_name)
	new_rune.texture_emission = load("res://images/%s.png" % gesture_name)
	new_rune.rotate_y(deg_to_rad(180))
	get_tree().get_root().add_child(new_rune)
	new_rune.global_position = position
	new_rune.look_at((new_rune.global_transform.origin + normal), Vector3.UP)
	new_rune.rotate_object_local(Vector3(1,0,0), 90)
	new_rune.rotate_object_local(Vector3(0,0,1), deg_to_rad(180))
	
func cast_spell(spell):
	print(spell)
	if spell == "Time":
		print("za warudo")
	elif spell == "Tele":
		print("zap")
		self.global_position = home.global_position
	elif spell == "Light":
		var new_light = SPELLIGHT.instantiate()
		get_tree().get_root().add_child(new_light)
		
		new_light.global_position = self.global_position

func _on_spell_collected(spell):
	spells_dict[spell] = spells_dict[spell] + 1
	#for s in spells_dict:
		#if spells_dict[s] > 0:
			#Hud.show_spell(spells_dict[s].index)
	print(spells_dict)

func _on_jump_scare():
	$Scare.play()
	
func _on_game_won():
	print("won")
	pass

func _on_game_lost():
	$Scream.play()
	global_position = Vector3(175, -782, 101)
	print("game over")
	$DeathTimer.start()

func _on_rune_collected(runeNum):
	print("play")
	$Bell.play()

func _on_death_timer_timeout() -> void:
	get_tree().quit()
