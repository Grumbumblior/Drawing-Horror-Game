extends Node

@export var nameLength = 3

@onready var runeSequence : Array

var rng = RandomNumberGenerator.new()
var allRunes = ["Fehu", "Ilx", "Jara", "Kaunaz", "Mannaz", "Naudiz", "Raidho", "Thurisaz", "Uruz"]
var runeIndex = 0
#var runeNum : int
var castRunes = []

signal game_won
signal rune_collected(runeNum : int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	runeSequence = []
	for i in range(nameLength):
		runeSequence.append(allRunes.pick_random())
		allRunes.shuffle()
	print(runeSequence)
		
func collect_rune(runeNum : int):
	#self.runeNum = runeNum
	emit_signal("rune_collected", runeNum)

func check_won():
	if castRunes == runeSequence:
		game_won.emit()
