extends Node

# Dictionary to store quiz scores for each floor
var quiz_scores = {}

# Add or update a quiz score
func set_quiz_score(floor_number: int, score: int, total_questions: int) -> void:
	var percentage = 0
	if total_questions > 0:
		percentage = int((float(score) / float(total_questions)) * 100)
	
	quiz_scores[floor_number] = percentage
	print("Set quiz score for floor ", floor_number, ": ", percentage, "%")


func get_quiz_score(floor_num: int) -> int:
	return quiz_scores.get(floor_num, 0)

# Clear all stored scores
func reset_scores() -> void:
	quiz_scores.clear()
