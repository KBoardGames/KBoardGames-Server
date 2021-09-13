<?php

/*
    Copyright (c) 2021 KBoardGames.com
    This program is part of KBoardGames server software.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

// author kboardgames.com

// check to see if this is a paid IP address. here we search the MySQL database table "users" with this IP address to see if the data found has a value of 1 which is a paid account.

$path = 'secure/'; // parent folder of this script
$filename = 'mysql_conf.php';
$file = $path . DIRECTORY_SEPARATOR . $filename;
require $file;

$filename = 'mysqlDB.php';
$file = $path . DIRECTORY_SEPARATOR . $filename;
require $file;

$mysqlDB = new MysqlDB();
try {
	global $dbh;
	$dbh = new PDO("mysql:host=$dbHost;dbname=$dbName", $dbUsername, $dbPassword);
} catch (PDOException $e) {
	echo "Access Denied.";
	//echo $e->getMessage();
}

$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$dbh->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
ini_set('display_errors', 1);


if (isset($_GET["serverDomain"]))
{
	$serverDomain = $_GET["serverDomain"];
	$stmt = $mysqlDB->selectServerDomain($dbh, $serverDomain);

	$row = $stmt->fetch(PDO::FETCH_ASSOC);

	// send data back to the client.
	if ($row['server_domain'] != "") echo $row['server_domain'];
		
}
?>