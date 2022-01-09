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
import sys.db.Connection;
import sys.db.Mysql;

typedef MysqlData = {
	_user: Array<String>, 				// the username of the player.
	_user2: Array<String>, 				// can be used to get player 2.
	_password_hash: Array<String>,		// md5 encrypted password.
	_hostname: Array<String>,			// a hostname is a label that is assigned to a device connected to a computer network 
	_player_maximum: Array<Int>, 		// total players in tournament.
	_player_current: Array<Int>,		// current players in tournament.
	_ip: Array<String>,					// used to return the ip of user.
	_message: Array<String>,
	_timestamp: Array<String>, 			// always use string for timestamp.
	_minutesTotal: Array<Int>,			// user hosting room, kick or ban other user.
	_gamesAllTotalWins: Array<Int>,
	_gamesAllTotalLosses: Array<Int>,
	_gamesAllTotalDraws: Array<Int>,
	_roomState: Array<Int>,				// 0 = empty, 1 creating room, 2 = waiting to play game. 3 = second player in room. 4 third player if any. 5 - forth player if any. 6 - room full, 7 playing game. 8 game ended. 
	_userId: Array<String>,				// player instance. this tells one player from another.
	_userLocation: Array<Int>,			// currently where the user is at. lobby, waiting room, etc. 0:lobby, 1:creating room, 2:waiting room, 3:room game playing.
	_room: Array<Int>,					// current room that the user is in. zero equals no room.
	_playerLimit: Array<Int>,			// // max players in room.
	_gameId: Array<Int>,				// 0: checkers, 1: chess, 2: reversi, 3: snakes and ladders, 5: signature game. etc.
	_isGameFinished: Array<Bool>,		// game over?
	_actionWho: Array<String>,			// who to place the action on.
	_actionNumber: Array<String>,		// the action known as a number.
	_hostUsername: Array<String>,		// the username that hosts the room.
	_gamePlayersValues: Array<Int>,		// save the player's game player state to the database. is the player playing a game or waiting to play. 
					// 0: = not playing but still at game room. 
					// 1: playing a game. 
					// 2: left game room while still playing it. 
					// 3: left game room when game was over. 
					// 4: quit game.	
	_spectatorPlaying: Array<Bool>,			// quit game or time ran out for this player. this player was once playing a game. when doing spectators for anyone to watch, that must be a different name.
	_spectatorWatching: Array<Bool>,
	_serversOnline: Array<Int>,			// total count.
	
	_connected1: Array<Bool>,			// used when the server first connects online. this var can be used to tell what server is online.
	_connected2: Array<Bool>,
	_connected3: Array<Bool>,
	_connected4: Array<Bool>,
	_connected5: Array<Bool>,
	_connected6: Array<Bool>,
	_connected7: Array<Bool>,
	_connected8: Array<Bool>,
	_connected9: Array<Bool>,
	_connected10: Array<Bool>,
	_connected11: Array<Bool>,
	_connected12: Array<Bool>,
	_connected13: Array<Bool>,
	_connected14: Array<Bool>,
	_connected15: Array<Bool>,
	_connected16: Array<Bool>,
	_connected17: Array<Bool>,
	_connected18: Array<Bool>,
	_connected19: Array<Bool>,
	_connected20: Array<Bool>,
	
	_disconnect1: Array<Bool>,			// used to send a disconnect message to all client on that server.	
	_disconnect2: Array<Bool>,
	_disconnect3: Array<Bool>,
	_disconnect4: Array<Bool>,
	_disconnect5: Array<Bool>,
	_disconnect6: Array<Bool>,
	_disconnect7: Array<Bool>,
	_disconnect8: Array<Bool>,
	_disconnect9: Array<Bool>,
	_disconnect10: Array<Bool>,
	_disconnect11: Array<Bool>,
	_disconnect12: Array<Bool>,
	_disconnect13: Array<Bool>,
	_disconnect14: Array<Bool>,
	_disconnect15: Array<Bool>,
	_disconnect16: Array<Bool>,
	_disconnect17: Array<Bool>,
	_disconnect18: Array<Bool>,
	_disconnect19: Array<Bool>,
	_disconnect20: Array<Bool>,
	
	_timestamp1: Array<String>, 		// used to disconnect server when its time.
	_timestamp2: Array<String>, 
	_timestamp3: Array<String>,
	_timestamp4: Array<String>,
	_timestamp5: Array<String>,
	_timestamp6: Array<String>,
	_timestamp7: Array<String>,
	_timestamp8: Array<String>,
	_timestamp9: Array<String>,
	_timestamp10: Array<String>,
	_timestamp11: Array<String>,
	_timestamp12: Array<String>,
	_timestamp13: Array<String>,
	_timestamp14: Array<String>,
	_timestamp15: Array<String>,
	_timestamp16: Array<String>,
	_timestamp17: Array<String>,
	_timestamp18: Array<String>,
	_timestamp19: Array<String>,
	_timestamp20: Array<String>,
	
	_doOnce1: Array<Bool>,				// at main, update() is in a tight loop. this stop the sending of another disconnect message to clients.
	_doOnce2: Array<Bool>,
	_doOnce3: Array<Bool>,
	_doOnce4: Array<Bool>,
	_doOnce5: Array<Bool>,
	_doOnce6: Array<Bool>,
	_doOnce7: Array<Bool>,
	_doOnce8: Array<Bool>,
	_doOnce9: Array<Bool>,
	_doOnce10: Array<Bool>,
	_doOnce11: Array<Bool>,
	_doOnce12: Array<Bool>,
	_doOnce13: Array<Bool>,
	_doOnce14: Array<Bool>,
	_doOnce15: Array<Bool>,
	_doOnce16: Array<Bool>,
	_doOnce17: Array<Bool>,
	_doOnce18: Array<Bool>,
	_doOnce19: Array<Bool>,
	_doOnce20: Array<Bool>,
		
	_messageOnline: Array<Bool>,		//The admin cancelled the server from going offline or another message.
	_messageOffline: Array<Bool>,		// going offline at given minutes.
	
	// all players move history for the game.
	_moveHistoryPieceLocationOld1: Array<String>,		// move history, the selected first piece
	_moveHistoryPieceLocationNew1: Array<String>,		// moved the first piece to selected location.
	_moveHistoryPieceLocationOld2: Array<String>,		// second piece, such as, the rook when castling. the second piece selected for that game move.
	_moveHistoryPieceLocationNew2: Array<String>,		// moved the second piece to selected location.
	
	_moveHistoryPieceValueOld1: Array<String>,		// image value of the selected first piece. if its a rook that first player selected then its a value of 4 else for second player then its a value of 14. normally this value is 0 because after the move, no piece is at that location.
	_moveHistoryPieceValueNew1: Array<String>,		// this refers to the value of the piece at the new selected moved to location.
	_moveHistoryPieceValueOld2: Array<String>,		// the second piece value, or piece image, normally this unit is empty because the second piece was moved to a new unit.
	_moveHistoryPieceValueNew2: Array<String>,		// this is the second piece moved to value of the image, so that the image can be moved to the new location.
	_moveHistoryPieceValueOld3: Array<String>,		// the piece that was captured. its image value.
	
	_eventMonth: Array<Int>,			// the current month. if month differs from current value then this field will be updated and credits_today field will be given a value of 0.
	_eventDay: Array<Int>,				// the current day. if day differs from current value then this field will be updated and credits_today will be given a value of 0.	
	_creditsToday: Array<Int>,			// credits given on event day. credits can be redeemed for a month of paid membership. Maximum of 5 credits per event day.
	_creditsTotal: Array<Int>,			// each credit_today value is written to this value. this value only decreases when credits are used to redeem something, such as 1 month of membership.
	
	_isLocked: Array<Int>,				// 0: room is unlocked. 1: locked.
	
	_experiencePoints:Array<Int>,		// this is the total exp points that the player has.
	
	_houseCoins: Array<Int>, 			// at the house event, after a game is played, some coins will be given. Use those coins to buy house furniture. Access your house from the house button at lobby.
	
	_worldFlag: Array<Int>, 
	_checkersWins:Array<Int>,
	_checkersLosses:Array<Int>,
	_checkersDraws:Array<Int>,
	_chessWins:Array<Int>,
	_chessLosses:Array<Int>,
	_chessDraws:Array<Int>,
	_reversiWins:Array<Int>,
	_reversiLosses:Array<Int>,
	_reversiDraws:Array<Int>,
	_snakesAndLaddersWins:Array<Int>,
	_snakesAndLaddersLosses:Array<Int>,
	_snakesAndLaddersDraws:Array<Int>,
	_signatureGameWins:Array<Int>,
	_signatureGameLosses:Array<Int>,
	_signatureGameDraws:Array<Int>,

	_vsComputer:Array<Int>, 		// if this value is true than the host is playing against the computer.
	_allowSpectators:Array<Int>, 	// if true then this room allows spectators.
	
	_spriteNumber: Array<String>,	// refers to a sprite that was bought to display at house. eg, 1.png	
	_spriteName: Array<String>, // this is the name of the sprite in the order it was bought and then after, in the order of was changed using the zorder buttons of bring to front and bring to back.
	_itemsX: Array<String>, 		// all items x position that is separated by a comma.
	_itemsY: Array<String>,			// all items y position that is separated by a comma.
	_mapX: Array<String>, // map x coordinates on scene at the time the item was bought or mouse dragged then mouse released.
	_mapY: Array<String>, // map y coordinates on scene at the time the item was bought or mouse dragged then mouse released.
	_isItemPurchased: Array<String>,// a list of 1 and 0's separated by a comma. the first value in this list refers to item 1. if that value is 1 then that item was purchased.
	_isPaidMember: Array<Int>,	// is the player a paid member of kg's website. 
	_itemDirectionFacing: Array<String>, // stores the direction that the furniture item is facing. values of 0=SE, 1:SW, 2:NE, 3:NW
	_mapOffsetX: Array<String>,	// when the map is moved up, down, left or right, this value increases in size by those pixels. this var is used at House update() so that the map hover can be displayed when outside of its default map boundaries. it is also added or subtracted to the mouse coordinates at other classes so that the map or panel items can correctly be detected by the mouse. for example, the mouse.x cannot be at a value of 2000 when the stage has a width of 1400 and the map changes in width, but it can be there when this offset is added to mouse.x.
 	_mapOffsetY: Array<String>,
	_itemIsHidden: Array<String>, // is this item hidden?
	_itemOrder: Array<String>, // the order of the furniture items displayed.
	/******************************
	* when value is true the furniture item will be displayed on the map behind a wall. This string contains true and false values up to 200 furniture items seperated by a comma.
	*/
	_itemBehindWalls: Array<String>,
	/******************************
	 * this holds all floor tiles on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and simular to reading words in a book.
	 */
	_floor: Array<String>,
	
	/******************************
	 * this holds all wall tiles in the left postion on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and simular to reading words in a book.
	 */
	_wallLeft: Array<String>,
	
	/******************************
	 * this holds all wall tiles in the upward postion on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and simular to reading words in a book.
	 * this var is shown under a left tile. so the wall is up but behind a left wall.
	 */
	_wallUpBehind: Array<String>,
	_wallUpInFront: Array<String>,
	/******************************
	 * the visibility state of all floor tiles.
	 */
	_floorIsHidden: Array<String>,
	
	/******************************
	 * the visibility state of all left wall tiles.
	 */
	_wallLeftIsHidden: Array<String>,
	
	/******************************
	 * the visibility state of all up wall tiles.
	 */
	_wallUpBehindIsHidden: Array<String>,
	_wallUpInFrontIsHidden: Array<String>,
	
	_moveNumberDynamic: Array<Int>,
	_move_number_current: Array<Int>,
	
	// Int does not work.
	_three_in_a_row: Array<String>,
	_chess_5_moves_under: Array<String>,
	_snakes_under_4_moves: Array<String>,
	_win_5_minute_game: Array<String>,
	_buy_four_house_items: Array<String>,
	_finish_signature_game: Array<String>,
	_reversi_occupy_50_units: Array<String>,
	_checkers_get_6_kings: Array<String>,
	_play_all_5_board_games: Array<String>,
	
	// name of the day. used at daily quests to determine of all quest data should be reset back to 0. that will happen if the day in the database is different then the day when entering into the daily quests event at server.
	_day_name: Array<String>,
	
	/******************************
	 * a gauge is dashed lines that runs horizontally across the top part of the dailyQuests.hx scene. There are three reward icons. then the dash filled line reaches a reward icon then a claim reward button will appear.
	 * the third dashed line refers to the first value is this string. the second value in this var refers to the sixth dashed line and the last dash lined (ninth) refers to the third value. therefore three quests need to be completed before a reward can be given. so there is 9 dashed lines, an every third line that is highlighted means that a quest reward can be given.
	 * this string look like this... "2,1,0". a zero means that no prize is available, the 1 means that a rewards can be claimed and 2 means that the reward for those quests have been claimed. remember that 2 quests are needed for every reward and that the dashed lines refer to those quests.
	 */
	_rewards: Array<String>,
	/******************************
	 * this is the avatar from the database if one exists.
	 */
	_avatarNumber: Array<String>,
	
	/******************************
	 * get the player's chess elo rating.
	 */
	_chess_elo_rating: Array<Float>,
	
	/******************************
	 * 0: not players turn to move piece. 1: player can move plece.
	 * */
	_move_piece: Array<Int>,
	
	_point_value: Array<Int>,
	_unique_value: Array<Int>,
	
	/******************************
	 * game id. move_history fields are not deleted from the mysql database. so this id is used so that a user accesses that correct move_history data.
	 */
	_gid: Array<String>,
	
	/******************************
	 * time is seconds you have to move a piece. failing to move piece within time allowed will result in losing the game. 
	 */
	_time_remaining_player1: Array<String>,
	_time_remaining_player2: Array<String>,	
	
	/******************************
	 * 0:not started 1:started.
	 */
	_tournament_started: Array<Int>,
	
	/******************************
	 * game move total for player
	 */
	_move_total: Array<Int>,
	
	_round_current: Array<Int>,		// current round of the tournament. 16 player tournament = this value of 0. 8 players has this value set at 1.

	_rounds_total: Array<Int>,					// when the round_current equals this value then the tournament is at its last round.
	
	_reminder_by_mail: Array<Int>,	// 0: player wants no tournament mail. 1: true.
	/******************************
	 * 0:lost a tournament game. 1:won a tournament game.
	 */
	_won_game: Array<Int>,
	
	_email_address: Array<String>,
}

