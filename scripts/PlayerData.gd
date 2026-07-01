extends RefCounted
class_name PlayerData 

#the data (no one touching this but the script) 
var current_turn: int = 1
var energy: int = 100
var gold: int = 50
var exposure: int = 0 

#define a custom signal 
signal dangerous_exposure_reached

#the logic 
func spend_energy(amount: int) -> bool: 
	if energy >= amount: 
		energy -= amount
		return true #we allow this action 
	return false #not enough energy 
	
func gain_gold(amount: int) -> void:
	gold += amount 
	
func increase_exposure(amount: int) -> void:
	exposure = clampi(exposure + amount, 0, 100) # prevents going over 100% 
	
	#automatic trigger: if math hits 50+, trigger 
	if exposure >= 50:
		dangerous_exposure_reached.emit() 
		#player data will fire this signal as long as increase exposure
		#crosses the desired number
	
func advance_day() -> void: 
	current_turn += 1
	energy = 100 #resetting the energy for the new turn 
