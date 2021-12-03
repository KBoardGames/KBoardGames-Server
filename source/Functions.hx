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
class Functions
{
	/****************************************************************************
	 * user activity log files at the logs folder. everytime an server event is called from the client, this is the name of the log file in date format of yead month day. eg, 2020-01-15.txt
	 */
	public static var _logDate:String = "";
	
	/****************************************************************************
	 * user activity log files at the logs folder. everytime an server event is called from the client, inside of the log file, each entry will append to the bottom of the file. the beginning on that entry will be the time the user entered into the event.
	 */
	public static var _logTime:String = "";
		
	/****************************************************************************
	 * user activity log files at the logs folder. everytime an server event is called from the client, this is the user ID. see client typedef, the id data.
	 */
	public static var _logsuserId:Array<String> = [];
	
	/****************************************************************************
	 * user activity log files at the logs folder. everytime an server event is called from the client, this is the username of the player from client.
	 */
	public static var _logsUsername:Array<String> = [];
	
	/**
	 * output the event name to server console then save the event data to the log file.
	 * @param	_event			the event the user is at.
	 * @param	_id				the id of the typedef being sent as event _data.
	 * @param	_user			the username.
	 * @param	_dataDump		all vars within the typedef of that event.
	 */
	public static function userLogs(_event:String, _id:String = "", _user:String = "", _dataDump:Dynamic = null):Void
	{
		_logDate = DateTools.format(Date.now(), "%Y-%m-%d"); // year, month, day
		_logTime = DateTools.format(Date.now(), "%H:%M:%S"); // hour, minute, sec
		
		// output the events. used for bug tracking.
		if (_dataDump != null)
		{
			if (_dataDump != "")
			{
				if (_dataDump._triggerEvent != "null") 
				{
					if (_event != "Message Ban"
					&&  _event != "Message Kick"
					&&  _event != "Is Host")
					{
						if (_user == "null") trace ("User Unknown :" + _event);
						else
							trace(Std.string(_logDate + " " + _logTime) + " " + _user + ": " + _event);
					}
				}
			}
		}
		
		Reg._usernameLastLogged = "";
		if (_user != null && _user != "") Reg._usernameLastLogged = _user; // this is needed at server connectiom.hx to display an error if any for the last known user that entered a server event. remember that at the top of most server events there is a call to the userLogs function. so when an error message is displayed, we know where the error came from and also know what user triggered the error.
		
		// if true then user has logged in. store both the _id of the user and the users name then every other time that this log is called, the id will be passed here from the events the user called. the username will be found here using the id value. the reason for this method is that at client, most typedefs do not have a username field but they all have a player id.
		if (_event != "" && _user != "")
		{
			_logsuserId.push(_id);
			_logsUsername.push(_user);
		}
		
		// get username from _id.
		else if (_user == "")
		{
			for (i in 0..._logsuserId.length + 1)
			{
				if (_id == _logsuserId[i])
				{
					_user = _logsUsername[i];				
				}
			}
		}
		
		if (_user == "") _user = "User logged in.";
		
		// dump the complete _data var.
		var saveFile = sys.io.File.append("logs/" + Std.string(_logDate) + "-dump.txt");
		if (_dataDump != null)
			saveFile.writeString(Std.string(_logTime) + ": " + _user + " at event " + _event + ". Data dump: " + _dataDump + ".\r\n\r\n");
		else saveFile.writeString(Std.string(_logTime) + ": " + _user + " at event " + _event + ".\r\n\r\n");
		
		saveFile.close();
		
		// a thinned out version of the above file save.
		var saveFile = sys.io.File.append("logs/" + Std.string(_logDate) + "-min.txt");
		saveFile.writeString(Std.string(_logTime) + ": " + _user + " at event " + _event + ".\r\n");
		
		saveFile.close();
		
		
		// TODO sometimes trace break things and other times it makes code work that should not. remove this line after you bug test the server.
		//trace("event "+_event);
		/*if (_dataDump != null)
		{
			if (_dataDump._username != null)
				trace("RegTypedef._dataPlayers._usernamesStatic " + Std.string(_dataDump._usernamesStatic));	
			if (_dataDump._username != null)
				trace("RegTypedef._dataPlayers._usernamesDynamic " + Std.string(_dataDump._usernamesDynamic));
		}*/
	}
	
	
	// here we use the ip address to find the username of the user logged into the website. if found, the user will be sent to the lobby.
	public static function getUsername(_ip:String):String
	{
		_ip = "&ip=" + _ip;
		
		// DO NOT USE SPECIAL CHARACTERS IN THIS TOKEN IT MAY BREAK LOGINS.
		var _token = "token=fi37cvPFq5ce78";
		var _str = Reg._websiteHomeUrl + "server/getUsername.php?" + _token + _ip;		
		var _http = new haxe.Http(_str);		
		var _data:String = "";
		
		_http.onData = function (data:String) 
		{
			if (data.substr(0, 1) == "<") 
			{
				// display error message.
			}
			
			else 
			{
				// we found the file if we are here.
				if (data == "")
				{
					_data = "";
				}
				
				else _data = data;
			}
		}

		_http.onError = function (_error)
		{			
		}
		
		_http.request();
		return _data;
	}
	
	//############################## START OF CHESS ELO CALCULATIONS.
	/**
	 * Function to calculate the chess elo Probability
	 * @param	rating1		player 1
	 * @param	rating2		player 2
	 * @return
	 */
	public static function eloProbability(rating1:Float, rating2:Float):Float
	{
		return 1.0 * 1.0 / (1 + 1.0 * 
			   Math.pow(10, 1.0 * (rating1 - rating2) / 400));
	}
	  
