extends Control
@onready var runePics : Array = []
@onready var label = %Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_won.connect(_on_game_won)
	GameManager.rune_collected.connect(_on_rune_collected)
	var i = 0
	for N in $RunePics.get_children():
		N.texture = load("res://images/%s.png" % GameManager.runeSequence[i])
		runePics.append(N)
		i = i + 1

func get_label():
	return label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_rune_collected(runeNum):
	runePics[runeNum].visible = true

func _on_game_won():
	$Label.visible = true