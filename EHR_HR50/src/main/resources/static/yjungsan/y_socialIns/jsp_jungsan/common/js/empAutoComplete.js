
/**
 * IBSheet 입력 이벤트 바인딩 정보 저장 객체
 * - ex) 사원 자동완성 기능
 * 
 * by gjyoo
 */
var SHEET_INPUT_EVENT_BIND_INFO = new Object();

/**
 * 시트 입력이벤트 바인딩 정보 추가
 * @param sheet
 * @param colSaveName
 * @param type
 * @param renderItem
 * @param callBackFunc
 * @returns
 * 
 * by gjyoo
 */
function addSheetInputEventBindInfo( sheet, colSaveName, type, renderItem, callBackFunc ) {
	var key = sheet + "";
	var obj = null;
	
	//console.log('colSaveName', colSaveName);
	if(SHEET_INPUT_EVENT_BIND_INFO[key] == null || SHEET_INPUT_EVENT_BIND_INFO[key] == undefined) {
		obj = {};
	} else {
		obj  = SHEET_INPUT_EVENT_BIND_INFO[key];
	}
	
	obj[colSaveName + ""] = {
		"colSaveName"  : colSaveName,
		"type"         : type,
		"renderItem"   : renderItem,
		"callBackFunc" : callBackFunc
	};
	
	SHEET_INPUT_EVENT_BIND_INFO[key] = obj;
}

/**
 * 시트 입력 이벤트 바인딩 처리
 * @returns
 * 
 * by gjyoo
 */
