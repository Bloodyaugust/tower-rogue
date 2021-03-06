extends Control

const FORBIDDEN_MODULATE:Color = Color(0.27450981736183, 0.27450981736183, 0.27450981736183)
const SELECTED_MODULATE:Color = Color(0.88627451658249, 1, 0.5137255191803)
const IDLE_MODULATE:Color = Color.WHITE

var data:Dictionary

@onready var _name:Label = find_node("Name")
@onready var _cost:Label = find_node("Cost")
@onready var _icon:TextureRect = find_node("Icon")

func _gui_input(event:InputEvent) -> void:
  if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
    if Store.state.money >= data.cost:
      Store.set_state("tower_building_selection", data)

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "money":
      _update_modulate()
    "tower_building_selection":
      _update_modulate()

func _ready():
  Store.state_changed.connect(_on_store_state_changed)
  _name.text = data.id
  _cost.text = str(data.cost)
  
  var _directory:Directory = Directory.new()
  var _texture_path:String = "res://sprites/towers/" + data.id + ".png"
  
  if _directory.file_exists(_texture_path):
    _icon.texture = load("res://sprites/towers/" + data.id + ".png")

func _update_modulate() -> void:
  if data == Store.state.tower_building_selection:
    self_modulate = SELECTED_MODULATE
  else:
    if Store.state.money >= data.cost:
      self_modulate = IDLE_MODULATE
    else:
      self_modulate = FORBIDDEN_MODULATE


func _on_tower_mouse_entered():
  var _tween:Tween = create_tween()
  _tween.tween_property(self, "rect_position", Vector2(0.0, rect_position.y), 0.15)

func _on_tower_mouse_exited():
  var _tween:Tween = create_tween()
  _tween.tween_property(self, "rect_position", Vector2(-100.0, rect_position.y), 0.15)
