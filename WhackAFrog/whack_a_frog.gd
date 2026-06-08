extends Control

@export var collapsible_holder : GridContainer
@export var game_timer : Timer
@export var whack_timer : Timer
@export var score_label : Label
@export var time_label : Label
@export var time_progress_bar : ProgressBar
@export var misses_label : Label
@export var start_btn : Button
@export var menu_label : Label
@export var pause_toggle : Button
@export var difficulty_curve: Curve # INFO: as time continues, speed at which things open is defined by this curve.
@export var audio : WhackFrogAudio
@export var pause_collapsibles_on_pause: bool = false # false because player can just position cursor on top of frog and click.

var misses : int = 0
var score : int = 0

var game_running : bool = false
var game_paused : bool = false

var debug_label : Label

class CollapsibleContainerIterator:
	var _collapsible_holder: GridContainer

	func _init(collapsible_holder: GridContainer):
		_collapsible_holder = collapsible_holder

	func _should_continue(current):
		return current < _collapsible_holder.get_child_count()

	func _iter_init(iter):
		# INFO: iter[0] is the current index
		iter[0] = 0
		return true

	func _iter_next(iter):
		iter[0] += 1
		return _should_continue(iter[0])

	func _iter_get(current):
		return _collapsible_holder.get_child(current).get_child(0)

@onready var collapsible_container_iterator = CollapsibleContainerIterator.new(collapsible_holder)

var collapsible_contained_folding_preset_values : Array = [] # Array[int]
var tween_transition_values : Array[Tween.TransitionType]
var tween_ease_values : Array[Tween.EaseType]

func _ready() -> void:
	#game_timer.wait_time = 4 #DEBUG
	pause_toggle.disabled = true
	pause_toggle.modulate = Color("ffffff80")
	time_progress_bar.max_value = game_timer.wait_time
	time_progress_bar.value = time_progress_bar.max_value
	menu_label.visible = false
	
	# INFO: Gets copy of CollapsibleContainer.FoldingPreset and removes "UNDEFINED" key so I can randomly pick all the other ones.
	# Instead of doing this, you could loop through Control.LayoutPreset (which has the same values as CollapsibleContainer.FoldingPreset without UNDEFINED) 
	# but Godot doesn't let you pick randomly from it: Control.LayoutPreset.pick_random(), so would have to create a copy anyway.
	var folding_preset_duplicate = CollapsibleContainer.FoldingPreset.duplicate()
	folding_preset_duplicate.erase("UNDEFINED")
	collapsible_contained_folding_preset_values = folding_preset_duplicate.values()
	
	# Godot doesn't currently let you randomly select with  Tween.TransitionType.pick_random(), so creating a clone
	tween_transition_values = [
		#Tween.TransitionType.TRANS_BACK, 
		Tween.TransitionType.TRANS_BOUNCE, 
		Tween.TransitionType.TRANS_CIRC, 
		Tween.TransitionType.TRANS_CUBIC, 
		#Tween.TransitionType.TRANS_ELASTIC, 
		Tween.TransitionType.TRANS_EXPO, 
		Tween.TransitionType.TRANS_LINEAR, 
		Tween.TransitionType.TRANS_QUAD, 
		Tween.TransitionType.TRANS_QUART, 
		Tween.TransitionType.TRANS_QUINT, 
		Tween.TransitionType.TRANS_SINE, 
		#Tween.TransitionType.TRANS_SPRING
	]
	tween_ease_values = [
		Tween.EaseType.EASE_IN,
		Tween.EaseType.EASE_IN_OUT,
		Tween.EaseType.EASE_OUT,
		Tween.EaseType.EASE_OUT_IN
	]
	
	# INFO: connect signals
	for collapsible : CollapsibleContainer in collapsible_container_iterator:
		#collapsible.state_set.connect(collapsible_complete.bind(collapsible))
		collapsible.tween_completed.connect(collapsible_tween_completed.bind(collapsible))
		
		var btn : Button = collapsible.get_child(1).get_child(0)
		btn.pressed.connect(collapsible_pressed.bind(collapsible))
		
	if OS.is_debug_build():
		debug_label = Label.new()
		add_child(debug_label)

