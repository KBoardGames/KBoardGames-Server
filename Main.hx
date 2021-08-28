package ;

import Reg;
import vendor.mphx.connection.IConnection;
import vendor.mphx.server.impl.Server;
import sys.FileSystem;
import sys.net.Host;
//import sys.ssl.Socket;
//import sys.net.Host;

/**
 *
 * @author kboardgames.com
 */
class Main
{
	//############################# chess elo rating vars
	/******************************
	 * player 1 and 2 current ELO ratings
	 */
	private var _chess_elo_rating:Array<Float> = [1200, 1000]; // example values.
		
	/******************************
	 * constant or power used in elo math.
	 */
	private var _chess_elo_k:Int = 30;
	
	/******************************
	 * player 1 won: true. player 2 won: false.
	 */
	private var _chess_did_player1_win:Bool = true;
	
	//#############################
	// THE FOLLOWiNG ARRAY ARE USED TO POPULATE THE TYPEDEF ARRAY AT REG.HX. WITHOUT THESE VARS, THE TYPEDEFS AT REG.HX WOULD CREATE AN ARRAY NOT DEFINED ERROR.

	// 0 = empty, 1 computer game, 2 creating room, 3 = firth player waiting to play game. 4 = second player in waiting room. 5 third player in waiting room if any. 6 - forth player in waiting room if any. 7 - room full, 8 - playing game / wating game.
	public var _roomState:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	// max players in room.
	public var _roomPlayerLimit:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
						 
	public var _roomPlayerCurrentTotal:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
						 
