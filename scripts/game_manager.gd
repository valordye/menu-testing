extends Node


# 1. defining the player variables 
var current_turn: int = 1
var energy: int = 100
var gold: int = 50
var exposure: int = 10 

#reference it to the UI labels so i can update the text on screen 
#when in doubt of a path: drag the node from tree into script by holding CTRL
@onready var stat_display: Label = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/StatDisplay
@onready var train_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/ActionButtons/TrainButton
@onready var study_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/ActionButtons/StudyButton
@onready var end_turn_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/EndTurnButton
@onready var log_display: RichTextLabel = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/LogDisplay


func _ready() -> void: 
	#manual signal connection 
	train_button.pressed.connect(_on_train_button_pressed)
	study_button.pressed.connect(_on_study_button_pressed)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	
	update_ui_text()
	

func update_ui_text():
	# %d means "insert an integer here" the array at the end fills them in order 
	stat_display.text = "DAY: %d\nENERGY: %d/100\nGOLD: %d\nGLOAM EXPOSURE: %d%%" % [current_turn, energy, gold, exposure]
	
	#if energy is less than 20, the button automatically disables itself. 
	train_button.disabled = (energy < 20)
	study_button.disabled = (energy < 20)
	
#handling button clicks: 
func _on_train_button_pressed():
	if energy >=20: 
		energy -= 20
		
		#randomization, roll a 100-sided die 
		var roll: int = randi_range(1,100)
		
		if roll > 80: 
			gold += 50
			exposure += 5
			log_display.text = "CRITICAL FIND! discover hidden cache of coins (+50 Gold)"
		elif roll < 20:
			exposure += 25
			log_display.text = "DANGER: a gust of wind blew a pocket of stagnant Gloam right into your face (+25% Exposure)"
		else:
			exposure += 10
			gold += 15
			log_display.text = "You made steady progress mapping out the perimeter. The air was heavy. "
		update_ui_text() 
		
func _on_study_button_pressed():
	if energy >=20: 
		energy -= 20
		exposure += 10
		print("studied ruins, exposure rose")
		update_ui_text() 
		
		
#advance the state 
func _on_end_turn_button_pressed(): 
	current_turn += 1
	energy = 100 # reset the energy for the new turn 
	print("A new day")
	update_ui_text()
	
