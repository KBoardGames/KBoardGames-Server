/*
    Copyright (c) 2021 KBoardGames.com
    This program is part of KBoardGames client software.

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

package;

/**
 * A dummy data contains player records and game statistics of none real customers. The idea is to populate the database or lobby with dummy data to give the impression that the server is busy or to give customers an idea about how the server or website could look if busy.
 * if you would like to use this dummy data for website screenshots and would like to take a screenshot of the game room, then use one of the last rooms in the lobby to enter the waiting room. a dummy name of player two will be displayed and the enter game room button can be pressed. when using the dummy data, admin name will be replaced with a random dummy name. dummy name will be used for player two. when in dummy mode, a game piece for player two cannot be moved since a real player two name is now used and the start game button is hidden.
 * @author kboardgames.com
 */
class DummyData
{

	public function new(_db_delete:DB_Delete, _db_insert:DB_Insert, _db_select:DB_Select, _db_update:DB_Update) 
	{
		
	}
	
	// populate the lobby, create room and waiting room with dummy data.
	static public function server_data():Void
	{
		// rated_game var is at Main.
				
		Events._roomPlayerCurrentTotal[1] = 1;
		Events._roomPlayerCurrentTotal[2] = 2;
		Events._roomPlayerCurrentTotal[3] = 1;
		Events._roomPlayerCurrentTotal[4] = 2;
		Events._roomPlayerCurrentTotal[5] = 1;
		Events._roomPlayerCurrentTotal[6] = 2;
		Events._roomPlayerCurrentTotal[7] = 2;
		Events._roomPlayerCurrentTotal[8] = 2;
		Events._roomPlayerCurrentTotal[9] = 3;
		Events._roomPlayerCurrentTotal[10] = 2;
		Events._roomPlayerCurrentTotal[11] = 2;
		Events._roomPlayerCurrentTotal[12] = 2;
		Events._roomPlayerCurrentTotal[13] = 2;
		Events._roomPlayerCurrentTotal[14] = 2;
		Events._roomPlayerCurrentTotal[15] = 2;
		Events._roomPlayerCurrentTotal[16] = 1;
		Events._roomPlayerCurrentTotal[17] = 2;
		Events._roomPlayerCurrentTotal[18] = 2;
		Events._roomPlayerCurrentTotal[19] = 2;
		Events._roomPlayerCurrentTotal[20] = 2;

		var _db_select = new DB_Select();
		var _rows = _db_select.all_at_room_data_dummy();
		
		for (i in 0... Main._dummy_first_player_count)
		{
			// host of room only so that the room buttons have the correct title.
			if (_rows._moveNumberDynamic[i] == 0)
			{
				Events._roomHostUsername[(i + 1)] = Std.string(_rows._user[i]);
			
				Events._roomState[(i + 1)] = _rows._roomState[i];
			
			}
			
			Events._roomGameIds[(i + 1)] = _rows._gameId[i];
			Events._roomPlayerLimit[(i + 1)] = _rows._playerLimit[i];
			//Main._rated_game[(i + 1)] = _rows;
			Events._allowSpectators[(i + 1)] = _rows._allowSpectators[i];
			
			
			// add the dummy data to the room_data mysql table. the dummy data will be deleted from room_data when admin logs off.
			var _db_insert = new DB_Insert();
			_db_insert.dummy_data_at_room_data(Std.string(_rows._user[i]), _rows._roomState[i], _rows._userLocation[i], _rows._room[i], _rows._playerLimit[i], _rows._gameId[i], _rows._allowSpectators[i]);
		}
		
	}
}