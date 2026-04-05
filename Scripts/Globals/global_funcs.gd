extends Node

func format_as_money(number) -> String:
	var string = "$" + str(number)
	
	var decimal_found = false
	var decimal_count = 0
	
	for character in string:
		
		if decimal_found:
			if decimal_count < 2:
				decimal_count += 1
			else:
				string.remove_char(character)
				
		if character == ".":
			decimal_found = true
	
	while decimal_count < 2:
		string += "0"
		decimal_count += 1
		
	return string
