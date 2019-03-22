<?php
//Dados de Conexão
$hostbd = "seuHost";
$userbd = "seuUsuario";
$passwordbd = "suaSenha";
$bd = "seuBancoDeDados";
$passCodeKey = "suaSenhaDeComunicação";

//Banco de Dados Conexão
$conexao = new mysqli($hostbd, $userbd, $passwordbd, $bd);

//Mensagem de erro
if (mysqli_connect_errno()) 
    trigger_error(mysqli_connect_error());
?>