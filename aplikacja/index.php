<?php
if(isset($_COOKIE['BDM1_log']))
{
	$log_v = $_COOKIE['BDM1_log'];
	if(strpos($log_v, "logged_as-") == 0)
    {
        header("Location: main.php");
    }
}
?>

<!DOCTYPE html>
<html lang="pl">
<head>
	<?php require_once 'html_head.php'; ?>
	<title>Sklep meblowy - miniprojekt BD1</title>
</head>
<body>

	<?php
		require_once 'header.php';

		getSimpleHeader();
	?>

	<main>
		<h2>Wybierz widok bazy</h2>
		<ul>
			<li> <a href="login.php?user=klient"> Klient </a> </li>
			<li> <a href="login.php?user=ksiegowa"> Księgowa </a> </li>
			<li> <a href="login.php?user=kadrowa"> Kadrowa </a> </li>
			<li> <a href="login.php?user=dostawca"> Dostawca </a> </li>
			<li> <a href="login.php?user=kierownik"> Kierownik </a> </li>
			<li> <a href="login.php?user=magazynier"> Magazynier </a> </li>
		</ul>
	</main>

	<?php
    	require_once 'footer.php';
	?>
</body>
</html>