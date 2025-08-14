extends CharacterBody3D


var SPEED = 2.8
const JUMP_VELOCITY = 4.5

var sens_horizontal = 0.3
var sens_vertical = 0.2

var walk_speed = 2.8
var run_speed = 5.0

var is_running = false
var is_looked = false	

@onready var pivote: Node3D = $Pivote
@onready var model: Node3D = $Model
@onready var animation_player: AnimationPlayer = $Model/mixamo_base/AnimationPlayer
@onready var health_component: Node = $HealthComponent


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		model.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		pivote.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
	
func _physics_process(delta: float) -> void:
	
	#F
	if Input.is_action_just_pressed("debug_key"):
		health_component.take_damage(5)
		print(health_component.current_health)
	
	if !animation_player.is_playing():
		is_looked = false
	
	if Input.is_action_pressed("run"):
		SPEED = run_speed
		is_running = true
	else:
		SPEED = walk_speed
		is_running = false
	
	if Input.is_action_just_pressed("hit"):
		if animation_player.current_animation != "kick":
			animation_player.play("kick")
			is_looked = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !is_looked:
			if is_running:
				if animation_player.current_animation != "runing":
					animation_player.play("running")
			else:
				if animation_player.current_animation != "walking":
					animation_player.play("walking")
		
			model.look_at(position - direction)
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if !is_looked:
			if animation_player.current_animation != "idle":
				animation_player.play("idle")
		
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if !is_looked:
		move_and_slide()