function initSheetInputEventBind() {
	//console.log('SHEET_INPUT_EVENT_BIND_INFO', SHEET_INPUT_EVENT_BIND_INFO);
	var keys = Object.keys(SHEET_INPUT_EVENT_BIND_INFO);
	var scriptTxt = "";
	
	if(keys != null && keys != undefined && keys.length > 0) {
		//console.log('keys', keys);
		
		var sheet    = null;
		var sheetObj = null;
		
		var colKeys  = null;
		var col      = null;
		var colObj   = null;
		
		var idx      = 0;
		var i        = 0;
		
		var scrptBeforeEdit = null;		// OnBeforeEdit 이벤트 바인딩 스크립트문
		var scrptAfterEdit  = null;		// OnAfterEdit 이벤트 바인딩 스크립트문
		var scrptKeyUp      = null;		// OnKeyup 이벤트 바인딩 스크립트문
		
		scriptTxt += "<script id=\"sheet_autocomplete_script\">";
		
		// 시트별 Loop
		for(idx = 0; idx < keys.length; idx++) {
			sheet = keys[idx] + "";	// sheet name
			sheetObj = SHEET_INPUT_EVENT_BIND_INFO[sheet];
			
			// 시트 정보가 존재하는 경우
			if(sheetObj != null && sheetObj != undefined) {
				colKeys = Object.keys(sheetObj);
				
				// 설정된 컬럼 정보가 존재하는 경우
				if(colKeys != null && colKeys != undefined && colKeys.length > 0) {

					// 초기화
					scrptBeforeEdit = "";
					scrptAfterEdit  = "";
					scrptKeyUp      = "";

					// Column Loop
					for(i = 0; i < colKeys.length; i++) {
						colObj = sheetObj[colKeys[i]];
						col = eval(sheet).SaveNameCol(colObj.colSaveName);
						
						scrptBeforeEdit += "    if(" + sheet + ".ColSaveName(Col) == \"" + colObj.colSaveName + "\") {";
						scrptAfterEdit  += "    if(" + sheet + ".ColSaveName(Col) == \"" + colObj.colSaveName + "\") {";
						scrptKeyUp      += "    if(" + sheet + ".ColSaveName(Col) == \"" + colObj.colSaveName + "\") {";
						
						// 사원 검색 자동완성
						if(colObj.type == "AutocompleteEmp") {
							scrptBeforeEdit += "        autoCompleteInit(" + col + "," + sheet + ",Row,Col,"+ colObj.renderItem +"," + colObj.callBackFunc + ");";
							scrptAfterEdit  += "        autoCompleteDestroy(" + sheet + ",Row,Col);";
							scrptKeyUp      += "        autoCompletePress(" + sheet + ", " + col + ",Row,Col,KeyCode);";
						
						// 키보드 보안 적용
						} else if (colObj.type == "SecureKeyboard") {
							scrptBeforeEdit += "        inptEvt_secureKeyboardInit(" + col + "," + sheet + ",Row,Col," + colObj.callBackFunc + ");";
							scrptAfterEdit  += "        inptEvt_secureKeyboardDestroy(" + sheet + ", Row, Col);";
							scrptKeyUp      += "        inptEvt_secureKeyboardPress(" + sheet + ", " + col + ",Row,Col,KeyCode);";
							
						// 보안 키패드 입력
						} else if (colObj.type == "SecureKeyPad") {
							//scrptBeforeEdit += "        inptEvt_secureKeyPadInit(" + col + "," + sheet + ",Row,Col," + colObj.callBackFunc + ");";
							//scrptAfterEdit  += "        inptEvt_secureKeyPadDestroy(" + sheet + ");";
							
						}
						
						scrptBeforeEdit += "    }";
						scrptAfterEdit  += "    }";
						scrptKeyUp      += "    }";
					}
					// [END] Column Loop

					// scriptTxt 취합
					scriptTxt += "";
					scriptTxt += "function " + sheet + "_OnBeforeEdit(Row, Col) {";
					scriptTxt += "	try{";
					scriptTxt += scrptBeforeEdit;
					scriptTxt += "	}catch(e){";
					scriptTxt += "	 	alert(e.message);";
					scriptTxt += "	}";
					scriptTxt += "}";
					scriptTxt += "";
					scriptTxt += "function " + sheet + "_OnAfterEdit(Row, Col) {";
					scriptTxt += "	try{";
					scriptTxt += scrptAfterEdit;
					scriptTxt += "	}catch(e){";
					scriptTxt += "		alert(e.message);";
					scriptTxt += "	}";
					scriptTxt += "}";
					scriptTxt += "";
					scriptTxt += "function " + sheet + "_OnKeyUp(Row, Col, KeyCode, Shift) {";
					scriptTxt += "	try{";
					scriptTxt += scrptKeyUp;
					scriptTxt += "	}catch(e){";
					scriptTxt += "		alert(e.message);";
					scriptTxt += "	}";
					scriptTxt += "}";
					// scriptTxt 취합
					
				}
			}
		}
		// [End] 시트별 Loop
		
		scriptTxt += "</script>";
		//console.log('scriptTxt', scriptTxt);
		
		//$(document).ready(function() {
			for(idx = 0; idx < keys.length; idx++) {
				sheet = keys[idx] + "";	// sheet name
				sheetObj = SHEET_INPUT_EVENT_BIND_INFO[sheet];
				
				// 시트 정보가 존재하는 경우
				if(sheetObj != null && sheetObj != undefined) {
					colKeys = Object.keys(sheetObj);
					
					// 설정된 컬럼 정보가 존재하는 경우
					if(colKeys != null && colKeys != undefined && colKeys.length > 0) {
						
						// Column Loop
						for(i = 0; i < colKeys.length; i++) {
							colObj = sheetObj[colKeys[i]];
							
							// 사원 검색 자동완성
							if(colObj.type == "AutocompleteEmp") {
								if($("#empForm_" + sheet + "_" + colObj.colSaveName).size() == 0) {
									$("<form></form>", {
										id: "empForm_" + sheet + "_" + colObj.colSaveName,
										name: "empForm_" + sheet + "_" + colObj.colSaveName
									}).html('<input type="hidden" name="searchStatusCd" value="AA" /> <input type="hidden" id="searchEmpType" name="searchEmpType" value="I"/>').appendTo('body');
								}
							}
						}
					}
				}
			}
			
			if(window.sheet2_OnBeforeEdit != undefined) {
				window.sheet2_OnBeforeEdit = undefined;
			}
			if(window.sheet2_OnAfterEdit != undefined) {
				window.sheet2_OnAfterEdit = undefined;
			}
			if(window.sheet2_OnKeyUp != undefined) {
				window.sheet2_OnKeyUp = undefined;
			}
			
			$("body").append(scriptTxt);
		//});
	}
}

