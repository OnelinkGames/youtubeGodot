using Godot;
using System;

public class Personagem : KinematicBody2D
{
    //Referencias Nodes
    public Area2D MyAreaDano;
    public Area2D MyAreaBater;
    public Timer MyTempoMorrer;
    public Timer MyTempoInvencivel;
    public AnimationPlayer MyAnimationPlayer;
    public Camera2D MyCamera2D;
    public Sprite MySprite;
    public Particles2D MyParticles2D;
    public Tween MyTween;
    public AudioStreamPlayer2D MyPulo;
    public AudioStreamPlayer2D MyDano;

    //Constantes
    public const int GRAVITY = 300;
    public Vector2 UP = new Vector2(0, -1);
    public const int SPEED = 100;
    public const int JUMP = 180;
    public const int CAMERA = -50;
    
    //Variaveis
    public Vector2 Motion = new Vector2();
    public int dir = 1;
    public bool colisorDano = false;
    public int cameraOffSet = -50;
    public int hp = 100;
    public StaticBody2D ObjetoInimigo;

    //Sinais
    [Signal]
    delegate void LevarDano();
    [Signal]
    delegate void AumentarScore();



    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        //Inicializar Nodes
        MyAreaDano = GetNode<Area2D>("areaDano");
        MyAreaBater = GetNode<Area2D>("areaBater");
        MyTempoMorrer = GetNode<Timer>("tempoMorrer");
        MyTempoInvencivel = GetNode<Timer>("tempo_invencivel");
        MyAnimationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
        MyCamera2D = GetNode<Camera2D>("Camera2D");
        MySprite = GetNode<Sprite>("Sprite");
        MyParticles2D = GetNode<Particles2D>("Particles2D");
        MyTween = GetNode<Tween>("Tween");
        MyPulo = GetNode<AudioStreamPlayer2D>("pulo");
        MyDano = GetNode<AudioStreamPlayer2D>("dano");

        //Conectar a Area2D que vai detectar se o Personagem colidiu com o Inimigo
        MyAreaDano.Connect("area_entered", this, "OnAreaDanoAreaEntered");

        //Conectar areaBater entrar
        MyAreaBater.Connect("area_entered", this, "OnAreaBaterAreaEntered");

        //Conectar areaBater Sair
        MyAreaBater.Connect("area_exited", this, "OnAreaBaterAreaExited");

        //Conectar timer
        MyTempoMorrer.Connect("timeout", this, "TempoMorrer");

        //Iniciar animação
        MyAnimationPlayer.Play("parado");

        //Camera Offset
        MyCamera2D.Offset = new Vector2(MyCamera2D.Offset.x, cameraOffSet);
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _PhysicsProcess(float delta)
    {
        //Gravidade
        if (!IsOnFloor())
        {
            Motion.y += GRAVITY * delta;
        } else {
            Motion.y = 0;
        }

        //Mover
        if (Input.IsActionPressed("ui_right"))
        {
            dir = 1;
            MySprite.FlipH = false;
            Motion.x = SPEED * dir;
            if (IsOnFloor())
            {
                MyAnimationPlayer.Play("andando");
            }
        } else {
            if (Input.IsActionPressed("ui_left"))
            {
                dir = -1;
                MySprite.FlipH = true;
                Motion.x = SPEED * dir;
                if (IsOnFloor())
                {
                    MyAnimationPlayer.Play("andando");
                }
            } else {
                dir = 0;
                Motion.x = SPEED * dir;
                if (IsOnFloor())
                {
                    MyAnimationPlayer.Play("parado");
                }
            }
        }

        //Pular
        if (Input.IsActionJustPressed("ui_accept"))
        {
            if (IsOnFloor())
            {
                Motion.y = -JUMP;
                MyAnimationPlayer.Play("pulando");
                MyPulo.Play();
            }
        }

        //Animação de cair
        if (!IsOnFloor())
        {
            if (Motion.y > 0)
            {
                if (MyAnimationPlayer.CurrentAnimation == "pulando")
                {
                    MyAnimationPlayer.Play("caindo");
                }
            }
        }

        //Camera
        MyCamera2D.Offset = new Vector2(MyCamera2D.Offset.x, cameraOffSet);

        //Abaixar Camera
        if (cameraOffSet <= 0 && cameraOffSet >= -50)
        {
            if (Input.IsActionPressed("ui_down"))
            {
                cameraOffSet += 1;
            }
        }

        //Levantar Camera
        if (cameraOffSet <= -50 && cameraOffSet >= -100)
        {
            if (Input.IsActionPressed("ui_up"))
            {
                cameraOffSet -= 1;
            }
        }

        //Camera Offset
        if (cameraOffSet != CAMERA)
        {
            if (!Input.IsActionPressed("ui_down") && !Input.IsActionPressed("ui_up"))
            {
                if (cameraOffSet > CAMERA)
                {
                    cameraOffSet -= 1;
                } else {
                    cameraOffSet += 1;
                }
            }
        }

        //Morrer se o hp for menor ou igual a zero
        if (hp <= 0)
        {
            Morrer();
        }

        //Realizar Fisica
        MoveAndSlide(Motion, UP);
    }

