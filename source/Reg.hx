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
//############################# NOTES
// The invalid operation errors on Neko come from uninitialized variables (int, bool, float), since these are by default null on Neko.

// Checking for null errors are important. The build error on neko, the invalid operation, come from uninitialized variables. To fix do var foo:int = 0. The 0 initializes that variable.
//#############################

/******************************
* all game data for all games are here.
*/
typedef DataGame = {
	id: String,					// id refers to a particular player.
	_room: Int					// current room that the user is in. zero 
}

typedef DataGame0 = {
	id: String,					// id refers to a particular player.
	_username: String,			// the username of the player.
	_gameUnitNumberNew: Int,	// unit number. 0-64
	_gameUnitNumberOld: Int,	// unit number. 0-64
	_gameXXold:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold:Int,				// unit y coordinate. you have requested this gameboard piece.
	_gameXXnew:Int,				// unit x coordinate. you have requested a piece be moved here.
	_gameYYnew:Int,				// unit y coordinate. you have requested a piece be moved here.
	_gameXXold2:Int,			// unit x coordinate. you have requested this gameboard piece.
	_gameYYold2:Int,			// unit y coordinate. you have requested this gameboard piece.
	_triggerNextStuffToDo:Int,	// used to determine if the pawn is En Passant.
	_room: Int,					// current room that the user is in. zero equals no room.
	_isThisPieceAtBackdoor:Bool,// each board game should use this for only one var.
}

typedef DataGame1 = {
	id: String,					// id refers to a particular player.
	_username: String,			// the username of the player._username: String,					 // the username of the player.
	_pieceValue: Int,			// this is the point value of each piece on the standard game board
	_uniqueValue: Int,			// unique value of a piece.
	_gameUnitNumberNew: Int,	// unit number. 0-64
	_gameUnitNumberOld: Int,	// unit number. 0-64
	_gameUnitNumberNew2: Int,	// unit number. 0-64
	_gameUnitNumberOld2: Int,	// unit number. 0-64
	_gameXXold:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold:Int,				// unit y coordinate. you have requested this gameboard piece.
	_gameXXnew:Int,				// unit x coordinate. you have requested a piece be moved here.
	_gameYYnew:Int,				// unit y coordinate. you have requested a piece be moved here.
	_gameXXold2:Int,			// unit x coordinate. you have requested this gameboard piece.
	_gameYYold2:Int,			// unit y coordinate. you have requested this gameboard piece.
	_gameXXnew2:Int,			// unit x coordinate. you have requested a piece be moved here.
	_gameYYnew2:Int,			// unit y coordinate. you have requested a piece be moved here.
	_isEnPassant:Bool,			// is pawn En passant? 
	_isEnPassantPawnNumber:Array<Int>,// the most recent pawn in En passant.
	_triggerNextStuffToDo:Int,	// used to determine if the pawn is En Passant.
	_pointValue2:Int,				// castling vars to move the rook.
	_uniqueValue2:Int,			// castling vars.
	_promotePieceLetter:String,// this is the letter used in notation of a promoted piece selected.
	_doneEnPassant:Bool,		// for notation.
	_room: Int,					// current room that the user is in. zero equals no room.
	/******************************
	 * capturing unit image value for history when using the backwards button.
	 */
	_piece_capturing_image_value: Int,
}

typedef DataGame2 = {
	id: String,					// id refers to a particular player.
	_username: String,			// the username of the player.
	_gameXXold:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold:Int,				// unit y coordinate. you have requested this gameboard piece.
	_triggerNextStuffToDo:Int,	// used to determine if the pawn is En Passant.
	_pointValue2:Int,				// castling vars to move the rook.
	_room: Int,					// current room that the user is in. zero equals no room.
}

typedef DataGame3 = {
	id: String,	
	_username: String,				// the username of the player.
	_gameUnitNumberNew: Int,		// unit number. 0-64
	_triggerEventForAllPlayers:Bool,// is pawn En passant? 
	// the most recent pawn in En passant.
	_triggerNextStuffToDo:Int,		// used to determine if the pawn is En Passant. also in Reversi, if all 4 discs have been placed on the board.
	_rolledA6:Bool,					// move again.
	_room: Int,						// current room that the user is in. zero equals no room.
}

