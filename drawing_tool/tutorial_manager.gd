extends Node3D

signal tutorial_message_tut(text : String)
signal spawn_tutorial_runes()
# Called when the node enters the scene tree for the first time.
@onready var mike = $Mike


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
	Hud.tutorial_message("Take the runes for the \n banishing spell.")
	#emit_signal("tutorial_message_tut", "Take the runes that make up the banishing spell.")
	
func banish():
	mike.visible = false
	