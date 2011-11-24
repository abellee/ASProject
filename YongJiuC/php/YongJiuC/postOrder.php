<?php
require_once("classes/db.php");
$zipCode = "";
$address = "";
$name = "";
$phoneNumber = "";
$cellPhoneNum = "";

$addonsIDs = "";
$addonsPrice = 0;

$email = "";
$pid = "";
$cid = "";
$aid = "";
$type = "";

$db = new DBConnection();

if(isset($_POST["type"]) && $_POST["type"] != ""){

	$type = $_POST["type"];
	$types = $db -> queryOrder("select * from yjc_type where type='".$type."'");
	if(!count($types) || !types){
	
		return 0;
	
	}
	$type = $types[0]["id"];

}
if(isset($_POST["pid"]) && $_POST["pid"] != ""){

	$pid = $_POST["pid"];

}
if(isset($_POST["cid"]) && $_POST["cid"] != ""){

	$cid = $_POST["cid"];

}
if(isset($_POST["aid"]) && $_POST["aid"] != ""){

	$aid = $_POST["aid"];

}
if(isset($_POST["zipCode"]) && $_POST["zipCode"] != ""){

	$zipCode = $_POST["zipCode"];

}
if(isset($_POST["address"]) && $_POST["address"] != ""){

	$address = $_POST["address"];

}
if(isset($_POST["name"]) && $_POST["name"] != ""){

	$name = $_POST["name"];

}
if(isset($_POST["phoneNumber"]) && $_POST["phoneNumber"] != ""){

	$phoneNumber = $_POST["phoneNumber"];

}
if(isset($_POST["cellPhoneNum"]) && $_POST["cellPhoneNum"] != ""){

	$cellPhoneNum = $_POST["cellPhoneNum"];

}
if(isset($_POST["addons"]) && $_POST["addons"] != ""){

	$addons = $_POST["addons"];
	$addonsArr = explode(",", $addons);
	
	foreach($addonsArr as $value){
	
		$res = $db -> queryOrder("select id, price from yjc_addons where typeOrName='".$value."' and type='".$type."'");
		foreach($res as $v){
		
			$addonsPrice = $addonsPrice + (int)$v["price"];
			$addonsIDs .= $v["id"] . ",";
		
		}
	
	}
}
if(isset($_POST["email"]) && $_POST["email"] != ""){

	$email = $_POST["email"];

}

$body = "";
$hand = "";
$group = "";
$round = "";
$innerRound = "";
$crankset = "";
$seat = "";
$brake = "";
$chain = "";
if(isset($_POST["body"]) && $_POST["body"] != ""){

	$body = $_POST["body"];

}
if(isset($_POST["hand"]) && $_POST["hand"] != ""){

	$hand = $_POST["hand"];

}
if(isset($_POST["group"]) && $_POST["group"] != ""){

	$group = $_POST["group"];

}
if(isset($_POST["round"]) && $_POST["round"] != ""){

	$round = $_POST["round"];

}
if(isset($_POST["innerRound"]) && $_POST["innerRound"] != ""){

	$innerRound = $_POST["innerRound"];

}
if(isset($_POST["crankset"]) && $_POST["crankset"] != ""){

	$crankset = $_POST["crankset"];

}
if(isset($_POST["seat"]) && $_POST["seat"] != ""){

	$seat = $_POST["seat"];

}
if(isset($_POST["brake"]) && $_POST["brake"] != ""){

	$brake = $_POST["brake"];

}
if(isset($_POST["chain"]) && $_POST["chain"] != ""){

	$chain = $_POST["chain"];

}

$bp = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='body' and pantone='".$body."'");
$bodyPrice = $db -> queryOrder("select price from yjc_component where colorList='".$bp[0]["id"]."' and direction='0'");

$hp = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='hand' and pantone='".$hand."'");
$handPrice = $db -> queryOrder("select price from yjc_component where colorList='".$hp[0]["id"]."' and direction='0'");

$gp = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='group' and pantone='".$group."'");
$groupPrice = $db -> queryOrder("select price from yjc_component where colorList='".$gp[0]["id"]."' and direction='0'");

$rp = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='round' and pantone='".$round."'");
$roundPrice = $db -> queryOrder("select price from yjc_component where colorList='".$rp[0]["id"]."' and direction='0'");