/**
 * IBSheet 입력 이벤트(자동완성, 보안키패드 ..) 설정 추가 및 적용.
 * 적용해야할 입력 이벤트가 여러가지 혹은 여러개인 경우 사용함.
 * addSheetInputEventBindInfo 함수로 이벤트 정보 추가 후 initSheetInputEventBind 함수 실행하여 이벤트 등록 처리함.
 * 
 * @param setInfo(object array) : 설정 정보
 *        ex)
 *        {
 *            "sheet1" : {
 *                 "name"   : {
 *                     colSaveName  : "name",
 *                     type         : "AutocompleteEmp",
 *                     renderItem   : null,
 *                     callBackFunc : function(rtnValue) { alert(rtnValue); }
 *                 },
 *                 "secureField" : {
 *                     colSaveName  : "secureField",
 *                     type         : "SecureKeyboard",
 *                     renderItem   : null,
 *                     callBackFunc : function(rtnValue) { alert(rtnValue); }
 *                 },
 *                 "keypad" : {
 *                     colSaveName  : "keypad",
 *                     type         : "SecureKeyPad",
 *                     renderItem   : null,
 *                     callBackFunc : function(rtnValue) { alert(rtnValue); }
 *                 }
 *            },
 *            "sheet2" : ...
 *        }
 * @returns
 * 
 * by gjyoo
 */
function setSheetInputEventBind(setInfo) {
	var keys = Object.keys(setInfo);
	
	if(keys != null && keys != undefined && keys.length > 0) {
		
		var sheet    = null;
		var sheetObj = null;
		
		var colKeys  = null;
		var col      = null;
		var colObj   = null;
		
		var idx      = 0;
		var i        = 0;
		
		// 시트별 Loop
		for(idx = 0; idx < keys.length; idx++) {
			sheet = keys[idx] + "";	// sheet name
			sheetObj = setInfo[sheet];
			
			// 시트 정보가 존재하는 경우
			if(sheetObj != null && sheetObj != undefined) {
				colKeys = Object.keys(sheetObj);
				
				// 설정된 컬럼 정보가 존재하는 경우
				if(colKeys != null && colKeys != undefined && colKeys.length > 0) {
					// Column Loop
					for(i = 0; i < colKeys.length; i++) {
						colObj = sheetObj[colKeys[i]];
						
						// addSheetInputEventBindInfo 실행하여 설정 정보 추가
						addSheetInputEventBindInfo( sheet, colObj.colSaveName, colObj.type, colObj.renderItem, colObj.callBackFunc );
					}
					// [END] Column Loop
				}
			}
		}
		// [End] 시트별 Loop
		
		// initSheetInputEventBind 함수 실행하여 적용 처리
		initSheetInputEventBind();
	}
}

/**
 * IBsheet의 Employee auto_complete
 *
 * setSheetAutocompleteEmp 함수로 초기화.
 * 선택된 사원 data는 getReturnValue 함수에서 처리 (pGubun = sheetAutocompleteEmp)
 *
 * @param sheet (string) : 자동완성을 사용할 sheet명
 * @param colSaveName (string) : 자동완성을 사용할 컬럼 saveName
 * @param renderItem (function) : 자동완성시 출력될 박스 포맷. Undefined일 경우 employeeRenderItem function 사용.
 * @returns
 *
 * by sjkim
 */