typedef DataGame4 = {
	id: String,					// id refers to a particular player.
	_username: String,			// the username of the player.
	_gameXXold:Int,				// unit x coordinate. you have requested this gameboard piece.
	_gameYYold:Int,				// unit y coordinate. you have requested this gameboard piece.
	_gameXXnew:Int,				// unit x coordinate. you have requested a piece be moved here.
	_gameYYnew:Int,				// unit y coordinate. you have requested a piece be moved here.
	_gameXXold2:Int,			// used in trade unit. this is the player that is moving piece. player would like to trade this unit.
	_gameYYold2:Int,			// used in trade unit. this is the player that is moving piece. player would like to trade this unit.
	_gameXXnew2:Int,			// used in trade unit. this is the other player's unit. player moving would like to trade other player's unit.
	_gameYYnew2:Int,			// used in trade unit. this is the other player's unit. player moving would like to trade other player's unit.
	_room: Int,					// current room that the user is in. zero equals no room.
	_rentBonus:Array<Float>,		// total rent bonus in game.
	_gameUniqueValueForPiece:Array<Array<Int>>, // -1 = not used. 0 = nobody owns this unit. 1 = player 1's unit. 2:player 2's unit. 3:player 3's unit. 4:player 4's unit.
	_gameHouseAmountPerPiece:Array<Array<Int>>,	//amount of houses on each unit.
	_gameUndevelopedValueOfUnit:Array<Int>, // Undeveloped units. no houses, nobody owns this unit when a value for that unit equals not 1.
	_unitNumberTrade:Array<Int> // used when trading units. this holds the value of a unit number. this var is useful. it can change an ownership of a unit. see Reg._gameUniqueValueForPiece.
}

// movement.
typedef DataMovement = 
{
	id: String, // player instance. this tells one player from another.
	_username: String,			// the username of the player.
	
	/******************************
	 * game id. move_history fields are not deleted from the MySQL database. so this id is used so that a user accesses that correct move_history data.
	 */
	_gid: String,
	
	/******************************
	 * true if the spectator is watching the game.
	 */
	_spectatorWatching: Int,
	
	/******************************
	 * used to get the history from the room host.
	 */
	_username_room_host :String,
	
	/******************************
	 * used to get all history but only once per game room session. when all history is retrieved the normal next entry event will be called.
	 */
	_history_get_all: Int,
	
	_gameDiceMaximumIndex: Int, // unit number. 0-64
	_triggerNextStuffToDo:Int, // used to determine if the pawn is En Passant. also in Reversi, if all 4 discs have been placed on the board.
	_room: Int, // current room that the user is in. zero equals no room.
	/******************************
	 * If events a and b are sent from event c to the server in that order, sometimes the server will send back event b to the client before the server finishes event a.
	 * to solve that problem, at client, move event b to the bottom of event a and if this var has the name of event b then at that code line event b will be executed.
	 */
	_triggerEvent: String,
	
	/******************************
	 * the point value of a gameboard piece.
	 */
	_point_value: String,
	
	/******************************
	 * the unique value of a gameboard piece.
	 */
	_unique_value: String,
	
	_moveHistoryPieceLocationOld1: String,		// move history, the selected first piece
	_moveHistoryPieceLocationNew1: String,		// moved the first piece to selected location.
	_moveHistoryPieceLocationOld2: String,		// second piece, such as, the rook when castling. the second piece selected for that game move.
	_moveHistoryPieceLocationNew2: String,		// moved the second piece to selected location.
	
	_moveHistoryPieceValueOld1: String,		// image value of the selected first piece. if its a rook that first player selected then its a value of 4 else for second player then its a value of 14. normally this value is 0 because after the move, no piece is at that location.
	_moveHistoryPieceValueNew1: String,		// this refers to the value of the piece at the new selected moved to location.
	_moveHistoryPieceValueOld2: String,		// the second piece value, or piece image, normally this unit is empty because the second piece was moved to a new unit.
	_moveHistoryPieceValueNew2: String,		// this is the second piece moved to value of the image, so that the image can be moved to the new location.
	_moveHistoryPieceValueOld3: String,		// the captured piece value, its image.
	_moveHistoryTotalCount: Int,			// the total amount of all moves from all player playing gaming game.
}