$ip = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='innerRound' and pantone='".$innerRound."'");
$innerRoundPrice = $db -> queryOrder("select price from yjc_component where colorList='".$ip[0]["id"]."' and direction='0'");

$cp = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='crankset' and pantone='".$crankset."'");
$cranksetPrice = $db -> queryOrder("select price from yjc_component where colorList='".$cp[0]["id"]."' and direction='0'");

$sp = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='seat' and pantone='".$seat."'");
$seatPrice = $db -> queryOrder("select price from yjc_component where colorList='".$sp[0]["id"]."' and direction='0'");

$brp = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='brake' and pantone='".$brake."'");
$brakePrice = $db -> queryOrder("select price from yjc_component where colorList='".$brp[0]["id"]."' and direction='0'");

$chp = $db -> queryOrder("select id from yjc_comcolor where type='".$type."' and component='chain' and pantone='".$chain."'");
$chainPrice = $db -> queryOrder("select price from yjc_component where colorList='".$chp[0]["id"]."' and direction='0'");

$pstr = $db -> queryOrder("select region_name from chinafar_region where region_id='".$pid."'");
$pid = $pstr[0]["region_name"];
$cstr = $db -> queryOrder("select region_name from chinafar_region where region_id='".$cid."'");
$cid = $cstr[0]["region_name"];
$astr = $db -> queryOrder("select region_name from chinafar_region where region_id='".$aid."'");
$aid = $astr[0]["region_name"];
$curTime = time();
$bool = $db -> queryOrder("select id from yjc_order where preorderNum=".$curTime);
if($bool){
	echo "exist";
	exit();	
}
$bool = $db -> queryOrderWithoutReturn("insert into yjc_order(type, username, email, address, telnumber, cellphone, price, state, createTime, addons, preoderNum, zipCode) values ('".$type."', '".$name."', '".$email."', '".$pid.$cid.$aid.$address."', '".$phoneNumber."', '".$cellPhoneNum."', '".($bodyPrice[0]["price"] + $handPrice[0]["price"] + $groupPrice[0]["price"] + $roundPrice[0]["price"] + $innerRoundPrice[0]["price"] + $cranksetPrice[0]["price"] + $seatPrice[0]["price"] + $brakePrice[0]["price"] + $chainPrice[0]["price"] + $addonsPrice)."', '0', '".$curTime."', '".$addonsIDs."', '".$curTime."', '".$zipCode."')");
if($bool){
	$lastId = mysql_insert_id();
	$db -> queryOrderWithoutReturn("insert into yjc_orderDetail(pid, comName, comColor, price) values ('".$lastId."', 'body', '".$body."', '".$bodyPrice[0]["price"]."'), ('".$lastId."', 'hand', '".$hand."', '".$handPrice[0]["price"]."'), ('".$lastId."', 'group', '".$group."', '".$groupPrice[0]["price"]."'), ('".$lastId."', 'round', '".$round."', '".$roundPrice[0]["price"]."'), ('".$lastId."', 'innerRound', '".$innerRound."', '".$innerRoundPrice[0]["price"]."'), ('".$lastId."', 'crankset', '".$crankset."', '".$cranksetPrice[0]["price"]."'), ('".$lastId."', 'seat', '".$seat."', '".$seatPrice[0]["price"]."'), ('".$lastId."', 'brake', '".$brake."', '".$brakePrice[0]["price"]."'), ('".$lastId."', 'chain', '".$chain."', '".$chainPrice[0]["price"]."')");
    echo "<info><province>".$pid."</province><city>".$cid."</city><area>".$aid."</area><street>".$address."</street><totalPrice>".($bodyPrice[0]["price"] + $handPrice[0]["price"] + $groupPrice[0]["price"] + $roundPrice[0]["price"] + $innerRoundPrice[0]["price"] + $cranksetPrice[0]["price"] + $seatPrice[0]["price"] + $brakePrice[0]["price"] + $chainPrice[0]["price"] + $addonsPrice)."</totalPrice><email>".$email."</email><type>".$type."</type><receiver>".$name."</receiver><phoneNumber>".$phoneNumber."</phoneNumber><cellPhoneNumber>".$cellPhoneNumber."</cellPhoneNumber><addons>".$addonsIDs."</addons><orderID>".$curTime."</orderID><zipCode>".$zipCode."</zipCode></info>";
}else{
    echo "error";
}
?>