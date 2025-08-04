extends CharacterBody2D

var jump_left = 2
const jump_total = 2

var attack_state = false
var hit_state = false

var check_point = 0

var health = 5;
var entity = "player"
var SPEED = 150.0

const ACCELERATION = 150*4
const DECCELERATION = 150*3
const JUMP_VELOCITY = -250.0

@onready var hurt_audio: AudioStreamPlayer2D = $HurtAudio
@onready var animated_sprite = $AnimatedSprite2D
@onready var player = $"."
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio
@onready var hurt_box: HurtBox = $HurtBox
@onready var hit_box: HitBox = $HitBox2

# Handles damage taken
func _ready():
	hit_box.Damaged.connect(TakeDamage)

# Handles death
func TakeDamage (_damage: int ) -> void:
		player.position.y = -50
		player.position.x = check_point
		health = 10
		
func heal(value):
	health += value;
	print(health)


func _physics_process(delta: float) -> void:
	
	# Handle attack
	if Input.is_action_just_pressed("ui_accept"):
		attack_state = true
		hurt_box.collision_layer = 5
		hurt_box.monitoring = true
	
	# Handles pitfalls
	if player.position.y > 60:
		player.position.y = -50
		player.position.x = check_point
		health = 5
	
	# Adds gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Resets jump
	if is_on_floor() or is_on_wall():
		jump_left = jump_total

	# Handles jump.
	if jump_left > 0 and Input.is_action_just_pressed("ui_up"):
		jump_audio.pitch_scale = randf_range(0.9, 1.1)
		jump_audio.play()
		velocity.y = JUMP_VELOCITY
		jump_left -= 1
		
	# Variable jump
	if Input.is_action_just_released("ui_up"):
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	
	# Flips sprite and hurt box on input
	if direction == 1:
		animated_sprite.flip_h = false
		hurt_box.rotation_degrees = 0
	elif direction == -1:
		animated_sprite.flip_h = true
		hurt_box.rotation_degrees = 180
	
	# Handles animation by attack/walk/idle/jump state
	if (direction == 0) and not attack_state and not hit_state:
		animated_sprite.play("idle")
	elif (direction == 1 or direction == -1) and (not is_on_floor()):
		animated_sprite.play("jump")
	elif (direction == 1 or direction == -1) and not hit_state:
		animated_sprite.play("walk_cycle")
	elif attack_state:
		velocity.x = 0
		animated_sprite.play("attack")
		await get_tree().create_timer(0.3).timeout
		attack_state = false
		hurt_box.monitoring = false
		hurt_box.collision_layer = 10
	
	# Acceleration and Deceleration 
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION*delta) 
	else:
		velocity.x = move_toward(velocity.x, 0, DECCELERATION*delta)

	move_and_slide()
