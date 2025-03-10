extends Node

# Dictionary mapping floor numbers to quiz data arrays
var floor_quiz_data = {
	1: [
		{
			"question": "What is the primary purpose of JavaScript?",
			"options": [
				"To style the appearance of a webpage",
				"To add interactivity and dynamic behavior to a webpage",
				"To define the structure of a webpage",
				"To manage server-side operations"
			],
			"correct_answer": 1  # 0-based index
		},
		{
			"question": "Where is JavaScript commonly used?",
			"options": [
				"Only in desktop applications",
				"Primarily in server-side programming",
				"In almost every website to create interactive experiences",
				"Only in mobile applications"
			],
			"correct_answer": 2
		},
		{
			"question": "Which of the following is NOT a common use of JavaScript?",
			"options": [
				"Creating dynamic web applications",
				"Handling server-side logic",
				"Adding animations to webpages",
				"Defining database schemas"
			],
			"correct_answer": 3
		},
		{
			"question": "JavaScript makes the website what?",
			"options": [
				"Load faster",
				"More secure",
				"Come to life",
				"Easier to read by search engines"
			],
			"correct_answer": 2
		}
	],

	# Questions for Floor 2 about JavaScript placement
# Add this to your QuizDataManager.gd in the floor_quiz_data dictionary

2: [
	{
		"question": "What are the two main ways to include JavaScript in an HTML document?",
		"options": [
			"Using CSS and HTML",
			"Using internal <script> tags and external .js files",
			"Using variables and functions",
			"Using HTML comments and metadata"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "When is internal JavaScript most useful?",
		"options": [
			"For large, complex applications",
			"When working with multiple web pages",
			"For small scripts specific to a single page",
			"When creating mobile applications"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "What is the benefit of using external JavaScript files?",
		"options": [
			"They run faster than internal scripts",
			"They keep your HTML cleaner and allow code reuse across multiple pages",
			"They don't require <script> tags",
			"They automatically fix coding errors"
		],
		"correct_answer": 1  # 0-based index (second option)
	}
],
3: [
	{
		"question": "Which method is best suited for debugging and displaying messages in the browser's console?",
		"options": [
			"document.write()",
			"alert()",
			"innerHTML",
			"console.log()"
		],
		"correct_answer": 3  # 0-based index (fourth option)
	},
	{
		"question": "Which method is used to change the content of an HTML element?",
		"options": [
			"console.log()",
			"alert()",
			"innerHTML",
			"document.write()"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "Which method displays a pop-up message in the browser?",
		"options": [
			"document.write()",
			"innerHTML",
			"console.log()",
			"alert()"
		],
		"correct_answer": 3  # 0-based index (fourth option)
	},
	{
		"question": "Which method is generally avoided in modern web development for writing directly to the HTML document?",
		"options": [
			"innerHTML",
			"console.log()",
			"document.write()",
			"alert()"
		],
		"correct_answer": 2  # 0-based index (third option)
	}
]
	# Add more floors as needed
}

# Returns quiz data for a specific floor
func get_quiz_data(floor_number: int) -> Array:
	if floor_quiz_data.has(floor_number):
		return floor_quiz_data[floor_number]
	else:
		printerr("No quiz data found for floor ", floor_number)
		return []

# You can add methods to add/modify quiz data at runtime if needed
func add_floor_quiz(floor_number: int, quiz_array: Array) -> void:
	floor_quiz_data[floor_number] = quiz_array
