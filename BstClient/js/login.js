var gui = require("nw.gui");
var win = gui.Window.get();
var baseWindow;
var startPosX, startPosY;
var ladda;

$("#closeBtn").on("mousedown", function(event){
	event.stopPropagation();
});

$("#closeBtn").on("mouseup", function(){
	win.close();
});

$("#dragZone").on("mousedown", function(event){
	startPosX = event.pageX;
	startPosY = event.pageY;
	$("#dragZone").css("cursor", "pointer");

	$(document).on("mousemove", function(event){
		var offsetX = event.pageX - startPosX;
		var offsetY = event.pageY - startPosY;
		win.moveBy(offsetX, offsetY);
	});
});

$(document).on("mouseup", function(event){
	$(document).off("mousemove");
	$("#dragZone").css("cursor", "default");
});

$(window).on("keydown", function(event){
	if(event.keyCode == 13){
		$("#submitBtn").trigger("click");
	}
});

$("#submitBtn").on("click", function(){
	var username = $("#username").val();
	var password = $("#password").val();
	if(username == "" || password == ""){
		alert("用户名或密码不能为空!");
		return;
	}
	$("#username").attr("readonly", "readonly");
	$("#password").attr("readonly", "readonly");
	$("#autoLogin").attr("disabled", "disabled");
	ladda = Ladda.create(this);
	ladda.start();
	$.scojs_message('正在连接服务器......', $.scojs_message.TYPE_OK);
	baseWindow.doLogin(username, password);
});

function loginFailed(msg){
	$.scojs_message(msg, $.scojs_message.TYPE_ERROR);
	$("#username").removeAttr("readonly");
	$("#password").removeAttr("readonly");
	$("#autoLogin").removeAttr("disabled");
	ladda.stop();
}

function loginSuccess(){
	var username = $("#username").val();
	var password = $("#password").val();
	if($("#autoLogin").is(":checked")){
		localStorage.un = username;
		localStorage.pw = password;
		localStorage.auto = true;
	}else{
		localStorage.auto = false;
	}
	ladda.stop();
}

$("a").on("dragstart", function(event){
	return false;
});

$("img").on("dragstart", function(event){
	return false;
});

function checkAutoLogin(){
	if(localStorage.auto){
		$("#autoLogin").attr("checked", "checked");
		$("#username").val(localStorage.un);
		$("#password").val(localStorage.pw);
		$("#submitBtn").trigger("click");
	}
}

$(document).ready(function(){
	setTimeout(checkAutoLogin, 500);
});