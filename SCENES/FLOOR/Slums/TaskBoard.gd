extends Control

@onready var task_label = $TaskLabel  # Make sure TaskLabel exists!

func _ready():
	visible = true  # 🔥 Ensure visibility
	modulate.a = 1  # 🔥 Ensure opacity is 100%
	print("✅ TaskBoard is READY! Visibility:", visible)

func _process(delta):
	visible = true  # 🔥 Force it visible every frame

func update_task_board():
	visible = true  # 🔥 Ensure UI shows up
	var task_manager = get_node("/root/TaskManager")
	var tasks = task_manager.get_tasks()
	var completed_tasks = task_manager.completed_tasks
	
	# Update the task list
	var task_text = "Tasks:\n"
	for task in tasks:
		if task in completed_tasks:
			task_text += "✅ " + task + "\n"
		else:
			task_text += "❌ " + task + "\n"

	task_label.text = task_text
	print("📋 TaskBoard updated!")
