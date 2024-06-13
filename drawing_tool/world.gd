extends Node3D

@onready var box = $NavigationRegion3D/CSGBox3D7
@onready var patrol_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for P in $Patrolpoints.get_children():
		#patrol_array.append(P)
	#patrol_array.shuffle()
	#$Enemy.waypoints = patrol_array
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
