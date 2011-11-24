<?php
require_once("classes/securityAbout.php");
$securityAbout = new SecurityAbout();
$securityAbout -> checkSessionIsValid();
if(isset($_GET["action"])){

	if($_GET["action"] == "logout"){
	
		$securityAbout -> clearSession();
	
	}

}
function setID($pn)
{

	if(isset($_GET["page"])){
	
    	if($_GET["page"] == $pn || ($pn == "oldorder" && $_GET["page"] == "orderview") || ($pn == "curorder" && $_GET["page"] == "curorderview") || ($pn == "oldorder" && $_GET["page"] == "modifyoldorder") || ($pn == "curorder" && $_GET["page"] == "modifycurorder"))
    	{
    		echo "id=\"curCate\"";
    	}
    	
    }

}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>永久C网站管理后台</title>
<link href="styles/layout.css" rel="stylesheet" type="text/css" />
<link href="styles/wysiwyg.css" rel="stylesheet" type="text/css" />
<!-- Theme Start -->
<link href="themes/blue/styles.css" rel="stylesheet" type="text/css" />
<!-- Theme End -->
</head>
	<script src="scripts/swfobject.js" type="text/javascript"></script>
	<script type="text/javascript" src="scripts/enhance.js"></script>	
	<script type='text/javascript' src='scripts/excanvas.js'></script>
	<script type='text/javascript' src='scripts/jquery.min.js'></script>
    <script type='text/javascript' src='scripts/jquery-ui.min.js'></script>
	<script type='text/javascript' src='scripts/jquery.wysiwyg.js'></script>
    <script type='text/javascript' src='scripts/visualize.jQuery.js'></script>
    <script type="text/javascript" src='scripts/functions.js'></script>
