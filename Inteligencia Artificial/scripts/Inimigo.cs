using Godot;
using System;

public class Inimigo : KinematicBody2D
{   
	//Nodes
	private Timer MyTimerPatrulha;
	private Area2D MyDetectorVisao;
	private Area2D MyArea2D;
	private AnimationPlayer MyAnimationPlayer;
	private Sprite MySprite;
	private Label MyAlerta;
	private Timer MyTimerAlerta;
	private Tween MyTween;
	private Area2D MyAtaquePersonagem;

	//Variaveis
	private enum estados {PATRULHAR, PERSEGUIR, PROCURAR, RETORNAR, ATACAR};
	private String estado;
	private Vector2 direcao = new Vector2();
	private int velocidade = 70;
	private Vector2 posInicial = new Vector2();
	private KinematicBody2D personagem;
	private bool procurar = false;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		//Inicializar Nodes
		MyTimerPatrulha = GetNode("TimerPatrulha") as Timer;
		MyDetectorVisao = GetNode("DetectorVisao") as Area2D;
		MyArea2D = GetNode("DetectorSom") as Area2D;
		MyAnimationPlayer = GetNode("AnimationPlayer") as AnimationPlayer;
		MySprite = GetNode("Sprite") as Sprite;
		MyAlerta = GetNode("Alerta") as Label;
		MyTimerAlerta = GetNode("TimerAlerta") as Timer;
		MyTween = GetNode("Tween") as Tween;
		MyAtaquePersonagem = GetNode("AtaquePersonagem") as Area2D;

		//Conexões dos Nodes
		MyTimerPatrulha.Connect("timeout", this, "TempoPatrulha");
		MyArea2D.Connect("area_entered", this, "EntrouAreaSom");
		MyArea2D.Connect("area_exited", this, "SaiuAreaSom");
		MyDetectorVisao.Connect("area_exited", this, "SaiuAreaVisao");
		MyDetectorVisao.Connect("area_entered", this, "EntrouAreaVisao");
		MyTimerAlerta.Connect("timeout", this, "SumirAlerta");
		MyTween.Connect("tween_completed", this, "RetornarBase");
		MyAtaquePersonagem.Connect("area_entered", this, "AtacarPersonagem");
		MyAtaquePersonagem.Connect("area_exited", this, "PararAtaquePersonagem");

		//Estado inicial
		posInicial = Position;
		estado = estados.PATRULHAR.ToString();
		direcao.x = 1;
		direcao.y = 0;
		MyTimerPatrulha.Start();
	}

// Called every frame. 'delta' is the elapsed time since the previous frame.
public override void _PhysicsProcess(float delta)
{
	//Maquina de estados
	switch (estado)
	{
		case "PATRULHAR":
			_PATRULHAR();
			break;
		
		case "PERSEGUIR":
			_PERSEGUIR();
			break;
		
		case "PROCURAR":
			_PROCURAR();
			break;
		
		case "RETORNAR":
			_RETORNAR();
			break;
		
		case "ATACAR":
			_ATACAR();
			break;
	}

	//Rodar e calcular animação do inimigo
	Animacao();

	//Rotação da colisão de visão do inimigo
	MyDetectorVisao.Rotation = direcao.Normalized().Angle();
}

//Função para começar a retornar a base.
public void RetornarBase(System.Object obj, NodePath key) {
	if (obj == this)
		procurar = true;
}

//Função para alterar o texto de acordo com a necessidade
public void MudarAlerta(String texto, Color cor, int tempo) {
	MyAlerta.Text = texto;
	MyAlerta.Modulate = cor;
	MyAlerta.Visible = true;
	MyTimerAlerta.WaitTime = tempo;
	MyTimerAlerta.CallDeferred("start");
}

//Função para sumir o alerta
public void SumirAlerta() {
	MyAlerta.Visible = false;
}