function setSheetAutocompleteEmp(sheet, colSaveName, renderItem , callBackFunc ) {
	try {
		// 설정 정보 추가
		addSheetInputEventBindInfo( sheet, colSaveName, "AutocompleteEmp", renderItem, callBackFunc );
		
		// 시트 입력 이벤트 바인딩 처리
		initSheetInputEventBind();
		
		/*    
	    var col = eval(sheet).SaveNameCol(colSaveName);
	    var scriptTxt = "";
	    scriptTxt += "<script>";
	    scriptTxt += "function " + sheet + "_OnBeforeEdit(Row, Col) {";
	    scriptTxt += "	try{";
	    scriptTxt += "		autoCompleteInit(" + col + "," + sheet + ",Row,Col,"+ renderItem +"," + callBackFunc + ");";
	    scriptTxt += "	}catch(e){";
	    scriptTxt += "	 	alert(e.message);";
	    scriptTxt += "	}";
	    scriptTxt += "}";
	    scriptTxt += "";
	    scriptTxt += "function " + sheet + "_OnAfterEdit(Row, Col) {";
	    scriptTxt += "	try{";
	    scriptTxt += "		autoCompleteDestroy(" + sheet + ");";
	    scriptTxt += "	}catch(e){";
	    scriptTxt += "		alert(e.message);";
	    scriptTxt += "	}";
	    scriptTxt += "}";
	    scriptTxt += "";
	    scriptTxt += "function " + sheet + "_OnKeyUp(Row, Col, KeyCode, Shift) {";
	    scriptTxt += "	try{";
	    scriptTxt += "		autoCompletePress(" + sheet + ", " + col + ",Row,Col,KeyCode);";
	    scriptTxt += "	}catch(e){";
	    scriptTxt += "		alert(e.message);";
	    scriptTxt += "	}";
	    scriptTxt += "}";
	    scriptTxt += "</script>";
	
	    $(document).ready(function() {
	        eval(sheet).SetEditArrowBehavior(2);
	        $("<form></form>", {
	            id: "empForm_" + sheet,
	            name: "empForm_" + sheet
	        }).html('<input type="hidden" name="searchStatusCd" value="AA" /> <input type="hidden" id="searchEmpType" name="searchEmpType" value="I"/>').appendTo('body')
	            .append(scriptTxt);
	    });
	    */
		
	} catch(ex) {
		alert("setSheetAutocompleteEmp Error :: " + ex);
	}
}

