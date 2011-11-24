<?php
require_once("db.php");
require_once("session.php");

class SecurityAbout
{
	var $session;
	
	function __construct()
	{
		$this -> session = new Session();
	}
	function checkIsAdmin($username, $password)
	{
		if($username == "" || $password == ""){
		
			return false;
		
		}
		$db = new DBConnection();
		$bool = $db -> checkIsAdmin($username, $password);
		$db -> closeConnection();
		if($bool){
		
			$this -> session -> setSession(true, $username);
			return true;
		
		}else{
		
			return false;
		
		}
	}
	function checkSessionIsValid($pos = "")
	{
	
		$bool = $this -> session -> checkSessionValid();
		if(!$bool){

			if($pos == "login"){
			
				return;
			
			}
			echo "<script>window.location=\"login.php\";</script>";

		}
	
	}
	function clearSession()
	{
		$this -> session -> clearSession();
		echo "<script>window.location=\"login.php\";</script>";
	}

}
?>