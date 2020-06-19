using Godot;
using System;

public class Personagem : KinematicBody2D
{
     //Nodes
    private AnimationPlayer MyAnimationPlayer;
    private Sprite MySprite;

    //Variaveis
    private Vector2 movimento = new Vector2();
    private int velocidade = 100;
    private String direcao = "";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        //Inicializar Nodes
        MyAnimationPlayer = GetNode("AnimationPlayer") as AnimationPlayer;
        MySprite = GetNode("Sprite") as Sprite;
    }

//  Called every frame. 'delta' is the elapsed time since the previous frame.
public override void _PhysicsProcess(float delta)
{
    //Movimentação
    if (Input.IsActionPressed("ui_right")) 
    {
        movimento.x = 1;
        movimento.y = 0;
        direcao = "direita";
        MyAnimationPlayer.Play("andandoHorizontal");
        MySprite.FlipH = false;
    } else {
        if (Input.IsActionPressed("ui_down")) 
        {
            movimento.y = 1;
            movimento.x = 0;
            direcao = "baixo";
            MyAnimationPlayer.Play("andandoBaixo");
            MySprite.FlipH = false;
        } else {
            if (Input.IsActionPressed("ui_left"))
            {
                movimento.x = -1;
                movimento.y = 0;
                direcao = "esquerda";
                MyAnimationPlayer.Play("andandoHorizontal");
                MySprite.FlipH = true;
            } else {
                if (Input.IsActionPressed("ui_up"))
                {
                    movimento.y = -1;
                    movimento.x = 0;
                    direcao = "cima";
                    MyAnimationPlayer.Play("andandoCima");
                    MySprite.FlipH = false;
                } else {
                    movimento.x = 0;
                    movimento.y = 0;
                    ChecarParado();
                }
            }
        }
    }

    //Move and Slide
    MoveAndSlide(movimento * velocidade);
}

//Metodo para verificar animação quando parado, colocando a animação correta em cada caso.
public void ChecarParado() {
    if (direcao == "direita") {
        MyAnimationPlayer.Play("paradoHorizontal");
        MySprite.FlipH = false;
    }

    if (direcao == "esquerda") {
        MyAnimationPlayer.Play("paradoHorizontal");
        MySprite.FlipH = true;
    }

    if (direcao == "baixo") {
        MyAnimationPlayer.Play("paradoBaixo");
        MySprite.FlipH = false;
    }

    if (direcao == "cima") {
        MyAnimationPlayer.Play("paradoCima");
        MySprite.FlipH = false;
    }
}

}
