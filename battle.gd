extends Control
enum State {HERO_TURN, ENEMY_TURN, WIN, LOSE}
var state: State = State.HERO_TURN

func _ready() -> void:
	change_state(State.HERO_TURN)
	
func change_state(new_state: State) -> void:
	state = new_state
	match state:
		State.HERO_TURN:
			%Log.text += 'Ваш ход' + '\n'
			%AttackButton.disabled = false
		State.ENEMY_TURN:
			%Log.text += 'Ход врага' + '\n'
			%AttackButton.disabled = true
			enemy_turn()
		State.WIN:
			%Log.text += 'Победа' + '\n'
			%AttackButton.disabled = true
			%AttackButton.visible = false
			%RestartButton.disabled = false
			%RestartButton.visible = true
		State.LOSE:
			%Log.text += 'Поражение' + '\n'
			%AttackButton.disabled = true
			%AttackButton.visible = false
			%RestartButton.disabled = false
			%RestartButton.visible = true

func enemy_turn():
	await get_tree().create_timer(1.0).timeout
	%Hero.take_damage(%Enemy.damage)
	%Log.text += %Enemy.fighter_name + ' бьет ' + %Hero.fighter_name + ' на ' + str(%Enemy.damage) + ' урона.'
	%Log.text += '\n'
	if %Hero.hp <= 0:
		change_state(State.LOSE)
	else:
		change_state(State.HERO_TURN)

func _on_attack_button_pressed() -> void:
	if state != State.HERO_TURN:
		return
	%Enemy.take_damage(%Hero.damage)
	%Log.text = ''
	%Log.text += %Hero.fighter_name + ' бьет ' + %Enemy.fighter_name + ' на ' + str(%Hero.damage) + ' урона.'
	%Log.text += '\n'
	if %Enemy.hp <= 0:
		change_state(State.WIN)
	else:
		change_state(State.ENEMY_TURN)

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	pass # Replace with function body.
