extends MarginContainer

@onready var my_size : Vector2 = size

func _on_collapsible_container_tweening_amount_changed(_current_size: Vector2, _normalized_progress: float, _time_left: float) -> void:
	size = my_size

func _on_collapsible_container_tween_completed(_previous_tween_state: CollapsibleContainer.TweenStates) -> void:
	size = my_size