/**
 *
 * @author kboardgames.com
 */
class DB_Parent
{
	public var cnx:Connection;	
	public var _mysqlData:MysqlData;
			
	public function new() 
	{
		_mysqlData = 
		{
			// need to initialize these array before using them. 
			_user: [], 
			_user2: [],
			_password_hash: [],
			_hostname: [],
			_player_maximum: [],
			_player_current: [],
			_ip: [],
			_message: [], 
			_timestamp: [],
			_minutesTotal: [],
			_gamesAllTotalWins: [],
			_gamesAllTotalLosses: [],
			_gamesAllTotalDraws: [],
			_roomState: [],
			_userId: [],
			_userLocation: [],
			_room: [],
			_playerLimit: [],
			_gameId: [],
			_isGameFinished: [],
			_actionWho: [],
			_actionNumber: [],
			_hostUsername: [],
			_gamePlayersValues: [],
			_spectatorPlaying: [],
			_spectatorWatching: [],
			_serversOnline: [],
			
			_connected1: [],
			_connected2: [],
			_connected3: [],
			_connected4: [],
			_connected5: [],
			_connected6: [],
			_connected7: [],
			_connected8: [],
			_connected9: [],
			_connected10: [],
			_connected11: [],
			_connected12: [],
			_connected13: [],
			_connected14: [],
			_connected15: [],
			_connected16: [],
			_connected17: [],
			_connected18: [],
			_connected19: [],
			_connected20: [],
			
			_disconnect1: [],
			_disconnect2: [],
			_disconnect3: [],
			_disconnect4: [],
			_disconnect5: [],
			_disconnect6: [],
			_disconnect7: [],
			_disconnect8: [],
			_disconnect9: [],
			_disconnect10: [],
			_disconnect11: [],
			_disconnect12: [],
			_disconnect13: [],
			_disconnect14: [],
			_disconnect15: [],
			_disconnect16: [],
			_disconnect17: [],
			_disconnect18: [],
			_disconnect19: [],
			_disconnect20: [],
			
			_timestamp1: [],
			_timestamp2: [],
			_timestamp3: [],
			_timestamp4: [],
			_timestamp5: [],
			_timestamp6: [],
			_timestamp7: [],
			_timestamp8: [],
			_timestamp9: [],
			_timestamp10: [],
			_timestamp11: [],
			_timestamp12: [],
			_timestamp13: [],
			_timestamp14: [],
			_timestamp15: [],
			_timestamp16: [],
			_timestamp17: [],
			_timestamp18: [],
			_timestamp19: [],
			_timestamp20: [],
			
			_doOnce1: [],
			_doOnce2: [],
			_doOnce3: [],
			_doOnce4: [],
			_doOnce5: [],
			_doOnce6: [],
			_doOnce7: [],
			_doOnce8: [],
			_doOnce9: [],
			_doOnce10: [],
			_doOnce11: [],
			_doOnce12: [],
			_doOnce13: [],
			_doOnce14: [],
			_doOnce15: [],
			_doOnce16: [],
			_doOnce17: [],
			_doOnce18: [],
			_doOnce19: [],
			_doOnce20: [],
						
			_messageOnline: [],
			_messageOffline: [],
			
			_moveHistoryPieceLocationOld1: [],
			_moveHistoryPieceLocationNew1: [],
			_moveHistoryPieceLocationOld2: [],
			_moveHistoryPieceLocationNew2: [],
			
			_moveHistoryPieceValueOld1: [],
			_moveHistoryPieceValueNew1: [],
			_moveHistoryPieceValueOld2: [],
			_moveHistoryPieceValueNew2: [],
			_moveHistoryPieceValueOld3: [],
			
			_eventMonth: [],
			_eventDay: [],
			_creditsToday: [],
			_creditsTotal: [],
			
			_isLocked: [],
			_experiencePoints: [],
			_houseCoins: [],
			_worldFlag: [],
			_checkersWins: [],
			_checkersLosses: [],
			_checkersDraws: [],
			_chessWins: [],
			_chessLosses: [],
			_chessDraws: [],
			_reversiWins: [],
			_reversiLosses: [],
			_reversiDraws: [],
			_snakesAndLaddersWins: [],
			_snakesAndLaddersLosses: [],
			_snakesAndLaddersDraws: [],
			_signatureGameWins: [],
			_signatureGameLosses: [],
			_signatureGameDraws: [],
			
			_vsComputer: [],
			_allowSpectators: [],
			
			_spriteNumber: [],
			_spriteName: [],
			_itemsX: [],
			_itemsY: [],
			_mapX: [],
			_mapY: [],
			_isItemPurchased: [],
			_isPaidMember: [],
			_itemDirectionFacing: [],
			_mapOffsetX: [],
			_mapOffsetY: [],
			_itemIsHidden: [],
			_itemOrder: [],
			_itemBehindWalls: [],
			_floor: [],
			_wallLeft: [],
			_wallUpBehind: [],
			_wallUpInFront: [],
			_floorIsHidden: [],
			_wallLeftIsHidden: [],
			_wallUpBehindIsHidden: [],
			_wallUpInFrontIsHidden: [],
			_moveNumberDynamic: [],
			_move_number_current: [],
			_three_in_a_row: [],
			_chess_5_moves_under: [],
			_snakes_under_4_moves: [],
			_win_5_minute_game: [],
			_buy_four_house_items: [],
			_finish_signature_game: [],
			_reversi_occupy_50_units: [],
			_checkers_get_6_kings: [],
			_play_all_5_board_games: [],
			_day_name: [],
			_rewards: [],
			_avatarNumber: [],
			_chess_elo_rating: [],
			_move_piece: [],

			_point_value: [],
			_unique_value: [],
			
			_gid: [],
			_time_remaining_player1: [],
			_time_remaining_player2: [],
			
			_tournament_started: [],
			_move_total: [],
			
			_round_current: [],
			_rounds_total: [],
			_reminder_by_mail: [],
			_won_game: [],
			_email_address: [],
		};
		
		tryMysqlConnectDatabase();
	}
	
