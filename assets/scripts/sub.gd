extends KinematicBody2D
class_name Sub

signal move_input_recieved(data)

enum AnimState {
	IDLE,
	TURNING
}

enum FacingDir {
	LEFT = 0,
	RIGHT = 1
}

export var acceleration: float = 50
export var max_speed: float = 50
onready var input_axis = Vector2(0, 0)
var velocity: Vector2
var anim_state: int = AnimState.IDLE
var facing_dir: int = FacingDir.LEFT

func _ready():
	pass

func _process(delta):
	input_axis = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	if input_axis != Vector2(0, 0):
		$Sprite.flip_h = input_axis.x > 0
	if facing_dir == FacingDir.LEFT and input_axis.x > 0 and anim_state == AnimState.IDLE:
		change_dir(FacingDir.RIGHT)
	elif facing_dir == FacingDir.RIGHT and input_axis.x < 0 and anim_state == AnimState.IDLE:
		change_dir(FacingDir.LEFT)
	if Input.is_action_just_pressed("q"):
		play_anim("turn_0")
	if Input.is_action_just_pressed("e"):
		play_anim("turn_1")

func _physics_process(delta):
	velocity += input_axis * acceleration * delta
	if velocity.length() > max_speed: velocity = velocity.normalized() * max_speed
	move_and_slide(velocity, Vector2.UP, false, 4, deg2rad(45), false)
	velocity -= velocity * 1.0 * delta
	emit_signal("move_input_recieved", velocity)

func play_anim(animation: String):
	$AnimatedSprite.animation = animation
	$AnimatedSprite.play()
	
func change_dir(new_dir: int):
	facing_dir = new_dir
	play_anim("turn_0")
	yield($AnimatedSprite, "animation_finished")
	play_anim("turn_1")
