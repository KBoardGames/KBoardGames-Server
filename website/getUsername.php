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

// this file is used at the server to found the username from an IP address.

// if match is found then the user is logged into the game. Therefore, no password field is needed in the game for online play.

// the $_get is sent from server. continue only if these two codes match.
$token = $_GET["token"];
$token2 = "fi37cv%PFq5*ce78"; // remember to change this and change it also at server main.hx file. Note that this token is not used at kboardgames.com

if ($token != $token2)
{
	//echo $token;
	die(); 
}

// get IP from the server.
$ip = $_GET['ip'];

// an external website is the only way to get an public IP address. php cannot do it.
$url= 'http://ipecho.net/plain';

if (!function_exists('curl_init'))
{
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
$externalIp = $m[1];

//------------------------
// connect to the db.
$path = '..secure/'; // parent folder of this script
$filename = 'conf.php';
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
$ip = secure($dbh, $ip);

// at this function the users table has an updated user's id each time the user logs into the website. get the id from the sessions table.
// used to get the username from the id of that table row.
$_stmt = selectUsername($dbh, $ip);
$_row = $_stmt->fetch(PDO::FETCH_ASSOC);

// phpbb forum user groups.
if ($_row['group_id'] == 1 || $_row['group_id'] == 6)
{
	die();
}

if ($_row['user_ip'] == "127.0.0.1") 
{
	echo $_row['username'];
	die();
}

// if ip output from external website equals ip output from table. the server will grab this output.
else if (isset($_row['username']) && $_row['username'] != "Anonymous" )
{
	if ($ip == $_row['user_ip'])
	{
 		echo $_row['username'];
		die();
	}
}

function selectUsername($dbh, $user_ip)
{
	$user_ip2 = "127.0.0.1";		

	try {
		$stmt = $dbh->prepare("SELECT * FROM xyz_users WHERE user_ip=:user_ip OR user_ip=:user_ip2");
		$stmt->bindParam(':user_ip', $user_ip);
		$stmt->bindParam(':user_ip2', $user_ip2);
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