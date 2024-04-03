extends Node

const SPWAN_RADIUS = 320 + 10
@export var basic_enemy_scene: PackedScene
@export var wizard_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var basic_enemy_timer = $BasicEnemyTimer
@onready var wizard_enemy_timer = $WizardEnemyTimer
@onready var player = $"../Entities/Player"

var base_spawn_time = 0
var wizard_enemy_spawn_time: int
var enemy_table = WeightedTable.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	enemy_table.add_item(basic_enemy_scene, 12)
	base_spawn_time = basic_enemy_timer.wait_time
	basic_enemy_timer.timeout.connect(on_basic_enemy_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	
	#wizard_enemy_spawn_time = wizard_enemy_timer.wait_time
	#wizard_enemy_timer.timeout.connect(on_wizard_enemy_timer_timeout)
	

func get_spawn_position():
	#var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return Vector2.ZERO
	
	var spawn_position = Vector2.ZERO
	var random_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	for i in range(4):
		spawn_position = player.global_position + (random_direction * SPWAN_RADIUS)
		var additional_check_offset = random_direction * 20
		var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position + additional_check_offset, 1)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func on_basic_enemy_timer_timeout():
	basic_enemy_timer.start()
	#var player = get_tree().get_first_node_in_group('player') as Node2D
	if player == null:
		return
	
	var enemy_scene = enemy_table.pick_item()
	var basic_enemy = enemy_scene.instantiate() as Node2D
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	entities_layer.add_child(basic_enemy)
	basic_enemy.global_position = get_spawn_position()
	
	
func on_wizard_enemy_timer_timeout():
	wizard_enemy_timer.start()
	if player == null:
		return
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	var wizard_enemy = wizard_enemy_scene.instantiate() as Node2D
	entities_layer.add_child(wizard_enemy)
	wizard_enemy.global_position = get_spawn_position()


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (0.1/12) * arena_difficulty
	time_off = min(time_off, 0.7)
	basic_enemy_timer.wait_time = base_spawn_time - time_off
	
	if arena_difficulty == 6:
		enemy_table.add_item(wizard_enemy_scene, 18)
