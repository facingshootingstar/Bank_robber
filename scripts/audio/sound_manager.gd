extends Node

const MIX_RATE := 22050
const POOL_SIZE := 8

var _players: Array[AudioStreamPlayer] = []
var _streams: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_streams()
	for index in range(POOL_SIZE):
		var player := AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		_players.append(player)

func play_footstep() -> void:
	_play("footstep", -18.0, randf_range(0.92, 1.08))

func play_pickup() -> void:
	_play("pickup", -12.0, 1.0)

func play_vault() -> void:
	_play("vault", -10.0, 0.9)

func play_alarm_pulse() -> void:
	_play("alarm", -14.0, 1.0)

func play_ui_click() -> void:
	_play("ui_click", -16.0, 1.0)

func play_hack() -> void:
	_play("hack", -13.0, 1.0)

func play_laser() -> void:
	_play("laser", -18.0, randf_range(0.96, 1.04))

func stop_all() -> void:
	for player in _players:
		player.stop()
		player.stream = null

func _build_streams() -> void:
	_streams["footstep"] = _make_noise(0.08, 0.28, 0.35)
	_streams["pickup"] = _make_tone(880.0, 0.08, 0.28, 0.05)
	_streams["vault"] = _make_tone(150.0, 0.18, 0.34, 0.12)
	_streams["alarm"] = _make_tone(620.0, 0.12, 0.22, 0.01)
	_streams["ui_click"] = _make_tone(420.0, 0.04, 0.18, 0.0)
	_streams["hack"] = _make_tone(1040.0, 0.16, 0.22, -0.08)
	_streams["laser"] = _make_tone(760.0, 0.05, 0.16, 0.0)

func _play(name: String, volume_db: float, pitch_scale: float) -> void:
	if not _streams.has(name):
		return
	var player := _next_player()
	if player == null:
		return
	player.stop()
	player.stream = _streams[name]
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()

func _next_player() -> AudioStreamPlayer:
	for player in _players:
		if not player.playing:
			return player
	return _players[0] if not _players.is_empty() else null

func _make_tone(frequency: float, duration: float, volume: float, slide: float) -> AudioStreamWAV:
	var frames := int(MIX_RATE * duration)
	var data := PackedByteArray()
	data.resize(frames * 2)
	for frame in range(frames):
		var t := float(frame) / float(MIX_RATE)
		var envelope := 1.0 - (float(frame) / float(frames))
		var hz := frequency + frequency * slide * t
		var sample := sin(TAU * hz * t) * volume * envelope
		data.encode_s16(frame * 2, int(clampf(sample, -1.0, 1.0) * 32767.0))
	return _stream_from_data(data)

func _make_noise(duration: float, volume: float, decay: float) -> AudioStreamWAV:
	var frames := int(MIX_RATE * duration)
	var data := PackedByteArray()
	data.resize(frames * 2)
	var rng := RandomNumberGenerator.new()
	for frame in range(frames):
		var progress := float(frame) / float(frames)
		var envelope := pow(1.0 - progress, 1.0 + decay)
		var thump := sin(TAU * 95.0 * progress) * 0.45
		var grit := rng.randf_range(-1.0, 1.0) * 0.55
		var sample := (thump + grit) * volume * envelope
		data.encode_s16(frame * 2, int(clampf(sample, -1.0, 1.0) * 32767.0))
	return _stream_from_data(data)

func _stream_from_data(data: PackedByteArray) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = MIX_RATE
	stream.stereo = false
	stream.data = data
	return stream