	/**
	 * Function to calculate chess Elo rating
	 * @param	_chess_elo_rating[0]		player 1 current elo rating.
	 * @param	_chess_elo_rating[1]		player 2 current elo rating.
	 * @param	_chess_elo_k				constant/power
	 * @param	_chess_did_player1_win		determines whether Player A wins or Player B.
	 */
	public static function EloRating(_user1:String, _user2:String, _chess_elo_rating1:Float, _chess_elo_rating2:Float, _chess_elo_k:Int, _chess_did_player1_win:Bool):Void
	{    
		// To calculate the Winning. Probability of Player B
		var _player2 = eloProbability(_chess_elo_rating1, _chess_elo_rating2);
		  
		// To calculate the Winning. Probability of Player A
		var _player1 = eloProbability(_chess_elo_rating2, _chess_elo_rating1);
		  
		// Case -1 When Player A wins
		// Updating the Elo Ratings
		if (_chess_did_player1_win == true) {
			_chess_elo_rating1 = _chess_elo_rating1 + _chess_elo_k * (1 - _player1);
			_chess_elo_rating2 = _chess_elo_rating2 + _chess_elo_k * (0 - _player2);
		}
		  
		// Case -2 When Player B wins
		// Updating the Elo Ratings
		else {
			_chess_elo_rating1 = _chess_elo_rating1 + _chess_elo_k * (0 - _player1);
			_chess_elo_rating2 = _chess_elo_rating2 + _chess_elo_k * (1 - _player2);
		}

		// save new chess elo rating.
		var _mysqlDB = new MysqlDB();
		_mysqlDB.updateChessEloRating(_user1, _chess_elo_rating1);
		_mysqlDB.updateChessEloRating(_user2, _chess_elo_rating2);
	}
	
	/**************************************************************************
	 * deletes these tables when user first logs in and when user is disconnecting.
	 * _dataMisc is passed as a paranmeter of _data here.
	 */
	public static function deleteRowsFromDatabase(_data:Dynamic):Void
	{
		var _mysqlDB = new MysqlDB();
		_mysqlDB.delete_hostname_at_logged_in_hostname(_data._hostname);
		_mysqlDB.delete_user_at_logged_in_user_table(_data._username);
		// also deletes table who_is_host and table room_lock at this line.
		_mysqlDB.delete_tables_user_logged_off(_data._username);
		_mysqlDB.delete_user_no_kicked_or_banned(_data._username);
		_mysqlDB.deleteIsHost(_data._username); 
	}
	
	public static function hostCpuUserNames():Void
	{
		// create the cpu host names for room a and b.
		while (Reg._cpu_host_name1 == "" && Reg._cpu_host_name2 == "")
		{
			var _int = Std.random(5);
			
			// assign the cpu host name that will be used at lobby room a.
			if (Reg._cpu_host_name1 == "")
			{
				if (_int == 0) Reg._cpu_host_name1 = Reg._cpu_host_names[0];
				if (_int == 1) Reg._cpu_host_name1 = Reg._cpu_host_names[1];
				if (_int == 2) Reg._cpu_host_name1 = Reg._cpu_host_names[2];
				if (_int == 3) Reg._cpu_host_name1 = Reg._cpu_host_names[3];
				if (_int == 4) Reg._cpu_host_name1 = Reg._cpu_host_names[4];
			}
			
			var _int = Std.random(4);
			
			// assign the cpu host name that will be used at lobby room a.
			if (Reg._cpu_host_name2 == "")
			{
				if (_int == 0) Reg._cpu_host_name2 = Reg._cpu_host_names[0];
				if (_int == 1) Reg._cpu_host_name2 = Reg._cpu_host_names[1];
				if (_int == 2) Reg._cpu_host_name2 = Reg._cpu_host_names[2];
				if (_int == 3) Reg._cpu_host_name2 = Reg._cpu_host_names[3];
				if (_int == 4) Reg._cpu_host_name2 = Reg._cpu_host_names[4];
			}

			// Reg._cpu_host_name1 and Reg._cpu_host_name2 are now with a host name but if they have the same host name then clear these var data so that the loop can continue.
			// note that this will always be true for the first loop because random values are not truly random if the seed is not set.
			if (Reg._cpu_host_name1 == Reg._cpu_host_name2)
			{
				Reg._cpu_host_name1 = "";
				Reg._cpu_host_name2 = "";
			}			
		}
	}
	
		// gets ip from a website file. if ip is not found then user cannot login. therefore, user must first login to the website before this works.
	public static function getIP(_username:String):String
	{
		_username = "&user=" + _username;
		_username = StringTools.replace(_username, " ", "%20");
		
		var _token = "token=fi37cv%PFq5*ce78";
		var _str = Reg._websiteHomeUrl + "server/getIP.php?" + _token + _username;		
		var _http = new haxe.Http(_str);		
		var _data:String = "";
				
		_http.onData = function (data:String) 
		{
			if (data.substr(0, 1) == "<") 
			{
				// display error message.
			}
			
			else 
			{
				// we found the file if we are here.
				if (data == "")
				{
				}
				
				else _data = data;
			}
		}

		_http.onError = function (_error)
		{			
		}
		
		_http.request();
		return _data;
	}

	
}