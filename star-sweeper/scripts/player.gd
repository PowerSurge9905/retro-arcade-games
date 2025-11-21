# scripts/Player.gd
extends CharacterBody2D

# Settings
@export var camera_path: NodePath = ^"../GameCamera"
@export var speed: float = 220.0
@export var magnet_strength: float = 900.0
@export var lives: int = 3
@export var screen_pad: float = 18.0

# Soft Breathing Effect (Glow / Horizon)
@export var glow_spin_deg_per_sec: float = 18.0
@export var glow_pulse_scale: float = 0.12
@export var glow_pulse_time: float = 0.7
@export var glow_pulse_alpha: float = 0.12

# Node Paths
@export var glow_path: NodePath = ^"BH_Glow"
@export var horizon_path: NodePath = ^"BH_Horizon"
@export var burst_path: NodePath = ^"PickupBurst"

# Cached Nodes
@onready var _cam_node: Camera2D = get_node_or_null(camera_path)
@onready var _glow: Sprite2D = get_node_or_null(glow_path)
@onready var _horizon: Sprite2D = get_node_or_null(horizon_path)
@onready var _burst: GPUParticles2D = get_node_or_null(burst_path)

@onready var _gameover_music: AudioStreamPlayer = $GameOverMusic

# State
signal game_overed
var score: int = 0
var _shake_tw: Tween

# Setup On Start
func _ready() -> void:
	# connect star collector once
	if not $Collector.area_entered.is_connected(_on_collector_area_entered):
		$Collector.area_entered.connect(_on_collector_area_entered)

	# write initial values to HUD
	var hud := get_node_or_null("../HUD")
	if hud:
		if hud.has_method("set_score"):
			hud.call_deferred("set_score", score)
		if hud.has_method("set_lives"):
			hud.call_deferred("set_lives", lives)

	# breathing tween for glow sprite
	if _glow:
		var base_scale: Vector2 = _glow.scale
		var base_color: Color = _glow.modulate
		var up_scale: Vector2 = base_scale * (1.0 + glow_pulse_scale)
		var up_color: Color = base_color
		up_color.a = clampf(base_color.a + glow_pulse_alpha, 0.0, 1.0)

		var tw := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_loops()
		tw.tween_property(_glow, "scale", up_scale, glow_pulse_time)
		tw.parallel().tween_property(_glow, "modulate", up_color, glow_pulse_time)
		tw.tween_property(_glow, "scale", base_scale, glow_pulse_time)
		tw.parallel().tween_property(_glow, "modulate", base_color, glow_pulse_time)

	# breathing tween for horizon sprite
	if _horizon:
		var base_scale_h: Vector2 = _horizon.scale
		var base_color_h: Color = _horizon.modulate
		var up_scale_h: Vector2 = base_scale_h * (1.0 + glow_pulse_scale * 0.6)
		var up_color_h: Color = base_color_h
		up_color_h.a = clampf(base_color_h.a + glow_pulse_alpha * 0.7, 0.0, 1.0)

		var tw2 := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_loops()
		tw2.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)  # keep breathing while paused
		tw2.tween_interval(glow_pulse_time * 0.5)
		tw2.tween_property(_horizon, "scale", up_scale_h, glow_pulse_time)
		tw2.parallel().tween_property(_horizon, "modulate", up_color_h, glow_pulse_time)
		tw2.tween_property(_horizon, "scale", base_scale_h, glow_pulse_time)
		tw2.parallel().tween_property(_horizon, "modulate", base_color_h, glow_pulse_time)

# Movement And Effects
func _physics_process(delta: float) -> void:
	var input_vec := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vec * speed
	move_and_slide()

	# keep inside the screen
	var rect := get_viewport().get_visible_rect()
	global_position.x = clampf(global_position.x, rect.position.x + screen_pad, rect.end.x - screen_pad)
	global_position.y = clampf(global_position.y, rect.position.y + screen_pad, rect.end.y - screen_pad)

	# magnet pulls stars
	for a in $Magnet.get_overlapping_areas():
		if a.is_in_group("star"):
			a.attract_to(global_position, magnet_strength, delta)

	# subtle rotations
	if _glow:
		_glow.rotation_degrees += glow_spin_deg_per_sec * delta
	if _horizon:
		_horizon.rotation_degrees -= glow_spin_deg_per_sec * 0.6 * delta

# Star Collection
func _on_collector_area_entered(area: Area2D) -> void:
	if not area.is_in_group("star"):
		return

	var hit_pos: Vector2 = area.global_position
	area.collect()

	if _burst:
		_burst.global_position = hit_pos
		_burst.emitting = false
		_burst.restart()
		_burst.emitting = true

	score += 1
	ScoreManager.add_score(1)
	var shown := ScoreManager.get_score()

	var hud := get_node_or_null("../HUD")
	if hud and hud.has_method("set_score"):
		hud.set_score(shown)

# Damage And Lives
func take_damage(amount: int) -> void:
	_shake_camera(10.0, 0.20)

	lives = max(lives - amount, 0)

	var hud := get_node_or_null("../HUD")
	if hud and hud.has_method("set_lives"):
		hud.set_lives(lives)

	if lives <= 0:
		_game_over()

# Game Over Flow
func _game_over() -> void:
	if _gameover_music:
		_gameover_music.play()

	var is_new: bool = ScoreManager.try_set_high_score(score)

	var hud := get_node_or_null(^"../HUD")
	if hud and hud.has_method("set_high_score"):
		hud.set_high_score(ScoreManager.get_high_score())
	if hud and hud.has_method("show_game_over"):
		hud.show_game_over()

	get_tree().paused = true
	emit_signal("game_overed")

# Reset API 
func reset_player_state() -> void:
	# position to screen center 
	var rect := get_viewport().get_visible_rect()
	global_position = rect.size * 0.5

	# motion
	velocity = Vector2.ZERO

	# resources
	lives = 3
	score = 0

	# HUD
	var hud := get_node_or_null("../HUD")
	if hud:
		if hud.has_method("set_lives"):
			hud.set_lives(lives)
		if hud.has_method("set_score"):
			hud.set_score(ScoreManager.get_score())

	# stop any gameover audio if playing
	if _gameover_music and _gameover_music.playing:
		_gameover_music.stop()

# Camera Shake
func _shake_camera(intensity: float = 6.0, duration: float = 0.15) -> void:
	if _cam_node == null:
		_cam_node = get_node_or_null(camera_path)
		if _cam_node == null:
			_cam_node = get_viewport().get_camera_2d()
	if _cam_node == null:
		return

	if _cam_node.has_method("shake"):
		_cam_node.shake(intensity, duration)
		return

	_shake_camera_local(_cam_node, intensity, duration)

func _shake_camera_local(cam: Camera2D, intensity: float, duration: float) -> void:
	if _shake_tw:
		_shake_tw.kill()
	cam.offset = Vector2.ZERO

	var steps := 6
	var dt: float = maxf(duration / float(steps), 0.001)
	_shake_tw = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for i in steps:
		var ang: float = randf() * TAU
		var vec: Vector2 = Vector2(cos(ang), sin(ang)) * intensity
		_shake_tw.tween_property(cam, "offset", vec, dt)
	_shake_tw.tween_property(cam, "offset", Vector2.ZERO, dt)


func GameOverMusic() -> void:
	pass
