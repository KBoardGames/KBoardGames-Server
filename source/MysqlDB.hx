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

	/******************************
	 * 0:lost a tournament game. 1:won a tournament game.
	 */
	_won_game: Array<Int>,
}

/**
 *
 * @author kboardgames.com
 */
class MysqlDB
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
			_won_game: [],
		};
		
		tryMysqlConnectDatabase();
	}
	
	private function tryMysqlConnectDatabase():Void
	{
		try
		{
			clearMysqlData();

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
	
	/******************************
	 * delete all logged in users because server is starting. we do this at starting not stopping because server may have crashed.
	 */
	public function delete_logged_in_tables():Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM logged_in_users"); 
		var rset = cnx.request("DELETE FROM logged_in_hostname"); 
		var rset = cnx.request("DELETE FROM room_data"); 
		var rset = cnx.request("DELETE FROM user_actions"); 
		var rset = cnx.request("DELETE FROM who_is_host"); 
		
		cnx.close();
	}
	
	/******************************
	 * delete user action table for user.
	 */
	public function delete_user_action(_user:String, _actionWho:String):Void
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("DELETE FROM user_actions WHERE user = " + cnx.quote(_user) + "AND action_who = " + cnx.quote(_actionWho));
			
		}
		catch (e:Dynamic)
		{
			trace("user_actions not delete to table.");
		}
		
		cnx.close();
	}
	
	
	/******************************
	 * at hostname to logged_in_hostname table. stores the hostname not the ip address.
	 */
	public function insert_hostname_to_logged_in_table(_hostname:String):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM logged_in_hostname WHERE hostname = " + cnx.quote(_hostname));
		
		var rset2 = cnx.request("INSERT IGNORE INTO logged_in_hostname (hostname) VALUES (" + cnx.quote(_hostname) + ")"); 
		
		
		cnx.close();
	
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	public function update_hostname_at_users_table(_user:String, _hostname:String):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			var rset3 = cnx.request("UPDATE users set hostname = " + cnx.quote(_hostname) + " WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("error at mysql add_host_to_users_table function.");
		}
		
		cnx.close(); 
	}
	
	/******************************
	 * user logged off. delete this table row.
	 */
	public function delete_user_at_logged_in_user_table(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM logged_in_users WHERE user = " + cnx.quote(_user));
		
		cnx.close();
	}
	
	public function delete_user_no_kicked_or_banned(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM user_actions WHERE user = " + cnx.quote(_user) + " AND action_number < 3"); //  action_number 1 and 2 is kicked / banned. 0 = nothing.
		
		cnx.close();
	}
	
	/******************************
	 * user logged off. delete this table row.
	 */
	public function delete_tables_user_logged_off(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM room_data WHERE user = " + cnx.quote(_user));
		var rset = cnx.request("DELETE FROM who_is_host WHERE user = " + cnx.quote(_user));
		var rset = cnx.request("DELETE FROM room_lock WHERE user = " + cnx.quote(_user));
		
		cnx.close();
	}
	
	// TODO this table is not used. verify if this table is needed.
	public function delete_room_from_room_data_table(_room:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM room_data WHERE room = " + _room);
		
		cnx.close();
	}
	
	/******************************
	 * user logged off. delete this table row.
	 */
	public function delete_hostname_at_logged_in_hostname(_hostname:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("DELETE FROM logged_in_hostname WHERE hostname = " + cnx.quote(_hostname));
		
		cnx.close();
	}
	
	/******************************
	 * when user logs in, temp data is written to mysql database. this table has data such as the ip, host, and roomState of the user.
	 */
	public function insert_user_at_logged_in_user_table(_user:String, _ip:String, _hostname:String, _roomState:Int):Void
	{
		tryMysqlConnectDatabase();

		var rset = cnx.request("INSERT IGNORE INTO logged_in_users (user, ip, host, room_state) VALUES (" + cnx.quote(_user) + ", " + cnx.quote(_ip) + ", " + cnx.quote(_hostname) + ", " + _roomState + ")");
		
		cnx.close();
	}
	
	// update the temp data of the user.
	public function updateLoggedInUser(_user:String, _roomState:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE logged_in_users SET 
		timestamp = UNIX_TIMESTAMP(), 
		room_state = " + _roomState + " WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	}

	

	// update the move history.
	public function updateMoveHistory(_gid:String, _user:String, _point_value:String, _unique_value:String, _pieceLocationOld1:String, _pieceLocationNew1:String, _pieceLocationOld2:String, _pieceLocationNew2:String, _pieceValueOld1:String, _pieceValueNew1:String, _pieceValueOld2:String, _pieceValueNew2:String, _pieceValueOld3:String):Void
	{
		tryMysqlConnectDatabase();
		
		_pieceLocationOld1 += ",";
		_pieceLocationNew1 += ",";
		_pieceLocationOld2 += ",";
		_pieceLocationNew2 += ",";
		_pieceValueOld1 += ",";
		_pieceValueNew1 += ",";
		_pieceValueOld2 += ",";
		_pieceValueNew2 += ",";
		_pieceValueOld3 += ",";
		
		try {
			
			var rset = cnx.request("SELECT COUNT(*) FROM move_history WHERE gid = " + cnx.quote(_gid));
				
			if (rset.getIntResult(0) == 0) 
			{
				var rset2 = cnx.request("INSERT IGNORE INTO move_history 
				(user,
				gid,
				point_value,
				unique_value,
				piece_location_old1, 
				piece_location_new1, 
				piece_location_old2, 
				piece_location_new2,
				piece_value_old1, 
				piece_value_new1, 
				piece_value_old2,
				piece_value_new2,
				piece_value_old3)
				VALUES 
				(" + cnx.quote(_user) + ", 
				 " + cnx.quote(_gid) + ", 
				 " + cnx.quote(_point_value) + ",
				 " + cnx.quote(_unique_value) + ",
				 " + cnx.quote(_pieceLocationOld1) + ",
				 " + cnx.quote(_pieceLocationNew1) + ",
				 " + cnx.quote(_pieceLocationOld2) + ",
				 " + cnx.quote(_pieceLocationNew2) + ",
				 " + cnx.quote(_pieceValueOld1) + ",
				 " + cnx.quote(_pieceValueNew1) + ",
				 " + cnx.quote(_pieceValueOld2) + ",
				 " + cnx.quote(_pieceValueNew2) + ",
				 " + cnx.quote(_pieceValueOld3) + "
				 )");
			}
		
			else
			{
				var rset2 = cnx.request("UPDATE move_history SET
				point_value = " + cnx.quote(_point_value) + ",
				unique_value = " + cnx.quote(_unique_value) + ",
				piece_location_old1 = CONCAT(IFNULL(piece_location_old1,''), " + cnx.quote(_pieceLocationOld1) + "),
				piece_location_new1 = CONCAT(IFNULL(piece_location_new1, ''), " + cnx.quote(_pieceLocationNew1) + "),
				piece_location_old2 = CONCAT(IFNULL(piece_location_old2, ''), " + cnx.quote(_pieceLocationOld2) + "),
				piece_location_new2 = CONCAT(IFNULL(piece_location_new2, ''), " + cnx.quote(_pieceLocationNew2) + "),
				piece_value_old1 = CONCAT(IFNULL(piece_value_old1, ''), " + cnx.quote(_pieceValueOld1) + "),
				piece_value_new1 = CONCAT(IFNULL(piece_value_new1, ''), " + cnx.quote(_pieceValueNew1) + "),
				piece_value_old2 = CONCAT(IFNULL(piece_value_old2, ''), " + cnx.quote(_pieceValueOld2) + "),
				piece_value_new2 = CONCAT(IFNULL(piece_value_new2, ''), " + cnx.quote(_pieceValueNew2) + "), 
				piece_value_old3 = CONCAT(IFNULL(piece_value_old3, ''), " + cnx.quote(_pieceValueOld3) + ") 
				WHERE gid = " + cnx.quote(_gid));
			}

		}
		catch (e:Dynamic)
		{
			trace("error at movehistory mysql function.");
		}
		
		cnx.close();
		
	}
	
	// create the room_data row for the user that logged in.
	public function insertRoomData(_user:String, _userId:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("INSERT IGNORE INTO room_data (user, user_id) VALUES (" + cnx.quote(_user) + ", " + cnx.quote(_userId) + ")");
		
		cnx.close();
	}
	
	// create the user table row for the user that logged in.
	public function insertUserToUsersTable(_user:String, _password_hash:String, _ip:String, _hostname:String):Void
	{	
		tryMysqlConnectDatabase();
		
		var _timestamp:Int = Std.int(Sys.time());
		
		try {
			var rset = cnx.request("INSERT IGNORE INTO users (user, password_hash, ip, hostname, timestamp) VALUES (" + cnx.quote(_user) + "," + cnx.quote(_password_hash) + "," + cnx.quote(_ip) + "," + cnx.quote(_hostname) + "," + _timestamp + ")");
					
		}
		catch (e:Dynamic)
		{
			trace("User not added to users table.");
		}
		
		try {
			var _var = cnx.request("UPDATE users SET ip = " + cnx.quote(_ip) + " WHERE user = " + cnx.quote(_user));					
		}
		catch (e:Dynamic)
		{
			trace("ip of user not updated at users table.");
		}
		
		cnx.close();
	}
	
	// create the user table row for the user that logged in.
	public function insertUserToDailyQuestsTable(_user:String):Void
	{	
		tryMysqlConnectDatabase();
		
		var _now = Date.now();
		var _dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saterday"];
		var _day_name = _dayNames[_now.getDay()];
		
		try {
			var rset = cnx.request("SELECT COUNT(*) FROM daily_quests WHERE user = " + cnx.quote(_user));
				
			if (rset.getIntResult(0) == 0) 
			{
				var rset2 = cnx.request("INSERT IGNORE INTO daily_quests (user, day_name, timestamp) VALUES (" + cnx.quote(_user) + "," + cnx.quote(_day_name) + ", UNIX_TIMESTAMP())" );
			}
				
		}		
		
		catch (e:Dynamic)
		{
			trace("User not added to daily quests table.");
		}
		
		cnx.close();
	}
	
	// create the user table row for the user that logged in. this function is called when the user logs into the quest quests and the time is the next day or greater.
	public function deleteThenRecreateDailyQuestsTable(_user:String):Void
	{	
		tryMysqlConnectDatabase();
		
		var _now = Date.now();
		var _dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saterday"];
		var _day_name = _dayNames[_now.getDay()];
		
		try 
		{
			var rset = cnx.request("DELETE FROM daily_quests WHERE user = " + cnx.quote(_user));
			
			var rset2 = cnx.request("INSERT IGNORE INTO daily_quests (user, day_name, timestamp) VALUES (" + cnx.quote(_user) + "," + cnx.quote(_day_name) + ", UNIX_TIMESTAMP())" );
				
		}		
		
		catch (e:Dynamic)
		{
			trace("recreate daily quests table error.");
		}
		
		cnx.close();
	}
	
	public function insertUserToStatisticsTable(_user:String):Void
	{	
		tryMysqlConnectDatabase();
		
		var _timestamp:Int = Std.int(Sys.time());
		
		try {
			var rset = cnx.request("INSERT IGNORE INTO statistics (user) VALUES (" + cnx.quote(_user) +")");
					
		}
		catch (e:Dynamic)
		{
			trace("User not added to statistics table.");
		}
		
		cnx.close();
	}
	
	
	public function insertUserToHouseTable(_user:String):Void
	{	
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("INSERT IGNORE INTO house (user) VALUES (" + cnx.quote(_user) +")");
					
		}
		catch (e:Dynamic)
		{
			trace("User not added to house table.");
		}
		
		cnx.close();
	}
	
	
	// does user exists. if count is greater then zero the return as true.
	public function requestLoggedInUsers(_user:String):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM logged_in_users WHERE user = " + cnx.quote(_user));
				
		cnx.close();
		
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	// does user exists at users table. if count is greater then zero the return as true.
	public function doesUserExistAtUsersTable(_user:String):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM users WHERE user = " + cnx.quote(_user));
		
		cnx.close();
					
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	public function selectUserAvatar(_user:String):MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.username);
				_mysqlData._avatarNumber.push(row.user_avatar);
			}
		
		}
		catch (e:Dynamic)
		{
			trace("avatar error from statistics table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
		
	public function isThereUserAction(_user:String, _actionWho:String):MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM user_actions WHERE user = " + cnx.quote(_user) + "AND action_who = " + cnx.quote(_actionWho));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._actionWho.push(row.action_who);
				_mysqlData._actionNumber.push(row.action_number);
				_mysqlData._timestamp.push(row.timestamp);
				_mysqlData._minutesTotal.push(row.minutes_total);
			}
		
		}
		catch (e:Dynamic)
		{
			trace("user_actions not SELECT to table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function selectUserEloRating(_user:String):MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._chess_elo_rating.push(row.chess_elo_rating);
			}
		
		}
		catch (e:Dynamic)
		{
			trace("chess elo rating error from statistics table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function select_host_at_users_table(_hostname:String):MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM users WHERE hostname = " + cnx.quote(_hostname));
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._hostname.push(row.hostname);
				_mysqlData._password_hash.push(row.password_hash);
			}
		
		}
		catch (e:Dynamic)
		{
			trace("error at mysql function select_host_at_users_table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
 
	// used to get the id of the server. every server has a different id. a query is read every so many ticks and when that query has a field such as disconnect_1 that matches lets say server id of 1 then that server will be disconnected or a disconnect cancelled.
	public function selectServerData():MysqlData
	{
		tryMysqlConnectDatabase();		
	
		try {
			var rset = cnx.request("SELECT * FROM servers_status");
		
			for ( row in rset )
			{
				_mysqlData._serversOnline.push(row.servers_online);
				
				_mysqlData._connected1.push(row.connected_1);
				_mysqlData._connected2.push(row.connected_2);
				_mysqlData._connected3.push(row.connected_3);
				_mysqlData._connected4.push(row.connected_4);
				_mysqlData._connected5.push(row.connected_5);
				_mysqlData._connected6.push(row.connected_6);
				_mysqlData._connected7.push(row.connected_7);
				_mysqlData._connected8.push(row.connected_8);
				_mysqlData._connected9.push(row.connected_9);
				_mysqlData._connected10.push(row.connected_10);
				_mysqlData._connected11.push(row.connected_11);
				_mysqlData._connected12.push(row.connected_12);
				_mysqlData._connected13.push(row.connected_13);
				_mysqlData._connected14.push(row.connected_14);
				_mysqlData._connected15.push(row.connected_15);
				_mysqlData._connected16.push(row.connected_16);
				_mysqlData._connected17.push(row.connected_17);
				_mysqlData._connected18.push(row.connected_18);
				_mysqlData._connected19.push(row.connected_19);
				_mysqlData._connected20.push(row.connected_20);
				
				_mysqlData._disconnect1.push(row.disconnect_1);
				_mysqlData._disconnect2.push(row.disconnect_2);
				_mysqlData._disconnect3.push(row.disconnect_3);
				_mysqlData._disconnect4.push(row.disconnect_4);
				_mysqlData._disconnect5.push(row.disconnect_5);
				_mysqlData._disconnect6.push(row.disconnect_6);
				_mysqlData._disconnect7.push(row.disconnect_7);
				_mysqlData._disconnect8.push(row.disconnect_8);
				_mysqlData._disconnect9.push(row.disconnect_9);
				_mysqlData._disconnect10.push(row.disconnect_10);
				_mysqlData._disconnect11.push(row.disconnect_11);
				_mysqlData._disconnect12.push(row.disconnect_12);
				_mysqlData._disconnect13.push(row.disconnect_13);
				_mysqlData._disconnect14.push(row.disconnect_14);
				_mysqlData._disconnect15.push(row.disconnect_15);
				_mysqlData._disconnect16.push(row.disconnect_16);
				_mysqlData._disconnect17.push(row.disconnect_17);
				_mysqlData._disconnect18.push(row.disconnect_18);
				_mysqlData._disconnect19.push(row.disconnect_19);
				_mysqlData._disconnect20.push(row.disconnect_20);
				
				_mysqlData._doOnce1.push(row.do_once_1);
				_mysqlData._doOnce2.push(row.do_once_2);
				_mysqlData._doOnce3.push(row.do_once_3);
				_mysqlData._doOnce4.push(row.do_once_4);
				_mysqlData._doOnce5.push(row.do_once_5);
				_mysqlData._doOnce6.push(row.do_once_6);
				_mysqlData._doOnce7.push(row.do_once_7);
				_mysqlData._doOnce8.push(row.do_once_8);
				_mysqlData._doOnce9.push(row.do_once_9);
				_mysqlData._doOnce10.push(row.do_once_10);
				_mysqlData._doOnce11.push(row.do_once_11);
				_mysqlData._doOnce12.push(row.do_once_12);
				_mysqlData._doOnce13.push(row.do_once_13);
				_mysqlData._doOnce14.push(row.do_once_14);
				_mysqlData._doOnce15.push(row.do_once_15);
				_mysqlData._doOnce16.push(row.do_once_16);
				_mysqlData._doOnce17.push(row.do_once_17);
				_mysqlData._doOnce18.push(row.do_once_18);
				_mysqlData._doOnce19.push(row.do_once_19);
				_mysqlData._doOnce20.push(row.do_once_20);
				
				_mysqlData._timestamp1.push(row.timestamp_1);
				_mysqlData._timestamp2.push(row.timestamp_2);
				_mysqlData._timestamp3.push(row.timestamp_3);
				_mysqlData._timestamp4.push(row.timestamp_4);
				_mysqlData._timestamp5.push(row.timestamp_5);
				_mysqlData._timestamp6.push(row.timestamp_6);
				_mysqlData._timestamp7.push(row.timestamp_7);
				_mysqlData._timestamp8.push(row.timestamp_8);
				_mysqlData._timestamp9.push(row.timestamp_9);
				_mysqlData._timestamp10.push(row.timestamp_10);
				_mysqlData._timestamp11.push(row.timestamp_11);
				_mysqlData._timestamp12.push(row.timestamp_12);
				_mysqlData._timestamp13.push(row.timestamp_13);
				_mysqlData._timestamp14.push(row.timestamp_14);
				_mysqlData._timestamp15.push(row.timestamp_15);
				_mysqlData._timestamp16.push(row.timestamp_16);
				_mysqlData._timestamp17.push(row.timestamp_17);
				_mysqlData._timestamp18.push(row.timestamp_18);
				_mysqlData._timestamp19.push(row.timestamp_19);
				_mysqlData._timestamp20.push(row.timestamp_20);
				
				_mysqlData._messageOnline.push(row.message_online);
				_mysqlData._messageOffline.push(row.message_offline);
			}
		}
		
		catch (e:Dynamic)
		{
			trace("servers_status table error.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	
	public function updateServerOnline(id:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE servers_status set servers_online = " + id);
		
		cnx.close();
	}
	
	
	// the total amount of servers online. id = the server online. the second server has an id of 2.
	public function serverNowOnline(id:Int):Int
	{
		tryMysqlConnectDatabase();
		
		if (id == 1) cnx.request("UPDATE servers_status set connected_1 = 1");
		if (id == 2) cnx.request("UPDATE servers_status set connected_2 = 1");
		if (id == 3) cnx.request("UPDATE servers_status set connected_3 = 1");
		if (id == 4) cnx.request("UPDATE servers_status set connected_4 = 1");
		if (id == 5) cnx.request("UPDATE servers_status set connected_5 = 1");
		if (id == 6) cnx.request("UPDATE servers_status set connected_6 = 1");
		if (id == 7) cnx.request("UPDATE servers_status set connected_7 = 1");
		if (id == 8) cnx.request("UPDATE servers_status set connected_8 = 1");
		if (id == 9) cnx.request("UPDATE servers_status set connected_9 = 1");
		if (id == 10) cnx.request("UPDATE servers_status set connected_10 = 1");
		if (id == 11) cnx.request("UPDATE servers_status set connected_11 = 1");
		if (id == 12) cnx.request("UPDATE servers_status set connected_12 = 1");
		if (id == 13) cnx.request("UPDATE servers_status set connected_13 = 1");
		if (id == 14) cnx.request("UPDATE servers_status set connected_14 = 1");
		if (id == 15) cnx.request("UPDATE servers_status set connected_15 = 1");
		if (id == 16) cnx.request("UPDATE servers_status set connected_16 = 1");
		if (id == 17) cnx.request("UPDATE servers_status set connected_17 = 1");
		if (id == 18) cnx.request("UPDATE servers_status set connected_18 = 1");
		if (id == 19) cnx.request("UPDATE servers_status set connected_19 = 1");
		if (id == 20) cnx.request("UPDATE servers_status set connected_20 = 1");
		
		
		cnx.close();
		return id;
	}
	
	
	public function serverNowOffline(id:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE servers_status set servers_online = servers_online - 1");
		
		if (id == 1) cnx.request("UPDATE servers_status set disconnect_1 = 0");
		if (id == 2) cnx.request("UPDATE servers_status set disconnect_2 = 0");
		if (id == 3) cnx.request("UPDATE servers_status set disconnect_3 = 0");
		if (id == 4) cnx.request("UPDATE servers_status set disconnect_4 = 0");
		if (id == 5) cnx.request("UPDATE servers_status set disconnect_5 = 0");
		if (id == 6) cnx.request("UPDATE servers_status set disconnect_6 = 0");
		if (id == 7) cnx.request("UPDATE servers_status set disconnect_7 = 0");
		if (id == 8) cnx.request("UPDATE servers_status set disconnect_8 = 0");
		if (id == 9) cnx.request("UPDATE servers_status set disconnect_9 = 0");
		if (id == 10) cnx.request("UPDATE servers_status set disconnect_10 = 0");
		if (id == 11) cnx.request("UPDATE servers_status set disconnect_11 = 0");
		if (id == 12) cnx.request("UPDATE servers_status set disconnect_12 = 0");
		if (id == 13) cnx.request("UPDATE servers_status set disconnect_13 = 0");
		if (id == 14) cnx.request("UPDATE servers_status set disconnect_14 = 0");
		if (id == 15) cnx.request("UPDATE servers_status set disconnect_15 = 0");
		if (id == 16) cnx.request("UPDATE servers_status set disconnect_16 = 0");
		if (id == 17) cnx.request("UPDATE servers_status set disconnect_17 = 0");
		if (id == 18) cnx.request("UPDATE servers_status set disconnect_18 = 0");
		if (id == 19) cnx.request("UPDATE servers_status set disconnect_19 = 0");
		if (id == 20) cnx.request("UPDATE servers_status set disconnect_20 = 0");
				
		cnx.close();
	}
		
	// reset server data because we do not want a message saying this server is has been cancelled when we did not receive a message about server going offline.
	public function serverResetStatus(id:Int):Void
	{
		tryMysqlConnectDatabase();
		
		if (id == 1)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_1 = 0,
			timestamp_1 = 0,
			do_once_1 = 0");			
		}
		
		if (id == 2)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_2 = 0,
			timestamp_2 = 0,
			do_once_2 = 0");			
		}
		
		if (id == 3)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_3 = 0,
			timestamp_3 = 0,
			do_once_3 = 0");			
		}
		
		if (id == 4)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_4 = 0,
			timestamp_4 = 0,
			do_once_4 = 0");			
		}
		
		if (id == 5)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_5 = 0,
			timestamp_5 = 0,
			do_once_5 = 0");			
		}
		
		if (id == 6)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_6 = 0,
			timestamp_6 = 0,
			do_once_6 = 0");			
		}
		
		if (id == 7)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_7 = 0,
			timestamp_7 = 0,
			do_once_7 = 0");			
		}
		
		if (id == 8)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_8 = 0,
			timestamp_8 = 0,
			do_once_8 = 0");			
		}
		
		if (id == 9)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_9 = 0,
			timestamp_9 = 0,
			do_once_9 = 0");			
		}
		
		if (id == 10)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_10 = 0,
			timestamp_10 = 0,
			do_once_10 = 0");			
		}
				
		if (id == 11)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_11 = 0,
			timestamp_11 = 0,
			do_once_11 = 0");			
		}
		
		if (id == 12)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_12 = 0,
			timestamp_12 = 0,
			do_once_12 = 0");			
		}
		
		if (id == 13)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_13 = 0,
			timestamp_13 = 0,
			do_once_13 = 0");			
		}
		
		if (id == 14)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_14 = 0,
			timestamp_14 = 0,
			do_once_14 = 0");			
		}
		
		if (id == 15)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_15 = 0,
			timestamp_15 = 0,
			do_once_15 = 0");			
		}
		
		if (id == 16)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_16 = 0,
			timestamp_16 = 0,
			do_once_16 = 0");			
		}
		
		if (id == 17)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_17 = 0,
			timestamp_17 = 0,
			do_once_17 = 0");			
		}
		
		if (id == 18)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_18 = 0,
			timestamp_18 = 0,
			do_once_18 = 0");			
		}
		
		if (id == 19)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_19 = 0,
			timestamp_19 = 0,
			do_once_19 = 0");			
		}
		
		if (id == 20)
		{
			cnx.request("UPDATE servers_status set 
			disconnect_20 = 0,
			timestamp_20 = 0,
			do_once_20 = 0");			
		}
		
		cnx.close();
	}
	
	// the total amount of servers online.
	public function updateServerDoOnce():Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE servers_status set 
		do_once_1 = 0,
		do_once_2 = 0,
		do_once_3 = 0,
		do_once_4 = 0,
		do_once_5 = 0,
		do_once_6 = 0,
		do_once_7 = 0,
		do_once_8 = 0,
		do_once_9 = 0,
		do_once_10 = 0,
		do_once_11 = 0,
		do_once_12 = 0,
		do_once_13 = 0,
		do_once_14 = 0,
		do_once_15 = 0,
		do_once_16 = 0,
		do_once_17 = 0,
		do_once_18 = 0,
		do_once_19 = 0,
		do_once_20 = 0
		");
		
		cnx.close();
	}
	
	
	public function select120KickedUsers():MysqlData
	{			
		tryMysqlConnectDatabase();
			
		try
		{
			var rset = cnx.request("SELECT * FROM kicked WHERE timestamp > " + Sys.time() + " ORDER BY id ASC LIMIT 120");
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._message.push(row.message);
				_mysqlData._timestamp.push(row.timestamp);
				_mysqlData._minutesTotal.push(row.minutes_total);
			}

		}
		
		catch (e:Dynamic)
		{
			trace("error at _mysql select120KickedUsers function.");
		}

		cnx.close();
		
		return _mysqlData;
	}
			
	public function select120BannedUsers():MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM banned ORDER BY id DESC LIMIT 120");
				
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._ip.push(row.ip);
				_mysqlData._message.push(row.message);
			}
			
		}
		
		catch (e:Dynamic)
		{
			trace("error at _mysql select120BannedUsers function.");
		}

		cnx.close();
		
		return _mysqlData;
	}
	
	public function select_guests_from_users_table():MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM users WHERE user like 'Guest%' order by user ASC");
				
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._hostname.push(row.hostname);
			}
			
		} 
		
		catch (e:Dynamic)
		{
			trace("error at _mysql select_all_from_users_table function.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function select_ip(_user:String):MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM users WHERE user = " + cnx.quote(_user));
				
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._ip.push(row.ip);
			}
			
		} 
		
		catch (e:Dynamic)
		{
			trace("error at selete_ip function.");
		}

		cnx.close();
		
		return _mysqlData;
	}
	
	public function select_hash(_user:String):MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM users WHERE user = " + cnx.quote(_user));
				
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._password_hash.push(row.password_hash);
				_mysqlData._hostname.push(row.hostname);
			}
			
		}
		
		catch (e:Dynamic)
		{
			trace("error at selete_hash function.");
		}

		cnx.close();
		
		return _mysqlData;
	}
	
	public function select_last_logged_in_guest():MysqlData
	{			
		tryMysqlConnectDatabase();

		try
		{
			var rset = cnx.request("SELECT * FROM users WHERE user like 'guest%' ORDER BY user ASC LIMIT 1");
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
			}

		}
		
		catch (e:Dynamic)
		{
			trace("error at _mysql select_last_logged_in_guest function.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function getAllMoveHistory(_gid:String):MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try 
		{
			
			var rset = cnx.request("SELECT * FROM move_history WHERE gid = " + cnx.quote(_gid));
					
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._point_value.push(row.point_value);
				_mysqlData._unique_value.push(row.unique_value);
				_mysqlData._moveHistoryPieceLocationOld1.push(row.piece_location_old1);
				_mysqlData._moveHistoryPieceLocationNew1.push(row.piece_location_new1);
				_mysqlData._moveHistoryPieceLocationOld2.push(row.piece_location_old2);
				_mysqlData._moveHistoryPieceLocationNew2.push(row.piece_location_new2);

				_mysqlData._moveHistoryPieceValueOld1.push(row.piece_value_old1);
				_mysqlData._moveHistoryPieceValueNew1.push(row.piece_value_new1);
				_mysqlData._moveHistoryPieceValueOld2.push(row.piece_value_old2);
				_mysqlData._moveHistoryPieceValueNew2.push(row.piece_value_new2);
				_mysqlData._moveHistoryPieceValueOld3.push(row.piece_value_old3);
			}

		}
		
		catch (e:Dynamic)
		{
			trace("mysql error at function getAllMoveHistory.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	// get all credit data for user.
	public function getEventCreditsFromUsersTable(_user:String):MysqlData
	{			
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
			
			for ( row in rset )
			{			
				_mysqlData._ip.push(row.ip);
				
				_mysqlData._eventMonth.push(row.event_month);
				_mysqlData._eventDay.push(row.event_day);
				_mysqlData._creditsToday.push(row.credits_today);
				_mysqlData._creditsTotal.push(row.credits_total);
			}
		}
		
		catch (e:Dynamic)
		{
			trace("get credit rows from statistics table for user.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function updateChessEloRating(_user:String, _rating:Float):Void
	{
		tryMysqlConnectDatabase();

		try 
		{
			var rset = cnx.request("UPDATE statistics SET 
			chess_elo_rating = " + _rating + "
			WHERE user = " + cnx.quote(_user) );
		}
		
		catch (e:Dynamic)
		{
			trace ("error updating elo rating.");
		}
		
		cnx.close();
	}
	
	/******************************
	 * if event month and day in reg file is different than month and day found in table then write new month and day value to table and also write credits_today value to 0 since this is a new day.
	 */
	public function changeEventCreditsMonthAndDay(_user:String, _eventMonth:Int, _eventDay:Int):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE statistics SET 
		event_month = " + _eventMonth + ", 
		event_day = " + _eventDay + ",
		credits_today = 1 
		WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	}
	
	public function giveCreditToUser(_user:String):Void
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("UPDATE statistics SET 
		credits_today = credits_today + 1, 
		credits_total = credits_total + 1 
		WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	}
	
	/******************************
	 *	give experience points to user after the game ends. exp points for a game lost is about half that of a win.
	 * _exp		the experience points to give to user.
	 */
	public function giveExperiencePointsToUser(_user:String, _exp:Int):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("UPDATE statistics SET 
			experience_points = experience_points + " + _exp + " WHERE user = " + cnx.quote(_user) );
		}
		
		catch (e:Dynamic)
		{
			trace("error in giving experience points from statistics table to user.");
		}
		
		cnx.close();
	}
	
	/******************************
	 *	give house coins to user after the game ends. house coins for a game lost is half that of a win.
	 * _coins		the house coins to give to user.
	 */
	public function giveHouseCoinsToUser(_user:String, _coins:Int):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			var rset = cnx.request("UPDATE statistics SET 
			house_coins = house_coins + " + _coins + " WHERE user = " + cnx.quote(_user) );
		}
		
		catch (e:Dynamic)
		{
			trace("error in giving house coins from statistics table to user.");
		}
		
		cnx.close();
	}
	
	// room data changes every time player calls "Greater" or "Lesser" room data events.
	public function selectRoomData(_room:Int):MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE room = " + _room + " 
		ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._roomState.push(row.room_state);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
		}

		return _mysqlData;
	}
	
	
	public function selectGameRoomDataNoSpectatorWatching(_room:Int):MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE spectator_watching = 0 AND user_location = 3 AND room = " + _room + " 
		ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._roomState.push(row.room_state);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
			_mysqlData._gamePlayersValues.push(row.game_players_values);
			_mysqlData._spectatorPlaying.push(row.spectator_playing);
			_mysqlData._spectatorWatching.push(row.spectator_watching);
			_mysqlData._moveNumberDynamic.push(row.move_number_dynamic);
		}

		return _mysqlData;
	}
	
	public function selectRoomDataIsGameFinished():MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE is_game_finished = 1 AND user_location = '0' ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._roomState.push(row.room_state);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
		}

		return _mysqlData;
	}
	
	// userLocation var changes every time player calls "Greater" or "Lesser" room data events, except for the other party when player leaves a game. eg, var is changed for the leaving playing but not anyone that gets the message about the player leaving.
	public function selectRoomDataUserLocation(_room:Int):MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE 
		user_location = '3' AND room = " + _room + " 
		ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
			_mysqlData._isGameFinished.push(row.is_game_finished);
			_mysqlData._gamePlayersValues.push(row.game_players_values);
			_mysqlData._spectatorPlaying.push(row.spectator_playing);
		}

		cnx.close();

		return _mysqlData;
	}
	
	// get all data for room_data table.
	public function selectRoomDataAll():MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data
		ORDER BY room DESC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userId.push(row.user_id);
			_mysqlData._roomState.push(row.room_state);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._vsComputer.push(row.vs_computer);
			_mysqlData._allowSpectators.push(row.allow_spectators);
			_mysqlData._gameId.push(row.game_id);
			_mysqlData._timestamp.push(row.timestamp);
		}

		cnx.close();

		return _mysqlData;
	}
	
	
	// get all data for user at this room_data table.
	public function selectRoomDataUser(_user:String):MysqlData
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("SELECT * FROM room_data WHERE user = " + cnx.quote(_user));
		
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._userId.push(row.user_id);
				_mysqlData._roomState.push(row.room_state);
				_mysqlData._userLocation.push(row.user_location);
				_mysqlData._room.push(row.room);
				_mysqlData._playerLimit.push(row.player_limit);
				_mysqlData._isGameFinished.push(row.is_game_finished);
				_mysqlData._timestamp.push(row.timestamp);
				_mysqlData._gamePlayersValues.push(row.game_players_values);
				_mysqlData._spectatorPlaying.push(row.spectator_playing);
				_mysqlData._spectatorWatching.push(row.spectator_watching);
				_mysqlData._gameId.push(row.game_id);
			}
		}
		
		catch (e:Dynamic)
		{
			trace("game_player, error room_data table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	// used to populate the .usernameOther to display the user's name and stats correctly at waiting room.
	public function selectPlayersUsernames(_room:Int):MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE 
		user_location > '1' AND spectator_watching = '0' AND room = " + _room + " 
		ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
			_mysqlData._gamePlayersValues.push(row.game_players_values);
			_mysqlData._spectatorPlaying.push(row.spectator_playing);
			_mysqlData._spectatorWatching.push(row.spectator_watching);
		}

		cnx.close();

		return _mysqlData;
	}
	
	// used to populate the .usernameOther to display the user's name and stats correctly at game room.
	public function selectPlayersUsernames2(_room:Int):MysqlData
	{
		tryMysqlConnectDatabase();		
	
		var rset = cnx.request("SELECT * FROM room_data WHERE 
		room_state = '8' AND user_location = '3' AND room = " + _room + " ORDER BY timestamp ASC");
		
		for ( row in rset )
		{			
			_mysqlData._user.push(row.user);
			_mysqlData._userLocation.push(row.user_location);
			_mysqlData._room.push(row.room);
			_mysqlData._playerLimit.push(row.player_limit);
			_mysqlData._timestamp.push(row.timestamp);
			_mysqlData._gamePlayersValues.push(row.game_players_values);
			_mysqlData._spectatorPlaying.push(row.spectator_playing);
		}

		cnx.close();

		return _mysqlData;
	}
	
	// get players in all rooms that are not playing a game. 
	public function selectAllPlayersInRoomButNotPlayingGame():MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT room FROM room_data WHERE 
			user_location = '2' ORDER BY timestamp ASC");
			
			for ( row in rset )
			{	
				_mysqlData._room.push(row.room);
			}

		}
		catch (e:Dynamic)
		{
			trace("selectAllPlayersNotPlayingGame not selected at users table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	 * used to determine if a room is locked.
	 */
	public function selectRoomIslocked(_room:Int):MysqlData
	{
		tryMysqlConnectDatabase();
		
		try 
		{
			var rset = cnx.request("SELECT * FROM room_lock WHERE room = " + _room);
			for ( row in rset )
			{	
				_mysqlData._room.push(row.room);
			}
		}
		catch (e:Dynamic)
		{
			trace("error trying to get room_lock data.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	* load daily quest data for player.
	*/
	public function selectDailyQuestsData(_user:String):MysqlData
	{
	   tryMysqlConnectDatabase();
	   
	   try 
	   {
		   var rset = cnx.request("SELECT * FROM daily_quests WHERE user = " + cnx.quote(_user));
		   for ( row in rset )
		   {	
				_mysqlData._three_in_a_row.push(row.three_in_a_row);
				_mysqlData._chess_5_moves_under.push(row.chess_5_moves_under);
				_mysqlData._snakes_under_4_moves.push(row.snakes_under_4_moves);
				_mysqlData._win_5_minute_game.push(row.win_5_minute_game);
				_mysqlData._buy_four_house_items.push(row.buy_four_house_items);
				_mysqlData._finish_signature_game.push(row.finish_signature_game);
				_mysqlData._reversi_occupy_50_units.push(row.reversi_occupy_50_units);
				_mysqlData._checkers_get_6_kings.push(row.checkers_get_6_kings);
				_mysqlData._play_all_5_board_games.push(row.play_all_5_board_games);
				_mysqlData._day_name.push(row.day_name);
				_mysqlData._rewards.push(row.rewards);
				_mysqlData._timestamp.push(row.timestamp);
		   }
	   }
	   catch (e:Dynamic)
	   {
		   trace("error trying to load daily quests data.");
	   }
	   
	   cnx.close();
	   
	   return _mysqlData;
	   
	}
	
	public function select_tournament_data():MysqlData
	{
		tryMysqlConnectDatabase();	
		
		try 
		{
			var rset = cnx.request("SELECT * FROM tournament_data WHERE id = 1");
			for ( row in rset )
			{
				_mysqlData._player_maximum.push(row.players);
			}
		}
		catch (e:Dynamic)
		{
			trace("error trying to get tournament_data.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function select_tournament_chess_standard_8_count():Int
	{
		tryMysqlConnectDatabase();	
		
		var rset = cnx.request("SELECT COUNT(*) FROM tournament_chess_standard_8");
		
		cnx.close();
		
		return rset.getIntResult(0);
	}
	
	public function select_tournament_chess_standard_8(_user:String, _game_id:Int):MysqlData
	{
		tryMysqlConnectDatabase();			
				
		try 
		{
			var rset = cnx.request("SELECT * FROM tournament_chess_standard_8 WHERE player1 = " + cnx.quote(_user) );
			for ( row in rset )
			{
				_mysqlData._user.push(row.player1);
				_mysqlData._user2.push(row.player2);
				_mysqlData._gid.push(row.gid);
				_mysqlData._tournament_started.push(row.tournament_started);
				_mysqlData._move_total.push(row.move_total);
				_mysqlData._room.push(row.room);
				_mysqlData._round_current.push(row.round_current);
				_mysqlData._rounds_total.push(row.rounds_total);
				_mysqlData._won_game.push(row.won_game);
				_mysqlData._move_piece.push(row.move_piece);
				_mysqlData._move_number_current.push(row.move_number_current);
				_mysqlData._time_remaining_player1.push(row.time_remaining_player1);
				_mysqlData._time_remaining_player2.push(row.time_remaining_player2);
				_mysqlData._isGameFinished.push(row.game_over);
				_mysqlData._timestamp.push(row.timestamp);
			}
		}
		catch (e:Dynamic)
		{
			trace("error trying to get tournament_chess_standard_8 data.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	// at tournament a player's piece was moved. update the time and anything else needed to continue the tournament play.
	public function update_tournament_chess_standard_8(_player1:String, _player2:String, _time_remaining_player1:String, _time_remaining_player2:String, _move_number_current):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			if (_move_number_current == 0)
			{
				var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
				time_remaining_player1 = " + cnx.quote(_time_remaining_player1) + ",
				move_piece = 0,
				timestamp = UNIX_TIMESTAMP(),
				reminder_mail_sent = 1,
				move_total = move_total + 1
				WHERE player1 = " + cnx.quote(_player1) );
				
				// the other player is now able to move piece so update these.
				var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
				time_remaining_player1 = " + cnx.quote(_time_remaining_player1) + ",
				move_piece = 1,
				timestamp = UNIX_TIMESTAMP(),
				reminder_mail_sent = 0
				WHERE player1 = " + cnx.quote(_player2) );
			}
			
			else
			{
				var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
				time_remaining_player2 = " + cnx.quote(_time_remaining_player2) + ",
				move_piece = 0,
				timestamp = UNIX_TIMESTAMP(),
				reminder_mail_sent = 1,
				move_total = move_total + 1
				WHERE player1 = " + cnx.quote(_player1) );
				
				var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
				time_remaining_player2 = " + cnx.quote(_time_remaining_player2) + ",
				move_piece = 1,
				timestamp = UNIX_TIMESTAMP(),
				reminder_mail_sent = 0
				WHERE player1 = " + cnx.quote(_player2) );
			}
		}
		catch (e:Dynamic)
		{
			trace("error update select_tournament_chess_standard_8 table.");
		}
		
		cnx.close();
	
	}
	
	// if game over, from a checkmate or something, end game for both players.
	public function update_tournament_chess_standard_8_game_over(_player1:String, _player2:String, _won_game1:Int, _won_game2:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
			move_piece = 0,
			game_over = 1,
			won_game = " + _won_game1 + ",
			players = players - " + _won_game1 + "			
			WHERE player1 = " + cnx.quote(_player1) );
				
			var _var = cnx.request("UPDATE tournament_chess_standard_8 SET 
			move_piece = 0,
			game_over = 1,
			won_game = " + _won_game2 + ",
			players = players - " + _won_game2 + "
			WHERE player1 = " + cnx.quote(_player2) );
			
		}
		catch (e:Dynamic)
		{
			trace("error update select_tournament_chess_standard_8_game_over table.");
		}
		
		cnx.close();
	
	}
	
	// win three in a row.
	public function saveDailyQuests_3_in_a_row_win(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			three_in_a_row = three_in_a_row + 1 WHERE three_in_a_row < 3 AND user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update three_in_a_row_win daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	// lose a game and the win "three in a row" will be set back to zero.
	public function saveDailyQuests_3_in_a_row_lose(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			three_in_a_row = 0 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update three_in_a_row_lose daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_chess_5_moves_under(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			chess_5_moves_under = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update _chess_5_moves_under daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_snakes_under_4_moves(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			snakes_under_4_moves = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update _snakes_under_4_moves daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_win_5_minute_game(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			win_5_minute_game = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update _win_5_minute_game daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_buy_four_house_items(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			buy_four_house_items = buy_four_house_items + 1 WHERE buy_four_house_items < 4 AND user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update _buy_four_house_items daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_finish_signature_game(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			finish_signature_game = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update _finish_signature_game daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_reversi_occupy_50_units(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			reversi_occupy_50_units = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update _reversi_occupy_50_units daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_checkers_get_6_kings(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			checkers_get_6_kings = 1 WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update _checkers_get_6_kings daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_play_all_5_board_games(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var _var = cnx.request("UPDATE daily_quests SET 
			play_all_5_board_games = play_all_5_board_games + 1 WHERE play_all_5_board_games < 5 AND user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update _play_all_5_board_games daily quest table field.");
		}
		
		cnx.close();
	
	}
	
	public function saveDailyQuests_rewards(_user:String, _rewards:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var rset = cnx.request("UPDATE daily_quests SET 
			rewards = " + cnx.quote(_rewards) + " WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update error _rewards daily quest table field.");
		}
		
		cnx.close();
	
	}
		
	public function daily_reward_save(_user:String, _experiencePoints:Int, _houseCoins:Int, _creditsTotal:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			var rset = cnx.request("UPDATE statistics SET 
			experience_points = " + _experiencePoints + ",
			house_coins = " + _houseCoins + ",
			credits_total = " + _creditsTotal + "
			WHERE user = " + cnx.quote(_user) );
		}
		catch (e:Dynamic)
		{
			trace("update error at saveDaily_reward_save function, db error.");
		}
		
		cnx.close();
	
	}
	
	public function getGamePlayer(_user:String):MysqlData
	{
		tryMysqlConnectDatabase();	
		_user = Std.string(_user);
		
		try {
			
			var rset = cnx.request("SELECT * FROM room_data WHERE user_location = '3' AND user = " + cnx.quote(_user));
		
			for ( row in rset )
			{
				_mysqlData._user.push(row.user);
				_mysqlData._gamePlayersValues.push(row.game_players_values);
				_mysqlData._spectatorPlaying.push(row.spectator_playing);
			}
					
		}
		catch (e:Dynamic)
		{
			trace("game_player, error room_data table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	// get players stats, such as win or draws.
	public function getStatsWinLoseDrawFromUsers(_user:String):MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
					
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._gamesAllTotalWins.push(row.games_all_total_wins);
				_mysqlData._gamesAllTotalLosses.push(row.games_all_total_losses);
				_mysqlData._gamesAllTotalDraws.push(row.games_all_total_draws);
				_mysqlData._chess_elo_rating.push(row.chess_elo_rating);
			}

		}
		catch (e:Dynamic)
		{
			trace("getStatsWinLoseDrawFromUsers not selected at statistics table.");
		}
				
		cnx.close();
		
		return _mysqlData;
	}
	
	// get players stats, such as win or draws.
	public function getStatsAllFromUsers(_user:String):MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE user = " + cnx.quote(_user));
					
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._chess_elo_rating.push(row.chess_elo_rating);
				_mysqlData._gamesAllTotalWins.push(row.games_all_total_wins);
				_mysqlData._gamesAllTotalLosses.push(row.games_all_total_losses);
				_mysqlData._gamesAllTotalDraws.push(row.games_all_total_draws);
				_mysqlData._creditsTotal.push(row.credits_total);
				_mysqlData._experiencePoints.push(row.experience_points);
				_mysqlData._houseCoins.push(row.house_coins);
				
				_mysqlData._checkersWins.push(row.checkers_wins);
				_mysqlData._checkersLosses.push(row.checkers_losses);
				_mysqlData._checkersDraws.push(row.checkers_draws);
				_mysqlData._chessWins.push(row.chess_wins);
				_mysqlData._chessLosses.push(row.chess_losses);
				_mysqlData._chessDraws.push(row.chess_draws);
				_mysqlData._reversiWins.push(row.reversi_wins);
				_mysqlData._reversiLosses.push(row.reversi_losses);
				_mysqlData._reversiDraws.push(row.reversi_draws);
				_mysqlData._snakesAndLaddersWins.push(row.snakes_and_ladders_wins);
				_mysqlData._snakesAndLaddersLosses.push(row.snakes_and_ladders_losses);
				_mysqlData._snakesAndLaddersDraws.push(row.snakes_and_ladders_draws);
				_mysqlData._signatureGameWins.push(row.signature_game_wins);
				_mysqlData._signatureGameLosses.push(row.signature_game_losses);
				_mysqlData._signatureGameDraws.push(row.signature_game_draws);
			}

		}
		catch (e:Dynamic)
		{
			trace("getStatsWinLoseDrawFromUsers not selected at statistics table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	/******************************
	* get top 59 leaderboard xp list.
	*/
	public function getLeaderboards():MysqlData
	{
		tryMysqlConnectDatabase();
				
		try {
			var rset = cnx.request("SELECT * FROM statistics WHERE world_flag != 0 ORDER BY experience_points DESC LIMIT 50");
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._experiencePoints.push(row.experience_points);
				_mysqlData._houseCoins.push(row.house_coins);
				_mysqlData._worldFlag.push(row.world_flag);
			}

		}
		catch (e:Dynamic)
		{
			trace("getLeaderboards() error at that function.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}

	
	// get all users in game room.
	public function getAllFromUsers(_user:String):MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM room_data WHERE user = " + cnx.quote(_user));
					
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._room.push(row.room);
			}

		}
		catch (e:Dynamic)
		{
			trace("room not found at users table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	
	public function getHouseDataForUser(_user:String):MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM house WHERE user = " + cnx.quote(_user));
					
			for ( row in rset )
			{
				_mysqlData._user.push(row.user);
				
				_mysqlData._spriteNumber.push(row.sprite_number);
				_mysqlData._spriteName.push(row.sprite_name);
				_mysqlData._itemsX.push(row.items_x);
				_mysqlData._itemsY.push(row.items_y);
				_mysqlData._mapX.push(row.map_x);
				_mysqlData._mapY.push(row.map_y);
				_mysqlData._isItemPurchased.push(row.is_item_purchased);
				
				_mysqlData._itemDirectionFacing.push(row.item_direction_facing);
				_mysqlData._mapOffsetX.push(row.map_offset_x);
				_mysqlData._mapOffsetY.push(row.map_offset_y);
				_mysqlData._itemIsHidden.push(row.item_is_hidden);
				_mysqlData._itemOrder.push(row.item_order);
				_mysqlData._itemBehindWalls.push(row.item_behind_walls);
				_mysqlData._floor.push(row.floor);
				
				_mysqlData._wallLeft.push(row.wall_left);
				_mysqlData._wallUpBehind.push(row.wall_up_behind);
				_mysqlData._wallUpInFront.push(row.wall_up_in_front);
				_mysqlData._floorIsHidden.push(row.floor_is_hidden);
				_mysqlData._wallLeftIsHidden.push(row.wall_left_is_hidden);
				_mysqlData._wallUpBehindIsHidden.push(row.wall_up_behind_is_hidden);
				_mysqlData._wallUpInFrontIsHidden.push(row.wall_up_in_front_is_hidden);
			}

		}
		catch (e:Dynamic)
		{
			trace("error at loading house table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	
	
	/******************************
	 * is the player a paid member.
	 */
	public function isPaidMemberFromUsers(_user:String):MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("SELECT * FROM users WHERE user = " + cnx.quote(_user));
					
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._isPaidMember.push(row.is_paid_member);
			}

		}
		catch (e:Dynamic)
		{
			trace("is_paid_member data not found at users table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	
	
	public function saveRoomState(_user:String, _roomState:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		var _var = cnx.request("UPDATE room_data SET timestamp = UNIX_TIMESTAMP(), room_state = " + _roomState + " WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function saveRoomToZero(_room:Int, _roomState:Int, _userLocation:Int, _roomPlayerLimit:Int):Void
	{
		tryMysqlConnectDatabase();		

		var _var = cnx.request("UPDATE room_data SET 
		room_state = 0,
		user_location = 0,
		room = 0,
		player_limit = 0
		WHERE room = " + _room);
					
		cnx.close();
	
	}
	
	
	public function saveUsernameDataToZero(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		var _var = cnx.request("UPDATE room_data SET 
		room_state = 0,
		user_location = 0,
		room = 0,
		player_limit = 0,
		allow_spectators = 0,
		spectator_watching = 0, 
		spectator_playing = 0
		WHERE user = " + cnx.quote(_user));	
					
		cnx.close();
	
	}
	
	
	public function deleteIsHost(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("DELETE FROM who_is_host WHERE user = " + cnx.quote(_user));		
		}
		catch (e:Dynamic)
		{
			trace("who_is_host not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	public function update_avatar_at_login(_user:String, _avatar:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("UPDATE statistics SET user_avatar = " + cnx.quote(_avatar) + " WHERE user = " + cnx.quote(_user));				
		}
		catch (e:Dynamic)
		{
			trace("errer at update_avatar_at_login function.");
		}
		
		cnx.close();
	
	}
	
	public function updateUsersKickedData(_user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("UPDATE users SET is_kicked = 0 WHERE user = " + cnx.quote(_user));				
		}
		catch (e:Dynamic)
		{
			trace("update user set kicked to zero not updated.");
		}
		
		cnx.close();
	
	}
	
	// player is no longer using a guest account. change names.
	public function update_players_name(_user:String, _old_username:String, _password_hash:String, _hostname:String):Void
	{
		tryMysqlConnectDatabase();
		
		try {
			var rset = cnx.request("UPDATE users SET user = " + cnx.quote(_user) + ", password_hash = " + cnx.quote(_password_hash) + "  WHERE user like 'Guest%' AND user = " + cnx.quote(_old_username) + " AND hostname = " + cnx.quote(_hostname));
			
			var rset2 = cnx.request("UPDATE house SET user = " + cnx.quote(_user) + " WHERE user like 'Guest%' AND user = " + cnx.quote(_old_username));
			
			var rset3 = cnx.request("UPDATE statistics SET user = " + cnx.quote(_user) + " WHERE user like 'Guest%' AND user = " + cnx.quote(_old_username));
		}
		
		catch (e:Dynamic)
		{
			trace("error at mysql table update_players_name.");
		}
		
		cnx.close();
	
	}
	
	// userLocation was 7 but a player is ending a game and returning to lobby, so nobody should be host of the room.
	public function deleteIsHostRoom(_room:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var rset = cnx.request("DELETE FROM who_is_host WHERE room = " + _room);				
		}
		catch (e:Dynamic)
		{
			trace("who_is_host not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	
	public function countIsHost(_room:Int):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM who_is_host WHERE room = " + _room);
				
		cnx.close();
		
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	public function loadIsHost():MysqlData
	{
		tryMysqlConnectDatabase();		
	
		try {
			var rset = cnx.request("SELECT * FROM who_is_host");
			
			for ( row in rset )
			{			
				_mysqlData._user.push(row.user);
				_mysqlData._room.push(row.room);
				_mysqlData._gid.push(row.gid);
			}
					
		}
		catch (e:Dynamic)
		{
			trace("who_is_host not updated at room_data table.");
		}
		
		cnx.close();
	
		return _mysqlData;
	}
	
	
	public function saveRoomLock(_user:String, _room:Int):Void
	{
		tryMysqlConnectDatabase();
		
		cnx.request("INSERT IGNORE INTO room_lock set room = " + _room + ", is_locked = 1, user = " + cnx.quote(_user));
		
		cnx.close();
	}
	
	public function deleteRoomUnlock(_user:String, _room:Int):Void
	{
		tryMysqlConnectDatabase();
		
		try
		{
			cnx.request("DELETE FROM room_lock WHERE user = " + cnx.quote(_user)); 		
		}
		catch (e:Dynamic)
		{
			trace("room_lock table not deleted.");
		}
		
		cnx.close();
	}
	
	
	// this function is called every so many clicks at waiting room.
	public function saveIsHost(_user:String, _gid:String, _room:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var rset = cnx.request("DELETE FROM who_is_host WHERE room = " + _room);	
			
			var _var = cnx.request("INSERT INTO who_is_host SET 
			user = " + cnx.quote(_user) + ", gid = " + cnx.quote(_gid) + ", room = " + _room);
		}
		catch (e:Dynamic)
		{
			trace("who_is_host not updated at table.");
		}
		
		cnx.close();
	
	}
	
	public function saveUserLocationToZero(_room:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			user_location = 0
			WHERE user_location = 3 AND room = 0" );
					
		}
		catch (e:Dynamic)
		{
			trace("room to zero not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	
	// save room state for users in room.
	public function saveRoomStateRoom(_room:Int, _roomState:Int, _userLocation:Int, _roomPlayerLimit:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			user_location = " + _userLocation + ", 
			player_limit = " + _roomPlayerLimit + ", 	
			game_players_values = '0',
			room_state = " + _roomState + " WHERE room = " + _room );
					
		}
		catch (e:Dynamic)
		{
			trace("roomState not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	public function moveNumber(_user:String, _moveNumberDynamic:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			move_number_dynamic = " + _moveNumberDynamic + " WHERE user = " + cnx.quote(_user));	
		}
		catch (e:Dynamic)
		{
			trace("move number var not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	public function saveRoomPlayerLimit(_user:String, _room:Int, _roomPlayerLimit:Int):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			player_limit = " + _roomPlayerLimit + " WHERE room = " + _room );
			
			var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = 0, game_id = -1 WHERE user = " + cnx.quote(_user));
		}
		catch (e:Dynamic)
		{
			trace("save player limit not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	/**
	 * @param	_user					name of user that entered the event.
	 * @param	_isGameFinished			is the current game finished?
	 * @param	_spectatorWatching		did the user enter game room by clicking the watch button from lobby?
	 */
	public function saveIsGameFinishedUser(_user:String, _isGameFinished:Bool, _spectatorWatching:Bool):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			is_game_finished = " + _isGameFinished + " WHERE user = " + cnx.quote(_user));
			
			if (_isGameFinished == false && _spectatorWatching == false)
			{
				var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = 1 WHERE user = " + cnx.quote(_user));
			}
					
		}
		catch (e:Dynamic)
		{
			trace("roomState not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	// _dataMisc
	public function saveGamePlayer(_user:String, _gamePlayersValues:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			game_players_values = " + _gamePlayersValues + " WHERE user = " + cnx.quote(_user));
					
		}
		catch (e:Dynamic)
		{
			trace("game players not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	public function saveSpectator(_user:String, _spectatorPlaying:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = " + _spectatorPlaying + " WHERE user = " + cnx.quote(_user));
					
		}
		catch (e:Dynamic)
		{
			trace("spectator_playing not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	// save room state for users in room.
	public function saveIsGameFinished(_room:Int, _isGameFinished:Bool, _is_spectator_watching:Bool):Void
	{
		tryMysqlConnectDatabase();		
	
		try {
			var _var = cnx.request("UPDATE room_data SET 
			is_game_finished = " + _isGameFinished + " WHERE room = " + _room );
			
			if (_isGameFinished == false)
			{
				if (_is_spectator_watching == false)
				{
					var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = 1 WHERE room = " + _room );
				}
			}
		}
		catch (e:Dynamic)
		{
			trace("roomState not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	
	// player just entered game room, so set spectator_playing as true.
	public function saveSpectatorsOfGamePlayersToRoomFalse(_room:Int, _spectatorPlaying:Bool):Void
	{
		tryMysqlConnectDatabase();		
	
		_spectatorPlaying = false; // value = 0.
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			spectator_playing = " + _spectatorPlaying + " WHERE room = " + _room );
					
		}
		catch (e:Dynamic)
		{
			trace("saveSpectatorsOfGamePlayersToTrue not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	public function saveRoomData(_user:String, _roomState:Int, _userlocation:Int, _room:Int, _roomPlayerLimit:Int, _gameId:Int, _vsComputer:Int, _allowSpectators:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		var _var = cnx.request("UPDATE room_data SET 
		room_state = " + _roomState + ", 
		user_location = " + _userlocation + ", 
		game_id = " + _gameId + ",
		room = " + _room + ",
		vs_computer = " + _vsComputer + ",
		allow_spectators = " + _allowSpectators + ",
		timestamp = UNIX_TIMESTAMP(),
		player_limit = " + _roomPlayerLimit + " WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function _spectatorWatching(_user:String, _roomState:Int, _userlocation:Int, _room:Int, _roomPlayerLimit:Int, _gameId:Int, _vsComputer:Int, _allowSpectators:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		var _var = cnx.request("UPDATE room_data SET 
		room_state = " + _roomState + ", 
		user_location = " + _userlocation + ", 
		game_id = " + _gameId + ",
		room = " + _room + ",
		vs_computer = " + _vsComputer + ",
		allow_spectators = " + _allowSpectators + ",
		timestamp = UNIX_TIMESTAMP(),
		player_limit = " + _roomPlayerLimit + ",
		spectator_watching = 1,
		game_players_values = 0 WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function saveRoomAtRoomData(_roomState:Int, _room:Int):Void
	{
		tryMysqlConnectDatabase();		
		
		
		try {
			var _var = cnx.request("UPDATE room_data SET 
			room_state = " + _roomState + "
			WHERE user_location = 2 AND room = " + _room );
		
		}
		catch (e:Dynamic)
		{
			trace("saveRoomAtRoomData not updated at room_data table.");
		}
		
		cnx.close();
	
	}
	
	public function password_hash(_user:String, _password_hash:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try {
			var _var = cnx.request("UPDATE users SET 
			password_hash = " + cnx.quote(_password_hash) + "
			WHERE user = " + cnx.quote(_user));
		
		}
		catch (e:Dynamic)
		{
			trace("password_hash not updated at password_hash function.");
		}
		
		cnx.close();
	
	}
	
	public function saveHouseDataForUser(_user:String, _sprite_number:String, _sprite_name:String, _items_x:String, _items_y:String, _map_x:String, _map_y:String, _is_item_purchased:String, _item_direction_facing:String, _map_offset_x:String, _map_offset_y:String, _item_is_hidden:String, _item_order:String, _item_behind_walls:String, _floor:String, _wall_left:String, _wall_up_behind:String, _wall_up_in_front:String, _floor_is_hidden:String, _wall_left_is_hidden:String, _wall_up_behind_is_hidden:String, _wall_up_in_front_is_hidden:String):MysqlData
	{
		tryMysqlConnectDatabase();
		
		try {
			var _var = cnx.request("UPDATE house SET 
			sprite_number = " + cnx.quote(_sprite_number) + ",
			sprite_name = " + cnx.quote(_sprite_name) + ",
			items_x = " + cnx.quote(_items_x) + ",
			items_y = " + cnx.quote(_items_y) + ",
			map_x = " + cnx.quote(_map_x) + ",
			map_y = " + cnx.quote(_map_y) + ",
			is_item_purchased = " + cnx.quote(_is_item_purchased) + ",
			item_direction_facing = " + cnx.quote(_item_direction_facing) + ",
			map_offset_x = " + cnx.quote(_map_offset_x) + ",
			map_offset_y = " + cnx.quote(_map_offset_y) + ",
			item_is_hidden = " + cnx.quote(_item_is_hidden) + ",
			item_order = " + cnx.quote(_item_order) + ",
			item_behind_walls = " + cnx.quote(_item_behind_walls) + ",		
			floor = " + cnx.quote(_floor) + ",
			wall_left = " + cnx.quote(_wall_left) + ",
			wall_up_behind = " + cnx.quote(_wall_up_behind) + ",
			wall_up_in_front = " + cnx.quote(_wall_up_in_front) + ",
			floor_is_hidden = " + cnx.quote(_floor_is_hidden) + ",
			wall_left_is_hidden = " + cnx.quote(_wall_left_is_hidden) + ",
			wall_up_behind_is_hidden = " + cnx.quote(_wall_up_behind_is_hidden) + ",
			wall_up_in_front_is_hidden = " + cnx.quote(_wall_up_in_front_is_hidden) + "
			WHERE user = " + cnx.quote(_user));

		}
		catch (e:Dynamic)
		{
			trace("error at saving house table.");
		}
		
		cnx.close();
		
		return _mysqlData;
	}
	
	public function usersSetActionCount(_user:String, _actionWho:String):Bool
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM user_actions WHERE user = " + cnx.quote(_user) + " AND action_who = " + cnx.quote(_actionWho));
				
		cnx.close();
		
		if (rset.getIntResult(0) == 0) return false;
		else return true;
	}
	
	public function usersPlayingGameCount(_room:Int):Int
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM room_data WHERE room_state = '8' AND room = " + _room);
				
		cnx.close();
		
		return rset.getIntResult(0);
	
	}
	
	public function usersPlayingGameCount2(_room:Int):Int
	{
		tryMysqlConnectDatabase();
		
		var rset = cnx.request("SELECT COUNT(*) FROM room_data WHERE room_state > '0' AND room = " + _room);
				
		cnx.close();
		
		return rset.getIntResult(0);
	
	}
	
	public function usersSetActionInsert(_user:String, _actionWho:String, _actionNumber:Int):Void
	{
		tryMysqlConnectDatabase();		
		//var _timestamp:Int = Std.int(Sys.time());
		
		try {
			var rset = cnx.request("INSERT INTO user_actions SET user = " + cnx.quote(_user) + ",
			action_who = " + cnx.quote(_actionWho) + ",
			action_number = " + _actionNumber + ",
			timestamp = UNIX_TIMESTAMP()");
				
		}
		catch (e:Dynamic)
		{	
			trace("user_actions not inserted at room_data table.");
		}
		
		cnx.close();
	
	}
	
	public function saveWinStats(_gameId:Int, _user:String, _gameTimePlayedInSeconds:Int = 0):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			if (_gameTimePlayedInSeconds != 0)
			{
				var _var = cnx.request("UPDATE statistics SET shortest_time_game_played = " + _gameTimePlayedInSeconds + " WHERE shortest_time_game_played > " + _gameTimePlayedInSeconds + " AND user = " + cnx.quote(_user) );
				
				var _var = cnx.request("UPDATE statistics SET longest_time_game_played = " + _gameTimePlayedInSeconds + " WHERE longest_time_game_played < " + _gameTimePlayedInSeconds + " AND user = " + cnx.quote(_user) );
			}
			
			// update the win streak and set the lose and draw streak to 0 since those game streaks have ended.
			var _var = cnx.request("UPDATE statistics SET longest_current_winning_streak = longest_current_winning_streak + 1, longest_current_losing_streak = 0, longest_current_draw_streak = 0 WHERE user = " + cnx.quote(_user) );
			
		}
		
		catch (e:Dynamic)
		{	
			trace("at function saveWinStats(), _gameTimePlayedInSeconds var not inserted at stats table.");
		}
		
		// save a stat to the game that was just played.
		if (_gameId == 0)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, checkers_wins = checkers_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		if (_gameId == 1)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, chess_wins = chess_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 2)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, reversi_wins = reversi_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 3)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, snakes_and_ladders_wins = snakes_and_ladders_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 4)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_wins = games_all_total_wins + 1, signature_game_wins = signature_game_wins + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		var _var = cnx.request("UPDATE room_data SET spectator_playing = 0 WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function saveLoseStats(_gameId:Int, _user:String, _gameTimePlayedInSeconds:Int = 0):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			if (_gameTimePlayedInSeconds != 0)
			{
				var _var = cnx.request("UPDATE statistics SET shortest_time_game_played = " + _gameTimePlayedInSeconds + " WHERE shortest_time_game_played > " + _gameTimePlayedInSeconds + " AND user = " + cnx.quote(_user) );
				
				var _var = cnx.request("UPDATE statistics SET longest_time_game_played = " + _gameTimePlayedInSeconds + " WHERE longest_time_game_played < " + _gameTimePlayedInSeconds + " AND user = " + cnx.quote(_user) );
			}
			
			// update the lose streak and set the win and draw streak to 0 since those game streaks have ended.
			var _var = cnx.request("UPDATE statistics SET longest_current_losing_streak = longest_current_losing_streak + 1, longest_current_winning_streak = 0, longest_current_draw_streak = 0 WHERE user = " + cnx.quote(_user) );
		}
		
		catch (e:Dynamic)
		{	
			trace("at function saveLoseStats(), _gameTimePlayedInSeconds var not inserted at stats table.");
		}
		
		if (_gameId == 0)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1,  games_all_total_losses = games_all_total_losses + 1, checkers_losses = checkers_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		if (_gameId == 1)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_losses = games_all_total_losses + 1, chess_losses = chess_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 2)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_losses = games_all_total_losses + 1, reversi_losses = reversi_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 3)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_losses = games_all_total_losses + 1, snakes_and_ladders_losses = snakes_and_ladders_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 4)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_losses = games_all_total_losses + 1, signature_game_losses = signature_game_losses + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		var _var = cnx.request("UPDATE room_data SET spectator_playing = 0 WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	public function saveDrawStats(_gameId:Int, _user:String):Void
	{
		tryMysqlConnectDatabase();		
		
		try
		{
			// update the draw streak and set the win and lose streak to 0 since those game streaks have ended.
			var _var = cnx.request("UPDATE statistics SET longest_current_draw_streak = longest_current_draw_streak + 1, longest_current_winning_streak = 0, longest_current_losing_streak = 0 WHERE user = " + cnx.quote(_user) );
		}
		
		
		if (_gameId == 0)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, checkers_draws = checkers_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		if (_gameId == 1)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, chess_draws = chess_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 2)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, reversi_draws = reversi_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 3)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, snakes_and_ladders_draws = snakes_and_ladders_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
			
		if (_gameId == 4)
		{
			var _var = cnx.request("UPDATE statistics SET total_games_played = total_games_played + 1, games_all_total_draws = games_all_total_draws + 1, signature_game_draws = signature_game_draws + 1 WHERE user = " + cnx.quote(_user) );
		}
		
		var _var = cnx.request("UPDATE room_data SET spectator_playing = 0 WHERE user = " + cnx.quote(_user) );
		
		cnx.close();
	
	}
	
	
	
	
	private function clearMysqlData():Void
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
		_mysqlData._won_game.splice(0, _mysqlData._won_game.length);
	}	
}//