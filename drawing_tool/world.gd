extends Node3D

#@onready var box = $NavigationRegion3D/CSGBox3D7
@onready var patrol_array = []
@onready var ENEMY = preload("res://enemies/enemy.tscn")
@onready var spawn : Marker3D = $Spawn
@onready var danger_music = $Danger
@onready var chase_music = $Chase
@onready var DANGER_BUS_ID = AudioServer.get_bus_index("Danger")
@onready var CHASE_BUS_ID = AudioServer.get_bus_index("Chase")
#@onready var PLAYER = preload("res://player/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_won.connect(_on_game_won)
	Hud.message.position.x = 400
	Hud.tutorial_message("It has to be this way")
	for P in $Patrolpoints.get_children():
		patrol_array.append(P)
	patrol_array.shuffle()
	GameManager.shuffle_runes()
	AudioServer.set_bus_mute(CHASE_BUS_ID, true)
	danger_music.play()
	chase_music.play()
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
		cricket.warning.connect(_on_warning)
		cricket.safe.connect(_on_safe)
		$start_box.queue_free()
		#GameManager.emit_signal("game_won")

func _on_game_won():
	Hud.tutorial_message("*Thump*")
	$WinTimer.start()

func _on_win_timer_timeout() -> void:
	Hud.end_screen.visible = true
	$ThanksTimer.start()
func _on_warning():
	AudioServer.set_bus_mute(DANGER_BUS_ID, true)
	AudioServer.set_bus_mute(CHASE_BUS_ID, false)
	pass
	
func _on_safe():
	AudioServer.set_bus_mute(CHASE_BUS_ID, true)
	AudioServer.set_bus_mute(DANGER_BUS_ID, false)
	pass

func _on_thanks_timer_timeout() -> void:
	get_tree().quit()
