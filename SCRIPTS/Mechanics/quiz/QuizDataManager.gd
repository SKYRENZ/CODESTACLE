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
],
4: [
	{
		"question": "What is a JavaScript statement?",
		"options": [
			"A comment in the code",
			"A command that the JavaScript interpreter executes",
			"A variable declaration",
			"A type of loop"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "What character is commonly used to end a JavaScript statement?",
		"options": [
			"Colon (:)",
			"Comma (,)",
			"Semicolon (;)",
			"Period (.)"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "What are curly braces {} used for in JavaScript?",
		"options": [
			"To define string literals",
			"To group statements into code blocks",
			"To declare variables",
			"To write comments"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "Which of the following is the best practice for writing JavaScript statements?",
		"options": [
			"Putting as many statements as possible on one line",
			"Always skipping the semicolon (;) at the end",
			"Writing each statement on a new line for readability",
			"Using comments instead of statements"
		],
		"correct_answer": 2  # 0-based index (third option)
	}
],
5: [
	{
		"question": "Which of the following is the correct way to declare a variable in JavaScript?",
		"options": [
			"variable age = 25;",
			"let age = 25;",
			"Age := 25;",
			"25 = age;"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "What is the purpose of the `console.log()` method?",
		"options": [
			"To display an alert box to the user",
			"To write directly to the HTML document",
			"To display messages in the browser's console for debugging",
			"To change the content of an HTML element"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "Which character is used to end most JavaScript statements?",
		"options": [
			":",
			",",
			".",
			";"
		],
		"correct_answer": 3  # 0-based index (fourth option)
	},
	{
		"question": "What is the difference between `==` and `===` in JavaScript?",
		"options": [
			"`==` assigns a value, while `===` compares values",
			"`==` compares values with type conversion, while `===` compares values without type conversion",
			"`===` assigns a value, while `==` compares values",
			"There is no difference"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "How do you write a single-line comment in JavaScript?",
		"options": [
			"`<!-- This is a comment -->`",
			"`// This is a comment`",
			"`/* This is a comment */`",
			"`** This is a comment **`"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "When linking an external JavaScript file, which HTML attribute is used in the `<script>` tag?",
		"options": [
			"`href`",
			"`link`",
			"`src`",
			"`url`"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "What do curly braces `{}` signify in JavaScript?",
		"options": [
			"String literals",
			"Comments",
			"Code blocks",
			"Arrays"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "Which keyword is used to declare a variable whose value cannot be changed after it's assigned?",
		"options": [
			"`var`",
			"`let`",
			"`const`",
			"`static`"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "Which of the following is NOT a JavaScript operator?",
		"options": [
			"`+`",
			"`=`",
			"`#`",
			"`==`"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "JavaScript is case-sensitive. True or False?",
		"options": [
			"True",
			"False",
			"Sometimes",
			"Only in strict mode"
		],
		"correct_answer": 0  # 0-based index (first option)
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
