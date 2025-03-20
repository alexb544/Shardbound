extends Node

var inventory : Array = []

func add_item(item : Resource):
	inventory.append(item)

func remove_item(item : Resource):
	inventory.erase(item)

func equip_item(character : Node, item : Resource):
	character.stats.equipment.append(item)
