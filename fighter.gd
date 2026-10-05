extends VBoxContainer
class_name Fighter
@export var fighter_name: String = ''
@export var max_hp: int = 120
@export var damage: int = 5
var hp: int = max_hp
signal died
func take_damage(amount):
	hp -= amount
	hp = clamp(hp, 0, max_hp)
	update_label()
	if hp <= 0:
		died.emit()
	pass
func _ready() -> void:
	hp = max_hp
	take_damage(220)
	update_label()
func update_label():
	$Label.text = fighter_name + ':
		Здоровье: ' + str(hp) + '/' + str(max_hp)