	public var _vsComputer:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	
	// if true then this room allows spectators.
	public var _allowSpectators:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		
	// used to list the games at lobby. see Reg.gameName(). also, for not a host player, the data from here will populate _miscState._data._gameId for that player.
	//-1: no data, 0:checkers, 1:chess, etc.
	public var _roomGameIds:Array<Int> =
					[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
					 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
					 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
					 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
					 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];

	
	// a list of every username that is a host of a room.
	// at client.SceneWaitingRoom.hx, there is a list of all user at the lobby. only the host can invite a user.
	public var _roomHostUsername:Array<String> =
					["", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", ""];
		
	// game id. move_history fields are not deleted from the mysql database. so this id is used so that a user accesses that correct move_history data.
	public var _gid:Array<String> =
					["", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", ""];
					
	public var _usernames_static:Array<Array<String>> =
	[for (p in 0...51) [for (i in 0...4) ""]];
						
	public var _onlinePlayersUsernames:Array<String>
					=	["", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "",
						"", "", "", "", "", "", "", "", "", "", ""];

	// if player is logged in at element 2 of the _onlinePlayersUsernames var then here at element 2 will be that players data. 
	public var _onlinePlayersGameWins:Array<Int>
					=	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	// total losses of every player logged in.
	public var _onlinePlayersGameLosses:Array<Int>
					=	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	// total draws of every player logged in
	public var _onlinePlayersGameDraws:Array<Int>
					=	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	public var _online_all_elo_ratings:Array<Float>
					=	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	/******************************
	* This var holds the players data (set) that the server stores for the client to process (get).
	*/
	public var allDataGame:Map<vendor.mphx.connection.IConnection,DataGame>;
	// these are needed. they are game id data.
	public var allDataGame0:Map<vendor.mphx.connection.IConnection,DataGame0>;
	public var allDataGame1:Map<vendor.mphx.connection.IConnection,DataGame1>;
	public var allDataGame2:Map<vendor.mphx.connection.IConnection,DataGame2>;
	public var allDataGame3:Map<vendor.mphx.connection.IConnection,DataGame3>;
	public var allDataGame4:Map<vendor.mphx.connection.IConnection,DataGame4>;
	
	public var allDataDailyQuests:Map<vendor.mphx.connection.IConnection,DataDailyQuests>;
	public var allDataQuestions:Map<vendor.mphx.connection.IConnection,DataQuestions>;
	public var allDataOnlinePlayers:Map<vendor.mphx.connection.IConnection,DataOnlinePlayers>;
	public var allDataMisc:Map<vendor.mphx.connection.IConnection,DataMisc>;
	public var allDataPlayers:Map<vendor.mphx.connection.IConnection,DataPlayers>;
	public var allDataTournaments:Map<vendor.mphx.connection.IConnection,DataTournaments>;
	public var allDataAccount:Map<vendor.mphx.connection.IConnection,DataAccount>;
	public var allDataGameMessage:Map<vendor.mphx.connection.IConnection,DataGameMessage>;
	public var allDataMovement:Map<vendor.mphx.connection.IConnection,DataMovement>;
	public var allDataStatistics:Map<vendor.mphx.connection.IConnection,DataStatistics>;
	public var allDataHouse:Map<vendor.mphx.connection.IConnection,DataHouse>;
	public var allDataLeaderboards:Map<vendor.mphx.connection.IConnection,Leaderboards>;
	
	/******************************
	 * player is the logged in data, such as password or host, that gets and sends to the client. player is used at both client and server while user is server side.
	 */
	private var _gameState:Dynamic;
	private var _gameState1:Dynamic;
	private var _gameState2:Dynamic;
	private var _gameState3:Dynamic;
	private var _gameState4:Dynamic;
	private var _gameState5:Dynamic;
	
	private var _dailyQuestsState:Dynamic;
	private var _questionsState:Dynamic;
	private var _onlinePlayersState:Dynamic;
	private var _miscState:Dynamic;
	private var _playersState:Dynamic;
	private var _accountState:Dynamic;
	private var _MovementState:Dynamic;
	
	/******************************
	 * An Internet Protocol address (IP address) is a numerical label assigned to each device connected to a computer network that uses the Internet Protocol for communication.
	 */
	private var _ip:String;

	/******************************
	 * Server (computing), a system that responds to requests across a computer network to provide, or help to provide, a network or data service.
	 */
	private var _server:Server;

	/******************************
	 * The current total amount of clients connected to this server.
	 */
	private var _serverConnections:Int = 0;
	
	/******************************
	 * every server that is online will have a different id. the id is determined after querying the servers_status database.
	 */
	private var _serverId:Int = 0;

	/******************************
	 * The maximum allowed connection to this server.
	 */
	private var _maximumServerConnections:Int = 119;
	
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
	private var player_game_state_value_username:Array<String> = [];

	/******************************
	 * this var is populated from events and at the disconnect event it is passed to the other users. This var is needed because static usernames of the room cannot be taken from the database since a player might have left the room before a request to get the static players values.
	 * this holds the data, the values below.
	 * is the player playing a game or waiting to play. 
	 * 0: = not playing but still at game room. 
	 * 1: playing a game. 
	 * 2: left game room while still playing it. 
	 * 3: left game room when game was over. 
	 * 4: quit game.
	 */
	private var player_game_state_value_data:Array<Array<Int>> = [];
	
	/******************************
	 * button total displayed at client lobby.
	 */
	private var _button_total:Int = 24;

	/******************************
	 * to access the _data of the _gameState, miscstate, etc.
	 */
	private var _data:Dynamic;


	public var _clientCommandIPs:Array<String> = [ for (i in 0...120) "" ];

	/******************************
	 * the _gameState that sent the _data.
	 */
	private var _sender:vendor.mphx.connection.IConnection;
	
	/******************************
	* closes the server if true. there will be an error if closing within an event because the event code cannot continue if not connected so this var is called in the event and this var "if true" is needed outside the event to close it.
	*/
	private var _closeServer:Bool = false;

	// if here at server, the lobby is room 0. if room[1].broadcast is used then at client, only players with room data of 1 can execute code at that code block. sometimes, at client, there is a check to see is the id passed to client matches the id of that user. if there is a match then player can execute code. , eg, if (_data.id == _miscState._data._id) the _miscState is players data where as the _data.id is passed to client.
	private var room:Array<vendor.mphx.server.room.Room> = [];
		/******************************
	 * mysql class.
	 */
	public var _mysqlDB:MysqlDB;
	
	/******************************
	 * read the mysql servers_status table every so many ticks. When the do_once field at that table has a value of true, this var will be set to true so that a block of code is is no longer read.
	 */
	//private var _mysqlReadServersStatusOnce:Bool = false;
	
	private var _ticksServerStatus:Int = 0; // when this is of a set value, mysql servers_status table will be read.

	/****************************************************************************
	 * user activity log files at the logs folder. everytime an server event is called from the client, this is the name of the log file in date format of yead month day. eg, 2020-01-15.txt
	 */
	private var _logDate:String = "";
	
	/****************************************************************************
	 * user activity log files at the logs folder. everytime an server event is called from the client, inside of the log file, each entry will append to the bottom of the file. the beginning on that entry will be the time the user entered into the event.
	 */
	private var _logTime:String = "";
		
	/****************************************************************************
	 * user activity log files at the logs folder. everytime an server event is called from the client, this is the user ID. see client typedef, the id data.
	 */
	private var _logsuserId:Array<String> = [];
	
	/****************************************************************************
	 * user activity log files at the logs folder. everytime an server event is called from the client, this is the username of the player from client.
	 */
	private var _logsUsername:Array<String> = [];

	
	// each element refers to the id of a game. the first element is checkers then chess, etc. the player that wins the game gets the experience points value of this vars element. a game lose is half that of a win. so if playing chess and the player lost the game then the experience points gained will be half of 70 rounded to the whole number because we are using Int.
	private var _experiencePointsGiven:Array<Int> = [70, 70, 50, 50, 90]; 
	
	
		
	public function new()
	{	
		// create a logs folder if logs folder does not exist.
		if (FileSystem.exists(FileSystem.absolutePath("logs/")) == false)
			FileSystem.createDirectory(FileSystem.absolutePath("logs/"));
			
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
		
		// sometimes allDataOnlinePlayers.get(_sender) is needed. without that code an error of INVALID FIELD ACCESS.
		allDataGame = new Map();
		allDataGame0 = new Map();
		allDataGame1 = new Map();
		allDataGame2 = new Map();
		allDataGame3 = new Map();
		allDataGame4 = new Map();
		allDataDailyQuests = new Map();
		allDataQuestions = new Map();
		allDataOnlinePlayers = new Map();
		allDataMisc = new Map();
		allDataPlayers = new Map();
		allDataTournaments = new Map();
		allDataAccount = new Map();
		allDataGameMessage = new Map();
		allDataMovement = new Map();
		allDataStatistics = new Map();
		allDataHouse = new Map();
		allDataLeaderboards = new Map();
		
		/**********************************************************************
		 * An Internet Protocol address (IP address) is a numerical label assigned to each device connected to a computer network that uses the Internet Protocol for communication.
		 */

		 // From the config.bat file
		if (Sys.args()[0] != null) _ip = Sys.args()[0]; //Allow the changing of the server IP through a command line argument. online use "192.168.0.11"; // use localhost, or 0.0.0.0 which is everyone, if you want to work offline. // use "192.168.0.11" which is an IPv4 address from ipConfig at windows prompt. use that if you want others from the internet to connect to server. must be online for the connection from client to work.

		var _port:Int = 0;
		if (Std.parseInt(Sys.args()[1]) != null) _port = Std.parseInt(Sys.args()[1]);
		
		// create the server.
		//_server = new FlashServer(_ip, null); // use this if you use a flash connection (using an policy files servers for flash socket). change null to a port number.
		_server = new vendor.mphx.server.impl.Server(_ip, _port); // need port forward and firewall opened for this port.
		
		
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
		
		// used to delete any user fields from mysql when the user is disconnecting.
		_server.onConnectionClose = onDisconnect;

		// create the rooms.
		for (i in 0...25) 
		{
			room[i] = new vendor.mphx.server.room.Room();
			_server.rooms.push(room[i]);
		}
		
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
		var saveFile = sys.io.File.write("sub/serverID.txt");
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
		
		if (_paid == "true") 
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
		
		//----------------------------------
		// create the cpu host names for room a and b.
		hostCpuUserNames();
		
		//----------------------------------
		
		join(_data, _sender);					// called when player joins server.
		disconnectByServer(_data, _sender); 	// then server is full, this event closes the client that tries to connect.
		disconnectAllByServer(_data, _sender); 	// disconnect all players from server/
		isLoggingIn(_data, _sender); 			// the player is logging in.
		houseLoad(_data, _sender);					// players house where they buy items, place items in room and vote for best house for prizes.
		houseSave(_data, _sender);	
		getStatisticsWinLossDraw(_data, _sender);	// Get Statistics Win Loss Draw, such as, wins, draws and losses.
		getStatisticsAll(_data, _sender);		// get all stats such as experience points, credits, wins, etc.
		greaterRoomStateValue(_data, _sender);	// event player has entered the room, so change the roomstate value.
		lesserRoomStateValue(_data, _sender);	// event player has left the room, so change the roomstate value.
		isRoomLocked(_data, _sender);
		setRoomData(_data, _sender); 			// save room data to database. able to put user into room.
		getRoomData(_data, _sender);			// load room data from database.
		
		roomLock1(_data, _sender); 				// Used at lobby to delay the second player from entering into the room until the room lock is removed from that room. 
		roomLock2(_data, _sender);				// This event only removes the room lock.
		getRoomPlayers(_data, _sender);
		chatSend(_data, _sender);				// the players chat message.
		
		gameMessageNotSender(_data, _sender); 	// Game message. Not a message box.
		
		gameMessageBoxForSpectatorWatching(_data, _sender);	// message box.

		messageKick(_data, _sender); 			// stop player from playing for some time.
		removeKickedFromUser(_data, _sender);
		
		messageBan(_data, _sender); 			// stop player from playing forever.
		
		drawOffer(_data, _sender);			// offer game draw so that it is a tie.
		drawAnsweredAs(_data, _sender);	// draw reply.
		restartOffer(_data, _sender);		// offer game restart so that another game can be played.
		restartAnsweredAs(_data, _sender);	// chess restart reply.

		OnlinePlayerOfferInvite(_data, _sender);// offer an invite to a player at the lobby.
		enterGameRoom(_data, _sender);				// this event enters the game room.
		gameWin(_data, _sender);				// win text using a message popup.
		gameLose(_data, _sender);				// lose text using a message popup.
		gameWinThenLoseForOther(_data, _sender);// win text using a message popup then lose message box for the other player.
		gameLoseThenWinForOther(_data, _sender);// lose text using a message popup, then win message box for the other player.
		gameDraw(_data, _sender);				// draw text using a message popup.
		saveWinStats(_data, _sender);			// save win stats of current player.
		saveLoseStats(_data, _sender);			// save lose stats of current player.
		saveWinStatsForBoth(_data, _sender);	// save win stats of current player then a lose for the other player.
		saveLoseStatsForBoth(_data, _sender);	// save lose stats of current player then a win for the other player.
		saveDrawStats(_data, _sender);			// save draw stats of current player.
		tournamentChessStandard8Get(_data, _sender);			// gets the selected tournament data.
		tournamentChessStandard8Put(_data, _sender);			// puts the selected tournament data to the mysql database.
		playerLeftGameRoom(_data, _sender);		// Trigger an event that the player has left the game room.
		playerLeftGame(_data, _sender);			// Trigger an event that the player has left the game.
		loggedInUsers(_data, _sender);			// list of online players with stats. used to invite.
		actionByPlayer(_data, _sender);			// refers to an action, eg, 1 = kick. see the "Action By Player" event at server.
		isActionNeededForPlayer(_data, _sender);	

		playerMoveTimeRemaining(_data, _sender);		// gets the current move timer for the player that is moving. the value is sent to the other clients so that they have the update value.
		
		gameIsFinished(_data, _sender);		// save a var to mySql so that someone cannot invite when still in game room. also, triggers a var called Reg._gameOverForAllPlayers to equal true so that the game has ended for everyone.
		
		isGameFinished(_data, _sender);	// false if game is still being played. defaults to true because when entering the game room the game for those players has not started yet.
		
		returnedToLobby(_data, _sender);	// at lobby, so return all vars to 0 for player, so that lobby data can be calculated to display data at lobby correctly.
						
		playerMoveId0(_data, _sender);	// called when player moves a piece.
		playerMoveId1(_data, _sender);	// id 1 = chess.	
		playerMoveId2(_data, _sender);	// reversi.
		playerMoveId3(_data, _sender);	// snakes and ladders.
		playerMoveId4(_data, _sender);	// signature game.
		
		isHost(_data, _sender); 		// EVENT WAITING ROOM SETS HOST OF THE ROOM.
		
		tradeProposalOffer(_data, _sender); // currently this event is for the signature game. a player sends a trade unit to another player and this event is for that other player receiving the trade. a dialog box displays, with trade details, asking if the player would like that trade. 30 seconds countdown. when timer reaches zero, the dialog box closes.
		tradeProposalAnsweredAs(_data, _sender); // what did the player answer as the trade request dialog box!
		
		Movement(_data, _sender);  // makes all clients move the same piece at the same time. this is not automatic. you need to set the values below at the game code. see SignatureGameClickMe.hx. at client.
		
		gamePlayersValues(_data, _sender);	// is the player playing a game or waiting to play. 0 = not playing but still at game room. 1 playing a game. 2: left game room while still playing it. 3 left game or game room when game was over. 
		
		spectatorWatching(_data, _sender); // user who requested to watch a game. that user can never play a game in that game room.
		
		spectatorWatchingGetMoveNumber(_data, _sender); // send the current move number to the watching spectator so that the timer and white box underneath the P1, P2, P3 or P4 moves, can be updated.
		
		moveHistoryNextEntry(_data, _sender);	// every player that moves a piece will use the host of the room to call this event so to update the move history at mysql. this is needed so that when a spectator watching enters the room, that person can get all the move history for that game.
		
		moveHistoryAllEntry(_data, _sender);	// the spectator has just joined the game room because there is currently only one move in that users history, do this event to get all the moves in the move history for this game.
		
		leaderboards(_data, _sender);			// display a 50 player list of the players with the top experence points.
		
		saveNewAccountConfigurations(_data, _sender); // save new user account information. when user first enters online game and chess elo equals zero then the user is new. the user will then be redirected to a new account scene where new user configuration will be set, such as chess skill level. when the save button is pressed, this event is called.
		
		dailyQuests(_data, _sender); 			// conpete these daily quests for rewards.
		dailyQuestsClaim(_data, _sender); 		// At the client the daily quest reward was given to player. this event saves the _reward var so that a second reward of the same type will not be given to player.
		dailyRewardSave(_data, _sender); // A daily reward has been claimed. now save the reward(s) to the database.
		// #############################################################
		
		_mysqlDB.clearLoggedInTables(); // delete all logged in users because server is starting. we do this at starting not stopping because server may have crashed.
				
		_server.listen();

		Sys.println ("Server started.");
		Sys.println ("Hold CTLR key then press C key to exit.");
		Sys.println ("");
		
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
	
	
	/**************************************************************************
	 * this checks if there is an event to give on this day but after the player won the game.
	 * see the doEvent() function.
	 */
	private function eventsWin(_data:Dynamic, _username:Dynamic):Void
	{
		//-------------------------------
		// daily quests.
		_mysqlDB.saveDailyQuests_3_in_a_row_win(_username);
		
		// if finished a game of chess in 5 or under moves...
		if (_data._gameId == 1 && _data._moveTotal <= 5) 
			_mysqlDB.saveDailyQuests_chess_5_moves_under(_username);
		// if finished a game of snakes and ladder in under 4 moves...
		if (_data._gameId == 3 && _data._moveTotal < 4) 
			_mysqlDB.saveDailyQuests_snakes_under_4_moves(_username);
		if (_data._timeTotal == 300) // 300 is 5m * 60s (5*60)
			_mysqlDB.saveDailyQuests_win_5_minute_game(_username);
		
		if (_data._house_items_daily_total >= 4)
			_mysqlDB.saveDailyQuests_buy_four_house_items(_username);
		if (_data._gameId == 4) // signature game.
			_mysqlDB.saveDailyQuests_finish_signature_game(_username);
		if (_data._gameId == 2 && _data._piece_total_for_winner >= 50)
			_mysqlDB.saveDailyQuests_reversi_occupy_50_units(_username);

			//------------------------------
			// checkers.	
			if (_data._gameId == 0 && _data._checkers_king_total >= 6) 
				_mysqlDB.saveDailyQuests_checkers_get_6_kings(_username);
				
			_data._all_boardgames_played_total[_data._gameId] = 1;
			
			var _count = true;
			
			for (i in 0...5) // all board games currently in client.
			{
				if (_data._all_boardgames_played_total[i] == 0)
					_count = false;
			}
			
			if (_count == true)
				_mysqlDB.saveDailyQuests_play_all_5_board_games(_username);
			//----------------------------
		//------------------------------
		
		doEvent(0, _data, false, _username); // credits.
		doEvent(1, _data, false, _username); // experience points.
		doEvent(2, _data, false, _username); // house coins.
	}
	
	/**************************************************************************
	 * this checks if there is an event to give on this day but after the player lost the game.
	 * see the doEvent() function.
	 */
	private function eventsLose(_data:Dynamic, _username:Dynamic):Void
	{
		_mysqlDB.saveDailyQuests_3_in_a_row_lose(_username);
		
		doEvent(1, _data, true, _username); // experience points.
		doEvent(2, _data, true, _username); // house coins.
	}
	
	/**************************************************************************
	 * do an event. the event code is used to determine which event to execute.
	 */
	private function doEvent(_num:Int, _data:Dynamic, _loseGame:Bool, _username:Dynamic):Void
	{
		_data._username = _username;
		
		switch (_num)
		{
			case 0: // credits
			{
				var rset = _mysqlDB.getEventCreditsFromUsersTable(_data._username);
				
				// month january starts at 0 not 1.
				var _intMonth = Std.parseInt(DateTools.format(Date.now(), "%m")) -1;
				var _intDay = Std.parseInt(DateTools.format(Date.now(), "%d"));
					
				if (Reg._eventMonths[0][_intMonth] == 1
				&&  Reg._eventDays[0][_intDay-1] == 1)
				{		
					// if event month and day in reg file is different than month and day found in table then write new month and day value to table and also write credits_today value to 0 since this is a new day.						
					if (_intMonth != rset._eventMonth[0]
					&&  _intDay != rset._eventDay[0])
					{
						_mysqlDB.changeEventCreditsMonthAndDay(_data._username, _intMonth, _intDay);
					}
					
					// if under 5 credits for today then give 1 credit to user that won the game. note that this event is called when game is won.
					else if (rset._creditsToday[0] < 5)
					{
						_mysqlDB.giveCreditToUser(_data._username);
					}
				}
				
					
			}
			
			case 1: // experience points.
			{
				// month january starts at 0 not 1.
				var _intMonth = Std.parseInt(DateTools.format(Date.now(), "%m")) -1;
				var _intDay = Std.parseInt(DateTools.format(Date.now(), "%d"));
				
				// Reg._eventMonths[1] and Reg._eventDays[1] refer to experience points event. 0: credits, 1: exp points. etc. give double xp.
				if (Reg._eventMonths[1][_intMonth] == 1
				&&  Reg._eventDays[1][_intDay-1] == 1)
				{
					if (_loseGame == true)
					{
						// double the experience points divided by 2.
						var _halfExperiencePointsGiven:Int = Math.round((_experiencePointsGiven[_data._gameId] * 2) / 2);
						_mysqlDB.giveExperiencePointsToUser(_data._username, _halfExperiencePointsGiven);
					}
					
					else 
					{
						// double the experience points.
						_mysqlDB.giveExperiencePointsToUser(_data._username, _experiencePointsGiven[_data._gameId] * 2);
					}
				}
				
				// this is not an event day so give normal xp (experience points.)
				else
				{
					if (_loseGame == true)
					{
						// normal expierience points divided by 2.
						var _halfExperiencePointsGiven:Int = Math.round(_experiencePointsGiven[_data._gameId] / 2);
						_mysqlDB.giveExperiencePointsToUser(_data._username, _halfExperiencePointsGiven);
						
					}
					
					else 
					{
						// give normal experience points.
						_mysqlDB.giveExperiencePointsToUser(_data._username, _experiencePointsGiven[_data._gameId]);
					}
				}
			}
			
			case 2: // house coins.
			{
				// month january starts at 0 not 1.
				var _intMonth = Std.parseInt(DateTools.format(Date.now(), "%m")) -1;
				var _intDay = Std.parseInt(DateTools.format(Date.now(), "%d"));
				
				// Reg._eventMonths[1] and Reg._eventDays[1] refer to experience points event. 0: credits, 1: exp points. etc. give double xp.
				if (Reg._eventMonths[2][_intMonth] == 1
				&&  Reg._eventDays[2][_intDay-1] == 1)
				{
					var _coins:Int = 0;
					
					if (_loseGame == true)
					{
						_mysqlDB.giveHouseCoinsToUser(_data._username, 1);
					}
					
					else 
					{
						_mysqlDB.giveHouseCoinsToUser(_data._username, 2);
					}
				}
				
			}
			
			
			
		}
		
		
	}
	
	/******************************
	* EVENT JOIN
	* this Join event is the first read when the client connects to this server.
	*/
	private function join(_data, _sender):Void
	{
		_server.events.on("Join", function(_data:Dynamic, _sender:vendor.mphx.connection.IConnection)
		{
			try 
			{
				userLogs("Join", "", "", ""); // logs.
				
				if (_data.id.length > 80) return;
				if (_data._username.length > 80) return;
				if (_data._popupMessage.length) return;
				if (_data._host.length > 80) return;
				
				//if (_data._username.length == 0) _data._username = "npc ben"; 
				
				// _sender is the current player connected to this server. _sender is passed through this event. the _senders _data is set for the client to get.
				allDataGame.set(_sender, _data);
				allDataGame0.set(_sender, _data);
				allDataGame1.set(_sender, _data);
				allDataGame2.set(_sender, _data);
				allDataGame3.set(_sender, _data);
				allDataGame4.set(_sender, _data);
				
				allDataDailyQuests.set(_sender, _data);
				allDataQuestions.set(_sender, _data);
				allDataOnlinePlayers.set(_sender, _data);
				allDataMisc.set(_sender, _data);
				allDataPlayers.set(_sender, _data);
				allDataTournaments.set(_sender, _data);
				allDataAccount.set(_sender, _data);
				allDataGameMessage.set(_sender, _data);
				allDataMovement.set(_sender, _data);
				allDataStatistics.set(_sender, _data);
				allDataHouse.set(_sender, _data);
				allDataLeaderboards.set(_sender, _data);
				
				// a client has connected to this server. Therefore, increase the amount of clients connected.
				_serverConnections += 1;

				// if no more connections are allowed then send _data to the clients "DisconnectByServer" event. Every client will receive the broadcast but only the player with the id of the sender will be disconnected.
				if (_serverConnections >= _maximumServerConnections)
				{
					_server.broadcast("DisconnectByServer", _data);
				}
				// connection is allowed, send a trace message to the servers console about the connection. Next broadcast the _data so every open client has the connected player displayed in that app.
				else
				{
					Sys.println ("A client has joined the server.");

					// a client has connected to this server. Therefore, increase the amount of clients connected.

					Sys.println ("Clients connected: " + _serverConnections);

					_accountState = allDataAccount.get(_sender);

					var host = _mysqlDB.addHostToLoggedInTable(_accountState._host);

					if (host == true) _accountState._alreadyOnlineHost = true;
					else _accountState._alreadyOnlineHost = false;

					//var rset = _mysqlDB.select_ip(_data._username);
					//var _resolve_ip = new Host(Std.string(rset._ip[0]));
					//_accountState._ip = Std.string(_resolve_ip);
					
					// get the current room data for user.
					/*_miscState._roomState = _roomState;
					_miscState._roomPlayerLimit = _roomPlayerLimit;
					_miscState._roomPlayerCurrentTotal = _roomPlayerCurrentTotal;
					_miscState._vsComputer = _vsComputer;
					_miscState._allowSpectators = _allowSpectators;
					_miscState._roomGameIds = _roomGameIds;
					_miscState._roomHostUsername = _roomHostUsername;
					_miscState._gid = _gid;
					*/
					_accountState._server_fast_send = _server.fastSend;
					_accountState._server_blocking = _server.blocking;			
					_accountState._clients_connected = _serverConnections;
					
					_server.broadcast("Join", _accountState);
					
				}
			}
			catch (e:Dynamic)
			{
				Sys.println ('Warning, someone accessed the server perhaps from a "is my port active" service.');
				
				userLogs("Join", "", "", ""); // logs.				
			}
		});
	}

	/******************************
	* EVENT DISCONNECT BY SERVER
	* then server is full, this event closes the client that tries to connect. this is the same as the disconnect event but it works because it calls a different code at client.
	*/
	private function disconnectByServer(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("DisconnectByServer", function (_data, _sender)
		{
			_miscState = allDataMisc.get(_sender);
			_miscState._alreadyOnlineHost = _data._alreadyOnlineHost;
			_miscState._host = _data._host;

			_sender.send("DisconnectByServer", _miscState);
		});
	}
	
	/******************************
	* EVENT DISCONNECT ALL PLAYERS BY SERVER
	*/
	private function disconnectAllByServer(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Disconnect All By Server",function (_data, _sender){
			_closeServer = true;

			_miscState = allDataMisc.get(_sender);
			_miscState._alreadyOnlineHost = _data._alreadyOnlineHost;
			_miscState._host = _data._host;

			_server.broadcast("Disconnect All By Server", _miscState); // need to call this event here to remove all players or else when user clicks the X button at the top-right corner of the client application the _gameState at the other clients will not be deleted.
		});
	}
	
	/******************************
	* EVENT IS LOGGING IN. user is typing a username and password to enter the lobby.
	* _dataAccount
	*/
	private function isLoggingIn(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Is Logging In", function (_data, _sender)
		{
			_accountState = allDataAccount.get(_sender);
			
			var _set_username = getUsername(_accountState._ip);
			
			// is user at website client?
			if (_data._guest_account == true)
			{
				var _rset = _mysqlDB.select_last_logged_in_guest();
				
				if (_rset._user[0] == null) 
					_accountState._username = _data._username = _set_username = "guest1";
				else
				{
					// this looks wrong but its correct. remember substr starts at 0 not 1. therefore the length of "guest" is 4 not 5. it is 4 because langth is always plus 1 from total. this line gets the last guest in the database, finds the number after the guest name, eg, guest1, then increments that value by 1 then sets username to that new guest name, eg, guest2
					var _temp = Std.string(_rset._user[0]);
					_temp = _temp.substr(5, _rset._user[0].length - 4);
					var _num = Std.parseInt(_temp) + 1;
					
					_accountState._username = _data._username = _set_username = "guest" + Std.string(_num); 
				}
				
			}
	
			if (_set_username != "" && _data._username == _set_username)
				_accountState._username = _set_username.substr(0, 11);
			// if client is not ready for release, at client title, buttons for npc login are displayed. when clicking those buttons, the _data._username will be set to that button name. the reason for this is because when using fast login without password check, the ip address of the user is checked against the ip in the mysql atabase, however, the npc's all share the same ip. so logging in the second time cannot be achived without those bottons at client. note that the buttons will not be display at release mode.
			else
			{
				if (_data._username == "npc ben"
				||  _data._username == "npc tina"
				||  _data._username == "npc amy"
				||  _data._username == "npc piper"
				||  _data._username == "npc zak")
					_set_username = _data._username;
			}
			
			if (_set_username != "" && _data._username == _set_username) // enter loop if username is logged in.
			{
				_mysqlDB.deleteRoomData(_accountState._username);
				_mysqlDB.deleteUserKickedAndBanned(_accountState._username);
				_mysqlDB.deleteIsHost(_accountState._username); 
				
				// check if user is already online.				
				var _found = _mysqlDB.requestLoggedInUsers(_accountState._username);

				if (_found == true) 
				{
					_accountState._alreadyOnlineUser = true; // username is already online. this var will be sent to client at that time the user will be disconnected.
				}
				else
				{
					// create room_data mysql fields. when user logs off, the mysql username rows will be deleted.
					addRowsToDatabase(_accountState);
					
				}
				
				// the vars hold the state of a player's game, such as, did the player quit the game, or is the player at the game room but is not playing the game? these vars are at the button of events that use these vars and also at the disconnect event so that the player can send these updated vars to other players in that room. those other players need these vars to that a proper message is displayed to them, such as, the player had left the room message.
				player_game_state_value_username.push(_data._username);
				player_game_state_value_data.push([0,0,0,1]);

				_accountState._alreadyOnlineHost = false;
				_accountState._popupMessage = "Login successful."; // if you change the value of this string then you need to change it also at client.

				userLogs("Is Logging In", _data.id, _data._username); // logs.
				_mysqlDB.insertUserToUsersTable(_data._username, _data._ip);
				_mysqlDB.insertUserToDailyQuestsTable(_data._username);
				
				_sender.putInRoom(room[0]);
				
			}
			else
			{
				_accountState._popupMessage = "Login failed."; // if you change the value of this string then you need to change it also at client.
			}

			_sender.send("Is Logging In", _accountState);
			
		});
	}
	
