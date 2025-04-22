extends Node

var coin_count: int = 0

signal coin_count_updated  # Signal to notify when the coin count changes

func add_coin() -> void:
	coin_count += 1
	print("Coins picked up:", coin_count)
	emit_signal("coin_count_updated", coin_count)  # Emit the signal

	# Update PlayerData
	var player_data = get_node_or_null("/root/PlayerData")
	if player_data:
		player_data.increment_coins_collected()
