extends Node

#create an instance of the playerdata class 
var stats: PlayerData = PlayerData.new()

#reference it to the UI labels so i can update the text on screen 
#when in doubt of a path: drag the node from tree into script by holding CTRL
@onready var stat_display: Label = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/StatDisplay
@onready var end_turn_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/EndTurnButton
@onready var log_display: RichTextLabel = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/LogDisplay

#action buttons 
@onready var train_button: Button = %TrainButton
@export var study_button: Button

#Location Panel Reference
@onready var karsin_panel: VBoxContainer = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/LocationManager/KarsinPanel
@onready var scarsind_panel: VBoxContainer = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/LocationManager/ScarsindPanel

#navigation References
@onready var travel_to_ruins_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/LocationManager/KarsinPanel/ActionButtons/TravelToRuinsButton
@onready var travel_to_town_button: Button = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/LocationManager/ScarsindPanel/HBoxContainer/TravelToTownButton

#modal nodes 
@onready var modal_overlay: ColorRect = %ModalOverlay
@onready var popup_text: Label = %PopupText
@onready var close_popup_button: Button = %ClosePopupButton


func _ready() -> void: 
	#manual signal connection 
	train_button.pressed.connect(_on_train_button_pressed)
	study_button.pressed.connect(_on_study_button_pressed)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	
	#connect navigation buttons 
	travel_to_ruins_button.pressed.connect(_on_travel_to_ruins_pressed)
	travel_to_town_button.pressed.connect(_on_travel_to_town_pressed)
	
	#connect modal close button 
	close_popup_button.pressed.connect(_on_close_popup_pressed)
	
	update_ui_text()
	
#the view: this function takes data from 'stats' and plasters in on screen 
func update_ui_text():
	# %d means "insert an integer here" the array at the end fills them in order 
	stat_display.text = "DAY: %d\nENERGY: %d/100\nGOLD: %d\nGLOAM EXPOSURE: %d%%" % [
		stats.current_turn,
		stats.energy,
		stats.gold,
		stats.exposure
	]
	
	#if energy is less than 20, the button automatically disables itself. 
	train_button.disabled = (stats.energy < 20)
	study_button.disabled = (stats.energy < 20)
	
#navigation logic 
func _on_travel_to_ruins_pressed() -> void:
	#Hide the town UI, show ruins UI
	karsin_panel.visible = false 
	scarsind_panel.visible = true 
	log_display.text = "Stepped past iron gates of Karsin, entering Scarsind"
	
func _on_travel_to_town_pressed() -> void: 
	scarsind_panel.visible = false 
	karsin_panel.visible = true 
	log_display.text = "You retreat back through the safety gates."

#handling button clicks: 
#buttons will not do math when we made PlayerData. it asks if an action is allowed 
func _on_train_button_pressed():
	if stats.spend_energy(20):
		stats.gain_gold(15) #tell brain what happened 
		log_display.text = "worked at the docks, earned gold"
		#randomization, roll a 100-sided die 
		#var roll: int = randi_range(1,100)
		#if roll > 80: 
			#gold += 50
			#exposure += 5
			#log_display.text = "CRITICAL FIND! discover hidden cache of coins (+50 Gold)"
		#elif roll < 20:
			#exposure += 25
			#log_display.text = "DANGER: a gust of wind blew a pocket of stagnant Gloam right into your face (+25% Exposure)"
		#else:
			#exposure += 10
			#gold += 15
			#log_display.text = "You made steady progress mapping out the perimeter. The air was heavy. "
		update_ui_text() 
		
func _on_study_button_pressed():
	if stats.spend_energy(20):
		stats.increase_exposure(10)
		log_display.text = "Studied the ruins map. Exposure rose"
		
		#trigger modal: check if exposure is getting bad 
		if stats.exposure >= 50:
			trigger_silas_event()
		
		update_ui_text() 
		
#function to activate overlay shield 
func trigger_silas_event() -> void: 
	popup_text.text = "SILAS blocks your path, yo gimme ur money twin \n(Silas takes 20 Gold gng)"
	stats.gold = max(0, stats.gold - 20) #penalty logic 
	
	#open modal window 
	modal_overlay.visible = true 
		
func _on_close_popup_pressed() -> void: 
	#hide the shield, returning input focus 
	modal_overlay.visible = false
	log_display.text = "Silas scuttles back into guild hall"
	update_ui_text()

#advance the state 
func _on_end_turn_button_pressed(): 
	stats.advance_day()
	log_display.text = "A new day dawns..."
	update_ui_text()
	
