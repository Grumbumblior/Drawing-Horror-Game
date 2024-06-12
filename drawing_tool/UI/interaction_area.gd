extends Area3D
class_name InteractionArea

@export var action_name : String = "interact"

var interact: Callable = func():
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionManager.register_area(self)
		print("entered")


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionManager.unregister_area(self)
		print("excitid")
