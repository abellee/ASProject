<?php
class DBConnection
{
	var $host = "localhost";
	var $dbacc = "root";
	var $dbpass = "123123";
	var $adminTable = "yjc_admin";
	
	var $conn = null;
	var $db = null;
	function __construct()
	{
		$this -> conn = mysql_connect($this -> host, $this -> dbacc, $this -> dbpass) or die("connect to db failed and error is ".mysql_error());
		mysql_query("SET NAMES UTF8", $this -> conn);
		$this -> db = mysql_select_db("cforevercn", $this -> conn) or die("yongjiuc select failed and error is ".mysql_error());
	}
	
	function checkIsAdmin($username, $password)
	{
		if($this -> conn){
			
			$sql = mysql_query("select * from ".($this -> adminTable)." where username='".$username."'", $this -> conn);
			if($sql){
			
				while($row = mysql_fetch_array($sql)){
				
					if($row["password"] == md5($password)){
					
						return true;
					
					}
				
				}
				return false;
			
			}else{
			
				return false;
			
			}
		
		}
	}
	function checkExist($key, $value, $table)
	{
		if($this -> conn){
		
			$sql = "select * from ".$table." where ".$key." = '".$value."'";
			$query = mysql_query($sql, $this -> conn);
			$num = mysql_num_rows($query);
			if($num > 0){
			
				return true;
			
			}else{
			
				return false;
			
			}
		}
	}
	function queryOrderWithoutReturn($q)
	{
		if($this -> conn){
			
			$sql = mysql_query($q, $this -> conn) or die(mysql_error());
			if($sql){
			
				return true;
			
			}
			return false;
		
		}
	}
	function queryOrder($q)
	{
		if($this -> conn){
		
			$sql = mysql_query($q, $this -> conn) or die(mysql_error());
			if($sql){
			
				$arr = array();
				while($row = mysql_fetch_array($sql)){
				
					array_push($arr, $row);
				
				}
				return $arr;
			
			}
			return false;
		
		}
	}
	function closeConnection()
	{
		mysql_close($this -> conn);
	}
}
?>