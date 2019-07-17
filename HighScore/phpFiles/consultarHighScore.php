<?php
//Incluir arquivo de conexão
include ("database.php");

//Recuperar valor do POST
$atualScore = $_POST["score"];
$passkey = $_POST["code"];

//Limpar String
$atualScore = preg_replace('/[^[:alnum:]_]/', '',$atualScore);
$passkey = preg_replace('/[^[:alnum:]_]/', '',$passkey);

//Verificar senha e sair se der erro.
if ($passkey != $passCodeKey) {
	echo(json_encode("Senha errada"));
	exit();
}

//Criar Tabela
$tabela = "CREATE TABLE IF NOT EXISTS highscore (
id INT(5) UNSIGNED AUTO_INCREMENT,
nome VARCHAR(20) NOT NULL,
score INT(15) NOT NULL,
PRIMARY KEY(id))ENGINE=MyISAM";
$criar_tabela = $conexao->query($tabela);

//Pesquisar tabela
$pesquisar = "SELECT * FROM highscore";
$retorno = $conexao->query($pesquisar);

//Pegar quantidade de linhas
$quantidade = $retorno->num_rows;

//Verificar Quantidade
if ($quantidade == 0) {
	//Se 0 cria novo cadastro.
	$cadastro = "INSERT INTO highscore(nome, score) VALUES ('NOOB', 0)";
	$criarCadastro = $conexao->query($cadastro);
	
	//Autoriza inserir score
	$retorno = "Verdadeiro";
	$retorno = json_encode($retorno);
	echo($retorno);
} else {
	//Realizar outra pesquisa
	$pesquisar = "SELECT score FROM highscore ORDER BY score DESC LIMIT 10";
	$retorno = $conexao->query($pesquisar);
	
	//Pegar ultimo valor desta pesquisa.
	 while ($row = $retorno->fetch_array(MYSQLI_BOTH)) {
		$valor = $row[0];
	 }
	
	//Realizar questionamento
	if ($valor < (int)$atualScore) {
		//Autoriza inserir score
		$retorno = "Verdadeiro";
		$retorno = json_encode($retorno);
		echo($retorno);
	} else {
		//Autoriza inserir score
		$retorno = "Falso";
		$retorno = json_encode($retorno);
		echo($retorno);
	}
}

//Fechar a conexão
$conexao->close();
?>