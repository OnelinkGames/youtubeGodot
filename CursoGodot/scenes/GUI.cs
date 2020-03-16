using Godot;
using System;

public class GUI : Control
{
    //Referencias Nodes
    public TextureProgress MyProgressBar;
    public RichTextLabel MyScore;

    //Variaveis
    public int currentScore = 0;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        //Inicializar Nodes
        MyProgressBar = GetNode("ProgressBar") as TextureProgress;
        MyScore = GetNode("score") as RichTextLabel;
    }

    //Função para diminuir o hp
    public void Dano(int dano)
    {
        MyProgressBar.Value -= dano;
    }

    //Função para aumentar o score
    public void Score(int score)
    {
        currentScore += score;
        MyScore.Text = "Score: " + currentScore.ToString();
    }
}
