extends Node2D

const _hit_effect_scene:PackedScene = preload("res://doodads/HitEffect.tscn")

var targetable:bool = true
var data:Dictionary
var path:PathFollow2D

@onready var _name:Label = find_node("Name")
@onready var _animation_player = find_node("AnimationPlayer")
@onready var _sprite:Sprite2D = find_node("Sprite2D")

@onready var _health:float = data.health

var _distance:float = 0.0

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
    _distance += delta * data["move-speed"]
    path.offset = _distance
    global_position = path.global_position

    if path.unit_offset == 1.0:
      _animation_player.play("die")
      targetable = false
      Store.set_state("health", Store.state.health - 1)

func _ready():
  CommandQueue.command_do.connect(_on_command_do)
  _name.text = data.id
  
  var _directory:Directory = Directory.new()
  var _texture_path:String = "res://sprites/creatures/" + data.id + ".png"
  
  if _directory.file_exists(_texture_path):
    _sprite.texture = load("res://sprites/creatures/" + data.id + ".png")