var intervalDestory;
// autocomplete 생성
function autoCompleteInit(opt, sheet, Row, Col, renderItem , callBackFunc) {
	//console.log('autoCompleteInit', Row);
	
	// 화살표키 상하이동 금지 처리
	sheet.SetEditArrowBehavior(2);
	
    if (Col != opt) return;

    //자동완성 List form
    var autocompRenderItem
    var callBackFunctionItem;
    if(renderItem != undefined && renderItem != null ) {
        autocompRenderItem = new Function ( "return "+ renderItem )();
    } else {
        autocompRenderItem = employeeRenderItem1;
    }

    if ( callBackFunc != undefined ){

        callBackFunctionItem = callBackFunc
    } else {
        callBackFunctionItem = "getReturnValue";
    }

    var colNm = sheet.ColSaveName(Col);
    if ($("#autoCompleteDiv", '#empForm_' + sheet.id + "_" + colNm).length == 0) {
        $('<div></div>', {
            id: "autoCompleteDiv"
        }).html("<input id='searchKeyword1' name='searchKeyword' type='text' />").appendTo('#empForm_' + sheet.id + "_" + colNm);

        var inputId = "searchKeyword1";
        $("#searchKeyword1", '#empForm_' + sheet.id + "_" + colNm).autocomplete({
            source: function(request, response) {
                
                var params = $("#empForm_" + sheet.id + "_" + colNm).serialize();
                
                // EncParams 함수를 통한 파라미터 보안 처리
                //params = EncParams(params);
                
                $.ajax({
                    url: "/Employee.do?cmd=employeeList",
                    dateType: "json",
                    type: "post",
                    data: decodeURIComponent(params),
                    success: function(data) {
                        response($.map(data.DATA, function(item) {
                            return {
                                label: item.empSabun + ", " + item.enterCd + ", " + item.enterNm,
                                searchNm: $("#searchKeyword1", "#empForm_" + sheet.id + "_" + colNm).val(),
                                enterNm: item.enterNm, // 회사명
                                enterCd: item.enterCd, // 회사코드
                                name: item.empName, // 사원명
                                sabun: item.empSabun, // 사번
                                empYmd: item.empYmd, // 입사일
                                orgCd: item.orgCd, // 조직코드
                                orgNm: item.orgNm, // 조직명
                                jikchakCd: item.jikchakCd, // 직책코드
                                jikchakNm: item.jikchakNm, // 직책명
                                jikgubCd: item.jikgubCd, // 직급코드
                                jikgubNm: item.jikgubNm, // 직급명
                                jikweeCd: item.jikweeCd, // PAYBAND
                                jikweeNm: item.jikweeNm, // PAYBAND
                                resNo: item.resNo, // 주민번호
                                resNoStr: item.resNoStr, // 주민번호 앞자리
                                statusCd: item.statusCd, // 재직/퇴직
                                statusNm: item.statusNm, // 재직/퇴직
                                value: item.empName,
                                callBackFunc : callBackFunctionItem
                            };
                        }));
                    }
                });
            },
            autoFocus: true,
            minLength: 1,
            focus: function() {
                return false;
            },
            open: function() {
                $(this).removeClass("ui-corner-all").addClass("ui-corner-top");
            },
            close: function() {
                $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
            }
        }).data("uiAutocomplete")._renderItem = autocompRenderItem;
    };

    //autocomplete 선택되었을 때 Event Handler
    $("#autoCompleteDiv", "#empForm_" + sheet.id + "_" + colNm).off("autocompleteselect");
    $("#autoCompleteDiv", "#empForm_" + sheet.id + "_" + colNm).on("autocompleteselect", function(event, ui) {
        var row = Row;
        sheet.SetCellText(Row, Col, ui.item.value);

        $("#autoCompleteInput", "#empForm_" + sheet.id + "_" + colNm).val("");
        autoCompleteDestroy(sheet,Row,Col);

        //상세 데이터 가져오기
        var params = "searchEnterCd="+ ui.item.enterCd
            + "&selectedUserId="+ ui.item.sabun
            + "&searchStatusCd="+ 'AA';
        var data = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail",params,false);

        //직원을 선택시 Data Return

        var returnFunc1 = new Function ( "return "+ ui.item.callBackFunc )()

        if(typeof returnFunc1 != "undefined") {
            gPRow = row;
            pGubun = "sheetAutocompleteEmp";
            returnFunc1( paramMapToJson(data.map) );
        }

    });

    $(".GMVScroll>div").scroll(function() {
        destroyAutoComplete(sheet);
    });
    $(".GMHScrollMid>div").scroll(function() {
        destroyAutoComplete(sheet);
    });

    var pleft = sheet.ColLeft(sheet.GetSelectCol());
    var ptop = sheet.RowTop(sheet.GetSelectRow()) + sheet.GetRowHeight(sheet.GetSelectRow());
    //건수정보 표시줄의 높이 만큼.
    if (sheet.GetCountPosition() == 1 || sheet.GetCountPosition() == 2) ptop += 13;

    var point = fGetXY(document.getElementById("DIV_" + sheet.id));

    var left = point.x + pleft;
    var top = point.y + ptop - 17;

    var cWidth = 520;
    var cHeight = 104;
    var dWidth = $(window).width();
    var dHeight = $(window).height();

    if (dWidth < left + cWidth) left = dWidth - cWidth;
    if (dHeight < top + cHeight) top = top - cHeight - 28;
    if (top < 0) top = 0;

    $("#autoCompleteDiv", "#empForm_" + sheet.id + "_" + colNm).css("left", left + "px");
    $("#autoCompleteDiv", "#empForm_" + sheet.id + "_" + colNm).css("top", top + "px");
    clearTimeout(intervalDestory);
    sheet.$beforeEditEnterBehavior = sheet.GetEditEnterBehavior();
    sheet.SetEditEnterBehavior("none");
}

