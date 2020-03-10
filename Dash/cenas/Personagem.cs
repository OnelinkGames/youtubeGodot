using Godot;
using System;

public class Personagem : KinematicBody2D
{
    //Referencias
    private PackedScene Ghost = GD.Load<PackedScene>("res://cenas/Ghost.tscn");

    //Variaveis
    private int velocidade = 100; //Velocidade do Personagem (Andar)
    private int pulo = -200; //Altura do Pulo
    private Vector2 Vetor = new Vector2(); //Vetor de Movimento do Personagem
    private int gravidade = 300; //Gravidade para descer o personagem
    private Vector2 VetorSlide = new Vector2(0, -1); //Vetor para Up do Move and Slide
    private int dir = 0; //Direção do Personagem
    private int dash = 150; //Distancia do Dash
    private bool anim = false; //Animação Extra
    private int raycast = 150; //Distancia do RayCast
    private int difEspaco = 32; //Diferença do Espaço entre o meio do RayCast e a borda da colisão

    //Referencias Nodes
    private Tween MyTween;
    private Timer MyTimer;
    private RayCast2D MyRayCast2D;
    private AnimatedSprite MyAnimatedSprite;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        //Inicializar referencias de Nodes
        MyTween = GetNode<Tween>("Tween");
        MyTimer = GetNode<Timer>("Timer");
        MyRayCast2D = GetNode<RayCast2D>("RayCast2D");
        MyAnimatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");

        //Conectar o tween para quando acabar todas as animações
        MyTween.Connect("tween_all_completed", this, "EndTween");

        //Conectar o tempo para criar a imagem fantasma
        MyTimer.Connect("timeout", this, "CriarImagem");
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _PhysicsProcess(float delta)
    {
        //Gravidade
        if (!IsOnFloor())
        {
            Vetor.y += gravidade * delta;
        }

        //Movimentar o personagem para a Direita
        if (Input.IsActionPressed("ui_right") & anim == false)
        {
            MyRayCast2D.CastTo = new Vector2(raycast, 0); //Mudar raycast para direita
            Vetor.x = 1 * velocidade; //Mudar vetor para andar para direita
            dir = 1; //Mudar direção para direita
            MyAnimatedSprite.FlipH = false; //Mudar Flip H para direita

            //Verificar se o personagem está no chão e a animação está como falso
            if (IsOnFloor())
            {
                MyAnimatedSprite.Play("andando"); //Tocar animação de andando
            }
        } else {
            if (Input.IsActionPressed("ui_left") & anim == false)
            {
                MyRayCast2D.CastTo = new Vector2(-raycast, 0); //Mudar raycast para esquerda
                Vetor.x = -1 * velocidade; //Mudar vetor para andar para esquerda
                dir = -1; //Mudar direção para esquerda
                MyAnimatedSprite.FlipH = true; //Mudar Flip H para esquerda

                //Verificar se o personagem está no chão e a animação está como falso
                if (IsOnFloor())
                {
                    MyAnimatedSprite.Play("andando"); //Tocar animação de andando
                }
            } else {
                Vetor.x = 0; //Zera velocidade

                //Verificar se o personagem está no chão e a animação está como falso
                if (IsOnFloor() & anim == false)
                {
                    MyAnimatedSprite.Play("parado"); //Toca animação parado
                }
            }
        }
        //Caso apertar o botão e estiver no chão execute o Pulo
        if (Input.IsActionJustPressed("ui_accept") & IsOnFloor())
        {
            Vetor.y = pulo; //Altera o vetor para pular

            //Se a animação estiver como falsa.
            if (anim == false)
            {
                MyAnimatedSprite.Play("pulando"); // Tocar animação de pulo
            }
        }

        //Caso apertar para cima executar o Dash
        if (Input.IsActionJustPressed("ui_up"))
        {
            anim = true; //Transformar animação em true para travar outras animações
            MyTimer.Start(); //Iniciar tempo dos Ghosts
            MyAnimatedSprite.Play("dash"); // Tocar a animação de Dash

            //Verificar se o RayCast2D está colidindo com algum Objeto
            if (MyRayCast2D.IsColliding())
            {
                //Pega a distancia entre o objeto e a colisão
                var dif = Position.DistanceTo(MyRayCast2D.GetCollisionPoint());
                var distance = (dif - difEspaco);
                var timeDif = distance / Mathf.Abs(MyRayCast2D.CastTo.x);
                MyTween.InterpolateProperty(this, "position", Position, new Vector2(Position.x + distance * dir, Position.y), timeDif, Tween.TransitionType.Linear, Tween.EaseType.InOut);
                MyTween.Start();
            } else {
                MyTween.InterpolateProperty(this, "position", Position, new Vector2(Position.x + dash * dir, Position.y), 1, Tween.TransitionType.Linear, Tween.EaseType.InOut);
                MyTween.Start();
            }
        }

        //Move and Slide
        MoveAndSlide(Vetor, VetorSlide);
    }
    //Função para retornar animação a falso quando acabar o dash
    public void EndTween()
    {
        anim = false;
    }

    //Função para criar as imagens fantasmas quando der o dash
    public void CriarImagem()
    {
        var Fantasma = (Node2D)Ghost.Instance(); //Instancia o Ghost
        Fantasma.Position = Position; //Arruma a Posição Dele
        Fantasma.CallDeferred("AlterarLado", MyAnimatedSprite.FlipH); //Arruma o FlipH dele.
        Owner.AddChild(Fantasma);

        //Verificar se o dash está ocorrendo ainda e reinicia o time.
        if (anim == true)
        {
            MyTimer.Start();
        }
    }
}
