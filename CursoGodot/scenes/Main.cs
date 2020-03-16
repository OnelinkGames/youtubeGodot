using Godot;
using System;

public class Main : Node2D
{
    //Referencias Nodes
    public KinematicBody2D MyPersonagem;
    public Control MyGui;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        //Inicializar Nodes
        MyPersonagem = GetNode("Personagem") as KinematicBody2D;
        MyGui = GetNode("guiCanvas/GUI") as Control;

        //Conectar dano
        MyPersonagem.Connect("LevarDano", MyGui, "Dano");

        //Conectar score
        MyPersonagem.Connect("AumentarScore", MyGui, "Score");
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
