extends Node2D

var harvestable = true

func harvest():
	if harvestable:
		harvestable = false
		get_node("HealingPlant").animation = "harvested"
		return true
	else:
		return false