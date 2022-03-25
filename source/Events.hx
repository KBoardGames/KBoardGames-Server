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

import Reg;
import RestrictedWords;
import Functions;
import sys.FileSystem;
import sys.net.Host;
import vendor.ws.SocketImpl;
import vendor.ws.WebSocketHandler;
import vendor.ws.WebSocketServer;

/**
 * ...
 * @author kboardgames.com
 */
class Events
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
	public static var _roomState:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	// max players in room.
	public static var _roomPlayerLimit:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
						 
	public static var _roomPlayerCurrentTotal:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
						 	
	// if true then this room allows spectators.
	public static var _allowSpectators:Array<Int> =
						[0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
					 	 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
						 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		
	// used to list the games at lobby. see Reg.gameName(). also, for not a host player, the data from here will populate _miscState._data._gameId for that player.
	//-1: no data, 0:checkers, 1:chess, etc.
	public static var _roomGameIds:Array<Int> =
					[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
					 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
					 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
					 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
					 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];

	
	// a list of every username that is a host of a room.
	// at client.SceneWaitingRoom.hx, there is a list of all user at the lobby. only the host can invite a user.
	public static var _roomHostUsername:Array<String> =
					["", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", ""];
		
	// game id. move_history fields are not deleted from the mysql database. so this id is used so that a user accesses that correct move_history data.
	public static var _gid:Array<String> =
					["", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", "",
					"", "", "", "", "", "", "", "", "", ""];
					
	public static var _onlinePlayersUsernames:Array<String>
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
	public static var _onlinePlayersGameWins:Array<Int>
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
	public static var _onlinePlayersGameLosses:Array<Int>
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
	public static var _onlinePlayersGameDraws:Array<Int>
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

	public static var _online_all_elo_ratings:Array<Float>
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
	
	private var _usernames_static:Array<Array<String>> =
	[for (p in 0...51) [for (i in 0...4) ""]];
	
	/******************************
	 * read the mysql servers_status table every so many ticks. When the do_once field at that table has a value of true, this var will be set to true so that a block of code is is no longer read.
	 */
	//private var _mysqlReadServersStatusOnce:Bool = false;
	
	// each element refers to the id of a game. the first element is checkers then chess, etc. the player that wins the game gets the experience points value of this vars element. a game lose is half that of a win. so if playing chess and the player lost the game then the experience points gained will be half of 70 rounded to the whole number because we are using Int.
	private var _experiencePointsGiven:Array<Int> = [70, 70, 50, 50, 90]; 
	
	/******************************
	* closes the server if true. there will be an error if closing within an event because the event code cannot continue if not connected so this var is called in the event and this var "if true" is needed outside the event to close it.
	*/
	private var _closeServer:Bool = false;

	/******************************
	 * The maximum allowed connection to this server.
	 */
	private var _maximumServerConnections:Int = 119;
	
	private var _db_delete:DB_Delete;
	private var _db_insert:DB_Insert;
	private var _db_select:DB_Select;
	private var _db_update:DB_Update;
	
	/******************************
	 * to access the _data of the _gameState, miscstate, etc.
	 */
	private var _data:Dynamic;
	
	private var _server:Main;
	private var _handler:WebSocketHandler;
	
	public function new(data:Dynamic, server:Main, handler:WebSocketHandler) 
	{
		_data = data;
		_server = server;
		_handler = handler;
		
		_db_delete = new DB_Delete();
		_db_select = new DB_Select();
		_db_insert = new DB_Insert();
		_db_update = new DB_Update();
		
		// create the cpu host names for room a and b.
		Functions.hostCpuUserNames();
	}	
	
	public function name(_data:Dynamic):Void
	{
		trace("data received: " + _data._event_name);
		
		switch (_data._event_name)
		{
			// called when player joins server.
			case "Join":
				join(_data, _server, _handler);
			
			// the player is logging in.
			case "Is Logging In":
				isLoggingIn(_data, _server, _handler);
			
			// players house where they buy items, place items in room and vote for best house for prizes.
			case "House Load":
				houseLoad(_data, _server, _handler);
			
			// save the house layout for player.
			case "House Save":
				houseSave(_data, _server, _handler);
			
			// verifies if the email address is valid. validation code could be sent to a user's email address.
			case "Email Address Validate":
				emailAddressValidate(_data, _server, _handler);
			
			// Get Statistics Win Loss Draw, such as, wins, draws and losses.
			case "Get Statistics Win Loss Draw":
				getStatisticsWinLossDraw(_data, _server, _handler);
			
			// get all stats such as experience points, credits, wins, etc.
			case "Get Statistics All":
				getStatisticsAll(_data, _server, _handler);
			
			// event player has entered the room, so change the roomstate value.
			case "Greater RoomState Value":
				greaterRoomStateValue(_data, _server, _handler);
			
			// event player has left the room, so change the roomstate value.
			case "Lesser RoomState Value":
				lesserRoomStateValue(_data, _server, _handler);
			
			// if room is locked then player cannot enter it. room is locked for everyone until that player gets all events for that room.
			case "Is Room Locked":
				isRoomLocked(_data, _server, _handler);
			
			// save room data to database. able to put user into room.
			case "Set Room Data":
				setRoomData(_data, _server, _handler);
			
			// load room data from database.
			case "Get Room Data":
				getRoomData(_data, _server, _handler);
			
			// Used at lobby to delay the second player from entering into the room until the room lock is removed from that room.
			case "Room Lock 1":
				roomLock1(_data, _server, _handler); 
			
			// This event only removes the room lock.
			case "Room Lock 2":
				roomLock2(_data, _server, _handler);
			
			case "Get Room Players":
				getRoomPlayers(_data, _server, _handler);
			
			// the players chat message.
			case "Chat Send":
				chatSend(_data, _server, _handler);
			
			// Game message. Not a message box.
			case "Game Message Not Sender":
				gameMessageNotSender(_data, _server, _handler);
			
			// message box.
			case "Game Message Box For Spectator Watching":
				gameMessageBoxForSpectatorWatching(_data, _server, _handler);
			
			// stop player from playing for some time.
			case "Message Kick":
				messageKick(_data, _server, _handler); 
			
			case "Remove Kicked From User":
				removeKickedFromUser(_data, _server, _handler);
			
			// stop player from playing forever.
			case "Message Ban":
				messageBan(_data, _server, _handler);
			
			// offer game draw so that it is a tie.
			case "Draw Offer":
				drawOffer(_data, _server, _handler);
			
			// draw reply.
			case "Draw Answered As":
				drawAnsweredAs(_data, _server, _handler);
			
			// offer game restart so that another game can be played.
			case "Restart Offer":
				restartOffer(_data, _server, _handler);
			
			// game restart reply.
			case "Restart Answered As":
				restartAnsweredAs(_data, _server, _handler);
			
			// offer an invite to a player at the lobby.
			case "Online Player Offer Invite":
				onlinePlayerOfferInvite(_data, _server, _handler);
			
			// this event enters the game room.
			case "Enter Game Room":
				enterGameRoom(_data, _server, _handler);
			
			// win text using a message popup.
			case "Game Win":
				gameWin(_data, _server, _handler);
			
			// lose text using a message popup.
			case "Game Lose":
				gameLose(_data, _server, _handler);
			
			// win text using a message popup then lose message box for the other player.
			case "Game Win Then Lose For Other":
				gameWinThenLoseForOther(_data, _server, _handler);
			
			// lose text using a message popup, then win message box for the other player.
			case "Game Lose Then Win For Other":
				gameLoseThenWinForOther(_data, _server, _handler);
			
			// draw text using a message popup.
			case "Game Draw":
				gameDraw(_data, _server, _handler);
			
			// save win stats of current player.
			case "Save Win Stats":
				saveWinStats(_data, _server, _handler);
			
			// save lose stats of current player.
			case "Save Lose Stats":
				saveLoseStats(_data, _server, _handler);	
			
			// save win stats of current player then a lose for the other player.
			case "Save Win Stats For Both":
				saveWinStatsForBoth(_data, _server, _handler);
			
			// save lose stats of current player then a win for the other player.
			case "Save Lose Stats For Both":
				saveLoseStatsForBoth(_data, _server, _handler);
			
			// save draw stats of current player.
			case "Save Draw Stats":
				saveDrawStats(_data, _server, _handler);
			
			// gets the selected tournament data.
			case "Tournament Chess Standard 8 Get":
				tournamentChessStandard8Get(_data, _server, _handler);			
			
			// puts the selected tournament data to the mysql database.
			case "Tournament Chess Standard 8 Put":
				tournamentChessStandard8Put(_data, _server, _handler);
			
			// 0: not subscribed to mail. 1: true.
			case "Tournament Reminder By Mail":
				tournamentReminderByMail(_data, _server, _handler);
			
			// 0: removed from tournament. 1: joined.
			case "Tournament Participating":
				tournamentParticipating(_data, _server, _handler);
			
			// Trigger an event that the player has left the game room.
			case "Player Left Game Room":
				playerLeftGameRoom(_data, _server, _handler);
			
			// Trigger an event that the player has left the game.
			case "Player Left Game":
				playerLeftGame(_data, _server, _handler);
			
			// list of online players with stats. used to invite.
			case "Logged In Users":
				loggedInUsers(_data, _server, _handler);
			
			// refers to an action, eg, 1 = kick. see the "Action By Player" event at server.
			case "Action By Player":
				actionByPlayer(_data, _server, _handler);
			
			case "Is Action Needed For Player":
				isActionNeededForPlayer(_data, _server, _handler);	
			
			// gets the current move timer for the player that is moving. the value is sent to the other clients so that they have the update value.
			case "Player Move Time Remaining":
				playerMoveTimeRemaining(_data, _server, _handler);
			
			// save a var to mySql so that someone cannot invite when still in game room. also, triggers a var called Reg._gameOverForAllPlayers to equal true so that the game has ended for everyone.
			case "Game Is Finished":
				gameIsFinished(_data, _server, _handler);
			
			// false if game is still being played. defaults to true because when entering the game room the game for those players has not started yet.
			case "Is Game Finished":
				isGameFinished(_data, _server, _handler);
			
			// at lobby, so return all vars to 0 for player, so that lobby data can be calculated to display data at lobby correctly.
			case "Returned To Lobby":
				returnedToLobby(_data, _server, _handler);
			
			// called when player moves a piece.
			// checkers.
			case "Player Move Id 0":
				playerMoveId0(_data, _server, _handler);
			
			// chess.
			case "Player Move Id 1":
				playerMoveId1(_data, _server, _handler);	
			
			// reversi.
			case "Player Move Id 2":
				playerMoveId2(_data, _server, _handler);
			
			// snakes and ladders.
			case "Player Move Id 3":
				playerMoveId3(_data, _server, _handler);
			
			// signature game.
			case "Player Move Id 4":
				playerMoveId4(_data, _server, _handler);
			
			// event waiting room sets host of the room.
			case "Is Host":
				isHost(_data, _server, _handler);
			
			// currently this event is for the signature game. a player sends a trade unit to another player and this event is for that other player receiving the trade. a dialog box displays, with trade details, asking if the player would like that trade. 30 seconds countdown. when timer reaches zero, the dialog box closes.
			case "Trade Proposal Offer":
				tradeProposalOffer(_data, _server, _handler);
			
			// what did the player answer as the trade request dialog box!
			case "Trade Proposal Answered As":
				tradeProposalAnsweredAs(_data, _server, _handler);
			
			// is the player playing a game or waiting to play. 0 = not playing but still at game room. 1 playing a game. 2: left game room while still playing it. 3 left game or game room when game was over. 
			case "Game Players Values":
				gamePlayersValues(_data, _server, _handler);
			
			// user who requested to watch a game. that user can never play a game in that game room.
			case "Spectator Watching":
				spectatorWatching(_data, _server, _handler); 
			
			// send the current move number to the watching spectator so that the timer and white box underneath the P1, P2, P3 or P4 moves, can be updated.
			case "Spectator Watching Get Move Number":
				spectatorWatchingGetMoveNumber(_data, _server, _handler); 
			
			// every player that moves a piece will use the host of the room to call this event so to update the move history at mysql. this is needed so that when a spectator watching enters the room, that person can get all the move history for that game.
			case "Move History Next Entry":
				moveHistoryNextEntry(_data, _server, _handler);
			
			// the spectator has just joined the game room because there is currently only one move in that users history, do this event to get all the moves in the move history for this game.
			case "Move History All Entry":
				moveHistoryAllEntry(_data, _server, _handler);
			
			// display a 50 player list of the players with the top experence points.
			case "Leaderboards":
				leaderboards(_data, _server, _handler);
			
			// save new user account information. when user first enters online game and chess elo equals zero then the user is new. the user will then be redirected to a new account scene where new user configuration will be set, such as chess skill level. when the save button is pressed, this event is called.
			case "Save New Account Configurations":
				saveNewAccountConfigurations(_data, _server, _handler); 
			
			// conpete these daily quests for rewards.
			case "Daily Quests":
				dailyQuests(_data, _server, _handler);
			
			// At the client the daily quest reward was given to player. this event saves the _reward var so that a second reward of the same type will not be given to player.
			case "Daily Quests Claim":
				dailyQuestsClaim(_data, _server, _handler); 
			
			// A daily reward has been claimed. now save the reward(s) to the database.
			case "Daily Reward Save":
				dailyRewardSave(_data, _server, _handler);
			
			// you need to set the values below at the game code. see SignatureGameClickMe.hx. at client. makes all clients move the same piece at the same time. this is not automatic.
			case "Movement":
				movement(_data, _server, _handler);
				
			case "Disconnect All By Server":
				disconnectAllByServer(_data, _server);
			
		}
	}
	
	/**************************************************************************
	 * this checks if there is an event to give on this day but after the player won the game.
	 * see the doEvent() function.
	 */
	private function eventsWin(_data:Dynamic, _username:Dynamic):Void
	{
		//-------------------------------
		// daily quests.
		_db_update.daily_quests_3_in_a_row_win(_username);
		
		// if finished a game of chess in 5 or under moves...
		if (_data._gameId == 1 && _data._moveTotal <= 5) 
			_db_update.daily_quests_chess_5_moves_under(_username);
		// if finished a game of snakes and ladder in under 4 moves...
		if (_data._gameId == 3 && _data._moveTotal < 4) 
			_db_update.daily_quests_snakes_under_4_moves(_username);
		if (_data._timeTotal == 300) // 300 is 5m * 60s (5*60)
			_db_update.daily_quests_win_5_minute_game(_username);
		
		if (_data._house_items_daily_total >= 4)
			_db_update.daily_quests_buy_four_house_items(_username);
		if (_data._gameId == 4) // signature game.
			_db_update.daily_quests_finish_signature_game(_username);
		if (_data._gameId == 2 && _data._piece_total_for_winner >= 50)
			_db_update.daily_quests_reversi_occupy_50_units(_username);

			//------------------------------
			// checkers.	
			if (_data._gameId == 0 && _data._checkers_king_total >= 6) 
				_db_update.daily_quests_checkers_get_6_kings(_username);
				
			_data._all_boardgames_played_total[_data._gameId] = 1;
			
			var _count = true;
			
			for (i in 0...5) // all board games currently in client.
			{
				if (_data._all_boardgames_played_total[i] == 0)
					_count = false;
			}
			
			if (_count == true)
				_db_update.daily_quests_play_all_5_board_games(_username);
			
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
		_db_update.daily_quests_3_in_a_row_lose(_username);
		
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
				var rset = _db_select.user_get_all_at_statistics(_data._username);
				
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
						_db_update.credits_for_user_at_statistics(_data._username, _intMonth, _intDay);
					}
					
					// if under 5 credits for today then give 1 credit to user that won the game. note that this event is called when game is won.
					else if (rset._creditsToday[0] < 5)
					{
						_db_update.credits_date_for_user_at_statistics(_data._username);
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
						_db_update.exp_points_for_user_at_statistics(_data._username, _halfExperiencePointsGiven);
					}
					
					else 
					{
						// double the experience points.
						_db_update.exp_points_for_user_at_statistics(_data._username, _experiencePointsGiven[_data._gameId] * 2);
					}
				}
				
				// this is not an event day so give normal xp (experience points.)
				else
				{
					if (_loseGame == true)
					{
						// normal expierience points divided by 2.
						var _halfExperiencePointsGiven:Int = Math.round(_experiencePointsGiven[_data._gameId] / 2);
						_db_update.exp_points_for_user_at_statistics(_data._username, _halfExperiencePointsGiven);
						
					}
					
					else 
					{
						// give normal experience points.
						_db_update.exp_points_for_user_at_statistics(_data._username, _experiencePointsGiven[_data._gameId]);
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
						_db_update.house_coins_for_user_at_statistics(_data._username, 1);
					}
					
					else 
					{
						_db_update.house_coins_for_user_at_statistics(_data._username, 2);
					}
				}
				
			}
			
			
			
		}
		
		
	}
	
	/******************************
	* EVENT JOIN
	* this Join event is the first read when the client connects to this server.
	*/
	private function join(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		/*trace(_data.id);
		trace(_data._username);
		trace(_data._ip);
		*/
		
		trace(_data._hostname);
		trace(_data._password_hash);
				
		try 
		{
			Functions.userLogs("Join", "", "", ""); // logs.
			
			if (_data.id == null
			||	_data._username == null
			||	_data._hostname == null
			||	_data._password_hash == null) return;
			
			if (_data.id == ""
			||	_data._username == ""
			//||	_data._hostname == ""
			||	_data._password_hash == "") return;
			
			if (_data.id.length > 80
			||	_data._username.length > 80
			||	_data._hostname.length > 150
			||	_data._password_hash.length > 150
			||	_data._email_address.length > 100) return;
			
			// a client has connected to this server. Therefore, increase the amount of clients connected.
			_server._serverConnections += 1;

			Sys.println ("A client has joined the server.");

			// a client has connected to this server. Therefore, increase the amount of clients connected.

			Sys.println ("Clients connected: " + _server._serverConnections);
			
			var host = _db_insert.hostname_to_logged_in_hostname(_data._username, _data._hostname);
			
			// TODO if removing this block then remember to remove _db_select.user_all_at_users() function.
			//var rset = _db_select.user_all_at_users(_data._username);
			//var _resolve_ip = new Host(Std.string(rset._ip[0]));
			//_data._ip = Std.string(_resolve_ip);
			
			// get the current room data for user.
			/*_miscState._roomState = _roomState;
			_miscState._roomPlayerLimit = _roomPlayerLimit;
			_miscState._roomPlayerCurrentTotal = _roomPlayerCurrentTotal;
			_miscState._rated_game = _rated_game;
			_miscState._allowSpectators = _allowSpectators;
			_miscState._roomGameIds = _roomGameIds;
			_miscState._roomHostUsername = _roomHostUsername;
			_miscState._gid = _gid;
			*/
			_data._server_fast_send = "";
			_data._server_blocking = "";			
			_data._clients_connected = _server._serverConnections;
			
			// host not found for username.
			// check if hostname exists in database.
			var _row = _db_select.data_from_hostname_at_users(_data._hostname);
			
			if (Std.string(_row._hostname[0]) != _data._hostname) 
			{
				var _found:Bool = false;
				
				// is this a guest account?
				
				var _row2 = _db_select.guests_from_users_table();
				
				if (_data._username == "Guest1")
				{
					for (i in 0... _row2._user.length)
					{
						if ( Std.string(_row2._user[i]) != "Guest" + Std.string((i+1)))
						{
							_data._username = "Guest" + Std.string((i+1));
							_found = true;
						}
						
						if (_found == true) break;
					}
				}
			}
			
			// determine if the hostname is not a guest account. meaning that the player created an account at desktop client.
			else if (_data._username == "Guest1")
			{
				var _row3 = _db_select.data_from_hostname_at_users(_data._hostname);
				
				var _user_new = Std.string(_row3._user[0]);
				_db_update.logged_in_hostname(_user_new, _data._username);
				
				_data._username = _user_new;
			}
			
			else
			{
				var rset = _db_select.data_from_hostname_at_users(_data._hostname);
				var _hash = Std.string(rset._password_hash[0]);
				var _user = Std.string(rset._user[0]);
				var _hostname = Std.string(rset._hostname[0]);
		
				// no longer using a guest account. save players name to the row that has the hostname.
				if (_user != _data._username
				&&	_hostname == _data._hostname)
				{
					_db_update.rename_user_from_guest_at_users(_data._username, _user, _data._password_hash, _data._hostname);
				}
			}
			
			// these words are reserved words. this list contains the dummy data names and words such as sysop or bot.
			for (i in 0... ReservedWords.list.length)
			{
				if (_data._username.toLowerCase() == ReservedWords.list[i].toLowerCase())
					_data._username_banned = ReservedWords.list[i];
			}
			
			// these are words that are filtered out of the chatter. Since these are unwanted words, if one of these words match this users selected username then set _data._username_banned. that person will not be able to login using that name.
			for (i in 0... RestrictedWords.list.length)
			{
				if (_data._username.toLowerCase() == RestrictedWords.list[i].toLowerCase())
					_data._username_banned = RestrictedWords.list[i];
			}
			
			_server.put_in_room(_data);
			_server.send_to_handler(_data);
			
		}
		catch (e:Dynamic)
		{
			Sys.println ('Warning, someone accessed the server perhaps from a "is my port active" service.');
			
			Functions.userLogs("Join", "", "", ""); // logs.				
		}
	}
	
	/******************************
	* EVENT IS LOGGING IN. user is typing a username and password to enter the lobby.
	* _dataAccount
	*/
	private function isLoggingIn(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		var rset = _db_select.user_all_at_users(_data._username);
		var _hash = Std.string(rset._password_hash[0]);
		var _user = Std.string(rset._user[0]);
		var _hostname = Std.string(rset._hostname[0]);
		
		// 1: save hash to database if hash was not found in database.
		if (_hash == "")
		{
			// saves either a guest or regular username.
			_db_update.user_password_hash_at_users(_data._username, _data._password_hash);
			
			
			_hash = _data._password_hash;
		}
		
		if (_data._username != "" // old account
		&&	_hash == _data._password_hash
		||	_data._username.toLowerCase() != "nobody"
		||	_user == "null" && _hash != "" /* new account */
		||	_data._username == "bot ben"
		||	_data._username == "bot zak"
		||	_data._username == "bot piper"
		||	_data._username == "bot lisa"
		||	_data._username == "bot amy"
		)
		{
			_db_delete.tables_user_logged_off(_data._username);
			_db_delete.user_no_kicked_or_banned(_data._username);
			_db_delete.user_at_who_is_host(_data._username); 
			
			// create room_data mysql fields. when user logs off, the mysql username rows will be deleted.
			addRowsToDatabase(_data);
			
			if (_data._username.substr(0, 5) == "Guest")	
				_db_update.hostname_at_users(_data._username, _data._hostname);
			
			_data._popupMessage = "Login successful."; // if you change the value of this string then you need to change it also at client.
			
			_db_update.avatar_at_login(_data._username, _data._avatarNumber);

			// TODO add a _data_some_new_var here which cab be used to bypass this code so that the user's avatar at website is used. also, see client PlayState class, the code just above the "is logging in" event.
			Functions.userLogs("Is Logging In", _data.id, _data._username); // logs.
			_db_insert.user_and_data_to_users(_data._username, _data._password_hash, _data._ip, _data._hostname);
			_db_insert.user_data_to_daily_quests(_data._username);
			
			_data._room = 0;
			
		}
		else
		{
			_data._popupMessage = "Login failed."; // if you change the value of this string then you need to change it also at client.
		}
	
		_db_delete.user_at_front_door_queue(_data._username);
		
		// disconnect the client if the server is in maintenance mode. only the admin can login.
		var _row = _db_select.is_maintenance();
		
		if (Std.string(_row._maintenance[0]) == "true" && _data._username != "admin")
		{
			// at client isLoggingIn event, this will disconnect the user and display a message that the server is in maintenance.
			_data._popupMessage = "";
		}
		
		_server.send_to_handler(_data);
		
	}
	
	private function player_game_state_value_update(_data:Dynamic):Void
	{
		// if true then we are at the game room.
		if (_data._username != null
		&&	_data._gamePlayersValues != null)
		{		
			for (i in 0...4)
			{
				// find the username is this var.
				if (_data._usernamesStatic[i] != ""
				&&	_data._username == _data._usernamesStatic[i])
				{
					// update the game state for this player.
					_server.player_game_state_value_username[_data._room][i] = _data._usernamesStatic[i];
					_server.player_game_state_value_data[_data._room][i] = _data._gamePlayersValues[i];
				}
			}
		}

	}
	
	/**************************************************************************
	* EVENT LOAD HOUSE DATA.
	* players house where they buy items, place items in room and vote for best house for prizes.
	*/
	private function houseLoad(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("House Load", _data.id, _data._username, _data); // logs.

		var row = _db_select.user_all_at_house(_data._username);

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
		
		_server.send_to_handler(_data);
	}
	
	/******************************
	* EVENT EMAIL ADDRESS VALIDATE
	* verifies if the email address is valid. validation code could be sent to a user's email address.
	* _dataAccount
	*/
	private function emailAddressValidate(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Email Address Validate", _data.id, _data._username, _data); // logs.
		
		if (_data._send_email_address_validation_code == true)
		{
			// create the email validation code.
			var _validation_code = Functions.create_code();
			
			_db_update.user_validation_code_at_users(_data._username, _data._email_address, _validation_code);
			
			// send the email address validation code to the new requested email address.
			var _send_mail = new EasyMail();
			_send_mail.compose("K Board Games: Validate Email Address.", "", 
			'<p>Welcome to <a href="kboardgames.com">K Board Games.</a></p>

<p>In compliance with the Canadian Anti-Spam Legislation, ' + Reg._domain + ' is requesting your response that you want your email address validated.</p><p>A user with a validated email address can subscribe to chess tournament move piece notices. To validate your email address, click <a href= "' + Reg._domain + '/server/emailAddressValidate.php?u=' + _data._username + '&v=' + _validation_code + '">here</a>.</p>

<p>Just ignore this email if you have not requested it or you are not interested in chess tournament play.</p>');
			_send_mail.send(Reg._smtpFrom, "admin@kboardgames.com", Reg._smtpHost, Reg._smtpPort, Reg._smtpUsername, Reg._smtpPassword);
			
		}
		
		_server.send_to_handler(_data);

	}
	
	/**************************************************************************
	* EVENT SAVE HOUSE DATA.
	*/
	private function houseSave(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("House Save", _data.id, _data._username, _data); // logs.
			
		_db_update.user_house_data_at_house(_data._username, _data._sprite_number, _data._sprite_name, _data._items_x, _data._items_y, _data._map_x, _data._map_y, _data._is_item_purchased, _data._item_direction_facing, _data._map_offset_x, _data._map_offset_y, _data._item_is_hidden, _data._item_order, _data._item_behind_walls, _data._floor, _data._wall_left, _data._wall_up_behind, _data._wall_up_in_front, _data._floor_is_hidden, _data._wall_left_is_hidden, _data._wall_up_behind_is_hidden, _data._wall_up_in_front_is_hidden);
	
	}
		
	/******************************
	* EVENT PLAYER MOVE TIME REMAINING
	* Gets the current move timer for the player that is moving. the value is sent to the other clients so that they have the update value.
	*/
	private function playerMoveTimeRemaining(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		_server.broadcast_everyone(_data);
	}

	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	*/
	private function playerMoveId0(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Player Move Id 0", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);
		
	}

	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	*/
	private function playerMoveId1(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Player Move Id 1", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}	
	
	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	*/
	private function playerMoveId2(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Player Move Id 2", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}
	
	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	* RegTypedef._dataGame3._gameUnitNumberNew
	*/
	private function playerMoveId3(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Player Move Id 3", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}	
	
	/******************************
	* EVENT PLAYER MOVE
	* the client sends a player move event.
	*/
	private function playerMoveId4(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Player Move Id 4", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}

	/****************************************************************************
	* EVENT DAILY QUESTS
	* complete these daily quests for rewards.
	* _dailyQuestsState
	*/
	private function dailyQuests(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Daily Quests", _data.id, _data._username, _data); // logs.
		
		var rset = _db_select.user_daily_quests(_data._username);
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
		_db_update.daily_quests_rewards(_data._username, _data._rewards);
		
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
			
			_db_delete.then_recreate_user_data_daily_quests(_data._username);
		}
		
		_server.send_to_handler(_data);

	}
	
	/****************************************************************************
	* EVENT DAILY QUESTS CLAIM
	* At the client the daily quest reward was given to player. this event saves the _reward var so that a second reward of the same type will not be given to player.
	* _dailyQuestsState
	*/
	private function dailyQuestsClaim(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Daily Quests Claim", _data.id, _data._username, _data); // logs.
		_db_update.daily_quests_rewards(_data._username, _data._rewards);
	}
	
	/****************************************************************************
	* EVENT DAILY REWARD SAVE
	* A daily reward has been claimed. now save the reward(s) to the database.
	* _dataStatistics
	*/
	private function dailyRewardSave(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Daily Reward Save", _data.id, _data._username, _data); // logs.
		_db_update.daily_reward_at_statistics(_data._username, _data._experiencePoints, _data._houseCoins, _data._creditsTotal);
	}
	
	/******************************
	* EVENT GET STATISTICS WIN LOSS DRAW
	* Win - Draw - Loss Stats for player(s).
	* _dataPlayers
	*/
	private function getStatisticsWinLossDraw(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Get Statistics Win Loss Draw", _data.id, _data._username, _data); // logs.
		
		// clear data. we will populate it down below.
		for (i in 0...4)
		{
			_data._usernamesDynamic[i] = "";
			_data._gamesAllTotalWins[i] = 0;
			_data._gamesAllTotalLosses[i] = 0;
			_data._gamesAllTotalDraws[i] = 0;
		}
		
		// get all users in waiting room.
		var rset = _db_select.room_by_timestamp_asc_at_room_data(_data._room);
		
		// these users are in room. for a 2 player game, only the first two of these vars will not be empty.
		var _user1 = rset._user[0];
		var _user2 = rset._user[1];
		var _user3 = rset._user[2];
		var _user4 = rset._user[3];

		
		var rset2 = _db_select.user_all_at_statistics(Std.string(_user1));
		
		// if username exists in database...
		// put those stats into the _data to send to client.
		if (_user1 != null)
		{
			_data._usernamesDynamic[0] = Std.string(_user1);
			
			_data._gamesAllTotalWins[0] = rset2._gamesAllTotalWins[0];
			_data._gamesAllTotalLosses[0] = rset2._gamesAllTotalLosses[0];
			_data._gamesAllTotalDraws[0] = rset2._gamesAllTotalDraws[0];
			
			var rset3 = _db_select.user_avatar_from_statistics(Std.string(_user1));
			_data._avatarNumber[0] = Std.string(rset3._avatarNumber[0]);
			
			if (_data._avatarNumber[0] == "") _data._avatarNumber[0] = "0.png";
		}	
		
		if (_user2 != null)
		{
			var rset2 = _db_select.user_all_at_statistics(Std.string(_user2));
			
			// if username exists in database...
			// put those stats into the _data to send to client.
			_data._usernamesDynamic[1] = Std.string(_user2);
			
			_data._gamesAllTotalWins[1] = rset2._gamesAllTotalWins[0];
			_data._gamesAllTotalLosses[1] = rset2._gamesAllTotalLosses[0];
			_data._gamesAllTotalDraws[1] = rset2._gamesAllTotalDraws[0];
			
			var rset3 = _db_select.user_avatar_from_statistics(Std.string(_user2));
			_data._avatarNumber[1] = Std.string(rset3._avatarNumber[0]);
			
			if (_data._avatarNumber[1] == "") _data._avatarNumber[1] = "0.png";

		}
		
		
		if (_user3 != null)
		{
			var rset2 = _db_select.user_all_at_statistics(Std.string(_user3));
			
			// if username exists in database...
			// put those stats into the _data to send to client.
			_data._usernamesDynamic[2] = Std.string(_user3);
							
			_data._gamesAllTotalWins[2] = rset2._gamesAllTotalWins[0];
			_data._gamesAllTotalLosses[2] = rset2._gamesAllTotalLosses[0];
			_data._gamesAllTotalDraws[2] = rset2._gamesAllTotalDraws[0];
			
			var rset3 = _db_select.user_avatar_from_statistics(Std.string(_user3));
			_data._avatarNumber[2] = Std.string(rset3._avatarNumber[0]);
			
			if (_data._avatarNumber[2] == "") _data._avatarNumber[2] = "0.png";

		}
		
		
		if (_user4 != null)
		{
			var rset2 = _db_select.user_all_at_statistics(Std.string(_user4));
			
			// if username exists in database...
			// put those stats into the _data to send to client.
			_data._usernamesDynamic[3] = Std.string(_user4);
							
			_data._gamesAllTotalWins[3] = rset2._gamesAllTotalWins[0];
			_data._gamesAllTotalLosses[3] = rset2._gamesAllTotalLosses[0];
			_data._gamesAllTotalDraws[3] = rset2._gamesAllTotalDraws[0];
			
			var rset3 = _db_select.user_avatar_from_statistics(Std.string(_user4));
			_data._avatarNumber[3] = Std.string(rset3._avatarNumber[0]);
			
			if (_data._avatarNumber[3] == "") _data._avatarNumber[3] = "0.png";

		}
		
		// the "room waiting" calls this event every some many ticks, so here is a good time to update the players move order.
		var rset = _db_select.room_by_timestamp_asc_at_room_data(_data._room);
		
		var _num:Int = 0;
		for (i in 0..._data._usernamesDynamic.length)
		{
			_num += 1;
			_db_update.move_number_dynamic_at_room_data(_data._usernamesDynamic[i], _num);
			_data._moveNumberDynamic[i] = _num;
		}
		
		// chat, score and stuff that is not a win, lose or draw data is passed to the server.
		_server.broadcast_in_room(_data);
		
	}

	/******************************
	* EVENT GET STATISTICS All
	* Example, experience points, credits, win - draw - loss, all stats.
	* _dataStatistics
	*/
	private function getStatisticsAll(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Get Statistics All", _data.id, _data._username, _data); // logs.
		
		var rset = _db_select.user_all_at_statistics(_data._username);

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
		
		_server.send_to_handler(_data);
		
	}
	
	/******************************
	* EVENT PLAYER HAS ENTERED THE ROOM, SO CHANGE THE ROOMSTATE VALUE.
	* _dataMisc
	*/
	private function greaterRoomStateValue(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Greater RoomState Value", _data.id, _data._username, _data); // logs.
		
		_data._roomState = _roomState;
		
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
			
			var rset = _db_select.user_all_by_timestamp_at_room_data(_data._room);
		
		
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
				
				// set rated game value for room if user is not in game room.
				if (_data._roomHostUsername[_data._room] == _data._username
				&&	_data._userLocation < 3)
					Main._rated_game[_data._room] = _data._rated_game[_data._room];
				
				if (rset._userLocation[i] == 2
				 && Std.string(rset._user[i].toString) != 
					Std.string(_data._username)
				)
				{
					// for all other users in the room...
					_data._roomPlayerLimit[_data._room] = rset._playerLimit[i];
					_data._rated_game[_data._room] = Main._rated_game[_data._room];
				}
				
			}
			
			
			// create room.
			if (_found == true || _data._roomState[_data._room] == 0)
			{
				_data._roomState[_data._room] = 1;
				_data._userLocation = 1;
			}				
			
			// if false, then a user is entering a room. determine if user should enter a room.
			
			// roomState value of 2
			else if (_data._roomState[_data._room] < 3 || _data._roomPlayerLimit[_data._room] == 0) // roomState of 2 and a limit of 2 does not work so we plus 1 to the limit.
			{
				//_data._roomState[_data._room] += 1;								
				
				var rset2 = _db_select.user_all_at_room_data(_data._username);
								
				_data._userLocation = 2;
				
				if (_data._roomPlayerLimit[_data._room] > 0)
					_roomPlayerLimit[_data._room] = _data._roomPlayerLimit[_data._room];

				for (i in 0...4)
				{
					// reset this data back to 0 before a new game starts.
					_server.player_game_state_value_username[_data._room][i] = "";
					_server.player_game_state_value_data[_data._room][i] = 0;
				}
				
			}
		}	
			
		if (_data._spectatorWatching == false)
		{
			_db_update.data_for_room_at_room_data(_data._room, _data._roomState[_data._room], _data._userLocation, _data._roomPlayerLimit[_data._room]);
		}
		
		else
		{
			_db_update.user_at_room_data(_data._username, _data._roomState[_data._room], _data._userLocation, _data._room, _data._roomPlayerLimit[_data._room], _data._roomGameIds[_data._room], _data._allowSpectators[_data._room]);
		}
		
		// when entering the game room, get all usernames from the database. this is needed for the server on disconnect event, so that correct data can be sent to the rest of the players at game room at the time the player disconnects.
		if (_data._userLocation == 3)
		{
			_usernames_static[_data._room][0] = "";
			_usernames_static[_data._room][1] = "";
			_usernames_static[_data._room][2] = "";
			_usernames_static[_data._room][3] = "";
			
			var rset3 = _db_select.user_all_by_timestamp_at_room_data(_data._room);
			
			if (rset3._user[0] != null) 
				_usernames_static[_data._room][0] = Std.string(rset3._user[0]);
				
			if (rset3._user[1] != null) 
				_usernames_static[_data._room][1] = Std.string(rset3._user[1]);
			
			if (rset3._user[2] != null) 
				_usernames_static[_data._room][2] = Std.string(rset3._user[2]);
			
			if (rset3._user[3] != null) 
				_usernames_static[_data._room][3] = Std.string(rset3._user[3]);
		}
		
		
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT PLAYER HAS LEFT THE ROOM, SO CHANGE THE ROOMSTATE VALUE.
	* _dataMisc
	*/
	private function lesserRoomStateValue(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Lesser RoomState Value", _data.id, _data._username, _data); // logs.
		
		var _room = _data._room;
		
		var _count = _db_select.count_room_for_room_state_at_room_data(_room);
		
		if (_data._spectatorWatching == false)
		{
			if (_data._roomPlayerCurrentTotal[_room] == 1) 
			{					
				_roomPlayerLimit[_room] = _data._roomPlayerLimit[_room] = 0;
			}
							
			// if ended a game where there are two or more players still playing, minus one from the total players playing so that the total players are the correct count at that lobby room.
			else if (_data._roomPlayerLimit[_room] > 2
			&&  _data._roomState[_room] == 8)
				_roomPlayerLimit[_room] = Std.int(_data._roomPlayerLimit[_room] -= 1);
				
			
				// if true then there is not enought players to play a game. remove all players from room at database so that at lobby a player can enter that room.
			//if (_data._roomPlayerCurrentTotal[_room] == 2) 
					
		}
		
		//_data._roomState = _roomState;
		
		if (_data._spectatorWatching == false)
		{
			// this removes host from room by deleting any user that exists at room at this database table.
			if (_count <= 2)
			{
				// delete host only if game has endded and no one else has created or is creating a room.
				if (_roomState[_data._room] < 1
				||  _roomState[_data._room] == 8)
				{
					_roomHostUsername[_data._room] = _data._roomHostUsername[_data._room] = "";	
				_gid[_data._room] = _data._gid[_data._room] = "";
					
					_db_delete.room_at_who_is_host(_data._room);
				}
				
				// if player is hosting a room then remove player because the remove deleteIsHostRoom might fail.
				_db_delete.user_at_who_is_host(_data._username);
				
			}
			
			if (_data._roomState[_data._room] == 8) 
			{
				//if (_count == 2) _db_delete.room_from_room_data_data._room);
				
				// when value is true, there are 2 or less players.
				if (_count <= 2)
				{
					_data._roomState[_data._room] = 0;
					//_data._roomGameIds[_data._room] = -1; // this gets set at this client event.
					_data._allowSpectators[_data._room] = 0;					
					_roomPlayerCurrentTotal[_data._room] = 0;
					
					// if two or less players, and one player is leaving room, then there is not enough players to play game. set all data to zero for the playing that where playing a game.
					_db_update.most_to_zero_for_room_at_room_data(_data._room, _data._roomState[_data._room], _data._userLocation, _data._roomPlayerLimit[_data._room]);
					
					_data._userLocation = 0;
				}
				
				else
				{
					_db_update.user_all_to_zero_at_room_data(_data._username);
					
					// if here then the only some data needs to be set back to default.
					_db_update.player_limit_at_room_data(_data._username, _data._room, _data._roomPlayerLimit[_data._room]);
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
					//_data._roomState[_data._room] -= 1; 
					_roomPlayerCurrentTotal[_data._room] -= 1;
					
					// else if this is true then user has a roomState value of 3, user is the only player in that room. that user roomState will be set to 0 because user is leaving. 
					if (_data._roomState[_data._room] == 1) 
					{					
						_data._roomGameIds[_data._room] = -1;
						_data._roomState[_data._room] = 0;	
					}
					
					// if player has a roomState of 4 and another player left that room, this will set all roomState for that room to a value of 3.
					_db_update.room_with_room_state_at_room_data(_data._roomState[_data._room], _data._room);
					
					_data._userLocation = 0;
											
					// saves room state to MySQL which is used for online players list.
					_db_update.all_for_user_at_room_data(_data._username, _data._roomState[_data._room], _data._userLocation, _data._room, _data._roomPlayerLimit[_data._room], _data._roomGameIds[_data._room], _data._allowSpectators[_data._room]);
					_data._room = 0;
				}
				
			}
			
		}
		
		// now set these values for user because user is returning to lobby.
		_data._roomState[_room] = 0;
		_roomPlayerLimit[_room] = _data._roomPlayerLimit[_room] = 0;
		
		_data._userLocation = 0;
		_data._room = 0;
		
		_db_update.user_all_to_zero_at_room_data(_data._username);
		
		// unlock the room.
		_data._roomLockMessage = "";	
		_db_delete.user_at_room_lock(_data._username, _room);
		
		_server.broadcast_everyone(_data);
	}

	private function isRoomLocked(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Is Room Locked", _data.id, _data._username, _data); // logs.
		
		var _rs = _db_select.room_at_room_lock(_data._room);
		
		if (_rs._room.length == 0
		||  _data._roomCheckForLock[_data._room] == 0)
		{
			_data._roomLockMessage = "";
			
			// lock the room.
			_db_insert.save_is_locked_for_user_at_room_lock(_data._username, _data._room);
		}
		
		else _data._roomLockMessage = "Someone beat you to this room. This room is locked until server sends room data to that person.";
		
		_server.send_to_handler(_data);
	}
	
	/******************************
	* EVENT WAITING ROOM SETS HOST OF THE ROOM.
	* _dataMisc
	*/
	private function isHost(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		// dump the complete _data var.						
		Functions.userLogs("Is Host", _data.id, _data._username, _data); // logs. // do not use
	
		if (_data._roomState[_data._room] > 1 && _data._roomState[_data._room] < 8)
		{
			_db_insert.room_and_user_at_who_is_host(_data._username, _data._gid[_data._room], _data._room);
			_roomHostUsername[_data._room] = _data._username;
			_gid[_data._room] = _data.id;
			_data._triggerEvent = "";
		}
	}	

	/******************************
	* EVENT SET ROOM DATA. SAVE ROOM DATA TO DATABASE.\
	* _dataMisc
	*/
	private function setRoomData(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Set Room Data", _data.id, _data._username, _data); // logs.
		
		if (_data._roomLockMessage == "")
		{
			var room = _data._room;
			
			var _bool = _db_select.count_for_room_at_who_is_host(_data._room);
			
			if (_bool == false && _data._userLocation == 1) // this value will be changed to 2 later down below. remember, this event plus 1 to userLocation. when entering room, which is true here, then save the host of the room to database.
			{
				_db_insert.room_and_user_at_who_is_host(_data._username, _data._gid[_data._room], _data._room);
			}
				
			if (_data._roomState[_data._room] > 0 && _data._roomState[_data._room] < 8) _db_update.all_for_user_at_room_data(_data._username, _data._roomState[_data._room], _data._userLocation, _data._room, _data._roomPlayerLimit[_data._room], _data._roomGameIds[_data._room], _data._allowSpectators[_data._room]);
			
			// update this user's online list that has IP, host, room state information for this user.
			_db_update.user_at_logged_in_users(_data._username, _data._roomState[_data._room]);
						
			// set room values to be used at the "Get Room Data" event at client.
			_roomState[_data._room] = _data._roomState[_data._room];
			_roomGameIds[_data._room] = _data._roomGameIds[_data._room];
			_allowSpectators[_data._room] = _data._allowSpectators[_data._room];
			_roomHostUsername[_data._room] = _data._roomHostUsername[_data._room];
			if (_data._username == _data._roomHostUsername[_data._room])
				_roomPlayerLimit[_data._room] = _data._roomPlayerLimit[_data._room];
			// not host so get room limit from the data that host created.
			else _data._roomPlayerLimit[_data._room] = _roomPlayerLimit[_data._room];
			
			_gid[_data._room] = _data._gid[_data._room];
		}
		
		_server.send_to_handler(_data);

	}
		
	/******************************
	* EVENT GET ROOM STATE. LOAD ROOM DATA FROM DATABASE.
	* USED AT LOBBY TO GET ROOM DATA.
	* _dataMisc
	*/
	private function getRoomData(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Get Room Data", _data.id, _data._username, _data); // logs.
		
		var _rs = _db_select.room_at_room_lock(_data._room);
		
		if (_data._roomLockMessage == "")
		{
			// get data from all users online. the data will populate roomState so that everyone at lobby and waiting room will have the correct state of a room.
			var rows = _db_select.all_by_desc_at_room_data();
			
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
				
			var ii:Int = 0;
			
			while (rows._room[ii] != null)
			{
				_roomState[rows._room[ii]] = rows._roomState[ii];
				
				// set the room limit text for lobby.
				_roomPlayerLimit[rows._room[ii]] = rows._playerLimit[ii];
				
				// set the text of the game currently set to room.
				_roomGameIds[rows._room[ii]] = rows._gameId[ii];
				_allowSpectators[rows._room[ii]] = rows._allowSpectators[ii];
		
				ii += 1;
			}
		
			// get every host of rooms.
			var erows = _db_select.all_at_who_is_host();
			
			for (i in 0...erows._room.length)
			{
				_roomHostUsername[erows._room[i]] = Std.string(erows._user[i]);
				_gid[erows._room[i]] = Std.string(erows._gid[i]);
			}
			
			_data._roomState = _roomState;
			_data._roomGameIds = _roomGameIds;			
			_data._roomPlayerLimit = _roomPlayerLimit;
			_data._allowSpectators = _allowSpectators;
			_data._roomHostUsername = _roomHostUsername;
			_data._gid = _gid;
			_data._rated_game = Main._rated_game;
			
			// get all players in room but not playing a game. the list is used to determine if player can join room.
			var rset = _db_select.waiting_room_by_timestamp_at_room_data();		
			
			// clear list.
			for (i in 0..._roomPlayerCurrentTotal.length)
			{
				_roomPlayerCurrentTotal[i] = 0;
			}
			
			for (i in 0... _server._room_total) // rooms
			{
				var _count = _db_select.count_room_at_room_data(i);
					
				// if playing against the cpu, set the total player in that room to equal _data._roomPlayerLimit var. this is needed since the _db_select.count_room_at_room_data above will only find 1 player in the room.
				if (_data._roomState[i] == 8 && _count == 1) _roomPlayerCurrentTotal[i] = _data._roomPlayerLimit[i];
				else _roomPlayerCurrentTotal[i] = _count;
			}	
			
			_data._roomPlayerCurrentTotal = _roomPlayerCurrentTotal;
			
			var cset = _db_select.user_all_at_room_data(_data._username);
				
			if (Std.string(cset._room[0]) == "0") 
			{
				// player left game so set the isGameFinished var so that player can get an invite.
				_db_update.is_game_finished_for_user_at_room_data(_data._username, true, false);
			}
			
			
		}
		
		/*
		//---------------- these cpu bots will host room a and b when there are no players in those rooms.
		// signature game - 2 players.
		_data._roomState[1] = _roomState[1] = 2;
		_data._roomGameIds[1] = _roomGameIds[1] = 4;
		_data._roomPlayerLimit[1] = _roomPlayerLimit[1] = 2;
		_data._allowSpectators[1] = _allowSpectators[1] = 0;
		_data._roomHostUsername[1] = _roomHostUsername[1] = Reg._cpu_host_name1;
		_data._roomPlayerCurrentTotal[1] = 1;
		
		// chess.
		_data._roomState[2] = _roomState[2] = 2;	
		_data._roomGameIds[2] = _roomGameIds[2] = 1;
		_data._roomPlayerLimit[2] = _roomPlayerLimit[2] = 2;
		_data._allowSpectators[2] = _allowSpectators[2] = 0;
		_data._roomHostUsername[2] = _roomHostUsername[2] = Reg._cpu_host_name2;
		_data._roomPlayerCurrentTotal[2] = 1;
		*/
		
		if (Reg._dummyData == true
		&&	_roomState[0] == 0)
		{
			DummyData.server_data();
			_data._dummy_data_in_use = true;
		}
		
		_server.send_to_handler(_data);

	}
	
	/******************************
	* EVENT ROOM LOCK 1.
	* USED AT LOBBY TO DELAY THE SECOND PLAYER FROM ENTERING INTO THE ROOM UNTIL THE ROOM LOCK IS REMOVED FROM THAT ROOM. THIS EVENT ONLY SENDS _data TO CLIENT. AT THAT CLIENT A VAR IS TRIGGERED TO UPDATE THE ROOMS TEXT AND THEN CLIENT SENDS TO ROOM LOCK 2 THEN THAT EVENT AT SERVER REMOVES THE LOCK.
	* _dataMisc
	*/
	private function roomLock1(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		_server.broadcast_everyone(_data);
	}	
	
	/******************************
	* EVENT ROOM LOCK 1.
	* THIS EVENT ONLY REMOVES THE ROOM LOCK.
	* _dataMisc
	*/
	private function roomLock2(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		_data._roomLockMessage = "";
		
		// unlock the room.
		_db_delete.user_at_room_lock(_data._username, _data._room);
	}
	
	/******************************
	* EVENT GET ROOM PLAYERS
	*/
	private function getRoomPlayers(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Get Room Players", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT CHAT.
	* chat message of the player.
	* _dataMisc
	*/
	private function chatSend(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Chat Send", _data.id, _data._username, _data); // logs.
		
		var _asterisk = "*************************************************************";
		
		// this is needed so that words that ends with " " are searched. without this code, part of a word could contain a restricted word.
		_data._chat += " "; // add this to the end of the string.
			
		for (i in 0 ... RestrictedWords.list.length)
		{			
			_data._chat = StringTools.replace(_data._chat, RestrictedWords.list[i] + " ", _asterisk.substr(0, RestrictedWords.list[i].length));
			
		}
		
		// remove " " from the end of the string.
		_data._chat.substr(0, _data._chat.length - 1);
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT DRAW OFFER
	* offer draw so that no one wins and loses a game. its a tie.
	*/
	private function drawOffer(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Draw Offer", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT DRAW ANSWERED AS
	* reply to the offer draw so that no one wins and loses a game. its a tie.
	*/
	private function drawAnsweredAs(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Draw Answered As", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT RESTART OFFER.
	* offer to restart and play another game.
	*/
	private function restartOffer(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Restart Offer", _data.id, _data._username, _data); // logs.

		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT RESTART ANSWERED AS
	* reply to the restart a chess game offer so that another game can be played.
	*/
	private function restartAnsweredAs(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Restart Answered As", _data.id, _data._username, _data); // logs.
		
		if (_data._restartGameAnsweredAs == true)
		{
			var _isGameFinished:Bool = false;
			var _is_spectator_watching:Bool = _data._spectatorWatching;
			
			_db_update.is_game_finished_for_room_at_room_data(_data._room, _isGameFinished, _is_spectator_watching);
		}
		
		_server.broadcast_in_room(_data);		
	}
	
	/******************************
	* EVENT 
	* currently this event is for the signature game. a player sends a trade unit to another player and this event is for that other player receiving the trade.
	*/
	private function tradeProposalOffer(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Trade Proposal Offer", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}
	
	/******************************
	* EVENT 
	* currently this event is for the signature game. replied to the trade request.
	*/
	private function tradeProposalAnsweredAs(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Trade Proposal Answered As", _data.id, _data._username, _data); // logs.
		
		_server.broadcast_in_room(_data);		
	}
	
	/******************************
	* EVENT ONLINE PLAYER OFFER INVITE.
	* offer an invite to a player at the lobby.
	*/
	private function onlinePlayerOfferInvite(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Online Player Offer Invite", _data.id, _data._username, _data); // logs.
		_server.broadcast_everyone(_data);
	}
	
	/******************************
	* EVENT GAME MESSAGE. NOT A MESSAGE BOX.
	*/
	private function gameMessageNotSender(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Game Message Not Sender", _data.id, _data._username, _data); // logs

		_server.broadcast_in_room(_data);		
	}
	
	/******************************
	* A MESSAGE BOX MESSSGE SENT TO ALL SPECTATORS WATCHING NOT SPECTATORS PLAYING.
	*/
	private function gameMessageBoxForSpectatorWatching(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Game Message Box For Spectator Watching", _data.id, _data._username, _data); // logs

		_server.broadcast_in_room(_data);	}

	/******************************
	* EVENT MESSAGE KICK
	* kick: player cannot play for a while because admin kicked player.
	*/
	private function messageKick(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Message Kick", _data.id, _data._username, _data); // logs // do not use.
		
		var _user:String = "";
		var _message:String = "";
		var _minutesTotal:String = "";
		var _timestamp:String = "";
		
		var rset = _db_select.limit_120_kicked_users();

		if (rset._user.length > 0)
		{
			for ( i in 0...rset._user.length)
			{
				// populate all data from the MySQL table. separate each element in these strings with a comma. later, the populated data will be added to arrays. if kicked time is remaining then those data will be passed to the client and the client will determine if a kicked message should be displayed.
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
				_server.broadcast_in_room(_data);
			}
		}
	}

	
	private function removeKickedFromUser(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Remove Kicked From User", _data.id, _data._username, _data); // logs
		_db_update.user_set_is_kicked_at_users(_data._username);
	}
	
	/******************************
	* EVENT MESSAGE BAN
	* ban: admin stopped player from playing forever.
	*/
	private function messageBan(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		// TODO uncomment this. it is commented to see if the type command outputs when error at server console happens.
		//Functions.userLogs("Message Ban", _data.id, _data._username, _data); // logs
		
		var _user:String = "";
		var _message:String = "";
		var _ip:String = "";
		
		var rset = _db_select.limit_120_banned_users();
		
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
				_server.broadcast_in_room(_data);
			}
		}
	}

	/******************************
	* EVENT GAME ROOM
	* this event enters the game room.
	* _dataMisc
	*/
	private function enterGameRoom(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Enter Game Room", _data.id, _data._username, _data); // logs
		
		var _isGameFinished:Bool = true;
		var _is_spectator_watching:Bool = _data._spectatorWatching;
			
		_db_update.is_game_finished_for_room_at_room_data(_data._room, _isGameFinished, _is_spectator_watching);
			
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT GAME WIN
	* this player wins the game.
	* _dataPlayers
	*/
	private function gameWin(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Game Win", _data.id, _data._username, _data); // logs
		_server.send_to_handler(_data);
	}

	/******************************
	* EVENT GAME LOSE
	* this player loses the game.
	* _dataPlayers
	*/
	private function gameLose(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		// at server, do not use "_handler.send" because more than one player can lose game.
		Functions.userLogs("Game Lose", _data.id, _data._username, _data); // logs
		
		_server.broadcast_in_room(_data);		
	}
	
	/******************************
	* EVENT GAME WIN
	* this player wins the game.
	* _dataPlayers
	*/
	private function gameWinThenLoseForOther(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Game Win Then Lose For Other", _data.id, _data._username, _data); // logs
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT GAME LOSE
	* this player loses the game.
	* _dataPlayers
	*/
	private function gameLoseThenWinForOther(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Game Lose Then Win For Other", _data.id, _data._username, _data); // logs
		
		_server.broadcast_in_room(_data);		
	}
	
	/******************************
	* EVENT GAME DRAW
	* this game ends in a tie.
	* _dataPlayers
	*/
	private function gameDraw(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		// at server, do not use "_handler.send" because more than one player can be in a draw.
		Functions.userLogs("Game Draw", _data.id, _data._username, _data); // logs
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT SAVE WIN STATS
	* save the win stats of the player that was sent here and then return that value to the cilent.
	* _dataPlayers
	*/
	private function saveWinStats(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Save Win Stats", _data.id, _data._username, _data); // logs
		
		var _isGameFinished:Bool = true;
		var _is_spectator_watching:Bool = _data._spectatorWatching;
			
		_db_update.is_game_finished_for_room_at_room_data(_data._room, _isGameFinished, _is_spectator_watching);
		// _playersState.
		// put those stats into the _data to send to client.
		if (_data._spectatorWatching == false)
		{
			for (i in 0...4)
			{
				if (_data._username == _data._usernamesStatic[i] 
				&&  _data._gamePlayersValues[i] == 1
				&&  _data._spectatorPlaying == false)
				{
					_data._gamesAllTotalWins[i] += 1;
										
					// this is the time that the player played for. This var is passed to mysql so that the shortest_time_game_played and longest_time_game_played stats can be saved but only if conditions are met.
					var _game_time_played_in_seconds = _data._timeTotal - _data._moveTimeRemaining[i]; 	
					
					// send that username to mysql to save the stats.
					if (Main._rated_game[_data._room] == 1)
						_db_update.win_at_statistics(_data._gameId, _data._username, Std.int(_game_time_played_in_seconds)); 
					
					_db_update.game_players_values_at_room_data(_data._username, 0);
					
					// this checks if there is an event to give on this day.
					// see the doEvent() function. 
					eventsWin(_data, _data._username);
				} 
			}
		}
		
		player_game_state_value_update(_data);
		
		_server.send_to_handler(_data);
	}

	/******************************
	* EVENT SAVE LOSE STATS
	* save the lose stats of the player that was sent here and then return that value to the cilent.
	* _dataPlayers
	*/
	private function saveLoseStats(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Save lose Stats", _data.id, _data._username, _data); // logs
		
		_db_update.is_game_finished_for_user_at_room_data(_data._username, true, _data._spectatorWatching);
		 
		if (_data._spectatorWatching == false)
		{
			var user:String = _data._username;

			// put those stats into the _data to send to client.
			for (i in 0...4)
			{
				if (_data._username == _data._usernamesDynamic[i]
				&&  _data._spectatorPlaying == false)
				{			
					_data._gamesAllTotalLosses[i] += 1;
					
					// this is the time that the player played for. This var is passed to mysql so that the shortest_time_game_played and longest_time_game_played stats can be saved but only if conditions are met.
					var _game_time_played_in_seconds = _data._timeTotal - _data._moveTimeRemaining[i]; 	
					
					// send that username to mysql to get the stats.
					if (Main._rated_game[_data._room] == 1)
						_db_update.lose_at_statistics(_data._gameId, _data._username, Std.int(_game_time_played_in_seconds));
					
					_db_update.game_players_values_at_room_data(_data._username, 0);
					
					// this checks if there is an event to give on this day.
					// see the doEvent() function.
					eventsLose(_data, _data._username);
				} 
			}
		}
		
		player_game_state_value_update(_data);
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT SAVE WIN STATS
	* save the win stats of the player that was sent here and then return that value to the cilent.
	* only a 2 player game should use this event.
	* _dataPlayers
	*/
	private function saveWinStatsForBoth(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Save Win Stats For Both", _data.id, _data._username, _data); // logs 
		
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
					
					if (Main._rated_game[_data._room] == 1)
						_db_update.win_at_statistics(_data._gameId, _data._usernamesStatic[i], Std.int(_game_time_played_in_seconds));
					
					_db_update.game_players_values_at_room_data(_data._username, 0);					
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
						if (Main._rated_game[_data._room] == 1)
							_db_update.lose_at_statistics(_data._gameId, _data._usernamesStatic[i], Std.int(_game_time_played_in_seconds));
						
						_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], 0);
						
						eventsLose(_data, _data._usernamesStatic[i]);
						
						_stop = true;
					}
					
					if (_stop == true) break;
				}
			}
		}
		
		player_game_state_value_update(_data);
		
		_server.broadcast_in_room(_data);		
	}

	/******************************
	* EVENT SAVE LOSE STATS
	* save the lose stats of the player that was sent here and then return that value to the cilent.
	* only a 2 player game should use this event.
	* playersData.
	*/
	private function saveLoseStatsForBoth(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Save Lose Stats For Both", _data.id, _data._username, _data); // logs
		// those are used to load, save and calculate the chess elo ratings on this game that ended.
		var _p1_username = "";
		var _p2_username = "";
		
		// the value of this chess elo var is populated from the data
		var _p1_chess_elo_rating:Float = 0;
		var _p2_chess_elo_rating:Float = 0;
		
		var _isGameFinished:Bool = true;
		var _is_spectator_watching:Bool = _data._spectatorWatching;
			
		_db_update.is_game_finished_for_room_at_room_data(_data._room, _isGameFinished, _is_spectator_watching);
			
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
					var _game_time_played_in_seconds = _data._timeTotal - Std.int(_data._moveTimeRemaining[i]); 	
					
					if (Main._rated_game[_data._room] == 1)
						_db_update.lose_at_statistics(_data._gameId, _data._username, Std.int(_game_time_played_in_seconds));
					
					_db_update.game_players_values_at_room_data(_data._username, 0);
					
					eventsLose(_data, _data._username);
					
					// load the elo rating for player whom lost the game of chess.
					if (_data._gameId == 1)
					{
						_p2_username = _data._username;
						
						var rset = _db_select.user_elo_rating_from_statistics(_p2_username);
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
						if (Main._rated_game[_data._room] == 1)
							_db_update.win_at_statistics(_data._gameId, _data._usernamesStatic[i], Std.int(_game_time_played_in_seconds));
						
						_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], 0); 
						
						eventsWin(_data, _data._usernamesStatic[i]);
						
						// load the elo rating for player whom lost the game of chess.
						if (_data._gameId == 1)
						{
							_p1_username = _data._usernamesStatic[i];
							
							var rset = _db_select.user_elo_rating_from_statistics(_p1_username);
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
				Functions.EloRating(_p1_username, _p2_username, _p1_chess_elo_rating, _p2_chess_elo_rating, _chess_elo_k, _chess_did_player1_win);				
			}
		}
		
		player_game_state_value_update(_data);

		_server.broadcast_in_room(_data);
	}

	/******************************
	* EVENT SAVE DRAW STATS
	* save the draw stats of the player that was sent here and then return that value to the cilent.
	* _dataPlayers
	*/
	private function saveDrawStats(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Save Draw Stats", _data.id, _data._username, _data); // logs
		
		var _isGameFinished:Bool = true;
		var _is_spectator_watching:Bool = _data._spectatorWatching;
			
		_db_update.is_game_finished_for_room_at_room_data(_data._room, _isGameFinished, _is_spectator_watching);
			
		if (_data._spectatorWatching == false)
		{
			for (i in 0...4)
			{
				if (_data._usernamesDynamic[i] != ""
				&&  _data._username == _data._usernamesDynamic[i])
				{
					_data._gamesAllTotalDraws[i] += 1;
					// send that username to mysql to get the stats.
					if (Main._rated_game[_data._room] == 1)
						_db_update.draw_at_statistics(_data._gameId, _data._username);
					
					_db_update.game_players_values_at_room_data(_data._username, 0);
				}
			}
		}
		
		player_game_state_value_update(_data);

		_server.broadcast_in_room(_data);
	}
	
	/******************************
	* EVENT GET TOURNAMENT
	* gets the selected tournament data.
	* _dataTournaments
	*/
	private function tournamentChessStandard8Get(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Tournament Chess Standard 8 Get", _data.id, _data._username, _data); // logs
	
		var rset = _db_select.tournament_chess_standard_8(_data._username, 1);
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
			
			var _reminder_by_mail = Std.parseInt(Std.string(rset._reminder_by_mail[0]));
			if (_reminder_by_mail == 0) _data._reminder_by_mail = false;
			else _data._reminder_by_mail = true;
			
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
		
		var rset2 = _db_select.tournament_data();
		
		//if (rset2._player_maximum[0] != null)
			_data._player_maximum = rset2._player_maximum[0];
					
		// get current count of players in tournament chess standard 8.
		var _count = _db_select.tournament_chess_standard_8_count();
		
		_data._player_current = _count;
		
		//##############################
		
		_server.send_to_handler(_data);
	}
	
	/******************************
	* EVENT GET TOURNAMENT
	* puts the selected tournament data to the mysql database.
	* _dataTournaments
	*/
	private function tournamentChessStandard8Put(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Tournament Chess Standard 8 Put", _data.id, _data._username, _data); // logs
		
		_db_update.tournament_chess_standard_8(_data._player1, _data._player2, _data._time_remaining_player1, _data._time_remaining_player2, _data._move_number_current);

		// if game over, from a checkmate or lost a game from time running out or something, end game for both players.
		if (_data._game_over == 1) 
		{
			if (_data._won_game == 1)
				_db_update.tournament_chess_standard_8_game_over(_data._player1, _data._player2, 1, 0); // 1:player1 0:player2. the 1 means a win and 0 is a lose.
			else 
				_db_update.tournament_chess_standard_8_game_over(_data._player1, _data._player2, 0, 1);
		}
		
		// TODO not used.
		//_server.send_to_handler(_data);
	}
	
	/******************************
	* EVENT TOURNAMENT REMINDER BY MAIL
	* 
	*/
	private function tournamentReminderByMail(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Tournament Reminder By Mail", _data.id, _data._username, _data); // logs
		
		var _reminder_by_mail:Int = 0;
		
		if (_data._reminder_by_mail == true)
			_data._reminder_by_mail = false;
			
		else 
		{
			_data._reminder_by_mail = true;
			_reminder_by_mail = 1;
		}
		
		_db_update.tournament_chess_standard_8_reminder_by_mail(_data._player1, _reminder_by_mail);
		
		_server.send_to_handler(_data);
	}
	
	/******************************
	* EVENT TOURNAMENT PARTICIPATING
	* 0: removed from tournament. 1: joined.
	* _dataTournaments
	*/
	private function tournamentParticipating(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Tournament Participating", _data.id, _data._username, _data); // logs
		
		if (_data._player1 != "")
		{
			_db_delete.tournament_chess_standard_8(_data._player1);
			_data._player1 = "";
		}
		
		else
		{
			var _uid_code = Functions.create_code();
			
			_db_insert.tournament_chess_standard_8(_data._username, _uid_code, _data._email_address);
			
			_data._player1 = _data._username;
			_data._game_over = 1;
		}
		
		_server.send_to_handler(_data);
	}

	/******************************
	* EVENT PLAYER LEFT GAME
	* Trigger an event that the player has left the game and then do stuff such as stop the ability to move piece. Note that the player may still be at the game room, waiting for another game to play.
	* _dataPlayers
	*/
	private function playerLeftGameRoom(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Player Left Game Room", _data.id, _data._username, _data); // logs
		
		// save the player's game player state to the database. is the player playing a game or waiting to play.
		for (i in 0...4)
		{
			if (_data._username == _data._usernamesStatic[i] && _data._usernamesStatic[i] != "")
			{
				_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
			}
		
			else
			{
				if (_data._gamePlayersValues[i] == 0)
				{
					_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
				}
			}
		}
		
		/*
		for (i in 0...4)
		{
			if (_data._username == _data._usernamesStatic[i] && _data._usernamesStatic[i] != "")
			{
				_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
			}
		
			else
			{
				if (_data._gamePlayersValues[i] == 0)
				{
					_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
				}
			}
		}
		
		
		// get game playing data from database for the other players in that game room.
		for (i in 0...4)
		{
			if (_data._usernamesStatic[i] != "" && _data._username != _data._usernamesStatic[i])
			{
				var rset = _db_select.user_all_from_user_location_at_room_data(_data._usernamesStatic[i]);
				
				var _type:Int = rset._gamePlayersValues[0];
				if (_data._gamePlayersValues[i] != 0) _data._gamePlayersValues[i] = _type;
			}
		}
		*/
		
		player_game_state_value_update(_data);
		
		_server.broadcast_in_room(_data);
		
	}

	/*************************************************************************
	 * this event is called when playing a game and player ran out of time or quit game.
	 */
	private function playerLeftGame(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Player Left Game", _data.id, _data._username, _data); // logs
		
		// save the player's game player state to the database. is the player playing a game or waiting to play.
		
		for (i in 0...4)
		{
			if (_data._username == _data._usernamesStatic[i] && _data._usernamesStatic[i] != "")
			{
				_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
			}
		
			else
			{
				if (_data._gamePlayersValues[i] == 0)
				{
					_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
				}
			}
		}
		/*
		// get game playing data from database for the other players in that game room.
		for (i in 0...4)
		{
			if (_data._usernamesStatic[i] != "" && _data._username != _data._usernamesStatic[i])
			{
				var rset = _db_select.user_all_from_user_location_at_room_data(_data._usernamesStatic[i]);
				
				var _type:Int = rset._gamePlayersValues[0];
				if (_data._gamePlayersValues[i] != 0) _data._gamePlayersValues[i] = _type;
			}
		}
		*/
		
		player_game_state_value_update(_data);
		
		_server.broadcast_in_room(_data);
		
	}

	/******************************
	* EVENT LOGGED IN USERS
	* list of online players with stats. used to invite.
	*/
	private function loggedInUsers(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Logged In Users", _data.id, _data._username, _data); // logs // do not use
		
		for (i in 0... _server._maximum_server_connections)
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
		var rset = _db_select.is_game_finished_at_room_data(); // get all current logged in users.

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
				var rset3 = _db_select.user_all_at_room_data(_user[i]);

				if (Std.string(rset3._roomState[0]) == "0" && Std.string(rset3._userLocation[0]) == "0")
				{
					// send that username to mysql to get the stats.
					var rset2 = _db_select.user_all_at_statistics(_user[i]);

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
		
		_server.broadcast_in_room(_data);
		
	}

	/******************************
	* EVENT ACTION BY PLAYER.
	* this is where player can kick, ban other players.
	* dataPlayers
	*/
	private function actionByPlayer(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Action By Player", _data.id, _data._username, _data); // logs
		
		// if there was not anything to update then there is no row that exists if this returns false.
		var rset = _db_select.count_user_at_user_actions(_data._username, _data._actionWho);

		// if there was no update, row returned false, then insert it. create a new entry into the database.
		if (rset == false) _db_insert.user_at_user_actions(_data._username, _data._actionWho, _data._actionNumber);

		
		//_server.send_to_handler(_data);
		
		_server.broadcast_in_room(_data);
		
	}
	
	/******************************
	* EVENT IS ACTION NEEDED FOR PLAYER.
	* do action for player event to kick, ban other players.
	*/
	private function isActionNeededForPlayer(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Is Action Needed For Player", _data.id, _data._username, _data); // logs.
		
		var _minutesTotal:Int = 0;
		var _timestamp:String = "";

		// not host and there is more than 1 player in room.
		if (_data._username != _data._usernamesDynamic[0])
		{
			var rset = _db_select.user_data_from_user_action(_data._usernamesDynamic[0], _data._username);
			
			if (rset._actionWho[0] != null)
			{	
				_minutesTotal = rset._minutesTotal[0];

				// get the current time.
				var _currentTime:Int = Std.int(Sys.time());

				var _timeRemaining:Int = 0;
				
				// populate the data to be sent to client.
				// how much time in seconds is remaining in current timestamp minus users timestamp. convert to minutes.
				var _timeMinus:Int = _currentTime - rset._timestamp[0];
				
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
					_db_delete.user_from_user_action(_data._usernamesDynamic[0], _data._username);
					
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
		
		_server.broadcast_in_room(_data);
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
	private function gamePlayersValues(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Game Players Values", _data.id, _data._username, _data); // logs
	
		// if spectator watching then populate _gamePlayersValues typedef.
		if (_data._spectatorWatching == true)
		{
			for (i in 0...4)
			{
				if (Std.string(_data._usernamesStatic[i]) != "")
				{
					var rset4 = _db_select.user_all_from_user_location_at_room_data(_data._usernamesStatic[i]);
					
					_data._gamePlayersValues[i] = rset4._gamePlayersValues[0]; 			
				}
			}
		}
		
		// save for player playing game, else load value of other players in room for this player.
		else
		{
			for (i in 0...4)
			{
				if (_data._usernamesStatic[i] != "")
				{
					_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
				
					// the reason why we update the spectator playing var here is because this event is first sent since entering the game room by the client when a game starts.
					if (_data._gamePlayersValues[i] == 1)
						_db_update.spectator_playing_at_room_data(_data._usernamesStatic[i], _data._spectatorPlaying);
				}
				
				else _data._gamePlayersValues[i] = 0;
			}
			
		}
		
		player_game_state_value_update(_data);
		
		_server.broadcast_in_room(_data);
		
	}	

	/******************************
	* EVENT SAVE A VAR TO MYSQL SO THAT SOMEONE CANNOT INVITE WHEN STILL IN GAME ROOM. ALSO USED TO PASS A VAR TO USER SPECTATOR WATCHING. THAT VAR IS USED TO START A GAME FOR THAT SPECTATOR IF THE _gameIsFinished VALUE IS FALSE.
	* _dataPlayers
	*/
	private function gameIsFinished(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Game Is Finished", _data.id, _data._username, _data); // logs
		
	_db_update.is_game_finished_for_user_at_room_data(_data._username, _data._gameIsFinished, _data._spectatorWatching);
	
		for (i in 0...4)
		{
			// find the username is this var.
			if (_data._usernamesStatic[i] != "")
			{
				// update the game state for this player.
				_server.player_game_state_value_username[_data._room][i] = _data._usernamesStatic[i];
				_server.player_game_state_value_data[_data._room][i] = _data._gamePlayersValues[i];
				
			}
		}
		
		_server.send_to_handler(_data);
		
	}	
	
	/******************************
	* EVENT IS GAME FINISHED. FALSE IF GAME IS STILL BEING PLAYED. DEFAULTS TO TRUE BECAUSE WHEN ENTERING THE GAME ROOM THE GAME FOR THOSE PLAYERS HAS NOT STARTED YET.
	* _dataPlayers
	*/
	private function isGameFinished(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		// TODO this event seems to create mysql and neko thread errors. with this return statement the code seems to work great.
		return; // TODO is this event needed?
	
		Functions.userLogs("Is Game Finished", _data.id, _data._username, _data); // logs
		
		var rset = _db_select.user_all_at_room_data(_data._usernamesDynamic[0]);
		_data._isGameFinished = rset._isGameFinished[0];

		// this could update the same user with the same value but it could also update the _isGameFinished var for the spectator watching.
		_db_update.is_game_finished_for_user_at_room_data(_data._username, _data._isGameFinished, _data._spectatorWatching);
		
		_server.broadcast_in_room(_data);
		
	}	
	
	/******************************
	* EVENT AT LOBBY, SO RETURN ALL VARS TO 0 FOR PLAYER, SO THAT LOBBY DATA CAN BE CALCULATED TO DISPLAY DATA AT LOBBY CORRECTLY.
	* _dataMisc
	*/
	private function returnedToLobby(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Returned To Lobby", _data.id, _data._username, _data); // logs
		
		// room with a value of 0 is saved to userLocation parameter because cannot pass numbers and cannot save userLocation of value 0 when this condition check for not a value of 0/
		//if (Std.string(_data._userLocation) != "0")
		_db_update.all_for_user_at_room_data(_data._username, 0, 0, 0, 0, -1, 0);
						
		_server.send_to_handler(_data);
	}	
	
	/******************************
	* NOTE... GAME WILL NOT UPDATE FOR SPECTATOR UNTIL SECOND MOVE 
	* EVENT SPECTATOR WATCHING
	*  user who requested to watch a game. this can be a message such as "checkmate" or "restarting game". also, any var needed to start or stop a game will be passed here.
	* only the game host should send to this event.
	* _dataQuestions.
	*/
	private function spectatorWatching(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Spectator Watching", _data.id, _data._username, _data); // logs
	
		_server.broadcast_in_room(_data);
		
	}	
	
	/******************************
	* NOTE... GAME WILL NOT UPDATE FOR SPECTATOR UNTIL SECOND MOVE 
	* EVENT SPECTATOR WATCHING GET MOVE NUMBER.
	* send the current move number to the watching spectator so that the timer and white box underneath the P1, P2, P3 or P4 moves, can be updated.
	* _dataPlayers.
	*/
	private function spectatorWatchingGetMoveNumber(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Spectator Watching Get Move Number", _data.id, _data._username, _data); // logs
		
		_server.broadcast_in_room(_data);
		
	}	
	
	/******************************
	* EVENT MOVE HISTORY NEXT ENTRY.
	* every player that moves a piece will use the host of the room to call this event so to update the move history at mysql. this is needed so that when a spectator watching enters the room, that person can get all the move history for that game.
	* _dataMovement.
	*/
	private function moveHistoryNextEntry(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Move History Next Entry", _data.id, _data._username, _data); // logs
		
		_db_update.gid_at_move_history(_data._gid, _data._username, _data._point_value, _data._unique_value, _data._moveHistoryPieceLocationOld1, _data._moveHistoryPieceLocationNew1, _data._moveHistoryPieceLocationOld2, _data._moveHistoryPieceLocationNew2, _data._moveHistoryPieceValueOld1, _data._moveHistoryPieceValueNew1, _data._moveHistoryPieceValueOld2, _data._moveHistoryPieceValueNew2, _data._moveHistoryPieceValueOld3);
		
		var rset = _db_select.all_move_history(_data.id);//_data._username);
		
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
		
		_server.broadcast_in_room(_data);
		
	}	
		
	/******************************
	* EVENT MOVE HISTORY ALL ENTRY.
	* the spectator has just joined the game room because there is currently only one move in that users history, do this event to get all the moves in the move history for this game.
	* _dataMovement.
	*/
	private function moveHistoryAllEntry(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Move History All Entry", _data.id, _data._username, _data); // logs
		var rset = _db_select.all_move_history(_data._gid);// _data._username);
		
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
		
		_server.send_to_handler(_data);
	}		
	
	/******************************
	* EVENT LEADERBOARDS
	* display a 50 player list of the players with the top experence points.
	* _dataLeaderboardXP.
	*/
	private function leaderboards(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Leaderboards", _data.id, _data._username, _data); // logs
		
		var _row = _db_select.top_50_statistics();
		
		// clear any old data because data is about to be populated.
		_data._usernames = "";
		_data._experiencePoints = "";
		_data._houseCoins = "";
		_data._worldFlag = "";
				
		for (i in 0...50)
		{
			if (_row._user[i] != null)
			{
				_data._usernames += Std.string(_row._user[i]) + ",";
				_data._experiencePoints += Std.string(_row._experiencePoints[i]) + ",";
				_data._houseCoins += Std.string(_row._houseCoins[i]) + ",";
				_data._worldFlag += Std.string(_row._worldFlag[i]) + ",";
			}
		}
		
		_server.send_to_handler(_data);			
	}	
	
	/******************************
	* EVENT SAVE NEW ACCOUNT CONFIGURATIONS
	* save new user account information. when user first enters online game and chess elo equals zero then the user is new. the user will then be redirected to a new account scene where new user configuration will be set, such as chess skill level. when the save button is pressed, this event is called.
	* _dataStatistics
	*/
	public function saveNewAccountConfigurations(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Save New Account Configurations", _data.id, _data._username, _data); // logs
		_db_update.chess_elo_rating_statistics(_data._username, _data._chess_elo_rating);
	}			
	
	/******************************
	* you need to set the values below at the game code. see SignatureGameClickMe.hx. at client. makes all clients move the same piece at the same time. this is not automatic.
	 */
	private function movement(_data:Dynamic, _server:Main, _handler:WebSocketHandler):Void
	{
		Functions.userLogs("Movement", _data.id, _data._username, _data); // logs.
		_server.broadcast_in_room(_data);
	}
		
	/******************************
	* EVENT DISCONNECT ALL PLAYERS BY SERVER
	*/
	public function disconnectAllByServer(_data:Dynamic, _server:Main):Void
	{
		Functions.userLogs("Disconnect All By Server", _data.id, _data._username, _data); // logs.
		
		_closeServer = true;
		_server.broadcast_everyone(_data);
	}
	
	public function onDisconnect(_server:Main, _handler:WebSocketHandler):Void
	{
		var _data = Reg._dataDisconnect;
		var _user_location = 0;
		
		// -1 because handler value starts at 1.
		_data._username = _server._username[(_handler.id - 1)];
		
		if (_data._username == "nobody") return;
		
		var _playerNumber:Int = 0;		
		
		try 
		{
			if (_data._username != null)
			{
				// this player that disconnected.
				var row = _db_select.user_all_at_room_data(_data._username);
				
				// remove username from array logs file vars. the logs file stores the user activity. we need to remove the username from these arrays so that the arrays store the correct online user.
				Functions._logsuserId.remove(_data._username);
				Functions._logsUsername.remove(_data._username);
				
				_data._gamePlayersValues = [0, 0, 0, 0];
								
				_data._usernamesDynamic = ["", "", "", ""];
				_data._usernamesStatic = ["", "", "", ""];
				_data._spectatorPlaying = row._spectatorPlaying[0];
				_data._spectatorWatching = row._spectatorWatching[0];
				_user_location = Std.parseInt(Std.string(row._userLocation[0]));
				_data._room = Std.parseInt(Std.string(row._room[0]));
				_data._gameId = row._gameId[0];
				
				if (_data._spectatorWatching == false)
				{
					var rowList = _db_select.room_not_spectator_watching_at_room_data(_data._room);
					// get game playing data from database for the players in that game room.
			
					// the following four code blocks need to be initiated this way to avoid a server crash.
					if (Std.string(rowList._user[0]) != "null")
						_data._usernamesDynamic[0] = Std.string(rowList._user[0]);
					
					if (Std.string(rowList._user[1]) != "null")
						_data._usernamesDynamic[1] = Std.string(rowList._user[1]);
						
					if (Std.string(rowList._user[2]) != "null")
						_data._usernamesDynamic[2] = Std.string(rowList._user[2]);
						
					if (Std.string(rowList._user[3]) != "null")
						_data._usernamesDynamic[3] = Std.string(rowList._user[3]);
					
					if (_data._username != null
					&&	_data._gamePlayersValues != null)
					{	
						for (i in 0...4)
						{
							// find all users that are not spectator watching at the game room.
							if (rowList._spectatorWatching[i] 
						
							== false
							&& _server.player_game_state_value_username[_data._room][i] != "")
							{
								_data._usernamesStatic[i] = _server.player_game_state_value_username[_data._room][i];
								
								// update the game state for this player.
								_data._gamePlayersValues[i] = _server.player_game_state_value_data[_data._room][i];
							}
						}
					}
					
					// get the usernames and the _gamePlayersValues for all non spectators in the game room that are playing a game.
					for (i in 0...4)
					{
						if (rowList._user[i] != null)
						{
							if (_data._gamePlayersValues[i] == 1)
								_data._usernamesDynamic[i] = rowList._user[i];
							
						}
					}
					
					// get all users in game room.
					var rset3 = _db_select.user_all_at_room_data(_data._username);	
					
					var rset = _db_select.user_location_by_timestamp_asc_at_room_data(rset3._room[0]);
					var row = _db_select.user_all_at_room_data(_data._username);
				
					if (_data._room > 0)
					{
						for (i in 0...4)
						{
							if (_data._usernamesStatic[i] != null && Std.string(_data._usernamesStatic[i]) != "" && Std.string(_data._usernamesStatic[i]) == _data._username)
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
								if (_data._spectatorPlaying == true)
									_db_update.game_players_values_at_room_data(Std.string(_data._usernamesStatic[i]), Std.parseInt(Std.string(_data._gamePlayersValues[_playerNumber])));
							}
						}
						
						_db_update.lose_at_statistics(_data._gameId, _data._username);
						
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
								
								if (_data._spectatorPlaying == true) _db_update.game_players_values_at_room_data(Std.string(_data._usernamesStatic[i]), Std.parseInt(Std.string(_data._gamePlayersValues[_playerNumber])));
							}
						}
					}
					
					// this sends a message to the other player saying that someone left the game. 			
					if (_user_location >= 2 && _data._room > 0)
					{						
						// player is leaving room, so make this a value of 3.
						if (_data._gamePlayersValues[_playerNumber] == 0)
							_data._gamePlayersValues[_playerNumber] = 3;
						
						// determine if this is a two player game. if it is then save a win for other player.
						var _count:Int = 0; 
						for (i in 0...4)
						{
							if (Std.string(_data._usernamesStatic[i]) != ""
							&&	_data._gamePlayersValues[i] == 1)
								_count += 1;
							
						}
						
						// end game for other players.
						for (i in 0...4)
						{
							// save a win for this player if a two player game. 
							//a _count value of 1 means that only one player left remaining in the current game. Remeber this player had left. so its minus 1 count of total players that were playing. 
							// the next check in this code block is the player who is at this event. if _data._gamePlayersValues is 1, a win for that player should be given and if a win then a lose must be given here for the player in this event.  
							if (_count == 1)
							{
								if (_data._gamePlayersValues[i] == 1)
								{
									_db_update.win_at_statistics(_data._gameId, _data._usernamesStatic[i]);
								}
							}
							
							if (Std.string(_data._usernamesStatic[i]) != ""
							&&	_data._gamePlayersValues[i] == 1)
							{
								_data._gamePlayersValues[i] = 0;			
							}
						}
							
						// save the player's game player state to the database. is the player playing a game or waiting to play.				
						for (i in 0...4)
						{//_data._username == Std.string(_data._usernamesStatic[i]) && 
							if (Std.string(_data._usernamesStatic[i]) != "")
							{
								//if (_data._spectatorPlaying == true) 
								_db_update.game_players_values_at_room_data(_data._usernamesStatic[i], _data._gamePlayersValues[i]);
							}
						}
						
						// player_game_state_value_data is read at the beginning of this event and its data is passed to _data._gamePlayersValues.
						for (i in 0 ...4)
						{
							_server.player_game_state_value_data[_data._room][i] = _data._gamePlayersValues[i];
						}

	/*
	for (i in 0...4) {trace(_server.player_game_state_value_username[_data._room][i]);}
	trace(_data._usernamesStatic + " _data._usernamesStatic");
	trace(_data._usernamesDynamic + " _data._usernamesDynamic");
	trace(_data._spectatorPlaying + " _data._spectatorPlaying");
	trace(_data._spectatorWatching + " _data._spectatorWatching");	
	trace(_data._gamePlayersValues + " _data._gamePlayersValues");
	trace(_data._room + " _data._room");
	trace(_data._gameId + " _data._gameId");
	trace(_playerNumber + " _playerNumber");
	trace("--------------------");
	*/	
						_data._event_name = "Player Left Game Room";
						_server.broadcast_in_room(_data);
					}
				}
				
				if (_data._username != null && _data._username != "nobody")
				{
					trace(_data._username + " disconnected.");
					Functions.userLogs("Disconnected", "", _data._username, _data); // logs
					
					// a client has disconnected to this server. Therefore, decrease the amount of clients connected.
					_server._serverConnections -= 1;
				}
			}
			
			_db_delete.user_at_front_door_queue(_data._username);
			
			// now that we got the username, remove all list data.
			_server.remove_from_room(_data);
			
			Sys.println ("Client disconnected.");
			Sys.println ("Clients connected: " + _server._serverConnections);
			
			if (_closeServer == true && _server._serverConnections == 0)
			{
				Sys.println ("Server not active.");
				Sys.exit(0);
			}
		}
		catch (e:Dynamic)
		{
		}
		
		trace ("onDisconnect from " + _data._username); 
	}
	
	private function addRowsToDatabase(_data:Dynamic):Void
	{
		_db_insert.user_at_logged_in_user(_data._username, _data._ip, _data._hostname, 0);
		_db_insert.user_and_id_at_room_data(_data._username, _data.id);
		_db_insert.user_to_statistics(_data._username);
		_db_insert.user_to_house(_data._username);
	}
	
	
}//