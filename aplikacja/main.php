<?php

$user_type = substr($_COOKIE['BDM1_log'], 10);

if(isset($_COOKIE['BDM1_log']))
{
	$log_v = $_COOKIE['BDM1_log'];
	if(strpos($log_v, "logged_as-") != 0)
    {
        header("Location: index.php");
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

		getMainHeader();
	?>

	<main>
		<h2>Kokpit <?php echo USER_TYPE_NAMES[$user_type]; ?></h2>
		<?php 
			if ($user_type == 'ksiegowa')
			{
				require_once 'main_contents/ksiegowa_main.php';
			}
		?>
	</main>

	<?php
    	require_once 'footer.php';
	?>
</body>
</html>