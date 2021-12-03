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

package ;

import Reg;
import vendor.mphx.connection.IConnection;
import vendor.mphx.server.impl.Server;
import sys.FileSystem;

import sys.net.Socket;
import vendor.mphx.server.impl.Server; // aliased to avoid conflict with sys.net.Socket
import sys.net.Host;
import sys.ssl.Socket;
import sys.ssl.Certificate;
import sys.ssl.Key;

/**
 *
 * @author kboardgames.com
 */
class Main
{
	private var _ticksServerStatus:Int = 0; // when this is of a set value, mysql servers_status table will be read.
	
	/******************************
	 * An Internet Protocol address (IP address) is a numerical label assigned to each device connected to a computer network that uses the Internet Protocol for communication.
	 */
	private var _ip:String;

	/******************************
	 * Server (computing), a system that responds to requests across a computer network to provide, or help to provide, a network or data service.
	 */
	private var _server:Server;
	
	/******************************
	 * every server that is online will have a different id. the id is determined after querying the servers_status database.
	 */
	private var _serverId:Int = 0;

	/******************************
	 * to access the _data of the _gameState, miscstate, etc.
	 */
	private var _data:Dynamic;

	public var _clientCommandIPs:Array<String> = [ for (i in 0...120) "" ];
		
	/******************************
	 * mysql class.
	 */
	public var _mysqlDB:MysqlDB;
	public var _events:Events;
			
