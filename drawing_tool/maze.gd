extends Node3D
@onready var BOX = preload("res://player/sight_box.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.shuffle_runes()
	var s_box = BOX.instantiate()
	get_node("Player/Head2/Camera3d").add_child(s_box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
