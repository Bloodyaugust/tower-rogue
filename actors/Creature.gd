extends Node2D

const _hit_effect_scene:PackedScene = preload("res://doodads/HitEffect.tscn")

var targetable:bool = true
var data:Dictionary
var path:Line2D

@onready var _name:Label = find_node("Name")
@onready var _animation_player = find_node("AnimationPlayer")

@onready var _health:float = data.health

var _path_index:int = 1

func _die_complete() -> void:
  queue_free()

func _on_command_do(command_data:Dictionary) -> void:
  match command_data.type:
    CommandQueue.COMMAND_TYPES.ATTACK:
      if command_data.target == self && targetable:
        _health -= command_data.attacker.data.damage
        
        var _hit_effect = _hit_effect_scene.instantiate()
        _hit_effect.global_position = global_position
        get_tree().get_root().add_child(_hit_effect)

        if _health <= 0:
          _animation_player.play("die")
          targetable = false
        else:
          _animation_player.play("damage")

func _process(delta):
  if targetable:
    var _target_position:Vector2 = path.get_point_position(_path_index)

    global_position = global_position.move_toward(_target_position, delta * data["move-speed"])

    if global_position.distance_to(_target_position) <= 0.01:
      _path_index += 1

      if _path_index >= path.get_point_count():
        _animation_player.play("die")
        targetable = false

func _ready():
  CommandQueue.command_do.connect(_on_command_do)
  _name.text = data.id
