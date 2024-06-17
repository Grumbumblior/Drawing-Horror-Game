extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://tutorial.tscn")



func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")


func _on_back_pressed() -> void:
	visible = false


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://labrynth.tscn")


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://maze.tscn")
