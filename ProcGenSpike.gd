extends Node2D

func duplicateObjectAtPosition():
	var scene = preload("res://ProcGenSpike.gd")
	var duplicatedObject = scene.instance()
	
	duplicatedObject.position = Vector2(100, 100)  # Set position as needed
	
	add_child(duplicatedObject)  # Add as a child to this node
