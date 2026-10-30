extends TestCase

const AudioManagerScript: GDScript = preload("res://core/audio/audio_manager.gd")

var _audio: Node


func before_each() -> void:
	_audio = add_node(AudioManagerScript.new())


func _tone(seconds: float = 0.5) -> AudioStreamWAV:
	var wav: AudioStreamWAV = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = 22050
	var data: PackedByteArray = PackedByteArray()
	data.resize(int(22050 * seconds) * 2)
	wav.data = data
	return wav


func test_buses_exist_and_route_to_master() -> void:
	for bus: StringName in AudioManagerScript.BUSES:
		var index: int = AudioServer.get_bus_index(bus)
		assert_ne(index, -1, "bus %s" % bus)
		assert_eq(AudioServer.get_bus_send(index), &"Master", "send %s" % bus)


func test_volumes_follow_settings_and_zero_mutes() -> void:
	_audio.apply_volumes(1.0, 0.5)
	var music: int = AudioServer.get_bus_index(&"Music")
	assert_true(absf(AudioServer.get_bus_volume_db(music) - linear_to_db(0.5)) < 0.01, "music -6 dB")
	_audio._on_setting_changed(&"sfx", 0.0)
	assert_true(AudioServer.is_bus_mute(AudioServer.get_bus_index(&"UI")), "sfx 0 mutes UI")
	_audio._on_setting_changed(&"sfx", 0.8)
	assert_false(AudioServer.is_bus_mute(AudioServer.get_bus_index(&"Pip")), "sfx unmutes Pip")


func test_duplicate_trigger_is_debounced() -> void:
	var tone: AudioStreamWAV = _tone()
	assert_ne(_audio.play_sfx(tone, &"UI"), null, "first plays")
	assert_eq(_audio.play_sfx(tone, &"UI"), null, "immediate repeat dropped")
	assert_ne(_audio.play_sfx(_tone(), &"UI"), null, "different stream plays")


func test_voices_per_stream_are_capped() -> void:
	var tone: AudioStreamWAV = _tone(2.0)
	var started: int = 0
	for i: int in 5:
		_audio._last_played_msec.clear()
		if _audio.play_sfx(tone) != null:
			started += 1
	assert_eq(started, AudioManagerScript.MAX_VOICES_PER_STREAM, "capped")


func test_null_stream_is_ignored() -> void:
	assert_eq(_audio.play_sfx(null), null, "no crash, no player")
