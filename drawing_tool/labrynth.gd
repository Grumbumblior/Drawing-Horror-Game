extends Node3D
@onready var EYE = preload("res://enemies/eye.tscn")
@onready var danger_music = $Danger
@onready var chase_music = $Chase
@onready var DANGER_BUS_ID = AudioServer.get_bus_index("Danger")
@onready var CHASE_BUS_ID = AudioServer.get_bus_index("Chase")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.labrynth_won.connect(_on_labrynth_won)
	GameManager.shuffle_runes()
	Hud.tutorial_message("Don't let this one catch sight of you.\nIf it does, your only hope is to hide.")
	AudioServer.set_bus_mute(CHASE_BUS_ID, true)
	danger_music.play()
	chase_music.play()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enterance_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var enemy = EYE.instantiate()
		get_tree().get_root().add_child(enemy)
		enemy.eye_warning.connect(_on_eye_warning)
		enemy.eye_safe.connect(_on_eye_safe)
		#GameManager.emit_signal("labrynth_won")
		$Enterance.queue_free()

func _on_labrynth_won():
	Hud.tutorial_message("Very good.\nThis one was quite the nuisance.\nAlways looking into my secrets.")
	$MessageTimer1.start()

func _on_message_timer_1_timeout() -> void:
	Hud.tutorial_message("But speaking of secrets...\nYou now know some of mine...\nand I cannot have any loose ends")
	$MessageTimer2.start()

func _on_eye_warning():
	AudioServer.set_bus_mute(DANGER_BUS_ID, true)
	AudioServer.set_bus_mute(CHASE_BUS_ID, false)
	pass
	
func _on_eye_safe():
	AudioServer.set_bus_mute(CHASE_BUS_ID, true)
	AudioServer.set_bus_mute(DANGER_BUS_ID, false)
	pass

func _on_message_timer_2_timeout() -> void:
	get_tree().change_scene_to_file("res://world.tscn")
