@tool
extends EditorPlugin

## Loads and removes the CollapsibleContainer inspector plugin.

var collapsible_container_inspector_plugin = preload("collapsible_container_inspector_plugin.gd")

func _enter_tree():
	collapsible_container_inspector_plugin = collapsible_container_inspector_plugin.new()
	add_inspector_plugin(collapsible_container_inspector_plugin)

func _exit_tree():
	remove_inspector_plugin(collapsible_container_inspector_plugin)
