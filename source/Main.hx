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

/**
 * ...
 * @author kboardgames.com
 */

import Reg;
import haxe.MainLoop;
import haxe.Serializer;
import haxe.Unserializer;
import sys.FileSystem;
import vendor.ws.Types;
import vendor.ws.Log;
import vendor.ws.WebSocketHandler;
import vendor.ws.WebSocketServer;

class Main 
{
	//***************************** CONFIG.
		// populate the lobby with users. Useful for taking screenshots to show a busy server.
		private var _dummyData:Bool = false;
		
		/******************************
		 * room total displayed at client lobby.
		 * NOTE: remember to change player_game_state_value_username and player_game_state_value_data to this value.
		 */
		public var _room_total:Int = 24;
		
		/******************************
		 * the total server that can go online.
		 */
		public var _total_servers:Int = 30;
		public var _maximum_server_connections:Int = 119;
		
	//*****************************
	
	public static var _rated_game:Array<Int> =
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
						 
	/******************************
	* this var is populated from events and at the disconnect event it is passed to the other users. This var is needed because static usernames of the room cannot be taken from the database since a player might have left the room before a request to get the static players values.
	 * is the player playing a game or waiting to play.
	 * this holds the username.
	 * 0: = not playing but still at game room. 
	 * 1: playing a game. 
	 * 2: left game room while still playing it. 
	 * 3: left game room when game was over. 
	 * 4: quit game.
	 */
	public var player_game_state_value_username:Array<Array<String>> = 
	[for (y in 0...24) [for (x in 0...4) ""]];
	
	/******************************
	 * this var is populated from events and at the disconnect event it is passed to the other users. This var is needed because static usernames of the room cannot be taken from the database since a player might have left the room before a request to get the static players values.
	 * // the vars hold the state of a player's game, such as, did the player quit the game, or is the player at the game room but is not playing the game? these vars are at the button of events that use these vars and also at the disconnect event so that the player can send these updated vars to other players in that room. those other players need these vars to that a proper message is displayed to them, such as, the player had left the room message.
	 * this holds the data, the values below.
	 * is the player playing a game or waiting to play. 
	 * 0: = not playing but still at game room. 
	 * 1: playing a game. 
	 * 2: left game room while still playing it. 
	 * 3: left game room when game was over. 
	 * 4: quit game.
	 */
	public var player_game_state_value_data:Array<Array<Int>> = 
	[for (y in 0...24) [for (x in 0...4) 0]];
	
	private var _handler:WebSocketHandler;
	
	/******************************
	 * these are the usernames currently logged in.
	 * if the second element has a value of "bot ben" then the second element of variable _room have that players room value.
	 */
	public var _username:Array<String> = [];
	
	/******************************
	 * these are the room values of each user currently logged in. 
	 * if the second element has a value of 3 then the second element of variable _username is the name of that user.
	 */
	public var _room:Array<Int> = [];
	
	
	/******************************
	* when client fails to call this event, at server Main.hx, the ticker for that client will increment. when ticker reaches a set value, client will be forced to disconnect and then the onDisconnect function at server Event.hx class will be called.
	*/
	public static var _ping:Array<Int> = [];
	
	/******************************
	 * when the user's ping reaches this value then the user will be forced to disconnect from server and the onDisconnect function will be called.
	 */
	private var _ping_needed_to_disconnect:Int = 20000;
	
	/******************************
	 * client sends and receives data at this class.
	 */
	public var _events:Events;
	
	/******************************
	 * to access typedef_data sucg as _gameState, miscstate, etc.
	 */
	private var _data:Dynamic;
	
	/******************************
	 * _handler var is here. handler is the client connected.
	 */
	private var _server:WebSocketServer<WebSocketHandler>;
	
	/******************************
	 * The current total amount of clients connected to this server.
	 */
	public var _serverConnections:Int = 0;
	
	/******************************
	 * mysql servers_status table will be read when this is of a set value.
	 */
	private var _ticksServerStatus:Int = 0;
	
	/******************************
	 * do not remove. this var is passed to client. at client messageBan() see paragraph2.
	 */
	public var _clientCommandIPs:Array<String> = [ for (i in 0...120) "" ];
	
