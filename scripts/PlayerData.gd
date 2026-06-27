extends RefCounted
class_name PlayerData 

#the data (no one touching this but the script) 
var current_turn: int = 1
var energy: int = 100
var gold: int = 50
var exposure: int = 0 

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
	
func advance_day() -> void: 
	current_turn += 1
	energy = 100 #resetting the energy for the new turn 