func collapsible_pressed(collapsible: CollapsibleContainer) -> void:
	if not game_running: return
	if pause_collapsibles_on_pause:
		if game_paused: return 
	frog_hit(collapsible)
	collapsible.close() # INFO: will trigger collapsible_complete()

func collapsible_tween_completed(finished_tween: CollapsibleContainer.TweenStates, collapsible: CollapsibleContainer) -> void:
	if finished_tween == CollapsibleContainer.TweenStates.OPENING:
		# INFO: begin closing the collapsible after it has opened
		collapsible.toggle_tween()
	
	if finished_tween == CollapsibleContainer.TweenStates.CLOSING:
		# INFO: closing tween was completed which means it was not clicked (if it were clicked, the closing tween would be interrupted by .close()
		frog_missed(collapsible)

func frog_missed(_collapsible: CollapsibleContainer) -> void:
	misses += 1
	misses_label.text = str(misses)
	audio.play_random_miss_sfx()

func frog_hit(_collapsible: CollapsibleContainer) -> void:
	score += 1
	score_label.text = str(score)
	audio.play_random_hit_sfx()

func _on_whack_open_timer_timeout() -> void:
	var collapsible = get_random_collapsible_or_null()
	if collapsible != null:
		randomize_collapsible(collapsible)
		# INFO: Call deferred because just changed folding preset to a random one and Godot needs a frame to update the necessary things. 
		# Otherwise, may use the previous FoldingPreset and cause unintended opening/closing dynamics.
		collapsible.call_deferred("toggle_tween")
	update_whack_open_timer()

func randomize_collapsible(collapsible: CollapsibleContainer) -> void:
	# pick a random animation
	var animated_sprite : AnimatedSprite2D = collapsible.get_child(1).get_child(1)
	# set random color
	var random_color : Color = Color8(
		randi_range(100, 255), 
		randi_range(100, 255), 
		randi_range(100, 255))
	animated_sprite.set_self_modulate(random_color)
	# set random animation
	var random_animation_number : int = randi_range(0, animated_sprite.sprite_frames.get_animation_names().size() - 1)
	var random_animation : String = animated_sprite.sprite_frames.get_animation_names()[random_animation_number]
	animated_sprite.set_frame_and_progress(0, 0)
	animated_sprite.play(random_animation)
	
	# give random folding preset.
	var random_folding_preset = collapsible_contained_folding_preset_values.pick_random()
	collapsible.set_folding_direction_preset(random_folding_preset)
	
	# give random speed between range.
	# INFO: Timer for how long the user has to press the button. Relative to the difficulty curve
	const MIN_WHACK_TIME = 0.45
	const MAX_WHACK_TIME = 0.7
	var whack_time = lerp(MIN_WHACK_TIME, MAX_WHACK_TIME, get_normalized_difficulty())
	collapsible.set_tween_duration_sec(whack_time)
	
	# give random tween transition type.
	# INFO: Keeping the default feels better so commenting out
	#collapsible.set_tween_transition_type(tween_transition_values.pick_random())
	
	# give random tween ease type.
	collapsible.set_tween_ease_type(tween_ease_values.pick_random())

func get_normalized_difficulty() -> float:
	# INFO: gets how difficlt the game should be: 0 = easiest. 1 = hardest.
	var remaining_time : float = game_timer.get_time_left()
	var normalized_time = remaining_time / game_timer.wait_time # 0.0 to 1.0 percentagized time
	normalized_time = 1 - normalized_time
	var difficulty = difficulty_curve.sample(normalized_time)
	#print("normalized time: ", normalized_time, " difficulty: ", difficulty)
	return difficulty

func update_whack_open_timer() -> void:
	# INFO: Time for choosing the next whack button. Not for how long the user has to press the button.
	var normalized_whack_speed = get_normalized_difficulty()
	const WHACK_WAIT_TIME_MAX = 3
	var whack_speed = WHACK_WAIT_TIME_MAX * normalized_whack_speed
	whack_timer.wait_time = whack_speed

