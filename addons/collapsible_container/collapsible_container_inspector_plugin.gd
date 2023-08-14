@tool
extends EditorInspectorPlugin

## Handles showing/hiding elements in the inspector of the CollapsibleContainer.

## Opening/closing buttons in the CollapsibleContainer's inspector.
var preview_buttons = preload("res://addons/collapsible_container/collapsible_elements/collapsible_inspector_buttons.gd")


func _can_handle(object):
	if object is CollapsibleContainer:
		return true


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	# returning true = replaces/removes the property. 
	
	if object is CollapsibleContainer:
		match name:
			"custom_open_size", "optional_custom_size_node":
				if not object.use_custom_open_size:
					return true
			"custom_close_size":
				if not object.use_custom_close_size:
					return true
			"__preview_buttons":
				add_property_editor("", preview_buttons.new(), true)
				return true
