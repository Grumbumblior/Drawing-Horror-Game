extends Node

@export var nameLength = 3

@onready var runeSequence : Array
@onready var timer = $Timer
var rng = RandomNumberGenerator.new()
var allRunes = ["Fehu", "Ilx", "Jara", "Kaunaz", "Mannaz", "Naudiz", "Raidho", "Thurisaz", "Uruz"]
var collectedRunes = 0
var runeIndex = 0
#var runeNum : int
var castRunes = []

signal game_won
signal game_lost
signal tutorial_message(text : String)
signal rune_collected(runeNum : int)
signal spell_collected(spell: String)
signal jump_scare
signal kill_mike

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shuffle_runes()

func shuffle_runes():
	runeSequence = []
	for i in range(nameLength):
		runeSequence.append(allRunes.pick_random())
		allRunes.shuffle()
	print(runeSequence)

func collect_rune(runeNum : int):
	#self.runeNum = runeNum
	collectedRunes = collectedRunes + 1
	emit_signal("rune_collected", runeNum)
	if runeNum == 0 && get_tree().current_scene.name == "World":
		emit_signal("jump_scare")
	if collectedRunes == nameLength && get_tree().current_scene.name == "Tutorial":
		kill_mike.emit()
		Hud.tutorial_message("Good. Now enscribe them upon the wall.\nPress [Spacebar] when facing a wall to enter draw mode.\n[Left click] to draw, [Right click] to cast.")

func collect_spell(spell : String):
	emit_signal("spell_collected", spell)

func check_won():
	if castRunes == runeSequence:
		if get_tree().current_scene.name == "World":
			game_won.emit()
		elif get_tree().current_scene.name == "Tutorial":
			#TutorialManager.banish()
			
			Hud.tutorial_message("Excellent. \nThere are many more of these beings to destroy.\nNot all of them are so docile.")
			#emit_signal("tutorial_message", )

func game_over():
	game_lost.emit()
