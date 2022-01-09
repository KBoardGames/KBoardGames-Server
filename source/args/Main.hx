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
import sys.FileSystem;


/**
 *
 * @author kboardgames.com
 */
class Main
{
	/********************************************************************************
	 * mysql class.
	 */
	public var _mysqlDB:MysqlDB;
	
			
	public function new()
	{			
		if (Sys.args()[2] != null) Reg._dbHost 		= Sys.args()[2];
		if (Std.parseInt(Sys.args()[3]) != null) Reg._dbPort = Std.parseInt(Sys.args()[3]);
		if (Sys.args()[4] != null) Reg._dbUser 		= Sys.args()[4];
		if (Sys.args()[5] != null) Reg._dbPass 		= Sys.args()[5];
			
		// if serverBuild.bat is executed, this will load serverCreateExe.bat within that file because this program has ended. this is used to build the server exe file/ 
		if (Reg._dbPass == "") Sys.exit(0);
		
		if (Sys.args()[6] != null) Reg._dbName 		= Sys.args()[6];
		
		
		if (Sys.args()[9] != null) Reg._domain_path 	= Sys.args()[9];
		if (Sys.args()[10] != null) Reg._smtpFrom 		= Sys.args()[10];
		if (Sys.args()[11] != null) Reg._smtpHost 		= Sys.args()[11];
		if (Sys.args()[12] != null) Reg._smtpPort		= Std.parseInt(Sys.args()[12]);
		if (Sys.args()[13] != null) Reg._smtpUsername	= Sys.args()[13];
		if (Sys.args()[14] != null) Reg._smtpPassword	= Sys.args()[14];
		
		// the client will search for this file at website. if found the client will then try to connect to server. if not found then the client will give a message that the server if offline. remove file since server is going offline.
		if (FileSystem.exists(Reg._domain_path + "/server/server") == true)
			FileSystem.deleteFile(Reg._domain_path + "/server/server");
		
		var loadFile = sys.io.File.getContent("serverID.txt");
		
		_mysqlDB = new MysqlDB(); // no add.(_mysqlDB) needed.
		_mysqlDB.server_now_offline_at_servers_status(Std.parseInt(loadFile));	
		
		Sys.println ("Server Disconnected.");
		
		Sys.exit(0);
	}
		
	public static function main (){
		new Main();

	}
}//