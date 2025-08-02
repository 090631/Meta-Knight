extends CharacterBody2D
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_bt_left: RayCast2D = $RayCastBtLeft
@onready var ray_cast_bt_right: RayCast2D = $RayCastBtRight
@onready var ray_cast_right_area: RayCast2D = $RayCastRightArea
@onready var ray_cast_left_area: RayCast2D = $RayCastLeftArea
@onready var hurt_audio: AudioStreamPlayer2D = $HurtAudio
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box: HitBox = $HitBox
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var health = 2;
var entity = "enemy"
var direction = 1
const SPEED = 60

func _ready():
	hit_box.Damaged.connect(TakeDamage)
		
func TakeDamage (_damage: int ) -> void:
	queue_free()
	
func _process(delta):
	if ray_cast_left_area.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if not ray_cast_bt_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if not ray_cast_bt_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta
