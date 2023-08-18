extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
##func _ready() -> void:
	var collapsible := CollapsibleContainer.new()
##
# Decide if you want the collapsible node to start opened or start closed.
	collapsible.starts_opened = false # Will start closed.
##
# Create/get node you want to hide. Here, we just create a label node.
	var label_node := Label.new()
	label_node.set_text("This is an example!")

# Add the node as a child to the collapsible. Now it can be hidden/revealed.
	collapsible.add_child(label_node)
##
# Alternatively, you can get a node which is already in the scene tree,
# remove it from its current parent and child it to the collapsible.
#var already_created_node = get_node(...)
#already_created_node.get_parent().remove_child(already_created_node)
#collapsible.add_child(already_created_node)
##
# Add the collapsible to the scene tree.
	add_child(collapsible)
##
# Alternatively, instead of simply adding the collapsible, you can parent the 
# collapsible to a Container to use more folding directions! 
# Should give the parent Containter a minimum size of the "open" size
# for the intended effect. 
#var parent_container := MarginContainer.new()
#parent_container.add_child(collapsible)
#add_child(parent_container)
##
# Set the sizing_node or set the custom size values. 
# Here, we just set the label as the sizing_node. Now, the label's size will be 
# used as the size the collapsible sets itself to when opened. In other words,
# the label's size is set as CollapsibleContainer's "open" size.
	collapsible.set_sizing_node_path(label_node.get_path())
##
# Alternatively, to use custom size values instead:   
#collapsible.use_custom_open_size = true 
#collapsible.use_custom_close_size = true 
#collapsible.custom_open_size = Vector2(x, y)
#collapsible.custom_close_size = Vector2(x, y)

# Modify the folding direction. (Folds from the top left by default).
# Here, we set it so that it folds from the top and is wide (as wide as the
# x/horizontal value in the "open" size).
# Some FoldingPresets require this node to be childed to a parent Container 
# (a MarginContainer is recommended) with a minimum size the same as the "open"
# size.
# But PRESET_TOP_WIDE, PRESET_TOP_LEFT and PRESET_LEFT_WIDE do not need a 
# parent Container. 
	collapsible.set_folding_direction_preset(CollapsibleContainer.FoldingPreset.PRESET_TOP_WIDE)

# Set desired the tween settings. Can also set tween_transition_type and tween_ease_type.
	collapsible.tween_duration_sec = 0.7

# Call open_tween() to start the tween.
# Should use call_deferred() if attempting to call open_tween() right after
# setting the LayoutPreset/FoldingPreset, sizing_constraint or container size flags.
	collapsible.call_deferred("open_tween")

#	collapsible.tween_started.connect(
#		func tween(_a): 
#			print ("tween started")
#			print(collapsible._tween_final_value)
#			print(collapsible.tween_duration_sec)
#			)
#
#	collapsible.tween_completed.connect(
#		func tween(_a): 
#			print ("==\ntween completed")
#			print(collapsible.get_size())
#			print(collapsible._tween_elapsed_time)
#			)




