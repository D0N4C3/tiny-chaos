extends Node
## Autoload `AudioManager`: buses, saved volumes, pooled one-shots and music.
## Settings mapping: "music" -> Music bus; "sfx" -> SFX, UI and Pip buses.

const BUS_MUSIC: StringName = &"Music"
const BUS_SFX: StringName = &"SFX"
const BUS_UI: StringName = &"UI"
const BUS_PIP: StringName = &"Pip"
const BUSES: Array[StringName] = [BUS_MUSIC, BUS_SFX, BUS_UI, BUS_PIP]

const POOL_SIZE: int = 12
## Same stream re-triggered within this window is dropped (duplicate-click de-bounce).
const DEBOUNCE_MSEC: int = 60
const MAX_VOICES_PER_STREAM: int = 3
const MUSIC_FADE_SEC: float = 0.6

var _pool: Array[AudioStreamPlayer] = []
var _last_played_msec: Dictionary[AudioStream, int] = {}
var _music: AudioStreamPlayer
var _music_tween: Tween
var _duck_tween: Tween
var _music_volume_db: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	ensure_buses()
	for i: int in POOL_SIZE:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		player.name = "Sfx%d" % i
		add_child(player)
		_pool.append(player)
	_music = AudioStreamPlayer.new()
	_music.name = "Music"
	_music.bus = BUS_MUSIC
	add_child(_music)
	var event_bus: Node = get_node_or_null("/root/EventBus")
	if event_bus != null:
		event_bus.connect("setting_changed", _on_setting_changed)
	var save: Node = get_node_or_null("/root/SaveManager")
	if save != null:
		apply_volumes(float(save.call("get_setting", "sfx")), float(save.call("get_setting", "music")))


## Creates missing buses routed to Master so the game works without a bus layout resource.
static func ensure_buses() -> void:
	for bus: StringName in BUSES:
		if AudioServer.get_bus_index(bus) == -1:
			AudioServer.add_bus()
			var index: int = AudioServer.bus_count - 1
			AudioServer.set_bus_name(index, bus)
			AudioServer.set_bus_send(index, &"Master")


func apply_volumes(sfx_linear: float, music_linear: float) -> void:
	set_bus_linear(BUS_MUSIC, music_linear)
	for bus: StringName in [BUS_SFX, BUS_UI, BUS_PIP]:
		set_bus_linear(bus, sfx_linear)


static func set_bus_linear(bus: StringName, linear: float) -> void:
	var index: int = AudioServer.get_bus_index(bus)
	if index == -1:
		return
	var clamped: float = clampf(linear, 0.0, 1.0)
	AudioServer.set_bus_mute(index, clamped <= 0.001)
	AudioServer.set_bus_volume_db(index, linear_to_db(maxf(clamped, 0.001)))


## Plays a one-shot. Returns the player, or null when de-bounced, voice-capped or no stream.
func play_sfx(stream: AudioStream, bus: StringName = BUS_SFX, pitch_jitter: float = 0.0) -> AudioStreamPlayer:
	if stream == null:
		return null
	var now: int = Time.get_ticks_msec()
	if _last_played_msec.has(stream) and now - _last_played_msec[stream] < DEBOUNCE_MSEC:
		return null
	if voices_playing(stream) >= MAX_VOICES_PER_STREAM:
		return null
	var player: AudioStreamPlayer = _free_player()
	if player == null:
		return null
	_last_played_msec[stream] = now
	player.stream = stream
	player.bus = bus
	player.pitch_scale = 1.0 + randf_range(-pitch_jitter, pitch_jitter)
	player.play()
	return player


func voices_playing(stream: AudioStream) -> int:
	var count: int = 0
	for player: AudioStreamPlayer in _pool:
		if player.playing and player.stream == stream:
			count += 1
	return count


func play_music(stream: AudioStream, fade_sec: float = MUSIC_FADE_SEC) -> void:
	if _music.stream == stream and _music.playing:
		return
	if _music_tween != null:
		_music_tween.kill()
	_music_tween = create_tween()
	if _music.playing:
		_music_tween.tween_property(_music, "volume_db", -40.0, fade_sec * 0.5)
	_music_tween.tween_callback(func() -> void:
		_music.stream = stream
		_music.volume_db = -40.0
		if stream != null:
			_music.play())
	_music_tween.tween_property(_music, "volume_db", _music_volume_db, fade_sec * 0.5)


func stop_music(fade_sec: float = MUSIC_FADE_SEC) -> void:
	if _music_tween != null:
		_music_tween.kill()
	_music_tween = create_tween()
	_music_tween.tween_property(_music, "volume_db", -40.0, fade_sec)
	_music_tween.tween_callback(_music.stop)


## Temporarily lowers music (spec: duck 4-8 dB at chain-reaction peaks), then restores it.
func duck_music(amount_db: float = 6.0, hold_sec: float = 0.8) -> void:
	if _duck_tween != null:
		_duck_tween.kill()
	_duck_tween = create_tween()
	_duck_tween.tween_property(_music, "volume_db", _music_volume_db - absf(amount_db), 0.08)
	_duck_tween.tween_interval(hold_sec)
	_duck_tween.tween_property(_music, "volume_db", _music_volume_db, 0.4)


func is_music_playing() -> bool:
	return _music.playing


func _free_player() -> AudioStreamPlayer:
	for player: AudioStreamPlayer in _pool:
		if not player.playing:
			return player
	return null


func _on_setting_changed(key: StringName, value: Variant) -> void:
	if key == &"music" and (value is float or value is int):
		set_bus_linear(BUS_MUSIC, float(value))
	elif key == &"sfx" and (value is float or value is int):
		for bus: StringName in [BUS_SFX, BUS_UI, BUS_PIP]:
			set_bus_linear(bus, float(value))


## Android audio focus/background: silence everything while the app is not in front.
func _notification(what: int) -> void:
	var master: int = AudioServer.get_bus_index(&"Master")
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		AudioServer.set_bus_mute(master, true)
	elif what == NOTIFICATION_APPLICATION_RESUMED or what == NOTIFICATION_APPLICATION_FOCUS_IN:
		AudioServer.set_bus_mute(master, false)
