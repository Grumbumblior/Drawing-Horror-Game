extends CharacterBody3D

@onready var sight = $VisionArea
@onready var raycast = $VisionRaycast
@onready var animation = $AnimationPlayer
@onready var timer = $VisionTimer
@onready var scream = $Scream
@onready var navigation = $NavigationAgent3D


func _process(delta: float) -> void:
	look_for_enemy()

func look_for_enemy():
	var overlaps = sight.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.is_in_group("Enemy"):
				var enemyPosition = overlap.center_mass.global_transform.origin
				raycast.look_at(enemyPosition, Vector3.UP)
				raycast.force_raycast_update()
				if raycast.is_colliding():
					var collider = $VisionRaycast.get_collider()
					if collider.is_in_group("Enemy"):
						print("I SEE YOU")
						var direction = global_position.direction_to(collider.global_position)
						var dot_product = (-self.get_global_transform().basis.z).dot(direction)
						print(dot_product)
					else:
						print("i don't see you")
