var gui = require("nw.gui");
var baseWindow;
var win = gui.Window.get();

template.helper("truncName", truncName);

function truncName(full){
	if(full.length > 4){
		return full.substring(0, 3) + "...";
	}
	return full;
}

$(".panel-title").text(gui.App.manifest.name);

var startPosX, startPosY;

// win.showDevTools("", false);

$("#closeBtn").on("mousedown", function(event){
	event.stopPropagation();
});

$("#closeBtn").on("mouseup", function(){
	if(localStorage.exitType == "true"){
		if(localStorage.isexit == "true"){
			baseWindow.exitApp();
		}else if(localStorage.hide == "true"){
			win.hide();
		}
		return;
	}
	var modal = $.scojs_confirm({
		content: '<label class="radio-inline"><input type="radio" name="exitType" id="quitRadio">退出程序</label><label class="radio-inline"><input type="radio" name="exitType" id="hideRadio">隐藏至任务栏</label>',
		cssClass: 'system-font modal-class',
		action: function(){
			if($("#quitRadio").is(":checked")){
				localStorage.exitType = true;
				localStorage.isexit = true;
				localStorage.hide = false;
				baseWindow.exitApp();
			}else if($("#hideRadio").is(":checked")){
				localStorage.exitType = true;
				localStorage.hide = true;
				localStorage.isexit = false;
				win.hide();
			}
		}
	});
	modal.show();
});

$("a").on("dragstart", function(event){
	return false;
});

$("img").on("dragstart", function(event){
	return false;
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

function onDisconnect(){
	var modal = $.scojs_modal({
		content: '<i class="glyphicon glyphicon-repeat refresh-motion" style="font-size:30px;"></i>',
		title: '正在重新连接...',
		cssClass: 'system-font modal-class',
		onClose: function(){
			baseWindow.disconnect();
		}
	});
	modal.show();
	baseWindow.relogin();
}

$("#sendBtn").on("click", function(event){
	var txt = $("#textArea").val();
	if(txt == ""){
		return;
	}

	var time = "";
	var curDate = new Date();
	var monthInt = curDate.getMonth() + 1;
	var monthStr = monthInt < 10 ? "0" + monthInt : monthInt + "";
	var dateInt = curDate.getDate();
	var dateStr = dateInt < 10 ? "0" + dateInt : dateInt + "";
	var hourInt = curDate.getHours();
	var hourStr = hourInt < 10 ? "0" + hourInt : hourInt + "";
	var minuteInt = curDate.getMinutes();
	var minuteStr = minuteInt < 10 ? "0" + minuteInt : minuteInt + "";
	var secondInt = curDate.getSeconds();
	var secondStr = secondInt < 10 ? "0" + secondInt : secondInt + "";
	time = curDate.getFullYear() + "-" + monthStr + "-" + dateStr + " " + hourStr + ":" + minuteStr + ":" + secondStr;

	$("#textArea").val("");
	var html = template("chatTemp", {name: "百斯特客服", self: 1, msg: txt, company: "", pos: "", time: time, type: "text"});
	$("#chatList").append(html);
	scrollToBottom();

	var cur = $('#tabList li[class="active"]');
	var acc = cur.attr("jid");
	var arr = acc.split("@");
	baseWindow.sendMessage(arr[0], {name: "百斯特客服", self: 0, msg: txt , company: "", pos: "", jid: acc, branch: "", t: time, tn: curDate.getTime(), type: "text"});
});

$("#textArea").on("keydown", function(event){
	if(event.keyCode == 13){
		$("#sendBtn").trigger("click");
		event.preventDefault();
		return false;
	}
});

function onMessage(message){
	var exist = $('#tabList li[jid="' + message.jid + '"]');
	if(exist[0] && exist.hasClass("active")){
		var html = template("chatTemp", {name: message.name, self: 0, msg: message.msg, company: message.company, pos: message.pos, time: message.t, branch: message.branch, type: message.type});
		baseWindow.clearUnread(message.jid);
		$("#chatList").append(html);
		scrollToBottom();
	}
}

function scrollToBottom(){
	$("#chatList").scrollTop($("#chatList")[0].scrollHeight);
}

function newClient(data){
	var exist = $('#tabList li[jid="' + data.jid + '"]');
	if(!exist[0]){
		var html = template("clientTab", data);
		$("#tabList").append(html);
		$("#tabList li").on("click", clientTabClicked);
	}else{
		var badgeNode = exist.children("a").children("span");
		if(!exist.hasClass("active")){
			if(badgeNode[0]){
				badgeNode.text(data.unread);
			}else{
				exist.children("a").append(template("badgeTemp", data));
			}
		}
	}
}

function clientTabClicked(event){
	var node = $(event.currentTarget);
	if(!node.hasClass("active")){
		$("#textArea").val("");
		$("#chatList").empty();
		node.siblings().removeClass("active");
		node.addClass("active");
		var badgeNode = node.children("a").children("span");
		if(badgeNode[0]){
			badgeNode.remove();
		}
		baseWindow.clearUnread(node.attr("jid"));
		$("#textArea").removeAttr("readonly");
		var arr = baseWindow.getMessageHistory(node.attr("jid"));
		if(arr && arr.length){
			arr.forEach(function(msg){
				onMessage(msg);
			});
		}
	}
}

function resetChat(){
	$("#textArea").val("");
	$("#textArea").attr("readonly", "readonly");
	$("#chatList").empty();
}
resetChat();