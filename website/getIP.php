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

// gets the ip address of the user signing in to the server.

// this file is used at the server to get the users ip address.
// if match is found then the user is auto logged into the game. Therefore, no username field or password field is needed in the game for online play.

// the $_get is sent from server. continue only if these two codes match.
$token = $_GET["token"];
$token2 = "&EK4F8gg*E&8DF*V&R63"; // remember to change this and change it also at server main.hx file. Note that this token is not used at kboardgames.com

if ($token != $token2)
{
	echo "die";
	 die(); 
}

// get username from the server.
$username = $_GET["user"];

// an external website is the only way to get an public ip address. php cannot do it.
$url= 'http://ipecho.net/plain';

if (!function_exists('curl_init')){ 
        die('CURL is not installed!');
}

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$output = curl_exec($ch);
curl_close($ch);

// alternatively, you can use this website.
//$url = 'http://checkip.dyndns.com/');
//preg_match('/Current IP Address: \[?([:.0-9a-fA-F]+)\]?/', $externalContent, $m);
//$externalIp = $m[1];

//------------------------
// connect to the db.
$path = 'C:\secure/'; // parent folder of this script
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
$username = secure($dbh, $username);

// used to get the user's id.
$_stmt = selectUser($dbh, $username);
$_row = $_stmt->fetch(PDO::FETCH_ASSOC);

if ($_row['group_id'] == 1 || $_row['group_id'] == 6) die();

// the ip in the users table is not updated when user relogged in but this table does get updated. get the ip from the user's id.
$_stmt2 = selectIP($dbh, $_row['user_id']);
$_row2 = $_stmt2->fetch(PDO::FETCH_ASSOC);

// if ip output from external website equals ip output from table. the server will grab this output.
if ($output == $_row2['last_ip']) echo $_row2['last_ip'];

function selectUser($dbh, $username)
{			
	try {
		$stmt = $dbh->prepare("SELECT * FROM xyz_users WHERE username=:username");
		$stmt->bindParam(':username', $username);
		$stmt->execute();
		
		return $stmt;
	} catch (PDOException $e) {
		echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
		exit;
	}
}

function selectIP($dbh, $user_id)
{
	try {
		$stmt = $dbh->prepare("SELECT * FROM xyz_sessions_keys WHERE user_id=:user_id");
		$stmt->bindParam(':user_id', $user_id);
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