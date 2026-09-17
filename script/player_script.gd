extends CharacterBody2D

# =========================
# MOVIMENTO
# =========================

@export var speed: float = 150.0
@export var jump_velocity: float = -480.0

# Gravidade aplicada ao personagem.
var gravity: float = 980.0


# =========================
# REFERÊNCIAS
# =========================

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


# =========================
# CICLO PRINCIPAL
# =========================

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_horizontal_movement()
	update_animation()

	move_and_slide()


# =========================
# GRAVIDADE
# =========================

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Evita acumular velocidade vertical quando estiver no chão.
		if velocity.y > 0:
			velocity.y = 0


# =========================
# PULO
# =========================

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


# =========================
# MOVIMENTO HORIZONTAL
# =========================

func handle_horizontal_movement() -> void:
	var direction := Input.get_axis("left", "right")

	if direction != 0:
		velocity.x = direction * speed
	else:
		velocity.x = 0


# =========================
# ANIMAÇÃO
# =========================

func update_animation() -> void:

	# 1. SUBINDO
	if velocity.y < 0:
		animated_sprite.play("jump")
		return

	# 2. CAINDO
	if velocity.y > 0:
		animated_sprite.play("down")
		return

	# A partir daqui, o personagem está no chão.

	# 3. MOVENDO PARA A ESQUERDA
	if velocity.x < 0:
		animated_sprite.play("left")
		return

	# 4. MOVENDO PARA A DIREITA
	if velocity.x > 0:
		animated_sprite.play("right")
		return

	# 5. PARADO
	animated_sprite.play("idle")
