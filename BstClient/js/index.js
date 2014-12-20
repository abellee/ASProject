var gui = require("nw.gui");
var needle = require("needle");
var fs = require("fs");
var xlsx = require('node-xlsx');
var md5 = require('md5');
var imageinfo = require('crafity-imageinfo');

var win = gui.Window.get();
var devWin = win.showDevTools('', false);
var screenW = screen.availWidth - 300;
var screenH = screen.availHeight;
devWin.width = 300;
devWin.height = screenH;
win.width = screenW;
win.height = screenH;
win.x = screen.availLeft;
win.y = screen.availTop;
devWin.x = win.x + win.width + 5;
devWin.y = win.y;

var xlsxData;
var customType;
var styleType;
var partType;
var brandData;
var zheType = ["无褶", "单褶", "双褶"];
var curIndex = 1;

var styleXlsxData;
var styleIdList = [];
var partDataBySid = {};

var fabricXlsxData;

var baseURL = "http://yun.hanloon.com/";

template.helper("merge_parts", mergeParts);
template.helper("is_undefined", isUndefined);

function isUndefined(data){
	if (!data) {
		return "";
	};
	return data.value;
}

function mergeParts(data){
	var str = "";
	if(data.length > 8){
		for(var i = 8; i<data.length; i++){
			if(i == data.length - 1){
				str += data[i].value;
			}else{
				str += data[i].value + ",";
			}
		}
	}
	str = str.replace(/\s+/g, '');
	if(str == "") str = "部件组";
	return str;
}

win.on("document-end", function(){
	win.show();

	needle.get(baseURL + 'api/partcates/?type=2&iDisplayLength=1000&iDisplayStart=0&sEcho=1', function(err, res, body){
		customType = body.aaData;
	});

	needle.get(baseURL + 'api/partcates/?type=1&iDisplayLength=1000&iDisplayStart=0&sEcho=1', function(err, res, body){
		styleType = body.aaData;
	});

	needle.get(baseURL + 'api/partcates/?type=0&iDisplayLength=1000&iDisplayStart=0&sEcho=1', function(err, res, body){
		partType = body.aaData;
	});

	needle.get(baseURL + 'api/BrandsTablelist/?iDisplayLength=1000&iDisplayStart=0&sEcho=1', function(err, res, body){
		brandData = body.aaData;
	});

	var excelBtn = document.querySelector("#excelBtn");
	excelBtn.addEventListener("click", excelBtn_clickHandler);

	var folderBtn = document.querySelector("#folderBtn");
	folderBtn.addEventListener("click", folderBtn_clickHandler);

	var excelChooser = document.querySelector("#excelChoose");
	excelChooser.onchange = excelChooser_changeHandler;

	var dirChooser = document.querySelector("#dirChoose");
	dirChooser.onchange = dirChooser_changeHandler;

	var styleBtn = document.querySelector("#styleBtn");
	var styleFolder = document.querySelector("#styleFolder");
	var styleChoose = document.querySelector("#styleChoose");
	var styleDirChoose = document.querySelector("#styleDirChoose");
	styleBtn.addEventListener("click", styleBtn_clickHandler);
	styleFolder.addEventListener("click", styleFolder_clickHandler);
	styleChoose.onchange = styleChoose_changeHandler;
	styleDirChoose.onchange = styleDirChoose_changeHandler;

	var fabricBtn = document.querySelector("#fabricBtn");
	var fabricFolder = document.querySelector("#fabricFolder");
	var fabricChoose = document.querySelector("#fabricChoose");
	var fabricDirChoose = document.querySelector("#fabricDirChoose");
	fabricBtn.addEventListener("click", fabricBtn_clickHandler);
	fabricFolder.addEventListener("click", fabricFolder_clickHandler);
	fabricChoose.onchange = fabricChoose_changeHandler;
	fabricDirChoose.onchange = fabricDirChoose_changeHandler;

	$("#uploadBtn").click(uploadBtn_clickHandler);
});

function fabricBtn_clickHandler(){
	var event = document.createEvent('MouseEvents');
    event.initMouseEvent('click');
	document.querySelector("#fabricChoose").dispatchEvent(event);
}

function fabricFolder_clickHandler(){
	var event = document.createEvent('MouseEvents');
    event.initMouseEvent('click');
	document.querySelector("#fabricDirChoose").dispatchEvent(event);
}

function fabricChoose_changeHandler(){
	var fabricChoose = document.querySelector("#fabricChoose");
	var fabricFile = document.querySelector("#fabricFile");
	fabricFile.innerHTML = fabricChoose.value;

	var obj = xlsx.parse(fabricChoose.value);

	fabricXlsxData = obj.worksheets[0];
	var html = template.render("fabricTmpl", fabricXlsxData);
	$("#fabricData").html(html);
}

