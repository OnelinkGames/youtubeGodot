<?php
//Incluir arquivo de conexão
include ("database.php");

//Realizar pesquisa
$pesquisar = "SELECT * FROM highscore ORDER BY score DESC LIMIT 10";
$retorno = $conexao->query($pesquisar);

//Inicializar JSON
$jsonString = new \stdClass();;
$quantidade = 0;
while ($row = $retorno->fetch_array(MYSQLI_BOTH)) {
	//Atalho para as Strings
	$nomeString = "nome" . $quantidade;
	$scoreString = "score" . $quantidade;
	
	//Montar JSON
	$jsonString->$nomeString = $row[1];
	$jsonString->$scoreString = $row[2];
	
	//Somar Quantidade
	$quantidade++;
}

//Mostrar Resultados
$stringFinal = json_encode($jsonString);
echo($stringFinal);

//Fechar a conexão
$conexao->close();
?>