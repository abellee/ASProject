var gui = require("nw.gui");
var baseWindow;
var win = gui.Window.get();

var startPosX, startPosY;
win.showDevTools("", false);
$("#closeBtn").on("mousedown", function(event){
	event.stopPropagation();
});

$("#closeBtn").on("mouseup", function(){
	if(localStorage.exitType){
		if(localStorage.isexit){
			gui.App.quit();
		}else if(localStorage.hide){
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
				gui.App.quit();
				localStorage.isexit = true;
				localStorage.hide = false;
			}else if($("#hideRadio").is(":checked")){
				localStorage.exitType = true;
				win.hide();
				localStorage.hide = true;
				localStorage.isexit = false;
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

function confirmCloseType(){

}

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