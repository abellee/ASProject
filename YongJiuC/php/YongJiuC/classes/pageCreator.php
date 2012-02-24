<?php
require_once("db.php");
class PageCreator
{
	function indexPage()   //网站后台首页页面
	{
	}
	function todayOrders($cp = 1, $tp = 0) //当时订单
	{
		$mytime = getdate();
		$year = $mytime["year"];
		$month = $mytime["mon"];
		$day = $mytime["mday"];
		$now = mktime(0, 0, 0, $month, $day, $year);
		$db = new DBConnection();
		$totalPage = $tp;
		if($tp == 0){
		
			$pages = $db -> queryOrder("select count(*) from yjc_order where createTime >= ".$now);
			$num = $pages[0][0];
			$totalPage = ceil($num / 10);
		
		}
		/*$pageList = "";
		if($totalPage > 15){
		
			for($i = 0; $i < 10; $i++){
			
				if(($i+1) == $cp){
				
					$pageList .= "<li class=\"page\"><a href=\"index.php?page=curorder&num=".($i+1)."&total=".$totalPage."\" title=\"\">".($i+1)."</a></li>";
				
				}else{
				
					$pageList .= "<li><a href=\"index.php?page=curorder&num=".($i+1)."&total=".$totalPage."\" title=\"\">".($i+1)."</a></li>";
				
				}
			
			}
			$pageList .= "..." + "<li><a href=\"index.php?page=curorder&num=".$totalPage."&total=".$totalPage."\" title=\"\">".$totalPage."</a></li>";
		
		}else{
		
			for($j = 0; $j < $totalPage; $j++){
			
				if(($j+1) == $cp){
				
					$pageList .= "<li class=\"page\"><a href=\"index.php?page=curorder&num=".($j+1)."&total=".$totalPage."\" title=\"\">".($j+1)."</a></li>";
				
				}else{
				
					$pageList .= "<li><a href=\"index.php?page=curorder&num=".($j+1)."&total=".$totalPage."\" title=\"\">".($j+1)."</a></li>";
				
				}
			
			}
		
		}*/
		
		$pageList = "<li><select id=\"pageSelecter\" onchange=\"flipCurOrderPage(".$totalPage.")\">";
		for($ii = 0; $ii < $totalPage; $ii++){
		
			if(($ii + 1) == $cp){
			
				$pageList .= "<option value=\"".($ii + 1)."\" selected>第".($ii + 1)."页</option>";
			
			}else{
			
				$pageList .= "<option value=\"".($ii + 1)."\">第".($ii + 1)."页</option>";
			
			}
		
		}
		$pageList .= "</select></li>";
		
		$arr = $db -> queryOrder("select * from yjc_order where createTime >= ".$now." order by id desc limit ".(($cp-1)*10).", 10");
		$str = "";
		foreach($arr as $value){
		
			$state = "";
			switch($value["state"]){
			
				case 0:
				$state = "未处理";
				break;
				case 1:
				$state = "正在配货";
				break;
				case 2:
				$state = "已发货";
				break;
			
			}
			$payment = "";
			switch($value["payment"]){
				case 0:
				$payment = "未付款";
				break;
				case 1:
				$payment = "已付款";
				break;
			}
			$types = $db -> queryOrder("select * from yjc_type where id=".$value["type"]);
			$typeText = $types[0]["type"];
			$str .= "<tr>
			<td>".$value["id"]."</td>
			<td>".$value["preorderNum"]."</td>
            <td>".$typeText."</td>
            <td>".$value["username"]."</td>
            <td width=\"200\">".$value["address"]."</td>
            <td>".$value["cellphone"]."</td>
            <td>".$value["telnumber"]."</td>
            <td>".$value["email"]."</td>
			<td>".$value["zipCode"]."</td>
            <td>".$value["price"]."</td>
            <td>".$state."</td>
			<td>".$payment."</td>
            <td>
            <a href=\"index.php?page=editOrder&from=cur&id=".$value["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a>
            <a href=\"javascript:void(0)\" onclick=\"javascript:if(confirm('确定删除此订单吗?')){window.location='query.php?action=delorder&from=cur&id=".$value["id"]."'}\"><img src=\"img/icons/icon_delete.png\" alt=\"删除\" title=\"删除\" /></a>
            </td>
            <td><a href=\"index.php?page=curorderview&id=".$value["id"]."\"><input type=\"button\" value=\"查看\" class=\"btn\" /></a></td>
            </tr>";
		
		}
		$db -> closeConnection();
		$nextPage = $cp + 1;
		if($nextPage > $totalPage){
		
			$nextPage = "#";
		
		}
		$prePage = $cp - 1;
		if($prePage < 1){
		
			$prePage = "#";
		
		}
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>当日订单</h2>
            </div>
            <div class=\"contentbox\">
            <table width=\"100%\">
                	<thead>
                    	<tr>
                    		<th>序号</th>
							<th>订单号</th>
                        	<th>车型</th>
                            <th>姓名</th>
                            <th>收货地址</th>
                            <th>手机号码</th>
                            <th>联系电话</th>
                            <th>邮箱</th>
							<th>邮编号码</th>
                            <th>订单总额</th>
                            <th>状态</th>
							<th>支付状态</th>
                            <th>操作</th>
                            <th>订单详情</th>
                        </tr>
                    </thead>
                    <tbody>
                    	".$str."
                    </tbody>
                </table>
                <div style=\"height:20px;padding-top:20px;\">
                        <ul class=\"pagination\" id=\"pagenavigator\">
                	<li class=\"text\"><a href=\"index.php?page=curorder&num=".$prePage."&total=".$totalPage."\" title=\"\">上一页</a></li>
                    ".$pageList."
                    <li class=\"text\"><a href=\"index.php?page=curorder&num=".$nextPage."&total=".$totalPage."\" title=\"\">下一页</a></li>
                    <li class=\"text\"> 共 </li>
                    <li class=\"text\" id=\"totalPageNum\">".$totalPage."</li>
                    <li class=\"text\"> 页 </li>
                </ul>
                <div style=\"clear: both;\"></div>
                </div>
                        </div>
                        </div>";
	}
	function oldOrders($cp = 1, $tp = 0)   //过往订单
	{
		$mytime = getdate();
		$year = $mytime["year"];
		$month = $mytime["mon"];
		$day = $mytime["mday"];
		$now = mktime(0, 0, 0, $month, $day, $year);
		$db = new DBConnection();
		$totalPage = $tp;
		if($tp == 0){
		
			$pages = $db -> queryOrder("select count(*) from yjc_order where createTime < ".$now);
			$num = $pages[0][0];
			$totalPage = ceil($num / 10);
		
		}
		/*$pageList = "";
		if($totalPage > 15){
		
			for($i = 0; $i < 10; $i++){
			
				if(($i+1) == $cp){
				
					$pageList .= "<li class=\"page\"><a href=\"index.php?page=oldorder&num=".($i+1)."&total=".$totalPage."\" title=\"\">".($i+1)."</a></li>";
				
				}else{
				
					$pageList .= "<li><a href=\"index.php?page=oldorder&num=".($i+1)."&total=".$totalPage."\" title=\"\">".($i+1)."</a></li>";
				
				}
			
			}
			$pageList .= "..." + "<li><a href=\"index.php?page=oldorder&num=".$totalPage."&total=".$totalPage."\" title=\"\">".$totalPage."</a></li>";
		
		}else{
		
			for($j = 0; $j < $totalPage; $j++){
			
				if(($j+1) == $cp){
				
					$pageList .= "<li class=\"page\"><a href=\"index.php?page=oldorder&num=".($j+1)."&total=".$totalPage."\" title=\"\">".($j+1)."</a></li>";
				
				}else{
				
					$pageList .= "<li><a href=\"index.php?page=oldorder&num=".($j+1)."&total=".$totalPage."\" title=\"\">".($j+1)."</a></li>";
				
				}
			
			}
		
		}*/
		
		$pageList = "<li><select id=\"pageSelecter\" onchange=\"flipOldOrderPage(".$totalPage.")\">";
		for($ii = 0; $ii < $totalPage; $ii++){
		
			if(($ii + 1) == $cp){
			
				$pageList .= "<option value=\"".($ii + 1)."\" selected>第".($ii + 1)."页</option>";
			
			}else{
			
				$pageList .= "<option value=\"".($ii + 1)."\">第".($ii + 1)."页</option>";
			
			}
		
		}
		$pageList .= "</select></li>";
		
		$arr = $db -> queryOrder("select * from yjc_order where createTime < ".$now." order by id desc limit ".(($cp-1)*10).", 10");
		$str = "";
		foreach($arr as $value){
		
			$state = "";
			switch($value["state"]){
			
				case 0:
				$state = "未处理";
				break;
				case 1:
				$state = "正在配货";
				break;
				case 2:
				$state = "已发货";
				break;
			
			}
			$payment = "";
			switch($value["payment"]){
				case 0:
				$payment = "未付款";
				break;
				case 1:
				$payment = "已付款";
				break;
			}
			$types = $db -> queryOrder("select * from yjc_type where id=".$value["type"]);
			$typeText = $types[0]["type"];
			$str .= "<tr>
			<td>".$value["id"]."</td>
			<td>".$value["preorderNum"]."</td>
            <td>".$typeText."</td>
            <td>".$value["username"]."</td>
            <td width=\"200\">".$value["address"]."</td>
            <td>".$value["cellphone"]."</td>
            <td>".$value["telnumber"]."</td>
            <td>".$value["email"]."</td>
			<td>".$value["zipCode"]."</td>
            <td>".$value["price"]."</td>
            <td>".$state."</td>
			<td>".$payment."</td>
            <td>
            <a href=\"index.php?page=editOrder&from=old&id=".$value["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a>
            <a href=\"javascript:void(0)\" onclick=\"javascript:if(confirm('确定删除此订单吗?')){window.location='query.php?action=delorder&from=old&id=".$value["id"]."'}\"><img src=\"img/icons/icon_delete.png\" alt=\"删除\" title=\"删除\" /></a>
            </td>
            <td><a href=\"index.php?page=orderview&id=".$value["id"]."\"><input type=\"button\" value=\"查看\" class=\"btn\" /></a></td>
            </tr>";
		
		}
		$db -> closeConnection();
		$nextPage = $cp + 1;
		if($nextPage > $totalPage){
		
			$nextPage = "#";
		
		}
		$prePage = $cp - 1;
		if($prePage < 1){
		
			$prePage = "#";
		
		}
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>过往订单</h2>
            </div>
            <div class=\"contentbox\">
            <table width=\"100%\" name=\"abel\">
                	<thead>
                    	<tr>
                    		<th>序号</th>
							<th>订单号</th>
                        	<th>车型</th>
                            <th>姓名</th>
                            <th>收货地址</th>
                            <th>手机号码</th>
                            <th>联系电话</th>
                            <th>邮箱</th>
							<th>邮编号码</th>
                            <th>订单总额</th>
                            <th>状态</th>
							<th>支付状态</th>
                            <th>操作</th>
                            <th>订单详情</th>
                        </tr>
                    </thead>
                    <tbody>
                    	".$str."
                    </tbody>
                </table>
                <div style=\"height:20px;padding-top:20px;\">
                        <ul class=\"pagination\" id=\"pagenavigator\">
                	<li class=\"text\"><a href=\"index.php?page=oldorder&num=".$prePage."&total=".$totalPage."\" title=\"\">上一页</a></li>
                    ".$pageList."
                    <li class=\"text\"><a href=\"index.php?page=oldorder&num=".$nextPage."&total=".$totalPage."\" title=\"\">下一页</a></li>
                    <li class=\"text\"> 共 </li>
                    <li class=\"text\" id=\"totalPageNum\">".$totalPage."</li>
                    <li class=\"text\"> 页 </li>
                </ul>
                <div style=\"clear: both;\"></div>
                </div>
                        </div>
                        </div>";
	}
	function modifyType()
	{
		$id = $_GET["id"];
		$db = new DBConnection();
		$type = $db -> queryOrder("select * from yjc_type where id=".$id);
		$typeName = $type[0]["type"];
		
		return "<div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加新车型</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=modifyType\" method=\"post\">
            <input type=\"hidden\" value=\"".$id."\" name=\"typeid\" />
            <p><label for=\"textfield\"><strong>请输入型号:</strong></label>
                        <input type=\"text\" id=\"textfield\" name=\"type\" class=\"inputbox\" value=\"".$typeName."\" /> <br />
                        <input type=\"submit\" value=\"添加\" class=\"btn\" /></p>
                        </form>
                        </div>
                        </div>";
	}
	function newType()     //添加新车型页面
	{
		if(isset($_GET["action"]) && $_GET["action"] == "modify"){
		
			return $this -> modifyType();
		
		}
		return "<div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加新车型</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=addtype\" method=\"post\">
            <p><label for=\"textfield\"><strong>请输入型号:</strong></label>
                        <input type=\"text\" id=\"textfield\" name=\"type\" class=\"inputbox\" /> <br />
                        <input type=\"submit\" value=\"添加\" class=\"btn\" /></p>
                        </form>
                        </div>
                        </div>";
	}
	function editOrderPage($id, $from)
	{
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_order where id=".$id);
		
		$type = $arr[0]["type"];
		$username = $arr[0]["username"];
		$email = $arr[0]["email"];
		$address = $arr[0]["address"];
		$tel = $arr[0]["telnumber"];
		$price = $arr[0]["price"];
		$state = $arr[0]["state"];
		
		$arr = $db -> queryOrder("select * from yjc_type");
		
		$str = "<select id=\"selectorType\">";
		foreach($arr as $value){
		
			$str .= "<option value=\"".$value["id"]."\"";
			if($value["type"] == $type){
			
				$str .= " selected";
			
			}
			$str .= ">".$value["type"]."</option>";
		
		}
		$str .= "</select>";
		$stateList = "";
		switch($state){
		
			case 0:
				$stateList = "<select id=\"selectorState\">
                        	<option value=\"0\" selected>未处理</option>
                        	<option value=\"1\">正在配货</option>
                        	<option value=\"2\">已发货</option>
                        </select>";
                break;
            case 1:
            	$stateList = "<select id=\"selectorState\">
                        	<option value=\"0\">未处理</option>
                        	<option value=\"1\" selected>正在配货</option>
                        	<option value=\"2\">已发货</option>
                        </select>";
                break;
            case 2:
            	$stateList = "<select id=\"selectorState\">
                        	<option value=\"0\">未处理</option>
                        	<option value=\"1\">正在配货</option>
                        	<option value=\"2\" selected>已发货</option>
                        </select>";
                break;
		
		}
		return "<div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>订单修改</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=editOrder&from=".$from."\" method=\"post\" id=\"orderForm\">
            <input type=\"hidden\" value=\"".$id."\" name=\"orderId\" />
            <input type=\"hidden\" name=\"typeInfo\" id=\"typeSelector\" />
            <input type=\"hidden\" name=\"orderState\" id=\"stateSelector\" />
            <p><label for=\"textfield\"><strong>请选择型号:</strong></label>
            ".$str."<br>
            <p><label for=\"textfield\"><strong>请输入客房姓名:</strong></label>
                        <input type=\"text\" id=\"textfield\" name=\"username\" class=\"inputbox\" value=\"".$username."\" /> <br />
                        <label for=\"textfield\"><strong>请输入收货地址:</strong></label>
                        <input type=\"text\" id=\"textfield\" name=\"address\" value=\"".$address."\" class=\"inputbox\" /> <br />
                        <label for=\"textfield\"><strong>请输入联系电话:</strong></label>
                        <input type=\"text\" id=\"textfield\" name=\"telephone\" value=\"".$tel."\" class=\"inputbox\" /> <br />
                        <label for=\"textfield\"><strong>请输入邮箱:</strong></label>
                        <input type=\"text\" id=\"textfield\" name=\"email\" value=\"".$email."\" class=\"inputbox\" /> <br />
                        <label for=\"textfield\"><strong>请输入价格:</strong></label>
                        <input type=\"text\" id=\"textfield\" name=\"price\" value=\"".$price."\" class=\"inputbox\" /> <br />
                        <p><label for=\"textfield\"><strong>请选择订单状态:</strong></label>
                        ".$stateList."<br>
                        <input type=\"button\" value=\"确认\" onclick=\"setData()\" class=\"btn\" /></p>
                        </form>
                        </div>
                        <script type=\"text/javascript\">
                        function setData(){
                        
                        	$(\"#typeSelector\").val($(\"#selectorType\").find(\"option:selected\").val());
                        	$(\"#stateSelector\").val($(\"#selectorState\").find(\"option:selected\").val());
                        
                        	$(\"#orderForm\").submit();
                        }
                        </script>
                        </div>";
	}
	function modifyComponent() //修改部件
	{
		if(isset($_GET["id"])){
		
			$id = $_GET["id"];
			$db = new DBConnection();
			$arr = $db -> queryOrder("select * from yjc_component where id=".$id);
			$typeid = $arr[0]["type"];
			$types = $db -> queryOrder("select * from yjc_type where id=".$typeid);
			$type = $types[0]["type"];
			$com = $arr[0]["comName"];
			$dir = $arr[0]["direction"];
			$color = $arr[0]["colorList"];
			$price = $arr[0]["price"];
			$arr = $db -> queryOrder("select * from yjc_type");
		$str = "<select id = \"typeSelector\">";
		foreach($arr as $value){
		
			if($value["type"] == $type){
			
				$str .= "<option value=\"".$value["id"]."\" selected>".$value["type"]."</option>";
			
			}else{
			
				$str .= "<option value=\"".$value["id"]."\">".$value["type"]."</option>";
			
			}
		
		}
		$str .= "</select>";
		$arr = $db -> queryOrder("select * from yjc_comconfig");
		$comstr = "<select id=\"comSelector\" onchange=\"showColor()\">";
		foreach($arr as $value){
		
			if($value["comKey"] == $com){
			
				$comstr .= "<option value=\"".$value["comKey"]."\" selected>".$value["comName"]."</option>";
			
			}else{
			
				$comstr .= "<option value=\"".$value["comKey"]."\">".$value["comName"]."</option>";
			
			}
		
		}
		$comstr .= "</select>";
		$arr = $db -> queryOrder("select * from yjc_dirconfig");
		$dirstr = "<select id=\"dirSelector\">";
		foreach($arr as $value){
		
			if($value["dirKey"] == $dir){
			
				$dirstr .= "<option value=\"".$value["dirKey"]."\" selected>".$value["dirName"]."</option>";
			
			}else{
			
				$dirstr .= "<option value=\"".$value["dirKey"]."\">".$value["dirName"]."</option>";
			
			}
		
		}
		$dirstr .= "</select>";
		return "<script type=\"text/javascript\">
		
            function setValues(){
            
            	if($(\"#selectColor\").val() == \"\"){
            	
            		alert(\"请选择部件颜色!\");
            		return;
            	
            	}
            	if($(\"#uploader\").val() != \"\"){
            	
            		if($(\"#uploader\").val().substring($(\"#uploader\").val().lastIndexOf(\".\")) != \".png\"){
            	
            			alert(\"上传的部件文件必须为png格式文件！\");
            			return;
            	
            		}
            	
            	}
            	var p = $(\"#comPrice\").val();
            	p = p.replace(/\s*/g, \"\");
            	if(p == \"\"){
            	
            		alert(\"请填写部件价格!\");
            		return;
            	
            	}
            	var pattern = /^\d[\d.]*(\d$)/;
            	var bool = pattern.test(p);
            	if(!bool){
            	
            		alert(\"部件价格格式不正确!\");
            		return;
            	
            	}
            	$(\"#selectType\").val($(\"#typeSelector\").find(\"option:selected\").val());
            	$(\"#selectCom\").val($(\"#comSelector\").find(\"option:selected\").val());
            	$(\"#selectDir\").val($(\"#dirSelector\").find(\"option:selected\").val());
            	jQuery.ajax({type:'GET', url:'query.php', data:'action=checkFileExist&type='+$(\"#selectType\").val()+\"&com=\"+$(\"#selectCom\").val()+\"&dir=\"+$(\"#selectDir\").val()+\"&color=\"+$(\"#selectColor\").val(), success:
            	function(bool){
            	
            		if(bool != 0){
            		
            			$(\"#comForm\").submit();
            		
            		}else{
            		
            			$(\"#comForm\").submit();
            		
            		}
            	
            	}
            	})
            
            }
            </script>
            <div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加/修改部件</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=modifyComponent\" method=\"post\" id=\"comForm\" enctype=\"multipart/form-data\">
            <input type=\"hidden\" id=\"comID\" name=\"comid\" value=\"".$id."\" />
            <input type=\"hidden\" id=\"selectType\" name=\"type\" />
            <input type=\"hidden\" id=\"selectCom\" name=\"com\" />
            <input type=\"hidden\" id=\"selectDir\" name=\"dir\" />
            <input type=\"hidden\" id=\"selectColor\" name=\"color\" value=\"".$color."\" />
            <p><label for=\"textfield\"><strong>请选择型号:</strong></label>
                        ".$str."<br /><br />
                    	<label for=\"textfield\"><strong>请选择部件类型:</strong></label>
                        ".$comstr."<br /><br />
                    	<label for=\"textfield\"><strong>请选择部件各方向图片:</strong></label>
                        ".$dirstr."<br /><br />
                    	<label for=\"textfield\"><strong>请选择部件颜色:</strong></label>
                        <span id=\"colorArea\"></span><br /><br />
                    	<label for=\"textfield\"><strong>请上传部件图片文件:</strong></label>
                        <input type=\"file\" id=\"uploader\" name=\"swfFile\" />不修改则无需选择文件! <br /><br />
                        <label for=\"textfield\"><strong>请填写该部件价格:</strong></label>
                        <input type=\"text\" id=\"comPrice\" value=".str_replace("#", ".", $price)." class=\"inputbox\" name=\"price\" /> <br /><br />
                        <input type=\"button\" value=\"确认修改\" class=\"btn\" onclick=\"setValues()\" /></p>
            </form>
                        </div>
                        </div><script type=\"text/javascript\">
	showColor(".$color.");
</script>";
		}
	}
	function newComponent()    //添加、修改 部件页面
	{
		if(isset($_GET["action"])){
		
			if(isset($_GET["action"]) == "modify"){
			
				return $this -> modifyComponent();
			
			}
		
		}
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_type order by id asc");
		$str = "<select id = \"typeSelector\" onchange=\"showColor()\">";
		foreach($arr as $value){
		
			$str .= "<option value=\"".$value["id"]."\">".$value["type"]."</option>";
		
		}
		$str .= "</select>";
		$arr = $db -> queryOrder("select * from yjc_comconfig order by id asc");
		$comstr = "<select id=\"comSelector\" onchange=\"showColor()\">";
		foreach($arr as $value){
		
			$comstr .= "<option value=\"".$value["comKey"]."\">".$value["comName"]."</option>";
		
		}
		$comstr .= "</select>";
		$arr = $db -> queryOrder("select * from yjc_dirconfig order by id asc");
		$dirstr = "";
		foreach($arr as $value){
		
			$dirstr .= "<label for=\"textfield\">".$value["dirName"].":</label><input type=\"file\" id=\"uploader".$value["dirKey"]."\" name=\"swfFile".$value["dirKey"]."\" /><br /><br />";
		
		}
		$dirstr .= "</select>";
		return "<script type=\"text/javascript\">
		
            function setValues(){
            
            	if($(\"#selectColor\").val() == \"\"){
            	
            		alert(\"请选择部件颜色!\");
            		return;
            	
            	}
            	if($(\"#uploader0\").val() == \"\" || $(\"#uploader1\").val() == \"\" || $(\"#uploader2\").val() == \"\" || $(\"#uploader3\").val() == \"\" || $(\"#uploader4\").val() == \"\" || $(\"#uploader5\").val() == \"\"){
            	
            		alert(\"请选择要上传的部件图片文件!\");
            		return;
            	
            	}
            	if($(\"#uploader0\").val().substring($(\"#uploader0\").val().lastIndexOf(\".\")) != \".png\" || $(\"#uploader1\").val().substring($(\"#uploader1\").val().lastIndexOf(\".\")) != \".png\" || $(\"#uploader2\").val().substring($(\"#uploader2\").val().lastIndexOf(\".\")) != \".png\" || $(\"#uploader3\").val().substring($(\"#uploader3\").val().lastIndexOf(\".\")) != \".png\" || $(\"#uploader4\").val().substring($(\"#uploader4\").val().lastIndexOf(\".\")) != \".png\" || $(\"#uploader5\").val().substring($(\"#uploader5\").val().lastIndexOf(\".\")) != \".png\"){
            	
            		alert(\"上传的部件文件必须为png格式文件！\");
            		return;
            	
            	}
            	var p = $(\"#comPrice\").val();
            	p = p.replace(/\s*/g, \"\");
            	if(p == \"\"){
            	
            		alert(\"请填写部件价格!\");
            		return;
            	
            	}
            	var pattern = /^\d[\d.]*(\d$)/;
            	var bool = pattern.test(p);
            	if(!bool){
            	
            		alert(\"部件价格格式不正确!\");
            		return;
            	
            	}
            	$(\"#selectType\").val($(\"#typeSelector\").find(\"option:selected\").val());
            	$(\"#selectCom\").val($(\"#comSelector\").find(\"option:selected\").val());
            	//$(\"#selectDir\").val($(\"#dirSelector\").find(\"option:selected\").val());
            	jQuery.ajax({type:'GET', url:'query.php', data:'action=checkFileExist&type='+$(\"#selectType\").val()+\"&com=\"+$(\"#selectCom\").val()+\"&dir=0&color=\"+$(\"#selectColor\").val(), success:
            	function(bool){
            	
            		if(bool != 0){
            		
            			var bo = confirm(\"您上传的该颜色的部件已经存在，是否确认替换?\");
            			if(bo){
            			
            				$(\"#comForm\").submit();
            			
            			}
            		
            		}else{
            		
            			$(\"#comForm\").submit();
            		
            		}
            	
            	}
            	})
            
            }
            </script>
            <div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加/修改部件</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=addComponent\" method=\"post\" id=\"comForm\" enctype=\"multipart/form-data\">
            <input type=\"hidden\" id=\"selectType\" name=\"type\" />
            <input type=\"hidden\" id=\"selectCom\" name=\"com\" />
            <input type=\"hidden\" id=\"selectDir\" name=\"dir\" />
            <input type=\"hidden\" id=\"selectColor\" name=\"color\" />
            <p><label for=\"textfield\"><strong>请选择型号:</strong></label>
                        ".$str."<br /><br />
                    	<label for=\"textfield\"><strong>请选择部件类型:</strong></label>
                        ".$comstr."<br /><br />
                    	<label for=\"textfield\"><strong>请选择部件各方向图片:</strong></label>
                        ".$dirstr."
                    	<label for=\"textfield\"><strong>请选择部件颜色:</strong></label>
                        <span id=\"colorArea\"></span><br /><br />
                        <label for=\"textfield\"><strong>请填写该部件价格:</strong></label>
                        <input type=\"text\" id=\"comPrice\" class=\"inputbox\" name=\"price\" /> <br /><br />
                        <input type=\"button\" value=\"添加\" class=\"btn\" onclick=\"setValues()\" /></p>
            </form>
                        </div>
                        </div><script type=\"text/javascript\">
	showColor(null);
</script>";
	}
	function detailView($cp = 1, $tp = 0, $curType="")     //查看车型以及款式页面
	{
		$db = new DBConnection();
		$types = $db -> queryOrder("select * from yjc_type order by id asc");
		$str = "";
		$typeSelect = "";
		$curTypeStr = "";
		if(!$types || !count($types)){
		
		}else{
		
			//$curTypeStr = $types[0]["type"];
			$comconfig = $db -> queryOrder("select * from yjc_comconfig");
		$dirconfig = $db -> queryOrder("select * from yjc_dirconfig");
		if($curType == ""){
		
			$curType = $types[0]["id"];
		
		}
		$pages = $db -> queryOrder("select count(*) from yjc_component where type='".$curType."'");
		$num = $pages[0][0];
		$totalPage = ceil($num / 10);
		$typeSelect = "<select id=\"typeSelecter\" onchange=\"changeDetailType()\">";
		
		$pageList = "<li><select id=\"pageSelecter\" onchange=\"flipPage(".$curType.",".$totalPage.")\">";
		for($ii = 0; $ii < $totalPage; $ii++){
		
			if(($ii + 1) == $cp){
			
				$pageList .= "<option value=\"".($ii+1)."\" selected>第".($ii+1)."页</option>";
			
			}else{
			
				$pageList .= "<option value=\"".($ii+1)."\">第".($ii+1)."页</option>";
			
			}
		
		}
		$pageList .= "</select></li>";
		/*if($totalPage > 15){
		
			for($i = 0; $i < 10; $i++){
			
				if(($i+1) == $cp){
				
					$pageList .= "<li class=\"page\"><a href=\"index.php?page=detail&curType=".$curType."&num=".($i+1)."&total=".$totalPage."\" title=\"\">".($i+1)."</a></li>";
				
				}else{
				
					$pageList .= "<li><a href=\"index.php?page=detail&curType=".$curType."&num=".($i+1)."&total=".$totalPage."\" title=\"\">".($i+1)."</a></li>";
				
				}
			
			}
			$pageList .= "..." + "<li><a href=\"index.php?page=detail&curType=".$curType."&num=".$totalPage."&total=".$totalPage."\" title=\"\">".$totalPage."</a></li>";
		
		}else{
		
			for($j = 0; $j < $totalPage; $j++){
			
				if(($j+1) == $cp){
				
					$pageList .= "<li class=\"page\"><a href=\"index.php?page=detail&curType=".$curType."&num=".($j+1)."&total=".$totalPage."\" title=\"\">".($j+1)."</a></li>";
				
				}else{
				
					$pageList .= "<li><a href=\"index.php?page=detail&curType=".$curType."&num=".($j+1)."&total=".$totalPage."\" title=\"\">".($j+1)."</a></li>";
				
				}
			
			}
		
		}*/
		
		$details = $db -> queryOrder("select * from yjc_component where type='".$curType."' order by id desc limit ".(($cp-1)*10).", 10");
		
		if(count($types)){
		
			foreach($types as $v){
			
				if($curType == $v["id"]){
				
					$typeSelect .= "<option value=\"".$v["id"]."\" selected>".$v["type"]."</option>";
				
				}else{
				
					$typeSelect .= "<option value=\"".$v["id"]."\">".$v["type"]."</option>";
				
				}
			
			}
			$typeSelect .= "</select>";
		
		}
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
			$imageName = $db -> queryOrder("select colorImage from yjc_comcolor where id=".$value["colorList"]);
			if(count($imageName)){
			
			$typeText = "";
			foreach($types as $vvv){
			
				if($vvv["id"] == $value["type"]){
				
					$typeText = $vvv["type"];
					break;
				
				}
			
			}
				$colorsHtml = "<img src=\"".$typeText."/".$value["comName"]."/color/".$imageName[0]["colorImage"]."\" border=0 /> ";
				$str .= "<tr>
                        	<td>".$typeText."</td>
                            <td>".$comName."</td>
                            <td>".$dirValue."</td>
                            <td>".$colorsHtml."</td>
                            <td>".str_replace("#", ".", $value["price"])."</td>
                            <td><a href=\"index.php?page=component&action=modify&id=".$value["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a>
                            <a href=\"javascript:deleteComponentColor(".$value["id"].")\"><img src=\"img/icons/icon_unapprove.png\" title=\"删除\" alt=\"删除\" /></a></td>
                        </tr>";
			
			}
		
		}
		
		}
		$nextPage = $cp + 1;
		if($nextPage > $totalPage){
		
			$nextPage = "#";
		
		}
		$prePage = $cp - 1;
		if($prePage < 1){
		
			$prePage = "#";
		
		}
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>查看车型以及款式</h2>
            </div>
            <div class=\"contentbox\">
            <div style=\"height:40px;\">
            ".$typeSelect."
            </div>
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>车型</th>
                            <th>所属部件</th>
                            <th>部件方向</th>
                            <th>部件颜色</th>
                            <th>部件价格(人民币: 元)</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id=\"typeTable\">
                    	".$str."
                    </tbody>
                </table>
                <div style=\"height:20px;padding-top:20px;\">
                        <ul class=\"pagination\" id=\"pagenavigator\">
                	<li class=\"text\"><a href=\"index.php?page=detail&curType=".$curType."&num=".$prePage."&total=".$totalPage."\" title=\"\">上一页</a></li>
                    ".$pageList."
                    <li class=\"text\"><a href=\"index.php?page=detail&curType=".$curType."&num=".$nextPage."&total=".$totalPage."\" title=\"\">下一页</a></li>
                    <li class=\"text\"> 共 </li>
                    <li class=\"text\" id=\"totalPageNum\">".$totalPage."</li>
                    <li class=\"text\"> 页 </li>
                </ul>
                <div style=\"clear: both;\"></div>
                </div>
                        </div>
                        </div>";
	}
	function componentConfig()     //部件配置页面 无特殊需求请不要操作该页面
	{
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_comconfig");
		$str = "";
		foreach($arr as $value){
		
			$str .= "<tr>
                        	<td>".$value["comName"]."</td>
                            <td>".$value["comKey"]."</td>
                            <td>
                            	<a href=\"#\" title=\"\"><img src=\"img/icons/icon_edit.png\" alt=\"Edit\" /></a>
                                <a href=\"#\" title=\"\"><img src=\"img/icons/icon_unapprove.png\" alt=\"Unapprove\" /></a>
                            </td>
                        </tr>";
		
		}
		return "<div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>部件配置</h2>
            </div>
            <div class=\"contentbox\">
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>部件</th>
                            <th>键</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                    	".$str."
                    </tbody>
                </table>
                        </div>
                        </div>
                        <div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加/修改 部件配置</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=addcomconfig\" method=\"post\">
            <p><label for=\"textfield\"><strong>请输入部件名称:</strong></label>
                        <input type=\"text\" id=\"textfield\" class=\"inputbox\" name=\"comname\" /> <br /><br />
                        <label for=\"textfield\"><strong>请输入部件键值:</strong></label>
                        <input type=\"text\" id=\"textfield\" class=\"inputbox\" name=\"comkey\" /> <br /><br />
                        <input type=\"submit\" value=\"确认\" class=\"btn\" /></p>
                        </form>
                        </div>
                        </div>"; 
	}
	function directionConfig()    //方向配置页面 无特别需求请不要操作该页面
	{
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_dirconfig");
		$str = "";
		foreach($arr as $value){
		
			$str .= "<tr>
                        	<td>".$value["dirName"]."</td>
                            <td>".$value["dirKey"]."</td>
                            <td>
                            	<a href=\"#\" title=\"\"><img src=\"img/icons/icon_edit.png\" alt=\"Edit\" /></a>
                                <a href=\"#\" title=\"\"><img src=\"img/icons/icon_unapprove.png\" alt=\"Unapprove\" /></a>
                            </td>
                        </tr>";
		
		}
		return "<div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>方向配置</h2>
            </div>
            <div class=\"contentbox\">
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>方向</th>
                            <th>键</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                    	".$str."
                    </tbody>
                </table>
                        </div>
                        </div>
                        <div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加/修改 方向配置</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=adddirconfig\" method=\"post\">
            <p><label for=\"textfield\"><strong>请输入方向名称:</strong></label>
                        <input type=\"text\" id=\"textfield\" class=\"inputbox\" name=\"dirname\" /> <br /><br />
                        <label for=\"textfield\"><strong>请输入方向键值:</strong></label>
                        <input type=\"text\" id=\"textfield\" class=\"inputbox\" name=\"dirkey\" /> <br /><br />
                        <input type=\"submit\" value=\"确认\" class=\"btn\" /></p>
                        </form>
                        </div>
                        </div>"; 
	}
	function advancedPage()   //当前管理员修改密码界面
	{
		return "<script type=\"text/javascript\">
		function checkPass(){
		
			if($(\"#newpass\").val() != $(\"#verifynp\").val()){
			
				alert(\"两次输入的密码不同，请重新输入!\");
			
			}else{
			
				if($(\"#newpass\").val().length >= 6 && $(\"#newpass\").val().length <= 12){
				
					$(\"#passForm\").submit();
				
				}else{
				
					alert(\"密码长度必须在6至12之间！\");
				
				}
			
			}
		
		}
		</script><div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>密码修改</h2>
            </div>
            <div class=\"contentbox\">
            <p><form action=\"query.php?action=changepassword\" method=\"post\" id=\"passForm\"><label for=\"textfield\"><strong>请输入旧密码:</strong></label>
                        <input type=\"password\" id=\"textfield\" class=\"inputbox\" name=\"oldpass\" /> <br />
                        <label for=\"textfield\"><strong>请输入新密码:</strong></label>
                        <input type=\"password\" id=\"newpass\" class=\"inputbox\" name=\"password\" /> <br />
                        <label for=\"textfield\"><strong>请确认新密码:</strong></label>
                        <input type=\"password\" id=\"verifynp\" class=\"inputbox\" /> <br />
                        <input type=\"button\" value=\"确认修改\" onclick=\"checkPass()\" class=\"btn\" />
                        </form></p>
                        </div>
                        </div>";
	}
	function modifyComColor()
	{
		$id = $_GET["id"];
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_comcolor where id=".$id);
		if(!count($arr) || !$arr){
		
			return;
		
		}
		$comconfig = $db -> queryOrder("select * from yjc_comconfig");
		$type = $arr[0]["type"];
		$com = $arr[0]["component"];
		$colorValue = $arr[0]["colorValue"];
		$pantone = $arr[0]["pantone"];
		
		$types = $db -> queryOrder("select * from yjc_type");
		$str = "<select id=\"typeSelector\">";
		foreach($types as $value){
		
			if($value["type"] == $type){
				
				$str .= "<option value=\"".$value["type"]."\" selected>".$value["type"]."</option>";
			
			}else{
			
				$str .= "<option value=\"".$value["type"]."\">".$value["type"]."</option>";
			
			}
		
		}
		$str .= "</select>";
		$comstr = "<select id=\"comSelector\">";
		foreach($comconfig as $value){
		
			if($value["comKey"] == $com){
				
				$comstr .= "<option value=\"".$value["comKey"]."\" selected>".$value["comName"]."</option>";
			
			}else{
			
				$comstr .= "<option value=\"".$value["comKey"]."\">".$value["comName"]."</option>";
			
			}
		
		}
		$comstr .= "</select>";
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>添加/修改部件颜色</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=modifyColor\" method=\"post\" id=\"colorForm\" enctype=\"multipart/form-data\">
            <input type=\"hidden\" id=\"selectType\" name=\"type\" />
            <input type=\"hidden\" id=\"selectCom\" name=\"com\" />
            <input type=\"hidden\" id=\"hexValue\" name=\"hex\" value=\"".$colorValue."\" />
            <input type=\"hidden\" id=\"selectCom\" name=\"idvalue\" value=\"".$id."\" />
            <p><label for=\"textfield\"><strong>请选择型号:</strong></label>
                        ".$str."<br /><br />
                    	<label for=\"textfield\"><strong>请选择部件类型:</strong></label>
                        ".$comstr."<br /><br />
                        <label for=\"textfield\"><strong>请点击选择Pantone值:(如: 118C )</strong></label>
                        <input type=\"text\" id=\"colorField\" class=\"inputbox\" name=\"colorValue\" onclick=\"showBox()\" value=\"".$pantone."\" readonly /> <br /><br />
                        <input type=\"button\" value=\"关闭选择器\" id=\"closeBtn\" style=\"display:none\" onclick=\"closePicker()\" />
                        <div id=\"box\" style=\"display:none\"></div><br />
                        <input type=\"button\" value=\"添加\" class=\"btn\" onclick=\"checkValues()\" /></p>
            </form>
                        </div>
                        </div>";
	}
	function colorPage() //添加/修改部件颜色页面
	{
		if(isset($_GET["action"])){
		
			if($_GET["action"] == "modify"){
		
				return $this -> modifyComColor();
		
			}
		
		}
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_type order by id asc");
		$str = "<select id=\"typeSelector\">";
		foreach($arr as $value){
		
			$str .= "<option value=\"".$value["id"]."\">".$value["type"]."</option>";
		
		}
		$str .= "</select>";
		$arr = $db -> queryOrder("select * from yjc_comconfig order by id asc");
		$comstr = "<select id=\"comSelector\">";
		foreach($arr as $value){
		
			$comstr .= "<option value=\"".$value["comKey"]."\">".$value["comName"]."</option>";
		
		}
		$comstr .= "</select>";
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>添加/修改部件颜色</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=newcolor\" method=\"post\" id=\"colorForm\" enctype=\"multipart/form-data\">
            <input type=\"hidden\" id=\"selectType\" name=\"type\" />
            <input type=\"hidden\" id=\"selectCom\" name=\"com\" />
            <input type=\"hidden\" id=\"hexValue\" name=\"hex\" />
            <p><label for=\"textfield\"><strong>请选择型号:</strong></label>
                        ".$str."<br /><br />
                    	<label for=\"textfield\"><strong>请选择部件类型:</strong></label>
                        ".$comstr."<br /><br />
                        <label for=\"textfield\"><strong>请点击选择Pantone值:(如: 118C )</strong></label>
                        <input type=\"text\" id=\"colorField\" class=\"inputbox\" name=\"colorValue\" onclick=\"showBox()\" readonly /> <br /><br />
                        <input type=\"button\" value=\"关闭选择器\" id=\"closeBtn\" style=\"display:none\" onclick=\"closePicker()\" />
                        <div id=\"box\" style=\"display:none\"></div><br />
                        <input type=\"button\" value=\"添加\" class=\"btn\" onclick=\"checkValues()\" /></p>
            </form>
                        </div>
                        </div>";
	}
	function administratorList($id=null, $action="addAdmin")    //管理员列表面面
	{
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_admin");
		$db -> closeConnection();
		$str = "";
		$adminInfo = "<input type=\"hidden\" id=\"idInput\" />
            <p><label for=\"textfield\"><strong>请输入用户名:</strong></label>
                        <input type=\"text\" id=\"usernameTxt\" class=\"inputbox\" name=\"username\" /> <br /><br />
                        <label for=\"textfield\"><strong>请输入密码:</strong></label>
                        <input type=\"password\" id=\"passwordTxt\" class=\"inputbox\" name=\"password\" /> <br /><br />
                        <label for=\"textfield\"><strong>请输入真实姓名:</strong></label>
                        <input type=\"text\" id=\"realnameTxt\" class=\"inputbox\" name=\"realname\" /> <br /><br />";
		foreach($arr as $value){
		
			if($value["username"] != $_SESSION["admin"]){
			
				$lastLogin = "";
				if($value["lastLogin"] != ""){
				
					$obj = getdate($value["lastLogin"]);
					$mon = $obj["mon"] < 10 ? ("0".$obj["mon"]) : $obj["mon"];
					$day = $obj["mday"] < 10 ? ("0".$obj["mday"]) : $obj["mday"];
					$hour = $obj["hours"] < 10 ? ("0".$obj["hours"]) : $obj["hours"];
					$minutes = $obj["minutes"] < 10 ? ("0".$obj["minutes"]) : $obj["minutes"];
					$second = $obj["seconds"] < 10 ? ("0".$obj["seconds"]) : $obj["seconds"];
					$lastLogin = $obj["year"]."-".$mon."-".$day." ".$hour.":".$minutes.":".$second;
			
				}
				$str .= "<tr>
                        	<td>".$value["username"]."</td>
                            <td>".$value["realName"]."</td>
                            <td>".$lastLogin."</td>
                            <td>".$value["createTime"]."</td>
                            <td>
                            	<a href=\"index.php?page=adminlist&action=edit&id=".$value["id"]."\" title=\"\"><img src=\"img/icons/icon_edit.png\" alt=\"Edit\" /></a>
                                <a href=\"javascript:var bool=confirm('您确定删除此管理员?'); if(bool){window.location='query.php?action=delete&id=".$value["id"]."'}\" title=\"\"><img src=\"img/icons/icon_unapprove.png\" alt=\"Unapprove\" /></a>
                            </td>
                        </tr>";
			
			}
			if($id != null){
			
				if($value["id"] == $id){
				
					$adminInfo = "<input type=\"hidden\" id=\"idInput\" value=\"".$value["id"]."\" name=\"userID\" />
            <p><label for=\"textfield\"><strong>请输入用户名:</strong></label>
                        <input type=\"text\" id=\"usernameTxt\" class=\"inputbox\" name=\"username\" value=\"".$value["username"]."\" disabled /> <br /><br />
                        <label for=\"textfield\"><strong>请输入密码:</strong></label>
                        <input type=\"password\" id=\"passwordTxt\" class=\"inputbox\" name=\"password\" value=\"".$value["password"]."\" /> <br /><br />
                        <label for=\"textfield\"><strong>请输入真实姓名:</strong></label>
                        <input type=\"text\" id=\"realnameTxt\" class=\"inputbox\" name=\"realname\" value=\"".$value["realName"]."\" /> <br /><br />";
				
				}
			
			}
		
		}
		return "<div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>管理员列表</h2>
            </div>
            <div class=\"contentbox\">
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>管理员</th>
                            <th>姓名</th>
                            <th>最后登录时间</th>
                            <th>创建时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                    	".$str."
                    </tbody>
                </table>
                        </div>
                        </div>
                        <div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加/修改 管理员信息</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=".$action."\" method=\"post\">
            ".$adminInfo."
                        <input type=\"submit\" value=\"确认\" class=\"btn\" /></p>
                        </form>
                        </div>
                        </div>";
	}
	function orderViewPage()
	{
		$id = $_GET["id"];
		$page = $_GET["page"];
		$curPage = "";
		if($page == "curorderview"){
		
			$curPage = "modifycurorder";
		
		}else{
		
			$curPage = "modifyoldorder";
		
		}
		$db = new DBConnection();
		$addons = $db -> queryOrder("select addons from yjc_order where id=".$id);
		$addonsArr = null;
		if($addons && count($addons)){
		
			$addonsArr = explode(",", $addons[0]["addons"]);
		
		}
		$arr = $db -> queryOrder("select * from yjc_orderDetail where pid=".$id);
		$comArr = $db -> queryOrder("select * from yjc_comconfig");
		$str = "";
		$totalPrice = 0;
		foreach($arr as $value){
		
			$comName = "";
			foreach($comArr as $v){
			
				if($v["comKey"] == $value["comName"]){
				
					$comName = $v["comName"];
					break;
				
				}
			
			}
			$str .= "<tr>
                        	<td>".$comName."</td>
                            <td>".$value["comColor"]."</td>
                            <td>".$value["price"]."</td>
                        </tr>";
            $totalPrice = $totalPrice + $value["price"];
		
		}
		if($addonsArr){
		
			foreach($addonsArr as $va){
		
				if($va != ""){
				
					$ap = $db -> queryOrder("select typeOrName,price from yjc_addons where id='".$va."'");
				$str .= "<tr>
                        	<td>(配件)".$ap[0]["typeOrName"]."</td>
                            <td>"."无"."</td>
                            <td>".$ap[0]["price"]."</td>
                        </tr>";
           		$totalPrice = $totalPrice + $ap[0]["price"];
				
				}
		
			}
		
		}
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>订单详情</h2>
            </div>
            <div class=\"contentbox\">
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>部件名称</th>
                            <th>部件颜色(Pantone)</th>
                            <th>部件价格</th>
                        </tr>
                    </thead>
                    <tbody>
                    	".$str."
                    </tbody>
                </table>
                <br>
                <div style=\"color:#ff0000;float:right;padding-right:50px;\">总金额: ".$totalPrice."元</div>
                </div>
                        </div>
                        </div>";
                        //<div><a href=\"index.php?page=".$curPage."&id=".$id."\"><input type=\"button\" value=\"修改\" class=\"btn\"></a><div style=\"color:#ff0000;float:right;padding-right:50px;\">总金额: ".$totalPrice."元</div></div>
	}
	function modifyOrderPage()
	{
		return;
		$id = $_GET["id"];
		$page = $_GET["page"];
		$curPage = "";
		if($page == "curorderview"){
		
			$curPage = "modifycurorder";
		
		}else{
		
			$curPage = "modifyoldorder";
		
		}
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_orderDetail where pid=".$id);
		$comArr = $db -> queryOrder("select * from yjc_comconfig");
		$colorArr = $db -> queryOrder("select * from yjc_comcolor");
		$str = "";
		$totalPrice = 0;
		
		$tableStr = "";
		
		foreach($arr as $value){
		
			$comSelecter = "<select>";
			$colorSelecter = "<select>";
			$comName = "";
			
			foreach($colorArr as $vv){
				
				if($vv["component"] == $value["comName"]){
					
					if($vv["pantone"] == $value["comColor"]){
						
						$colorSelecter .= "<option value=\"".$vv["pantone"]."\" selected>".$vv["pantone"]."</option>";
						
					}else{
						
						$colorSelecter .= "<option value=\"".$vv["pantone"]."\">".$vv["pantone"]."</option>";
						
					}
					
				}
				
			}
			foreach($comArr as $v){
			
				if($v["comKey"] == $value["comName"]){
				
					$comSelecter .= "<option value=\"".$v["comKey"]."\" selected>".$v["comName"]."</option>";
				
				}else{
				
					$comSelecter .= "<option value=\"".$v["comKey"]."\">".$v["comName"]."</option>";
				
				}
			
			}
			$colorSelecter .= "</select>";
			$comSelecter .= "</select>";
			$str .= "<tr>
                        	<td>".$comSelecter."</td>
                            <td>".$colorSelecter."</td>
                            <td>".$value["price"]."</td>
                            <td>".$value["operater"]."</td>
                            <td>".$value["lastModify"]."</td>
                        </tr>";
            $totalPrice = $totalPrice + $value["price"];
		
		}
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>订单详情</h2>
            </div>
            <div class=\"contentbox\">
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>部件名称</th>
                            <th>部件颜色(Pantone)</th>
                            <th>部件价格</th>
                            <th>最后修改人</th>
                            <th>最后修改时间</th>
                        </tr>
                    </thead>
                    <tbody>
                    	".$str."
                    </tbody>
                </table>
                <br>
                <div><a href=\"index.php?page=".$curPage."&id=".$id."\"><input type=\"button\" value=\"确认修改\" onclick=\"test()\" class=\"btn\"></a><div style=\"color:#ff0000;float:right;padding-right:50px;\">总金额: ".$totalPrice."元</div></div>
                </div>
                        </div>
                        </div>";
	}
	function addOnsPage()
	{
		if(isset($_GET["action"])){
		
			if($_GET["action"] == "modify"){
		
				return $this -> modifyAddons();
		
			}
		
		}
		$db = new DBConnection();
		$arr = $db -> queryOrder("select id, type from yjc_type order by id asc");
		$str = "<select id = \"typeSelector\">";
		foreach($arr as $value){
		
			$str .= "<option value=\"".$value["id"]."\">".$value["type"]."</option>";
		
		}
		$str .= "</select>";
		return "<div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加/修改配件</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=addAddons\" method=\"post\" enctype=\"multipart/form-data\" id=\"addonForm\">
            <input type=\"hidden\" id=\"type\" name=\"type\" />
            <p><label for=\"textfield\"><strong>请选择车型:</strong></label>
            ".$str."<br /><br />
            <label for=\"textfield\"><strong>请输入配件名称/型号:</strong></label>
                        <input type=\"text\" id=\"addonName\" class=\"inputbox\" name=\"addonName\" /> <br /><br />
                        <label for=\"textfield\"><strong>请输入配件价格:</strong></label>
                        <input type=\"text\" id=\"addonPrice\" class=\"inputbox\" name=\"addonPrice\" /> <br /><br />
                        <label for=\"textfield\"><strong>请上传配件图片文件:</strong></label>
                        <input type=\"file\" id=\"uploader\" name=\"addOnFile\" /><br /><br /><input type=\"button\" value=\"确定\" class=\"btn\" onclick=\"submitAddon(null)\"></div></div>";
	}
	function modifyAddons()
	{
		$id = $_GET["id"];
		$db = new DBConnection();
		$arr = $db -> queryOrder("select * from yjc_type order by id asc");
		$addon = $db -> queryOrder("select * from yjc_addons where id=".$id);
		$str = "<select id = \"typeSelector\">";
		foreach($arr as $value){
		
			if($value["id"] == $addon[0]["type"]){
			
				$str .= "<option value=\"".$value["id"]."\" selected>".$value["type"]."</option>";
			
			}else{
			
				$str .= "<option value=\"".$value["id"]."\">".$value["type"]."</option>";
			
			}
		
		}
		$str .= "</select>";
		return "<div class=\"contentcontainer med left\">
            <div class=\"headings alt\">
                <h2>添加/修改配件</h2>
            </div>
            <div class=\"contentbox\">
            <form action=\"query.php?action=modifyAddons\" method=\"post\" enctype=\"multipart/form-data\" id=\"addonForm\">
            <input type=\"hidden\" id=\"addonID\" name=\"addonID\" value=\"".$id."\" />
            <input type=\"hidden\" id=\"type\" name=\"type\" />
            <p><label for=\"textfield\"><strong>请选择车型:</strong></label>
            ".$str."<br /><br />
            <label for=\"textfield\"><strong>请输入配件名称/型号:</strong></label>
                        <input type=\"text\" id=\"addonName\" class=\"inputbox\" name=\"addonName\" value=\"".$addon[0]["typeOrName"]."\" /> <br /><br />
                        <label for=\"textfield\"><strong>请输入配件价格:</strong></label>
                        <input type=\"text\" id=\"addonPrice\" class=\"inputbox\" name=\"addonPrice\" value=\"".str_replace("#", ".", $addon[0]["price"])."\" /> <br /><br />
                        <label for=\"textfield\"><strong>请上传配件图片文件:</strong></label>
                        <input type=\"file\" id=\"uploader\" name=\"addOnFile\" /> 不修改则无需选择文件!<br /><br /><input type=\"button\" value=\"确认修改\" class=\"btn\" onclick=\"submitAddon('modify')\"></form></div></div>";
	}
	function addonsViewPage()
	{
		$db = new DBConnection();
		$types = $db -> queryOrder("select * from yjc_type order by id asc");
		$str = "";
		$typeSelect = "";
		if(!$types || !count($types)){
		
			
		
		}else{
		
			$details = $db -> queryOrder("select * from yjc_addons where type='".$types[0]["id"]."'");
		$typeSelect = "<select id=\"typeSelecter\" onchange=\"changeAddonsByType()\">";
		if(count($types)){
		
			foreach($types as $v){
			
				$typeSelect .= "<option value=\"".$v["id"]."\">".$v["type"]."</option>";
			
			}
			$typeSelect .= "</select>";
		
		}
		foreach($details as $value){
		
			$typeName = "";
			foreach($types as $vvv){
			
				if($vvv["id"] == $value["type"]){
				
					$typeName = $vvv["type"];
					break;
				
				}
			
			}
			$str .= "<tr>
                    <td>".$typeName."</td>
                    <td>".$value["typeOrName"]."</td>
                    <td>".str_replace("#", ".", $value["price"])."</td>
                    <td>".$value["operater"]."</td>
                    <td>".$value["createTime"]."</td>
                    <td><a href=\"index.php?page=addons&action=modify&id=".$value["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a>
                    <a href=\"javascript:deleteAddon(".$value["id"].")\"><img src=\"img/icons/icon_unapprove.png\" title=\"删除\" alt=\"删除\" /></a></td>
                    </tr>";
		
		}
		
		}
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>查看车型以及款式</h2>
            </div>
            <div class=\"contentbox\">
            <div style=\"height:40px;\">
            ".$typeSelect."
            </div>
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>车型</th>
                            <th>配件名称/型号</th>
                            <th>配件价格(人民币: 元)</th>
                            <th>最后修改人</th>
                            <th>最后修改时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id=\"typeTable\">
                    	".$str."
                    </tbody>
                </table>
                        </div>
                        </div>";
	}
	function comColorViewPage($cp = 1, $tp = 0, $curType="")
	{
		$db = new DBConnection();
		$types = $db -> queryOrder("select * from yjc_type order by id asc");
		$str = "";
		$typeSelect = "";
		$curTypeStr = "";
		if(!$types || !count($types)){
		
		}else{
		
			//$curTypeStr = $types[0]["type"];
			$comconfig = $db -> queryOrder("select * from yjc_comconfig");
			if($curType == ""){
		
			$curType = $types[0]["id"];
		
		}
		$pages = $db -> queryOrder("select count(*) from yjc_comcolor where type='".$curType."'");
		$num = $pages[0][0];
		$totalPage = ceil($num / 10);
		$pageList = "<li><select id=\"pageSelecter\" onchange=\"flipComColorPage(".$curType.",".$totalPage.")\">";
		for($ii = 0; $ii < $totalPage; $ii++){
		
			if(($ii + 1) == $cp){
			
				$pageList .= "<option value=\"".($ii + 1)."\" selected>第".($ii + 1)."页</option>";
			
			}else{
			
				$pageList .= "<option value=\"".($ii + 1)."\">第".($ii + 1)."页</option>";
			
			}
		
		}
		$pageList .= "</select></li>";
		$typeSelect = "<select id=\"typeSelecter\" onchange=\"changeComColorList()\">";
		if(count($types)){
		
			foreach($types as $v){
			
				$typeSelect .= "<option value=\"".$v["id"]."\">".$v["type"]."</option>";
			
			}
			$typeSelect .= "</select>";
		
		}
		$details = $db -> queryOrder("select * from yjc_comcolor where type='".$curType."' order by id desc limit ".(($cp-1)*10).", 10");
		foreach($details as $value){
		
			$comName = "";
			foreach($comconfig as $vv){
			
				if($vv["comKey"] == $value["component"]){
				
					$comName = $vv["comName"];
					break;
				
				}
			
			}
			$typeText = "";
			foreach($types as $vvv){
			
				if($vvv["id"] == $value["type"]){
				
					$typeText = $vvv["type"];
				
				}
			
			}
			$str .= "<tr>
                        	<td>".$typeText."</td>
                            <td>".$comName."</td>
                            <td>".$value["colorValue"]."</td>
                            <td>".$value["pantone"]."</td>
                            <td><a href=\"index.php?page=color&action=modify&id=".$value["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a> <a href=\"query.php?page=color&action=deleteColor&id=".$value["id"]."\"><img src=\"img/icons/icon_unapprove.png\" alt=\"删除\" title=\"删除\" /></a></td>
                        </tr>";
		
		}
		
		}
		
		
		$nextPage = $cp + 1;
		if($nextPage > $totalPage){
		
			$nextPage = "#";
		
		}
		$prePage = $cp - 1;
		if($prePage < 1){
		
			$prePage = "#";
		
		}
		
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>查看部件颜色</h2>
            </div>
            <div class=\"contentbox\">
            <div style=\"height:40px;\">
            ".$typeSelect."
            </div>
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>车型</th>
                            <th>所属部件</th>
                            <th>部件色值</th>
                            <th>部件Pantone值</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id=\"typeTable\">
                    	".$str."
                    </tbody>
                </table>
                <div style=\"height:20px;padding-top:20px;\">
                        <ul class=\"pagination\" id=\"pagenavigator\">
                	<li class=\"text\"><a href=\"index.php?page=comColor&num=".$prePage."&total=".$totalPage."\" title=\"\">上一页</a></li>
                    ".$pageList."
                    <li class=\"text\"><a href=\"index.php?page=comColor&num=".$nextPage."&total=".$totalPage."\" title=\"\">下一页</a></li>
                    <li class=\"text\"> 共 </li>
                    <li class=\"text\" id=\"totalPageNum\">".$totalPage."</li>
                    <li class=\"text\"> 页 </li>
                </ul>
                <div style=\"clear: both;\"></div>
                </div>
                        </div>
                        </div>";
	}
	function typeViewPage()
	{
		$db = new DBConnection();
		$types = $db -> queryOrder("select * from yjc_type order by id asc");
		$str = "";
		$typeSelect = "";
		$curTypeStr = "";
		if(!$types || !count($types)){
		
		}else{
		
		foreach($types as $v){
		
			$str .= "<tr>
                        	<td>".$v["type"]."</td>
                            <td><a href=\"index.php?page=type&action=modify&id=".$v["id"]."\"><img src=\"img/icons/icon_edit.png\" alt=\"编辑\" title=\"编辑\" /></a></td>
                        </tr>";
		
		}
		
		}
		return "<div class=\"contentcontainer med left\" style=\"width:100%\">
            <div class=\"headings alt\">
                <h2>查看车型</h2>
            </div>
            <div class=\"contentbox\">
            <table width=\"100%\">
                	<thead>
                    	<tr>
                        	<th>车型型号</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id=\"typeTable\">
                    	".$str."
                    </tbody>
                </table>
                        </div>
                        </div>";
	}
}
?>
