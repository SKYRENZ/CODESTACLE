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
		},
		{
			"question": "What is the role of JavaScript in web development?",
			"options": [
				"To store data in databases",
				"To add interactivity and control webpage behavior",
				"To handle server requests exclusively",
				"To design the layout of a webpage"
			],
			"correct_answer": 1
		},
		{
			"question": "Which of the following is an example of JavaScript functionality?",
			"options": [
				"Changing text color permanently",
				"Displaying a pop-up message when clicking a button",
				"Structuring the content on a webpage",
				"Styling elements with gradients"
			],
			"correct_answer": 1
		},
		{
			"question": "'Alert', 'Prompt', and 'Confirm' are examples of what in JavaScript?",
			"options": [
				"Data types",
				"Built-in functions for user interaction",
				"CSS properties",
				"HTML attributes"
			],
			"correct_answer": 1
		},
		{
			"question": "'Dynamic' means what in the context of JavaScript?",
			"options": [
				"Changing content or behavior based on user interaction",
				"Creating static web pages that do not change",
				"Handling server-side operations only",
				"Designing fixed layouts for websites"
			],
			"correct_answer": 0
		}
	],
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
		},
		{
			"question": "What HTML tag is used to embed JavaScript code directly within an HTML document?",
			"options": [
				"<js>",
				"<script>",
				"<javascript>",
				"<embed>"
			],
			"correct_answer": 1  # 0-based index (second option)
		},
		{
			"question": "Which attribute is used to link an external JavaScript file to an HTML document?",
			"options": [
				"href",
				"src",
				"link",
				"url"
			],
			"correct_answer": 1  # 0-based index (second option)
		},
		{
			"question": "Where is the <script> tag typically placed in an HTML document?",
			"options": [
				"Only in the <body> section",
				"Only in the <head> section",
				"Either in the <head> or <body> section",
				"Only outside the <html> tag"
			],
			"correct_answer": 2  # 0-based index (third option)
		},
		{
			"question": "When is it generally better to use an external JavaScript file?",
			"options": [
				"For very small scripts specific to one page",
				"When you want to reuse the same code across multiple pages",
				"When you don't have access to an external server",
				"When you want to make your HTML file larger"
			],
			"correct_answer": 1  # 0-based index (second option)
		},
		{
			"question": "What is a benefit of placing your <script> tags just before the closing </body> tag?",
			"options": [
				"It makes your code harder to read",
				"It ensures all HTML elements have loaded before the script runs",
				"It hides the script from the browser",
				"It increases page load time"
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
			},
			{
				"question": "What happens if you use `document.write()` after the page has fully loaded?",
				"options": [
					"It updates a specific element",
					"It opens a new tab",
					"It overwrites the entire HTML document",
					"It logs a message in the console"
				],
				"correct_answer": 2  # 0-based index (third option)
			},
			{
				"question": "Which output method is best for updating the score on a game web page in real-time?",
				"options": [
					"alert()",
					"innerHTML",
					"document.write()",
					"console.log()"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "Which method would you use to show a welcome message only to the developer, not the user?",
				"options": [
					"alert()",
					"innerHTML",
					"console.log()",
					"document.write()"
				],
				"correct_answer": 2  # 0-based index (third option)
			},
			{
				"question": "Which method interrupts the user and requires them to click \"OK\" before continuing?",
				"options": [
					"alert()",
					"innerHTML",
					"console.log()",
					"document.write()"
				],
				"correct_answer": 0  # 0-based index (first option)
			}
	],
	4: [
			{
				"question": "What is a JavaScript statement?",
				"options": [
					"A comment in the code",
					"A command the interpreter executes",
					"A CSS style rule",
					"A type of HTML tag"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "What character typically ends a JavaScript statement?",
				"options": [
					":",
					";",
					",",
					"}"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "What is the purpose of curly braces `{}` in JavaScript?",
				"options": [
					"To define arrays",
					"To group statements into code blocks",
					"To write comments",
					"To declare variables"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "Which is the best practice for writing statements?",
				"options": [
					"Use one line for all statements",
					"Add semicolons explicitly",
					"Never use code blocks",
					"Use `var` for all variables"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "What happens if you omit semicolons in JavaScript?",
				"options": [
					"The code always fails",
					"The engine auto-inserts them, but errors may occur",
					"The code runs faster",
					"Curly braces become optional"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "Which code block is correctly formatted?",
				"options": [
					"`{let x=5; console.log(x)}`",
					"`{ let x = 5; console.log(x); }`",
					"`{ let x = 5 console.log(x) }`",
					"`( let x = 5; console.log(x) )`"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "Why should variables be declared at the start of their scope?",
				"options": [
					"To improve readability and avoid hoisting issues",
					"To slow down execution",
					"To make the code longer",
					"To use fewer semicolons"
				],
				"correct_answer": 0  # 0-based index (first option)
			},
			{
				"question": "Which statement declares a constant variable?",
				"options": [
					"`let x = 5;`",
					"`var x = 5;`",
					"`const x = 5;`",
					"`x = 5;`"
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
	],
	6: [
				{
					"question": "What are comments used for in JavaScript code?",
					"options": [
						"To be executed by the JavaScript interpreter",
						"To make the code easier for humans to read and understand",
						"To define variables",
						"To speed up code execution"
					],
					"correct_answer": 1  # 0-based index (second option)
				},
				{
					"question": "How do you write a single-line comment in JavaScript?",
					"options": [
						"#",
						"<!-- -->",
						"//",
						"/* */"
					],
					"correct_answer": 2  # 0-based index (third option)
				},
				{
					"question": "Which of the following is the correct way to write a multi-line comment in JavaScript?",
					"options": [
						"// This is a multi-line comment //",
						"<!-- This is a multi-line comment -->",
						"/* This is a multi-line comment */",
						"** This is a multi-line comment **"
					],
					"correct_answer": 2  # 0-based index (third option)
				},
				{
					"question": "Why should you use comments in your code?",
					"options": [
						"To explain complex logic or the purpose of functions",
						"To make the code run faster",
						"To declare new variables",
						"To execute alternative code"
					],
					"correct_answer": 0  # 0-based index (first option)
				},
				{
					"question": "What does 'commenting out' code mean?",
					"options": [
						"Deleting code permanently",
						"Temporarily disabling code for testing or debugging",
						"Turning code into a string",
						"Encrypting code"
					],
					"correct_answer": 1  # 0-based index (second option)
				},
				{
					"question": "Which of the following statements about comments is true?",
					"options": [
						"Comments are executed by the JavaScript interpreter",
						"Comments can help others understand your code",
						"Comments should always explain what the code does, not why",
						"Comments are required for every line of code"
					],
					"correct_answer": 1  # 0-based index (second option)
				}
	],
	7: [
				{
					"question": "What is a variable in JavaScript?",
					"options": [
						"A comment in the code",
						"A named storage location that can hold a value",
						"A type of loop",
						"A reserved keyword"
					],
					"correct_answer": 1  # 0-based index (second option)
				},
				{
					"question": "Which keyword is used to declare a variable in older JavaScript code?",
					"options": [
						"let",
						"const",
						"var",
						"variable"
					],
					"correct_answer": 2  # 0-based index (third option)
				},
				{
					"question": "Which of the following is a valid variable name?",
					"options": [
						"123name",
						"my-variable",
						"myVariable",
						"my Variable"
					],
					"correct_answer": 2  # 0-based index (third option)
				},
				{
					"question": "What is the assignment operator used for?",
					"options": [
						"To compare two values",
						"To declare a variable",
						"To assign a value to a variable",
						"To perform arithmetic operations"
					],
					"correct_answer": 2  # 0-based index (third option)
				},
				{
					"question": "What is camelCase used for?",
					"options": [
						"To write comments",
						"To name functions",
						"To name multi-word variables in a readable way",
						"To define strings"
					],
					"correct_answer": 2  # 0-based index (third option)
				},
				{
					"question": "Which of the following is NOT a valid way to start a variable name in JavaScript?",
					"options": [
						"_myVar",
						"$myVar",
						"2myVar",
						"myVar"
					],
					"correct_answer": 2  # 0-based index (third option)
				},
				{
					"question": "What is the difference between `let` and `var` in modern JavaScript?",
					"options": [
						"`let` is used for constant values, `var` is not",
						"`let` provides block scope, `var` provides function scope",
						"`var` is only for numbers, `let` is for strings",
						"There is no difference"
					],
					"correct_answer": 1  # 0-based index (second option)
				},
				{
					"question": "Which variable declaration is preferred for values that should not change?",
					"options": [
						"var",
						"let",
						"const",
						"variable"
					],
					"correct_answer": 2  # 0-based index (third option)
				}
	],
	8: [
			{
				"question": "Which version of JavaScript introduced the `let` keyword?",
				"options": [
					"ES3",
					"ES5",
					"ES6 (2015)",
					"ES2020"
				],
				"correct_answer": 2  # 0-based index (third option)
			},
			{
				"question": "What kind of scope does a variable declared with `let` have?",
				"options": [
					"Global scope",
					"Function scope",
					"Block scope",
					"No scope"
				],
				"correct_answer": 2  # 0-based index (third option)
			},
			{
				"question": "What happens if you try to access a `let` variable before it is declared?",
				"options": [
					"It returns `undefined`",
					"It throws a ReferenceError",
					"It returns `null`",
					"It is automatically declared"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "Can you redeclare a variable with `let` in the same block scope?",
				"options": [
					"Yes",
					"No"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "Which of the following is a correct way to declare a variable using `let`?",
				"options": [
					"let score = 100;",
					"let: score = 100;",
					"variable score = 100;",
					"var score = 100;"
				],
				"correct_answer": 0  # 0-based index (first option)
			},
			{
				"question": "What is a \"block\" in JavaScript?",
				"options": [
					"A single line of code",
					"A sequence of code enclosed in curly braces `{}`",
					"A comment",
					"A reserved keyword"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "Which statement about `let` vs. `var` is true?",
				"options": [
					"`var` has block scope, `let` has function scope",
					"Both `let` and `var` have block scope",
					"`let` has block scope, `var` has function scope",
					"Both are deprecated"
				],
				"correct_answer": 2  # 0-based index (third option)
			},
			{
				"question": "What is the \"temporal dead zone\" (TDZ) in the context of `let`?",
				"options": [
					"The time before a variable is assigned a value",
					"The period between entering a block and the variable's declaration, when the variable cannot be accessed",
					"The time after a variable is deleted",
					"The scope of a global variable"
				],
				"correct_answer": 1  # 0-based index (second option)
			}
		],
	9: [
			{
				"question": "What is the main purpose of the `const` keyword in JavaScript?",
				"options": [
					"To declare variables that can be reassigned",
					"To declare variables that cannot be reassigned",
					"To declare variables with global scope",
					"To declare variables with function scope"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "When must you assign a value to a `const` variable?",
				"options": [
					"Before the program starts",
					"Anytime before it's used",
					"When you declare it",
					"When the block ends"
				],
				"correct_answer": 2  # 0-based index (third option)
			},
			{
				"question": "What happens if you try to reassign a value to a `const` variable?",
				"options": [
					"The value is updated",
					"An error occurs",
					"The variable is deleted",
					"The value is assigned a new type"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "What is the scope of a `const` variable?",
				"options": [
					"Global scope",
					"Function scope",
					"Block scope",
					"No scope"
				],
				"correct_answer": 2  # 0-based index (third option)
			},
			{
				"question": "If a `const` variable holds an object, can you modify the properties of that object?",
				"options": [
					"No, the object is completely immutable",
					"Yes, you can modify the properties, but you can't reassign the variable to a different object",
					"Yes, you can reassign and modify",
					"Only if the object is not frozen"
				],
				"correct_answer": 1  # 0-based index (second option)
			},
			{
				"question": "What happens if you declare a `const` variable without assigning a value?",
				"options": [
					"It is set to `undefined`",
					"It is hoisted to the top of the scope",
					"A SyntaxError occurs",
					"It is automatically assigned a default value"
				],
				"correct_answer": 2  # 0-based index (third option)
			},
			{
				"question": "Which of the following is a correct way to declare a constant in JavaScript?",
				"options": [
					"`const PI = 3.14;`",
					"`const PI; PI = 3.14;`",
					"`constant PI = 3.14;`",
					"`let PI = 3.14;`"
				],
				"correct_answer": 0  # 0-based index (first option)
			},
			{
				"question": "Why is it considered best practice to use `const` by default?",
				"options": [
					"It makes code run faster",
					"It prevents accidental reassignment of values that shouldn't change",
					"It allows variables to be used before declaration",
					"It creates global variables"
				],
				"correct_answer": 1  # 0-based index (second option)
			}
		],
	10: [
		{
			"question": "How do you write a single-line comment in JavaScript?",
			"options": [
				"<!-- Comment -->",
				"// Comment",
				"/* Comment */",
				"** Comment **"
			],
			"correct_answer": 1  # 0-based index (second option)
		},
		{
			"question": "Which keyword is used to declare a variable that cannot be reassigned?",
			"options": [
				"var",
				"let",
				"const",
				"dynamic"
			],
			"correct_answer": 2  # 0-based index (third option)
		},
		{
			"question": "What is the scope of a variable declared with let?",
			"options": [
				"Global",
				"Function",
				"Block",
				"File"
			],
			"correct_answer": 2  # 0-based index (third option)
		},
		{
			"question": "Which of the following is NOT a valid variable name?",
			"options": [
				"myVar",
				"_myVar",
				"1myVar",
				"$myVar"
			],
			"correct_answer": 2  # 0-based index (third option)
		},
		{
			"question": "Which of the following is a valid multi-line comment?",
			"options": [
				"// This is a comment //",
				"/* This is a comment */",
				"<!-- This is a comment -->",
				"** This is a comment **"
			],
			"correct_answer": 1  # 0-based index (second option)
		},
		{
			"question": "Which data type represents textual data?",
			"options": [
				"Number",
				"Boolean",
				"String",
				"Object"
			],
			"correct_answer": 2  # 0-based index (third option)
		},
		{
			"question": "Which data type represents a logical value (true or false)?",
			"options": [
				"Number",
				"String",
				"Boolean",
				"Undefined"
			],
			"correct_answer": 2  # 0-based index (third option)
		},
		{
			"question": "How would you declare a constant variable named MAX_VALUE with a value of 100?",
			"options": [
				"let MAX_VALUE = 100;",
				"const MAX_VALUE = 100;",
				"var MAX_VALUE = 100;",
				"MAX_VALUE = 100;"
			],
			"correct_answer": 1  # 0-based index (second option)
		},
		{
			"question": "Which data type represents an ordered collection of values?",
			"options": [
				"Object",
				"String",
				"Number",
				"Array"
			],
			"correct_answer": 3  # 0-based index (fourth option)
		},
		{
			"question": "Which data type represents a variable that has been declared but not assigned a value?",
			"options": [
				"Null",
				"String",
				"Undefined",
				"Boolean"
			],
			"correct_answer": 2  # 0-based index (third option)
		},
		{
			"question": "Which is the best practice way to name a JS variable?",
			"options": [
				"The quick brown fox",
				"the_quick_brown_fox",
				"TheQuickBrownFox",
				"theQuickBrownFox"
			],
			"correct_answer": 3  # 0-based index (fourth option)
		},
		{
			"question": "How can you ensure that a JS variable remain unchangeable for the duration of the code?",
			"options": [
				"let",
				"const",
				"var",
				"cant be done"
			],
			"correct_answer": 1  # 0-based index (second option)
		},
		{
			"question": "Which is the best type of output for debugging?",
			"options": [
				"alert()",
				"document.write()",
				"innerHTML",
				"console.log()"
			],
			"correct_answer": 3  # 0-based index (fourth option)
		}
	]
}

# Function to get random questions for a floor
func get_random_questions(floor_number: int, num_questions: int) -> Array:
	randomize() # Seed the random number generator
	var all_questions = floor_quiz_data.get(floor_number, [])
	if all_questions == null:
		printerr("Error: No quiz data found for floor number: ", floor_number)
		return []

	var selected_questions = []
	var available_questions = all_questions.duplicate()

	# Shuffle the available questions
	available_questions.shuffle()

	# Select the first 'num_questions' questions from the shuffled array
	for i in range(min(num_questions, available_questions.size())):
		selected_questions.append(available_questions[i])

	return selected_questions

# Function to get quiz data for a specific floor
func get_quiz_data(floor_number: int) -> Array:
	return get_random_questions(floor_number, 4) # Get 4 random questions

func _ready():
	# Example usage: Get 4 random questions for Floor 1
	var random_questions = get_quiz_data(1)
	print(random_questions)
