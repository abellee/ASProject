var gui = require("nw.gui");
var win = gui.Window.get();
// win.showDevTools('', false);

var tray = new gui.Tray({title: gui.App.manifest.name, icon: "img/tray.png"});
var menu = new gui.Menu();
var logout = new gui.MenuItem({label: '注销'});
var exit = new gui.MenuItem({label: '退出'});
menu.append(logout);
menu.append(exit);
tray.menu = menu;
logout.on("click", function(){
	localStorage.removeItem("auto");
	disconnect();
});
exit.on("click", function(){
	gui.App.quit();
});

var flash;
var user = {};
var soundNode;
var messageList = {};
var login;
var chat;

tray.on("click", function(){
	chat.show();
	chat.focus();
});

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

function setServiceData(data){
	user.data = data;
}

function cacheHistory(message){
	if(!messageList[message.jid]){
		messageList[message.jid] = {
			name: message.name,
			jid: message.jid,
			company: message.company,
			pos: message.pos,
			branch: message.branch,
			history: []
		};
	}
	messageList[message.jid].history.push(message);
}


//for flash api

function onDisconnect(){
	chat.window.onDisconnect();
}

function onLogin(){
	login.window.loginSuccess();
	openChatWindow();
}

function onIncoming(data){
	console.log(data);
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
	cacheHistory(message);
	chat.window.onMessage(message);
}


//for js api
function doLogin(un, pw){
	user.un = un;
	user.pw = pw;
	flash.connect(un, pw);
}

function relogin(){
	doLogin(user.un, user.pw);
}

function disconnect(){
	flash.disconnect();
	closeAllWindow();
	win.reloadIgnoringCache();
}

function sendMessage(to, content){
	cacheHistory(content);
	flash.sendMessage(to, encodeURIComponent(JSON.stringify(content)));
}