typedef DataGameMessage = {
	id: String,	
	_username: String,			// the username of the player.
	_room: Int,					// current room that the user is in. zero equals no room.
	/******************************
	 * If events a and b are sent from event c to the server in that order, sometimes the server will send back event b to the client before the server finishes event a.
	 * to solve that problem, at client, move event b to the bottom of event a and if this var has the name of event b then at that code line event b will be executed.
	 */
	_triggerEvent: String,
	_gameMessage:String,		// an example of this would be a chess game where a player just received a message saying that the king is in check. this event sends that same message to the other party.	
	_userTo: String,
	_userFrom: String,
	_questionAnsweredAs: Bool, // this var can hold any message.
}

/******************************
 * compete these daily quests for rewards.
 */
typedef DataDailyQuests = 
{
	id: String,	
	_username: String,			// the username of the player.
	
	/******************************
	 * Win three board games in a row.
	 */
	_three_in_a_row: String,
	
	/******************************
	 * Win a chess game in 5 moves or under.
	 */
	_chess_5_moves_under: String,
	
	/******************************
	 * Win a snakes and ladders game in under 4 moves.
	 */
	_snakes_under_4_moves: String,
	
	/******************************
	 * Win a 5 minute game
	 */
	_win_5_minute_game: String,
	
	/******************************
	 * Buy any four house items
	 */
	_buy_four_house_items: String,
	
	/******************************
	 * Finish playing a signature game
	 */
	_finish_signature_game: String,
	
	/******************************
	 * Occupy a total of 50 units in Reversi
	 */
	_reversi_occupy_50_units: String,
	
	/******************************
	 * Get 6 Kinged pieces in 1 checkers game
	 */
	_checkers_get_6_kings: String, 
	
	/******************************
	 * play all 5 games.
	 */
	_play_all_5_board_games: String,
	
	/******************************
	 * a gauge is dashed lines that runs horizontally across the top part of the dailyQuests.hx scene. There are three reward icons. then the dash filled line reaches a reward icon then a claim reward button will appear.
	 * the third dashed line refers to the first value is this string. the second value in this var refers to the sixth dashed line and the last dash lined (ninth) refers to the third value. therefore three quests need to be completed before a reward can be given. so there is 9 dashed lines, an every third line that is highlighted means that a quest reward can be given.
	 * this string look like this... "2,1,0". a zero means that no prize is available, the 1 means that a rewards can be claimed and 2 means that the reward for those quests have been claimed. remember that 2 quests are needed for every reward and that the dashed lines refer to those quests.
	 */
	_rewards: String,
}

/******************************
 * all game buttons, chat, restart, etc.
 */
typedef DataQuestions = {
	id: String,						// id refers to a particular player.
	_username: String,			// the username of the player.
	_gameMessage:String,			// an example of this would be a chess game where a player just received a message saying that the king is in check.
	_drawOffer:Bool,				// chess draw offer. false=not yet asked. true=yes.
	_drawAnsweredAs:Bool,			// chess draw was answered as, false:no, true:yes 
	_restartGameOffer:Bool,			// restart game offer. false=not yet asked. true=yes.
	_restartGameAnsweredAs:Bool,	// restart game was answered as, false:no, true:yes.
	_room: Int,						// current room that the user is in. zero equals no room.
	/******************************
	 * If events a and b are sent from event c to the server in that order, sometimes the server will send back event b to the client before the server finishes event a.
	 * to solve that problem, at client, move event b to the bottom of event a and if this var has the name of event b then at that code line event b will be executed.
	 */
	_triggerEvent: String,
	_gameOver: Bool,				// is the game over?
}

// every player's name, win, lose, draw, etc.
typedef DataOnlinePlayers = 
{
	id:String,
	_username: String,			// the username of the player.
	_room: Int,					// current room that the user is in. zero equals no room.
	/******************************
	 * If events a and b are sent from event c to the server in that order, sometimes the server will send back event b to the client before the server finishes event a.
	 * to solve that problem, at client, move event b to the bottom of event a and if this var has the name of event b then at that code line event b will be executed.
	 */
	_triggerEvent: String,
	_usernamesOnline:Array<String>,	// players names that are online.
	_gameAllTotalWins:Array<Int>,			// any game played. players game wins of players online.
	_gameAllTotalLosses:Array<Int>,			// any game played. players game losses of players online.
	_gameAllTotalDraws:Array<Int>,			// any game played. players game draws of players online.	
	_chess_elo_rating:Array<Float>			// chess Elo rating for every player online.
}

