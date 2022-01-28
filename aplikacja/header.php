<?php

	require_once 'globals.php';

	function getSimpleHeader()
	{
		$header_template = '<header>';
		$header_template .= "\n\r<a href=\"main.php\"><img src=\"img/logo.png\" id=\"logo\" alt=\"logo\"></a>";
		$header_template .= "\n\r</header>";

		echo ($header_template);
	}

	function getMainHeader()
	{
		$header_template = '<header>';
		$header_template .= "\n\r<a href=\"main.php\"><img src=\"img/logo.png\" id=\"logo\" alt=\"logo\"></a>";
		$header_template .= "\n\r<nav>";
		$header_template .= "\n\r<a href=\"login.php?logout=1\"><i class=\"tooltip fas fa-power-off\"><span class=\"tooltiptext\">Wyloguj</span></i></a>";
		$header_template .= "\n\r</nav>";
		$header_template .= "\n\r<div>\n\r<p> Zalogowano jako: ";
		$header_template .= USER_TYPE_NAMES[substr($_COOKIE['BDM1_log'], 10)];
		$header_template .= "\n\r</p>\n\r</div>";
		$header_template .= "\n\r</header>";

		echo ($header_template);
	}

?>