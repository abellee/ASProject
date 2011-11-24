<?php
require_once("classes/db.php");
if($_GET["action"] == "getProvince"){
	
	$db = new DBConnection();
	$result = $db -> queryOrder("select * from chinafar_region where region_type='1'");
	$str = "";
	foreach($result as $value){
	
		$str .= $value["region_id"]."#".$value["region_name"].",";
	
	}
	$cityStr = "";
	$res = $db -> queryOrder("select * from chinafar_region where parent_id=".$result[0]["region_id"]);
	foreach($res as $v){
	
		$cityStr .= $v["region_id"]."#".$v["region_name"].",";
	
	}
	$areaStr = "";
	$ress = $db -> queryOrder("select * from chinafar_region where parent_id=".$res[0]["region_id"]);
	foreach($ress as $vv){
	
		$areaStr .= $vv["region_id"]."#".$vv["region_name"].",";
	
	}
	echo $str."|".$cityStr."|".$areaStr;
	
}
if($_GET["action"] == "getCity"){

	$id = $_GET["id"];
	$db = new DBConnection();
	$result = $db -> queryOrder("select * from chinafar_region where parent_id=".$id);
	$str = "";
	foreach($result as $value){
	
		$str .= $value["region_id"]."#".$value["region_name"].",";
	
	}
	$cityStr = "";
	$res = $db -> queryOrder("select * from chinafar_region where parent_id=".$result[0]["region_id"]);
	foreach($res as $v){
	
		$cityStr .= $v["region_id"]."#".$v["region_name"].",";
	
	}
	echo $str."|".$cityStr;

}
if($_GET["action"] == "getArea"){

	$id = $_GET["id"];
	$db = new DBConnection();
	$result = $db -> queryOrder("select * from chinafar_region where parent_id=".$id);
	$str = "";
	foreach($result as $value){
	
		$str .= $value["region_id"]."#".$value["region_name"].",";
	
	}
	echo $str;

}
?>