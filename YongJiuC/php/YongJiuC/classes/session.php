<?php
require_once("db.php");
class Session
{
	var $delay = 300; //session为5昏钟
	function __construct()
	{
		session_start();
	}
	function setSession($bool, $username)
	{
		$_SESSION["time"] = time();
		$_SESSION["admin"] = $username;
		$now = time();
		$db = new DBConnection();
		$db -> queryOrderWithoutReturn("update yjc_admin set lastLogin = '".$now."' where username='".$username."'");
		$db -> closeConnection();
	}
	function checkSessionValid()
	{
		if(isset($_SESSION["time"]))
		{
		
			if(time() - $_SESSION["time"] > $this -> delay){
		
				return false;
		
			}else{
		
				$_SESSION["time"] = time();
				return true;
		
			}
		
		}else{
		
			return false;
		
		}
	}
	function clearSession()
	{
	
		if(isset($_SESSION["time"])){
		
			$_SESSION["time"] = 0;
			$_SESSION["admin"] = "";
		
		}
	
	}
}
?>