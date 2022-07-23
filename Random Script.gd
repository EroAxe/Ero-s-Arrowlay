extends Node


func _ready():
	
	multiply([1,2,3,4], 4)
	

func multiply(arr, num):
	
	if num <= 0:
		
		return 1
		
	else:
		
		return multiply(arr, num - 1) * arr[num - 1]
		
	
