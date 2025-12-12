@tool
extends MarginContainer

@export var keep_size : Vector2


func _on_collapsible_container_tweening_amount_changed(_current_size: Vector2, _normalized_progress: float, _time_left: float) -> void:
	size = keep_size


func _on_collapsible_container_tween_completed(_previous_tween_state: CollapsibleContainer.TweenStates) -> void:
	size = keep_size
