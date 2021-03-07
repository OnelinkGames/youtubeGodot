using Godot;
using System;

public class Control : Godot.Control
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";
    private FileDialog myFile;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        myFile = GetNode("FileDialog") as FileDialog;
        myFile.Connect("confirmed", this, "teste");
        myFile.Popup_();
    }

    public void teste() {
        GD.Print("Olá");
    }
//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