typedef DataTournaments =
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id:String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
	
	/******************************
	 * if this name is not empty then its the name of the user in the tournament.
	 */
	_player1: String,
	
	/******************************
	 * if this var is not empty and username is _player1 then player1 maybe be playing against player 2,
	 */
	_player2: String,
	
	/******************************
	 * game id. move_history fields are not deleted from the MySQL database. so this id is used so that a user accesses that correct move_history data.
	 */
	_gid: String,
	
	/******************************
	 * 0:not started 1:started.
	 */
	_tournament_started: Bool,
	
	/******************************
	 * maximum total players in the current tournament. the current tournament is select with the _game_id var. see below.
	 */
	_player_maximum: Int,
	
	/******************************
	 * current player count in the current tournament. the current tournament is select with the _game_id var. see below.
	 */
	_player_current: Int,
	
	/******************************
	 * current room that the user is in. zero equals no room.
	 */
	_room: Int,
	
	/******************************
	 * used to determine what tournament is being referenced. a value of 1 and the chess tournament standard was selected. that value of 1, is the id at the MySQL database "tournament data" table. a value of 0 means that no tournament game was selected.
	 */
	_game_id: Int,
	
	_round_current: Int,		// current round of the tournament. 16 player tournament = this value of 0. 8 players has this value set at 1.

	_rounds_total: Int,			// when the round_current equals this value then the tournament is at its last round.
	
	/******************************
	 * game move total for player
	 */
	_move_total: Int,
	
	/******************************
	 * game move total for player
	 */
	_won_game: Int,
	
	/******************************
	 * a value of 1 means the game is over.
	 * if value is 0 then this player is a tournament player.
	 */
	_game_over: Int,
	
	/******************************
	 * 0:cannot move piece 1:player can move piece.
	 */
	_move_piece: Bool,
	
	/******************************
	 * time is seconds you have to move a piece. failing to move piece within time allowed will result in losing the game.
	 */
	_time_remaining_player1: String,
	_time_remaining_player2: String,
	
	// is it the players turn to move. a value of 1 = player1, 2=player2, etc.
	_move_number_current: Int,
	
	/******************************
	 * timestamp for player 1. 
	 * player 2 is not needed. the time might not be actuate when working with another players timestamp. the reason might be that a few seconds might be off from the time it takes to get and display the time. within that time, a player might have moved piece when instead we forfeit the game based on no activity from the user.
	 * for player 1, we use a lock so that the mailer knows that the player is in the process of moving a piece.
	 */
	_timestamp: Int,
}

// anything account related us here.
typedef DataAccount = 
{
	id: String,
	_username: String,				// the username of the player.
	_password_hash: String, 		// password hash encrypted with md5.
	_popupMessage: String, 		// the current message to be displayed as a dialog or popup box.
	_hostname: String,					// used to return the this local hosts name.
	_ip:String,					// IP address of player.
	_alreadyOnlineHost: Bool,		// is there two computers with the same host name connected to server?
	_alreadyOnlineUser: Bool,		// is there already a user with that username online?
	
	/******************************
	 * outputs if server is blocking
	 */
	_server_blocking: Bool,
	
	/******************************
	 * outputs if server is using fast send.
	 */
	_server_fast_send: Bool,
	
	/******************************
	 * amount of clients connected.
	 */
	_clients_connected: Int,
	
	/******************************
	 * if true then player is using the html5 client.
	 */
	_guest_account: Bool,
	
	/******************************
	 * This is the profile avatar image number used to display the image.
	 */
	_avatarNumber:String,
}

