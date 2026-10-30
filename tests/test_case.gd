class_name TestCase
extends RefCounted
## Base class for headless tests. Subclass in tests/unit or tests/content as test_*.gd,
## add `func test_*() -> void` methods (they may await). Run: python tools/run_tests.py

## SceneTree of the runner; use it to add nodes that need _ready()/signals.
var tree: SceneTree
var _failures: PackedStringArray = PackedStringArray()
var _nodes: Array[Node] = []


func before_each() -> void:
	pass


func after_each() -> void:
	pass


## Adds a node to the runner's root and frees it after the current test.
func add_node(node: Node) -> Node:
	_nodes.append(node)
	tree.root.add_child(node)
	return node


func fail(message: String) -> void:
	_failures.append(message)


func assert_true(condition: bool, message: String = "expected true") -> void:
	if not condition:
		fail(message)


func assert_false(condition: bool, message: String = "expected false") -> void:
	if condition:
		fail(message)


func assert_eq(actual: Variant, expected: Variant, message: String = "") -> void:
	if typeof(actual) != typeof(expected) or actual != expected:
		fail("%s expected <%s> got <%s>" % [message, var_to_str(expected), var_to_str(actual)])


func assert_ne(actual: Variant, unexpected: Variant, message: String = "") -> void:
	if typeof(actual) == typeof(unexpected) and actual == unexpected:
		fail("%s did not expect <%s>" % [message, var_to_str(actual)])


func assert_has(container: Variant, item: Variant, message: String = "") -> void:
	var found: bool = false
	if container is Dictionary:
		found = (container as Dictionary).has(item)
	elif container is Array:
		found = (container as Array).has(item)
	elif container is String:
		found = (container as String).contains(str(item))
	if not found:
		fail("%s <%s> missing <%s>" % [message, var_to_str(container), var_to_str(item)])


func _clear_nodes() -> void:
	for node: Node in _nodes:
		if is_instance_valid(node):
			node.free()
	_nodes.clear()
