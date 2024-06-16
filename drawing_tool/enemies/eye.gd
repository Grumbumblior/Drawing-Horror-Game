extends CharacterBody3D
@onready var waypoints := get_tree().get_nodes_in_group("EyeWaypoints")
@onready var sight = $VisionArea
@onready var raycast = $VisionRaycast
@onready var animation = $AnimationPlayer
@onready var timer = $VisionTimer
@onready var scream = $Scream
@onready var navigation = $NavigationAgent3D

signal eye_warning
signal eye_safe

@export var speed : int = 3.5

var target_position
var waypoint_index = 1
var player

enum {
	SPAWN,
	SEARCH,
	CHASE,
	HUNT
}

var state
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.labrynth_won.connect(_on_labrynth_won)
	waypoints.shuffle()
	player = get_tree().get_nodes_in_group("Player")[0]
	target_position = waypoints[0].global_position
	state = SPAWN
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match state:
		SPAWN:
			global_position = target_position
			state = SEARCH
		SEARCH:
			animation.play("rotate")
		CHASE:
			look_at(player.global_position)
			if look_for_player():
				navigation.set_target_position(player.head.global_position)
				move_towards_point(speed)
			else: 
				state = HUNT
		HUNT:
			if navigation.is_navigation_finished():
				state = SEARCH
				eye_safe.emit()
			move_towards_point(speed)

func move_towards_point(speed):
	var targetPos = navigation.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	velocity = direction * speed
	move_and_slide()
	pass

func look_for_player():
	var overlaps = sight.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.is_in_group("Player"):
				var playerPosition = overlap.center_mass.global_transform.origin
				raycast.look_at(playerPosition, Vector3.UP)
				raycast.force_raycast_update()
				if raycast.is_colliding():
					var collider = $VisionRaycast.get_collider()
					if collider.is_in_group("Player"):
						print("I SEE YOU")
						eye_warning.emit()
						return true
					else:
						print("i don't see you")
						return false


func end_search():
	waypoint_index += 1
	if waypoint_index > waypoints.size() - 1:
		waypoint_index = 0
	target_position = waypoints[waypoint_index].global_position
	state = SPAWN

func _on_vision_timer_timeout() -> void:
	if look_for_player() == true:
		animation.stop()
		timer.stop()
		scream.play()
		state = CHASE


func _on_killbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		#body.global_position = Vector3(175, -782, 101)
		GameManager.game_over()

func _on_labrynth_won():
	scream.play()
	await scream.finished
	queue_free()
	#animation.play("die")


#func _on_warning_zone_body_entered(body: Node3D) -> void:
	#eye_warning.emit()
#
#
#func _on_warning_zone_body_exited(body: Node3D) -> void:
	#eye_safe.emit()
