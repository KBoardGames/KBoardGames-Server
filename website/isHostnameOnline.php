<?PHP

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

// check is hostname exists. if true then user will be disconnected because only 1 device is allowed to be online.

// the $_get is sent from server. continue only if these two codes match.
$token = $_GET["token"];
$token2 = "H77Wox53m7syw6Ng";

if ($token != $token2)
{
	echo "die";
	 die(); 
}

// get hostname from the server.
$hostname = $_GET["hostname"];

//------------------------
// connect to the db.
$path = 'C:\xampp\secure/'; // parent folder of this script
$filename = 'config.php';
$file = $path . DIRECTORY_SEPARATOR . $filename;
require $file;

try {
	$dbh = new PDO("mysql:host=$dbHost;dbname=$dbName", $dbUsername, $dbPassword);
} catch (PDOException $e) {
	echo $e->getMessage();
}

$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$dbh->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
ini_set('display_errors', 1);
//.........................

// use security on the strings that were populated from the $_GET.
$token = secure($dbh, $token);
$hostname = secure($dbh, $hostname);

// used to get the user's hostname.
$_stmt = selectUser($dbh, $hostname);
$_row = $_stmt->fetch(PDO::FETCH_ASSOC);

if ($_row['hostname'] != "" && $_row['hostname'] != null) echo $_row['hostname'];
else echo "nobody";

function selectUser($dbh, $hostname)
{			
	try {
		$stmt = $dbh->prepare("SELECT * FROM logged_in_hostname WHERE hostname=:hostname");
		$stmt->bindParam(':hostname', $hostname);
		$stmt->execute();
		
		return $stmt;
	} catch (PDOException $e) {
		echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
		exit;
	}
}

//----------------------------

function secure($dbh, $value) {

	// Stripslashes
	if (get_magic_quotes_gpc()) {
	$value = stripslashes($value);
	}

	return $value;
}
?>