function fabricDirChoose_changeHandler(){
	var fabricDirChoose = document.querySelector("#fabricDirChoose");
	var fabricDir = document.querySelector("#fabricDir");
	fabricDir.innerHTML = fabricDirChoose.value;
}

function styleBtn_clickHandler(){
	var event = document.createEvent('MouseEvents');
    event.initMouseEvent('click');
	document.querySelector("#styleChoose").dispatchEvent(event);
}

function styleFolder_clickHandler(){
	var event = document.createEvent('MouseEvents');
    event.initMouseEvent('click');
	document.querySelector("#styleDirChoose").dispatchEvent(event);
}

function styleChoose_changeHandler(){
	var styleChoose = document.querySelector("#styleChoose");
	var styleFile = document.querySelector("#styleFile");
	styleFile.innerHTML = styleChoose.value;

	var obj = xlsx.parse(styleChoose.value);

	styleXlsxData = obj.worksheets[0];
	var html = template.render("styleTmpl", styleXlsxData);
	$("#styleData").html(html);
}

function styleDirChoose_changeHandler(){
	var styleDirChoose = document.querySelector("#styleDirChoose");
	var styleDir = document.querySelector("#styleDir");
	styleDir.innerHTML = styleDirChoose.value;
}

function uploadBtn_clickHandler(){
	if(xlsxData && xlsxData.data.length){
		uploadPart();
	}else if(styleXlsxData && styleXlsxData.data.length){
		uploadStyle();
	}else if(fabricXlsxData && fabricXlsxData.data.length){
		uploadFabric();
	}
}

function uploadFabric(){
	if(!fabricXlsxData || !fabricXlsxData.data.length){
		return;
	}
	var partName = encodeURIComponent(fabricXlsxData.data[curIndex][0].value);
	var partPrice = isUndefined(fabricXlsxData.data[curIndex][1]);
	var ele = isUndefined(fabricXlsxData.data[curIndex][2]);
	var sz = isUndefined(fabricXlsxData.data[curIndex][3]);
	var brandStr = isUndefined(fabricXlsxData.data[curIndex][4]).toLowerCase();
	if (brandStr == "") {
		brandStr = "恒龙云定制";
	};
	var brandId = getBrandId(brandStr);

	var imgFolder = $("#fabricChoose").val();
	var imgPath = $("#fabricDirChoose").val() + "/" + fabricXlsxData.data[curIndex][5].value;

	var isShirt = fabricXlsxData.data[curIndex][6].value == "是" ? 1 : 0;
	imageinfo.readInfoFromFile(imgPath, function (err, data) {
		if (err) { return console.error(err); }
		var type = "image/png";
		var imgType = data.format.toLowerCase();
		if(imgType == "jpg" || imgType == "jpeg"){
			type = "image/jpeg";
		}else if(imgType == "png"){
			type = "image/png";
		}else{
			return console.error("image must be jpg or png!");
		}

		var info = {
	    	pp: partPrice,
	    	pn: partName,
	    	brandList: brandId,
	    	elementList: encodeURIComponent(ele),
	    	szList: encodeURIComponent(sz),
	    	isShirt: isShirt,
			partImage: {file: imgPath, content_type: type}
		};

		showFloatInfo("正在上传第" + curIndex + "块面料...");
		needle.post(baseURL + "allfabric/upload/", info, {multipart:true}, function(err, res, body){
			curIndex++;
			if(curIndex >= fabricXlsxData.data.length){
				showFloatInfo("面料上传完成");
				hideFloat();
			}else{
				uploadFabric();
			}
		});
	});
}

function uploadPart(){
	var partName = encodeURIComponent(xlsxData.data[curIndex][0].value);
	var partPrice = xlsxData.data[curIndex][1].value;
	var customId = getCustomId(xlsxData.data[curIndex][2].value);
	var styleId = getStyleId(customId, xlsxData.data[curIndex][3].value);
	var partId = getPartId(styleId, xlsxData.data[curIndex][4].value);
	var brandId = getBrandId(xlsxData.data[curIndex][5].value);
	var zhe = zheType.indexOf(isUndefined(xlsxData.data[curIndex][6]));

	var imgFolder = $("#dirChoose").val();
	var imgPath = $("#dirChoose").val() + "/" + xlsxData.data[curIndex][7].value;
	imageinfo.readInfoFromFile(imgPath, function (err, data) {
		if (err) { return console.error(">>>>" + err); }
		var type = "image/png";
		var imgType = data.format.toLowerCase();
		if(imgType == "jpg" || imgType == "jpeg"){
			type = "image/jpeg";
		}else if(imgType == "png"){
			type = "image/png";
		}else{
			return console.error("image must be jpg or png!");
		}
	    var info = {
	    	pp: partPrice,
	    	pn: partName,
	    	customType: customId,
	    	brandList: brandId,
	    	styleType: styleId,
	    	cateList: partId,
	    	zheList: zhe,
			partImage: {file: imgPath, content_type: type}
		};
		showFloat();
		needle.post(baseURL + "allpart/upload", info, {multipart: true}, function(err, res, body){
			curIndex++;
			if(curIndex < xlsxData.data.length){
				uploadPart();
			}else{
				$("#floatDiv").show();
				$("#floatContainer").html("部件全部上传完成!");
				hideFloat(uploadStyle);
			}
		});
	});
}

function hideFloat(cb){
	setTimeout(function(){
		$("#floatDiv").hide();
		curIndex = 1;
		if(cb) cb();
	}, 2000);
}

function showFloatInfo(str){
	$("#floatDiv").show();
	$("#floatContainer").html(str);
}

function uploadStyle(){
	if(!styleXlsxData || !styleXlsxData.data){
		return;
	}
	$("#floatDiv").show();
	for(var i = 1; i<styleXlsxData.data.length; i++){
		$("#floatContainer").html("正在验证第" + (i + 1) + "条款式数据正确性...");
		var styleName = styleXlsxData.data[i][2].value;
		var styleId = getStyleByName(styleName);
		console.log(styleId, styleName);
		if (styleId == 0) {
			showFloatInfo("没找到第" + (i + 1) + "个款式的款式系列, 上传将退出!");
			hideFloat();
			return;
		};
		styleIdList.push(styleId);
	}
	$("#floatContainer").html("数据验证通过，开始上传...");
	startUploadStyle();
}

function sortNumeric(a, b){
	return a - b;
}

function startUploadStyle(){
	if(!styleXlsxData || !styleXlsxData.data.length){
		uploadFabric();
		return;
	}
	var mergedStr = mergeParts(styleXlsxData.data[curIndex]);
	var arr = mergedStr.split(",");
	var partIds = [];
	if(partDataBySid[styleIdList[0]]){
		var l = arr.length;
		for(var i = 0; i<l; i++){
			var ll = partDataBySid[styleIdList[0]].length;
			for(var j = 0; j<ll; j++){
				var obj = partDataBySid[styleIdList[0]][j];
				if(arr[i] == doubleDecode(obj.details_name)){
					partIds.push(obj.id);
				}
			}
		}

		partIds.sort(sortNumeric);
		var imgPath = $("#styleDirChoose").val() + "/" + styleXlsxData.data[curIndex][3].value;
		imageinfo.readInfoFromFile(imgPath, function (err, data) {
			if (err) {
				hideFloat();
				return console.error(err);
			}
			var type = "image/png";
			var imgType = data.format.toLowerCase();
			if(imgType == "jpg" || imgType == "jpeg"){
				type = "image/jpeg";
			}else if(imgType == "png"){
				type = "image/png";
			}else{
				hideFloat();
				return console.error("image must be jpg or png!");
			}

			var backImgPath = $("#styleDirChoose").val() + "/" + styleXlsxData.data[curIndex][4].value;

			imageinfo.readInfoFromFile(backImgPath, function (err, data) {
				if (err) {
					hideFloat();
					return console.error(err);
				}
				var btype = "image/png";
				var imgType = data.format.toLowerCase();
				if(imgType == "jpg" || imgType == "jpeg"){
					btype = "image/jpeg";
				}else if(imgType == "png"){
					btype = "image/png";
				}else{
					hideFloat();
					return console.error("image must be jpg or png!");
				}

				if(styleXlsxData.data[curIndex][5] && styleXlsxData.data[curIndex][5] != ""){
					var sideImgPath = $("#styleDirChoose").val() + "/" + styleXlsxData.data[curIndex][5].value;

					imageinfo.readInfoFromFile(sideImgPath, function(err, data){
						if (err) {
							hideFloat();
							return console.error(err);
						}
						var stype = "image/png";
						var imgType = data.format.toLowerCase();
						if(imgType == "jpg" || imgType == "jpeg"){
							stype = "image/jpeg";
						}else if(imgType == "png"){
							stype = "image/png";
						}else{
							hideFloat();
							return console.error("image must be jpg or png!");
						}

						var info = {
							ids: partIds.join(","),
							frontFile: {file: imgPath, content_type: type},
							backFile: {file: backImgPath, content_type: btype},
							sideFile: {file: sideImgPath, content_type: stype},
							invpock: styleXlsxData.data[curIndex][6].value == "是" ? 1 : 0,
							sig: styleXlsxData.data[curIndex][7].value == "是" ? 1 : 0,
							sn: encodeURIComponent(styleXlsxData.data[curIndex][0].value),
							sp: styleXlsxData.data[curIndex][1].value,
							sc: styleIdList[0]
						}

						showFloatInfo("正在上传第" + curIndex + "个款式...");

						needle.post(baseURL + "allstyle/upload/", info, {multipart: true}, function(err, res, body){
							curIndex++;
							styleIdList.shift();
							if(!styleIdList.length){
								showFloatInfo("款式上传完成!");
								hideFloat(uploadFabric);
								curIndex = 1;
							}else{
								startUploadStyle();
							}
						});
					});
				}else{
					var info = {
						ids: partIds.join(","),
						frontFile: {file: imgPath, content_type: type},
						backFile: {file: backImgPath, content_type: btype},
						sideFile: "",
						invpock: styleXlsxData.data[curIndex][6].value == "是" ? 1 : 0,
						sig: styleXlsxData.data[curIndex][7].value == "是" ? 1 : 0,
						sn: encodeURIComponent(styleXlsxData.data[curIndex][0].value),
						sp: styleXlsxData.data[curIndex][1].value,
						sc: styleIdList[0]
					}

					showFloatInfo("正在上传第" + curIndex + "个款式...");

					needle.post(baseURL + "allstyle/upload/", info, {multipart: true}, function(err, res, body){
						curIndex++;
						styleIdList.shift();
						if(err){
							console.log(err);
						}
						if(!styleIdList.length){
							showFloatInfo("款式上传完成!");
							hideFloat(uploadFabric);
							curIndex = 1;
						}else{
							startUploadStyle();
						}
					});
				}
			});
		});
	}else{
		needle.get(baseURL + "api/allDataByPid/?pid=" + styleIdList[0], function(err, res, body){
			if(body.code == 100006){
				partDataBySid[styleIdList[0]] = body.data;
				startUploadStyle();
			}else{
				showFloatInfo("部件信息获取失败!");
				hideFloat();
			}
		});
	}
}

