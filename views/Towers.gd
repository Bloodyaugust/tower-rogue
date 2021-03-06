extends Control

const _tower_component:PackedScene = preload("res://views/components/Tower.tscn")

@onready var _tower_list:VBoxContainer = find_node("TowerList")
@onready var _towers:Array = Depot.get_lines("towers")

func _hide_towers() -> void:
  await get_tree().create_timer(0.01).timeout
  for _tower in _tower_list.get_children():
    _tower.rect_position = Vector2(-100.0, _tower.rect_position.y)

func _ready():
  for _tower in _towers:
    var _new_tower_component:Control = _tower_component.instantiate()
    
    _new_tower_component.data = _tower
    _tower_list.add_child(_new_tower_component)
    
  call_deferred("_hide_towers")
