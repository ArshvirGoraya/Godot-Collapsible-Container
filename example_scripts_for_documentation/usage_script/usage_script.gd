extends Control

func _ready() -> void:
	var collapsible := CollapsibleContainer.new()

	# Decide if you want the collapsible node to start opened or start closed.
	collapsible.starts_opened = false # Will start closed.

	# Create/get node you want to hide/collapse. Here, we just create a label node.
	var label_node := Label.new()
	label_node.set_text("Hide Me!")

	# Add the node as a child to the collapsible. Now it will be hidden/revealed.
	collapsible.add_child(label_node)

	# Alternatively, you can get a node which is already in the scene tree,
	# remove it from its current parent and child it to the collapsible.
	#var already_created_node = get_node(...)
	#already_created_node.get_parent().remove_child(already_created_node)
	#collapsible.add_child(already_created_node)

	# Set the sizing_node or set the custom size values. 
	# Here, we just set the label as the sizing_node. Now, the label's size will be 
	# used as the size the collapsible sets itself to when opened. In other words,
	# the CollapsibleContainer's "open_size" value is set to the label's size.
	# Note that the sizing_node is set BEFORE collapsible is added to the scene tree. This
	# will make starts_opened work as intended.
	collapsible.set_sizing_node_path(collapsible.get_path_to(label_node))
	
	# Alternatively, can use custom open/close sizes:
	# With this, the "open_size" for the collapsible will not automatically change to match the
	# sizing_node if sizing_node ever changes sizes. For that, you must use set_sizing_node_path(...) 
	# like above instead.
	#collapsible.use_custom_open_size = true
	#collapsible.use_custom_close_size = true
	#collapsible.custom_open_size = label_node.get_minimum_size()
	#collapsible.custom_close_size = Vector2.ZERO
	
	# You can use custom sizes along with sizing_node. For example, set "open" size to the 
	# full sizing node, but use a custom size for the "close" size:
	#collapsible.set_sizing_node_path(collapsible.get_path_to(label_node))
	#collapsible.use_custom_close_size = true
	#collapsible.custom_close_size = Vector2(10, 10)
	
	# Add the collapsible to the scene tree.
	#add_child(collapsible)

	# Alternatively, instead of simply adding the collapsible, you can parent the 
	# collapsible to a Container to use more folding directions! 
	# Should give the parent Container a minimum size of the "open" size
	# for the intended effect. 
	var parent_container := MarginContainer.new()
	parent_container.set_custom_minimum_size(label_node.get_minimum_size())
	parent_container.add_child(collapsible)
	add_child(parent_container)

	# Modify the folding direction (folds from the top left by default).
	# Here, we set it so that it folds from the top and is wide (as wide as the
	# x/horizontal value in the "open" size).
	# Some FoldingPresets require this node to be childed to a parent Container 
	# (a MarginContainer is recommended) with a minimum size the same as the "open"
	# size. PRESET_TOP_WIDE, PRESET_TOP_LEFT and PRESET_LEFT_WIDE do not need a parent Container.
	#
	# Certain folding directions may not make any sense when combined with certain close and open sizes.
	# For example, if using PRESET_TOP_WIDE, only the height will ever change. This is because the 
	# sizing_constraint is set to ONLY_HEIGHT when folding_direction_preset is set to PRESET_TOP_WIDE. 
	# The width will never be set to anything other than the open size's width. If you set a 
	# custom close width expecting it to close to that width, you will see that it will not change. 
	# If you want the width to change between open/close consider using another folding direction 
	# instead of one that only allows height to change. PRESET_TOP_LEFT, for example, allows both height 
	# and width to change.
	collapsible.set_folding_direction_preset(CollapsibleContainer.FoldingPreset.PRESET_TOP_WIDE)
	
	# If you have childed the collapsible to a parent Container, ideally with the same minimum size 
	# as your "open" size, then you can use even more folding directions. As an example, we set it 
	# to BOTTOM_WIDE here:
	#collapsible.set_folding_direction_preset(CollapsibleContainer.FoldingPreset.PRESET_BOTTOM_WIDE)

	# Can set your custom tween settings if you want to use different values from the default.
	collapsible.tween_duration_sec = 0.5
	collapsible.tween_transition_type = Tween.TRANS_LINEAR
	collapsible.tween_ease_type = Tween.EASE_IN

	# Call open_tween() to start the open tween whenever you want.
	# Should use call_deferred() if attempting to call open_tween() right after
	# setting the sizing_constraint, container size flags, or LayoutPreset/FoldingPreset (which we did in this example).
	collapsible.call_deferred("open_tween") 

	# If you want a button to toggle the collapsible open and closed:
	var button := Button.new()
	button.text = "Collapsible Button"
	button.set_anchors_preset(Control.PRESET_CENTER)
	add_child(button)

	# Any time the button is pressed, will toggle the collapsible's open/close tween functions.
	# The collapsible keeps track of its open/closed state so you don't have to.
	button.connect("pressed", collapsible.toggle_tween)
