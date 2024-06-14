extends Node3D

#@onready var box = $NavigationRegion3D/CSGBox3D7
@onready var patrol_array = []
@onready var ENEMY = preload("res://enemies/enemy.tscn")
@onready var spawn : Marker3D = $Spawn
#@onready var PLAYER = preload("res://player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Hud.message.position.x = 450
	Hud.tutorial_message("Hi this is Drake\nI'm jumping you to the last level\nCricket turns on you\nDon't get caught")
	for P in $Patrolpoints.get_children():
		patrol_array.append(P)
	patrol_array.shuffle()
	GameManager.shuffle_runes()
	#$Enemy.waypoints = patrol_array
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_box_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var cricket = ENEMY.instantiate()
		get_tree().get_root().add_child(cricket)
		#cricket.waypoints = patrol_array
		cricket.global_position = spawn.global_position
		$start_box.queue_free()
