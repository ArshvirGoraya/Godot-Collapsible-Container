extends Control

func _ready() -> void:
	var collapsible := CollapsibleContainer.new()
	
	# Create button to toggle the collapsible
	var button := Button.new()
	button.set_text("Collapsible Button")
	button.connect("pressed", collapsible.toggle_tween) # Connect signal to collapsible
	add_child(button)
	
	# Create and child node you want to collapse.
	var label := Label.new()
	label.set_text("Hide Me!")
	collapsible.add_child(label)
	collapsible.set_sizing_node_path(collapsible.get_path_to(label))
	
	# Add collapsible to scene with custom settings.
	add_child(collapsible)
	collapsible.set_folding_direction_preset(CollapsibleContainer.FoldingPreset.PRESET_TOP_WIDE)
	collapsible.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
