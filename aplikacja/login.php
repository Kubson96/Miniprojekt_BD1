<?php

const USER_TYPES = array('klient', 'ksiegowa', 'kadrowa', 'dostawca', 'kierownik', 'magazynier');
$logged_as = '';

$user_type = '';

if (isset($_GET['user']))
{
	$user_type = $_GET['user'];
	foreach (USER_TYPES as &$val) {
		if ($val == $user_type) {
			$logged_as = $val;
			setcookie('BDM1_log', 'logged_as-'.$val, time()+86400);
		}
	}
}

if (empty($logged_as) == false)
{
	header("Location: main.php");
}
else
{
	header("Location: index.html");
}

if (isset($_GET['logout']))
{
    setcookie('BDM1_log', '', time()-3600);

    header("Location: index.php");
}

?>