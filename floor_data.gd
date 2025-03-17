extends Node

var floor_templates = {
	11: { 
		"sentence_template": ["let x = [_];", "console.log(x + 5);"], 
		"valid_items": ["12"]
	},
	12: { 
		"sentence_template": ["const x = [_];", "const y = x + [_];", "console.log(y);"], 
		"valid_items": ["10", "2"]
	},
	13: {
		"sentence_template": ["var a = [_];", "var b = a * [_];", "console.log(b);"], 
		"valid_items": ["5", "3"]
	},
	14: {
		"sentence_template": ["function add(a, b) {", "  return a + [_];", "}", "console.log(add(5, 3));"], 
		"valid_items": ["b"]
	},
	15: {
		"sentence_template": ["let sum = 10 + [_];", "console.log(sum);"], 
		"valid_items": ["5"]
	},
	16: {
		"sentence_template": ["let greeting = 'Hello' + ' [_]!';", "console.log(greeting);"], 
		"valid_items": ["world"]
	},
	17: {
		"sentence_template": ["let name = 'JavaScript';", "console.log(name.[_]());"], 
		"valid_items": ["toUpperCase"]
	},
	18: {
		"sentence_template": ["let sentence = 'I love JavaScript!';", "console.log(sentence.[_]('love'));"], 
		"valid_items": ["indexOf"]
	},
	19: {
		"sentence_template": ["let name = 'Alex';", "console.log(`Hello, ${[_]}!`);"], 
		"valid_items": ["name"]
	},
	20: {
		"sentence_template": ["let big = 12345678901234567890[_];", "console.log(big);"], 
		"valid_items": ["n"]
	}
}

func get_floor_data(floor_number: int):
	return floor_templates.get(floor_number, { "sentence_template": [], "valid_items": [] })
