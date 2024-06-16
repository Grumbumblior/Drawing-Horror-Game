extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var music = preload("res://sound/music_manager.tscn").instantiate()
	get_tree().get_root().add_child(music)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	#GameManager.tutorial_music.play()
	$LevelSelect.visible = true
