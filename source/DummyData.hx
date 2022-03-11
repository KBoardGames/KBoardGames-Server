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
		Events._roomState[1] = 3;
		Events._roomState[2] = 7;
		Events._roomState[3] = 3;
		Events._roomState[4] = 3;
		Events._roomState[5] = 2;
		Events._roomState[6] = 7;
		Events._roomState[7] = 8;
		Events._roomState[8] = 8;
		Events._roomState[9] = 8;
		Events._roomState[10] = 7;
		Events._roomState[11] = 2;
		Events._roomState[12] = 3;
		Events._roomState[13] = 8;
		Events._roomState[14] = 0;
		Events._roomState[15] = 8;
		Events._roomState[16] = 0;
		Events._roomState[17] = 7;
		Events._roomState[18] = 8;
		Events._roomState[19] = 3;
		Events._roomState[20] = 3;
		Events._roomState[21] = 7;
		Events._roomState[22] = 7;
		Events._roomState[23] = 8;
		
		Events._roomHostUsername[1] = "Jeti";
		Events._roomHostUsername[2] = "rastarx";
		Events._roomHostUsername[3] = "teacup";
		Events._roomHostUsername[4] = "EstaXen";
		Events._roomHostUsername[5] = "ironclad";
		Events._roomHostUsername[6] = "qentroz";
		Events._roomHostUsername[7] = "EloBender";
		Events._roomHostUsername[8] = "GameGeek";
		Events._roomHostUsername[9] = "Udela";
		Events._roomHostUsername[10] = "dogbone";
		Events._roomHostUsername[11] = "annaFlower";
		Events._roomHostUsername[12] = "InError";
		Events._roomHostUsername[13] = "MingmeiCheng";
		Events._roomHostUsername[14] = "";
		Events._roomHostUsername[15] = "laceyAnt";
		Events._roomHostUsername[16] = "";
		Events._roomHostUsername[17] = "stillwater";
		Events._roomHostUsername[18] = "ponyride";
		Events._roomHostUsername[19] = "sam";
		Events._roomHostUsername[20] = "drumspirit";
		Events._roomHostUsername[21] = "blueberry";
		Events._roomHostUsername[22] = "margaret";
		Events._roomHostUsername[23] = "Noob";
		
		Events._roomGameIds[1] = 1;
		Events._roomGameIds[2] = 3;
		Events._roomGameIds[3] = 0;
		Events._roomGameIds[4] = 4;
		Events._roomGameIds[5] = 3;
		Events._roomGameIds[6] = 2;
		Events._roomGameIds[7] = 1;
		Events._roomGameIds[8] = 2;
		Events._roomGameIds[9] = 0;
		Events._roomGameIds[10] = 4;
		Events._roomGameIds[11] = 3;
		Events._roomGameIds[12] = 4;
		Events._roomGameIds[13] = 1;
		Events._roomGameIds[14] = 0;
		Events._roomGameIds[15] = 0;
		Events._roomGameIds[16] = 0;
		Events._roomGameIds[17] = 3;
		Events._roomGameIds[18] = 2;
		Events._roomGameIds[19] = 0;
		Events._roomGameIds[20] = 4;
		Events._roomGameIds[21] = 3;
		Events._roomGameIds[22] = 1;
		Events._roomGameIds[23] = 0;
		
		Events._roomPlayerLimit[1] = 2;
		Events._roomPlayerLimit[2] = 2;
		Events._roomPlayerLimit[3] = 2;
		Events._roomPlayerLimit[4] = 4;
		Events._roomPlayerLimit[5] = 2;
		Events._roomPlayerLimit[6] = 2;
		Events._roomPlayerLimit[7] = 2;
		Events._roomPlayerLimit[8] = 2;
		Events._roomPlayerLimit[9] = 2;
		Events._roomPlayerLimit[10] = 3;
		Events._roomPlayerLimit[11] = 2;
		Events._roomPlayerLimit[12] = 2;
		Events._roomPlayerLimit[13] = 2;
		Events._roomPlayerLimit[14] = 2;
		Events._roomPlayerLimit[15] = 2;
		Events._roomPlayerLimit[16] = 2;
		Events._roomPlayerLimit[17] = 2;
		Events._roomPlayerLimit[18] = 2;
		Events._roomPlayerLimit[19] = 2;
		Events._roomPlayerLimit[20] = 4;
		Events._roomPlayerLimit[21] = 2;
		Events._roomPlayerLimit[22] = 2;
		Events._roomPlayerLimit[23] = 2;
		
		Events._roomPlayerCurrentTotal[1] = 1;
		Events._roomPlayerCurrentTotal[2] = 2;
		Events._roomPlayerCurrentTotal[3] = 1;
		Events._roomPlayerCurrentTotal[4] = 3;
		Events._roomPlayerCurrentTotal[5] = 1;
		Events._roomPlayerCurrentTotal[6] = 2;
		Events._roomPlayerCurrentTotal[7] = 2;
		Events._roomPlayerCurrentTotal[8] = 2;
		Events._roomPlayerCurrentTotal[9] = 2;
		Events._roomPlayerCurrentTotal[10] = 3;
		Events._roomPlayerCurrentTotal[11] = 1;
		Events._roomPlayerCurrentTotal[12] = 1;
		Events._roomPlayerCurrentTotal[13] = 2;
		Events._roomPlayerCurrentTotal[14] = 0;
		Events._roomPlayerCurrentTotal[15] = 2;
		Events._roomPlayerCurrentTotal[16] = 0;
		Events._roomPlayerCurrentTotal[17] = 2;
		Events._roomPlayerCurrentTotal[18] = 2;
		Events._roomPlayerCurrentTotal[19] = 1;
		Events._roomPlayerCurrentTotal[20] = 1;
		Events._roomPlayerCurrentTotal[21] = 2;
		Events._roomPlayerCurrentTotal[22] = 2;
		Events._roomPlayerCurrentTotal[23] = 2;
		
		Main._rated_game[1] = 1;
		Main._rated_game[2] = 1;
		Main._rated_game[3] = 1;
		Main._rated_game[4] = 0;
		Main._rated_game[5] = 1;
		Main._rated_game[6] = 0;
		Main._rated_game[7] = 1;
		Main._rated_game[8] = 1;
		Main._rated_game[9] = 1;
		Main._rated_game[10] = 0;
		Main._rated_game[11] = 1;
		Main._rated_game[12] = 1;
		Main._rated_game[13] = 1;
		Main._rated_game[14] = 1;
		Main._rated_game[15] = 0;
		Main._rated_game[16] = 1;
		Main._rated_game[17] = 1;
		Main._rated_game[18] = 1;
		Main._rated_game[19] = 0;
		Main._rated_game[20] = 1;
		Main._rated_game[21] = 1;
		Main._rated_game[22] = 1;
		Main._rated_game[23] = 1;
		
		Events._allowSpectators[1] = 1;
		Events._allowSpectators[2] = 0;
		Events._allowSpectators[3] = 1;
		Events._allowSpectators[4] = 1;
		Events._allowSpectators[5] = 1;
		Events._allowSpectators[6] = 0;
		Events._allowSpectators[7] = 1;
		Events._allowSpectators[8] = 1;
		Events._allowSpectators[9] = 1;
		Events._allowSpectators[10] = 0;
		Events._allowSpectators[11] = 0;
		Events._allowSpectators[12] = 0;
		Events._allowSpectators[13] = 1;
		Events._allowSpectators[14] = 1;
		Events._allowSpectators[15] = 1;
		Events._allowSpectators[16] = 1;
		Events._allowSpectators[17] = 0;
		Events._allowSpectators[18] = 1;
		Events._allowSpectators[19] = 1;
		Events._allowSpectators[20] = 0;
		Events._allowSpectators[21] = 0;
		Events._allowSpectators[22] = 0;
		Events._allowSpectators[23] = 1;
	}
	
}