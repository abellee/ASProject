var mode = "develop";
var flash;
var curUsername;
var userPassword;

var soundNode;

var messageList = {};

var gui = require("nw.gui");
// var needle = require("needle");
var win = gui.Window.get();
win.showDevTools('', false);

var login;
var chat;

function openLoginWindow(){
	login = gui.Window.open('windows/login.html', {
		"position": 'center',
		"width": 350,
		"height": 485,
		"resizable": false,
		"toolbar": false,
		"frame": false,
		"transparent": true,
		"fullscreen": false,
		"show": false
	});

	login.on("loaded", initLogin);
	login.on("close", exitApp);
}

function initLogin(){
	login.setTransparent(true);
	login.show();
	login.window.baseWindow = window;
}

function exitApp(){
	gui.App.quit();
}

function openChatWindow(){
	if(login){
		login.removeAllListeners();
		login.close();
		login = null;
	}
	chat = gui.Window.open('windows/chat.html', {
		"position": 'center',
		"width": 800,
		"height": 600,
		"toolbar": false,
		"frame": false,
		"transparent": true,
		"fullscreen": false,
		"show": false,
		"resizable": false
	});
	chat.on("loaded", initChat);
}

function initChat(){
	chat.removeAllListeners();
	chat.show();
	chat.focus();
	chat.window.baseWindow = window;
	chat.on("focus", chatOnFocus);
	chat.on("blur", chatOnBlur);
}

function chatOnFocus(){
	console.log("focus");
}

function chatOnBlur(){
	console.log("blur");
}

$(document).ready(function(){
	openLoginWindow();
	flash = document["xmppLib"];
});

function closeAllWindow(){
	if(chat){
		chat.removeAllListeners();
		chat.close();
		chat = null;
	}
	if(login){
		login.removeAllListeners();
		login.close();
		login = null;
	}
}


//for flash api
function onConnectSuccess(){
	
}

function onDisconnect(){
	chat.window.onDisconnect();
}

function onLogin(){
	login.window.loginSuccess();
	openChatWindow();
}

function onError(info){
	switch(info.errorCode){
		case 401:
			login.window.loginFailed("用户名或密码不正确!");
		break;
	}
}

function onMessage(message){
	if(!soundNode){
		soundNode = new Audio();
		soundNode.src = "info.ogg";
		soundNode.volumn = 1;
	}
	soundNode.play();
}


//for js api
function doLogin(un, pw){
	curUsername = un;
	curPassword = pw;
	flash.connect(un, pw);
}

function relogin(){
	doLogin(curUsername, curPassword);
}

function disconnect(){
	flash.disconnect();
	closeAllWindow();
	win.reloadIgnoringCache();
}