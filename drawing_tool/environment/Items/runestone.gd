extends CSGBox3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var runeDecal = $Decal
@export var runeNum = 0

signal rune_collected(runeNum)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_rune(GameManager.runeSequence[runeNum])
	interaction_area.interact = Callable(self, "_on_interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_rune(chosenRune):
	runeDecal.texture_albedo = load("res://images/%s.png" % chosenRune)
	runeDecal.texture_emission = load("res://images/%s.png" % chosenRune)

func _on_interact():
	GameManager.collect_rune(runeNum)
	queue_free()