func get_random_collapsible_or_null() -> CollapsibleContainer:
	# INFO: select random from a set of closed collapsible containers
	var possible_collapsibles : Array[CollapsibleContainer] = [] 
	
	# OPTIMIZE: only loops through ~36 elements, so this is fine.	
	for collapsible : CollapsibleContainer in collapsible_container_iterator:
		if collapsible.is_closed():
			possible_collapsibles.append(collapsible)
	
	if possible_collapsibles.size() <= 0:
		return null
	
	return possible_collapsibles[randi_range(0, possible_collapsibles.size() - 1)]

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == Key.KEY_ESCAPE and event.pressed == false:
			toggle_pause()

func toggle_pause() -> void:
	if pause_toggle.disabled == false:
		pause_toggle.button_pressed = !pause_toggle.button_pressed 

func _on_start_game_pressed() -> void:
	start_btn.visible = false
	start_btn.text = "RESTART"
	game_timer.start() # resets timer to initial time_out
	whack_timer.start()
	game_running = true
	misses = 0
	misses_label.text = str(misses)
	score = 0
	score_label.text = str(score)
	
	# INFO: for when restarting, close all collapsibles.
	for collapsible : CollapsibleContainer in collapsible_container_iterator:
		collapsible.close()
	pause_toggle.button_pressed = false
	audio.restarting()
	
	#get_random_collapsible_or_null().toggle_tween() # open random collapsible immediately
	audio.pause_to_gameplay_audio()
	audio.disable_volume_controls()
	pause_toggle.disabled = false
	pause_toggle.modulate = Color("ffffffff")

func _on_pause_toggle_toggled(paused: bool) -> void:
	if paused:
		on_pause()
	else:
		on_resume()

func on_pause() -> void:
	# INFO: Game can only pause if running.
	game_paused = true
	start_btn.visible = true
	audio.enable_volume_controls()
	#audio.gameplay_to_pause_audio()
	
	if pause_collapsibles_on_pause:
		whack_timer.set_paused(true)
		for collapsible : CollapsibleContainer in collapsible_container_iterator:
			collapsible.pause_tween(false)

func on_resume() -> void:
	game_paused = false
	menu_label.visible = false
	start_btn.visible = false
	audio.disable_volume_controls()
	#audio.pause_to_gameplay_audio()
	
	if pause_collapsibles_on_pause:
		whack_timer.set_paused(false)
		for collapsible : CollapsibleContainer in collapsible_container_iterator:
			collapsible.resume_tween(false)

func _on_game_timer_timeout() -> void:
	# on game end!
	start_btn.visible = false # if paused.
	pause_toggle.disabled = true
	pause_toggle.modulate = Color("ffffff80")
	game_running = false
	whack_timer.stop()
	for collapsible : CollapsibleContainer in collapsible_container_iterator:
		collapsible.force_stop_tween()
	
	# INFO: wait before reshowing start button so player doesn't click is accidentally
	menu_label.visible = true
	if misses == 0:
		menu_label.text = "WIN!!!!!!!"
		audio.play_win_sfx()
	else:
		menu_label.text = "END"
	
	audio.gameplay_to_pause_audio()
	audio.enable_volume_controls()
	await get_tree().create_timer(3).timeout
	
	for collapsible : CollapsibleContainer in collapsible_container_iterator:
		collapsible.close()
	menu_label.visible = false
	start_btn.visible = true

func _process(_delta: float) -> void:
	if game_running:
		var game_time : float = game_timer.get_time_left()
		time_label.text = get_formatted_time_string(game_time)
		time_progress_bar.value = game_timer.wait_time - game_time

	if OS.is_debug_build():
		debug_label.text = "Whack Time: " + get_formatted_time_string(whack_timer.get_time_left())

func get_formatted_time_string(time: float) -> String:
	var time_left : int = int(time) # time left in seconds.
	@warning_ignore("integer_division")
	var minutes = time_left / 60
	var seconds = time_left % 60
	return str(minutes) + ":" + str(seconds).pad_zeros(2)
