class_name HitBox
extends Area2D

@export var damage := 1;

func _ready():
	collision_layer = 2