// what sets this typedef apart is the room data. here is room, roomState, _roomPlayerLimit, etc.
typedef DataMisc = {
	id: String,
	_username: String,					// the username of the player.
	_room: Int,							// current room that the user is in. zero equals no room.
	/******************************
	 * If events a and b are sent from event c to the server in that order, sometimes the server will send back event b to the client before the server finishes event a.
	 * to solve that problem, at client, move event b to the bottom of event a and if this var has the name of event b then at that code line event b will be executed.
	 */
	_triggerEvent: String,
	_spectatorWatching:Bool,			// this user entered the game from the lobby when clicking the "watch game" button. this user can only watch the game. this player cannot play the game even when game ends.
	_roomState: Array<Int>,				// 0 = empty, 1 computer game, 2 creating room, 3 = firth player waiting to play game. 4 = second player in waiting room. 5 third player in waiting room if any. 6 - forth player in waiting room if any. 7 - room full, 8 - game room.
	_roomPlayerLimit: Array<Int>,		// maximum number of players that can play the selected game.
	_roomPlayerCurrentTotal: Array<Int>,// current total of players in a room.
	// used to list the games at lobby. see Reg.gameName(). also, for not a host player, the data from here will populate _miscState._data._gameId for that player. 
	//-1: no data, 0:checkers, 1:chess, etc.
	_roomGameIds: Array<Int>,
	_roomHostUsername: Array<String>,	// a list of every username that is a host of a room.
	
	/******************************
	 * game id. move_history fields are not deleted from the MySQL database. so this id is used so that a user accesses that correct move_history data.
	 */
	_gid: Array<String>,
	
	_roomIsLocked: Array<Int>,			// if this vars value is true then a different player will not be able change the room state until the player has finished the "Greater RoomState Value" event at "Get Room Data" event. Note: that when a player leaves the game room, since that userLocation will always be a value of zero, a _roomIsLocked is not needed.
	_roomCheckForLock: Array<Int>, 	// If vars value is true then a check for a room lock will be made. This is used only when entering a room. If mouse clicked the "refresh room" button or leaving a game room then a check will not be made because in these cases a check is not needed. See Note: at _roomIsLocked for the reason why.
	_roomLockMessage: String,			// When a room lock is true then this room cannot be entered by the current player and this is the message saying that someone is already accessing the room so try again shortly.
	_vsComputer: Array<Int>, 		// if this value is true than the host is playing against the computer.
	_allowSpectators: Array<Int>, 	// if true then this room allows spectators.
	_userLocation: Int,					// currently where the user is at. 0:lobby, 1:creating room, 2:scene_waiting_room, 3:room game playing.
	_chat: String,						// chat text of the player.
	_gameRoom: Bool,					// should player enter the game room?
	_clientCommandMessage: String,		// kick, ban or some message. player blocked other player for some time or from playing again at that room for that session.
	_clientCommandUsers: String,
	_clientCommandIPs: String,
	
	
}

	// if a playersState event is sending data to the server then remember that the server broadcasts to a room depending on the value of _room. therefore, before that event is sent from client, at client the _playersState room must equal _gameState._data._room.
	
	// note that id and room vars exists at each of these typedef containers. room var value must be taken from the _gameState. so if you are passing _miscState, remember to get the room state from _miscState first or _miscState if that was the last typedef used. by default, the id's are all the same value. you do not need to be concerned with typedef ID's.
	
	// if you forget to get the value of a room before sending to the client, the server will not return the data to the client at the correct room. either no data will be sent to the client event or a different player will get the data.
