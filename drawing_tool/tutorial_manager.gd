extends Node3D

signal tutorial_message_tut(text : String)
signal spawn_tutorial_runes()
# Called when the node enters the scene tree for the first time.
@onready var mike = $Mike
@onready var animation = $AnimationPlayer
@onready var sound = $Mike/AudioStreamPlayer3D

func _ready() -> void:
	GameManager.shuffle_runes()
	GameManager.kill_mike.connect(_on_kill_mike)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	print("timer")
	Hud.tutorial_message("This creature is profane. \nDestroy him for me.")
	#emit_signal("tutorial_message_tut", )
	$RuneTimer.start()
	

func _on_rune_timer_timeout() -> void:
	print("rune timer")
	$Stones.visible = true
	Hud.tutorial_message("Take the runes for the \n banishing spell.")
	#emit_signal("tutorial_message_tut", "Take the runes that make up the banishing spell.")
	
func _on_kill_mike():
	animation.play("kill_mike")
	sound.play()
	
func kill_message():
	Hud.message.position.x = 350
	Hud.tutorial_message("Excellent.\nHowever there are more of these beings.\nAnd not all of them will die so easily.")
	$GlyphTimer.start()


func _on_glyph_timer_timeout() -> void:
	Hud.message.position.x = 464
	Hud.tutorial_message("Serve me.\nStep into the circle.\nDestroy the others.")
	$CSGCylinder3D.use_collision = false


func _on_portal_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Hud.tutorial_message("")
		if body.is_in_group("Player"):
			get_tree().change_scene_to_file("res://world.tscn")
