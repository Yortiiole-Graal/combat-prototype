extends VBoxContainer
class_name Fighter
@export var chance: float = 0
@export var fighter_name: String = ''
@export var max_hp: int = 120
@export var min_damage: int = 1
@export var max_damage: int = 5
var hp: int = max_hp
signal died
func take_damage(amount: int) -> void:
	hp -= amount
	hp = clamp(hp, 0, max_hp)
	update_label()
	if hp <= 0 and GameState.soul < GameState.revive_cost:
		died.emit()
func revive():
	@warning_ignore("integer_division")
	hp = (max_hp / 3)
	update_label()
func _ready() -> void:
	hp = max_hp
	update_label()
func update_label():
	$Label.text = fighter_name + ':
		Здоровье: ' + str(hp) + '/' + str(max_hp)
