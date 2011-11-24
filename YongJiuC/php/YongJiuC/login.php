<?php
require_once("classes/securityAbout.php");
$securityAbout = new SecurityAbout();
$securityAbout -> checkSessionIsValid("login");
if(isset($_POST["username"]) && isset($_POST["password"]))
{
	if($_POST["username"] == "" || $_POST["password"] == ""){
	
		echo "<script>alert(\"用户名或者密码不能为空!\");</script>";
	
	}else{
	
		$bool = $securityAbout -> checkIsAdmin($_POST["username"], $_POST["password"]);
		if($bool){
	
			echo "<script>window.location=\"index.php?page=curorder\";</script>";
	
		}else{
	
			echo "<script>alert(\"用户名不存在或者密码不正确!\");</script>";
	
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
<link href="styles/login.css" rel="stylesheet" type="text/css" />
<!-- Theme Start -->
<link href="themes/blue/styles.css" rel="stylesheet" type="text/css" />
<!-- Theme End -->
</head>

<body>
	<div id="logincontainer">
    	<div id="loginbox">
        	<div id="loginheader">
            	<img src="themes/blue/img/cp_logo_login.png" alt="Control Panel Login" />
            </div>
            <div id="innerlogin">
            	<form action="login.php" method="post">
                	<p>Enter your username:</p>
                	<input type="text" class="logininput" name="username" />
                    <p>Enter your password:</p>
                	<input type="password" class="logininput" name="password" />
                   	<input type="submit" class="loginbtn" value="Submit" /><br />
                </form>
            </div>
        </div>
        <img src="img/login_fade.png" alt="Fade" />
    </div>
</body>
</html>