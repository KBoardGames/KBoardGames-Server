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
		if (Sys.args()[2] != null) Reg._dbHost = Sys.args()[2];
		if (Std.parseInt(Sys.args()[3]) != null) Reg._dbPort = Std.parseInt(Sys.args()[3]);
		if (Sys.args()[4] != null) Reg._dbUser = Sys.args()[4];
		if (Sys.args()[5] != null) Reg._dbPass = Sys.args()[5];
			
		// if serverBuild.bat is executed, this will load serverCreateExe.bat within that file because this program has ended. this is used to build the server exe file/ 
		if (Reg._dbPass == "") Sys.exit(0);
		
		if (Sys.args()[6] != null) Reg._dbName = Sys.args()[6];
		
		
		if (Sys.args()[9] != null) Reg._domain_path = Sys.args()[9];
		
		// the client will search for this file at website. if found the client will then try to connect to server. if not found then the client will give a message that the server if offline. remove file since server is going offline.
		if (FileSystem.exists(Reg._domain_path + "/server/server") == true)
			FileSystem.deleteFile(Reg._domain_path + "/server/server");
		
		var loadFile = sys.io.File.getContent("serverID.txt");
		
		_mysqlDB = new MysqlDB(); // no add.(_mysqlDB) needed.
		_mysqlDB.serverNowOffline(Std.parseInt(loadFile));	
		
		Sys.println ("Server Disconnected.");
		
		Sys.exit(0);
	}
		
	public static function main (){
		new Main();

	}
}//