var gui = require("nw.gui");
var win = gui.Window.get();
var fs = require("fs");
var path = require("path");
var flashTrust = require('nw-flash-trust');
// win.showDevTools('', false);

var appName = "aibest";

var filename = global.module.filename;
var arr = filename.split("/");
arr.pop();
var appDir = arr.join("\\");
try {
    var trustManager = flashTrust.initSync(appName);
    var isTrusted = trustManager.isTrusted(path.resolve(appDir, ''));
    if(!isTrusted){
    	trustManager.add(path.resolve(appDir, ''));
    }
} catch(err) {
    if (err.message === 'Flash Player config folder not found.') {
    }
}

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
	exitApp();
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

$(document).ready(function(){
	if(!fs.existsSync("cache")){
		fs.mkdirSync("cache", 0777);
	}
	openLoginWindow();
	flash = document["xmppLib"];
});

function openLoginWindow(){
	login = gui.Window.open('windows/login.html', {
		"position": 'center',
		"width": 350,
		"height": 485,
		"resizable": false,
		"icon": "img/icon.png",
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
		"icon": "img/icon.png",
		"toolbar": false,
		"frame": false,
		"transparent": true,
		"fullscreen": false,
		"show": false,
		"resizable": false
	});
	chat.on("loaded", initChat);
}

function exitApp(){
	if(!fs.existsSync("cache")){
		fs.mkdirSync("cache", 0777);
	}
	if(user.un){
		fs.open("cache/cache_" + user.un + ".json", "w", 0777, function(e, fd){
			fs.write(fd, JSON.stringify(messageList), 0, 'utf8', function(e){
				fs.closeSync(fd);
				gui.App.quit();
			});
		});
	}else{
		gui.App.quit();
	}
}

function initChat(){
	chat.removeAllListeners();
	chat.show();
	chat.focus();
	chat.window.baseWindow = window;
	chat.on("focus", chatOnFocus);
	chat.on("blur", chatOnBlur);

	if(messageList){
		for(var k in messageList){
			chat.window.newClient(messageList[k]);
		}
	}
}

function chatOnFocus(msg){
	console.log(msg);
}

function chatOnBlur(){
}

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
			unread: 0,
			history: []
		};
	}
	messageList[message.jid].history.push(message);
	messageList[message.jid].unread += 1;
	if(chat){
		chat.window.newClient(messageList[message.jid]);
	}
}

function clearUnread(jid){
	if(messageList[jid]){
		messageList[jid].unread = 0;
	}
}

function getMessageHistory(jid){
	if(messageList[jid]){
		return messageList[jid].history;
	}
	return null;
}


//for flash api

function onDisconnect(){
	chat.window.onDisconnect();
}

function onLogin(){
	console.log("onLogin", user.un);
	if(user.un){
		if(fs.existsSync("cache/cache_" + user.un + ".json")){
			var file = fs.readFileSync("cache/cache_" + user.un + ".json", "utf8")
			messageList = JSON.parse(file);
		}
	}
	login.window.loginSuccess();
	openChatWindow();
}

function onIncoming(data){
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
	console.log(un, pw);
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