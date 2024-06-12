extends Node

@export var nameLength = 3

@onready var runeSequence : Array

var rng = RandomNumberGenerator.new()
var allRunes = ["Fehu", "Ilx", "Jara", "Kaunaz", "Mannaz", "Naudiz", "Raidho", "Thurisaz", "Uruz"]

var castRunes = []

signal game_won
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	runeSequence = []
	for i in range(nameLength):
		runeSequence.append(allRunes.pick_random())
		allRunes.shuffle()
	print(runeSequence)
		
	
func _process(delta: float) -> void:
	if castRunes == runeSequence:
		game_won.emit()
