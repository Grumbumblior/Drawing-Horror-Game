extends Node3D

@onready var box = $NavigationRegion3D/CSGBox3D7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	box.global_rotation_degrees.x = box.global_rotation_degrees.x + 1 
