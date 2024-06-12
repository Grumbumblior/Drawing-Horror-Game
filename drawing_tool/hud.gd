extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_won.connect(_on_game_won)
	var i = 0
	for N in $RunePics.get_children():
		N.texture = load("res://images/%s.png" % GameManager.runeSequence[i])
		i = i + 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_game_won():
	$Label.visible = true
