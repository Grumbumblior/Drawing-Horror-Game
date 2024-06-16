extends CharacterBody3D

@onready var navigationAgent = $NavigationAgent3D
@onready var speed = 2

func _ready() -> void:
	navigationAgent.set_target_position(get_tree().get_nodes_in_group("Player")[0].aura.global_position)

func _process(delta: float) -> void:
	move_towards_point(speed)
	
	
func move_towards_point(speed):
	if navigationAgent.is_navigation_finished():
		navigationAgent.set_target_position(get_tree().get_nodes_in_group("Player")[0].aura.global_position)
	var targetPos = navigationAgent.get_next_path_position()
	var direction = global_position.direction_to(targetPos)
	
	if global_position != targetPos:
		face_direction(targetPos)
	velocity = direction * speed
	move_and_slide()
	pass
	

func face_direction(direction : Vector3):
	look_at(Vector3(direction.x, global_position.y, direction.z), Vector3.UP)
