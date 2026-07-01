extends Resource
class_name ScavengeItem 


#the @export keyword exposes these slots directly to the Godot Inspector panel 
@export var item_name: String = "Unknown Relic"
@export var gold_value: int = 10
@export var exposure_risk: int = 5
@export_multiline var discovery_text: String = "You found something in the mud."
