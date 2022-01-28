<?php

require_once('conn_configuration.php');

function openDatabase()
{
	$conn = oci_connect(DB_USERNAME, DB_PASSWORD, DB_CONNECTION_STRING, DB_ENCODING);
	if (!$conn)
	{
		$m = oci_error();
		echo "<p class=\"error\">" . $m['message'] . "</p>";
		return NULL;
	}
	else
	{
		return $conn;
	}
}

?>