	/******************************
	 * An Internet Protocol address (IP address) is a numerical label assigned to each device connected to a computer network that uses the Internet Protocol for communication.
	 */
	private var _ip:String;

	/******************************
	 * every server that is online will have a different id. the id is determined after querying the servers_status database.
	 */
	private var _serverId:Int = 0;
	
	/******************************
	 * mysql database functions. delete table.
	 */
	private var _db_delete:DB_Delete;
	
	/******************************
	 * mysql database functions. insert data to table.
	 */
	private var _db_insert:DB_Insert;
	
	/******************************
	 * mysql database functions. select data from table.
	 */
	private var _db_select:DB_Select;
	
	/******************************
	 * mysql database functions. update table.
	 */
	private var _db_update:DB_Update;
		
	function new() 
	{
	
		// create a logs folder if logs folder does not exist.
		if (FileSystem.exists(FileSystem.absolutePath("C:/Users/suppo/Desktop/serverDev/logs/")) == false)
			FileSystem.createDirectory(FileSystem.absolutePath("C:/Users/suppo/Desktop/serverDev/logs/"));
			
		Reg.resetRegVarsOnce();
		
		_rated_game =
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
		 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
			
		// get version number file from internet and compare it with this server's offline file, to determine if this server should shutdown for a software update.
		webFileExist();
		
		// if false then Reg._messageFileExists which is the version at website does not match the Reg._version. update the server.
		if (Reg._doOnce == false) 
		{
			if (Reg._messageFileExists != Reg._version) serverUpdate();
		}
		else
		{
			Reg._doOnce = false;
			//Sys.println (Reg._messageFileExists);
		}
		
		var _ver = Reg._messageFileExists;
		
		/******************************
		 * An Internet Protocol address (IP address) is a numerical label assigned to each device connected to a computer network that uses the Internet Protocol for communication.
		 */

		 // From the config.bat file
		if (Sys.args()[0] != null) _ip = Sys.args()[0]; //Allow the changing of the server IP through a command line argument. online use "192.168.0.11"; // use localhost, or 0.0.0.0 which is everyone, if you want to work offline. // use "192.168.0.11" which is an IPv4 address from ipConfig at windows prompt. use that if you want others from the internet to connect to server. must be online for the connection from client to work.
		
		var _port:Int = 0;
		if (Std.parseInt(Sys.args()[1]) != null) _port = Std.parseInt(Sys.args()[1]);
		
		//-----------------------------
		
		Log.mask = Log.INFO;
		
		_server = new WebSocketServer<WebSocketHandler>(_ip, _port, _maximum_server_connections);
		if (Sys.args()[2] != null) Reg._dbHost 			= Sys.args()[2];
		if (Std.parseInt(Sys.args()[3]) != null) 
			Reg._dbPort = Std.parseInt(Sys.args()[3]);
		if (Sys.args()[4] != null) Reg._dbUser 			= Sys.args()[4];
		if (Sys.args()[5] != null) Reg._dbPass 			= Sys.args()[5];
		
		// if serverBuild.bat is executed, this will load serverCreateExe.bat within that file because this program has ended. this is used to build the server exe file
		if (Reg._dbPass == "") Sys.exit(0);
		
		if (Sys.args()[6] != null)	Reg._dbName			= Sys.args()[6];
		if (Sys.args()[7] != null)	Reg._username		= Sys.args()[7];
		if (Sys.args()[8] != null)	Reg._domain			= Sys.args()[8];
		if (Sys.args()[9] != null)	Reg._domain_path	= Sys.args()[9];
				
		if (Sys.args()[10] != null) Reg._smtpFrom 		= Sys.args()[10];
		if (Sys.args()[11] != null) Reg._smtpHost 		= Sys.args()[11];
		if (Sys.args()[12] != null) Reg._smtpPort		= Std.parseInt(Sys.args()[12]);
		if (Sys.args()[13] != null) Reg._smtpUsername	= Sys.args()[13];
		if (Sys.args()[14] != null) Reg._smtpPassword	= Sys.args()[14];
		
		// this looks wrong but it works.
		var _bool:String = "false";
		
		if (Sys.args()[15] != null) _bool = Std.string(Sys.args()[15]);
		if (_bool == "false") Reg._dummyData = false;
		else Reg._dummyData = true;
		
		if (_dummyData == true) Reg._dummyData = true;
		
		Sys.println("Version " + _ver);
		Sys.println ("Your domain is " + Reg._domain);
		
		_events = new Events(_data, this, _handler);
				
		_server.onClientAdded = function(_handler:WebSocketHandler) 
		{
			_handler.onopen = function() 
			{
				_username.push("nobody");
				_ping.push(0);
				_room.push(9000); // 9000 is used only for joining server. disconnect uses 10000 and entering the looby uses 0. 9000 is used so that a "is port open" service cannot stop a regular user from logging in.
				
				trace(_handler.id + ". OPEN");
			}
			
			_handler.onclose = function() 
			{
				if (_username[_handler.id - 1] != null)
				{
					_events.onDisconnect(this, _handler);
				}
				
				else
				{
					trace ("Unknown user.");
					_username.push("nobody");
					_room.push(10000);
					
					_events.onDisconnect(this, _handler);
					trace(_handler.id + ". CLOSE");
				}
			}
			
			_handler.onmessage = function(_message: MessageType)
			{
				switch (_message)
				{
					case BytesMessage(content):
						var _str = "echo: " + content.readAllAvailableBytes();
					
					case StrMessage(content):
						var _str = content;
						
						if (_str != "Client connected." && _str != "")
						{
							var unserializer = new Unserializer(_str);
							var _data:DataMisc = unserializer.unserialize();
							_events.name(_data);
						}
						
						else
						{
							_handler.send(_str);
							trace("data received: " + _str);
						}
						
				}
				
			}
			
			_handler.onerror = function(error) 
			{
				trace(_handler.id + ". ERROR: " + error);
			}
		}
		
		_db_delete = new DB_Delete(); // no add() needed.
		_db_insert = new DB_Insert();
		_db_select = new DB_Select();
		_db_update = new DB_Update();
		
		var _countServersConnected:Int = 0;
		var rset = _db_select.server_data_at_servers_status();		
		// if true then server is online and can be disconnected at the admin section of the website. make sure this _serversOnline var at the database starts at 1.
		// currently set for total of 5 servers online.
		// this gets the total count of the servers online.
		for (i in 0... _total_servers)
		{
			if (rset._connected[i] == true) _countServersConnected += 1;
		}
		
		if (_countServersConnected == _total_servers)
		{
			Sys.println("");
			Sys.println("too many servers online. Exiting.");
			Sys.exit(0);
		}
		
		// assign the _serverID to the first available connected_ID. fpr example, At localhost/admin maintenance.php, the checkbox for server with an id of 1 will be displayed when server is online and that server will be online when a conencted[0] has a value of 1.
		for (i in 0... _total_servers)
		{
			if (rset._connected[i] == false) 
			{
				_serverId = _db_update.server_now_online_at_servers_status(i + 1);
				break;
			}
		}
		
		// only search the internet once, when event data is not populated.
		if (Reg._eventName[0] == "") getAllEvents();
		
		// reset server data because we do not want a message saying this server is has been cancelled when we did not receive a message about server going offline. reset back to default, the disconnect_id, timestamp_id and do_once_id vars.
		_db_update.server_id_at_servers_status(_serverId);		
		
		// this is needed so that when server disconnects, the server total online can then be minus 1 and the disconnect_# can be set back to 0.
		var saveFile = sys.io.File.write("serverID.txt");
		saveFile.writeString(Std.string(_serverId));
		saveFile.close();
		
		//------------------------------
		// server password. your username password is needed or else server will not start.
		var _charCode = 0;
		var _charFrom = "";
		
		Sys.println("Server " + _serverId);
		Sys.println("");
		Sys.println("1: A paid account is needed.");
		Sys.println("2: Your IP address must be identical to your IP address last used at the forum.");
		Sys.println("3: The username from the forum must match the username at server sub.");
		Sys.println("");
		Sys.println("If server cannot go online, shutdown the server and then try again.");
				
		var _row = _db_select.user_all_at_users(Reg._username);
		var _paid = Std.string(_row._isPaidMember[0]);
		var _set_ip:String = Functions.getIP(Reg._username);			
		if (_set_ip != "" && _paid == "true") 
		{
			Sys.println("Welcome " + Reg._username + ".");
		}
		else 
		{
			Sys.println("");
			Sys.println("Your username and/or IP address was rejected.");
			Sys.println("1: Was the username added to the config.bat file at /sub?");
			Sys.println("2: Are you a paid member of " + Reg._websiteHomeUrl);
			Sys.println("3: Is the external website at /getIP.php online and working?");
			
			Sys.println("");
			Sys.println("Press ESC to exit the server.");
			
			while (true)
			{
				_charCode = Sys.getChar(false);
				
				if (_charCode == 27) Sys.exit(0); 
			}
		}
		
		_charFrom = "";
		
		//----------------------------------
		
		Sys.println("");
		
		// the client will search for this file at website. if found the client will then try to connect to server. if not found then the client will give a message that the server if offline. 
		if (FileSystem.exists(Reg._domain_path + "/server/server") == false)
		{	
			var saveFile = sys.io.File.write(Reg._domain_path + "/server/server");

			saveFile.writeString("Delete this file so that the server can go online.");
			saveFile.close();

		}		
		
		_db_delete.logged_in_tables(); // delete all logged in users because server is starting. we do this at starting not stopping because server may have crashed.
		
		Sys.println ("Server started.");
		Sys.println ("Hold CTLR key then press C key to exit.");
		Sys.println ("");

		_server.start();
		
		MainLoop.add(function()
		{
			// TODO. anything outside of the event loops can be done here. for example, if a room has not been pinged for awhile then remove all users from that room.
			var _currentTimestamp:Int = Std.int(Sys.time());
			_ticksServerStatus += 1;
						
			if (_ticksServerStatus == 1400) 
			{
				for (i in 0... _serverId)
				{
					var _msg = _db_select.all_server_messages();
					var _server_status = _db_select.server_data_at_servers_status();
					
					_ticksServerStatus = 0;				
					
					if (_currentTimestamp > _server_status._timestamp[i] && _server_status._timestamp[i] > 0) 
					{
						Sys.println ('Server disconnected normally.');
						Sys.exit(0);
					}	
					
					if (_server_status._doOnce[i] == true && _serverId == 1)
					{		
						if (_server_status._disconnect[i] == true && _currentTimestamp < _server_status._timestamp[i])
						{
							if (Reg._dataServerMessage._message_offline == "")
							{
								Reg._dataServerMessage._message_offline = _msg._messageOffline[0];
								Reg._dataServerMessage._message_online = "";
								broadcast_everyone(Reg._dataServerMessage);
							}
						}
					
						if (_server_status._disconnect[i] == false && _server_status._timestamp[i] == 0)
						{
							if (Reg._dataServerMessage._message_online == "")
							{
								Reg._dataServerMessage._message_online = _msg._messageOnline[0];
								Reg._dataServerMessage._message_offline = "";
								broadcast_everyone(Reg._dataServerMessage);
							}
						}
					}
						
					_db_update.do_once_at_servers_status(i);
				}
			}		
			
			for (i in 0... _ping.length)
			{
				// increment ping for each user.
				_ping[i] += 1;
				
				// ping for the user is set back to zero when an event is sent to server. if ping reaches too high a value then user is not active and must be disconnected.
				if (_ping[i] > _ping_needed_to_disconnect)
				{
					for (h in _server.handlers)
					{
						if (h.id == (i + 1)) // h.id starts at 1.
						{
							// disconnect the client.
							h.close();
							trace(h.id + ". had lack of activity. Disconnection was forced.");
						}
					}
				}
			}
			
			Sys.sleep(0.01); // wait for 1 ms to prevent full cpu usage. (0.01)	
		});
	}

