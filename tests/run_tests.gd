extends SceneTree
## Headless test runner. Discovers res://tests/**/test_*.gd scripts extending TestCase.
## Run: godot --headless --path . -s res://tests/run_tests.gd -- --test-run [--filter=substring]
## (--test-run keeps autoloads such as SaveManager away from the real player profile.)
## Exit code 0 only when every test passed and at least one test ran.

const TEST_ROOT: String = "res://tests"

var _passed: int = 0
var _failed: int = 0


func _initialize() -> void:
	_run.call_deferred()


func _run() -> void:
	var filter: String = ""
	for arg: String in OS.get_cmdline_user_args():
		if arg.begins_with("--filter="):
			filter = arg.trim_prefix("--filter=")
	var scripts: PackedStringArray = PackedStringArray()
	_collect(TEST_ROOT, scripts)
	scripts.sort()
	for path: String in scripts:
		await _run_script(path, filter)
	var total: int = _passed + _failed
	print("\n%d passed, %d failed, %d total" % [_passed, _failed, total])
	quit(0 if _failed == 0 and total > 0 else 1)


func _collect(dir_path: String, out: PackedStringArray) -> void:
	for sub: String in DirAccess.get_directories_at(dir_path):
		_collect(dir_path.path_join(sub), out)
	for file: String in DirAccess.get_files_at(dir_path):
		if file.begins_with("test_") and file.ends_with(".gd") and file != "test_case.gd":
			out.append(dir_path.path_join(file))


func _run_script(path: String, filter: String) -> void:
	var script: GDScript = load(path) as GDScript
	if script == null or not script.can_instantiate():
		_record(path, "<load>", PackedStringArray(["script failed to load or parse"]))
		return
	var methods: PackedStringArray = PackedStringArray()
	for info: Dictionary in script.get_script_method_list():
		var name: String = info["name"]
		if name.begins_with("test_") and not methods.has(name):
			if filter.is_empty() or path.contains(filter) or name.contains(filter):
				methods.append(name)
	for method: String in methods:
		var instance: Object = script.new()
		var test_case: TestCase = instance as TestCase
		if test_case == null:
			_record(path, method, PackedStringArray(["script does not extend TestCase"]))
			return
		test_case.tree = self
		await test_case.before_each()
		await test_case.call(method)
		await test_case.after_each()
		test_case._clear_nodes()
		_record(path, method, test_case._failures)


func _record(path: String, method: String, failures: PackedStringArray) -> void:
	var label: String = "%s::%s" % [path.trim_prefix(TEST_ROOT + "/"), method]
	if failures.is_empty():
		_passed += 1
		print("PASS ", label)
	else:
		_failed += 1
		print("FAIL ", label)
		for message: String in failures:
			print("     - ", message)
