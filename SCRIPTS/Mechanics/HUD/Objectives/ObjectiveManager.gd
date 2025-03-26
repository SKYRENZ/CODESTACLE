extends Node

signal objective_updated(signage_current: int, signage_total: int, npc_current: int, npc_total: int)

var total_signage = 0
var total_npcs = 0
var current_read = 0
var current_npcs_interacted = 0

func set_total_objectives(signage_count, npc_count):
	total_signage = signage_count
	total_npcs = npc_count
	current_read = 0
	current_npcs_interacted = 0
	emit_signal("objective_updated", current_read, total_signage, current_npcs_interacted, total_npcs)
	print("ObjectiveManager: Signal emitted", current_read, total_signage, current_npcs_interacted, total_npcs)

func increment_signage_read():
	if current_read < total_signage:
		current_read += 1
		print("ObjectiveManager: Incrementing signage read to", current_read, "/", total_signage)
		emit_signal("objective_updated", current_read, total_signage, current_npcs_interacted, total_npcs)

func increment_npc_interacted():
	if current_npcs_interacted < total_npcs:
		current_npcs_interacted += 1
		print("ObjectiveManager: Incrementing NPC interactions to", current_npcs_interacted, "/", total_npcs)
		emit_signal("objective_updated", current_read, total_signage, current_npcs_interacted, total_npcs)
