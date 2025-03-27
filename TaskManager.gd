extends Node

var current_floor = "floor_1"
var completed_tasks = []
var signs_read = 0

var floor_sign_requirements = {
	"floor_1": 3,
	"floor_2": 5
}

var tasks = {
	"floor_1": ["Read at least 3 signs"],
	"floor_2": ["Read at least 5 signs"]
}

func get_tasks():
	return tasks.get(current_floor, [])

func get_required_signs():
	return floor_sign_requirements.get(current_floor, 3)

func complete_task(task):
	if task in get_tasks() and task not in completed_tasks:
		completed_tasks.append(task)
		return true
	return false

func read_sign():
	signs_read += 1
	print("📜 Sign read! Progress:", signs_read, "/", get_required_signs())

	if signs_read >= get_required_signs():
		var task_name = "Read at least " + str(get_required_signs()) + " signs"
		if task_name not in completed_tasks:
			complete_task(task_name)

		# 🔥 Update TaskBoard
		var task_board = get_tree().get_first_node_in_group("task_board")
		if task_board:
			task_board.update_task_board()
			print("✅ TaskBoard updated!")
		else:
			print("❌ TaskBoard NOT found in the scene tree!")


func change_floor(new_floor):
	current_floor = new_floor
	signs_read = 0  # Reset sign progress
	update_task_board()

# ✅ Fix: Make sure TaskBoard is found dynamically
func update_task_board():
	var task_board = get_tree().get_first_node_in_group("task_board")
	if task_board:
		task_board.update_task_board()
		print("🔄 TaskBoard updated after reading sign!")
	else:
		print("❌ TaskBoard not found in the scene tree!")
