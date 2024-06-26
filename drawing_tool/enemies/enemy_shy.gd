extends CharacterBody3D


@onready var waypoints := get_tree().get_nodes_in_group("ShyWaypoints")
@export var patrolSpeed = 2
@export var chaseSpeed = 1
@onready var raycast = $VisionRaycast
var freezeSpeed = 0
var speed = chaseSpeed

enum {
	PATROL,
	CHASE,
	HUNT,
	WAIT
}
signal warning
signal safe

var state
var navigationAgent : NavigationAgent3D
var waypointIndex : int
var patrolTimer : Timer
var playerInEarshotFar : bool
var playerInEarshotClose : bool
var playerInSight : bool
var player
@onready var animation = $AnimatedSprite3D
signal shy_warning
signal shy_safe
func _ready() -> void:
	state = PATROL
	GameManager.jump_scare.connect(_on_jump_scare)
	GameManager.game_won.connect(_on_game_won)
	GameManager.maze_won.connect(_on_maze_won)
	player = get_tree().get_nodes_in_group("Player")[0]
	patrolTimer = $PatrolTimer
	navigationAgent = $NavigationAgent3D
	waypoints.shuffle()
	print(waypoints)
	navigationAgent.set_target_position(waypoints[0].global_position)
	print(waypoints[0].global_position)


func _process(delta: float) -> void:
	match state:
		PATROL:
			animation.animation = "Idle"
			if navigationAgent.is_navigation_finished():
				state = WAIT
				patrolTimer.start()
				return
			move_towards_point(speed)
		CHASE:
			animation.animation = "Chase"
			if navigationAgent.is_navigation_finished():
				patrolTimer.start()
				state = WAIT
			navigationAgent.set_target_position(player.global_position)
			move_towards_point(speed)
		HUNT:
			animation.animation = "Idle"
			if navigationAgent.is_navigation_finished():
				patrolTimer.start()
				state = WAIT
			move_towards_point(speed)
		WAIT:
			animation.animation = "Idle" 
			pass

func face_direction(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)
	
func check_line_of_sight():
	raycast.look_at(player.center_mass.global_position, Vector3.UP)
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var collider = $VisionRaycast.get_collider()
		if collider.is_in_group("SightBox"):
			#print("I SEE YOU")
			speed = freezeSpeed
			return true
		else:
			#print("i don't see you")
			speed = chaseSpeed
			return false

func patrol_state():
	pass

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
		#print(result)
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
				warning.emit()
				navigationAgent.set_target_position(player.global_position)

func _on_patrol_timer_timeout() -> void:
	state = PATROL
	safe.emit()
	waypointIndex += 1
	if waypointIndex > waypoints.size() - 1:
		waypointIndex = 0
	navigationAgent.set_target_position(waypoints[waypointIndex].global_position)


func _on_hearing_far_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		shy_warning.emit()
		playerInEarshotFar = true
		print("Player is in earshot")
	pass # Replace with function body.


func _on_hearing_far_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		shy_safe.emit()
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


func _on_killbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		
		GameManager.game_over()
		

func _on_jump_scare():
	self.global_position = $"../World/Scaremarker".global_position

func _on_game_won():
	queue_free()

func _on_jumpscare_timer_timeout() -> void:
	get_tree().quit()
	
func _on_maze_won():
	queue_free()
	#animation.play("die")

func _on_look_timer_timeout() -> void:
	check_line_of_sight()
