using Godot;
using System;

public class Inimigo : StaticBody2D
{
    //Referencias Nodes
    public AnimationPlayer MyAnimationPlayer;
    public Area2D MyAreaInimigo;
    public Area2D MyBocaInimigo;
    public Timer MyDestroyTimer;
    public Sprite MySprite;
    public Tween MyTween;
    public Particles2D MyParticles2D;
    public AudioStreamPlayer2D MyExplodir;

    //Variaveis
    public bool areaDetectavel = false; //Area de detecção
    public KinematicBody2D ObjetoPersonagem; //Referencia Personagem
    public int direcaoInimigo = 0; //Direção inimigo

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        //Inicializar Nodes
        MyAnimationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
        MyAreaInimigo = GetNode<Area2D>("areaInimigo");
        MyBocaInimigo = GetNode<Area2D>("bocaInimigo");
        MyDestroyTimer = GetNode<Timer>("destroy_timer");
        MySprite = GetNode<Sprite>("Sprite");
        MyTween = GetNode<Tween>("Tween");
        MyParticles2D = GetNode<Particles2D>("Particles2D");
        MyExplodir = GetNode<AudioStreamPlayer2D>("explodir");

        //Conectar o AnimationPlayer quando terminar a animação
        MyAnimationPlayer.Connect("animation_finished", this, "AnimacaoTerminada");

        //Conectar ao entrar na area do personagem
        MyAreaInimigo.Connect("body_entered", this, "EntrouAreaPersonagem");

        //Conectar ao sair da area do personagem
        MyAreaInimigo.Connect("body_exited", this, "SaiuAreaPersonagem");

        //Conectar o fim do tempo de destruir
        MyDestroyTimer.Connect("timeout", this, "Destruir");

        //Iniciar animação do inimigo
        MyAnimationPlayer.Play("paradoEsquerda");
    }

    //Função para quando o personagem aparecer na linha de visão do inimigo
    public void PersonagemAparece()
    {
        if (MyAnimationPlayer.CurrentAnimation != "ataqueDireita" || MyAnimationPlayer.CurrentAnimation != "ataqueEsquerda")
        {
            if (MySprite.FlipH == false)
            {
                MyAnimationPlayer.Play("ataqueEsquerda");
            } else {
                MyAnimationPlayer.Play("ataqueDireita");
            }
        }
    }

    //Para quando a animação terminar e não ficar travado.
    public void AnimacaoTerminada(string anim)
    {
        if (anim == "ataqueDireita" || anim == "ataqueEsquerda")
        {
            if (MySprite.FlipH == false)
            {
                MyAnimationPlayer.Play("paradoEsquerda");
            } else {
                MyAnimationPlayer.Play("paradoDireita");
            }
        }
    }

    //Função para detectar quando uma area entra no setor do inimigo
    public void EntrouAreaPersonagem(Node Body)
    {
        if (Body.IsInGroup("personagem"))
        {
            ObjetoPersonagem = (KinematicBody2D)Body;
            Body.SetDeferred("ObjetoInimigo", this);
            areaDetectavel = true;
        }
    }

    //Função para detectar quando uma area sai do setor do inimigo
    public void SaiuAreaPersonagem(Node Body)
    {
        if (Body.IsInGroup("personagem"))
        {
            ObjetoPersonagem = null;
            Body.SetDeferred("ObjetoInimigo", null);
            areaDetectavel = false;
        }
    }

    //Função para checar o lado que o inimigo deve estar
    public void VerificarLado(KinematicBody2D Body)
    {
        if (Body.Position.x < Position.x)
        {
            VirarPersonagem(false);
        } else {
            VirarPersonagem(true);
        }
    }

    //Função para virar o inimigo
    public void VirarPersonagem(bool dir)
    {
        if (dir)
        {
            direcaoInimigo = 1;
        } else {
            direcaoInimigo = -1;
        }

        //Alterar a direção
        MySprite.FlipH = dir;
    }

    //Explodir
    public void Explodir()
    {
        //Desativar colisores
        MyBocaInimigo.Monitoring = false;
        SetPhysicsProcess(false);
        
        //Vai deixando a planta transparente e inicia a animação, depois toca o som de explodir.
        MyTween.InterpolateProperty(MySprite, "modulate", new Color(1,1,1,1), new Color(1,1,1,0), (float)0.5, Tween.TransitionType.Bounce, Tween.EaseType.InOut);
        MyTween.Start();
        MyExplodir.Play();

        //Emite a particula
        MyParticles2D.Emitting = true;

        //Inicia o tempo para destruir o objeto
        MyDestroyTimer.Start();
    }

    //Destruir o inimigo
    public void Destruir()
    {
        QueueFree();
    }

    public override void _PhysicsProcess(float delta)
    {
        if (areaDetectavel)
        {
            PersonagemAparece();
            if (ObjetoPersonagem != null)
            {
                VerificarLado(ObjetoPersonagem);
            }
        }
    }
}
