<?php
//Incluir arquivo de conexão
include ("database.php");

//Recuperar valor do GET
$atualScore = $_POST["score"];
$nome = $_POST["nome"];
$passkey = $_POST["code"];

//Limpar String
$atualScore = preg_replace('/[^[:alnum:]_]/', '',$atualScore);
$nome = preg_replace('/[^[:alnum:]_]/', '',$nome);
$passkey = preg_replace('/[^[:alnum:]_]/', '',$passkey);

//Verificar senha e sair se der erro.
if ($passkey != $passCodeKey) {
	echo(json_encode("Senha errada"));
	exit();
}

//Cadastrar highScore
$cadastrar = "INSERT INTO highscore(nome, score) VALUES ('$nome', $atualScore)";
$retornoCadastrar = $conexao->query($cadastrar);

//Realizar outra pesquisa
$pesquisar = "SELECT score FROM highscore ORDER BY score DESC LIMIT 10";
$retorno = $conexao->query($pesquisar);
	
//Pegar ultimo valor desta pesquisa.
while ($row = $retorno->fetch_array(MYSQLI_BOTH)) {
	$valor = $row[0];
}

//Deleter valores menores
$excluir = "DELETE FROM highscore WHERE score < $valor";
$retorno_excluir = $conexao->query($excluir);

//Mostrar retorno
$retorno = "mostrarForm";
$retorno = json_encode($retorno);
echo($retorno);

//Fechar a conexão
$conexao->close();
?>