	private function player_game_state_value_update(_data:Dynamic):Void
	{
		// if true then we are at the game room.
		if (_data._username != null
		&&	_data._gamePlayersValues != null)
		{		
			for (i in 0...player_game_state_value_username.length+1)
			{
				// find the username is this var.
				if (_data._username == player_game_state_value_username[i])
				{
					// update the game state for this player.
					player_game_state_value_data[i] = _data._gamePlayersValues;
				}
			}
		}

	}
	
	/**************************************************************************
	* EVENT LOAD HOUSE DATA.
	* players house where they buy items, place items in room and vote for best house for prizes.
	*/
	private function houseLoad(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("House Load", function (_data, _sender)
		{
			userLogs("House Load", _data.id, _data._username, _data); // logs.
	
			var row = _mysqlDB.getHouseDataForUser(_data._username);
	
			_data._sprite_number = Std.string(row._spriteNumber[0]);
			_data._sprite_name = Std.string(row._spriteName[0]);
			_data._items_x = Std.string(row._itemsX[0]);
			_data._items_y = Std.string(row._itemsY[0]);
			_data._map_x = Std.string(row._mapX[0]);
			_data._map_y = Std.string(row._mapY[0]);
			_data._is_item_purchased = Std.string(row._isItemPurchased[0]);
			_data._item_direction_facing = Std.string(row._itemDirectionFacing[0]);
			_data._map_offset_x = Std.string(row._mapOffsetX[0]);
			_data._map_offset_y = Std.string(row._mapOffsetY[0]);
			_data._item_is_hidden = Std.string(row._itemIsHidden[0]);
			_data._item_order = Std.string(row._itemOrder[0]);
			_data._item_behind_walls = Std.string(row._itemBehindWalls[0]);
			_data._floor = Std.string(row._floor[0]);
			_data._wall_left = Std.string(row._wallLeft[0]);
			_data._wall_up_behind = Std.string(row._wallUpBehind[0]);
			_data._wall_up_in_front = Std.string(row._wallUpInFront[0]);
			_data._floor_is_hidden = Std.string(row._floorIsHidden[0]);
			_data._wall_left_is_hidden = Std.string(row._wallLeftIsHidden[0]);
			_data._wall_up_behind_is_hidden = Std.string(row._wallUpBehindIsHidden[0]);
			_data._wall_up_in_front_is_hidden = Std.string(row._wallUpInFrontIsHidden[0]);
			
			_sender.send("House Load", _data);
		});
	}
	
	/**************************************************************************
	* EVENT SAVE HOUSE DATA.
	*/
	private function houseSave(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("House Save", function (_data, _sender)
		{
			userLogs("House Save", _data.id, _data._username, _data); // logs.
			
			_mysqlDB.saveHouseDataForUser(_data._username, _data._sprite_number, _data._sprite_name, _data._items_x, _data._items_y, _data._map_x, _data._map_y, _data._is_item_purchased, _data._item_direction_facing, _data._map_offset_x, _data._map_offset_y, _data._item_is_hidden, _data._item_order, _data._item_behind_walls, _data._floor, _data._wall_left, _data._wall_up_behind, _data._wall_up_in_front, _data._floor_is_hidden, _data._wall_left_is_hidden, _data._wall_up_behind_is_hidden, _data._wall_up_in_front_is_hidden);
	
		});
	}
		
