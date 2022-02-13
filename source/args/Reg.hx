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

package;

/**
 * ...
 * @author kboardgames.com
 */
//######################## NOTES ################################
// The invalid operation errors on Neko come from uninitialized variables (int, bool, float), since these are by default null on Neko.

// Checking for null errors are important. The build error on neko, the invalid operation, come from uninitialized variables. To fix do var foo:int = 0. The 0 initializes that variable.
//###############################################################

class Reg
{
	public static var _dbHost:String = "";
	public static var _dbPort:Int = 0;
	public static var _dbUser:String = "";
	public static var _dbPass:String = "";
	public static var _dbName:String = "";
	public static var _domain_path:String = "";
	public static var _smtpFrom:String = "";
	public static var _smtpHost:String = "";
	public static var _smtpPort:Int = 0;
	public static var _smtpUsername:String = "";
	public static var _smtpPassword:String = "";
	/*********************************************************************************
	 * is the server connected to the mysql database?
	 */
	public static var _mysqlConnected:Bool = false;
	
	/*********************************************************************************
	 * used to connect to server once.
	 */
	public static var _doOnce:Bool = false;
	
	/*************************************************************************
	 * only change the version number here. this value must be changed everytime this complete program with dlls are copied to the localhost/files/windows folder.
	 * no need to copy this var then paste to the bottom of this class because this value does not change while client is running.
	 */
	public static var _version:String = "1.21.3";

	/********************************************************************************
	 * when doing a request to see if a file exists at the website, this is the result of tht search.
	 * also, this var is used to compare the client's version.txt with the localhost/files/version.txt. if they do not match then a software update will happen.
	 */
	public static var _messageFileExists:String = "";
	
	/*************************************************************************
	 * website house url that ends in "/".
	 */
	public static var _websiteHomeUrl:String = "http://kboardgames.com/";	
	public static var _websiteName:String = "K Board Games.";

	
	
	public static function resetRegVarsOnce():Void
	{
		//############################ START CONFIG ###########################
		// change these values below this line.
		
		_websiteHomeUrl = "http://kboardgames.com/"; // end in trail "/"
		_messageFileExists = "";
	}
}