
	var testMsgArray = [];

	$(function(){
		if(typeof msgArray != "undefined") {
			testMsgArray = msgArray;
			//old_alert("=>"+testMsgArray );
		} else {

			if(parent != null && typeof parent.testMsgArray != "undefined") {
				testMsgArray = parent.testMsgArray;
				//old_alert("=>"+testMsgArray.length);
			} else {
				if(opener != null && typeof opener.testMsgArray != "undefined") {
					testMsgArray = opener.testMsgArray;
					//old_alert("=>>"+testMsgArray.length);
				}
			}
		}
		
	});

	function msg(str){
		alert(testMsgArray[str]);
	}

	function returnMsg(str){
		var rtStr = testMsgArray[str].replace(/\n/g, "<br />");
		return rtStr;
	}

	function nl2br(varTest){return varTest.replace(/\n/g, "<br />");};

	function sheetSplice(arr, sint, arrStr, option, type){

		if(arrStr.length==0)
			return;

		if(type){
		arr.splice(sint++,	0,{Hidden:1,SaveName:"keyLevel"});
		arr.splice(sint++,	0,{Hidden:1,SaveName:"keyId"});
		arr.splice(sint++,	0,{Hidden:1,SaveName:"keyText"});
		arr.splice(sint++,	0,{Hidden:1,SaveName:"keyNote"});
		arr.splice(sint++,	0,{Hidden:1,Type:"CheckBox",SaveName:"keyRead",TrueValue:"0",	FalseValue:"1"});
		}

		$(arrStr.split(",")).each(function(idx,	str){
		arr.splice(sint++,0,{Header:($.type(option) ==="string" ? option:option[0])+'['+str+']',
							Type:"Text",
							Align:($.type(option) ==="string" ? "Left" :option[2]),
							Width:($.type(option) ==="string" ? "120" :option[1]),
							SaveName:convCamel(str),
							KeyField:($.type(option[3]) === "undefined" ? "1" :option[3]),
							EditLen:3000,
							MultiLineText:true});
		});
	}

	function sheetLangSave(sheet, keyLevel, keyId, keyText){
		$(sheet.FindStatusRow("I|U|D").split(";")).each(function(idx, arrow)	{
			sheet.SetCellValue(arrow, "keyLevel", keyLevel);
			var keyIdStr   = "";
			var keyTextStr = "";

			keyIdStr = $.type(keyId) === "string" ? "" :keyId[1];
			$(($.type(keyId) === "string" ? keyId :keyId[0]).split(",")).each(function(idx, keyIdr) { keyIdStr = keyIdStr+ "." + sheet.GetCellValue(arrow,$.trim(keyIdr));});
			keyIdStr = keyIdStr + ($.type(keyId) ==="string" ? "" :keyId[2]);
			keyIdStr = (keyIdStr.indexOf(".")==0) ? keyIdStr.substr(1) : keyIdStr;

			sheet.SetCellValue(arrow,"keyId",keyIdStr);

			keyTextStr = $.type(keyText) ==="string" ? "" :keyText[1];
			$(($.type(keyText)	==="string" ? keyText :keyText[0]).split(",")).each(function(idx,keyTextr){keyTextStr = keyTextStr+ "." + sheet.GetCellValue(arrow,$.trim(keyTextr));});
			keyTextStr = keyTextStr + ($.type(keyText) === "string" ? "" :keyText[2]);
			keyTextStr = (keyTextStr.indexOf(".")==0) ? keyTextStr.substr(1) : keyTextStr;
			sheet.SetCellValue(arrow,"keyText",keyTextStr);

			sheet.SetCellValue(arrow,"keyRead","1");
		});
	}

	//사용언어	조회
	function selectLanguage(gLn)	{
		const localeList = ajaxCall("/LangId.do?cmd=getLocaleList", "", false).list;
		if ( localeList.length > 1) {
			const localeHtml = localeList.reduce((a, c) => {
				let	className =	c.localeCd === gLn ? "on" :	"";
				let flagImgNm = "flags_" + c.localeCd + ".png";

				a += "<div class='option' localeCd='"+c.localeCd+"'>" +
					"<a class='"+className+" pointer'>" +
					"<img src='/common/images/icon/" + flagImgNm + "' style='vertical-align:text-bottom; margin-right: 10px' id='langFlag' />" +
					c.langNm	+
					"</a> </div>";

				return a;
			}, '<div class="header">언어 변경</div>\n');

			$("#langeList").html(localeHtml);

			$("#langeList div.option").click(function()	{
				ajaxCall("/LangId.do?cmd=changeLocale","strLocale="+	$(this).attr("localeCd"),false);
				setCookie("hrSaveLocaleCd",$(this).attr("localeCd"),1000);
				redirect("/",	"_top");
			});
		}else{
			$("#langFlag").attr("style","display:none;");
			$("#langeMgr").attr("style","display:none;");
		}

	}

	function getMsgLanguage(obj) {
		var msgid = "", defaultMsg = "", returnMsg = "", arg = "";

		try{
			if(typeof obj == "object") {
				msgid = obj.msgid;
				if(typeof obj.defaultMsg != "object") {
					defaultMsg = obj.defaultMsg.toString();
				}

				if(obj.arg != null && typeof obj.arg != "object") {
					arg = obj.arg.toString();
				}

			} else if(obj != null){
				defaultMsg = obj.toString();
			}

			if(msgid != "" && testMsgArray[msgid] != null) {
				returnMsg = testMsgArray[msgid]
			} else {
				if(defaultMsg != "" && testMsgArray[defaultMsg] != null) {
					returnMsg = testMsgArray[defaultMsg];
				} else {
					returnMsg = defaultMsg;
				}
			}

			if(arg != null && arg != "") {
				var arrArg = arg.split(",");

				for(var i = 0; i < arrArg.length; i++) {
					var strArg = arrArg[i];
					var regexp = "{"+i+"}";

					returnMsg = returnMsg.split(regexp).join(strArg);
				}
			}
		}
		catch(err){
			returnMsg = "";
		}

		return returnMsg;
	}

	// window.alert = function(){
	// 	var alertStr = "";
	// 	var alertMsg = "";
	// 	try{
	// 		for(var i = 0; i < arguments.length; i++) {
	// 			alertStr = testMsgArray[arguments[i]]
	//
	// 			if(alertStr == undefined) {
	// 				//if(arguments.length==(i+1)){return old_alert("-->"+arguments[i]);}
	// 				alertStr = arguments[i];
	// 			}
	// 			alertMsg = alertMsg+ alertStr
	// 		}
	// 	}
	// 	catch(err){
	// 		alertMsg = arguments[0];
	// 	}
	// 	return alertMsg;
	// };

	// window.old_confirm = window.confirm;
	// window.confirm = function() {
	// 	var confirmStr = "";
	// 	var confirmMsg = "";
	// 	for(var i = 0; i < arguments.length; i++) {
	// 		confirmStr = testMsgArray[arguments[i]]
	//
	// 		if(confirmStr == undefined) {
	// 			confirmStr = arguments[i]
	// 		}
	// 		confirmMsg = confirmMsg+ confirmStr
	// 	}
	// 	return old_confirm(confirmMsg);
	// }




















	function sheetSplice2(cols, sInt, arrLang, option, type, matchKeyColNm){
		if(arrLang.length==0)
			return;

		if(type) {
			cols.splice(sInt++, 0,{Hidden:1, SaveName: matchKeyColNm+"keyLevel"});
			cols.splice(sInt++, 0,{Hidden:1, SaveName: matchKeyColNm+"keyId"});
			cols.splice(sInt++, 0,{Hidden:1, SaveName: matchKeyColNm+"keyText"});
			cols.splice(sInt++, 0,{Hidden:1, SaveName: matchKeyColNm+"keyNote"});
			cols.splice(sInt++, 0,{Hidden:1, Type:"CheckBox", SaveName: matchKeyColNm+"keyRead", TrueValue:"0", FalseValue:"1"});
		}

		$(arrLang.split(",")).each(function(idx, str){
			cols.splice(sInt++,0,{Header:($.type(option) ==="string" ? option:option[0])+'['+str+']',
							Type:"Text",
							Align:($.type(option) ==="string" ? "Left" :option[2]),
							Width:($.type(option) ==="string" ? "120" :option[1]),
							SaveName: matchKeyColNm+convCamel(str),
							KeyField:($.type(option[3]) === "undefined" ? "1" :option[3]),
							EditLen:3000,
							MultiLineText:true});
		});
	}

	function sheetLangSave2(sheet, keyLevel, keyId, keyText, matchKeyColNm){
		$(sheet.FindStatusRow("I|U|D").split(";")).each(function(idx, arrow) {
			sheet.SetCellValue(arrow, "keyLevel", keyLevel);
			var keyIdStr   = "";
			var keyTextStr = "";

			keyIdStr = $.type(keyId) === "string" ? "" :keyId[1];
			$(($.type(keyId) === "string" ? keyId :keyId[0]).split(",")).each(function(idx, keyIdr) { keyIdStr = keyIdStr+ "." + sheet.GetCellValue(arrow,$.trim(keyIdr));});
			keyIdStr = keyIdStr + ($.type(keyId) ==="string" ? "" :keyId[2]);
			keyIdStr = (keyIdStr.indexOf(".")==0) ? keyIdStr.substr(1) : keyIdStr;

			sheet.SetCellValue(arrow,"keyId",keyIdStr);

			keyTextStr = $.type(keyText) ==="string" ? "" :keyText[1];
			$(($.type(keyText)	==="string" ? keyText :keyText[0]).split(",")).each(function(idx,keyTextr){keyTextStr = keyTextStr+ "." + sheet.GetCellValue(arrow,$.trim(keyTextr));});
			keyTextStr = keyTextStr + ($.type(keyText) === "string" ? "" :keyText[2]);
			keyTextStr = (keyTextStr.indexOf(".")==0) ? keyTextStr.substr(1) : keyTextStr;
			sheet.SetCellValue(arrow,"keyText",keyTextStr);

			sheet.SetCellValue(arrow,"keyRead","1");
		});
	}






/*


window.old_alert = window.alert;
window.alert = function(){
	var alertMsg = testMsgArray[arguments[0]];
	if(alertMsg == undefined) {
		if(arguments[1] != undefined){
			old_alert(arguments[1]);
		}else{
			old_alert(arguments[0]);
		}

		return;
	}
	else{
		old_alert(testMsgArray[arguments[0]]);
		return;
	}
};


window.old_confirm = window.confirm;
window.confirm = function() {

	var confirmMsg = testMsgArray[arguments[0]];
	if(confirmMsg == undefined) {
		return old_confirm(arguments[0]);
	}
	else{
		return  old_confirm(testMsgArray[arguments[0]]);
	}
}
*/