	/****************************************************************************
	 * gets all the event names and event description from the website.
	 */
	public static function getAllEvents():Void
	{
		var _http = new haxe.Http(Reg._websiteHomeUrl + "server/getAllEvents.php");
	
		// in getAllEvents.php the getAllEvents param will have the value of _str.
		_http.setParameter("getAllEventNames", "names");
		
		_http.onData = function(_data:String) 
		{
			// if there is data
			if (_data.length > 1) 
			{
				// hold event data.
				var _eventData:Array<String>  = 
	[for (p in 0...40) "" ];				
				 
				// at getAllEvents.php, a block of code gets all event data and puts that data in a string. for each mysql row, at mysql, each event has name, description, months, days and colour. that data is writen to a string then the word "END" is placed at that string so that we know all data for that event ends there.
				
				// the string is split at the word "END" so now _eventSeperate hold all data for just 1 event at each of its elements. so, _eventSeperate[0] var holds name, description, months, days and colour for that event.
				var _eventSeperate:Array<String> = _data.split("END;");
				
				for (i in 0..._eventSeperate.length)
				{
					// the data is split one more time so that now we have the data for only event var i.
					_eventData = _eventSeperate[i].split(";");
							
					Reg._eventName[i] = _eventData[0];
					Reg._eventDescription[i] = _eventData[2];
					
					Reg._eventMonths[i][0] = Std.parseInt(_eventData[4]);
					Reg._eventMonths[i][1] = Std.parseInt(_eventData[5]);
					Reg._eventMonths[i][2] = Std.parseInt(_eventData[6]);
					Reg._eventMonths[i][3] = Std.parseInt(_eventData[7]);
					Reg._eventMonths[i][4] = Std.parseInt(_eventData[8]);
					Reg._eventMonths[i][5] = Std.parseInt(_eventData[9]);
					Reg._eventMonths[i][6] = Std.parseInt(_eventData[10]);
					Reg._eventMonths[i][7] = Std.parseInt(_eventData[11]);
					Reg._eventMonths[i][8] = Std.parseInt(_eventData[12]);
					Reg._eventMonths[i][9] = Std.parseInt(_eventData[13]);
					Reg._eventMonths[i][10] = Std.parseInt(_eventData[14]);
					Reg._eventMonths[i][11] = Std.parseInt(_eventData[15]);
					
					Reg._eventDays[i][0] = Std.parseInt(_eventData[17]);
					Reg._eventDays[i][1] = Std.parseInt(_eventData[18]);
					Reg._eventDays[i][2] = Std.parseInt(_eventData[19]);
					Reg._eventDays[i][3] = Std.parseInt(_eventData[20]);
					Reg._eventDays[i][4] = Std.parseInt(_eventData[21]);
					Reg._eventDays[i][5] = Std.parseInt(_eventData[22]);
					Reg._eventDays[i][6] = Std.parseInt(_eventData[23]);
					Reg._eventDays[i][7] = Std.parseInt(_eventData[24]);
					Reg._eventDays[i][8] = Std.parseInt(_eventData[25]);
					Reg._eventDays[i][9] = Std.parseInt(_eventData[26]);
					Reg._eventDays[i][10] = Std.parseInt(_eventData[27]);
					Reg._eventDays[i][11] = Std.parseInt(_eventData[28]);
					Reg._eventDays[i][12] = Std.parseInt(_eventData[29]);
					Reg._eventDays[i][13] = Std.parseInt(_eventData[30]);
					Reg._eventDays[i][14] = Std.parseInt(_eventData[31]);
					Reg._eventDays[i][15] = Std.parseInt(_eventData[32]);
					Reg._eventDays[i][16] = Std.parseInt(_eventData[33]);
					Reg._eventDays[i][17] = Std.parseInt(_eventData[34]);
					Reg._eventDays[i][18] = Std.parseInt(_eventData[35]);
					Reg._eventDays[i][19] = Std.parseInt(_eventData[36]);
					Reg._eventDays[i][20] = Std.parseInt(_eventData[37]);
					Reg._eventDays[i][21] = Std.parseInt(_eventData[38]);
					Reg._eventDays[i][22] = Std.parseInt(_eventData[39]);
					Reg._eventDays[i][23] = Std.parseInt(_eventData[40]);
					Reg._eventDays[i][24] = Std.parseInt(_eventData[41]);
					Reg._eventDays[i][25] = Std.parseInt(_eventData[42]);
					Reg._eventDays[i][26] = Std.parseInt(_eventData[43]);
					Reg._eventDays[i][27] = Std.parseInt(_eventData[44]);
					
					Reg._eventBackgroundColour[i] = Std.parseInt(_eventData[46]);
				}
				
			}
		}		

		_http.onError = function (_error)
		{
			// TODO make a message box saying that maybe not connected to internet because this function needs to connect to the website.
		}
		
		_http.request();
		
	}

