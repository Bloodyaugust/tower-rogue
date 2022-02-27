extends Node2D

const _creature_scene:PackedScene = preload("res://actors/Creature.tscn")

func _spawn_creature(creature_data:Dictionary) -> void:
  var _new_creature:Node2D = _creature_scene.instantiate()
  var _path:Line2D = get_tree().get_nodes_in_group("paths")[0]
      
  _new_creature.data = creature_data
  _new_creature.path = _path
  _new_creature.global_position = get_tree().get_nodes_in_group("paths")[0].get_point_position(0)
  CommandQueue.add_command({
    "type": CommandQueue.COMMAND_TYPES.SPAWN_CREATURE,
    "creature": _new_creature
  })

func _on_command_do(command_data:Dictionary) -> void:
  match command_data.type:
    CommandQueue.COMMAND_TYPES.SPAWN_CREATURE:
      get_tree().get_root().add_child(command_data.creature)

func _ready():
  CommandQueue.command_do.connect(_on_command_do)
  
  (func(parent): parent._spawn_creature(Depot.get_line("creatures", "orc"))).call_deferred(self)