//Função para Animação do Personagem
public void Animacao() {
	var angle = Mathf.Rad2Deg(direcao.Normalized().Angle());
	if ((angle >= 0 && angle <= 50) || (angle <= 0 && angle >= -50)) {
		MyAnimationPlayer.Play("andarHorizontal");
		MySprite.FlipH = false;
	}

	if ((angle >= 130 && angle <= 180) || (angle <= -130 && angle >= -180)) {
		MyAnimationPlayer.Play("andarHorizontal");
		MySprite.FlipH = true;
	}

	if (angle >= 51 && angle <= 129) {
		MyAnimationPlayer.Play("andarBaixo");
		MySprite.FlipH = false;
	}

	if (angle <= -51 && angle >= -129) {
		MyAnimationPlayer.Play("andarCima");
		MySprite.FlipH = false;
	}
}
//Função para trocar direção da patrulha.
public void TempoPatrulha() {
	//Variavel de controle
	bool controle = true;

	//Verificar troca de direção
	if (estado == "PATRULHAR")
	{
		if (direcao == new Vector2(1, 0) && controle)
		{
			direcao = new Vector2(0, -1);
			controle = false;
		}

		if (direcao == new Vector2(0,-1) && controle)
		{
			direcao = new Vector2(-1, 0);
			controle = false;
		}

		if (direcao == new Vector2(-1,0) && controle)
		{
			direcao = new Vector2(0, 1);
			controle = false;
		}

		if (direcao == new Vector2(0,1) && controle)
		{
			direcao = new Vector2(1, 0);
			controle = false;
		}

		//Reiniciar tempo para mudar direção da patrulha
		MyTimerPatrulha.Start();
	}
}

//Sinal entrou na area de som
public void EntrouAreaSom(Area2D body) {
	if (body.IsInGroup("personagem")) {
		MudarAlerta("!", new Color("#ff0066"), 2);
		personagem = body.Owner as KinematicBody2D;
		estado = estados.PERSEGUIR.ToString();
		MyTween.StopAll();
		procurar = false;
	}
}

//Sinal entrou na de visão
public void EntrouAreaVisao(Area2D body) {
	if (body.IsInGroup("personagem")) {
		MudarAlerta("!", new Color("#ff0066"), 2);
		personagem = body.Owner as KinematicBody2D;
		estado = estados.PERSEGUIR.ToString();
		MyTween.StopAll();
		procurar = false;
	}
}

//Sinal sair da area de som
public void SaiuAreaSom(Area2D body) {
	//NULL
}

//Sinal sair da area de visão
public void SaiuAreaVisao(Area2D body) {
	if (body.IsInGroup("personagem")) {
		personagem = null;
		estado = estados.PROCURAR.ToString();
		MudarAlerta("?", new Color("#6699ff"), 5);
		MyTween.InterpolateMethod(this, "PersonagemProcurar", Mathf.Rad2Deg(direcao.Normalized().Angle()), Mathf.Rad2Deg(direcao.Normalized().Angle()) + 6, 5, Tween.TransitionType.Linear, Tween.EaseType.In);
		MyTween.CallDeferred("start");
	}
}

//Personagem realizar busca
public void PersonagemProcurar(float graus) {
	direcao = new Vector2(Mathf.Sin(graus), Mathf.Cos(graus));
}

//Sinal para entrar na area de ataque.
public void AtacarPersonagem(Area2D body) {
	if (body.IsInGroup("personagem")) {
		if (estado == estados.PERSEGUIR.ToString()) {
			estado = estados.ATACAR.ToString();
		}
	}
}

//Sinal para sair da area de ataque.
public void PararAtaquePersonagem(Area2D body) {
	if (body.IsInGroup("personagem")) {
		if (estado == estados.ATACAR.ToString()) {
			estado = estados.PERSEGUIR.ToString();
		}
	}
}

//Metodo para PATRULHAR
public void _PATRULHAR() {
	MoveAndSlide(direcao * velocidade);
}

//Metodo para Perseguir
public void _PERSEGUIR() {
	direcao = (personagem.Position - Position).Normalized() * velocidade;
	MoveAndSlide(direcao);
}

//Metodo para Procurar
public void _PROCURAR() {
	if (procurar) {
		estado = estados.RETORNAR.ToString();
	}
}

//Metodo para Retornar
public void _RETORNAR() {
	direcao = (posInicial - Position).Normalized() * velocidade;
	MoveAndSlide(direcao);

	if (Position.DistanceTo(posInicial) < 5) {
		direcao = new Vector2(1, 0);
		MyTimerPatrulha.Stop();
		MyTimerPatrulha.Start();
		estado = estados.PATRULHAR.ToString();
		procurar = false;
	}
}

//Metodo para Atacar
public void _ATACAR() {
	direcao = (personagem.Position - Position).Normalized();
	MyAnimationPlayer.Stop();
}

}