	/******************************
	* EVENT PLAYER MOVE TIME REMAINING
	* Gets the current move timer for the player that is moving. the value is sent to the other clients so that they have the update value.
	*/
	private function playerMoveTimeRemaining(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Player Move Time Remaining",function (_data, _sender)
		{			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Player Move Time Remaining", _data);
				}
			}

		});
	}

	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	*/
	private function playerMoveId0(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Player Move Id 0",function (_data, _sender)
		{
			userLogs("Player Move Id 0", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Player Move Id 0", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	*/
	private function playerMoveId1(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Player Move Id 1",function (_data, _sender)
		{
			userLogs("Player Move Id 1", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Player Move Id 1", _data);
				}
			}
			
		});
	}	
	
	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	*/
	private function playerMoveId2(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Player Move Id 2",function (_data, _sender)
		{
			userLogs("Player Move Id 2", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Player Move Id 2", _data);
				}
			}
			
		});
	}
	
	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	* RegTypedef._dataGame3._gameUnitNumberNew
	*/
	private function playerMoveId3(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Player Move Id 3",function (_data, _sender)
		{
			userLogs("Player Move Id 3", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Player Move Id 3", _data);
				}
			}
			
		});
	}	
	
	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	*/
	private function playerMoveId4(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Player Move Id 4",function (_data, _sender)
		{
			userLogs("Player Move Id 4", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Player Move Id 4", _data);
				}
			}
			
		});
	}

	/****************************************************************************
	* EVENT DAILY QUESTS
	* complete these daily quests for rewards.
	* _dailyQuestsState
	*/
	private function dailyQuests(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Daily Quests",function (_data, _sender)
		{
			userLogs("Daily Quests", _data.id, _data._username, _data); // logs.
			
			var rset = _mysqlDB.selectDailyQuestsData(_data._username);
			var _day_name_current = Std.string(rset._day_name[0]);
			
			// get the rewards data from the database then split it at the comma then store it as an array so that we can work with each of the posible 3 rewards that can be given.
			var _rewards_str = Std.string(rset._rewards[0]);
			var _rewards = _rewards_str.split(",");
			
			// this var counts how many quests are complete.
			var _num = 0;
			
			//------------------------ determine first reward.
			_data._three_in_a_row = Std.string(rset._three_in_a_row[0]);
			if (Std.parseInt(_data._three_in_a_row) >= 3) _num += 1;
			
			_data._chess_5_moves_under = Std.string(rset._chess_5_moves_under[0]);
			if (Std.parseInt(_data._chess_5_moves_under) == 1) _num += 1;
			
			_data._snakes_under_4_moves = Std.string(rset._snakes_under_4_moves[0]);
			if (Std.parseInt(_data._snakes_under_4_moves) == 1) _num += 1;
			
			_data._win_5_minute_game = Std.string(rset._win_5_minute_game[0]);
			if (Std.parseInt(_data._win_5_minute_game) == 1) _num += 1;
			
			_data._buy_four_house_items = Std.string(rset._buy_four_house_items[0]);
			if (Std.parseInt(_data._buy_four_house_items) >= 4) _num += 1;
			
			_data._finish_signature_game = Std.string(rset._finish_signature_game[0]);
			if (Std.parseInt(_data._finish_signature_game) == 1) _num += 1;
			
			_data._reversi_occupy_50_units = Std.string(rset._reversi_occupy_50_units[0]);
			if (Std.parseInt(_data._reversi_occupy_50_units) == 1) _num += 1;
			
			_data._checkers_get_6_kings = Std.string(rset._checkers_get_6_kings[0]);
			if (Std.parseInt(_data._checkers_get_6_kings) == 1) _num += 1;
			
			_data._play_all_5_board_games = Std.string(rset._play_all_5_board_games[0]);
			if (Std.parseInt(_data._play_all_5_board_games) >= 5) _num += 1; // TODO currently 5 board games. change 5 to 6 when the enxt game is ready.
			
			//--------------------------------
			if (_rewards[0] == "0" && _num >= 3)
			{
				_rewards[0] = "1"; // first reward can now be given at client. we will save this as part of the _rewards var down below to the database.
			}
						
			if (_rewards[1] == "0" && _num >= 6)
			{
				_rewards[1] = "1"; // second reward can now be given at client. we will save this as part of the _rewards var down below to the database.
			}
			
			if (_rewards[2] == "0" && _num >= 9
			)
			{
				_rewards[2] = "1"; // third reward can now be given at client. we will save this as part of the _rewards var down below to the database.
			}
		
			// add one day into the future, so if current time is greater than this time (86400 = 1 day + some minutes) then the daily quests will be reset. see near end of this event.
			var _timestamp = Std.string(rset._timestamp[0]); 
			var _timestamp_daily = Std.parseInt(_timestamp + 87000);

			_data._rewards = _rewards[0] + "," + _rewards[1] + "," + _rewards[2];
			_mysqlDB.saveDailyQuests_rewards(_data._username, _data._rewards);
			
			//---------------------------------
		
			var _now = Date.now();
			var _dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saterday"];
			var _day_name = _dayNames[_now.getDay()];
			
			// if this is a different day than that which is stored in the database then reset all daily quest data back to 0 and then save that data to the database because we are starting a new day.
			// 86400 equals 24 hours.		 
			if (_day_name != _day_name_current
			||  Sys.time() > _timestamp_daily)
			{
				_data._three_in_a_row = "0";
				_data._chess_5_moves_under = "0";
				_data._snakes_under_4_moves = "0";
				_data._win_5_minute_game = "0";
				_data._buy_four_house_items = "0";
				_data._finish_signature_game = "0";
				_data._reversi_occupy_50_units = "0";
				_data._checkers_get_6_kings = "0";
				_data._play_all_5_board_games = "0";
				_data._rewards = "0,0,0";
				
				_mysqlDB.deleteThenRecreateDailyQuestsTable(_data._username);
			}
						
			_sender.send("Daily Quests",_data);
		});
	}
	
	/****************************************************************************
	* EVENT DAILY QUESTS CLAIM
	* At the client the daily quest reward was given to player. this event saves the _reward var so that a second reward of the same type will not be given to player.
	* _dailyQuestsState
	*/
	private function dailyQuestsClaim(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Daily Quests Claim",function (_data, _sender)
		{
			userLogs("Daily Quests Claim", _data.id, _data._username, _data); // logs.
		
			_mysqlDB.saveDailyQuests_rewards(_data._username, _data._rewards);
		});
	}
	
	/****************************************************************************
	* EVENT DAILY REWARD SAVE
	* A daily reward has been claimed. now save the reward(s) to the database.
	* _dataStatistics
	*/
	private function dailyRewardSave(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Daily Reward Save",function (_data, _sender)
		{
			userLogs("Daily Reward Save", _data.id, _data._username, _data); // logs.
		
			_mysqlDB.daily_reward_save(_data._username, _data._experiencePoints, _data._houseCoins, _data._creditsTotal);
		});
	}
	
	/**************************************************************************
	 * makes all clients move the same piece at the same time. this is not automatic. you need to set the values below at the game code. see SignatureGameClickMe.hx. at client.
	 */
	private function Movement(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Movement",function (_data, _sender)
		{
			userLogs("Movement", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Movement", _data);
				}
			}
			
		});
	}
		
	/******************************
	* EVENT GET STATISTICS WIN LOSS DRAW
	* Win - Draw - Loss Stats for player(s).
	* _dataPlayers
	*/
	private function getStatisticsWinLossDraw(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Get Statistics Win Loss Draw", function(_data, _sender)
		{
			userLogs("Get Statistics Win Loss Draw", _data.id, _data._username, _data); // logs.
			
			// clear data. we will populate it down below.
			for (i in 0...4)
			{
				_data._usernamesDynamic[i] = "";
				_data._gamesAllTotalWins[i] = 0;
				_data._gamesAllTotalLosses[i] = 0;
				_data._gamesAllTotalDraws[i] = 0;
			}
			
			// get all users in waiting room.
			var rset = _mysqlDB.selectPlayersUsernames(_data._room);
			
			// these users are in room. for a 2 player game, only the first two of these vars will not be empty.
			var _user1 = rset._user[0];
			var _user2 = rset._user[1];
			var _user3 = rset._user[2];
			var _user4 = rset._user[3];

			
			var rset2 = _mysqlDB.getStatsWinLoseDrawFromUsers(Std.string(_user1));
			
			// if username exists in database...
			// put those stats into the _data to send to client.
			if (_user1 != null)
			{
				_data._usernamesDynamic[0] = Std.string(_user1);
				
				_data._gamesAllTotalWins[0] = rset2._gamesAllTotalWins[0];
				_data._gamesAllTotalLosses[0] = rset2._gamesAllTotalLosses[0];
				_data._gamesAllTotalDraws[0] = rset2._gamesAllTotalDraws[0];
				
				var rset3 = _mysqlDB.selectUserAvatar(Std.string(_user1));
				_data._avatarNumber[0] = Std.string(rset3._avatarNumber[0]);
				
				if (_data._avatarNumber[0] == "") _data._avatarNumber[0] = "0.png";
			}	
			
			if (_user2 != null)
			{
				var rset2 = _mysqlDB.getStatsWinLoseDrawFromUsers(Std.string(_user2));
				
				// if username exists in database...
				// put those stats into the _data to send to client.
				_data._usernamesDynamic[1] = Std.string(_user2);
				
				_data._gamesAllTotalWins[1] = rset2._gamesAllTotalWins[0];
				_data._gamesAllTotalLosses[1] = rset2._gamesAllTotalLosses[0];
				_data._gamesAllTotalDraws[1] = rset2._gamesAllTotalDraws[0];
				
				var rset3 = _mysqlDB.selectUserAvatar(Std.string(_user2));
				_data._avatarNumber[1] = Std.string(rset3._avatarNumber[0]);
				
				if (_data._avatarNumber[1] == "") _data._avatarNumber[1] = "0.png";

			}
			
			
			if (_user3 != null)
			{
				var rset2 = _mysqlDB.getStatsWinLoseDrawFromUsers(Std.string(_user3));
				
				// if username exists in database...
				// put those stats into the _data to send to client.
				_data._usernamesDynamic[2] = Std.string(_user3);
								
				_data._gamesAllTotalWins[2] = rset2._gamesAllTotalWins[0];
				_data._gamesAllTotalLosses[2] = rset2._gamesAllTotalLosses[0];
				_data._gamesAllTotalDraws[2] = rset2._gamesAllTotalDraws[0];
				
				var rset3 = _mysqlDB.selectUserAvatar(Std.string(_user3));
				_data._avatarNumber[2] = Std.string(rset3._avatarNumber[0]);
				
				if (_data._avatarNumber[2] == "") _data._avatarNumber[2] = "0.png";

			}
			
			
			if (_user4 != null)
			{
				var rset2 = _mysqlDB.getStatsWinLoseDrawFromUsers(Std.string(_user4));
				
				// if username exists in database...
				// put those stats into the _data to send to client.
				_data._usernamesDynamic[3] = Std.string(_user4);
								
				_data._gamesAllTotalWins[3] = rset2._gamesAllTotalWins[0];
				_data._gamesAllTotalLosses[3] = rset2._gamesAllTotalLosses[0];
				_data._gamesAllTotalDraws[3] = rset2._gamesAllTotalDraws[0];
				
				var rset3 = _mysqlDB.selectUserAvatar(Std.string(_user4));
				_data._avatarNumber[3] = Std.string(rset3._avatarNumber[0]);
				
				if (_data._avatarNumber[3] == "") _data._avatarNumber[3] = "0.png";

			}
			
			// the "room waiting" calls this event every some many ticks, so here is a good time to update the players move order.
			var rset = _mysqlDB.selectPlayersUsernames(_data._room);
			
			var _num:Int = 0;
			for (i in 0..._data._usernamesDynamic.length)
			{
				_num += 1;
				_mysqlDB.moveNumber(_data._usernamesDynamic[i], _num);
				_data._moveNumberDynamic[i] = _num;
			}
			
			// chat, score and stuff that is not a win, lose or draw data is passed to the server.
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Get Statistics Win Loss Draw", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT GET STATISTICS All
	* Example, experience points, credits, win - draw - loss, all stats.
	* _dataStatistics
	*/
	private function getStatisticsAll(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Get Statistics All", function(_data, _sender)
		{
			userLogs("Get Statistics All", _data.id, _data._username, _data); // logs.
			
			var rset = _mysqlDB.getStatsAllFromUsers(_data._username);

			// put stats into an array.
			// these vars was declared at this file.
			_data._chess_elo_rating = rset._chess_elo_rating[0];
			
			_data._gamesAllTotalWins = rset._gamesAllTotalWins[0];
			_data._gamesAllTotalLosses = rset._gamesAllTotalLosses[0];
			_data._gamesAllTotalDraws = rset._gamesAllTotalDraws[0];
			_data._creditsTotal = rset._creditsTotal[0];
			_data._experiencePoints = rset._experiencePoints[0];
			_data._houseCoins = rset._houseCoins[0];
			
			_data._checkersWins = rset._checkersWins[0];
			_data._checkersLosses = rset._checkersLosses[0];
			_data._checkersDraws = rset._checkersDraws[0];
			_data._chessWins = rset._chessWins[0];
			_data._chessLosses = rset._chessLosses[0];
			_data._chessDraws = rset._chessDraws[0];
			_data._reversiWins = rset._reversiWins[0];
			_data._reversiLosses = rset._reversiLosses[0];
			_data._reversiDraws = rset._reversiDraws[0];
			_data._snakesAndLaddersWins = rset._snakesAndLaddersWins[0];
			_data._snakesAndLaddersLosses = rset._snakesAndLaddersLosses[0];
			_data._snakesAndLaddersDraws = rset._snakesAndLaddersDraws[0];
			_data._signatureGameWins = rset._signatureGameWins[0];
			_data._signatureGameLosses = rset._signatureGameLosses[0];
			_data._signatureGameDraws = rset._signatureGameDraws[0];
			
			_sender.send("Get Statistics All",_data);
			
		});
	}
	
	/******************************
	* EVENT PLAYER HAS ENTERED THE ROOM, SO CHANGE THE ROOMSTATE VALUE.
	* _dataMisc
	*/
	private function greaterRoomStateValue(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Greater RoomState Value", function(_data, _sender)
		{
			userLogs("Greater RoomState Value", _data.id, _data._username, _data); // logs.
			
			_data._roomState = _roomState;
			_vsComputer[_data._room] = _data._vsComputer[_data._room];
			
			// roomState was added to this line to stop a bug where leaving a game and reentering the room would set the button to playing game while the user would stay at lobby.
			if (_data._gameRoom == true && _data._userLocation >= 2)
			{
				_data._roomState[_data._room] = 8; // trigger the playing game text at lobby button.
								
				_data._userLocation = 3; // playing game room.	
				_data._usernamesTotalDynamic = _data._roomPlayerLimit[_data._room];
				_data._usernamesTotalStatic = _data._roomPlayerLimit[_data._room];
				
			}
			
			else 
			{
				var _found:Bool = false;
				
				var rset = _mysqlDB.selectRoomData(_data._room);
			
			
				for ( i in 0...rset._userLocation.length)
				{
					// if true then there is a user creating a room.
					if (rset._userLocation[i] == 1
					 && Std.string(rset._user[i].toString) != 
						Std.string(_data._username)
					 && _data._userLocation == 1)
					{
						_found = true;
					}
					
					if (rset._userLocation[i] == 2
					 && Std.string(rset._user[i].toString) != 
					    Std.string(_data._username)
					)
					{
						// for all other users in the room...
						_data._roomPlayerLimit[_data._room] = rset._playerLimit[i];					
					}
					
				}
				
				
				// create room.
				if (_found == true || _data._roomState[_data._room] == 0)
				{
					_data._roomState[_data._room] = 1;
					_data._userLocation = 1;
				}				
				
				// if false, then a user is entering a room. determine if user should enter a room.
				
				// roomState value of 2 = creating a room. value of 3 means player is in the room. if max player limit is 2 and there is 1 player in the room. that means we need to plus 1 to this code so that the code condition works.
				else if (_data._roomState[_data._room] < 3 || _data._roomPlayerLimit[_data._room] == 0) // roomState of 2 and a limit of 2 does not work so we plus 1 to the limit.
				{
					_data._roomState[_data._room] += 1;								
					
					var rset2 = _mysqlDB.selectRoomDataUser(_data._username);
									
					_data._userLocation = 2;
					
					if (_data._roomPlayerLimit[_data._room] > 0)
						_roomPlayerLimit[_data._room] = _data._roomPlayerLimit[_data._room];
				}
			}	
				
			if (_data._spectatorWatching == false)
			{
				_mysqlDB.saveRoomStateRoom(_data._room, _data._roomState[_data._room], _data._userLocation, _data._roomPlayerLimit[_data._room]);
			}
			
			else _mysqlDB._spectatorWatching(_data._username, _data._roomState[_data._room], _data._userLocation, _data._room, _data._roomPlayerLimit[_data._room], _data._roomGameIds[_data._room], _data._vsComputer[_data._room], _data._allowSpectators[_data._room]);
			
			// when entering the game room, get all usernames from the database. this is needed for the server on disconnect event, so that correct data can be sent to the rest of the players at game room at the time the player disconnects.
			if (_data._userLocation == 3)
			{
				_usernames_static[_data._room][0] = "";
				_usernames_static[_data._room][1] = "";
				_usernames_static[_data._room][2] = "";
				_usernames_static[_data._room][3] = "";
				
				var rset3 = _mysqlDB.selectRoomData(_data._room);
				
				if (rset3._user[0] != null) 
					_usernames_static[_data._room][0] = Std.string(rset3._user[0]);
					
				if (rset3._user[1] != null) 
					_usernames_static[_data._room][1] = Std.string(rset3._user[1]);
				
				if (rset3._user[2] != null) 
					_usernames_static[_data._room][2] = Std.string(rset3._user[2]);
				
				if (rset3._user[3] != null) 
					_usernames_static[_data._room][3] = Std.string(rset3._user[3]);
			}
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Greater RoomState Value", _data);
				}
			}
						
		});

	}

	/******************************
	* EVENT PLAYER HAS LEFT THE ROOM, SO CHANGE THE ROOMSTATE VALUE.
	* _dataMisc
	*/
	public function lesserRoomStateValue(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Lesser RoomState Value", function(_data, _sender)
		{
			userLogs("Lesser RoomState Value", _data.id, _data._username, _data); // logs.
		
			var _room = _data._room;
			
			var _count = _mysqlDB.usersPlayingGameCount(_room);
			
			if (_data._spectatorWatching == false)
			{
				if (_data._roomPlayerCurrentTotal[_room] == 1) 
				{					
					_roomPlayerLimit[_room] = _data._roomPlayerLimit[_room] = 0;
				}
								
				// if ended a game where there are two or more players still playing, minus one from the total players playing so that the total players are the correct count at that lobby room.
				else if (_data._roomPlayerLimit[_room] > 2
				&&  _data._roomState[_room] == 8)
					_roomPlayerLimit[_room] = _data._roomPlayerLimit[_room] -= 1;
					
				
					// if true then there is not enought players to play a game. remove all players from room at database so that at lobby a player can enter that room.
				//if (_data._roomPlayerCurrentTotal[_room] == 2) 
						
			}
			
			//_vsComputer[_data._room] = _data._vsComputer[_data._room];
			//_data._roomState = _roomState;
			
			if (_data._spectatorWatching == false)
			{
				// this removes host from room by deleting any user that exists at room at this database table.
				if (_count <= 2)
				{
					_roomHostUsername[_data._room] = _data._roomHostUsername[_data._room] = "";	
					_gid[_data._room] = _data._gid[_data._room] = "";	
										
					// delete host only if game has endded and no one else has created or is creating a room.
					if (_roomState[_data._room] < 1
					||  _roomState[_data._room] == 8)
					_mysqlDB.deleteIsHostRoom(_data._room);
					
					// if player is hosting a room then remove player because the remove deleteIsHostRoom might fail.
					_mysqlDB.deleteIsHost(_data._username);
					
				}
				
				if (_data._roomState[_data._room] == 8) 
				{
					//if (_count == 2) _mysqlDB.deleteRoomDataAll(_data._room);
					
					// when value is true, there are 2 or less players.
					if (_count <= 2)
					{
						_data._roomState[_data._room] = 0;
						//_data._roomGameIds[_data._room] = -1; // this gets set at this client event.
						_data._allowSpectators[_data._room] = 0;					
						_roomPlayerCurrentTotal[_data._room] = 0;
						
						// if two or less players, and one player is leaving room, then there is not enought players to play game. set all data to zero for the playing that where playing a game.
						_mysqlDB.saveRoomToZero(_data._room, _data._roomState[_data._room], _data._userLocation, _data._roomPlayerLimit[_data._room]);
						
						_data._userLocation = 0;
					}
					
					else
					{
						_mysqlDB.saveUsernameDataToZero(_data._username);
						
						// if here then the only some data needs to be set back to default.
						_mysqlDB.saveRoomPlayerLimit(_data._username, _data._room, _data._roomPlayerLimit[_data._room]);
					}
					
					_data._room = 0;								
					_data._gameRoom = false;
				}						
				
				else
				{
					// if at waiting room...
					if (_data._userLocation == 2)				
					{
						//if value after minus 1 is greater than 1 then there were more than 1 user at the room, roomState could be 3,4,5 or 6. in this case, minus 1 from roomState.
						_data._roomState[_data._room] -= 1; 
						_roomPlayerCurrentTotal[_data._room] -= 1;
						
						// else if this is true then user has a roomState value of 3, user is the only player in that room. that user roomState will be set to 0 because user is leaving. 
						if (_data._roomState[_data._room] == 1) 
						{						
							_data._roomGameIds[_data._room] = -1;
							_data._roomState[_data._room] = 0;	
						}
						
						// if player has a roomState of 4 and another player left that room, this _mysqlDB will set all roomState for that room to a value of 3.
						_mysqlDB.saveRoomAtRoomData(_data._roomState[_data._room], _data._room);
						
						_data._userLocation = 0;
						_data._room = 0;	
						
						// saves room state to MySQL which is used for online players list.
						_mysqlDB.saveRoomData(_data._username, _data._roomState[_data._room], _data._userLocation, _data._room, _data._roomPlayerLimit[_data._room], _data._roomGameIds[_data._room], _data._vsComputer[_data._room], _data._allowSpectators[_data._room]);
					}
					
				}
				
			}
			
			// at client this value will be set to 0. this is needed so that other players at lobby can set the room button back to empty.
			_data._room = _room;		
			
			// now set these values for user because user is returning to lobby.
			_data._roomState[_data._room] = 0;
			_data._userLocation = 0;
			_data._room = 0;
			
			_mysqlDB.saveUsernameDataToZero(_data._username);
			
			// unlock the room.
			_data._roomLockMessage = "";	
			_mysqlDB.deleteRoomUnlock(_data._username, _room);
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					_server.broadcast("Lesser RoomState Value", _data);
				}
			}
			
		});

	}

	private function isRoomLocked(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Is Room Locked", function(_data, _sender)
		{
			userLogs("Is Room Locked", _data.id, _data._username, _data); // logs.
			
			var _rs = _mysqlDB.selectRoomIslocked(_data._room);
			
			if (_rs._room.length == 0
			||  _data._roomCheckForLock[_data._room] == 0)
			{
				_data._roomLockMessage = "";
				
				// lock the room.
				_mysqlDB.saveRoomLock(_data._username, _data._room);
			}
			
			else _data._roomLockMessage = "Someone beat you to this room. This room is locked until server sends room data to that person.";
			
			//_server.broadcast("Is Room Locked", _data);
			_sender.send("Is Room Locked",_data);
			
		});

	}
	
	/******************************
	* EVENT WAITING ROOM SETS HOST OF THE ROOM.
	* _dataMisc
	*/
	public function isHost(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Is Host", function (_data, _sender)
		{
			// dump the complete _data var.						
			userLogs("Is Host", _data.id, _data._username, _data); // logs. // do not use
		
			if (_data._roomState[_data._room] > 1 && _data._roomState[_data._room] < 8)
			{
				_mysqlDB.saveIsHost(_data._username, _data._gid[_data._room], _data._room);
				_roomHostUsername[_data._room] = _data._username;
				_gid[_data._room] = _data.id;
				_data._triggerEvent = "";
			}
			
			
		});
	}	

	/******************************
	* EVENT SET ROOM DATA. SAVE ROOM DATA TO DATABASE.\
	* _dataMisc
	*/
	private function setRoomData(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Set Room Data", function(_data, _sender)
		{
			userLogs("Set Room Data", _data.id, _data._username, _data); // logs.
			
			if (_data._roomLockMessage == "")
			{
				var room = _data._room;
				
				var _bool = _mysqlDB.countIsHost(_data._room);
				
				if (_bool == false && _data._userLocation == 2) // this value will be changed to 2 later down below. remember, this event plus 1 to userLocation. when entering room, which is true here, then save the host of the room to database.
				{
					_mysqlDB.saveIsHost(_data._username, _data._gid[_data._room], _data._room);
				}
					
				if (_data._roomState[_data._room] > 0 && _data._roomState[_data._room] < 8) _mysqlDB.saveRoomData(_data._username, _data._roomState[_data._room], _data._userLocation, _data._room, _data._roomPlayerLimit[_data._room], _data._roomGameIds[_data._room], _data._vsComputer[_data._room], _data._allowSpectators[_data._room]);
				
				// update this user's online list that has ip, host, roomstate information for this user.
				_mysqlDB.updateLoggedInUser(_data._username, _data._roomState[_data._room]);
							
				// set room values to be used at the "Get Room Data" event at client.
				_roomState[_data._room] = _data._roomState[_data._room];
				_roomGameIds[_data._room] = _data._roomGameIds[_data._room];
				//_vsComputer[_data._room] = _data._vsComputer[_data._room];
				_allowSpectators[_data._room] = _data._allowSpectators[_data._room];
				_roomHostUsername[_data._room] = _data._roomHostUsername[_data._room];
				if (_data._username == _data._roomHostUsername[_data._room])
					_roomPlayerLimit[_data._room] = _data._roomPlayerLimit[_data._room];
				// not host so get room limit from the data that host created.
				else _data._roomPlayerLimit[_data._room] = _roomPlayerLimit[_data._room];
				
				_gid[_data._room] = _data._gid[_data._room];
			}
			
			_sender.send("Set Room Data",_data);
	
		});

	}
		
	/******************************
	* EVENT GET ROOM STATE. LOAD ROOM DATA FROM DATABASE.
	* USED AT LOBBY TO GET ROOM DATA.
	* _dataMisc
	*/
	private function getRoomData(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Get Room Data", function(_data, _sender)
		{
			userLogs("Get Room Data", _data.id, _data._username, _data); // logs.
			
			var _rs = _mysqlDB.selectRoomIslocked(_data._room);
			
			if (_data._roomLockMessage == "")
			{
				// get data from all users online. the data will populate roomState so that everyone at lobby and waiting room will have the correct state of a room.
				var rows = _mysqlDB.selectRoomDataAll();
				
				// next we clear the roomState var to prepare it for the new data.
				_roomState =
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

				_roomPlayerCurrentTotal =
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
				 
				_vsComputer =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
				
				_allowSpectators =
				[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		
				_roomGameIds =
				[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
				 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
				 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
				 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
				 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
				
				_roomHostUsername = 
				["", "", "", "", "", "", "", "", "", "",
				"", "", "", "", "", "", "", "", "", "",
				"", "", "", "", "", "", "", "", "", "",
				"", "", "", "", "", "", "", "", "", "",
				"", "", "", "", "", "", "", "", "", ""];
				
				_gid = 
				["", "", "", "", "", "", "", "", "", "",
				"", "", "", "", "", "", "", "", "", "",
				"", "", "", "", "", "", "", "", "", "",
				"", "", "", "", "", "", "", "", "", "",
				"", "", "", "", "", "", "", "", "", ""];
					
				var _stop = false;
				
				// populate roomState and _roomPlayerCurrentTotal with the correct data.
				// this is the total rows in the mysql database table.
				var _room_number = rows._room.length;
				
				while (_room_number-- > 0)
				{
					// button total is the total rooms at lobby.
					var _room_desc = _button_total;
					
					// search backwards, starting from the last room.
					while (-- _room_desc > 0)
					{
						// count backwards, search for the first occurrence of a room value. for example, if there are 3 players in room then the last player's _roomState value will be compared.
						if (_room_desc == rows._room[_room_number])
						{
							_roomState[_room_desc] = rows._roomState[_room_number];
							
							// set the room limit text for lobby.
							_roomPlayerLimit[_room_desc] = rows._playerLimit[_room_number];
							// set the text of the game currently set to room.
							_roomGameIds[_room_desc] = rows._gameId[_room_number];
							_vsComputer[_room_desc] = rows._vsComputer[_room_number];
							_allowSpectators[_room_desc] = rows._allowSpectators[_room_number];
			
							_stop = true;
							break;
						}
						
						if (_stop == true) break;
					}	
				}
				
				_vsComputer[_data._room] = _data._vsComputer[_data._room];
				
				// get every host of rooms.
				var erows = _mysqlDB.loadIsHost();
				
				for (i in 0...erows._room.length)
				{
					_roomHostUsername[erows._room[i]] = Std.string(erows._user[i]);
					_gid[erows._room[i]] = Std.string(erows._gid[i]);
				}
				
				_data._roomState = _roomState;
				_data._roomGameIds = _roomGameIds;			
				_data._roomPlayerLimit = _roomPlayerLimit;
				_data._vsComputer = _vsComputer;
				_data._allowSpectators = _allowSpectators;
				_data._roomHostUsername = _roomHostUsername;
				_data._gid = _gid;
								
				// get all players in room but not playing a game. the list is used to determine if player can join room.
				var rset = _mysqlDB.selectAllPlayersInRoomButNotPlayingGame();		
				
				// clear list.
				for (i in 0..._roomPlayerCurrentTotal.length)
				{
					_roomPlayerCurrentTotal[i] = 0;
				}
				
				for (i in 0...25) // rooms
				{
					var _count = _mysqlDB.usersPlayingGameCount2(i);
						
					// if playing against the cpu, set the total player in that room to equal _data._roomPlayerLimit var. this is needed since the _mysqlDB.usersPlayingGameCount2 above will only find 1 player in the room.
					if (_data._roomState[i] == 8 && _count == 1) _roomPlayerCurrentTotal[i] = _data._roomPlayerLimit[i];
					else _roomPlayerCurrentTotal[i] = _count;
				}	
				
				_data._roomPlayerCurrentTotal = _roomPlayerCurrentTotal;
				
				var cset = _mysqlDB.selectRoomDataUser(_data._username);
					
				if (Std.string(cset._room[0]) == "0") 
				{
					// player left game so set the isGameFinished var so that player can get an invite.
					_mysqlDB.saveIsGameFinishedUser(_data._username, true, false);
				}
				
				
			}
			
			/*
			//---------------- these cpu bots will host room a and b when there are no players in those rooms.
			// signature game - 2 players.
			_data._roomState[1] = _roomState[1] = 2;
			_data._roomGameIds[1] = _roomGameIds[1] = 4;
			_data._roomPlayerLimit[1] = _roomPlayerLimit[1] = 2;
			_data._vsComputer[1] = _vsComputer[1] = 1;
			_data._allowSpectators[1] = _allowSpectators[1] = 0;
			_data._roomHostUsername[1] = _roomHostUsername[1] = Reg._cpu_host_name1;
			_data._roomPlayerCurrentTotal[1] = 1;
			
			// chess.
			_data._roomState[2] = _roomState[2] = 2;	
			_data._roomGameIds[2] = _roomGameIds[2] = 1;
			_data._roomPlayerLimit[2] = _roomPlayerLimit[2] = 2;
			_data._vsComputer[2] = _vsComputer[2] = 1;
			_data._allowSpectators[2] = _allowSpectators[2] = 0;
			_data._roomHostUsername[2] = _roomHostUsername[2] = Reg._cpu_host_name2;
			_data._roomPlayerCurrentTotal[2] = 1;
			*/
			
			_sender.send("Get Room Data", _data);
			
		});

	}
	
	/******************************
	* EVENT ROOM LOCK 1.
	* USED AT LOBBY TO DELAY THE SECOND PLAYER FROM ENTERING INTO THE ROOM UNTIL THE ROOM LOCK IS REMOVED FROM THAT ROOM. THIS EVENT ONLY SENDS _data TO CLIENT. AT THAT CLIENT A VAR IS TRIGGERED TO UPDATE THE ROOMS TEXT AND THEN CLIENT SENDS TO ROOM LOCK 2 THEN THAT EVENT AT SERVER REMOVES THE LOCK.
	* _dataMisc
	*/
	private function roomLock1(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Room Lock 1", function(_data, _sender)
		{
			_server.broadcast("Room Lock 1",_data);
		});

	}	
	
	/******************************
	* EVENT ROOM LOCK 1.
	* THIS EVENT ONLY REMOVES THE ROOM LOCK.
	* _dataMisc
	*/
	private function roomLock2(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Room Lock 2", function(_data, _sender)
		{
			_data._roomLockMessage = "";
			
			// unlock the room.
			_mysqlDB.deleteRoomUnlock(_data._username, _data._room);
		});

	}
	
	/******************************
	* EVENT GET ROOM PLAYERS
	*/
	private function getRoomPlayers(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Get Room Players", function(_data, _sender)
		{	
			userLogs("Get Room Players", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Get Room Players", _data);
				}
			}
			
		});

	}

	/******************************
	* EVENT CHAT.
	* chat message of the player.
	* _dataMisc
	*/
	private function chatSend(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Chat Send", function(_data, _sender)
		{
			userLogs("Chat Send", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Chat Send", _data);
				}
			}
			
		});

	}

	/******************************
	* EVENT DRAW OFFER
	* offer draw so that no one wins and loses a game. its a tie.
	*/
	private function drawOffer(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Draw Offer", function(_data, _sender)
		{
			userLogs("Draw Offer", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Draw Offer", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT DRAW ANSWERED AS
	* reply to the offer draw so that no one wins and loses a game. its a tie.
	*/
	private function drawAnsweredAs(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Draw Answered As", function(_data, _sender)
		{
			userLogs("Draw Answered As", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Draw Answered As", _data);
				}
			}
			
		});

	}

	/******************************
	* EVENT RESTART OFFER.
	* offer to restart and play another game.
	*/
	private function restartOffer(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Restart Offer", function(_data, _sender)
		{
			userLogs("Restart Offer", _data.id, _data._username, _data); // logs.

			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Restart Offer", _data);
				}
			}
			
		});

	}

	/******************************
	* EVENT RESTART ANSWERED AS
	* reply to the restart a chess game offer so that another game can be played.
	*/
	private function restartAnsweredAs(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Restart Answered As", function(_data, _sender)
		{
			userLogs("Restart Answered As", _data.id, _data._username, _data); // logs.
			
			if (_data._restartGameAnsweredAs == true)
			{
				var _isGameFinished:Bool = false;
				var _is_spectator_watching:Bool = _data._spectatorWatching;
				
				_mysqlDB.saveIsGameFinished(_data._room, _isGameFinished, _is_spectator_watching);
			}
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Restart Answered As", _data);
				}
			}

		});

	}
	
	/******************************
	* EVENT 
	* currently this event is for the signature game. a player sends a trade unit to another player and this event is for that other player receiving the trade.
	*/
	private function tradeProposalOffer(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Trade Proposal Offer", function(_data, _sender)
		{
			userLogs("Trade Proposal Offer", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Trade Proposal Offer", _data);
				}
			}
			
		});

	}
	
	/******************************
	* EVENT 
	* currently this event is for the signature game. replied to the trade request.
	*/
	private function tradeProposalAnsweredAs(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Trade Proposal Answered As", function(_data, _sender)
		{
			userLogs("Trade Proposal Answered As", _data.id, _data._username, _data); // logs.
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Trade Proposal Answered As", _data);
				}
			}
			
		});

	}
	
	/******************************
	* EVENT ONLINE PLAYER OFFER INVITE.
	* offer an invite to a player at the lobby.
	*/
	public function OnlinePlayerOfferInvite(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Online Player Offer Invite", function(_data, _sender)
		{
			userLogs("Online Player Offer Invite", _data.id, _data._username, _data); // logs.
			
			_server.broadcast("Online Player Offer Invite",_data);
		});
	}
	
	/******************************
	* EVENT GAME MESSAGE. NOT A MESSAGE BOX.
	*/
	private function gameMessageNotSender(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Game Message Not Sender", function(_data, _sender)
		{
			userLogs("Game Message Not Sender", _data.id, _data._username, _data); // logs

			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Game Message Not Sender", _data);
				}
			}
			
		});

	}
	
	/******************************
	* A MESSAGE BOX MESSSGE SENT To ALL SPECTATORS WATCHING NOT SPECTATORs PLAYING.
	*/
	private function gameMessageBoxForSpectatorWatching(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Game Message Box For Spectator Watching", function(_data, _sender)
		{
			userLogs("Game Message Box For Spectator Watching", _data.id, _data._username, _data); // logs

			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					_sender.send("Game Message Box For Spectator Watching", _data);
				}
			}
			
		});

	}

	/******************************
	* EVENT MESSAGE KICK
	* kick: player cannot play for a while because admin kicked player.
	*/
	private function messageKick(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Message Kick", function(_data, _sender)
		{
			userLogs("Message Kick", _data.id, _data._username, _data); // logs // do not use.
			
			var _user:String = "";
			var _message:String = "";
			var _minutesTotal:String = "";
			var _timestamp:String = "";
			
			var rset = _mysqlDB.select120KickedUsers();

			if (rset._user.length > 0)
			{
				for ( i in 0...rset._user.length)
				{
					// populate all data from the mysql table. separate each element in these strings with a comma. later, the populated data will be added to arrays. if kicked time is remaining then those data will be passed to the client and the client will determine if a kicked message should be displayed.
					_user = _user + rset._user[i] + ",";
					_message = _message + rset._message[i] + ",";
					_minutesTotal = _minutesTotal + rset._minutesTotal[i] + ",";
					_timestamp = _timestamp + rset._timestamp[i] + ",";
						
				}

				// get the current time.
				var _currentTime = Std.int(Sys.time());

				var paragraph:Array<String> = _user.split(","); // cut each username data at comma.
				var paragraph2:Array<String> = _message.split(","); // cut _clientCommandMessage data at comma.
				var paragraph4:Array<String> = _minutesTotal.split(","); // total minutes when kicked.
				var paragraph5:Array<String> = _timestamp.split(","); // cut user timestamps data at comma.


				var _timeRemaining:Array<Int> = [ for (i in 0...120) 0];

				// populate the data to be sent to client.
				for (i in 0...120)
				{
					if (paragraph5[i+1] != null) // this line is needed to address bug.
					{
						// how much time in seconds is remaining in current timestamp minus users timestamp. convert to minutes.
						var _timeMinus:Int = _currentTime - Std.parseInt(paragraph5[i]);
						_timeMinus = Std.int(_timeMinus / 60);
					
						var _currentTimeRemaining:Int = Std.parseInt(paragraph4[i]) - _timeMinus;
						// change the time at _clientCommandMessage.
						paragraph2[i] = StringTools.replace(paragraph2[i], paragraph4[i], Std.string(_currentTimeRemaining));

						// next time remaining needs to be changed to the new time.
						paragraph4[i] = Std.string(_currentTimeRemaining);
						
					}
				}

				var _text:String = "";
				var _text2:String = "";
				var _text3:String = "";
				var _text4:String = "";
				var _text5:String = "";

				// remove user from all kicked files when time remaining less or equal zero.
				for (i in 0...paragraph.length) // populate _text var with the new paragraph data.
				{
					if (paragraph[i] != "" && Std.parseInt(paragraph4[i]) >0)
					{
						_text = _text + paragraph[i] + ",";		// _clientCommand users.
						_text2 = _text2 + paragraph2[i] + ",";	// _clientCommand messages.
							
					}
				}

				if (_text  != "") _data._clientCommandUsers = _text;
				if (_text2 != "") _data._clientCommandMessage = _text2;

				if (_text != "" && _text2 != "")
				{
					_sender.putInRoom(room[0]);
					room[0].broadcast("Message Kick", _data);
				}
			}
			
			
		});

	}

	
	private function removeKickedFromUser(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Remove Kicked From User", function(_data, _sender)
		{
			userLogs("Remove Kicked From User", _data.id, _data._username, _data); // logs
			
			_mysqlDB.updateUsersKickedData(_data._username);
		});

	}
	
	/******************************
	* EVENT MESSAGE BAN
	* ban: admin stopped player from playing forever.
	*/
	private function messageBan(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Message Ban", function(_data, _sender)
		{
			// TODO uncomment this. it is commented to see if the type command outputs when error at server console happens.
			//userLogs("Message Ban", _data.id, _data._username, _data); // logs
			
			var _user:String = "";
			var _message:String = "";
			var _ip:String = "";
			
			var rset = _mysqlDB.select120BannedUsers();
			
			if (rset._user.length > 0)
			{
				for ( i in 0...rset._user.length)
				{
					// populate all data from the mysql table. separate each element in these strings with a comma. later, the populated data will be added to arrays. 
					_user = _user + rset._user[i] + ",";
					_message = _message + rset._message[i] + ",";
					_ip = _ip + rset._ip[i] + ",";
				}

				// pass banned data to client. at that time, if user is banned then client will display the banned message.
				_data._username = _user;
				_data._clientCommandMessage = _message;
				_data._clientCommandIPs = _ip;
								
				if (_message != "")
				{
					_sender.putInRoom(room[0]);
					room[0].broadcast("Message Ban", _data);
				}
			}

		});

	}

	/******************************
	* EVENT GAME ROOM
	* this event enters the game room.
	* _dataMisc
	*/
	public function enterGameRoom(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Enter Game Room", function (_data, _sender)
		{
			userLogs("Enter Game Room", _data.id, _data._username, _data); // logs
			
			var _isGameFinished:Bool = true;
			var _is_spectator_watching:Bool = _data._spectatorWatching;
				
			_mysqlDB.saveIsGameFinished(_data._room, _isGameFinished, _is_spectator_watching);
				
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Enter Game Room", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT GAME WIN
	* this player wins the game.
	* _dataPlayers
	*/
	public function gameWin(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Game Win", function (_data, _sender)
		{
			userLogs("Game Win", _data.id, _data._username, _data); // logs
			
			_sender.send("Game Win",_data);
			
		});
	}

	/******************************
	* EVENT GAME LOSE
	* this player loses the game.
	* _dataPlayers
	*/
	public function gameLose(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		// at server, do not use "_sender.send" because more than one player can lose game.
		_server.events.on("Game Lose", function (_data, _sender)
		{
			userLogs("Game Lose", _data.id, _data._username, _data); // logs
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Game Lose", _data);
				}
			}
			
		});
	}
	
	/******************************
	* EVENT GAME WIN
	* this player wins the game.
	* _dataPlayers
	*/
	public function gameWinThenLoseForOther(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Game Win Then Lose For Other", function (_data, _sender)
		{
			userLogs("Game Win Then Lose For Other", _data.id, _data._username, _data); // logs
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Game Win Then Lose For Other", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT GAME LOSE
	* this player loses the game.
	* _dataPlayers
	*/
	public function gameLoseThenWinForOther(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Game Lose Then Win For Other", function (_data, _sender)
		{
			userLogs("Game Lose Then Win For Other", _data.id, _data._username, _data); // logs
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Game Lose Then Win For Other", _data);
				}
			}
			
		});
	}
	
	/******************************
	* EVENT GAME DRAW
	* this game ends in a tie.
	* _dataPlayers
	*/
	public function gameDraw(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		// at server, do not use "_sender.send" because more than one player can be in a draw.
		_server.events.on("Game Draw", function (_data, _sender)
		{
			userLogs("Game Draw", _data.id, _data._username, _data); // logs
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Game Draw", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT SAVE WIN STATS
	* save the win stats of the player that was sent here and then return that value to the cilent.
	* _dataPlayers
	*/
	public function saveWinStats(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Save Win Stats", function (_data, _sender)
		{
			userLogs("Save Win Stats", _data.id, _data._username, _data); // logs
			
			var _isGameFinished:Bool = true;
			var _is_spectator_watching:Bool = _data._spectatorWatching;
				
			_mysqlDB.saveIsGameFinished(_data._room, _isGameFinished, _is_spectator_watching);
			// _playersState.
			// put those stats into the _data to send to client.
			if (_data._spectatorWatching == false)
			{
				for (i in 0...4)
				{
					if (_data._username == _data._usernamesStatic[i] 
					&&  _data._gamePlayersValues[i] == 1
					&&  _data._spectatorPlaying == false
					||  _data._username == _data._usernamesStatic[i]
					&&  _data._gamePlayersValues[i] == 1
					&&  _vsComputer[_data._room] == 1)
					{
						_data._gamesAllTotalWins[i] += 1;
											
						// this is the time that the player played for. This var is passed to mysql so that the shortest_time_game_played and longest_time_game_played stats can be saved but only if conditions are met.
						var _game_time_played_in_seconds = _data._timeTotal - _data._moveTimeRemaining[i]; 	
						
						// send that username to mysql to save the stats.
						_mysqlDB.saveWinStats(_data._gameId, _data._username, _game_time_played_in_seconds); 
						_mysqlDB.saveGamePlayer(_data._username, 0);
						
						// this checks if there is an event to give on this day.
						// see the doEvent() function. 
						eventsWin(_data, _data._username);
						
						_vsComputer[_data._room] = 0;
						
					} 
				}
			}
			
			player_game_state_value_update(_data);
			_sender.send("Save Win Stats",_data);

		});
	}

	/******************************
	* EVENT SAVE LOSE STATS
	* save the lose stats of the player that was sent here and then return that value to the cilent.
	* _dataPlayers
	*/
	public function saveLoseStats(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Save Lose Stats", function (_data, _sender)
		{
			userLogs("Save lose Stats", _data.id, _data._username, _data); // logs
			
			_mysqlDB.saveIsGameFinishedUser(_data._username, true, _data._spectatorWatching);
			 
			if (_data._spectatorWatching == false)
			{
				var user:String = _data._username;

				// put those stats into the _data to send to client.
				for (i in 0...4)
				{
					if (_data._username == _data._usernamesDynamic[i]
					&&  _data._spectatorPlaying == false
					||  _data._username == _data._usernamesDynamic[i]
					&&  _vsComputer[_data._room] == 1)
					{			
						_data._gamesAllTotalLosses[i] += 1;
						
						// this is the time that the player played for. This var is passed to mysql so that the shortest_time_game_played and longest_time_game_played stats can be saved but only if conditions are met.
						var _game_time_played_in_seconds = _data._timeTotal - _data._moveTimeRemaining[i]; 	
						
						// send that username to mysql to get the stats.
						_mysqlDB.saveLoseStats(_data._gameId, _data._username, _game_time_played_in_seconds);
						_mysqlDB.saveGamePlayer(_data._username, 0);
											
						// this checks if there is an event to give on this day.
						// see the doEvent() function.
						eventsLose(_data, _data._username);
						
						_vsComputer[_data._room] = 0;
					} 
				}
			}
			
			player_game_state_value_update(_data);
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Save Lose Stats", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT SAVE WIN STATS
	* save the win stats of the player that was sent here and then return that value to the cilent.
	* only a 2 player game should use this event.
	* _dataPlayers
	*/
	public function saveWinStatsForBoth(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Save Win Stats For Both", function (_data, _sender)
		{
			userLogs("Save Win Stats For Both", _data.id, _data._username, _data); // logs 
			
			// _playersState.
			// put those stats into the _data to send to client.
			if (_data._spectatorWatching == false)
			{
				for (i in 0...4)
				{
					if (_data._username == _data._usernamesStatic[i])
					{
						_data._gamesAllTotalWins[i] += 1;
						
						// this is the time that the player played for. This var is passed to mysql so that the shortest_time_game_played and longest_time_game_played stats can be saved but only if conditions are met.
						var _game_time_played_in_seconds = _data._timeTotal - _data._moveTimeRemaining[i]; 	
						
						_mysqlDB.saveWinStats(_data._gameId, _data._usernamesStatic[i], _game_time_played_in_seconds);
						_mysqlDB.saveGamePlayer(_data._username, 0);					
						_vsComputer[_data._room] = 0;
						
						_data._username = _data._usernamesStatic[i];
						eventsWin(_data, _data._usernamesStatic[i]);
					} 
				}
			}
			
			var _stop:Bool = false;
			
			// player lost game.
			if (_data._spectatorWatching == false)
			{	
				for (i in 0...4)
				{
					if (_data._username != _data._usernamesStatic[i])
					{
						if (_data._gamePlayersValues[i] == 1
						||  _data._gamePlayersValues[i] == 2
						||  _data._gamePlayersValues[i] == 4)
						{					
							_data._gamesAllTotalLosses[i] += 1;
							
							var _game_time_played_in_seconds = _data._timeTotal - _data._moveTimeRemaining[i]; 	
							
							// send that username to mysql to get the stats.
							_mysqlDB.saveLoseStats(_data._gameId, _data._usernamesStatic[i], _game_time_played_in_seconds);
							_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], 0);
							
							_vsComputer[_data._room] = 0;
							
							eventsLose(_data, _data._usernamesStatic[i]);
							
							_stop = true;
						}
						
						if (_stop == true) break;
					}
				}
			}
			
			player_game_state_value_update(_data);
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Save Win Stats For Both", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT SAVE LOSE STATS
	* save the lose stats of the player that was sent here and then return that value to the cilent.
	* only a 2 player game should use this event.
	* playersData.
	*/
	public function saveLoseStatsForBoth(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Save Lose Stats For Both", function (_data, _sender)
		{
			userLogs("Save Lose Stats For Both", _data.id, _data._username, _data); // logs
			// those are used to load, save and calculate the chess elo ratings on this game that ended.
			var _p1_username = "";
			var _p2_username = "";
			
			// the value of this chess elo var is populated from the data
			var _p1_chess_elo_rating:Float = 0;
			var _p2_chess_elo_rating:Float = 0;
			
			var _isGameFinished:Bool = true;
			var _is_spectator_watching:Bool = _data._spectatorWatching;
				
			_mysqlDB.saveIsGameFinished(_data._room, _isGameFinished, _is_spectator_watching);
				
			// _playersState.
			if (_data._spectatorWatching == false)
			{
				// put those stats into the _data to send to client.
				for (i in 0...4)
				{
					if (_data._username == _data._usernamesStatic[i])
					{
						_data._gamesAllTotalLosses[i] += 1;
						
						// this is the time that the player played for. This var is passed to mysql so that the shortest_time_game_played and longest_time_game_played stats can be saved but only if conditions are met.
						var _game_time_played_in_seconds = _data._timeTotal - _data._moveTimeRemaining[i]; 	
						
						_mysqlDB.saveLoseStats(_data._gameId, _data._username, _game_time_played_in_seconds);
						_mysqlDB.saveGamePlayer(_data._username, 0);
						
						_vsComputer[_data._room] = 0;
						
						eventsLose(_data, _data._username);
						
						// load the elo rating for player whom lost the game of chess.
						if (_data._gameId == 1)
						{
							_p2_username = _data._username;
							
							var rset = _mysqlDB.selectUserEloRating(_p2_username);
							_p2_chess_elo_rating = rset._chess_elo_rating[0];
						}
						
					} 
				}
			}
			
			var _stop:Bool = false;
			
			// player won game.
			if (_data._spectatorWatching == false)
			{
				for (i in 0...4)
				{
					// do not use _data._username instead of _data._usernamesStatic[i] in this code block because you will have two of the same user saving to two different accounts!
					if (_data._username != _data._usernamesStatic[i])
					{
						if (_data._gamePlayersValues[i] == 1
						||  _data._gamePlayersValues[i] == 2
						||  _data._gamePlayersValues[i] == 4)
						{					
							_data._gamesAllTotalWins[i] += 1;
							
							var _game_time_played_in_seconds = _data._timeTotal - _data._moveTimeRemaining[i]; 
							
							// send that username to mysql to get the stats.
							_mysqlDB.saveWinStats(_data._gameId, _data._usernamesStatic[i], _game_time_played_in_seconds);
							_mysqlDB.saveGamePlayer(_data._usernamesStaic[i], 0);
							
							_vsComputer[_data._room] = 0;
							
							eventsWin(_data, _data._usernamesStatic[i]);
							
							// load the elo rating for player whom lost the game of chess.
							if (_data._gameId == 1)
							{
								_p1_username = _data._usernamesStatic[i];
								
								var rset = _mysqlDB.selectUserEloRating(_p1_username);
								_p1_chess_elo_rating = rset._chess_elo_rating[0];
								
							}
							
							_stop = true;
						}
						
						if (_stop == true) break;
					}
				}
			}
			
			// Chess ELO rating.
			if (_data._spectatorWatching == false)
			{
				if (_data._gameId == 1)
				{
					// lowest posiiable elo rating is 100.
					if (_p1_chess_elo_rating < 100)
						_p1_chess_elo_rating = 100;
						
					if (_p2_chess_elo_rating < 100)
						_p2_chess_elo_rating = 100;
					
					// save the chess elo rating for each player at this function but first calculate the new elo values.
					EloRating(_p1_username, _p2_username, _p1_chess_elo_rating, _p2_chess_elo_rating, _chess_elo_k, _chess_did_player1_win);				
				}
			}
			
			player_game_state_value_update(_data);
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Save Lose Stats For Both", _data);
				}
			}

				
		});
	}

	/******************************
	* EVENT SAVE DRAW STATS
	* save the draw stats of the player that was sent here and then return that value to the cilent.
	* _dataPlayers
	*/
	public function saveDrawStats(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Save Draw Stats", function (_data, _sender)
		{
			userLogs("Save Draw Stats", _data.id, _data._username, _data); // logs
			
			var _isGameFinished:Bool = true;
			var _is_spectator_watching:Bool = _data._spectatorWatching;
				
			_mysqlDB.saveIsGameFinished(_data._room, _isGameFinished, _is_spectator_watching);
				
			if (_data._spectatorWatching == false)
			{
				for (i in 0...4)
				{
					if (_data._usernamesDynamic[i] != ""
					&&  _data._username == _data._usernamesDynamic[i])
					{
						_data._gamesAllTotalDraws[i] += 1;
						// send that username to mysql to get the stats.
						_mysqlDB.saveDrawStats(_data._gameId, _data._username);
						_mysqlDB.saveGamePlayer(_data._username, 0);
						
						_vsComputer[_data._room] = 0;
					}
				}
			}
			
			player_game_state_value_update(_data);
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Save Draw Stats", _data);
				}
			}
			
		});
	}
	
	/******************************
	* EVENT GET TOURNAMENT
	* gets the selected tournament data.
	* _dataTournaments
	*/
	public function tournamentChessStandard8Get(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Tournament Chess Standard 8 Get", function (_data, _sender)
		{
			userLogs("Tournament Chess Standard 8 Get", _data.id, _data._username, _data); // logs
		
			var rset = _mysqlDB.select_tournament_chess_standard_8(_data._username, 1);
			//############################# TOURNAMENT CHESS STANDARD 8.
			
			// set this to empty in case another tournament data was read before this one because we need to know if a user exists in this mysql table,
			_data._player1 = "";
			if (rset._user[0] != null) 
			{
				_data._player1 = Std.string(rset._user[0]);
				_data._player2 = Std.string(rset._user2[0]);
				_data._gid = Std.string(rset._gid[0]);
				
				_data._round_current = Std.parseInt(Std.string(rset._round_current[0]));
				_data._rounds_total = Std.parseInt(Std.string(rset._rounds_total[0]));
				_data._move_total = Std.parseInt(Std.string(rset._move_total[0]));
				_data._won_game = Std.parseInt(Std.string(rset._won_game[0]));
				var _tournament_started = Std.parseInt(Std.string(rset._tournament_started[0]));
				if (_tournament_started == 0) _data._tournament_started = false;
				else _data._tournament_started = true;
				
				var _move_piece = Std.parseInt(Std.string(rset._move_piece[0]));
				if (_move_piece == 0) _data._move_piece = false;
				else _data._move_piece = true;
				
				_data._time_remaining_player1 = Std.string(rset._time_remaining_player1[0]);
				_data._time_remaining_player2 = Std.string(rset._time_remaining_player2[0]);
				
				_data._move_number_current = Std.int(rset._move_number_current[0]);
				_data._timestamp = Std.parseInt(Std.string(rset._timestamp[0]));
				_data._game_over = Std.parseInt(Std.string(rset._isGameFinished[0]));
			}
			
			// player not found so set this to empty.
			else _data._gid = "";
			
			var rset2 = _mysqlDB.select_tournament_data();
			
			if (rset2._player_maximum[0] != null)
				_data._player_maximum = rset2._player_maximum[0];
						
			// get current count of players in tournament chess standard 8.
			var _count = _mysqlDB.select_tournament_chess_standard_8_count();
			
			_data._player_current = _count;
			
			//##############################
			
			_sender.send("Tournament Chess Standard 8 Get", _data);
		});
	}
	
	/******************************
	* EVENT GET TOURNAMENT
	* puts the selected tournament data to the mysql database.
	* _dataTournaments
	*/
	public function tournamentChessStandard8Put(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Tournament Chess Standard 8 Put", function (_data, _sender)
		{
			userLogs("Tournament Chess Standard 8 Put", _data.id, _data._username, _data); // logs
			
			_mysqlDB.update_tournament_chess_standard_8(_data._player1, _data._player2, _data._time_remaining_player1, _data._time_remaining_player2, _data._move_number_current);
	
			// if game over, from a checkmate or lost a game from time running out or something, end game for both players.
			if (_data._game_over == 1) 
			{
				if (_data._won_game == 1)
					_mysqlDB.update_tournament_chess_standard_8_game_over(_data._player1, _data._player2, 1, 0); // 1:player1 0:player2. the 1 means a win and 0 is a lose.
				else 
					_mysqlDB.update_tournament_chess_standard_8_game_over(_data._player1, _data._player2, 0, 1);
			}
	
			_sender.send("Tournament Chess Standard 8 Put", _data);
		});
	}
	

	/******************************
	* EVENT PLAYER LEFT GAME
	* Trigger an event that the player has left the game and then do stuff such as stop the ability to move piece. Note that the player may still be at the game room, waiting for another game to play.
	* _dataPlayers
	*/
	public function playerLeftGameRoom(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Player Left Game Room", function (_data, _sender)
		{
			userLogs("Player Left Game Room", _data.id, _data._username, _data); // logs
			
			// save the player's game player state to the database. is the player playing a game or waiting to play.
			for (i in 0...4)
			{
				if (_data._username == _data._usernamesStatic[i] && _data._usernamesStatic[i] != "")
				{
					_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
				}
			
				else
				{
					if (_data._gamePlayersValues[i] == 0)
					{
						_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
					}
				}
			}
			
			/*
			for (i in 0...4)
			{
				if (_data._username == _data._usernamesStatic[i] && _data._usernamesStatic[i] != "")
				{
					_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
				}
			
				else
				{
					if (_data._gamePlayersValues[i] == 0)
					{
						_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
					}
				}
			}
			
			
			// get game playing data from database for the other players in that game room.
			for (i in 0...4)
			{
				if (_data._usernamesStatic[i] != "" && _data._username != _data._usernamesStatic[i])
				{
					var rset = _mysqlDB.getGamePlayer(_data._usernamesStatic[i]);
					
					var _type:Int = rset._gamePlayersValues[0];
					if (_data._gamePlayersValues[i] != 0) _data._gamePlayersValues[i] = _type;
				}
			}
			*/
			
			player_game_state_value_update(_data);
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Player Left Game Room", _data);
				}
			}
			
		});
	}

	/*************************************************************************
	 * this event is called when playing a game and player ran out of time or quit game.
	 */
	public function playerLeftGame(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Player Left Game", function (_data, _sender)
		{
			userLogs("Player Left Game", _data.id, _data._username, _data); // logs
			
			// save the player's game player state to the database. is the player playing a game or waiting to play.
			
			for (i in 0...4)
			{
				if (_data._username == _data._usernamesStatic[i] && _data._usernamesStatic[i] != "")
				{
					_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
				}
			
				else
				{
					if (_data._gamePlayersValues[i] == 0)
					{
						_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
					}
				}
			}
			/*
			// get game playing data from database for the other players in that game room.
			for (i in 0...4)
			{
				if (_data._usernamesStatic[i] != "" && _data._username != _data._usernamesStatic[i])
				{
					var rset = _mysqlDB.getGamePlayer(_data._usernamesStatic[i]);
					
					var _type:Int = rset._gamePlayersValues[0];
					if (_data._gamePlayersValues[i] != 0) _data._gamePlayersValues[i] = _type;
				}
			}
			*/
			
			player_game_state_value_update(_data);
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Player Left Game", _data);
				}
			}
			
		});
	}

	/******************************
	* EVENT LOGGED IN USERS
	* list of online players with stats. used to invite.
	*/
	public function loggedInUsers(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Logged In Users", function (_data, _sender)
		{
			userLogs("Logged In Users", _data.id, _data._username, _data); // logs // do not use
			
			_onlinePlayersState = allDataOnlinePlayers.get(_sender); // INVALED FIELD ACCESS ERROR WITHOUT THIS LINE.

			for (i in 0...121)
			{
				// clear list so that old data will not be displayed. a user may not be online since last update.
				_onlinePlayersUsernames[i] = "";
				_onlinePlayersGameWins[i] = 0;
				_onlinePlayersGameLosses[i] = 0;
				_onlinePlayersGameDraws[i] = 0;
				_online_all_elo_ratings[i] = 0;
				
				_data._chess_elo_rating[i] = Std.parseFloat(Std.string(_data._chess_elo_rating[i]));
			}

			var _user:Array<String> = [];
			var rset = _mysqlDB.selectRoomDataIsGameFinished(); // get all current logged in users.

			for ( i in 0...rset._user.length)
			{
				// put all current users in array elements.
				_user[i] = Std.string(rset._user[i]);
			}

			var _count:Int = -1;

			// if found a user then length is not zero.
			if (_user.length > 0)
			{
				for ( i in 0..._user.length)
				{
					// get the data for this user,
					var rset3 = _mysqlDB.selectRoomDataUser(_user[i]);

					if (Std.string(rset3._roomState[0]) == "0" && Std.string(rset3._userLocation[0]) == "0")
					{
						// send that username to mysql to get the stats.
						var rset2 = _mysqlDB.getStatsWinLoseDrawFromUsers(_user[i]);

						_count += 1; // used to push thru array elements.

						// put stats into an array.
						// these vars was declared at this file.
						_onlinePlayersUsernames[_count] = _user[i];
						_onlinePlayersGameWins[_count] = rset2._gamesAllTotalWins[0];
						_onlinePlayersGameLosses[_count] = rset2._gamesAllTotalLosses[0];
						_onlinePlayersGameDraws[_count] = rset2._gamesAllTotalDraws[0];
						_online_all_elo_ratings[_count] = rset2._chess_elo_rating[0];

					}

				}
			}

			if (_count == -1) // no data. create data to avoid a client crash.
			{
				_onlinePlayersUsernames[0] = "";
				_onlinePlayersGameWins[0] = 0;
				_onlinePlayersGameLosses[0] = 0;
				_onlinePlayersGameDraws[0] = 0;
				_data._chess_elo_rating[0] = 0;
			}

			// Populate the tyoedef var.
			_data._usernamesOnline = _onlinePlayersUsernames;
			_data._gamesAllTotalWins = _onlinePlayersGameWins;
			_data._gamesAllTotalLosses = _onlinePlayersGameLosses;
			_data._gamesAllTotalDraws = _onlinePlayersGameDraws;
			_data._chess_elo_rating = _online_all_elo_ratings;
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Logged In Users", _data);
				}
			}

		});
	}

	/******************************
	* EVENT ACTION BY PLAYER.
	* this is where player can kick, ban other players.
	* dataPlayers
	*/
	public function actionByPlayer(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Action By Player", function (_data, _sender)
		{
			userLogs("Action By Player", _data.id, _data._username, _data); // logs
			
			// if there was not anything to update then there is no row that exists if this returns false.
			var rset = _mysqlDB.usersSetActionCount(_data._username, _data._actionWho);
	
			// if there was no update, row returned false, then insert it. create a new entry into the database.
			if (rset == false) _mysqlDB.usersSetActionInsert(_data._username, _data._actionWho, _data._actionNumber);

			
			//_sender.send("Action By Player",_data);
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Action By Player", _data);
				}
			}
			
		});
	}
	
	/******************************
	* EVENT IS ACTION NEEDED FOR PLAYER.
	* do action for player event to kick, ban other players.
	*/
	public function isActionNeededForPlayer(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Is Action Needed For Player", function (_data, _sender)
		{
			userLogs("Is Action Needed For Player", _data.id, _data._username, _data); // logs.
			
			var _minutesTotal:Int = 0;
			var _timestamp:String = "";

			// not host and there is more than 1 player in room.
			if (_data._username != _data._usernamesDynamic[0])
			{
				var rset = _mysqlDB.isThereUserAction(_data._usernamesDynamic[0], _data._username);
				
				if (rset._actionWho[0] != null)
				{	
					_minutesTotal = rset._minutesTotal[0];

					// get the current time.
					var _currentTime:Int = Std.int(Sys.time());

					var _timeRemaining:Int = 0;
					
					// populate the data to be sent to client.
					// how much time in seconds is remaining in current timestamp minus users timestamp. convert to minutes.
					var _timeMinus:Int = _currentTime - Std.parseInt(rset._timestamp[0]);
					
					_timeMinus = Std.int(_timeMinus / 60);

					var _currentTimeRemaining:Int = _minutesTotal - _timeMinus;

					// a value of 100 is a ban to the user. see this event at client.
					if (_data._actionNumber == 2)
					{
						_data._actionDo = 100;
					}
					
					if (_data._username != "" && _currentTimeRemaining > 0 && _data._actionDo != 100)
					{
						_data._actionDo = _currentTimeRemaining;
					}
										
					if (_currentTimeRemaining < 1 && _data._actionDo != 100)
					{
						_mysqlDB.deleteUserAction(_data._usernamesDynamic[0], _data._username);
						
						_data._actionDo = -1;
						_data._actionNumber = 0;
						_data._actionWho = "";
					}
					
					else 
					{
						_data._actionNumber = Std.parseInt(rset._actionNumber[0]);
						_data._actionWho = Std.string( rset._actionWho[0]);
					}
				}
				
			} 
		
			if (_data._actionDo == -1) _data._actionNumber = 0; //return;
			
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Is Action Needed For Player", _data);
				}
			}
			
			//_server.broadcast("Is Action Needed For Player", _data);
		});
	}
	
	/*************************************************************************
	* EVENT GAME PLAYERS VALUE.
	* save the player's game player state to the database. is the player playing a game or waiting to play. else, if _spectatorWatching when load _gamePlayersValues for this player because the player might be entering the room from clicking the "watch game" button.
	* 0 = not playing but still at game room. 
	* 1 playing a game. 
	* 2: left game room while still playing it. 
	* 3 left game or game room when game was over. 
	* this var is used to display players who are waiting for a game at the game room and to get the _count of how many players are waiting at game room.
	* _dataPlayers
	*/
	public function gamePlayersValues(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Game Players Values", function (_data, _sender)
		{
			userLogs("Game Players Values", _data.id, _data._username, _data); // logs
		
			// if spectator watching then populate _gamePlayersValues typedef.
			if (_data._spectatorWatching == true)
			{
				for (i in 0...4)
				{
					if (Std.string(_data._usernamesStatic[i]) != "")
					{
						var rset4 = _mysqlDB.getGamePlayer(_data._usernamesStatic[i]);
						
						_data._gamePlayersValues[i] = rset4._gamePlayersValues[0]; 			
					}
				}
			}
			
			// save for player playing game, else load value of other players in room for this player.
			else
			{
				// the reason why we update the spectator playing var here is because this event is first sent since entering the game room by the client when a game starts.
				_mysqlDB.saveSpectator(_data._username, _data._spectatorPlaying);
			
				for (i in 0...4)
				{
					if (_data._usernamesStatic[i] != "")
						_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
					else _data._gamePlayersValues[i] = 0;
				}
				
				/*for (i in 0...4)
				{
					if (_data._gamePlayersValues.length - 1 < i) _data._gamePlayersValues[i] = 0;
					
					if (_data._username == _data._usernamesStatic[i] && _data._usernamesStatic[i] != "")
					{
						// entering game room so do not save these values.
						if (_data._triggerEvent != "foo") 
							_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
					}
					
					else if (_data._gamePlayersValues[i] == 0)
					{
						// load values if player is not entering game room and the array is not null.
						var rowList = 
						_mysqlDB.getGamePlayer(_data._usernamesStatic[i]);
						if (rowList	!= null &&  _data._triggerEvent != "foo")					
							_data._gamePlayersValues[i] = rowList._gamePlayersValues[0];
					}								
					
				}
				
				
				// save spectator_playing as false if this condition is true because everyone is playing the game at that game room.
				for (i in 0...4)
				{
					if (_data._username == _data._usernamesDynamic[i])
					{
						if (_data._gamePlayersValues[i] == 0)
							_mysqlDB.saveSpectator(_data._username, 0);				
					}
					
					else if (_data._gamePlayersValues[i] == 1)
						_mysqlDB.saveSpectator(_data._usernamesStatic[i], 1);
							
				}*/
			}
			
			player_game_state_value_update(_data);
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Game Players Values", _data);
				}
			}
			
		});
	}	

	/******************************
	* EVENT SAVE A VAR TO MYSQL SO THAT SOMEONE CANNOT INVITE WHEN STILL IN GAME ROOM. ALSO USED TO PASS A VAR TO USER SPECTATOR WATCHING. THAT VAR IS USED TO START A GAME FOR THAT SPECTATOR IF THE _gameIsFinished VALUE IS FALSE.
	* _dataPlayers
	*/
	public function gameIsFinished(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Game Is Finished", function(_data, _sender)
		{
			userLogs("Game Is Finished", _data.id, _data._username, _data); // logs
			
			_mysqlDB.saveIsGameFinishedUser(_data._username, _data._gameIsFinished, _data._spectatorWatching);
		
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Game Is Finished", _data);
				}
			}
			
		});
	}	
	
	/******************************
	* EVENT IS GAME FINISHED. FALSE IF GAME IS STILL BEING PLAYED. DEFAULTS TO TRUE BECAUSE WHEN ENTERING THE GAME ROOM THE GAME FOR THOSE PLAYERS HAS NOT STARTED YET.
	* _dataPlayers
	*/
	public function isGameFinished(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Is Game Finished", function(_data, _sender)
		{
			userLogs("Is Game Finished", _data.id, _data._username, _data); // logs
			
			var rset = _mysqlDB.selectRoomDataUser(_data._usernamesDynamic[0]);
			_data._isGameFinished = rset._isGameFinished[0];

			// this could update the same user with the same value but it could also update the _isGameFinished var for the spectator watching.
			_mysqlDB.saveIsGameFinishedUser(_data._username, _data._isGameFinished, _data._spectatorWatching);
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Is Game Finished", _data);
				}
			}
			
		});
	}	
	
	/******************************
	* EVENT AT LOBBY, SO RETURN ALL VARS TO 0 FOR PLAYER, SO THAT LOBBY DATA CAN BE CALCULATED TO DISPLAY DATA AT LOBBY CORRECTLY.
	* _dataMisc
	*/
	private function returnedToLobby(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Returned To Lobby", function(_data, _sender)
		{
			userLogs("Returned To Lobby", _data.id, _data._username, _data); // logs
			
			// room with a value of 0 is saved to userLocation parameter because cannot pass numbers and cannot save userLocation of value 0 when this condition check for not a valie of 0/
			//if (Std.string(_data._userLocation) != "0")
			_mysqlDB.saveRoomData(_data._username, 0, 0, 0, 0, -1, 0, 0);
							
			_sender.send("Returned To Lobby", _data);
		});
	}	
			
	/******************************
	* NOTE... GAME WILL NOT UPDATE FOR SPECTATOR UNTIL SECOND MOVE 
	* EVENT SPECTATOR WATCHING
	*  user who requested to watch a game. this can be a message such as "checkmate" or "restarting game". also, any var needed to start or stop a game will be passed here.
	* only the game host should send to this event.
	* _dataQuestions.
	*/
	private function spectatorWatching(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Spectator Watching", function(_data, _sender)
		{
			userLogs("Spectator Watching", _data.id, _data._username, _data); // logs
		
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Spectator Watching", _data);
				}
			}
			
		});
	}	
	
	/******************************
	* NOTE... GAME WILL NOT UPDATE FOR SPECTATOR UNTIL SECOND MOVE 
	* EVENT SPECTATOR WATCHING GET MOVE NUMBER.
	* send the current move number to the watching spectator so that the timer and white box underneath the P1, P2, P3 or P4 moves, can be updated.
	* _dataPlayers.
	*/
	private function spectatorWatchingGetMoveNumber(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Spectator Watching Get Move Number", function(_data, _sender)
		{
			userLogs("Spectator Watching Get Move Number", _data.id, _data._username, _data); // logs
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Spectator Watching Get Move Number", _data);
				}
			}
			
		});
	}	
	
	/******************************
	* EVENT MOVE HISTORY NEXT ENTRY.
	* every player that moves a piece will use the host of the room to call this event so to update the move history at mysql. this is needed so that when a spectator watching enters the room, that person can get all the move history for that game.
	* _dataMovement.
	*/
	private function moveHistoryNextEntry(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Move History Next Entry", function(_data, _sender)
		{
			userLogs("Move History Next Entry", _data.id, _data._username, _data); // logs
				
			_mysqlDB.updateMoveHistory(_data._gid, _data._username, _data._point_value, _data._unique_value, _data._moveHistoryPieceLocationOld1, _data._moveHistoryPieceLocationNew1, _data._moveHistoryPieceLocationOld2, _data._moveHistoryPieceLocationNew2, _data._moveHistoryPieceValueOld1, _data._moveHistoryPieceValueNew1, _data._moveHistoryPieceValueOld2, _data._moveHistoryPieceValueNew2, _data._moveHistoryPieceValueOld3);
			
			var rset = _mysqlDB.getAllMoveHistory(_data.id);//_data._username);
			
			
			// get length of any history var...
			var _str:String = Std.string(rset._moveHistoryPieceLocationOld1[0]);	
			//  then _dataMovement._moveHistoryTotalCount at client will equal that vars value. every value of that var from the database is split then put into _strArray and array elements.
			var _strArray = _str.split(",");
			_data._moveHistoryTotalCount = _strArray.length - 2;
			
			_data._moveHistoryPieceLocationOld1 = _strArray[_data._moveHistoryTotalCount];	

			_str = Std.string(rset._moveHistoryPieceLocationNew1[0]);	
			_strArray = _str.split(",");
			
			_data._moveHistoryPieceLocationNew1 = _strArray[_data._moveHistoryTotalCount];	
			
			_str = Std.string(rset._moveHistoryPieceLocationOld2[0]);	
			_strArray = _str.split(",");
			
			_data._moveHistoryPieceLocationOld2 = _strArray[_data._moveHistoryTotalCount];	
			
			_str = Std.string(rset._moveHistoryPieceLocationNew2[0]);	
			_strArray = _str.split(",");
			
			_data._moveHistoryPieceLocationNew2 = _strArray[_data._moveHistoryTotalCount];	
			
			_str = Std.string(rset._moveHistoryPieceValueOld1[0]);	
			_strArray = _str.split(",");
			
			_data._moveHistoryPieceValueOld1 = _strArray[_data._moveHistoryTotalCount];	
			
			_str = Std.string(rset._moveHistoryPieceValueNew1[0]);	
			_strArray = _str.split(",");
			
			_data._moveHistoryPieceValueNew1 = _strArray[_data._moveHistoryTotalCount];	
			
			_str = Std.string(rset._moveHistoryPieceValueOld2[0]);	
			_strArray = _str.split(",");
			
			_data._moveHistoryPieceValueOld2 = _strArray[_data._moveHistoryTotalCount];	
			
			_str = Std.string(rset._moveHistoryPieceValueNew2[0]);	
			_strArray = _str.split(",");
			
			_data._moveHistoryPieceValueNew2 = _strArray[_data._moveHistoryTotalCount];	
			
			_str = Std.string(rset._moveHistoryPieceValueOld3[0]);	
			_strArray = _str.split(",");
			
			_data._moveHistoryPieceValueOld3 = _strArray[_data._moveHistoryTotalCount];
			
			
			for (i in 0...25)
			{
				if (Std.int(_data._room) == i)
				{
					_sender.putInRoom(room[i]);
					room[i].broadcast("Move History Next Entry", _data);
				}
			}

		});
	}	
		
	/******************************
	* EVENT MOVE HISTORY ALL ENTRY.
	* the spectator has just joined the game room because there is currently only one move in that users history, do this event to get all the moves in the move history for this game.
	* _dataMovement.
	*/
	private function moveHistoryAllEntry(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Move History All Entry", function(_data, _sender)
		{
			userLogs("Move History All Entry", _data.id, _data._username, _data); // logs
			var rset = _mysqlDB.getAllMoveHistory(_data._gid);// _data._username);
			
			// get length of any history var...
			var _str:String = Std.string(rset._moveHistoryPieceLocationOld1[0]);	
			//  then _dataMovement._moveHistoryTotalCount at client will equal that vars value. every value of that var from the database is split then put into _strArray and array elements.
			var _strArray = _str.split(",");
						
			_data._history_get_all = 0;
			
			if (rset._moveHistoryPieceLocationOld1[0] != null)
			{		
				_data._history_get_all = 1;
				_data._moveHistoryTotalCount = _strArray.length;
			
				_data._point_value = Std.string(rset._point_value[0]);	
				_data._unique_value = Std.string(rset._unique_value[0]);
				
				_data._moveHistoryPieceLocationOld1 = Std.string(rset._moveHistoryPieceLocationOld1[0]);	
				
				_data._moveHistoryPieceLocationNew1 = Std.string(rset._moveHistoryPieceLocationNew1[0]);	
				
				_data._moveHistoryPieceLocationOld2 = Std.string(rset._moveHistoryPieceLocationOld2[0]);		
				
				_data._moveHistoryPieceLocationNew2 = Std.string(rset._moveHistoryPieceLocationNew2[0]);
				
				_data._moveHistoryPieceValueOld1 = Std.string(rset._moveHistoryPieceValueOld1[0]);		
				
				_data._moveHistoryPieceValueNew1 = Std.string(rset._moveHistoryPieceValueNew1[0]);		
				
				_data._moveHistoryPieceValueOld2 = Std.string(rset._moveHistoryPieceValueOld2[0]);
				
				_data._moveHistoryPieceValueNew2 = Std.string(rset._moveHistoryPieceValueNew2[0]);
				
				_data._moveHistoryPieceValueOld3 = Std.string(rset._moveHistoryPieceValueOld3[0]);
			}
			
			_sender.send("Move History All Entry", _data);
			
		});
	}		
	
	/******************************
	* EVENT LEADERBOARDS
	* display a 50 player list of the players with the top experence points.
	* _dataLeaderboardXP.
	*/
	private function leaderboards(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Leaderboards", function(_data, _sender)
		{
			userLogs("Leaderboards", _data.id, _data._username, _data); // logs
			
			var _row = _mysqlDB.getLeaderboards();
			
			for (i in 0...50)
			{
				if (_row._user[i] != null)
				{
					_data._usernames += Std.string(_row._user[i]) + ",";
					_data._experiencePoints += Std.string(_row._experiencePoints[i]) + ",";
				}
			}
			
			_sender.send("Leaderboards", _data);			
		});
	}	
	
	/******************************
	* EVENT SAVE NEW ACCOUNT CONFIGURATIONS
	* save new user account information. when user first enters online game and chess elo equals zero then the user is new. the user will then be redirected to a new account scene where new user configuration will be set, such as chess skill level. when the save button is pressed, this event is called.
	* _dataStatistics
	*/
	public function saveNewAccountConfigurations(_data:Dynamic, _sender:vendor.mphx.connection.IConnection):Void
	{
		_server.events.on("Save New Account Configurations", function (_data, _sender)
		{
			userLogs("Save New Account Configurations", _data.id, _data._username, _data); // logs
			
			_mysqlDB.updateChessEloRating(_data._username, _data._chess_elo_rating);
			
		});
	}			
			
	private function onDisconnect(_data:Dynamic, _sender:IConnection) : Void
	{
		_data = allDataPlayers.get(_sender);
				
		var _playerNumber:Int = 0;		
		
		try 
		{
			if (_data._username != null)
			{
				// this player that disconnected.
				var row = _mysqlDB.selectRoomDataUser(_data._username);
				
				// this function does not get _playersState correctly, so this is needed or else the next mysql save will give an error.
				_data._username = row._user[0];
				_data._username = Std.string(_data._username);
				
				// remove username from array logs file vars. the logs file stores the user activity. we need to remove the username from these arrays so that the arrays store the correct online user.
				_logsuserId.remove(_data._username);
				_logsUsername.remove(_data._username);
				
				_data._gamePlayersValues = [0, 0, 0, 0];
				
				// if true then we are at the game room.
				if (_data._username != null
				&&	_data._gamePlayersValues != null
				&&	player_game_state_value_username != null)
				{		
					for (i in 0...player_game_state_value_username.length+1)
					{
						// find the username is this var.
						if (_data._username == player_game_state_value_username[i])
						{
							// update the game state for this player.
							_data._gamePlayersValues = player_game_state_value_data[i];
						}
					}
				}
				
				_data._usernamesDynamic = ["", "", "", ""];
				_data._usernamesStatic = ["", "", "", ""];
				_data._spectatorPlaying = row._spectatorPlaying[0];
				_data._spectatorWatching = row._spectatorWatching[0];
				_data._userLocation = Std.parseInt(Std.string(row._userLocation[0]));
				_data._room = Std.parseInt(Std.string(row._room[0]));
				_data._gameId = row._gameId[0];
				
				if (_data._spectatorWatching == false)
				{
					var rowList = _mysqlDB.selectGameRoomDataNoSpectatorWatching(_data._room);
					// get game playing data from database for the players in that game room.
			
					// the following four code blocks need to be init this way to avoid a server crash.
					if (Std.string(_usernames_static[_data._room][0]) != "")
					{								
						_data._usernamesStatic[0] = Std.string(_usernames_static[_data._room][0]);
						_data._usernamesStatic[0] = Std.string(_data._usernamesStatic[0]);
						
					}
					
					if (Std.string(_usernames_static[_data._room][1]) != "")
					{								
						_data._usernamesStatic[1] = Std.string(_usernames_static[_data._room][1]);
						_data._usernamesStatic[1] = Std.string(_data._usernamesStatic[1]);
						
					}
					
					if (Std.string(_usernames_static[_data._room][2]) != "")
					{								
						_data._usernamesStatic[2] = Std.string(_usernames_static[_data._room][2]);
						_data._usernamesStatic[2] = Std.string(_data._usernamesStatic[2]);
						
					}
					
					if (Std.string(_usernames_static[_data._room][3]) != "")
					{								
						_data._usernamesStatic[3] = Std.string(_usernames_static[_data._room][3]);
						_data._usernamesStatic[3] = Std.string(_data._usernamesStatic[3]);
						
					}
					
					if (_data._usernamesStatic[0] == "")
					{
						_data._usernamesStatic[0] = _data._username;
						_data._usernamesStatic = Std.string(_data._usernamesStatic);
						
					}
					
					// get the usernames and the _gamePlayersValues for all non spectators in the game room rather they are playing a game or not.
					for (i in 0...4)
					{
						if (rowList._user[i] != null)
						{
							if (_data._gamePlayersValues[i] == 1)
								_data._usernamesDynamic[i] = rowList._user[i];
							
						}
					}
					
					// get all users in game room.
					var rset3 = _mysqlDB.getAllFromUsers(_data._username);		
					var rset = _mysqlDB.selectPlayersUsernames2(rset3._room[0]);
					var row = _mysqlDB.selectRoomDataUser(_data._username);
					
					if (_data._room > 0)
					{
						for (i in 0...4)
						{
							if (Std.string(_data._usernamesStatic[i]) != "" && Std.string(_data._usernamesStatic[i]) == _data._username)
							{
								_playerNumber = i;
							}
						}
					}
					
					if (row._roomState[0] == 8 && _data._gamePlayersValues[_playerNumber] == 1)
					{
						// save the player's game player state to the database. is the player playing a game or waiting to play. 
						// 0: = not playing but still at game room. 
						// 1: playing a game. 
						// 2: left game room while still playing it. 
						// 3: left game room when game was over. 
						// 4: quit game.
						// this var is used to display players who are waiting for a game at the game room and to get the _count of how many players are waiting at game room.
						
						// even thou this user will be deleted from the database, we should save the _gamePlayersValues var because player is logging offline and if the data was not saved here then it might first be read from a client that gets the data from the server and that value could be 0 or 1 not -1 or -2.
						if (_data._spectatorPlaying == true) _data._gamePlayersValues[_playerNumber] = 2;
						else _data._gamePlayersValues[_playerNumber] = 3;
						
						for (i in 0...4)
						{
							if (row._roomState[0] == 8
							&& _data._username == Std.string(_data._usernamesStatic[i]))
							{
								if (_data._spectatorPlaying == true) _mysqlDB.saveGamePlayer(Std.string(_data._usernamesStatic[i]), Std.parseInt(_data._gamePlayersValues[_playerNumber]));
							}
						}
								
						_mysqlDB.saveLoseStats(_data._gameId, _data._username);
						
						// this checks if there is an event to give on this day.
						// see the doEvent() function.
						eventsLose(_data, _data._username);
					}
					
					else
					{
						for (i in 0...4)
						{
							if (row._roomState[0] == 8 && _data._gamePlayersValues[_playerNumber] == 0 && _data._username == Std.string(_data._usernamesStatic[i])
							||  row._roomState[0] == 8 && _data._gamePlayersValues[_playerNumber] == 4 && _data._username == Std.string(_data._usernamesStatic[i]))
							{
								_data._gamePlayersValues[_playerNumber] = 3;
								if (_data._spectatorPlaying == true) _mysqlDB.saveGamePlayer(Std.string(_data._usernamesStatic[i]), Std.parseInt(_data._gamePlayersValues[_playerNumber]));
							}
						}
					}
					
					// this sends a message to the other player saying that someone left the game. 			
					if (_data._userLocation >= 2 && _data._room > 0)
					{						
						// player is leaving room, so make this a value of 3.
						if (_data._gamePlayersValues[_playerNumber] == 0)
							_data._gamePlayersValues[_playerNumber] = 3;
						
						// save the player's game player state to the database. is the player playing a game or waiting to play.				
						for (i in 0...4)
						{
							if (_data._username == Std.string(_data._usernamesStatic[i]) && Std.string(_data._usernamesStatic[i]) != "")
							{
								//if (_data._spectatorPlaying == true) 
								_mysqlDB.saveGamePlayer(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
							}
						}
	/*
	trace(_data._usernamesStatic + " _data._usernamesStatic");
	trace(_data._usernamesDynamic + " _data._usernamesDynamic");
	trace(_data._spectatorPlaying + " _data._spectatorPlaying");
	trace(_data._spectatorWatching + " _data._spectatorWatching");	
	trace(_data._gamePlayersValues + " _data._gamePlayersValues");
	trace(_data._userLocation + " _data._userLocation");
	trace(_data._gamePlayersValues+"_gamePlayersValues");
	trace(_data._room + " _data._room");
	trace(_data._gameId + " _data._gameId");
	trace("--------------------");
	*/										
						// TODO maybe do rooms instead of broadcast here.		
						//_server.broadcast("Player Left Game Room", _data);
						
						for (i in 0...25)
						{
							if (Std.int(_data._room) == i)
							{
								//_sender.putInRoom(room[i]);
								room[i].broadcast("Player Left Game Room", _data);
							}
						}
					}
				}
				
				userLogs("Disconnected", "", _data._username, _data); // logs
			}
			
			// at every connection an existence of a host file is checked. if the user opens another client at the same computer then that means there is a host file. that user will be disconnected.
			_miscState = allDataMisc.get(_sender);
			
			if (_miscState._username != null && _miscState._alreadyOnlineHost == false)
			{
				deleteRowsFromDatabase(_miscState);	 
				
				if (_miscState._username.substr(0, 5) == "guest")
					_mysqlDB.deleteUserGuest(_miscState._username);

			}	
				
			allDataGame.remove(_sender);
			allDataGame0.remove(_sender); // don't delete.
			allDataGame1.remove(_sender);
			allDataGame2.remove(_sender);
			allDataGame3.remove(_sender);
			allDataGame4.remove(_sender);
			
			allDataDailyQuests.remove(_sender);
			allDataQuestions.remove(_sender);
			allDataOnlinePlayers.remove(_sender);
			allDataMisc.remove(_sender);
			allDataPlayers.remove(_sender);
			allDataTournaments.remove(_sender);
			allDataAccount.remove(_sender);
			allDataGameMessage.remove(_sender);
			allDataMovement.remove(_sender);
			allDataStatistics.remove(_sender);
			allDataHouse.remove(_sender);
			allDataLeaderboards.remove(_sender);
			
			// a client has disconnected to this server. Therefore, decrease the amount of clients connected.
			_serverConnections -= 1;
			
			Sys.println ("Client disconnected. Clients connected: " + _serverConnections);
			
			if (_closeServer == true && _serverConnections == 0)
			{
				Sys.println ("Server not active.");
				_server.close();
				Sys.exit(0);
			}
		}
		catch (e:Dynamic)
		{
		}
	}
	
	private function addRowsToDatabase(_data:Dynamic):Void
	{
		_mysqlDB.insertLoggedInUser(_data._username, _data._ip, _data._host, 0);
		_mysqlDB.insertRoomData(_data._username, _data.id);
		_mysqlDB.insertUserToStatisticsTable(_data._username);
		_mysqlDB.insertUserToHouseTable(_data._username);
	}
	
	/**************************************************************************
	 * deletes these tables when user first logs in and while user is disconnecting.
	 * _dataMisc is passed as a paranmeter of _data here.
	 */
	private function deleteRowsFromDatabase(_data:Dynamic):Void
	{
		_mysqlDB.deleteLoggedInHost(_data._host);
		_mysqlDB.deleteLoggedInUser(_data._username);
		// also deletes table who_is_host and table room_lock at this line.
		_mysqlDB.deleteRoomData(_data._username);
		_mysqlDB.deleteUserKickedAndBanned(_data._username);
		_mysqlDB.deleteIsHost(_data._username); 
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
	
	/**
	 * output the event name to server console then save the event data to the log file.
	 * @param	_event			the event the user is at.
	 * @param	_id				the id of the typedef being sent as event _data.
	 * @param	_user			the username.
	 * @param	_dataDump		all vars within the typedef of that event.
	 */
	private function userLogs(_event:String, _id:String = "", _user:String = "", _dataDump:Dynamic = null):Void
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
	
	private function hostCpuUserNames():Void
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
	
	// here we use the ip address to find the username of the user logged into the website. if found, the user will be sent to the lobby.
	public static function getUsername(_ip:String):String
	{
		_ip = "&ip=" + _ip;
		
		var _token = "token=fi37cv%PFq5*ce78";
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
	private function eloProbability(rating1:Float, rating2:Float):Float
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
	private function EloRating(_user1:String, _user2:String, _chess_elo_rating1:Float, _chess_elo_rating2:Float, _chess_elo_k:Int, _chess_did_player1_win:Bool):Void
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
		_mysqlDB.updateChessEloRating(_user1, _chess_elo_rating1);
		_mysqlDB.updateChessEloRating(_user2, _chess_elo_rating2);
	}
	
}// ignore this. its a bug in the ide that adds this junk sometimes to the end of a class. 