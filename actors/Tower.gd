extends Node2D

const SELECTED_MODULATE:Color = Color(0.88627451658249, 1, 0.5137255191803)
const IDLE_MODULATE:Color = Color.WHITE

var data:Dictionary

@onready var _name:Label = find_node("Name")
@onready var _area2d:Area2D = find_node("Area2D")
@onready var _sprite:Sprite2D = find_node("Sprite2D")

@onready var _time_to_attack = data["attack-speed"]

var _target:Node2D

func _attack() -> void:
  CommandQueue.add_command({
    "type": CommandQueue.COMMAND_TYPES.ATTACK,
    "attacker": self,
    "target": _target
  })
  print("attack command sent")

func _on_area2d_input_event(_viewport:Node, event:InputEvent, _shape_index:int) -> void:
  if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
    Store.set_state("tower_selection", self)

func _on_command_do(command_data:Dictionary) -> void:
  match command_data.type:
    CommandQueue.COMMAND_TYPES.ATTACK:
      if command_data.attacker == self:
        _time_to_attack = data["attack-speed"]

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "tower_selection":
      if self == substate:
        modulate = SELECTED_MODULATE
      else:
        modulate = IDLE_MODULATE

func _process(delta):
  _time_to_attack = clamp(_time_to_attack - delta, 0, data["attack-speed"])
  
  if !GDUtil.reference_safe(_target) || !_target.targetable:
    _target = null
    var _creatures:Array = get_tree().get_nodes_in_group("creatures")
    for _creature in _creatures:
      if _creature.targetable && _creature.global_position.distance_to(global_position) <= data.range:
        _target = _creature
        break
  
  if _time_to_attack <= 0 && GDUtil.reference_safe(_target):
    _attack()

func _ready():
  CommandQueue.command_do.connect(_on_command_do)
  Store.state_changed.connect(_on_store_state_changed)
  (func(parent): parent._area2d.input_event.connect(parent._on_area2d_input_event)).call_deferred(self)
  _name.text = data.id
  
  var _directory:Directory = Directory.new()
  var _texture_path:String = "res://sprites/towers/" + data.id + ".png"
  
  if _directory.file_exists(_texture_path):
    _sprite.texture = load("res://sprites/towers/" + data.id + ".png")