	public function new()
	{	
		// create a logs folder if logs folder does not exist.
		if (FileSystem.exists(FileSystem.absolutePath("C:/Users/suppo/Desktop/serverDev/logs/")) == false)
			FileSystem.createDirectory(FileSystem.absolutePath("C:/Users/suppo/Desktop/serverDev/logs/"));
			
		Reg.resetRegVarsOnce();
		
				
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
		

		/**********************************************************************
		 * An Internet Protocol address (IP address) is a numerical label assigned to each device connected to a computer network that uses the Internet Protocol for communication.
		 */

		 // From the config.bat file
		if (Sys.args()[0] != null) _ip = Sys.args()[0]; //Allow the changing of the server IP through a command line argument. online use "192.168.0.11"; // use localhost, or 0.0.0.0 which is everyone, if you want to work offline. // use "192.168.0.11" which is an IPv4 address from ipConfig at windows prompt. use that if you want others from the internet to connect to server. must be online for the connection from client to work.

		var _port:Int = 0;
		if (Std.parseInt(Sys.args()[1]) != null) _port = Std.parseInt(Sys.args()[1]);
		
		//-----------------------------
	
		_server =  new Server(_ip, _port);
		
     	if (Sys.args()[2] != null) Reg._dbHost = Sys.args()[2];
		if (Std.parseInt(Sys.args()[3]) != null) Reg._dbPort = Std.parseInt(Sys.args()[3]);
		if (Sys.args()[4] != null) Reg._dbUser = Sys.args()[4];
		if (Sys.args()[5] != null) Reg._dbPass = Sys.args()[5];
		
		// if serverBuild.bat is executed, this will load serverCreateExe.bat within that file because this program has ended. this is used to build the server exe file
		if (Reg._dbPass == "") Sys.exit(0);
		
		if (Sys.args()[6] != null) Reg._dbName = Sys.args()[6];
		if (Sys.args()[7] != null) Reg._username = Sys.args()[7];
		if (Sys.args()[8] != null) Reg._domain = Sys.args()[8];
		if (Sys.args()[9] != null) Reg._domain_path = Sys.args()[9];
		
		Sys.println("Version " + _ver);
		Sys.println ("Your domain is " + Reg._domain);
		Sys.println ("");
		
		//############################# server events.
		_events = new Events(_data, _server);
		_mysqlDB = new MysqlDB(); // no add(_mysqlDB) needed.
		
		var _countServersConnected:Int = 0;
		var rset = _mysqlDB.selectServerData();		
		// if true then server is online and can be disconnected at the admin section of the website. make sure this _serversOnline var at the database starts at 1.
		// currently set for total of 20 servers online.
		{
			// this gets the total count of the servers online.
			if (rset._connected1[0] == true) _countServersConnected += 1;
			if (rset._connected2[0] == true) _countServersConnected += 1;
			if (rset._connected3[0] == true) _countServersConnected += 1;
			if (rset._connected4[0] == true) _countServersConnected += 1;
			if (rset._connected5[0] == true) _countServersConnected += 1;
			if (rset._connected6[0] == true) _countServersConnected += 1;
			if (rset._connected7[0] == true) _countServersConnected += 1;
			if (rset._connected8[0] == true) _countServersConnected += 1;
			if (rset._connected9[0] == true) _countServersConnected += 1;
			if (rset._connected10[0] == true) _countServersConnected += 1;
			if (rset._connected11[0] == true) _countServersConnected += 1;
			if (rset._connected12[0] == true) _countServersConnected += 1;
			if (rset._connected13[0] == true) _countServersConnected += 1;
			if (rset._connected14[0] == true) _countServersConnected += 1;
			if (rset._connected15[0] == true) _countServersConnected += 1;
			if (rset._connected16[0] == true) _countServersConnected += 1;
			if (rset._connected17[0] == true) _countServersConnected += 1;
			if (rset._connected18[0] == true) _countServersConnected += 1;
			if (rset._connected19[0] == true) _countServersConnected += 1;
			if (rset._connected20[0] == true) _countServersConnected += 1;
			
			// assign the _serverID to the first available connected_ID. fpr example, At localhost/admin maintenance.php, the checkbox for server with an id of 1 will be displayed when server is online and that server will be online when a conencted_1 has a value of 1. this code set a connected_# to a value of 1.			
			if (rset._connected1[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(1);			
			else if (rset._connected2[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(2);
			else if (rset._connected3[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(3);
			else if (rset._connected4[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(4);
			else if (rset._connected5[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(5);
			else if (rset._connected6[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(6);
			else if (rset._connected7[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(7);
			else if (rset._connected8[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(8);
			else if (rset._connected9[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(9);
			else if (rset._connected10[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(10);
			else if (rset._connected11[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(11);
			else if (rset._connected12[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(12);
			else if (rset._connected13[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(13);
			else if (rset._connected14[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(14);
			else if (rset._connected15[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(15);
			else if (rset._connected16[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(16);
			else if (rset._connected17[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(17);
			else if (rset._connected18[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(18);
			else if (rset._connected19[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(19);
			else if (rset._connected20[0] == false) 
				_serverId = _mysqlDB.serverNowOnline(20);
			else 
			{
				Sys.println ("too many servers online. Exiting.");
				Sys.exit(0);
			}
		}
		
		// only search the internet once, when event data is not populated.
		if (Reg._eventName[0] == "") getAllEvents();
		
		// update table servers_status, the field servers_online. that will then display the correct total servers online.
		_mysqlDB.updateServerOnline(_countServersConnected+1); // we need a +1 because this server just when online. the _mysqlDB.selectServerData() code from above only checked for existing online servers.

		// reset server data because we do not want a message saying this server is has been cancelled when we did not receive a message about server going offline. reset back to default, the disconnect_id, timestamp_id and do_once_id vars.
		_mysqlDB.serverResetStatus(_serverId);		
		
		// this is needed so that when server disconnects, the server total online can then be minus 1 and the disconnect_# can be set back to 0.
		var saveFile = sys.io.File.write("serverID.txt");
		saveFile.writeString(Std.string(_serverId));
		saveFile.close();
		
		//------------------------------
		// server password. your username password is needed or else server will not start.
		var _charCode = 0;
		var _charFrom = "";
		
		Sys.println("1: A paid account is needed.");
		Sys.println("2: Your IP address must be identical to your IP address last used at the forum.");
		Sys.println("3: The username from the forum must match the username at server sub.");
		Sys.println("");
		Sys.println("If server cannot go online, shutdown the server and then try again.");
				
		var _row = _mysqlDB.isPaidMemberFromUsers(Reg._username);
		var _paid = Std.string(_row._isPaidMember[0]);
		var _set_ip:String = Functions.getIP(Reg._username);			
		if (_set_ip != "" && _paid == "true") 
		{
			Sys.println("Welcome " + Reg._username);
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
		
		_mysqlDB.delete_logged_in_tables(); // delete all logged in users because server is starting. we do this at starting not stopping because server may have crashed.
		
		Sys.println ("Server started.");
		Sys.println ("Hold CTLR key then press C key to exit.");
		Sys.println ("");

		_server.listen();
		
		// TODO. anything outside of the event loops can be done here. for example, if a room has not been pinged for awhile then remove all users from that room.
		while (true)
		{			
			var _currentTimestamp:Int = Std.int(Sys.time());
			_ticksServerStatus += 1;
						
			if (_ticksServerStatus == 2000) 
			{
				var rset = _mysqlDB.selectServerData();
				
				_ticksServerStatus = 0;

				
				if (_serverId == 1 && _currentTimestamp > Std.parseInt(rset._timestamp1[0]) && Std.parseInt(rset._timestamp1[0]) > 0) 
				Sys.exit(0);
				
				if (_serverId == 2 && _currentTimestamp > Std.parseInt(rset._timestamp2[0]) && Std.parseInt(rset._timestamp2[0]) > 0) 
				{
					Sys.println ('Server disconnected normally.');
					Sys.exit(0);
				}	
				
				if (rset._doOnce1[0] == true && _serverId == 1)
				{
					// server number 1.					
					if (rset._disconnect1[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp1[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect1[0] == false && Std.parseInt(rset._timestamp1[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce2[0] == true && _serverId == 2)
				{
					// server number 2.					
					if (rset._disconnect2[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp2[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect2[0] == false && Std.parseInt(rset._timestamp2[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce3[0] == true && _serverId == 3)
				{
					// server number 3.					
					if (rset._disconnect3[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp3[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect3[0] == false && Std.parseInt(rset._timestamp3[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce4[0] == true && _serverId == 4)
				{
					// server number 4.					
					if (rset._disconnect4[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp4[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect4[0] == false && Std.parseInt(rset._timestamp4[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce5[0] == true && _serverId == 5)
				{
					// server number 5.					
					if (rset._disconnect5[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp5[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect5[0] == false && Std.parseInt(rset._timestamp5[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce6[0] == true && _serverId == 6)
				{
					// server number 6.					
					if (rset._disconnect6[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp6[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect6[0] == false && Std.parseInt(rset._timestamp6[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce7[0] == true && _serverId == 7)
				{
					// server number 7.					
					if (rset._disconnect7[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp7[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect7[0] == false && Std.parseInt(rset._timestamp7[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce8[0] == true && _serverId == 8)
				{
					// server number 8.					
					if (rset._disconnect8[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp8[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect8[0] == false && Std.parseInt(rset._timestamp8[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce9[0] == true && _serverId == 9)
				{
					// server number 9.					
					if (rset._disconnect9[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp9[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect9[0] == false && Std.parseInt(rset._timestamp9[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce10[0] == true && _serverId == 10)
				{
					// server number 10.					
					if (rset._disconnect10[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp10[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect10[0] == false && Std.parseInt(rset._timestamp10[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce11[0] == true && _serverId == 11)
				{
					// server number 11.					
					if (rset._disconnect11[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp11[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect11[0] == false && Std.parseInt(rset._timestamp11[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce12[0] == true && _serverId == 12)
				{
					// server number 12.					
					if (rset._disconnect12[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp12[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect12[0] == false && Std.parseInt(rset._timestamp12[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce13[0] == true && _serverId == 13)
				{
					// server number 13.					
					if (rset._disconnect13[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp13[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect13[0] == false && Std.parseInt(rset._timestamp13[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce14[0] == true && _serverId == 14)
				{
					// server number 14.					
					if (rset._disconnect14[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp14[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect14[0] == false && Std.parseInt(rset._timestamp14[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce15[0] == true && _serverId == 15)
				{
					// server number 15.					
					if (rset._disconnect15[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp15[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect15[0] == false && Std.parseInt(rset._timestamp15[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce16[0] == true && _serverId == 16)
				{
					// server number 16.					
					if (rset._disconnect16[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp16[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect16[0] == false && Std.parseInt(rset._timestamp16[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce17[0] == true && _serverId == 17)
				{
					// server number 17.					
					if (rset._disconnect17[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp17[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect17[0] == false && Std.parseInt(rset._timestamp17[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce18[0] == true && _serverId == 18)
				{
					// server number 18.					
					if (rset._disconnect18[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp18[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect18[0] == false && Std.parseInt(rset._timestamp18[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce19[0] == true && _serverId == 19)
				{
					// server number 19.					
					if (rset._disconnect19[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp19[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect19[0] == false && Std.parseInt(rset._timestamp19[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				if (rset._doOnce20[0] == true && _serverId == 20)
				{
					// server number 20.					
					if (rset._disconnect20[0] == true && _currentTimestamp <= Std.parseInt(rset._timestamp20[0]))
					{
						_server.broadcast("Message All By Server", rset._messageOffline[0]);
					}
					
					if (rset._disconnect20[0] == false && Std.parseInt(rset._timestamp20[0]) == 0)
					{
						_server.broadcast("Message All By Server", rset._messageOnline[0]);
					}
				}
				
				_mysqlDB.updateServerDoOnce();
			}		
	
			Sys.sleep(0.01); // wait for 1 ms to prevent full cpu usage. (0.01)
			_server.update();
			
		}
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
	


	
}// ignore this. its a bug in the ide that adds this junk sometimes to the end of a class. 