	private function tryMysqlConnectDatabase():Void
	{
		try
		{
			clear_mysql_data();

			var cnx2 = Mysql.connect(
			{ 
				host : Reg._dbHost,
				port : Reg._dbPort,
				user : Reg._dbUser,
				pass : Reg._dbPass,
				socket : null,
				database : Reg._dbName
			});	
			
			cnx = cnx2;
			
		}	
		
		catch (e:Dynamic)
		{
			trace ("Cannot connect to mysql database. Does the database exist? Is xampp online? Start this server after xampp is online. Close this server then try again.");
							
			while (true) {};
		}	
	}
	private function clear_mysql_data():Void
	{
		_mysqlData._user.splice(0, _mysqlData._user.length);
		_mysqlData._user2.splice(0, _mysqlData._user2.length);
		_mysqlData._password_hash.splice(0, _mysqlData._password_hash.length);
		_mysqlData._hostname.splice(0, _mysqlData._hostname.length);
		
		_mysqlData._player_maximum.splice(0, _mysqlData._player_maximum.length);
		_mysqlData._player_current.splice(0, _mysqlData._player_current.length);
		_mysqlData._userId.splice(0, _mysqlData._userId.length);
		_mysqlData._ip.splice(0, _mysqlData._ip.length);
		_mysqlData._message.splice(0, _mysqlData._message.length);
		
		_mysqlData._timestamp.splice(0, _mysqlData._timestamp.length);
		_mysqlData._minutesTotal.splice(0, _mysqlData._minutesTotal.length);

		_mysqlData._gamesAllTotalWins.splice(0, _mysqlData._gamesAllTotalWins.length);
		_mysqlData._gamesAllTotalLosses.splice(0, _mysqlData._gamesAllTotalLosses.length);
		_mysqlData._gamesAllTotalDraws.splice(0, _mysqlData._gamesAllTotalDraws.length);
		_mysqlData._roomState.splice(0, _mysqlData._roomState.length);
	
		_mysqlData._userLocation.splice(0, _mysqlData._userLocation.length);
		_mysqlData._room.splice(0, _mysqlData._room.length);
		_mysqlData._playerLimit.splice(0, _mysqlData._playerLimit.length);
		_mysqlData._gameId.splice(0, _mysqlData._gameId.length);
		_mysqlData._isGameFinished.splice(0, _mysqlData._isGameFinished.length);
		
		_mysqlData._actionWho.splice(0, _mysqlData._actionWho.length);
		_mysqlData._actionNumber.splice(0, _mysqlData._actionNumber.length);
		_mysqlData._hostUsername.splice(0, _mysqlData._hostUsername.length);
		_mysqlData._gamePlayersValues.splice(0, _mysqlData._gamePlayersValues.length);
		_mysqlData._spectatorPlaying.splice(0, _mysqlData._spectatorPlaying.length);
		_mysqlData._spectatorWatching.splice(0, _mysqlData._spectatorWatching.length);
		
		_mysqlData._serversOnline.splice(0, _mysqlData._serversOnline.length);
		
		_mysqlData._connected1.splice(0, _mysqlData._connected1.length);
		_mysqlData._connected2.splice(0, _mysqlData._connected2.length);
		_mysqlData._connected3.splice(0, _mysqlData._connected3.length);
		_mysqlData._connected4.splice(0, _mysqlData._connected4.length);
		_mysqlData._connected5.splice(0, _mysqlData._connected5.length);
		_mysqlData._connected6.splice(0, _mysqlData._connected6.length);
		_mysqlData._connected7.splice(0, _mysqlData._connected7.length);
		_mysqlData._connected8.splice(0, _mysqlData._connected8.length);
		_mysqlData._connected9.splice(0, _mysqlData._connected9.length);
		_mysqlData._connected10.splice(0, _mysqlData._connected10.length);
		_mysqlData._connected11.splice(0, _mysqlData._connected11.length);
		_mysqlData._connected12.splice(0, _mysqlData._connected12.length);
		_mysqlData._connected13.splice(0, _mysqlData._connected13.length);
		_mysqlData._connected14.splice(0, _mysqlData._connected14.length);
		_mysqlData._connected15.splice(0, _mysqlData._connected15.length);
		_mysqlData._connected16.splice(0, _mysqlData._connected16.length);
		_mysqlData._connected17.splice(0, _mysqlData._connected17.length);
		_mysqlData._connected18.splice(0, _mysqlData._connected18.length);
		_mysqlData._connected19.splice(0, _mysqlData._connected19.length);
		_mysqlData._connected20.splice(0, _mysqlData._connected20.length);
		
		_mysqlData._disconnect1.splice(0, _mysqlData._disconnect1.length);
		_mysqlData._disconnect2.splice(0, _mysqlData._disconnect2.length);
		_mysqlData._disconnect3.splice(0, _mysqlData._disconnect3.length);
		_mysqlData._disconnect4.splice(0, _mysqlData._disconnect4.length);
		_mysqlData._disconnect5.splice(0, _mysqlData._disconnect5.length);
		_mysqlData._disconnect6.splice(0, _mysqlData._disconnect6.length);
		_mysqlData._disconnect7.splice(0, _mysqlData._disconnect7.length);
		_mysqlData._disconnect8.splice(0, _mysqlData._disconnect8.length);
		_mysqlData._disconnect9.splice(0, _mysqlData._disconnect9.length);
		_mysqlData._disconnect10.splice(0, _mysqlData._disconnect10.length);
		_mysqlData._disconnect11.splice(0, _mysqlData._disconnect11.length);
		_mysqlData._disconnect12.splice(0, _mysqlData._disconnect12.length);
		_mysqlData._disconnect13.splice(0, _mysqlData._disconnect13.length);
		_mysqlData._disconnect14.splice(0, _mysqlData._disconnect14.length);
		_mysqlData._disconnect15.splice(0, _mysqlData._disconnect15.length);
		_mysqlData._disconnect16.splice(0, _mysqlData._disconnect16.length);
		_mysqlData._disconnect17.splice(0, _mysqlData._disconnect17.length);
		_mysqlData._disconnect18.splice(0, _mysqlData._disconnect18.length);
		_mysqlData._disconnect19.splice(0, _mysqlData._disconnect19.length);
		_mysqlData._disconnect20.splice(0, _mysqlData._disconnect20.length);
				
		_mysqlData._timestamp1.splice(0, _mysqlData._timestamp1.length);		
		_mysqlData._timestamp2.splice(0, _mysqlData._timestamp2.length);
		_mysqlData._timestamp3.splice(0, _mysqlData._timestamp3.length);		
		_mysqlData._timestamp4.splice(0, _mysqlData._timestamp4.length);
		_mysqlData._timestamp5.splice(0, _mysqlData._timestamp5.length);		
		_mysqlData._timestamp6.splice(0, _mysqlData._timestamp6.length);
		_mysqlData._timestamp7.splice(0, _mysqlData._timestamp7.length);		
		_mysqlData._timestamp8.splice(0, _mysqlData._timestamp8.length);
		_mysqlData._timestamp9.splice(0, _mysqlData._timestamp9.length);		
		_mysqlData._timestamp10.splice(0, _mysqlData._timestamp10.length);
		_mysqlData._timestamp11.splice(0, _mysqlData._timestamp11.length);		
		_mysqlData._timestamp12.splice(0, _mysqlData._timestamp12.length);
		_mysqlData._timestamp13.splice(0, _mysqlData._timestamp13.length);		
		_mysqlData._timestamp14.splice(0, _mysqlData._timestamp14.length);
		_mysqlData._timestamp15.splice(0, _mysqlData._timestamp15.length);		
		_mysqlData._timestamp16.splice(0, _mysqlData._timestamp16.length);
		_mysqlData._timestamp17.splice(0, _mysqlData._timestamp17.length);		
		_mysqlData._timestamp18.splice(0, _mysqlData._timestamp18.length);
		_mysqlData._timestamp19.splice(0, _mysqlData._timestamp19.length);		
		_mysqlData._timestamp20.splice(0, _mysqlData._timestamp20.length);
		
		_mysqlData._doOnce1.splice(0, _mysqlData._doOnce1.length);
		_mysqlData._doOnce2.splice(0, _mysqlData._doOnce2.length);
		_mysqlData._doOnce3.splice(0, _mysqlData._doOnce3.length);
		_mysqlData._doOnce4.splice(0, _mysqlData._doOnce4.length);
		_mysqlData._doOnce5.splice(0, _mysqlData._doOnce5.length);
		_mysqlData._doOnce6.splice(0, _mysqlData._doOnce6.length);
		_mysqlData._doOnce7.splice(0, _mysqlData._doOnce7.length);
		_mysqlData._doOnce8.splice(0, _mysqlData._doOnce8.length);
		_mysqlData._doOnce9.splice(0, _mysqlData._doOnce9.length);
		_mysqlData._doOnce10.splice(0, _mysqlData._doOnce10.length);
		_mysqlData._doOnce11.splice(0, _mysqlData._doOnce11.length);
		_mysqlData._doOnce12.splice(0, _mysqlData._doOnce12.length);
		_mysqlData._doOnce13.splice(0, _mysqlData._doOnce13.length);
		_mysqlData._doOnce14.splice(0, _mysqlData._doOnce14.length);
		_mysqlData._doOnce15.splice(0, _mysqlData._doOnce15.length);
		_mysqlData._doOnce16.splice(0, _mysqlData._doOnce16.length);
		_mysqlData._doOnce17.splice(0, _mysqlData._doOnce17.length);
		_mysqlData._doOnce18.splice(0, _mysqlData._doOnce18.length);
		_mysqlData._doOnce19.splice(0, _mysqlData._doOnce19.length);
		_mysqlData._doOnce20.splice(0, _mysqlData._doOnce20.length);
		
		_mysqlData._messageOnline.splice(0, _mysqlData._messageOnline.length);
		_mysqlData._messageOffline.splice(0, _mysqlData._messageOffline.length);
		
		_mysqlData._moveHistoryPieceLocationOld1.splice(0, _mysqlData._moveHistoryPieceLocationOld1.length);
		_mysqlData._moveHistoryPieceLocationNew1.splice(0, _mysqlData._moveHistoryPieceLocationNew1.length);
		_mysqlData._moveHistoryPieceLocationOld2.splice(0, _mysqlData._moveHistoryPieceLocationOld2.length);
		_mysqlData._moveHistoryPieceLocationNew2.splice(0, _mysqlData._moveHistoryPieceLocationNew2.length);
		
		_mysqlData._moveHistoryPieceValueOld1.splice(0, _mysqlData._moveHistoryPieceValueOld1.length);
		_mysqlData._moveHistoryPieceValueNew1.splice(0, _mysqlData._moveHistoryPieceValueNew1.length);
		_mysqlData._moveHistoryPieceValueOld2.splice(0, _mysqlData._moveHistoryPieceValueOld2.length);
		_mysqlData._moveHistoryPieceValueNew2.splice(0, _mysqlData._moveHistoryPieceValueNew2.length);
		_mysqlData._moveHistoryPieceValueOld3.splice(0, _mysqlData._moveHistoryPieceValueOld3.length);
		
		_mysqlData._eventMonth.splice(0, _mysqlData._eventMonth.length);
		_mysqlData._eventDay.splice(0, _mysqlData._eventDay.length);
		_mysqlData._creditsToday.splice(0, _mysqlData._creditsToday.length);
		_mysqlData._creditsTotal.splice(0, _mysqlData._creditsTotal.length);
		
		_mysqlData._isLocked.splice(0, _mysqlData._isLocked.length);
		_mysqlData._experiencePoints.splice(0, _mysqlData._experiencePoints.length);
		_mysqlData._houseCoins.splice(0, _mysqlData._houseCoins.length);
		_mysqlData._worldFlag.splice(0, _mysqlData._worldFlag.length);
		
		_mysqlData._checkersWins.splice(0, _mysqlData._checkersWins.length);
		_mysqlData._checkersLosses.splice(0, _mysqlData._checkersLosses.length);
		_mysqlData._checkersDraws.splice(0, _mysqlData._checkersDraws.length);
		_mysqlData._chessWins.splice(0, _mysqlData._chessWins.length);
		_mysqlData._chessLosses.splice(0, _mysqlData._chessLosses.length);
		_mysqlData._chessDraws.splice(0, _mysqlData._chessDraws.length);
		_mysqlData._reversiWins.splice(0, _mysqlData._reversiWins.length);
		_mysqlData._reversiLosses.splice(0, _mysqlData._reversiLosses.length);
		_mysqlData._reversiDraws.splice(0, _mysqlData._reversiDraws.length);
		_mysqlData._snakesAndLaddersWins.splice(0, _mysqlData._snakesAndLaddersWins.length);
		_mysqlData._snakesAndLaddersLosses.splice(0, _mysqlData._snakesAndLaddersLosses.length);
		_mysqlData._snakesAndLaddersDraws.splice(0, _mysqlData._snakesAndLaddersDraws.length);
		_mysqlData._signatureGameWins.splice(0, _mysqlData._signatureGameWins.length);
		_mysqlData._signatureGameLosses.splice(0, _mysqlData._signatureGameLosses.length);
		_mysqlData._signatureGameDraws.splice(0, _mysqlData._signatureGameDraws.length);
		
		_mysqlData._vsComputer.splice(0, _mysqlData._vsComputer.length);
		_mysqlData._allowSpectators.splice(0, _mysqlData._allowSpectators.length);
		
		// house data.
		_mysqlData._spriteNumber.splice(0, _mysqlData._spriteNumber.length);
		_mysqlData._spriteName.splice(0, _mysqlData._spriteName.length);
		_mysqlData._itemsX.splice(0, _mysqlData._itemsX.length);
		_mysqlData._itemsY.splice(0, _mysqlData._itemsY.length);
		_mysqlData._mapX.splice(0, _mysqlData._mapX.length);
		_mysqlData._mapY.splice(0, _mysqlData._mapY.length);
		_mysqlData._isItemPurchased.splice(0, _mysqlData._isItemPurchased.length);
			
		_mysqlData._isPaidMember.splice(0, _mysqlData._isPaidMember.length);
		
		_mysqlData._itemDirectionFacing.splice(0, _mysqlData._itemDirectionFacing.length);		
		_mysqlData._mapOffsetX.splice(0, _mysqlData._mapOffsetX.length);
		_mysqlData._mapOffsetY.splice(0, _mysqlData._mapOffsetY.length);
		_mysqlData._itemIsHidden.splice(0, _mysqlData._itemIsHidden.length);
		_mysqlData._itemOrder.splice(0, _mysqlData._itemOrder.length);
		_mysqlData._itemBehindWalls.splice(0, _mysqlData._itemBehindWalls.length);
		_mysqlData._floor.splice(0, _mysqlData._floor.length);
		
		_mysqlData._wallLeft.splice(0, _mysqlData._wallLeft.length);
		_mysqlData._wallUpBehind.splice(0, _mysqlData._wallUpBehind.length);
		_mysqlData._wallUpInFront.splice(0, _mysqlData._wallUpInFront.length);
		_mysqlData._floorIsHidden.splice(0, _mysqlData._floorIsHidden.length);
		_mysqlData._wallLeftIsHidden.splice(0, _mysqlData._wallLeftIsHidden.length);
		_mysqlData._wallUpBehindIsHidden.splice(0, _mysqlData._wallUpBehindIsHidden.length);
		_mysqlData._wallUpInFrontIsHidden.splice(0, _mysqlData._wallUpInFrontIsHidden.length);
		_mysqlData._moveNumberDynamic.splice(0, _mysqlData._moveNumberDynamic.length);
		_mysqlData._move_number_current.splice(0, _mysqlData._move_number_current.length);
		_mysqlData._three_in_a_row.splice(0, _mysqlData._three_in_a_row.length);
		_mysqlData._chess_5_moves_under.splice(0, _mysqlData._chess_5_moves_under.length);
		_mysqlData._snakes_under_4_moves.splice(0, _mysqlData._snakes_under_4_moves.length);
		_mysqlData._win_5_minute_game.splice(0, _mysqlData._win_5_minute_game.length);
		_mysqlData._buy_four_house_items.splice(0, _mysqlData._buy_four_house_items.length);
		_mysqlData._finish_signature_game.splice(0, _mysqlData._finish_signature_game.length);
		_mysqlData._reversi_occupy_50_units.splice(0, _mysqlData._reversi_occupy_50_units.length);
		_mysqlData._checkers_get_6_kings.splice(0, _mysqlData._checkers_get_6_kings.length);
		_mysqlData._play_all_5_board_games.splice(0, _mysqlData._play_all_5_board_games.length);
		_mysqlData._day_name.splice(0, _mysqlData._day_name.length);
		_mysqlData._rewards.splice(0, _mysqlData._rewards.length);
		_mysqlData._avatarNumber.splice(0, _mysqlData._avatarNumber.length);
		_mysqlData._chess_elo_rating.splice(0, _mysqlData._chess_elo_rating.length);
		_mysqlData._move_piece.splice(0, _mysqlData._move_piece.length);
		
		_mysqlData._point_value.splice(0, _mysqlData._point_value.length);
		_mysqlData._unique_value.splice(0, _mysqlData._unique_value.length);
		
		_mysqlData._gid.splice(0, _mysqlData._gid.length);
		_mysqlData._time_remaining_player1.splice(0, _mysqlData._time_remaining_player1.length);
		_mysqlData._time_remaining_player2.splice(0, _mysqlData._time_remaining_player2.length);
		
		_mysqlData._tournament_started.splice(0, _mysqlData._tournament_started.length);
		_mysqlData._move_total.splice(0, _mysqlData._move_total.length);
		
		_mysqlData._round_current.splice(0, _mysqlData._round_current.length);
		_mysqlData._rounds_total.splice(0, _mysqlData._rounds_total.length);
		_mysqlData._reminder_by_mail.splice(0, _mysqlData._reminder_by_mail.length);		
		_mysqlData._won_game.splice(0, _mysqlData._won_game.length);
		_mysqlData._email_address.splice(0, _mysqlData._email_address.length);
	}
}//