class_name BattleReward
extends Control

const SHARD_REWARDS = preload("res://Resources/Shards/shard_rewards.tres")
const REWARD_BUTTON = preload("res://Scenes/ui/reward_button.tscn")
const GOLD_ICON := preload("res://Graphics/ui/gold_icon.png")
const GOLD_TEXT := "%s Gold"
const SHARD_TEXT := "%s"

@export var run_stats : RunStats

@onready var rewards : VBoxContainer = %Rewards
@onready var back_button : Button = %BackButton
@onready var party_selector : PartySelector = %PartySelector

var current_party : CurrentParty = GlobalParty.current_party
var total_rewards := 0
var claimed_rewards := 0


func _ready():
	party_selector.hide()
	party_instantiate()
	for node : Node in rewards.get_children():
		node.queue_free()


func add_gold_reward(amount : int) -> void:
	var gold_reward := REWARD_BUTTON.instantiate() as RewardButton
	gold_reward.reward_icon = GOLD_ICON
	gold_reward.reward_text = GOLD_TEXT % amount
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amount))
	rewards.add_child.call_deferred(gold_reward)
	total_rewards += 1


func _on_gold_reward_taken(amount : int) -> void:
	if not run_stats:
		return

	run_stats.gold += amount
	_check_all_rewards_claimed()


func add_shard_reward() -> void:
	var random_shard = SHARD_REWARDS.shards.pick_random()
	var shard_reward := REWARD_BUTTON.instantiate() as RewardButton

	shard_reward.reward_icon = random_shard.icon
	shard_reward.reward_text = SHARD_TEXT % random_shard.id
	
	shard_reward.pressed.connect(_on_shard_reward_taken.bind(random_shard))

	rewards.add_child.call_deferred(shard_reward)
	total_rewards += 1


func _on_shard_reward_taken(shard : Resource) -> void:
	if not shard:
		return

	party_selector.show()
	var party_selector_panels = party_selector.party_menu.get_children()

	for panel : PartySelectorPanel in party_selector_panels:
		if panel != null or hidden:
			panel.set_shard_to_select(shard)

	_check_all_rewards_claimed()


func _check_all_rewards_claimed() -> void:
	claimed_rewards += 1
	if claimed_rewards >= total_rewards:
		back_button.text = "Continue >>"
		back_button.mouse_default_cursor_shape = CURSOR_POINTING_HAND


func party_instantiate() -> void:
	var party = current_party.party_members

	for i in party:
		await i.scene.instantiate()


func _on_back_button_pressed() -> void:
	var run = get_tree().get_root().get_node("Run")
	run.stop_victory_music()
	Events.battle_reward_exited.emit()