	public static function main (){
		new Main();

	}
	

	public static function webFileExist():Void
	{
		var _http = new haxe.Http(Reg._websiteHomeUrl + "files/versionServer.txt");
		var _str:String = "Failed to get server's version number from a file at " + Reg._websiteName + " website. ";
		Reg._doOnce = false;
		
		_http.onData = function (_dataFeed:String) 
		{
			if (_dataFeed.substr(0, 1) == "<") 
			{
				Reg._doOnce = true;
				
				_dataFeed = "";				
				Reg._messageFileExists = _str + "Reason: File does not exist.";
			}
			
			else 
			{
				// version of client is found because file exists at website.
				Reg._doOnce = false;
				
				Reg._messageFileExists = _dataFeed;
			}
		}
		
		_http.onError = function (_error)
		{
			
			Reg._doOnce = true;			
			Reg._messageFileExists = _str + "\nReason: Cannot connect to that website.";
		}
		
		_http.request();
	}

	private function serverUpdate():Void
	{
		Sys.command("start", [ "boardGamesUpdaterServer.bat"]); // lnk is a file shortcut extension.
		Sys.exit(0);
	}
	
	/******************************
	 * put the user in the room. if user is already in a room then that user's room value will be updated.
	 */
	public function put_in_room(_data:Dynamic)
	{
		var _found:Bool = false;
		
		for (i in 0 ... _username.length + 1)
		{
			// username found so update the _room list.
			if (_username[i] == _data._username)
			{
				_found = true;
				_room[i] = _data._room;
			}
		}
		
		// username not found in list so add username and room to the lists.
		if (_found == false)
		{
			for (i in 0... _room.length + 1)
			{
				if (_room[i] == 9000)
				{
					_username[i] = _data._username;
					_room[i] = 0;
				}
			}
		}
	}
	
