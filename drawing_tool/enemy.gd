extends CharacterBody3D


@export var waypoints : Array[Marker3D]
@export var patrolSpeed =2
@export var chaseSpeed = 3

enum {
	PATROL,
	CHASE,
	HUNT,
	WAIT
}

var state
var navigationAgent : NavigationAgent3D
var waypointIndex : int
var patrolTimer : Timer
var playerInEarshotFar : bool
var playerInEarshotClose : bool
var playerInSight : bool
var player
@onready var animation = $AnimatedSprite3D

func _ready() -> void:
	state = PATROL
	player = get_tree().get_nodes_in_group("Player")[0]
	patrolTimer = $PatrolTimer
	navigationAgent = $NavigationAgent3D
	navigationAgent.set_target_position(waypoints[0].global_position)
	print(waypoints[0].global_position)

func _process(delta: float) -> void:
	match state:
		PATROL:
			animation.animation = "Idle"
			patrol_state()
		CHASE:
			animation.animation = "Chase"
			if navigationAgent.is_navigation_finished():
				patrolTimer.start()
				state = WAIT
			navigationAgent.set_target_position(player.global_position)
			move_towards_point(chaseSpeed)
		HUNT:
			animation.animation = "Idle"
			if navigationAgent.is_navigation_finisahed():
				patrolTimer.start()
				state = WAIT
			move_towards_point(patrolSpeed)
		WAIT:
			animation.animation = "Idle" 
			pass
func face_direction(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)
	
func patrol_state():
	if navigationAgent.is_navigation_finished():
		state = WAIT
		patrolTimer.start()
		return
	move_towards_point(patrolSpeed)

func move_towards_point(speed):
	var targetPos = navigationAgent.get_next_path_position()

	var direction = global_position.direction_to(targetPos)
	if global_position != targetPos:
		face_direction(targetPos)
	velocity = direction * speed
	move_and_slide()
	if(playerInEarshotFar):
		check_for_player()
	pass

func check_for_player():
	#var space_state = get_world_3d().direct_space_state
	#var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create($Head.global_position, player.get_node("Head2/Camera3D").global_position, 1, [self]))
	#if result.size() > 0:
		#print("hi")
		#if result["collider"].is_in_group("Player"):
			if(playerInEarshotClose):
				print("chase")
				state = CHASE
			elif(playerInSight):
				print("chase")
				state = CHASE
			else:
				print("hunt")
				state = HUNT
				navigationAgent.set_target_position(player.global_position)
func _on_patrol_timer_timeout() -> void:
	state = PATROL
	waypointIndex += 1
	if waypointIndex > waypoints.size() - 1:
		waypointIndex = 0
	navigationAgent.set_target_position(waypoints[waypointIndex].global_position)


func _on_hearing_far_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		playerInEarshotFar = true
		print("Player is in earshot")
	pass # Replace with function body.


func _on_hearing_far_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		playerInEarshotFar = false
		print("Player has left earshot")
	pass # Replace with function body.


func _on_hearing_close_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		playerInEarshotClose = true
		print("Player is in close earshot")
	pass # Replace with function body.


func _on_hearing_close_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		playerInEarshotClose = false
		print("Player has left close earshot")
	pass # Replace with function body.


func _on_sight_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		playerInSight = true
		print("Player is in sight")
	pass # Replace with function body.


func _on_sight_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		playerInSight = false
		print("Player has left sight")
	pass # Replace with function body.