    //Função para quando o personagem morrer
    public void Morrer()
    {
        MyParticles2D.Emitting = true;
        MySprite.Visible = false;
        MyTempoMorrer.Start();
        SetPhysicsProcess(false);
    }

    //Quando acabar o tempo reinicia a tela
    public void TempoMorrer()
    {
        GetTree().ReloadCurrentScene();
    }

    //Checar se o colisor de dano encostou no inimigo
    public void OnAreaBaterAreaEntered(Node2D Area)
    {
        if (Area.IsInGroup("inimigo"))
        {
            colisorDano = true;
        }
    }

    public void OnAreaBaterAreaExited(Node2D Area)
    {
        if (Area.IsInGroup("inimigo"))
        {
            colisorDano = false;
        }
    }

    //Colisão com o inimigo
    public void OnAreaDanoAreaEntered(Node2D Area)
    {
        if (Area.IsInGroup("inimigo"))
        {
            if (MyTempoInvencivel.TimeLeft == 0)
            {
                if (colisorDano == false)
                {
                    MyTempoInvencivel.Start();
                    TomouDano();
                    hp -= 10;
                    EmitSignal("LevarDano", 10);
                } else {
                    Area.Owner.CallDeferred("Explodir");
                    Motion.y = (-JUMP / 2);
                    MyPulo.Play();
                    EmitSignal("AumentarScore", 50);
                }
            }
        }
    }

    //Função para realizar a animação de dano do personagem
    public void TomouDano()
    {
        MyTween.InterpolateProperty(MySprite, "modulate", new Color((float)0.55, 0, 0, 1), new Color(1, 1, 1, 1), (float)0.5, Tween.TransitionType.Bounce, Tween.EaseType.InOut);
        MyTween.InterpolateProperty(MySprite, "scale", new Vector2((float)0.5, (float)0.5), new Vector2(1, 1), (float)0.5, Tween.TransitionType.Bounce, Tween.EaseType.InOut);

        //Verificar direção do inimigo
        if (ObjetoInimigo != null)
        {
            var dirInimigo = ObjetoInimigo.Get("direcaoInimigo");
            if ((int)dirInimigo == -1)
            {
                MyTween.InterpolateProperty(this, "position", null, new Vector2(Position.x - 30, Position.y), (float)0.5, Tween.TransitionType.Bounce, Tween.EaseType.InOut);
            } else {
                MyTween.InterpolateProperty(this, "position", null, new Vector2(Position.x + 30, Position.y), (float)0.5, Tween.TransitionType.Bounce, Tween.EaseType.InOut);
            }
        }
        MyDano.Play();
        MyTween.Start();
    }
}
