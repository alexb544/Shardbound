extends Node

var current_run_id : int = 0
var shards_found   : Array = [] # List of shards collected 
var party_members  : Array = [] # List of characters in party
var run_data       : Dictionary = {} # Custom key-value pairs for run info

func _ready() -> void:
	print("Game Manager Loaded")


## New Run Management #########################################################
func generate_new_run_id():
	current_run_id = randi()
	run_data = {}
	shards_found.clear()
	party_members.clear()
	print("New Seed Generated! ID: ", current_run_id)

#### Item Management ##########################################################
func add_shard(shard_id : String):
	if shard_id not in shards_found:
		shards_found.append(shard_id)
		print("Shard Added: ", shard_id)
	else:
		return

func has_shard(shard_id : String) -> bool:
	return shard_id in shards_found

#### Party Management #########################################################
func add_party_member(member_name : String):
	if member_name not in party_members:
		party_members.append(member_name)
		print("Added Party Member: ", member_name)

func remove_party_member(member_name : String):
	if member_name in party_members:
		party_members.erase(member_name)
		print("Removed Party Member: ", member_name)

#### Run Data Management ######################################################
func set_run_data(key : String, value):
	run_data[key] = value

func get_run_data(key : String, default = null):
	return run_data.get(key, default)

func reset_run():
	generate_new_run_id()
