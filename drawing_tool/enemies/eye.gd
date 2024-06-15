extends Node3D
@onready var sight = $VisionArea
@onready var raycast = $VisionRaycast
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_vision_timer_timeout() -> void:
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
					else:
						print("I don't see you")
