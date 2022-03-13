extends Control

@onready var _aoe:Label = find_node("AOE")
@onready var _crit:Label = find_node("Crit")
@onready var _description:Label = find_node("Description")
@onready var _dps:Label = find_node("DPS")
@onready var _effects:VBoxContainer = find_node("Effects")
@onready var _name:Label = find_node("Name")
@onready var _range:Label = find_node("Range")
@onready var _upgrades:VBoxContainer = find_node("Upgrades")

var _target:Variant

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "tower_selection":
      if GDUtil.reference_safe(substate):
        _set_target(substate)
        create_tween().tween_property(self, "offset_right", 0.0, 0.15)
      else:
        create_tween().tween_property(self, "offset_right", rect_size.x, 0.15)

func _set_target(new_target:Variant) -> void:
  _target = new_target
  var _data = _target.data
  
  _aoe.text = "AOE: %.0f" % _data.aoe
  _crit.text = "Crit: {0}%, {1}x".format([_data["crit-chance"] * 100.0, _data["crit-multiplier"]])
  _description.text = ""
  _dps.text = "DPS: {0} ({1} * {2}/sec)".format(["%.2f" % (_data.damage / _data["attack-speed"]), _data.damage, "%.2f" % (1.0 / _data["attack-speed"])])
  _name.text = _data.id
  _range.text = "Range: %.0f" % _data.range
  
  GDUtil.queue_free_children(_effects)
  GDUtil.queue_free_children(_upgrades)
  
func _ready():
  Store.state_changed.connect(_on_store_state_changed)
