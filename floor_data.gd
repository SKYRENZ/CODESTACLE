extends Node

var floor_templates = {
	11: { 
		"sentence_template": ["let x = [_];", "console.log(x + 5);", "The outcome is: 17"] ,
		"valid_items": ["12"]
	},
	12: { 
		"sentence_template": ["const x = [_];", "const y = x + [_];", "console.log(y);", "The outcome is: 12"] ,
		"valid_items": ["10", "2"]
	},
	13: {
		"sentence_template": ["var a = [_];", "var b = a * [_];", "console.log(b);", "The outcome is: 15"] ,
		"valid_items": ["5", "3"]
	},
	14: {
		"sentence_template": ["function add(a, b) {", "  return a + [_];", "}", "console.log(add(5, 3));", "The outcome is: 8"] ,
		"valid_items": ["b"]
	},
	15: {
		"sentence_template": ["let sum = 10 + [_];", "console.log(sum);", "The outcome is: 15"] ,
		"valid_items": ["5"]
	},
	16: {
		"sentence_template": ["let greeting = 'Hello' + ' [_]!';", "console.log(greeting);", "The outcome is: Hello world!"] ,
		"valid_items": ["world"]
	},
	17: {
		"sentence_template": ["let name = 'JavaScript';", "console.log(name.[_]());", "The outcome is: JAVASCRIPT"] ,
		"valid_items": ["toUpperCase"]
	},
	18: {
		"sentence_template": ["let sentence = 'I love JavaScript!';", "console.log(sentence.[_]('love'));", "The outcome is: 2"] ,
		"valid_items": ["indexOf"]
	},
	19: {
		"sentence_template": ["let name = 'Alex';", "console.log(`Hello, ${[_]}!`);", "The outcome is: Hello, Alex!"] ,
		"valid_items": ["name"]
	},
	20: {
		"sentence_template": ["let big = 12345678901234567890[_];", "console.log(big);", "The outcome is: 12345678901234567890n"] ,
		"valid_items": ["n"]
	}
}

func get_floor_data(floor_number: int):
	return floor_templates.get(floor_number, { "sentence_template": [], "valid_items": [] })
