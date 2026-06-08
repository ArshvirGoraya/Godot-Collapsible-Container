class_name WhackFrogAudio
extends Node
@onready var pause_audio: AudioStreamPlayer = $Pause
@onready var gameplay: AudioStreamPlayer = $Gameplay
@onready var sfx_hit: Node = $sfx_hit
@onready var sfx_miss: Node = $sfx_miss
@onready var sfx_win: AudioStreamPlayer = $WinFretless

@onready var pause_audio_fades: AnimationPlayer = $PauseAudioFades
@onready var gameplay_audio_fades: AnimationPlayer = $GameplayAudioFades

@onready var music_control : Slider = $"../border/play_area/frog_area/HBoxContainer/MarginContainer2/Music"
@onready var sfx_control : Slider = $"../border/play_area/frog_area/HBoxContainer/MarginContainer3/SFX"

# TODO: different logic for music on Game Start (fade in pause), Game Play (gameplay), Game Pause (gameplay) and Game End (fade in pause. fade out gameplay)

var gameplay_pause_time : float = 0.0
var pause_audio_pause_time : float = 0.0

func _ready() -> void:
	set_music_volumes()
	set_sfx_volumes()
	pause_audio.volume_linear = 0
	pause_audio_fades.play("fade_in_pause_audio")
	pause_audio.play()
	gameplay_audio_fades.animation_finished.connect(set_gameplay_pause_time)

# MUSIC: ######################################################################

func _on_music_value_changed(_value: float) -> void:
	stop_all_fades()
	set_music_volumes()
	set_fade_volume_targets()
	
func stop_all_fades() -> void:
	if gameplay_audio_fades.is_playing():
		# gameplay audio only ever fades out. never fades in. 
		set_gameplay_pause_time()
		gameplay_audio_fades.stop()
		gameplay.stop() # will stop after fade finished, but stopped fade here so stop now as fade will never finish.
	
	# pause audio only fades in. never fades out.
	pause_audio_fades.stop()
	
	set_music_volumes()

func set_music_volumes() -> void:
	gameplay.volume_linear = music_control.value
	pause_audio.volume_linear = music_control.value

func set_fade_volume_targets() -> void:
	pause_audio_fades.get_animation("fade_in_pause_audio").track_set_key_value(0, 1, pause_audio.volume_db)
	gameplay_audio_fades.get_animation("fade_in_gameplay_audio").track_set_key_value(0, 1, gameplay.volume_db)

func set_gameplay_pause_time(_anim_name: = "fade_in_gameplay_audio") -> void:
	gameplay_pause_time = gameplay.get_playback_position()
	# Fade out complete:
	gameplay.stop()

func gameplay_to_pause_audio() -> void:
	# CALLED WHEN PAUSED
	set_fade_volume_targets()
	gameplay_audio_fades.play_backwards("fade_in_gameplay_audio")
	pause_audio.volume_linear = 0
	pause_audio_fades.play("fade_in_pause_audio")
	pause_audio.play()

func pause_to_gameplay_audio() -> void:
	# CALLED ON GAME START AND ON RESUME.
	if gameplay_audio_fades.is_playing():
		set_gameplay_pause_time()
	
	stop_all_fades()
	
	pause_audio_pause_time = pause_audio.get_playback_position()
	pause_audio.stop()
	gameplay.play(gameplay_pause_time)

func restarting() -> void:
	gameplay_pause_time = 0.0
	pause_audio_pause_time = 0.0

# SFX: ######################################################################
func play_win_sfx() -> void:
	sfx_win.volume_linear = sfx_control.value
	sfx_win.play()

func set_sfx_volumes() -> void:
	for sfx in sfx_hit.get_children():
		sfx.volume_linear = sfx_control.value
	for sfx in sfx_miss.get_children():
		sfx.volume_linear = sfx_control.value

func _stop_all_sfx() -> void:
	for sfx in sfx_miss.get_children():
		sfx.stop()
	for sfx in sfx_hit.get_children():
		sfx.stop()

func _on_sfx_value_changed(_value: float) -> void:
	set_sfx_volumes()
	_stop_all_sfx()
	_play_random_sfx()

func play_random_hit_sfx() -> void:
	#_play_sfx(sfx_hit.get_children().pick_random())
	var sfx = sfx_hit.get_children().pick_random()
	sfx.pitch_scale = randf_range(0.9, 1.3)
	sfx.play()
	
func play_random_miss_sfx() -> void:
	_play_sfx(sfx_miss.get_children().pick_random())

func _play_sfx(sfx: AudioStreamPlayer) -> void:
	sfx.pitch_scale = randf_range(0.7, 1.3)
	sfx.play()

func _play_random_sfx() -> void:
	if randi_range(0, 1) == 0:
		play_random_miss_sfx()
	else:
		play_random_hit_sfx()

func disable_volume_controls() -> void:
	music_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sfx_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	music_control.self_modulate = Color("ffffff80")
	sfx_control.self_modulate = Color("ffffff80")

func enable_volume_controls() -> void:
	music_control.mouse_filter = Control.MOUSE_FILTER_STOP
	sfx_control.mouse_filter = Control.MOUSE_FILTER_STOP
	music_control.self_modulate = Color("ffffffff")
	sfx_control.self_modulate = Color("ffffffff")
