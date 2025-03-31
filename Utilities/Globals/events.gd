extends Node

# Party-related events


# Enemy-related events


# Battle-related events
signal battle_over_screen_requested(text : String, type : BattleOverPanel.Type)
signal battle_won

# Map-related events
signal map_exited

# Town-releated events
signal town_exited

# Battle Reward-related events
signal battle_reward_exited

# Treasure Room-related events
signal loot_room_exited