<script type="text/javascript">
var bool = false;
function showBox(){

	$("#box").css("display", "");
	$("#closeBtn").css("display", "");
	if(bool){
	
		return;
	
	}
	swfobject.embedSWF("PantoneColorPicker.swf", "box", "700", "600", "10.0.0", "expressInstall.swf");
	bool = true;

}
function closePicker(){

	$("#box").css("display", "none");
	$("#closeBtn").css("display", "none");
	bool = false;

}
function setColor(hex, pantone){
            
    $("#colorField").val(pantone);
    $("#hexValue").val(hex);
            
}
function checkValues(){
            
    var str = $("#colorField").val();
    var pattern = /^(\d)(\d+[Cc]$)/;
	//var flag = pattern.test(str);
	if($("#colorField").val() == ""){
	
		alert("请选择Pantone值!");
		return;
	
	}
	//if(!flag){
				
		//alert("Pantone值不正确!");
		//return;
				
	//}
    $("#selectCom").val($("#comSelector").find("option:selected").val());
    $("#selectType").val($("#typeSelector").find("option:selected").val());
    $("#colorForm").submit();
            
}
function showColor(index){
    
    var str = $("#comSelector").find("option:selected").val();
    var typeStr = $("#typeSelector").find("option:selected").val();
    var dataStr = "";
    if(index != null){
    
    	dataStr = 'action=syncColor&com='+str+'&type='+typeStr+'&index='+index;
    
    }else{
    
    	dataStr = 'action=syncColor&com='+str+'&type='+typeStr;
    
    }
    jQuery.ajax({type:'GET', url:'query.php', data:dataStr, success:
    function(rmsg){
    
        $('#colorArea').html(rmsg);
    }
    });
            
}
function deleteComponentColor(id){

	var bool = confirm("确定删除此颜色配件吗?");
	if(!bool){
	
		return;
	
	}
	if(id){
	
		var str = "query.php?action=delComColor&id=" + id;
		window.location = str;
	
	}

}
function deleteAddon(id){

	var bool = confirm("确定删除此配件吗?");
	if(!bool){
	
		return;
	
	}
	if(id){
	
		var str = "query.php?action=delAddon&id=" + id;
		window.location = str;
	
	}

}
function registCheckBox(){

	$("input[type=checkbox]").bind("click", function pushValueToArray(){
	
		var valueArr = $(this).val().split("|");
		if($(this).attr("checked") == true){
		
			if(arr[valueArr[0]]){
			
				arr[valueArr[0]].push(valueArr[1]);
			
			}else{
			
				arr[valueArr[0]] = [];
				arr[valueArr[0]].push(valueArr[1]);
			
			}
		
		}else{
		
			if(arr[valueArr[0]]){
			
				var len = arr[valueArr[0]].length;
				for(var i = 0; i < len; i++){
			
					if(arr[valueArr[0]][i] == valueArr[1]){
				
						arr[valueArr[0]].splice(i, 1);
						break;
				
					}
			
				}
			
			}
		
		}
	
	}
	);

}
function genXML(){

	$("#loadingIcon").css("display","block");
	jQuery.ajax({type:"GET", url:"query.php", data:"action=genXML", success:
	function(str){
	
		switch(str){
		
			case "0":
				alert("生成失败, 请重新尝试!");
				break;
			case "1":
				alert("成功生成xml配置文件!");
				break;
			case "2":
				alert("配件xml文件生成失败，请重新尝试!");
				break;
		
		}
		$("#loadingIcon").css("display","none");
	
	}});

}
function flipPage(curType, totalPage)
{
	var tpage = $("#pageSelecter").find("option:selected").val();
	var str = "index.php?page=detail&curType=" + curType + "&num=" + tpage + "&total=" + totalPage;
	window.location = str;
}
function flipComColorPage(curType, totalPage)
{
	var tpage = $("#pageSelecter").find("option:selected").val();
	var str = "index.php?page=comColor&curType=" + curType + "&num=" + tpage + "&total=" + totalPage;
	window.location = str;
}
function flipCurOrderPage(totalPage)
{
	var tpage = $("#pageSelecter").find("option:selected").val();
	var str = "index.php?page=curorder&num=" + tpage + "&total=" + totalPage;
	window.location = str;
}
function flipOldOrderPage(totalPage)
{
	var tpage = $("#pageSelecter").find("option:selected").val();
	var str = "index.php?page=oldorder&num=" + tpage + "&total=" + totalPage;
	window.location = str;
}
function submitAddon(mode){

	if($("#addonName").val() == ""){
		
		alert("配件名称/型号不能为空!");
		return;
		
	}
	var price = $("#addonPrice").val();
	if(price == ""){
		
		alert("配件价格不能为空!");
		return;
		
	}
	var pattern = /^\d[\d.]*(\d$)/;
    var bool = pattern.test(price);
    if(!bool){
            	
        alert("配件价格格式不正确!");
        return;
            	
    }
    $("#type").val($("#typeSelector").find("option:selected").val());
    var img = $("#uploader").val();
	if(!mode){
		if(img == ""){
		
			alert("请选择要上传的配件图片文件!");
			return;
		
		}
	
	}
	if(mode == "modify"){
	
		if(img != ""){
		
			if(img.substring(img.lastIndexOf(".")) != ".jpg"){
		
				alert("配件图片必需为jpg格式!");
				return;
		
			}
		
		}
	
		$("#addonForm").submit();
		return;
	
	}
	jQuery.ajax({type:"GET", url:"query.php", data:"action=checkAddons&typeOrName=" + $("#addonName").val() + "&type=" + $("#type").val(), success:
	function(str){
	
		if(str == 1){
		
			alert("该型号的配件已存在!");
			return;
		
		}else{
		
			$("#addonForm").submit();
		
		}
	
	}
	})

}
function changeDetailType()
{
	var type = $("#typeSelecter").find("option:selected").val();
	jQuery.ajax({type:"GET", url:"query.php", data:"action=getDetailsByType&type="+type, success:
	function(htmlStr){
	
		$("#rightside").html(htmlStr);
		//$("#curDetailType").html(type);
	
	}
	});
}
function changeComColorList()
{
	var type = $("#typeSelecter").find("option:selected").val();
	jQuery.ajax({type:"GET", url:"query.php", data:"action=getComColorList&type="+type, success:
	function(htmlStr){
	
		$("#typeTable").html(htmlStr);
		//$("#curDetailType").html(type);
	
	}
	});
}
function changeAddonsByType()
{
	var type = $("#typeSelecter").find("option:selected").val();
	jQuery.ajax({type:"GET", url:"query.php", data:"action=getAddonsByType&type="+type, success:
	function(htmlStr){
	
		$("#typeTable").html(htmlStr);
		//$("#curDetailType").html(type);
	
	}
	});
}
</script>
<body id="homepage">
	<div id="header">
    	<a href="" title=""><img src="img/cp_logo.png" alt="Control Panel" class="logo" /></a>
    	<div id="searcharea">
            <p class="left smltxt"><a href="index.php?page=advance" title="">Advanced</a></p>
            <!--<input type="text" class="searchbox" value="Search control panel..." onclick="if (this.value =='Search control panel...'){this.value=''}"/>
            <input type="submit" value="Search" class="searchbtn" />-->
        </div>
    </div>
        
    <!-- Top Breadcrumb Start -->
    <div id="breadcrumb">
    	<ul>	
        	<li><img src="img/icons/icon_breadcrumb.png" alt="Location" /></li>
        	<li><strong>Location:</strong></li>
            <li id="locLink"><?php
            if(!isset($_GET["page"])){
            
            	echo "管理后台首页";
            
            }else{
            
            	switch($_GET["page"]){
				
					case "type":
						echo "添加/修改车型";
						break;
					case "component":
						echo "添加/修改部件";
						break;
					case "detail":
						echo "查看车型以及款式";
						break;
					case "curorder":
						echo "当日订单";
						break;
					case "oldorder":
						echo "过往订单";
						break;
					case "comconfig":
						echo "部件类型配置";
						break;
					case "dirconfig":
						echo "方向配置";
						break;
					case "adminlist":
						echo "管理员列表";
						break;
					case "advance":
						echo "修改密码";
						break;
					case "color":
						echo "添加/修改部件颜色";
						break;
					case "editOrder":
						echo "订单修改";
						break;
					case "curorderview":
					case "orderview":
						echo "查看订单详情";
						break;
					case "modifycurorder":
					case "modifyoldorder":
						echo "修改订单";
						break;
					case "addons":
						echo "添加修改配件";
						break;
					case "addonsViewer":
						echo "查看各车型配件";
						break;
					case "comColor":
						echo "查看部件颜色";
						break;
					case "typeView":
						echo "查看车型";
						break;
				
				}
            
            }
            ?></li>
        </ul>
    </div>
    <!-- Top Breadcrumb End -->
     
    <!-- Right Side/Main Content Start -->
    <div id="rightside">
        
        <?php
        	//echo 
			if(isset($_GET["page"])){
			
				require_once("classes/pageCreator.php");
				$pageCreator = new PageCreator();
				switch($_GET["page"]){
				
					case "type":
						echo $pageCreator -> newType();
						break;
					case "component":
						echo $pageCreator -> newComponent();
						break;
					case "detail":
						$curPage = 1;
						$totalPage = 0;
						$curType = "";
						if(isset($_GET["num"])){
						
							if($_GET["num"] != ""){
							
								$curPage = $_GET["num"];
							
							}
						
						}
						if(isset($_GET["total"])){
						
							if($_GET["total"] != ""){
							
								$totalPage = $_GET["total"];
							
							}
						
						}
						if(isset($_GET["curType"]) && $_GET["curType"] != ""){
						
							$curType = $_GET["curType"];
						
						}
						echo $pageCreator -> detailView($curPage, $totalPage, $curType);
						echo "<script>registCheckBox();</script>";
						break;
					case "curorder":
						$curPage = 1;
						$totalPage = 0;
						if(isset($_GET["num"])){
						
							if($_GET["num"] != ""){
							
								$curPage = $_GET["num"];
							
							}
						
						}
						if(isset($_GET["total"])){
						
							if($_GET["total"] != ""){
							
								$totalPage = $_GET["total"];
							
							}
						
						}
						echo $pageCreator -> todayOrders($curPage, $totalPage);
						break;
					case "oldorder":
						$curPage = 1;
						$totalPage = 0;
						if(isset($_GET["num"])){
						
							if($_GET["num"] != ""){
							
								$curPage = $_GET["num"];
							
							}
						
						}
						if(isset($_GET["total"])){
						
							if($_GET["total"] != ""){
							
								$totalPage = $_GET["total"];
							
							}
						
						}
						echo $pageCreator -> oldOrders($curPage, $totalPage);
						break;
					case "comconfig":
						echo $pageCreator -> componentConfig();
						break;
					case "dirconfig":
						echo $pageCreator -> directionConfig();
						break;
					case "adminlist":
						if(isset($_GET["action"])){
						
							if($_GET["action"] == "edit"){
							
								echo $pageCreator -> administratorList($_GET["id"], $_GET["action"]);
							
							}
							break;
						
						}
						echo $pageCreator -> administratorList();
						break;
					case "advance":
						echo $pageCreator -> advancedPage();
						break;
					case "color":
						echo $pageCreator -> colorPage();
						break;
					case "editOrder":
						if(isset($_GET["id"])){
						
							echo $pageCreator -> editOrderPage($_GET["id"], $_GET["from"]);
						
						}
						break;
					case "curorderview":
					case "orderview":
						echo $pageCreator -> orderViewPage();
						break;
					case "modifycurorder":
					case "modifyoldorder":
						echo $pageCreator -> modifyOrderPage();
						break;
					case "addons":
						echo $pageCreator -> addOnsPage();
						break;
					case "addonsViewer":
						echo $pageCreator -> addonsViewPage();
						break;
					case "comColor":
						$curPage = 1;
						$totalPage = 0;
						$curType = "";
						if(isset($_GET["num"])){
						
							if($_GET["num"] != ""){
							
								$curPage = $_GET["num"];
							
							}
						
						}
						if(isset($_GET["total"])){
						
							if($_GET["total"] != ""){
							
								$totalPage = $_GET["total"];
							
							}
						
						}
						if(isset($_GET["curType"]) && $_GET["curType"] != ""){
						
							$curType = $_GET["curType"];
						
						}
						echo $pageCreator -> comColorViewPage($curPage, $totalPage, $curType);
						break;
					case "typeView":
						echo $pageCreator -> typeViewPage();
						break;
				
				}
			
			}
		?>
          
    </div>
    <!-- Right Side/Main Content End -->
    
        <!-- Left Dark Bar Start -->
    <div id="leftside">
    	<div class="user">
        	<img src="img/avatar.png" width="44" height="44" class="hoverimg" alt="Avatar" />
            <p>Logged in as:</p>
            <p class="username"><?php echo $_SESSION["admin"] ?></p>
            <p class="userbtn"><a href="index.php?action=logout" title="">注销</a></p>
        </div>
        <!--<div class="notifications">
        	<p class="notifycount"><a href="" title="" class="notifypop">10</a></p>
            <p><a href="" title="" class="notifypop">New Notifications</a></p>
            <p class="smltxt">(Click to open notifications)</p>
        </div>-->
        
        <ul id="nav">
        	<li>
        		<a class="expanded heading">订单管理</a>
                <ul class="navigation">
                  <li <?php setID("curorder") ?>><a href="index.php?page=curorder" title="">当日订单</a></li>
                    <li <?php setID("oldorder") ?>><a href="index.php?page=oldorder" title="">过往订单</a></li>
                </ul>
            </li>
            <li>
                <a class="expanded heading">车型以及款式设置</a>
                 <ul class="navigation">
                    <li <?php setID("type") ?>><a href="index.php?page=type" title="">添加新车型</a></li>
                    <li <?php setID("addons") ?>><a href="index.php?page=addons" title="">添加/修改配件</a></li>
                    <li <?php setID("color") ?>><a href="index.php?page=color" title="">添加/修改部件颜色</a></li>
                    <li <?php setID("component") ?>><a href="index.php?page=component" title="">添加/修改部件</a></li>
                    <li <?php setID("typeView") ?>><a href="index.php?page=typeView" title="">查看车型</a></li>
                    <li <?php setID("comColor") ?>><a href="index.php?page=comColor" title="">查看部件颜色</a></li>
                    <li <?php setID("addonsViewer") ?>><a href="index.php?page=addonsViewer" title="">查看各车型配件</a></li>
                    <li <?php setID("detail") ?>><a href="index.php?page=detail" title="">查看车型以及款式</a></li>
                </ul>
            </li>
            <li><a class="expanded heading">相关配置</a>
                <ul class="navigation">
                    <li <?php setID("comconfig") ?>><a href="index.php?page=comconfig" title="" class="likelogin">部件类型配置</a></li>
                    <li <?php setID("dirconfig") ?>><a href="index.php?page=dirconfig" title="" class="likelogin">方向配置</a></li>
                </ul>
            </li>
            <li><a class="expanded heading">管理员操作</a>
                <ul class="navigation">
                    <li <?php setID("adminlist") ?>><a href="index.php?page=adminlist" title="" class="likelogin">管理员列表</a></li>
                </ul>
            </li>
            <li>
            <ul class="navigation">
                <li><div style="float:left;width:100px;"><a href="javascript:void(0)" onclick="genXML()" title="" class="likelogin">生成配置文件</a></div><div id="loadingIcon" style="display:none; float:right;padding-top:10px;padding-right:10px;"><img src="img/loading.gif" alt="Loading"></div></li>
            </ul>
            </li>
        </ul>
    </div>
    <!-- Left Dark Bar End --> 
    
    <!--[if IE 6]>
    <script type='text/javascript' src='scripts/png_fix.js'></script>
    <script type='text/javascript'>
      DD_belatedPNG.fix('img, .notifycount, .selected');
    </script>
    <![endif]--> 
</body>
</html>
