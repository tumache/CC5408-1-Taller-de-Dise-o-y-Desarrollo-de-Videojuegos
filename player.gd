extends CharacterBody2D

var movement_speed = 50.0
var movement_array = []

var max_hp = 10
var hp = 1 
var time = 0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var shdwtimeline := ShadowTimeline.new()

@onready var shadw = get_tree().get_first_node_in_group("Shadow")
@onready var healthBar = get_node("%HealthBar")
@onready var gom = get_node("GameOverMenu")

signal show_menu()


func _ready():
	_on_hurt_box_hurt(0)
	#connect("show_menu",Callable(gom, "show_menu"))
@onready var pivot = $Pivot
@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var lbl_timer = $GUI/lblTimer
@onready var deadEnemiesCounter = $GUI/deadEnemiesCounter
@onready var numberOfDeadEnemies = get_parent().get_node("EnemySpawner").number_of_enemies_slayed_by_the_player


func _physics_process(delta):
	movement()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
	#	velocity.x = direction * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("ui_accept"):
		shadw.global_position = global_position
		shadw.movementArray = movement_array
		shadw.movementCounter = 0	
		
	
	
	
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	movement_array.append(mov)
	velocity = mov.normalized()*movement_speed

	if mov:
		playback.travel("run")
		if mov.x:
			pivot.scale.x = sign(mov.x)	
	else:
		playback.travel("idle")
	move_and_slide() 


func _on_hurt_box_hurt(damage):
	hp -= damage 
	healthBar.max_value = max_hp
	healthBar.value = hp
	if hp <= 0:
		#emit_signal("show_menu")
		gom.show_menu()
	print(hp)

		

func change_time(argtime = 0):
	time = argtime
	var minutes = int(time/60)
	var seconds = time % 60
	if minutes < 10 :
		minutes = str(0,minutes)
	if seconds < 10:
		seconds = str(0,seconds)
	lbl_timer.text = str(minutes,":",seconds)
	
func change_deadEnemiesCounter(numberOfDeadEnemies):
	deadEnemiesCounter.text = str(numberOfDeadEnemies)
