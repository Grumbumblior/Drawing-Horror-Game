extends CSGBox3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var rune_decal = $Decal
@export var rune_num : int = 0

signal rune_collected(rune)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.runes_shuffled.connect(show_rune)
	#show_rune(GameManager.runeSequence[rune_num])
	interaction_area.interact = Callable(self, "_on_interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_rune():
	var chosen_rune = GameManager.runeSequence[rune_num]
	rune_decal.texture_albedo = load("res://images/%s.png" % chosen_rune)
	rune_decal.texture_emission = load("res://images/%s.png" % chosen_rune)

func _on_interact():
	GameManager.collect_rune(rune_num)
	queue_free()
