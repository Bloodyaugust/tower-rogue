extends Node2D

var data:Dictionary

@onready var _name:Label = find_node("Name")

@onready var _health:float = data.health

func _ready():
  _name.text = data.id
