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

$user = htmlspecialchars($_GET["u"]);  
$email_address_validation_code = htmlspecialchars($_GET["v"]);  

if ($user == "" || $email_address_validation_code == "")
{
	echo "die";
	 die(); 
}

//------------------------
// connect to the db.
$path = 'secure/'; // parent folder of this script
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

$_stmt = selectUser($dbh, $user);
$row = $_stmt->fetch(PDO::FETCH_ASSOC);

$email_address = $row['email_address_needing_validation'];
$email_address_validation_code2 = $row['email_address_validation_code'];

if ($email_address_validation_code == $email_address_validation_code2
&&	$email_address_validation_code != "")
{
	$email_address_validation_code = 0;
	$email_address_needing_validation = "";
	
	$_stmt = updateEmailAddress($dbh, $user, $email_address, $email_address_needing_validation, $email_address_validation_code);
}

else 
{
	echo "Email address failed validation. ";
	
	if ($email_address_validation_code2 == 0)
		echo "Your email address is already validated.";
	else
		echo "Wrong validation code";
}

function selectUser($dbh, $user)
{
	try {
		$stmt = $dbh->prepare("SELECT * FROM users WHERE user=:user");
		$stmt->bindParam(':user', $user);
		$stmt->execute();
		
		return $stmt;
	} catch (PDOException $e) {
		echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
		exit;
	}
}

function updateEmailAddress($dbh, $user, $email_address, $email_address_needing_validation, $email_address_validation_code)
{
	$player1 = $user;
	
	try {
		$stmt = $dbh->prepare("UPDATE tournament_chess_standard_8 SET email_address=:email_address WHERE player1=:player1");
		$stmt->bindParam(':player1', $player1);
		$stmt->bindParam(':email_address', $email_address);
		$stmt->execute();
		
		$stmt = $dbh->prepare("UPDATE users SET email_address=:email_address, email_address_needing_validation=:email_address_needing_validation, email_address_validation_code=:email_address_validation_code WHERE user=:user");
		$stmt->bindParam(':user', $user);
		$stmt->bindParam(':email_address', $email_address);
		$stmt->bindParam(':email_address_needing_validation', $email_address_needing_validation);
		$stmt->bindParam(':email_address_validation_code', $email_address_validation_code);
		$stmt->execute();
		echo "Your email address was successfully validated.";
		return $stmt;
		
	} catch (PDOException $e) {
		echo $e->getMessage().' in '.$e->getFile().' on line '.$e->getLine();
		exit;
	}
}
?>