typedef DataPlayers = {
	id: String,
	_username: String,				// username of the client.
	_usernamesDynamic:Array<String>,		// one to four usernames of the players in the waiting room or game room.
	_usernamesStatic:Array<String>, // the difference between _usernamesDynamic and _usernamesStatic is that a username can get removed from the list of _usernames, but the _usernamesStatic will always have the same names through the actions within the game room.
	_usernamesTotalDynamic:Int, // current total of players playing the game.
	_usernamesTotalStatic:Int, // total players that can play a game in that game room.
	_spectatorPlaying:Bool,			// user watching the game being played. quit game or time ran out for this player. this player was once playing a game. when doing spectators for anyone to watch, that must be a different name.
	_spectatorWatching:Bool,		// this user entered the game from the lobby when clicking the "watch game" button. this user can only watch the game. this player cannot play the game even when game ends.
	_gamePlayersValues:Int,			// 0: = not playing but still at game room. 1: playing a game. 2: left game room while still playing it. 3: left game or game room when game was over.4: quit game.
	// is it the players turn to move. a value of 1 = player1, 2=player2, etc.
	_moveNumberDynamic:Array<Int>,
	_room: Int,						// current room that the user is in. zero equals no room.
	_avatarNumber:Array<String>, 	// This is the profile avatar image number used to display the image.
	/******************************
	 * If events a and b are sent from event c to the server in that order, sometimes the server will send back event b to the client before the server finishes event a.
	 * to solve that problem, at client, move event b to the bottom of event a and if this var has the name of event b then at that code line event b will be executed.
	 */
	_triggerEvent: String,
	// this is needed to save a game win to the game being played. if chess is being played and player won that game then this var will be used to save a win to chess, not just the overall wins of any game played.
	_gameId: Int,
	_gameAllTotalWins:Array<Int>,			// total game wins of host player.
	_gameAllTotalLosses:Array<Int>,			// total game losses of host player.
	_gameAllTotalDraws:Array<Int>,			// total game draws of host player.
	_gameName:String,				// the game being played.
	_usernameInvite:String,			// username of the sent room invite.
	_gameMessage:String,			// an example of this would be a chess game where a player just received a message saying that the king is in check. 
	_actionWho:String,				// player that you want something done to.
	_actionNumber:Int,				// refers to an action, eg, 1 = kick. see the "Action By Player" event at server.
	_actionDo:Int,					// targeted player must do an action of _actionNumber. this var can be a time remaining var or whatever is needed for an Int.
	_moveTimeRemaining:Array<Int>,	// time remaining to make a move. when time reaches 0, the game ends and that player losses.
	_score:Array<Int>,				// total score in game.
	_cash:Array<Float>,				// total cash in game.
	_quitGame:Bool,					// while playing the game, a player has clicked the quit game button if true.
	_isGameFinished: Bool,			// false if game is still being played. defaults to true because when entering the game room the game for those players has not started yet.
	_gameIsFinished: Bool, 			// SAVE A VAR TO MYSQL SO THAT SOMEONE CANNOT INVITE WHEN STILL IN GAME ROOM. ALSO USED TO PASS A VAR TO USER SPECTATOR WATCHING. THAT VAR IS USED TO START A GAME FOR THAT SPECTATOR IF THE _gameIsFinished VALUE IS FALSE.
	_spectatorWatchingGetMoveNumber: Int, // send the current move number to the watching spectator so that the timer and white box underneath the P1, P2, P3 or P4 moves, can be updated.
	_moveTotal: Int, // how many times a player moved a piece.
	/******************************
	* this is the time when game is started.
	*/
	_timeTotal: Int,
	
	/******************************
	* total house items bought within 24 houses. this var is for the daily quest. see _buy_four_house_items
	*/
	_house_items_daily_total: Int,
	
	/******************************
	 * this is the piece total for the winner at the end of a game.
	 * currently only used in Reversi.
	 */
	_piece_total_for_winner: Int, 
	
	/******************************
	 *	this is a daily quest var. This is the amount of kings that a player has while playing a game. this var is used at DailyQuests.hx to determine if a reward should be given to player.
	 */
	_checkers_king_total: Int,
	
	/******************************
	 * this is a daily quest var. when a game is won, at server main.hx, at the saveWinStats() function, a value of 1 will be given to that array element for that board game played. so if playing a Reversi game then the array element of 2 will be set to a value of 1. when all array elements in this var has a value of 1 then all board games has been played.
	 */
	_all_boardgames_played_total: Array<Int>,
}


// credits, experience points, wins, losses, draws. all player statistics.
typedef DataStatistics = 
{
	id: String,
	_username: String,					// the username of the player.
	_room: Int,	
	/******************************
	* this is the time when game is started.
	*/
	_timeTotal: Int,
	_moveTimeRemaining: Array<Int>, // time since game has started.
	_chess_elo_rating:Float, // current chess Elo rating a player has.
	
	/******************************
	 * If events a and b are sent from event c to the server in that order, sometimes the server will send back event b to the client before the server finishes event a.
	 * to solve that problem, at client, move event b to the bottom of event a and if this var has the name of event b then at that code line event b will be executed.
	 */
	_triggerEvent: String,
	
	_total_games_played:Int,
	_highest_experience_points:Int,
	_highest_credits:Int,
	_highest_house_coins:Int,
	_shortest_time_game_played:Int,
	_longest_time_game_played:Int,
	_longest_current_winning_streak:Int,
	/******************************
	 * from any games played.
	 */
	_highest_winning_streak:Int,
	_longest_current_losing_streak:Int,
	_highest_losing_streak:Int,
	_longest_current_draw_streak:Int,
	_highest_draw_streak:Int,	
	
	_gamesAllTotalWins: Int,			// all game wins for player.
	_gamesAllTotalLosses: Int,			// all game losses for player.
	_gamesAllTotalDraws: Int,			// all game draws for player.
	
	_checkersWins: Int,
	_checkersLosses: Int,
	_checkersDraws: Int,
	_chessWins: Int,
	_chessLosses: Int,
	_chessDraws: Int,
	_reversiWins: Int,
	_reversiLosses: Int,
	_reversiDraws: Int,
	_snakesAndLaddersWins: Int,
	_snakesAndLaddersLosses: Int,
	_snakesAndLaddersDraws: Int,
	_signatureGameWins: Int,
	_signatureGameLosses: Int,
	_signatureGameDraws: Int,
	
	_creditsToday: Int,					// credits given on event day. credits can be redeemed for a month of paid membership. Maximum of 5 credits per event day.
	_creditsTotal: Int,					// each credit_today value is written to this value. this value only decreases when credits are used to redeem something, such as 1 month of membership.
	_experiencePoints: Int,				// each game played gives some XP points. get enough XP point to increase players level.	
	_houseCoins: Int,					// at the house event, after a game is played, some coins will be given. Use those coins to buy house furniture. Access your house from the house button at lobby.
}