	public function remove_from_room(_data:Dynamic)
	{
		for (i in 0 ... _username.length + 1)
		{
			if (_username[i] == _data._username)
			{
				if (_room[i] != 9000) _room[i] = 10000;
				
				_username[i] = "nobody";
				
				// deletes these tables when user first logs in and when user is disconnecting.
				Functions.deleteRowsFromDatabase(_data);
			}
		}
	}
	
	/******************************
	 * send back to the client that had sent the event to server.
	 */
	public function send_to_handler(_data:Dynamic):Void
	{
		Sys.sleep(0.1);
		var serializer = new Serializer();
		serializer.serialize(_data);
		var _send = serializer.toString();
		
		var ii:Int = -1;
		
		for (i in 0 ... _username.length + 1)
		{
			if (_data._username == _username[i]
			&&	_username[i] != "nobody")
			{
				ii = i;
			}
		}
		
		if (ii > -1)
		{
			for (h in _server.handlers)
			{
				if (h.id == (ii + 1)) // h.id starts at 1.
				{
					h.send(_send);
				}
			}
		}
	}
	
	/******************************
	 * broadcast to everyone in the room.
	 */
	public function broadcast_in_room(_data:Dynamic):Void
	{
		Sys.sleep(0.1);
		put_in_room(_data);
		
		var serializer = new Serializer();
		serializer.serialize(_data);
		var _send = serializer.toString();
		
		for (h in _server.handlers)
		{
			for (i in 0 ... _username.length + 1)
			{
				if (_room[i] == _data._room
				&&	i == (h.id - 1)
				&&	_username[i] != "nobody")
				{
					h.send(_send);
				}
			}
        }
    }
	
	/******************************
	 * broadcast to everyone.
	 */
	public function broadcast_everyone(_data:Dynamic):Void
	{
		Sys.sleep(0.1);
		
		var serializer = new Serializer();
		serializer.serialize(_data);
		var _send = serializer.toString();
		
		for (h in _server.handlers)
		{
			for (i in 0 ... _username.length + 1)
			{
				if (_username[i] != "nobody"
				&&	i == (h.id - 1))
				{
					h.send(_send);
				}
			}
        }
    }
}// ignore this. its a bug in the ide that adds this junk sometimes to the end of a class. 