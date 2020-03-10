using Godot;
using System;

public class Ghost : Node2D
{   
    //Referencias Nodes
    private Tween MyTween;
    private AnimatedSprite MyAnimatedSprite;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        //Inicializar Nodes
        MyTween = GetNode<Tween>("Tween");
        MyAnimatedSprite = GetNode<AnimatedSprite>("AnimatedSprite");

        //Conectar Tween para deletar Ghost quando o Tween completar
        MyTween.Connect("tween_all_completed", this, "FimTween");

        //Iniciar interpolação da visibilidade do Ghost
        MyTween.InterpolateProperty(this, "modulate", new Color(1, 1, 1, 1), new Color(1, 1, 1, 0), (float)0.3, Tween.TransitionType.Linear, Tween.EaseType.InOut);
        MyTween.Start();
    }
    //Ao acabar a função o Ghost é deletado
    public void FimTween()
    {
        QueueFree();
    }

    //Função para alterar o FlipH do Ghost para ser igual ao do Personagem
    public void AlterarLado(bool valor)
    {
        MyAnimatedSprite.FlipH = valor;
    }
}
