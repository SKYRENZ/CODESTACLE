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
],
6: [
	{
		"question": "What is the purpose of comments in JavaScript code?",
		"options": [
			"To be executed by the JavaScript interpreter",
			"To make the code run faster",
			"To explain the code and make it more readable",
			"To define variables"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "How do you start a single-line comment in JavaScript?",
		"options": [
			"/*",
			"*/",
			"//",
			"--"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "How do you start a multi-line comment in JavaScript?",
		"options": [
			"//",
			"/*",
			"<!--",
			"**"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "Which of the following is a good use of comments?",
		"options": [
			"To write the same code in multiple languages",
			"To explain the *what* instead of the *why* of the code",
			"To explain complex logic and provide helpful information for debugging",
			"To impress other programmers"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "What is 'commenting out' code?",
		"options": [
			"Deleting code permanently",
			"Temporarily disabling code for testing or debugging",
			"Turning code into a string",
			"Encrypting code"
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
		"question": "Which keyword is used to declare a variable (in older JavaScript code)?",
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
	}
],
8: [
	{
		"question": "What kind of scope does the let keyword have in JavaScript?",
		"options": [
			"Global scope",
			"Function scope",
			"Block scope",
			"No scope"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "What happens if you try to redeclare a variable using let in the same scope?",
		"options": [
			"The value gets updated",
			"An error occurs",
			"The second declaration is ignored",
			"The variable becomes undefined"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "Which of the following correctly declares a variable with let?",
		"options": [
			"let myVar = 5;",
			"variable myVar = 5;",
			"let: myVar = 5;",
			"var myVar = 5;"
		],
		"correct_answer": 0  # 0-based index (first option)
	},
	{
		"question": "What is a 'block' in JavaScript?",
		"options": [
			"A line of code",
			"A sequence of code enclosed in curly braces {}",
			"A comment",
			"A reserved keyword"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "Which statement about let vs. var is true?",
		"options": [
			"var has block scope, while let has function scope",
			"let has block scope, while var has function scope",
			"Both let and var have block scope",
			"Both let and var have global scope"
		],
		"correct_answer": 1  # 0-based index (second option)
	}
],
9: [
	{
		"question": "What is the main purpose of the const keyword?",
		"options": [
			"To declare variables that can be reassigned",
			"To declare variables that cannot be reassigned",
			"To declare variables with global scope",
			"To declare variables with function scope"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "When must you assign a value to a const variable?",
		"options": [
			"Before the program starts",
			"Anytime before it's used",
			"When you declare it",
			"When the block ends"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "What happens if you try to reassign a value to a const variable?",
		"options": [
			"The value is updated",
			"An error occurs",
			"The variable is deleted",
			"The value is assigned a new type"
		],
		"correct_answer": 1  # 0-based index (second option)
	},
	{
		"question": "What is the scope of a const variable?",
		"options": [
			"Global scope",
			"Function scope",
			"Block scope",
			"No scope"
		],
		"correct_answer": 2  # 0-based index (third option)
	},
	{
		"question": "If a const variable holds an object, can you modify the properties of that object?",
		"options": [
			"No, the object is completely immutable",
			"Yes, you can modify the properties, but you can't reassign the variable to a different object",
			"Yes, you can reassign and modify",
			"Only if the object is not frozen"
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
	},
	{
		"question": "What do you called value that can be \"true\" or \"false?\"",
		"options": [
			"null",
			"bolean",
			"object",
			"string"
		],
		"correct_answer": 1  # 0-based index (second option - although it should probably be "Boolean" with capital B)
	},
	{
		"question": "what does // do?",
		"options": [
			"declares array",
			"nothing",
			"singe-line comment",
			"makes the site crash"
		],
		"correct_answer": 2  # 0-based index (third option)
	}
],
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
