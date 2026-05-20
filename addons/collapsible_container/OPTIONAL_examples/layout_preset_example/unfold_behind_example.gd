extends TextureButton

@export var collapse_top : CollapsibleContainer
@export var collapse_bot : CollapsibleContainer

func _ready() -> void:
	collapse_top.open_tween()

func _on_pressed() -> void:
	collapse_top.close()
	collapse_bot.close()
	
	collapse_top.open_tween()

func _on_collapsible_container_top_tween_completed(previous_tween_state: CollapsibleContainer.TweenStates) -> void:
	# Begins the bottom collapsible's tween once top collapsible is finished opening.
	collapse_bot.open_tween()
