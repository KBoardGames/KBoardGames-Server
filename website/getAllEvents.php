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

// Author kboardgames.com
// server gets all the event names and event description from the website.

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

// get all event names.
if (isset($_GET["getAllEventNames"]))
{
	$str = "";

	$stmt = $mysqlDB->getAllEvents($dbh);

	while ($row = $stmt->fetch(PDO::FETCH_ASSOC))
	{
		// send data back to the client.
		if ($row['name'] != "") $str .= $row['name'] . ";DESCRIPTION;" . $row['description'] . ";MONTHS;" . $row['month_0'] . ";" . $row['month_1'] . ";" . $row['month_2'] . ";" . $row['month_3'] . ";" . $row['month_4'] . ";" . $row['month_5'] . ";" . $row['month_6'] . ";" . $row['month_7'] . ";" . $row['month_8'] . ";" . $row['month_9'] . ";" . $row['month_10'] . ";" . $row['month_11'] . ";DAYS;" . $row['day_1'] . ";" . $row['day_2'] . ";" . $row['day_3'] . ";" . $row['day_4'] . ";" . $row['day_5'] . ";" . $row['day_6'] . ";" . $row['day_7'] . ";" . $row['day_8'] . ";" . $row['day_9'] . ";" . $row['day_10'] . ";" . $row['day_11'] . ";" . $row['day_12'] . ";" . $row['day_13'] . ";" . $row['day_14'] . ";" . $row['day_15'] . ";" . $row['day_16'] . ";" . $row['day_17'] . ";" . $row['day_18'] . ";" . $row['day_19'] . ";" . $row['day_20'] . ";" . $row['day_21'] . ";" . $row['day_22'] . ";" . $row['day_23'] . ";" . $row['day_24'] . ";" . $row['day_25'] . ";" . $row['day_26'] . ";" . $row['day_27'] . ";" . $row['day_28'] . ";BACKGROUND_COLOUR;" . $row['background_colour'] . ";END;";
	}

	if ($str != "") echo $str;
}

?>