/******************************
 * players house where they buy items, place items in room and vote for best house for prizes.
 */
typedef DataHouse = 
{
	/******************************
	 * player instance. this tells one player from another.
	 */
	id: String,
	
	/******************************
	 * the username of the player.
	 */
	_username: String,
		
	/******************************
	 * refers to a sprite that was bought to display at house. eg, 1.png
	 */
	_sprite_number: String,
	
	/******************************
	 * this is the name of the sprite in the order it was bought and then after, in the order of was changed using the z-order buttons of bring to front and bring to back.
	 */
	_sprite_name: String,
	
	/******************************
	 * all items x position that is separated by a comma.
	 */
	_items_x: String,
	
	/******************************
	 * all items y position that is separated by a comma.
	 */
	_items_y: String,

	/******************************
	 * map x coordinates on scene at the time the item was bought or mouse dragged then mouse released.
	 */
	_map_x: String,
	
	/******************************
	 * map y coordinates on scene at the time the item was bought or mouse dragged then mouse released.
	 */
	_map_y: String,
	
	/******************************
	 * when the map is moved up, down, left or right, this value increases in size by those pixels. this var is used at House update() so that the map hover can be displayed when outside of its default map boundaries. it is also added or subtracted to the mouse coordinates at other classes so that the map or panel items can correctly be detected by the mouse. for example, the mouse.x cannot be at a value of 2000 when the stage has a width of 1400 and the map changes in width, but it can be there when this offset is added to mouse.x.
	 */
	_map_offset_x: String,
 	_map_offset_y: String,
	
	/******************************
	 * is this item hidden?
	 */
	_item_is_hidden: String,
	
	/******************************
	 * a list of 1 and 0's separated by a comma. the first value in this list refers to item 1. if that value is 1 then that item was purchased.
	 */
	_is_item_purchased: String,
	
	/******************************
	 * stores the direction that the furniture item is facing.
	 * values of 0=SE, 1:SW, 2:NE, 3:NW
	 */
	_item_direction_facing: String,
	
	/******************************
	 * the order of the furniture items displayed.
	 */
	_item_order: String,
	
	/******************************
	* when value is true the furniture item will be displayed on the map behind a wall. This string contains true and false values up to 200 furniture items separated by a comma.
	*/
	_item_behind_walls: String,
	
	/******************************
	 * this holds all floor tiles on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and similar to reading words in a book.
	 */
	_floor: String,
	
	/******************************
	 * this holds all wall tiles in the left position on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and similar to reading words in a book.
	 */
	_wall_left: String,
	
	/******************************
	 * this holds all wall tiles in the upward position on the map. This var is read from left to right but that data is placed on the map starting from the top left of map and then moving right and similar to reading words in a book.
	 * this var is shown under a left tile. so the wall is up but behind a left wall.
	 */
	_wall_up_behind: String,
	_wall_up_in_front: String,
	
	/******************************
	 * the visibility state of all floor tiles.
	 */
	_floor_is_hidden: String,
	
	/******************************
	 * the visibility state of all left wall tiles.
	 */
	_wall_left_is_hidden: String,
	
	/******************************
	 * the visibility state of all up wall tiles.
	 */
	_wall_up_behind_is_hidden: String,
	_wall_up_in_front_is_hidden: String,
}

