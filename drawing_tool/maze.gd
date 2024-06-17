extends Node3D
@onready var BOX = preload("res://player/sight_box.tscn")
@onready var danger_music = $Danger
@onready var chase_music = $Chase
@onready var DANGER_BUS_ID = AudioServer.get_bus_index("Danger")
@onready var CHASE_BUS_ID = AudioServer.get_bus_index("Chase")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.shuffle_runes()
	GameManager.maze_won.connect(_on_maze_won)
	var s_box = BOX.instantiate()
	get_node("Player/Head2/Camera3d").add_child(s_box)
	$Enemy.shy_warning.connect(_on_shy_warning)
	$Enemy.shy_safe.connect(_on_shy_safe)
	Hud.tutorial_message("This one is a bit shy.\nHowever it is very persistant.\nDon't turn your back on it.")
	AudioServer.set_bus_mute(CHASE_BUS_ID, true)
	danger_music.play()
	chase_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_shy_warning():
	AudioServer.set_bus_mute(DANGER_BUS_ID, true)
	AudioServer.set_bus_mute(CHASE_BUS_ID, false)
	pass
	
func _on_shy_safe():
	AudioServer.set_bus_mute(CHASE_BUS_ID, true)
	AudioServer.set_bus_mute(DANGER_BUS_ID, false)
	pass
	
func _on_maze_won():
	Hud.tutorial_message("Well done.\nOne more thorn of mine removed.\nOn to the next")
	$MessageTimer1.start()

func _on_message_timer_1_timeout() -> void:
	get_tree().change_scene_to_file("res://labrynth.tscn")
