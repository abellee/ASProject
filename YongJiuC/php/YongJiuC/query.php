<?php
require_once("classes/db.php");
require_once("classes/securityAbout.php");
require_once("classes/SimpleImage.php");
require_once("classes/pageCreator.php");
$pageCreator = new PageCreator();
$securityAbout = new SecurityAbout();
$securityAbout -> checkSessionIsValid();
$db = new DBConnection();
if(isset($_GET["action"])){

	if($_GET["action"] == "addAdmin"){
	
		if(isset($_POST["username"]) && isset($_POST["password"]) && isset($_POST["realname"])){
		
			if($_POST["username"] != "" && $_POST["password"] != "" && $_POST["realname"] != ""){
			
				$len = strlen($_POST["password"]);
				$namelen = strlen($_POST["username"]);
				if($namelen < 6 || $namelen > 20){
				
					echo "<script>alert(\"用户名必须为6至20之间!\");</script>";
						echo "<script>window.location=\"index.php?page=adminlist\";</script>";
						return;
				
				}
				if($len < 6 || $len > 12){
				
					echo "<script>alert(\"密码长度必须为6至12之间!\");</script>";
						echo "<script>window.location=\"index.php?page=adminlist\";</script>";
						return;
				
				}
				$bool = $db -> checkExist("username", $_POST["username"], "yjc_admin");
				if($bool){
				
					echo "<script>alert(\"用户名已存在!\");</script>";
					echo "<script>window.location=\"index.php?page=adminlist\";</script>";
				
				}else{
				
					$bool = $db -> queryOrderWithoutReturn("insert into yjc_admin(username, password, realname) values('".$_POST["username"]."', '".md5($_POST["password"])."', '".$_POST["realname"]."')");
					if($bool){
					
						echo "<script>alert(\"管理员添加成功!\");</script>";
						echo "<script>window.location=\"index.php?page=adminlist\";</script>";
					
					}else{
					
						echo "<script>alert(\"管理员添加失败!\");</script>";
						echo "<script>window.location=\"index.php?page=adminlist\";</script>";
					
					}
				
				}
			
			}else{
			
				echo "<script>alert(\"资料填写不完整, 请重新填写!\");</script>";
				echo "<script>window.location=\"index.php?page=adminlist\";</script>";
			
			}
		
		}else{
		
			echo "<script>alert(\"资料填写不完整, 请重新填写!\");</script>";
			echo "<script>window.location=\"index.php?page=adminlist\";</script>";
		
		}
		return;
	
	}
	if($_GET["action"] == "changepassword"){
	
		if(isset($_POST["password"])){
	
			if($_POST["password"] != ""){
	
			$bool = $db -> checkIsAdmin($_SESSION["admin"], $_POST["oldpass"]);
			if(!$bool){
		
				$db -> closeConnection();
				echo "<script>alert(\"旧密码不正确, 请重新输入！\");</script>";
				echo "<script>window.location=\"index.php?page=advance\";</script>";
				return;
		
			}
				$db -> queryOrderWithoutReturn("update yjc_admin set password = '".md5($_POST["password"])."' where username='".$_SESSION["admin"]."'");
				$db -> closeConnection();
				echo "<script>alert(\"密码修改成功!\");</script>";
				echo "<script>window.location=\"index.php?page=advance\"</script>";
				return;
	
			}else{
	
				echo "<script>alert(\"密码不能为空!\");</script>";
				echo "<script>window.location=\"index.php?page=advance\"</script>";
				return;
	
			}

		}
	
	}
	if($_GET["action"] == "addcomconfig"){
	
		if(isset($_POST["comname"]) && isset($_POST["comkey"])){

			if($_POST["comname"] != "" && $_POST["comkey"] != ""){
	
				$bo = $db -> checkExist("comName", $_POST["comname"], "yjc_comconfig");
			if($bo){
		
				echo "<script>alert(\"该部件配置已存在!\");</script>";
				echo "<script>window.location=\"index.php?page=comconfig\";</script>";
				return;
		
			}
				$bool = $db -> queryOrderWithoutReturn("insert into yjc_comconfig(comName, comKey)  values ('".$_POST["comname"]."', '".$_POST["comkey"]."')");
			if($bool){
		
				echo "<script>alert(\"添加成功!\");</script>";
				echo "<script>window.location=\"index.php?page=comconfig\";</script>";
		
			}else{
		
				echo "<script>alert(\"添加失败!\");</script>";
				echo "<script>window.location=\"index.php?page=comconfig\";</script>";
		
			}
	
			}else{
	
				echo "<script>alert(\"部件名称与部件键值不能为空!\");</script>";
				echo "<script>window.location=\"index.php?page=comconfig\";</script>";
	
			}
			$db -> closeConnection();
			return;

		}
	
	}
	if($_GET["action"] == "adddirconfig"){
	
		if(isset($_POST["dirname"]) && isset($_POST["dirkey"])){

			if($_POST["dirname"] != "" && $_POST["dirkey"] != ""){
	
				$bo = $db -> checkExist("dirName", $_POST["dirname"], "yjc_dirconfig");
			if($bo){
		
				echo "<script>alert(\"该方向配置已存在!\")</script>";
				echo "<script>window.location=\"index.php?page=dirconfig\"</script>";
				return;
		
			}
			$bool = $db -> queryOrderWithoutReturn("insert into yjc_dirconfig(dirName, dirKey)  values ('".$_POST["dirname"]."', '".$_POST["dirkey"]."')");
			if($bool){
		
				echo "<script>alert(\"添加成功!\")</script>";
				echo "<script>window.location=\"index.php?page=dirconfig\"</script>";
		
			}else{
		
				echo "<script>alert(\"添加失败!\")</script>";
				echo "<script>window.location=\"index.php?page=dirconfig\"</script>";
		
			}
	
			}else{
	
				echo "<script>alert(\"方向名称与方向键值不能为空!\")</script>";
				echo "<script>window.location=\"index.php?page=dirconfig\"</script>";
	
			}
			return;

		}
	
	}
	if($_GET["action"] == "addtype"){
	
		if(isset($_POST["type"])){

			if($_POST["type"] != ""){
			if(!is_dir($_POST["type"])){
		
				mkdir($_POST["type"]);
		
			}
				$bool = $db -> checkExist("type", $_POST["type"], "yjc_type");
				if($bool){
		
					echo "<script>window.location.history(-1)</script>";
					echo "<script>alert(\"该型号已存在!\")</script>";
		
				}else{
		
					$bo = $db -> queryOrderWithoutReturn("insert into yjc_type(type, operater, addTime) values ('".$_POST["type"]."', '".$_SESSION["admin"]."', '".time()."')");
					if($bo){
			
						echo "<script>alert(\"添加成功!\")</script>";
			
					}else{
			
						echo "<script>alert(\"添加失败!\")</script>";
			
					}
		
				}
	
			}else{
	
				echo "<script>alert(\"型号不能为空!\")</script>";
	
			}
			$db -> closeConnection();
			echo "<script>window.location = \"index.php?page=type\"</script>";

		}
	
	}
	if($_GET["action"] == "newcolor"){
	
		$typeid = $_POST["type"];
		$com = $_POST["com"];
		$colorValue = $_POST["hex"];
		$pantone = $_POST["colorValue"];
		$types = $db -> queryOrder("select * from yjc_type where id=".$typeid);
		$type = $types[0]["type"];
		
		//创建目录 - -!
		if(!is_dir($type)){
			
			mkdir($type, 0777);
			
		}
		if(!is_dir($type."/".$com)){
		
			mkdir($type."/".$com, 0777);
		
		}
		if(!is_dir($type."/".$com."/color")){
		
			mkdir($type."/".$com."/color", 0777);
		
		}
		$arr = $db -> queryOrder("select * from yjc_comcolor where type='".$type."' and component='".$com."'");
		foreach($arr as $value){
			
			if($value["colorValue"] == $colorValue){
				
				echo "<script>alert(\"该色值已经存在!\")</script>";
				echo "<script>window.location = \"index.php?page=color\"</script>";
				return;
				
			}
			
		}
		$bool = $db -> queryOrderWithoutReturn("insert into yjc_comcolor(type, component, colorValue, pantone) values ('".$typeid."', '".$com."', '".$colorValue."', '".$pantone."')");
		$result;
		if($bool){
		
			$result = $db -> queryOrder("select id from yjc_comcolor where type='".$typeid."' and component='".$com."' and colorValue='".$colorValue."' and pantone='".$pantone."'");
			$imageName = $result[0]["id"].".jpg";
			$bool = $db -> queryOrderWithoutReturn("update yjc_comcolor set colorImage='".$imageName."' where id=".$result[0]["id"]);
		
		}
		
		if($bool){
		
			$carr = hex2RGB($colorValue);
      		createPng(20, 20, $type."/".$com."/color/".$result[0]["id"].".jpg", $carr);
      		header("Content-Type: text/html");
			echo "<script>alert(\"添加成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"添加失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=color\"</script>";
		//echo "<script>alert('".$_FILES["imgFile"]["name"]."')</script>";
	
	}
	if($_GET["action"] == "syncColor"){
	
		$arr = $db -> queryOrder("select * from yjc_comcolor where component='".$_GET["com"]."' and type='".$_GET["type"]."'");
		$len = count($arr);
		if($len){
			
			$str = "";
			foreach($arr as $value){
			
				$typeStr = $db -> queryOrder("select * from yjc_type where id=".$value["type"]);
				if(isset($_GET["index"])){
				
					if($_GET["index"] == $value["id"]){
					
						$str .='<input type="radio" name="colorRadio" onclick="$(\'#selectColor\').val(this.value);" value="'.$value["id"].'" checked><img src="'.$typeStr[0]["type"]."/".$value["component"]."/color/".$value["colorImage"].'" />';
					
					}else{
					
						$str .='<input type="radio" name="colorRadio" onclick="$(\'#selectColor\').val(this.value);" value="'.$value["id"].'"><img src="'.$typeStr[0]["type"]."/".$value["component"]."/color/".$value["colorImage"].'" />';
					
					}
				
				}else{
				
					$str .='<input type="radio" name="colorRadio" onclick="$(\'#selectColor\').val(this.value);" value="'.$value["id"].'"><img src="'.$typeStr[0]["type"]."/".$value["component"]."/color/".$value["colorImage"].'" />';
				
				}
			
			}
			echo $str;
		
		}
	
	}
	if($_GET["action"] == "addComponent"){
	
		$typeid = $_POST["type"];
		$com = $_POST["com"];
		//$dir = $_POST["dir"];
		$color = $_POST["color"];
		$price = str_replace(".", "#", $_POST["price"]);
		$types = $db -> queryOrder("select * from yjc_type where id=".$typeid);
		$type = $types[0]["type"];
		for($i = 0; $i<6; $i++){
		
			$dir = $i;
			if(!is_dir($type)){
		
				mkdir($type, 0777);
		
			}
			if(!is_dir($type."/".$com)){
		
				mkdir($type."/".$com, 0777);
		
			}
			if(!is_dir($type."/".$com."/".$dir)){
		
				mkdir($type."/".$com."/".$dir, 0777);
		
			}
		$arr = $db -> queryOrder("select * from yjc_component where type='".$typeid."' and comName='".$com."' and direction='".$dir."' and colorList='".$color."'");
		$len = count($arr);
		$bool;
		if($len == 0){
		
			$bool = $db -> queryOrderWithoutReturn("insert into yjc_component(type, comName, direction, colorList, operater, price) values ('".$typeid."', '".$com."', '".$dir."', '".$color."', '".$_SESSION["admin"]."', '".$price."')");
		
		}else{
		
			$bool = $db -> queryOrderWithoutReturn("update yjc_component set colorList='".$color."', operater='".$_SESSION["admin"]."', price='".$price."' where type='".$typeid."' and comName='".$com."' and direction='".$dir."' and colorList='".$color."'");
		
		}
		
		}
		$rgb = $db -> queryOrder("select colorValue from yjc_comcolor where type='".$typeid."' and id='".$color."' and component='".$com."'");
		if($bool){
		
			move_uploaded_file($_FILES["swfFile0"]["tmp_name"],
      	$type."/".$com."/0/".($rgb[0]["colorValue"] + 0).".png");
      	
      	move_uploaded_file($_FILES["swfFile1"]["tmp_name"],
      	$type."/".$com."/1/".($rgb[0]["colorValue"] + 0).".png");
      	
      	move_uploaded_file($_FILES["swfFile2"]["tmp_name"],
      	$type."/".$com."/2/".($rgb[0]["colorValue"] + 0).".png");
      	
      	move_uploaded_file($_FILES["swfFile3"]["tmp_name"],
      	$type."/".$com."/3/".($rgb[0]["colorValue"] + 0).".png");
      	
      	move_uploaded_file($_FILES["swfFile4"]["tmp_name"],
      	$type."/".$com."/4/".($rgb[0]["colorValue"] + 0).".png");
      	
      	move_uploaded_file($_FILES["swfFile5"]["tmp_name"],
      	$type."/".$com."/5/".($rgb[0]["colorValue"] + 0).".png");
      	
			echo "<script>alert(\"添加成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"添加失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=component\"</script>";
		return;
	
	}
	if($_GET["action"] == "checkFileExist"){
	
		$type = $_GET["type"];
		$com = $_GET["com"];
		$dir = $_GET["dir"];
		$color = $_GET["color"];
		$arr = $db -> queryOrder("select * from yjc_component where type='".$type."' and comName='".$com."' and direction='".$dir."' and colorList='".$color."'");
		$len = count($arr);
		echo $len;
	
	}
	if($_GET["action"] == "edit"){
	
		$id = $_POST["userID"];
		$password = $_POST["password"];
		$realname = $_POST["realname"];
		$bool = $db -> queryOrderWithoutReturn("update yjc_admin set password='".md5($password)."', realName='".$realname."' where id='".$id."'");
		if($bool){
		
			echo "<script>alert(\"修改成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"修改失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=adminlist\"</script>";
	
	}
	if($_GET["action"] == "delete"){
	
		$id = $_GET["id"];
		$bool = $db -> queryOrderWithoutReturn("delete from yjc_admin where id='".$id."'");
		if($bool){
		
			echo "<script>alert(\"删除成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"删除失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=adminlist\"</script>";
	
	}
	if($_GET["action"] == "editOrder"){
	
		$id = $_POST["orderId"];
		$type = $_POST["typeInfo"];
		$state = $_POST["orderState"];
		$username = $_POST["username"];
		$address = $_POST["address"];
		$tel = $_POST["telephone"];
		$email = $_POST["email"];
		$price = $_POST["price"];
		
		$from = $_GET["from"];
		
		$bool = $db -> queryOrderWithoutReturn("update yjc_order set type='".$type."',  username='".$username."', email='".$email."', address='".$address."', telnumber='".$tel."', price='".$price."', state=".$state." where id=".$id);
		if($bool){
		
			echo "<script>alert(\"更新成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"更新失败!\")</script>";
		
		}
		if($from == "old"){
		
			echo "<script>window.location = \"index.php?page=oldorder\"</script>";
		
		}else{
		
			echo "<script>window.location = \"index.php?page=curorder\"</script>";
		
		}
	
	}
	if($_GET["action"] == "delorder"){
	
		$id = $_GET["id"];
		$from = $_GET["from"];
		$bool = $db -> queryOrderWithoutReturn("delete from yjc_order where id=".$id);
		if($bool){
		
			$bool = $db -> queryOrderWithoutReturn("delete from yjc_orderDetail where pid=".$id);
			echo "<script>alert(\"删除成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"删除失败!\")</script>";
		
		}
		if($from == "old"){
		
			echo "<script>window.location = \"index.php?page=oldorder\"</script>";
		
		}else{
		
			echo "<script>window.location = \"index.php?page=curorder\"</script>";
		
		}
	
	}
	if($_GET["action"] == "getFlashContent"){
	
		$url = "flashContent.html"; 
		$str = file_get_contents($url);
		echo htmlspecialchars($str);
	
	}
	if($_GET["action"] == "delComColor"){
	
		$id = $_GET["id"];
		$arr = $db -> queryOrder("select type, comName, colorList from yjc_component where id=".$id);
		$type = $arr[0]["type"];
		$com = $arr[0]["comName"];
		$color = $arr[0]["colorList"];
		$imageName = $db -> queryOrder("select colorValue from yjc_comcolor where id=".$color);
		$db -> queryOrderWithoutReturn("delete from yjc_comcolor where id=".$color);
		$bool = $db -> queryOrderWithoutReturn("delete from yjc_component where type='".$type."' and comName='".$com."' and colorList='".$color."'");
		if($bool){
		
			echo "<script>alert(\"删除成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"删除失败!\")</script>";
		
		}
		//unlink($type."/".$com."/color/".($imageName[0]["colorValue"] + 0).".png");
		echo "<script>window.location = \"index.php?page=detail\"</script>";
	
	}
	if($_GET["action"] == "modifyComponent"){
	
		$typeid = $_POST["type"];
		$types = $db -> queryOrder("select * from yjc_type where id=".$typeid);
		$type = $types[0]["type"];
		$com = $_POST["com"];
		$dir = $_POST["dir"];
		$color = $_POST["color"];
		$id = $_POST["comid"];
		$price = str_replace(".", "#", $_POST["price"]);
		$oarr = $db -> queryOrder("select * from yjc_component where id=".$id);
		$arr = $db -> queryOrder("select * from yjc_component where type='".$typeid."' and comName='".$com."' and direction='".$dir."' and colorList='".$color."'");
		$len = count($arr);
		$bool = $db -> queryOrderWithoutReturn("update yjc_component set colorList='".$color."', operater='".$_SESSION["admin"]."', price='".$price."', type='".$typeid."', direction='".$dir."', comName='".$com."' where id=".$id);
		if($bool){
		
			if($_FILES["swfFile"]["tmp_name"]){
			
				$c = $db -> queryOrder("select colorValue from yjc_comcolor where id=".$color);
				if($len == 1 && $arr[0]["id"]){
		
					//$db -> queryOrderWithoutReturn("delete from yjc_component where id=".$arr[0]["id"]);
					($type."/".$arr[0]["comName"]."/".$arr[0]["direction"]."/".($c[0]["colorValue"] + 0).".png");
		
				}
				move_uploaded_file($_FILES["swfFile"]["tmp_name"],
      	$type."/".$com."/".$dir."/".($c[0]["colorValue"] + 0).".png");
			
			}else{
				
				$c = $db -> queryOrder("select colorValue from yjc_comcolor where id=".$oarr[0]["colorList"]);
				$nc = $db -> queryOrder("select colorValue from yjc_comcolor where id=".$color);
				rename($type."/".$oarr[0]["comName"]."/".$oarr[0]["direction"]."/".($c[0]["colorValue"] + 0).".png", $type."/".$com."/".$dir."/".($nc[0]["colorValue"] + 0).".png");
			
			}
			echo "<script>alert(\"修改成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"修改失败!\")</script>";
		
		}
		$db -> closeConnection();
		echo "<script>window.location = \"index.php?page=component\"</script>";
		return;
	
	}
	if($_GET["action"] == "genXML"){
	
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_type");
		$xml = "<cycle width=\"14\" height=\"14\">";
		
		foreach($arr as $value){
		
			$xml .= "<type id=\"".$value["type"]."\">";
			$coms = $db -> queryOrder("select comKey from yjc_comconfig");
			foreach($coms as $v){
			
				$key = $v["comKey"];
				$component = $db -> queryOrder("select colorList, price from yjc_component where type='".$value["id"]."' and comName='".$key."' and direction='0'");
				$pantoneColors = "";
				$hexColors = "";
				$prices = "";
				foreach($component as $vv){
				
					$color = $db -> queryOrder("select colorValue, pantone from yjc_comcolor where id=".$vv["colorList"]);
					$pantoneColors .= $color[0]["pantone"].",";
					$hexColors .= $color[0]["colorValue"].",";
					$prices .= $vv["price"].",";
				
				}
				$pantoneColors = substr($pantoneColors, 0, strlen($pantoneColors) - 1);
				$hexColors = substr($hexColors, 0, strlen($hexColors) - 1);
				$prices = substr($prices, 0, strlen($prices) - 1);
				$xml .= "<".$key." pantoneValue=\"".$pantoneColors."\" colorValue=\"".$hexColors."\" price=\"".$prices."\" />";
			
			}
			$xml .= "</type>";
		
		}
		$xml .="</cycle>";
		$file = fopen("fc.xml", "wb+");
		$bool = fwrite($file, $xml);
		if($bool){
		
			fclose($file);
			//生成addons文件
			$arr = $db -> queryOrder("select * from yjc_type");
			$xml = "<addons>";
			foreach($arr as $value){
			
				$addons = $db -> queryOrder("select * from yjc_addons where type='".$value["id"]."'");
				if(!count($addons) || !$addons) break;
				$xml .= "<type id=\"".$value["type"]."\">";
				$addonsXML = "";
				foreach($addons as $v){
				
					$addonsXML .= "<addon type=\"".$v["typeOrName"]."\" price=\"".$v["price"]."\" />";
				
				}
				$xml .= $addonsXML."</type>";
			
			}
			$xml .= "</addons>";
			$file = fopen("addons.xml", "wb+");
			$bool = fwrite($file, $xml);
			if($bool){
			
				echo 1;
			
			}else{
			
				echo 2;
			
			}
		
		}else{
		
			echo 0;
		
		}
		fclose($file);
	
	}
	if($_GET["action"] == "addAddons"){
	
		$typeOrName = $_POST["addonName"];
		$addonPrice = str_replace(".", "#", $_POST["addonPrice"]);;
		$typeid = $_POST["type"];
		$db = new DBConnection();
		$types = $db -> queryOrder("select type from yjc_type where id=".$typeid);
		if(!count($types) || !$types){
		
			return;
		
		}
		$type = $types[0]["type"];
		if(!is_dir($type)){
		
			mkdir($type, 0777);
		
		}
		if(!is_dir($type."/addons")){
		
			mkdir($type."/addons", 0777);
		
		}
		$bool = $db -> queryOrderWithoutReturn("insert into yjc_addons(typeOrName, type, price, operater) values ('".$typeOrName."', '".$typeid."', '".$addonPrice."', '".$_SESSION["admin"]."')");
		if($bool){
		
			echo "<script>alert(\"添加成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"添加失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=addons\"</script>";
		$bool = move_uploaded_file($_FILES["addOnFile"]["tmp_name"], $type."/addons/".$typeOrName.".jpg");
		//创建缩略图
		if($bool){
		
			$image = new SimpleImage();
			$image->load($type."/addons/".$typeOrName.".jpg");
			$image->resizeToWidth(80);
			$image->save($type."/addons/".$typeOrName."_s.jpg");
		
		}
	
	}
	if($_GET["action"] == "checkAddons"){
	
		$typeOrName = $_GET["typeOrName"];
		$type = $_GET["type"];
		$arr = $db -> queryOrder("select id from yjc_addons where typeOrName='".$typeOrName."' and type='".$type."'");
		$len = count($arr);
		if($len >= 1){
		
			echo 1;
		
		}else{
		
			echo 0;
		
		}
	
	}
	if($_GET["action"] == "getDetailsByType"){
	
		$type = $_GET["type"];
		echo $pageCreator -> detailView(1, 0, $type);
		/*$details = $db -> queryOrder("select * from yjc_component where type='".$type."'");
		$comconfig = $db -> queryOrder("select * from yjc_comconfig");
		$dirconfig = $db -> queryOrder("select * from yjc_dirconfig");
		$str = "";
		foreach($details as $value){
		
			$comName = "";
			$dirValue = "";
			foreach($comconfig as $v){
			
				if($v["comKey"] == $value["comName"]){
				
					$comName = $v["comName"];
				
				}
			
			}
			foreach($dirconfig as $a){
			
				if($a["dirKey"] == $value["direction"]){
				
					$dirValue = $a["dirName"];
				
				}
			
			}
			$typeItem = $db -> queryOrder("select * from yjc_type where id=".$value["type"]);
			$imageName = $db -> queryOrder("select colorImage from yjc_comcolor where id=".$value["colorList"]);
			if(count($imageName)){
			
				$colorsHtml = "<img src=\"".$typeItem[0]["type"]."/".$value["comName"]."/color/".$imageName[0]["colorImage"]."\" border=0 /> ";
				$str .= "<tr>
                        	<td>".$typeItem[0]["type"]."</td>
                            <td>".$comName."</td>
                            <td>".$dirValue."</td>
                            <td>".$colorsHtml."</td>
                            <td>".str_replace("#", ".", $value["price"])."</td>
                            <td><a href=\"index.php?page=component&action=modify&id=".$value["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a>
                            <a href=\"javascript:deleteComponentColor(".$value["id"].")\"><img src=\"img/icons/icon_unapprove.png\" title=\"删除\" alt=\"删除\" /></a></td>
                        </tr>";
			
			}
		
		}*/
		//echo $str;
	
	}
	if($_GET["action"] == "modifyType"){
	
		$id = $_POST["typeid"];
		$type = $_POST["type"];
		$bool = $db -> queryOrderWithoutReturn("update yjc_type set type='".$type."' where id=".$id);
		if($bool){
		
			echo "<script>alert(\"修改成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"修改失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=type\"</script>";
	
	}
	if($_GET["action"] == "getAddonsByType"){
	
		$type = $_GET["type"];
		$details = $db -> queryOrder("select * from yjc_addons where type='".$type."'");
		$str = "";
		foreach($details as $value){
		
		$typeStr = $db -> queryOrder("select * from yjc_type where id=".$value["type"]);
			$str .= "<tr>
                    <td>".$typeStr[0]["type"]."</td>
                    <td>".$value["typeOrName"]."</td>
                    <td>".str_replace("#", ".", $value["price"])."</td>
                    <td>".$value["operater"]."</td>
                    <td>".$value["createTime"]."</td>
                    <td><a href=\"index.php?page=addons&action=modify&id=".$value["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a>
                    <a href=\"javascript:deleteComponentColor(".$value["id"].")\"><img src=\"img/icons/icon_unapprove.png\" title=\"删除\" alt=\"删除\" /></a></td>
                    </tr>";
		
		}
		echo $str;
	
	}
	if($_GET["action"] == "modifyAddons"){
	
		$id = $_POST["addonID"];
		$type = $_POST["type"];
		$typeOrName = $_POST["addonName"];
		$price = str_replace(".", "#", $_POST["addonPrice"]);
		$bool = $db -> queryOrderWithoutReturn("update yjc_addons set typeOrName='".$typeOrName."', type='".$type."', price='".$price."' where id=".$id);
		if($bool){
		
			echo "<script>alert(\"修改成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"修改失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=addonsViewer\"</script>";
		if($_FILES["addOnFile"]){
		
			$bool = move_uploaded_file($_FILES["addOnFile"]["tmp_name"], $type."/addons/".$id.".jpg");
			//创建缩略图
			if($bool){
		
				$image = new SimpleImage();
				$image->load($type."/addons/".$id.".jpg");
				$image->resizeToWidth(94);
				$image->save($type."/addons/".$id."_s.jpg");
		
			}
		
		}
	
	}
	if($_GET["action"] == "delAddon"){
	
		$id = $_GET["id"];
		$bool = $db -> queryOrderWithoutReturn("delete from yjc_addons where id=".$id);
		if($bool){
		
			echo "<script>alert(\"删除成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"删除失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=addonsViewer\"</script>";
	
	}
	if($_GET["action"] == "getComColorList"){
	
		$type = $_GET["type"];
		$res = $db -> queryOrder("select * from yjc_comcolor where type='".$type."'");
		$comconfig = $db -> queryOrder("select * from yjc_comconfig");
		$str = "";
		foreach($res as $value){
		
			$comName = "";
			foreach($comconfig as $vv){
			
				if($vv["comKey"] == $value["component"]){
				
					$comName = $vv["comName"];
					break;
				
				}
			
			}
			$typedb = $db -> queryOrder("select * from yjc_type where id=".$type);
			$str .= "<tr>
                        	<td>".$typedb[0]["type"]."</td>
                            <td>".$comName."</td>
                            <td>".$value["colorValue"]."</td>
                            <td>".$value["pantone"]."</td>
                            <td><a href=\"index.php?page=color&action=modify&id=".$value["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a></td>
                        </tr>";
		
		}
		echo $str;
	
	}

	if($_GET["action"] == "deleteColor" && $_GET["page"] == "color"){
		$id=$_GET["id"];
		$res = $db -> queryOrderWithoutReturn("delete from yjc_comcolor where id=".$id);
		if($res){
			echo "<script>alert(\"删除成功!\")</script>";
		}else{
			echo "<script>alert(\"删除失败!\")</script>";
		}
		echo "<script>window.location = \"index.php?page=comColor\"</script>";
	}

	if($_GET["action"] == "modifyColor"){
	
		$type = $_POST["type"];
		$com = $_POST["com"];
		$colorValue = $_POST["hex"];
		$pantone = $_POST["colorValue"];
		$id = $_POST["idvalue"];
		
		//创建目录 - -!
		if(!is_dir($type)){
			
			mkdir($type, 0777);
			
		}
		if(!is_dir($type."/".$com)){
		
			mkdir($type."/".$com, 0777);
		
		}
		if(!is_dir($type."/".$com."/color")){
		
			mkdir($type."/".$com."/color", 0777);
		
		}
		$bool = false;
		$res = $db -> queryOrder("select * from yjc_comcolor where id=".$id);
		if($res[0]["component"] != $com){
			$typeId = $res[0]["type"];
			$bool = $db -> queryOrderWithoutReturn("delete from yjc_comcolor where id=".$id);
			if($bool){
				$bool = $db -> queryOrderWithoutReturn("insert into yjc_comcolor(type, component, colorValue, pantone) values('".$typeId."', '".$com."','".$colorValue."','".$pantone."')");
				$result = $db -> queryOrder("select * from yjc_comcolor where type='".$typeId."' and component='".$com."' and colorValue='".$colorValue."' and pantone='".$pantone."'");
				$id = $result[0]["id"];
				$imageName = $id.".jpg";
				$bool = $db -> queryOrderWithoutReturn("update yjc_comcolor set colorImage='".$imageName."' where id=".$result[0]["id"]);
			}
		}else{
			$bool = $db -> queryOrderWithoutReturn("update yjc_comcolor set colorValue='".$colorValue."', pantone='".$pantone."' where id=".$id);
		}
		
		if($bool){
		
			$carr = hex2RGB($colorValue);
      		createPng(20, 20, $type."/".$com."/color/".$id.".jpg", $carr);
      		header("Content-Type: text/html");
			echo "<script>alert(\"修改成功!\")</script>";
		
		}else{
		
			echo "<script>alert(\"修改失败!\")</script>";
		
		}
		echo "<script>window.location = \"index.php?page=color\"</script>";
	
	}

}
	function createPng($w, $h, $path, $color)
	{
		$canvas = imagecreate($w, $h);
		$white = imagecolorallocate($canvas, $color["r"], $color["g"], $color["b"]);
		$black = imagecolorallocate($canvas, 0, 0, 0);
		imagerectangle($canvas, 0, 0, $w-1, $h-1, $black);
		header('Content-Type: image/jpeg');
		$file = $path;
		imagepng($canvas, $file);
		if(is_file($file)){

			$fp = fopen($file, "r");
			$data = addslashes(fread($fp, filesize($file)));
			fclose($fp);

		}
		imagedestroy($canvas);
	}
	function hex2RGB($hexColor) {
    	$color = str_replace('0x', '', $hexColor);
    	if (strlen($color) > 3) {
        	$rgb = array(
            	'r' => hexdec(substr($color, 0, 2)),
            	'g' => hexdec(substr($color, 2, 2)),
            	'b' => hexdec(substr($color, 4, 2))
        	);
     	} else {
        	$color = str_replace('#', '', $hexColor);
        	$r = substr($color, 0, 1) . substr($color, 0, 1);
        	$g = substr($color, 1, 1) . substr($color, 1, 1);
        	$b = substr($color, 2, 1) . substr($color, 2, 1);
        	$rgb = array(
            	'r' => hexdec($r),
            	'g' => hexdec($g),
            	'b' => hexdec($b)
        	);
    	}
     return $rgb;
	}
?>