function getStyleByName(str){
	var id = 0;
	$.each(styleType, function(index, val){
		var styleName = doubleDecode(val.cate_name);
		if(str == styleName){
			id = val.id;
			return false;
		}
	});
	return id;
}

function showFloat(){
	$("#floatDiv").show();
	$("#floatContainer").html("正在上传第" + curIndex + "个部件...");
}

function getCustomId(str){
	var id = 0;
	$.each(customType, function(index, val){
		var cateName = doubleDecode(val.cate_name);
		if(cateName == str){
			id = val.id;
			return false;
		}
	});
	return id;
}

function getStyleId(cid, str){
	var id = 0;
	$.each(styleType, function(index, val){
		var styleName = doubleDecode(val.cate_name);
		if(str == styleName && val.parent_id == cid){
			id = val.id;
			return false;
		}
	});
	return id;
}

function getPartId(sid, str){
	var id = 0;
	$.each(partType, function(index, val){
		var partName = doubleDecode(val.cate_name);
		if(str == partName && val.parent_id == sid){
			id = val.id;
			return false;
		}
	});
	return id;
}

function getBrandId(str){
	var id = 0;
	$.each(brandData, function(index, val){
		var brandName = doubleDecode(val.brand_name);
		if(brandName == str){
			id = val.id;
			return false;
		}
	});
	return id;
}

function doubleDecode(str){
	return decodeURIComponent(decodeURIComponent(str))
}

function excelChooser_changeHandler(){
	var excelChooser = document.querySelector("#excelChoose");
	var excelFile = document.querySelector("#excelFile");
	excelFile.innerHTML = excelChooser.value;

	var obj = xlsx.parse(excelChooser.value);

	xlsxData = obj.worksheets[0];
	var html = template.render("excelTmpl", xlsxData);
	$("#excelData").html(html);
}

function dirChooser_changeHandler(){
	var dirChooser = document.querySelector("#dirChoose");
	var folderDir = document.querySelector("#folderDir");
	folderDir.innerHTML = dirChooser.value;
}

function excelBtn_clickHandler(){
	var event = document.createEvent('MouseEvents');
    event.initMouseEvent('click');
	document.querySelector("#excelChoose").dispatchEvent(event);
}

function folderBtn_clickHandler(){
	var event = document.createEvent('MouseEvents');
    event.initMouseEvent('click');
	document.querySelector("#dirChoose").dispatchEvent(event);
}