extends Node2D

const _hit_effect_scene:PackedScene = preload("res://doodads/HitEffect.tscn")
const WALK_ANIMATION_LENGTH:float = 0.5

var targetable:bool = true
var data:Dictionary
var path:PathFollow2D

@onready var _name:Label = find_node("Name")
@onready var _animation_player:AnimationPlayer = find_node("AnimationPlayer")
@onready var _walk_animation:AnimationPlayer = find_node("WalkAnimator")
@onready var _sprite:Sprite2D = find_node("Sprite2D")

@onready var _health:float = data.health

var _distance:float = 0.0
var _time_to_change_walk_sprite:float = 0.0
var _walk_sprites:Array = []
var _walk_sprite_index:int = 0
var _walk_sprite_interval:float = 0.0

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
          _walk_animation.stop()
          Store.set_state("money", Store.state.money + data.value)
          targetable = false
        else:
          _animation_player.play("damage")

func _process(delta):
  if targetable:
    _time_to_change_walk_sprite -= delta
    _distance += delta * data["move-speed"]
    path.offset = _distance
    
    if _time_to_change_walk_sprite <= 0:
      _walk_sprite_index += 1
      if _walk_sprite_index >= _walk_sprites.size():
        _walk_sprite_index = 0
      _time_to_change_walk_sprite = _walk_sprite_interval
      _sprite.texture = _walk_sprites[_walk_sprite_index]
    
    if global_position.x > path.global_position.x:
      _sprite.flip_h = true
    else:
      _sprite.flip_h = false
    
    global_position = path.global_position

    if path.unit_offset == 1.0:
      _animation_player.play("die")
      _walk_animation.stop()
      targetable = false
      Store.set_state("health", Store.state.health - 1)

func _ready():
  CommandQueue.command_do.connect(_on_command_do)
  _name.text = data.id
  
  for _path in data.sprites:
    _walk_sprites.append(GDUtil.load_texture_or_icon(_path.id))
    
  _sprite.texture = _walk_sprites[0]
  _walk_animation.play("walk", -1, randf_range(0.85, 1.15))
  _walk_animation.seek(randf_range(0.0, 0.25), true)
  _walk_sprite_interval = WALK_ANIMATION_LENGTH / _walk_sprites.size()
  _time_to_change_walk_sprite = _walk_sprite_interval
