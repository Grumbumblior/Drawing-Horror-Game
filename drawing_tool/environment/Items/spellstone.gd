extends CSGBox3D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var spellDecal = $Decal
@export var spell : String = "Tele"

signal spell_collected(spell)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_spell(spell)
	interaction_area.interact = Callable(self, "_on_interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_spell(chosenSpell):
	spellDecal.texture_albedo = load("res://images/%s.png" % chosenSpell)
	spellDecal.texture_emission = load("res://images/%s.png" % chosenSpell)

func _on_interact():
	GameManager.collect_spell(spell)
	queue_free()
