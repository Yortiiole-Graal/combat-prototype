extends Control
enum State {HERO_TURN, ENEMY_TURN, WIN, LOSE}
var state: State = State.HERO_TURN

func _ready() -> void:
	change_state(State.HERO_TURN)
	update_soul_bar()
	
	
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
			%Log.text += 'Душа иссякла. ' + %Hero.fighter_name + ' погиб окончательно' + '\n'
			%AttackButton.disabled = true
			%AttackButton.visible = false
			%NewGameButton.disabled = false
			%NewGameButton.visible = true


func enemy_turn():
	await get_tree().create_timer(1.0).timeout
	if %Enemy.chance < randf():
		%Log.text += %Enemy.fighter_name + ' Промахивается' + '\n'
		change_state(State.HERO_TURN)
	else:
		var dmg1: int = randi_range(%Enemy.min_damage, %Enemy.max_damage)
		%Hero.take_damage(dmg1)
		%Log.text += %Enemy.fighter_name + ' бьет ' + %Hero.fighter_name + ' на ' + str(dmg1) + ' урона.'
		%Log.text += '\n'
		if %Hero.hp > 0:
			change_state(State.HERO_TURN)
		if %Hero.hp <= 0 and GameState.soul >= GameState.revive_cost:
			GameState.soul -= GameState.revive_cost
			%Hero.revive()
			update_soul_bar()
			%Log.text = 'Удар был смертельным — душа ' + %Hero.fighter_name + ' удержала. Душа −' + str(GameState.revive_cost) + '\n'
			change_state(State.HERO_TURN)
		else:
			change_state(State.LOSE)

func _on_attack_button_pressed() -> void:
	if state != State.HERO_TURN:
		return
	if %Hero.chance < randf():
		%Log.text = ''
		%Log.text += %Hero.fighter_name + ' Промахивается' + '\n'
		change_state(State.ENEMY_TURN)
	else:
		var dmg1: int = randi_range(%Hero.min_damage, %Hero.max_damage)
		%Enemy.take_damage(dmg1)
		%Log.text = ''
		%Log.text += %Hero.fighter_name + ' бьет ' + %Enemy.fighter_name + ' на ' + str(dmg1) + ' урона.'
		%Log.text += '\n'
		if %Enemy.hp <= 0:
			change_state(State.WIN)
		else:
			change_state(State.ENEMY_TURN)

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_new_game_button_pressed() -> void:
	GameState.restartsoul()
	get_tree().reload_current_scene()

func update_soul_bar():
	%SoulBar.max_value = GameState.max_soul
	%SoulBar.value = GameState.soul