// string is needed for all fields because at client this data will be .split(",")
typedef Leaderboards = 
{
	id: String,
	_username: String,					// the username of the player.
	_usernames: String,					// this holds all players in a top leaderboard list. the usernames in the list is separated with a comma.
	_experiencePoints: String,			// total XP for all players. each XP is separated by a comma.
	_houseCoins: String,
	_worldFlag: String,
}

class Reg
{
	// these vars are populated from the config.bat file at /subs. All but the last var are used by the paid member to set the server up so that the server can connect to a port to go online. 
	
	// the last var is used along with a password to load the version. if the username or password is not correct then the server will not start. a paid member is needed. the MySQL database that is connected to kg's website is used to get the password.
	public static var _dbHost:String = "";
	public static var _dbPort:Int = 0;
	public static var _dbUser:String = "";
	public static var _dbPass:String = "";
	public static var _dbName:String = "";
	public static var _username:String = "";
	public static var _domain:String = "";
	public static var _domain_path:String = "";
	
	/******************************
	 * this is needed at mphx/server/connection.hx to display an error if any for the last known user that entered a server event. remember that at the top of most server events there is a call to the userLogs function. so when an error message is displayed, we know where the error came from and also know what user triggered the error.
	 */
	public static var _usernameLastLogged:String = "";
	
	/******************************
	 * is the server connected to the MySQL database?
	 */
	public static var _mysqlConnected:Bool = false;
	
	/******************************
	 * used to connect to server once.
	 */
	public static var _doOnce:Bool = false;
	
	/******************************
	 * only change the version number here. this value must be changed every time this complete program with dll's are copied to the localhost/files/windows folder.
	 * no need to copy this var then paste to the bottom of this class because this value does not change while client is running.
	 */
	public static var _version:String = "1.19.0";
	
	/******************************
	 * these are the computer player names for room a and b. those rooms are reserved for playing a game against the computer. these names are displayed at the hub.
	 * when the server first starts, the two of the names, randomly selected, will be assigned to room a and b.
	 */
	public static var _cpu_host_names:Array<String> = ["bot piper", "bot ben", "bot tina", "bot zak", "bot amy"];
	
	/******************************
	 * this name will be seen at lobby a. two names from the Reg._cpu_names will be selected when server starts. one of those names will be saved to this var.
	*/
	public static var _cpu_host_name1:String = "";
	
	/******************************
	 * this name will be seen at lobby a. two names from the Reg._cpu_names will be selected when server starts. one of those names will be saved to this var.
	*/
	public static var _cpu_host_name2:String = "";
	
	/*********************************
	 * when doing a request to see if a file exists at the website, this is the result of that search.
	 * also, this var is used to compare the server's Reg._version with the localhost/files/versionServer.txt. if they do not match then a software update will happen.
	 */
	public static var _messageFileExists:String = "";
	
	/******************************
	 * website house url that ends in "/".
	 */
	public static var _websiteHomeUrl:String = "http://kboardgames.com/";	
	public static var _websiteName:String = "K Board Games";

	/******************************
	 * this is the event calendar names, event are limited to no more than 40 events for the board games.
	 */
	public static var _eventName:Array<String> = 
	[for (p in 0...40) "" ];
	
	public static var _eventDescription:Array<String> = 
	[for (p in 0...40) "" ];
	
	 /******************************
	  * months start at element 0.
	  */
	 public static var _eventMonths:Array<Array<Int>> = 
	[for (p in 0...40) [for (d in 0...12) 0]];
	
	/******************************
	* days start at element 0.
	*/
	public static var _eventDays:Array<Array<Int>> = 
	[for (p in 0...40) [for (d in 0...28) 0]];
	
	public static var _eventBackgroundColour:Array<Int> =  
	[for (p in 0...40) 0 ];
	
	
	public static var _ip:String; // the IP address of the client connecting to the server.
	
	public static function resetRegVarsOnce():Void
	{
		//############################# START CONFIG
		// change these values below this line.
		
		_websiteHomeUrl = "http://kboardgames.com/"; // end in trail "/"
		_messageFileExists = "";
		_cpu_host_name1 = "";
		_cpu_host_name2 = "";
	}
}