//autocomplete 키보드 이벤트
function autoCompletePress(sheet, opt, Row, Col, code) {
    if (Col != opt) return;
    
    var colNm = sheet.ColSaveName(Col);
    
    //IBsheet에서 입력된 값을 가져와 자동완성에 넘김
    var e = jQuery.Event("keydown");
    e.keyCode = code;
    $("#searchKeyword1", '#empForm_' + sheet.id + "_" + colNm).trigger(e);
    
    //IBsheet input tag의 속성 - id:_editInput0 class:GMEditInput2
    if( $("#_editInput0", "#DIV_" + sheet.id).length != 0 ) {
        $("#searchKeyword1", '#empForm_' + sheet.id + "_" + colNm).val($("#_editInput0", "#DIV_" + sheet.id).val());
    } else {
        //id:_editInput0 가 없는 경우도 있다. 그럴 경우 class:GMEditInput 로 검색
        $("#searchKeyword1", '#empForm_' + sheet.id + "_" + colNm).val($(".GMEditText", "#DIV_" + sheet.id).val());
    }
}

// autocomplete 제거
function autoCompleteDestroy(sheet,Row,Col) {
    clearTimeout(intervalDestory);
    intervalDestory = setTimeout(function() {
        destroyAutoComplete(sheet,Row,Col);
    }, 200);
}

//autocomplete 제거
function destroyAutoComplete(sheet,Row,Col) {
    $(".GMVScroll>div").unbind("scroll");
    $(".GMHScrollMid>div").unbind("scroll");

    var colNm = sheet.ColSaveName(Col);
    $("#autoCompleteInput").autocomplete("destroy");
    $("#autoCompleteDiv", '#empForm_' + sheet.id + "_" + colNm).remove();

	// 화살표키 상하이동 허용 처리
    sheet.SetEditArrowBehavior(3);

    //sheet.SetEditEnterBehavior("tab");
    sheet.SetEditEnterBehavior(sheet.$beforeEditEnterBehavior);
}

//autocomplete 리스트 포맷
function employeeRenderItem1(ul, item) {
	var empYmd = "";
	if(item != null && item != undefined) {
		if(item.empYmd != null && item.empYmd != undefined) {
			empYmd = item.empYmd;
			empYmd = empYmd.substring(0, 4) + "-" + empYmd.substring(4, 6) + "-" + empYmd.substring(6, 8);
		}
	}
    return $("<li />")
        .data("item.autocomplete", item)
        .append("<a class='autocomplete' style='width:470px;'>" +
            "<span style='width:70px;'>" + String(item.name).split(item.searchNm).join('<b>' + item.searchNm + '</b>') + "</span>" +
            "<span style='width:90px;'>" + item.sabun + "</span>" +
            "<span style='width:150px;'>" + item.orgNm + "</span>" +
            "<span style='width:70px;'>" + empYmd + "</span>" +
            "<span style='width:50px;'>" + item.statusNm + "</span>" +
            "</a>").appendTo(ul);
}

/**
 * IBSheet AutoComplete 끝.
 */


/**
 * Map 형태의 변수를 Json string으로 변환
 *
 * @param args (Map) : 변환할 변수
 * @returns json string
 *
 * by sjkim
 */
function paramMapToJson(args) {
	var json = "";
	var i = 0;

	for(key in args) {
		if(key != "contains"){
			if(typeof args[key] == "object") {
				alert("arguments 값이 object 입니다.");
				return;
			}

			if(typeof args[key] != 'undefined' && args[key] != null) {
				args[key] = args[key].toString().replace(/\"/gi,'\\"');
				args[key] = args[key].toString().replace(/'/gi,"\'");
				args[key] = args[key].toString().replace(/\r\n/gi,"\n");
				args[key] = args[key].toString().replace(/\n/gi,"\\n");
				args[key] = args[key].toString().replace(/\t/gi,"    ");
			}

			json = json + ((i==0) ? "\"" : ",\"") +[key]+"\":\""+args[key]+"\"";
		}
		i++;
	}

	return json;
}
