extends Node2D


@export var spawns: Array[Spawn_info] = []
@onready var player= get_tree().get_first_node_in_group("player")

var time = 0 
var number_of_enemies_in_la_pantalla = 0
var max_number_of_enemies = 300
@export var number_of_enemies_slayed_by_the_player = 0 

signal changetime(time)

func _ready():
	connect("changetime",Callable(player, "change_time"))

func _on_timer_timeout():
	time +=1
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter +=1
			elif number_of_enemies_in_la_pantalla < max_number_of_enemies:
				i.spawn_delay_counter = 0
				var new_enemy = load(str(i.enemy.resource_path))
				var counter = 0 
				while counter < i.enemy_num:
					var enemy_spawn = new_enemy.instantiate()
					enemy_spawn.global_position= get_random_position()
					add_child(enemy_spawn)
					number_of_enemies_in_la_pantalla  +=1
					print(number_of_enemies_in_la_pantalla)
					counter +=1
	emit_signal("changetime", time)

func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4) *1.5
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up","down","right","left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = bottom_right
			spawn_pos2 = top_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)
