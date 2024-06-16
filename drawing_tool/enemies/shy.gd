extends CharacterBody3D
@export var freezeSpeed = 0
@export var chaseSpeed = .001
@onready var center_mass = $CenterMass
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var waypoints := get_tree().get_nodes_in_group("ShyWaypoints")
@onready var raycast = $VisionRaycast
@onready var navigationAgent = $NavigationAgent3D
@onready var patrolTimer = $PatrolTimer
var field_of_view : float = 45.0

var speed = chaseSpeed
var waypointIndex = 0
enum{
	PATROL,
	HUNT,
	FREEZE,
	WAIT
}

@onready var state = HUNT

func _ready() -> void:
	waypoints.shuffle()
	print(waypoints)
	navigationAgent.set_target_position(waypoints[0].global_position)

func _process(delta: float) -> void:
	match state:
		PATROL:
			if check_line_of_sight():
				speed = freezeSpeed
			else:
				speed = chaseSpeed
			if navigationAgent.is_navigation_finished():
				state = WAIT
				patrolTimer.start()
				return
			move_towards_point(speed)
		HUNT:
			if check_line_of_sight():
				speed = freezeSpeed
			else:
				speed = chaseSpeed
			if navigationAgent.is_navigation_finished():
				patrolTimer.start()
				state = WAIT
			navigationAgent.set_target_position(player.global_position)
			move_towards_point(speed)
		FREEZE:
			speed = freezeSpeed
			if !check_line_of_sight():
				state = HUNT
		WAIT:
			pass

func check_line_of_sight():
	raycast.look_at(player.center_mass.global_position, Vector3.UP)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var collider = $VisionRaycast.get_collider()
		if collider.is_in_group("SightBox"):
			#print("I SEE YOU")
			return true
		else:
			#print("i don't see you")
			return false
	#var direction = global_position.direction_to(player.global_position)
	#var dot_product = (player.head.get_global_transform().basis.z).dot(direction)
	#print(dot_product)
	##print(cos(field_of_view))
	#if dot_product >= cos(field_of_view):
		#print("in sight")

func move_towards_point(speed):
	var targetPos = navigationAgent.get_next_path_position()
	#print("target pos: " , targetPos)
	var direction = global_position.direction_to(targetPos)
	if global_position != targetPos:
		face_direction(targetPos)
	velocity = direction * speed
	move_and_slide()
	pass

func face_direction(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)

func _on_look_timer_timeout() -> void:
	check_line_of_sight()


func _on_patrol_timer_timeout() -> void:
	state = PATROL
	waypointIndex += 1
	if waypointIndex > waypoints.size() - 1:
		waypointIndex = 0
	navigationAgent.set_target_position(waypoints[waypointIndex].global_position)


func _on_warning_shape_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		state = HUNT
