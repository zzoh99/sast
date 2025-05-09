<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사기록사항관리(업로드)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var _tblInfo = null;
var _tbName = null;
var _selInfo = null;

	$(function() {
		// 테이블별 컬럼 정보 조회chunk
		_tblInfo = ajaxCall("${ctx}/PsnalInfoUpload.do?cmd=getTableInfoList","",false);
		_tblInfo = _tblInfo.DATA;
		
		// 기존꺼		
// 		// 조회조건 테이블명 셋팅
// 		var searchTableTxt = "";
// 		var preTblNm = "";
		
// 		for(var i=0; i<_tblInfo.length; i++) {
// 			if(preTblNm != _tblInfo[i].empTableNm) {
// 				searchTableTxt += "<option value='"+_tblInfo[i].empTable+"'>" + _tblInfo[i].empTableNm + "</option>";
// 				preTblNm = _tblInfo[i].empTableNm;
// 			}
// 		}
		
		/* ######################################################################################################### */
		// JY 수정 (2020-07-27)  # 전체면 전부, 선택이면 선택한것만 나오게 수정 
		// 테이블별 컬럼 정보 조회
		_tbName = ajaxCall("${ctx}/PsnalInfoUpload.do?cmd=getTableNameList","",false);
		_tbName = _tbName.DATA;
		
		// 조회조건 테이블명 셋팅
		var searchTableTxt = "";
		var searchTableTxt2 = "";
		
		var valType ="";
		var valType2 ="";
		
		for(var z=0; z<_tbName.length; z++) {
				
            if(_tbName[z].allVal == "S"){
               	valType = _tbName[z].allVal;
                   searchTableTxt += "<option value='"+_tbName[z].code+"'>" + _tbName[z].codeNm + "</option>";
            }
            
			if(_tbName[z].allVal == "E"){
               	valType2 = _tbName[z].allVal;
               }else{
               		if(_tbName[z].code != "ALL"){
            	   		searchTableTxt2 += "<option value='"+_tbName[z].code+"'>" + _tbName[z].codeNm + "</option>";
               		}
               }
                
		}
		
		/* ######################################################################################################### */
		
		if(valType2 == "E"){
			$("#searchTableName").html(searchTableTxt2);
		}else if(valType == "S"){
			$("#searchTableName").html(searchTableTxt);
		}
		
		// 재직상태
 		var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
 		select2MultiChoose(statusCd[2], "AA", "searchStatusCd", "<tit:txt mid='103895' mdef='전체'/>");
		
		// 컬럼 타입셋팅
		setColType();
		// 시트 초기화
		initDynamicSheetInfo();
		/*
		$("#fromSdate").datepicker2({startdate:"toSdate"});
		$("#toSdate").datepicker2({enddate:"fromSdate"});
// 		$("#fromSdate").val("${curSysYyyyMMHyphen}-01") ;
// 		$("#toSdate").val("${curSysYyyyMMHyphen}-31") ;
        $("#searchSaNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		*/
		// 콤보 변경할때 마다 그리드 사이즈 조정
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search") ;
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
/* 				{
					ColSaveName  : ( !($("#searchTableName").val() == "THRM100" && $("#searchTableName").val() == "THRM124") ) ? "name" : "",
					CallbackFunc : function(returnValue){
						
						var rv = $.parseJSON('{' + returnValue+ '}');
						
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "empName",	rv["name"]);
						sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"]);
					}
				}, */
				{
					ColSaveName  : ( !($("#searchTableName").val() == "THRM100" && $("#searchTableName").val() == "THRM124") ) ? "empName" : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "empName",	rv["name"]);
						sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"]);
					}
				}
			]
		});	
		
        $("#searchSaNm,#searchTableName").bind("keyup",function(event){
        	if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});
	
	var _colType = new Array(); // 시트의 컬럼 타입정의
	function setColType() {
		//var ctype=[" |COMBO|TEXT|TEXTAREA|CHECKBOX|POPUP|DATE|MONTH|FILE|HIDDEN"," |C|T|A|H|P|D|M|F|N"];
		var ctype=[" |Combo|Text|Text|CheckBox|PopupEdit|Date|Month|NotUse|Hidden"," |C|T|A|H|P|D|M|F|N"];
		var cnm = ctype[0].split("|");
		var ccd = ctype[1].split("|");
		// {"C":"Combo", "T":"Text"} 형식의 JSON데이터 생성
		var tmp = "{";
		for(var i=0; i<cnm.length; i++) {
			if($.trim(cnm[i]) != "") {
				if(tmp != "{") {tmp += ",";}
				//tmp += "'" + ccd[i] + "':'" + cnm[i].substring(0,1).toUpperCase() + cnm[i].substring(1, cnm[i].length).toLowerCase() + "'";
				tmp += "'" + ccd[i] + "':'" + cnm[i] + "'";
			}
		}
		tmp += "}";
		$.globalEval("_colType = "+tmp+";");
		
	}
	
	var _pkList = "";
	var _sqList = "";
	var _selQuery = "";
	var _selMenuQuery = "";
	var _selMenuQuery2 = "";
	var _defaultVal = null;
	var _templateCols = "";
	var _templateColsLen = 0;
	var _templateNames = "";
	var _align = "Center";
	function initDynamicSheetInfo() {
		//시트 초기화 
		sheet1.Reset();
		
		_pkList   = ""; // pk리스트
		_sqList   = ""; // seq리스트
		_selQuery = ""; // 셀렉트 절에 들어갈 컬럼명 ,를 구분자로 나열
		_selMenuQuery = ""; // 셀렉트 절에 들어갈 컬럼명 ,를 구분자로 나열
		_selMenuQuery2 = ""; // 셀렉트 절에 들어갈 컬럼명 ,를 구분자로 나열
		_defaultVal = new Array(); // 디폴트 값 입력할 내용
		_templateCols = ""; // 양식 다운로드 시 필요한 컬럼
		_templateColsLen = 0; // 양식 다운로드 시 헤더 길이
		_templateNames = ""; // 필수 입력 컬럼 설명칸에 입력할 내용
		
		var tabNm = $("#searchTableName").val(); // 테이블명
		var initdata1 = {};
		
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		//var cryptKey=[" |주민번호|면허번호|여권번호|비밀번호(양방향)|비밀번호(단방향)|계좌카드번호|유효기간|전화번호|주소|메일|차량번호|생년월일"
		//             ," |RSNO|LICNO|PSPNO|SCRNO|PWD|ACTNO|VALD_TRM|TLNO|ADR|MAIL|CARNO|BRTH"];
		//sheet1.SetColProperty("cryptKey", 	{ComboText:cryptKey[0], ComboCode:cryptKey[1] });
		
		// 인사기본인 경우 입력 버튼 hidden 처리
		$("#btnInsert").show();
		if(tabNm == "THRM100"){
			$("#btnInsert").hide();
		}
		
		//구분이 성명 테이블 같은 경우 초기 구성 시 성명컬럼은 제외함(2019.04.02)
		if(tabNm == "THRM101"){
			initdata1.Cols = [
				{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			];	
		} else {
			initdata1.Cols = [
				{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				{Header:"소속",		Type:"Text",    	Hidden:0,   				Width:90,   		Align:"Center", ColMerge:0, SaveName:"orgNm", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
				{Header:"성명",		Type:"Text",    	Hidden:0,   				Width:70,   		Align:"Center", ColMerge:0, SaveName:"empName", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100}
			];
		}
		
		// 콤보 셋팅 리스트
		var comboCols = new Array();
		var searchList = new Array();
		
		var sum = 0;
		
		for(var i=0; i<_tblInfo.length; i++) {
			
			var _col = _tblInfo[i];
			_align = "Center";
			
			// 선택한 테이블별 컬럼 정보
			if(tabNm == _col.empTable) {
				// var _cTp = _colType.T; 형식의 변수 생성
				
				$.globalEval("var _cTp = _colType." + _col.cType + ";");
				// 파일 첨부 컬럼같은건 사용안함 , setColType함수에서 정의
				if(_cTp == "NotUse") { continue; }
				
				// 히든 컬럼 정의
// 				var _hidYn   = _col.hiddenValColumnCd; if(_hidYn == "Y") {_hidYn = 0;} if(_cTp == "Hidden") {_cTp = "Text"; _hidYn = 1;}	// 기존소스
				var _hidYn   = _col.displayYn; 
				
				if(_hidYn == "Y"){
					_hidYn = 0;
				}else{
					_hidYn = 1;
				}
				
				if(_cTp == "Hidden"){
					_cTp = "Text"; 
					_hidYn = 0;
				}
				
				var _mergeYn = _col.mergeYn; if(_mergeYn == "") {_mergeYn = 0;}
				var _sNm     = ""+convCamel(_col.columnCd);
				var _fmt     = ""; 
				/*
				 	if(_sNm.indexOf("Ymd") > -1) {
				 		_fmt = "Ymd"; 
				 	}else if(_sNm.indexOf("Ym") > -1) {
				 		_fmt = "Ym";
				 	}
				*/
				//수정 - 2020.08.19 kosh
				if(_col.cType == "D") {
					_fmt = "Ymd";
				} else if (_col.cType == "M") {
					_fmt = "Ym";
				} else if (_col.cType == "N") {
					_hidYn = 1;
				} else if (_col.cType == "I") {
					_cTp = "Int"
				    _align = "Right;"
				} else if (_col.cType == "A") {
					_align = "Left;"
				}
				
				var _pkTp    = _col.pkType;
				var _notNull = _col.notNullYn;
				var _readOnlyYn = _col.readOnlyYn;
				var _insertEd = 1;
				var _updatEd = 1;
				
				// seq일 경우 _sqList에 
				if(_pkTp == "S") {
					if(_sqList != "") {
						_sqList += "|";
					}
					_sqList += _col.columnCd;
				}
				
				// pk일경우 _pkList에 |컬럼명 형식으로 붙임 - 업데이트 딜리트 구문에서 사용
				if(_pkTp == "P") {
					if(_pkList != "") {
						_pkList += "|";
					}
					_pkList += _col.columnCd; 
					_pkTp = "1";
				} else {
					_pkTp = "0";
				}
				// _notNull 널이 아닌 컬럼일경우 키필드 지정
				
				if(_pkTp != "1") {
					if(_notNull == "Y") {
						_pkTp = "1";
					}
				}
				
				
				// 양식다운로드시 필요한 컬럼정의
				if(_hidYn == 0) {
					if(_templateCols != "") {_templateCols += "|";}
					_templateCols += _sNm;
					_templateColsLen++;
				}
				// 필수 입력 컬럼 정의
				if(_pkTp == "1" && _hidYn == 0) {
					if(_templateNames != "") {_templateNames += ", ";}
					_templateNames += _col.columnNm;
					_updatEd = 0;
				}
				
				if(_selQuery != "") {_selQuery += ",";}
				// 셀렉트 문에 들어갈 컬럼 정의
				if(_col.cryptKey == "twoWay") {
					// 암호화 컬럼 일경우 암호화함께 표시
					_selQuery += _col.columnCd+"|"+_col.cryptKey;
				} else {
					_selQuery += _col.columnCd+"|";
				}
				
				// 디폴트 값입력 리스트 정의 {컬럼명:데이터} 형식의 JSON
				if(_col.hiddenValColumnCd != "") {
					_defaultVal.push({"id":_sNm, "val":replaceAll(_col.hiddenValColumnCd, "'", "")});
				}
				
				//console.log("saveName:::::"+_col.columnNm+"___ctype:::::"+_cTp);
				// 콤보박스 컬럼 정의 {컬럼명:공통코드}형식의 데이터
				if(_cTp == "Combo") {
					comboCols.push({"colName":_sNm, "comboCd":_col.popupType});
				}

				if(_cTp == "Month"){
					_cTp = "Date";
					_fmt = "Ym";
				}
				
				if(_readOnlyYn == "Y") {
					_insertEd = 0;
					_updatEd = 0;
				}
				
				if(_col.columnNm == "주민번호"){
					_col.columnNm = "주민등록번호";
					//_fmt = ["IdNo", "#"];
				}else if(_col.columnNm == "년차"){
					_col.columnNm = "조정년차";					
				}/* else if(_col.columnNm == "결혼여부"){
					_col.columnNm = "혼인여부";					
				}else if(_col.columnNm == "결혼기념일"){
					_col.columnNm = "혼인일";
				} */else if(_col.columnNm == "신장"){
					_col.columnNm = "키";
				}else if(_col.columnNm == "체중"){
					_col.columnNm = "몸무게";
				}
				
				var colPeoperties = {
					 Header      : _col.columnNm
					,Type        : _cTp
					,Hidden      : _hidYn
					,Width       : 90
					,Align       : _align
					,ColMerge    : _mergeYn
					,SaveName    : _sNm
					,KeyField    : _pkTp
					,Format      : _fmt
					,PointCount  : 0
					,UpdateEdit  : _updatEd
					,InsertEdit  : _insertEd
					,EditLen     : _col.limitLength
				};

				// 체크 박스 일경우 디폴트 값을 0/1이 아닌 Y/N으로 정의
				if(_cTp == "CheckBox") {
					colPeoperties.TrueValue = "Y";
					colPeoperties.FalseValue = "N";
				}
								
				//성명 인사정보 업로드할 경우 현업의 요청으로 메뉴 순서 강제로 조정되게 수정(2019.04.02) 구분/성명/사번/시작일/종료일/표기명
				if(_col.empTable == "THRM101" && _col.colSeq == 2){
					initdata1.Cols.push(
						{Header:"소속",		Type:"Text",    	Hidden:0,   				Width:90,   		Align:"Left", ColMerge:0, SaveName:"orgNm", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
						{Header:"성명",		Type:"Popup",    	Hidden:0,   				Width:70,   		Align:"Center", ColMerge:0, SaveName:"empName", KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }		
					);
					initdata1.Cols.push(colPeoperties);
				} else {
					initdata1.Cols.push(colPeoperties);
				}

				//입사일 퇴사일 설정
				if(colPeoperties.SaveName == "empYmd"){
					colPeoperties.EndDateCol = "retYmd";
				}
				if(colPeoperties.SaveName == "retYmd"){
					colPeoperties.StartDateCol = "empYmd";
				}

				// JY 조회조건 추가
				
				if(_col.conditionYn == "Y"){
					
					if(_selMenuQuery != "") {_selMenuQuery += ",";}
					if(_selMenuQuery2 != "") {_selMenuQuery2 += ",";}
					// 셀렉트 문에 들어갈 컬럼 정의
					if(_col.cryptKey == "twoWay") {
						// 암호화 컬럼 일경우 암호화함께 표시
						_selMenuQuery += _sNm+"|"+_col.cryptKey;
						_selMenuQuery2 += _col.columnCd+"|"+_col.cryptKey;
					} else {
						_selMenuQuery += _sNm+"|";
						_selMenuQuery2 += _col.columnCd+"|";
					}
					
					sum++;
					
					if(sum == 1){
						//searchList.push("<table>");
					}
					
					if(sum%7 == 0){	
						//searchList.push("<tr>");
					}
					
					if(_cTp == "Text"){
						searchList.push(
								  //"<td>",
								  "<span>"+_col.columnNm+"</span>",
								  "<input id='"+_sNm+"' name='"+_sNm+"' type='"+_cTp+"' class='"+_cTp+"'/>"
								  //"</td>"
								);
					}
					
					if(_cTp == "Combo"){
						searchList.push(
								  //"<td>",
								  "<span>"+_col.columnNm+"</span>",
								  "<select id='"+_sNm+"' name='"+_sNm+"'></select>"
								  //"</td>"
								);
					}
					
					if(_cTp == "CheckBox"){
						searchList.push(
								  //"<td>",
								  "<span>"+_col.columnNm+"</span>",
								  "<input type='"+_cTp+"' id='"+_sNm+"View' name='"+_sNm+"View' style='vertical-align:middle;'/>",
								  "<input type='hidden' id='"+_sNm+"' name='"+_sNm+"' style='vertical-align:middle;'/>"
								  //"</td>"
								);
						
					}
					
					if(_cTp == "Date"){
						
						searchList.push(
								  //"<td>",
								  "<span>"+_col.columnNm+"</span>",
								  "<input type='text' id='"+_sNm+"' name='"+_sNm+"' class='date2 w80' maxlength='10'/>"
								  //"</td>"
								);
					}
					
					if(sum%6 == 0){
// 						searchList.push("</tr>");
					}
					
				}
			}
		}
		
		if(sum != 0){
			//searchList.push("<tr>");
			//searchList.push("<table>");
		}
		
		$("#searchMenu").html(searchList.join(""));
		
		if(sum == 0) {
			$("#searchMenu").hide();
		} else {
			$("#searchMenu").show();
		}
		
		var fixedColCnt = _pkList.split("|").length + 3;
		initdata1.Cfg = {FrozenCol:fixedColCnt,SearchMode:smLazyLoad,Page:22};

		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		
		// 콤보박스 셋팅
		for(var i=0; i<comboCols.length; i++) {
			
			var userCd1 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y",comboCols[i].comboCd), "");
			sheet1.SetColProperty(comboCols[i].colName,{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
			$("#"+comboCols[i].colName+"").html("<option value=''>전체</option>"+ userCd1[2]);
			
		}
		/*
		$("#sheet1-table").css("width", "1000");
		console.log($("#sheet1-table").css("width"));
		$("#sheet1-table").css("border", "1px solid black");
		//console.log("initdata1.Cols.length::::"+initdata1.Cols.length);
		*/
		sheetInit();
		var sheetWidth = parseInt(replaceAll($("#sheet1-table").css("width"), "px", ""));
		if(sheetWidth < 1190) {
			sheet1.FitColWidth();
		}
		//$("#sheet1-table").css("height", "100%");
		
/* 		if( $("#searchTableName").val() == "THRM100" ) {
			sheet1.SetColHidden("empName", 1);

		}else{
			sheet1.SetColHidden("empName", 0);
		}	 */	
		
		if( $("#searchTableName").val() == "THRM100" ) {
			sheet1.SetColHidden("empName", 1);
			//sheet1.SetColHidden("name", 1);
			sheet1.SetColHidden("sDelete", 1);

		}else{
			sheet1.SetColHidden("empName", 0);
			//sheet1.SetColHidden("name", 0);
			// if ( $("#searchTableName").val() == "THRM124" ){
			// 	sheet1.SetColHidden("sDelete", 1);
			// }else{
			// 	sheet1.SetColHidden("sDelete", 0);
			// }
		}	
		
		for(var i=0; i<_tblInfo.length; i++) {
			var _col = _tblInfo[i];
			
			if(tabNm == _col.empTable) {
				$.globalEval("var _cTp = _colType." + _col.cType + ";");
				var _sNm     = ""+convCamel(_col.columnCd);

				if(_cTp == "Month"){
					_cTp = "Date";
					_fmt = "Ym";
				}
				
				// JY 조회조건 추가
				if(_col.conditionYn == "Y"){
						if(_cTp == "Date"){
							$("#"+_sNm+"").datepicker2();
						}

				}
				
			}
			
		}
		// 콤보 변경할때 마다 그리드 사이즈 조정
		$(window).smartresize(sheetResize); sheetInit();
		
		// 저장 시 분할 저장 설정
		IBS_setChunkedOnSave("sheet1", {
			chunkSize : 50
		});
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
			$("#multiStatusCd").val(getMultiSelect($("#searchStatusCd").val()));
			
			var tabNm = $("#searchTableName").val(); // 테이블명
			
			if(tabNm == null){
				alert("담당자관리를 등록 해 주세요.");
				return;
			}
			
			for(var i=0; i<_tblInfo.length; i++) {
				var _col = _tblInfo[i];
				
				if(tabNm == _col.empTable) {
					$.globalEval("var _cTp = _colType." + _col.cType + ";");
					var _sNm     = ""+convCamel(_col.columnCd);
					
					// JY 조회조건 추가
					if(_col.conditionYn == "Y"){
							if(_cTp == "CheckBox"){
								$("#"+_sNm+"").val( $(':checkbox[name='+_sNm+'View]').is(":checked") ? "Y" : "N" );
							}

					}
					
				}
				
			}
			sheet1.DoSearch( "${ctx}/PsnalInfoUpload.do?cmd=getPsnalInfoUploadList",$("#sheet1Form").serialize()+"&selQuery="+_selQuery+"&selMenuQuery="+_selMenuQuery+"&selMenuQuery2="+_selMenuQuery2);
			
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			for(var i=0; i<_defaultVal.length; i++) {
				var tmp = _defaultVal[i];
				sheet1.SetCellValue(row, tmp.id, tmp.val);
			}
			break;
		case "Save":
			//if(!dupChk(sheet1,_pkList, true, true)){break;}
			// 필수값/유효성 체크
			if (!chkInVal()) break;
			IBS_SaveName(document.sheet1Form,sheet1);

			//sheet1.DoSave( "${ctx}/PsnalInfoUpload.do?cmd=savePsnalInfoUpload2" ,$("#sheet1Form").serialize()+"&selQuery="+_selQuery+"&pkList="+_pkList+"&sqList="+_sqList);
			
			sheet1.DoSave( "${ctx}/PsnalInfoUpload.do?cmd=savePsnalInfoUpload3" ,$("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		case "Copy":
			var row = sheet1.DataCopy();
		break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({
					TitleText:"*기록사항자료업로드"
						+ "\n*필수입력항목 : " + _templateNames
						+ "\n*파일로드시에는 이 행을 삭제해야 합니다."
					, SheetDesign:1,Merge:1,DownRows:0,DownCols:_templateCols,UserMerge:"0,0,1,"+_templateColsLen+""});
			//console.log(_tblInfo.length);
			break;
		case "LoadExcel":
			if($("#searchTableName").val() == ""){
				alert("구분을 선택해주세요.");
				break;
			}
			sheet1.RemoveAll();
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
		break;
		}
	}

	function sheet1_OnLoadExcel() {
		for(var j = 1; j < sheet1.LastRow()+1; j++) {
			for(var i=0; i<_defaultVal.length; i++) {
				var tmp = _defaultVal[i];
				sheet1.SetCellValue(j, tmp.id, tmp.val);
			}
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			if( $("#searchTableName").val() == "THRM100" ) {
				sheet1.SetColHidden("empName", 1);
				//sheet1.SetColHidden("name", 1);
				sheet1.SetColHidden("sDelete", 1);

			}else{
				sheet1.SetColHidden("empName", 0);
				//sheet1.SetColHidden("name", 0);
				
				// if ( $("#searchTableName").val() == "THRM124" ){
				// 	sheet1.SetColHidden("sDelete", 1);
				// }else{
				// 	sheet1.SetColHidden("sDelete", 0);
				// }
			}			

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	var gPRow = "";
    var pGubun = "";
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "empName" || sheet1.ColSaveName(Col) == "adviser") {
			
				if(!isPopup()) {return;}

				if(sheet1.ColSaveName(Col) == "adviser"){
					pGubun = "adviser";
				}else{
					pGubun = "empName";
				}
				gPRow = Row;
	            var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
	            if(rst != null){
// 	                sheet1.SetCellValue(Row, "sabun",		rst["sabun"]);
// 	                sheet1.SetCellValue(Row, "name",		rst["name"]);
// 					sheet1.SetCellValue(Row, "orgCd",		rst["orgCd"]);
// 		        	sheet1.SetCellValue(Row, "orgNm",		rst["orgNm"]);
	            }
			} else {
				for(var i = 0 ; i < _tblInfo.length ; i++) {
					if($("#searchTableName").val() == _tblInfo[i].empTable && sheet1.ColSaveName(Col) == convCamel(_tblInfo[i].columnCd)) {
						_selInfo = _tblInfo[i];
						empInfoPopup(convCamel(_selInfo.columnCd), _selInfo.popupType);
					}
				}
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(rv) {

		var popPrefix = "", popSurfix = "", relPrefix = "", relSurfix = "Cd";

		if(rv["fileCheck"] == "exist"){
			sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">다운로드</a>');
			sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
		}else{
			sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">첨부</a>');
			sheet1.SetCellValue(gPRow, "fileSeq", "");
		}
		if( pGubun == "adviser" ){
	        sheet1.SetCellValue(gPRow, "adviser",   rv["name"] );
	        sheet1.SetCellValue(gPRow, "adviserSabun",   rv["sabun"] );
		}else if( pGubun == "empName" ){
            sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
            sheet1.SetCellValue(gPRow, "empName",		rv["name"] );
            sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
        } else {
        	if(_selInfo.popupType=="POST"){
				$("#"+pGubun.objid).val(rv["zip"]);

				if($("#searchTableName").val() === 'THRM123') {
					if(sheet1.GetCellValue(gPRow, "addType") === '4') {
						// 영문주소 입력인 경우
						sheet1.SetCellValue(gPRow, "addr1", rv["resDoroFullAddrEng"]);
						sheet1.SetCellValue(gPRow, "addr2", rv["detailAddr"]);
					} else {
						sheet1.SetCellValue(gPRow, "addr1", rv["doroFullAddr"]);
						sheet1.SetCellValue(gPRow, "addr2", rv["detailAddr"]);
					}
				}
			}else if(_selInfo.popupType == "ORG" || _selInfo.popupType == "LOCATION" || _selInfo.popupType == "JOB"){
				popCd = convCamel(empInfo.popupType)+"Cd";
				popNm = convCamel(empInfo.popupType)+"Nm";
			}
			else{
				popCd = "code";
				popNm = "codeNm"
			}

			var relcolcds = (convCamel(_selInfo.relColumnCd)+","+pGubun.objid).split(",");
			for(var i in relcolcds){
				if(!relcolcds[i])continue;
				var colid = relcolcds[i];//convCamel(relcolcds[i]+"");
				var popVal = rv[popPrefix +""+ relSurfix];

				if(colid.substring(colid.length-2) == "Cd"){
					popVal = rv[popCd];
				}else if(colid.substring(colid.length-2) == "Nm"){
					popVal = rv[popNm];
				}else{
					for(var key in rv){
						var t_colid = colid.toLowerCase();
						var t_key = key.toLowerCase();
						if(t_colid.length == key.length && t_colid == t_key){
							popVal = rv[key];
							break;
						}else if(t_colid.length != key.length && t_colid.indexOf(t_key) == (t_colid.length-t_key.length-1)){
							popVal = rv[key];
							break;
						}
							//homeAddr1 9-4-1
							//addr1
					}
				}

//				$("#"+colid).val(popVal);
//				if($("#v_"+colid))$("#v_"+colid).val(popVal);
				sheet1.SetCellValue(gPRow, colid, popVal);
			}
        }
	}

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{
			gPRow = Row;
			if(sheet1.ColSaveName(Col) == "btnFile"){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					var authPgTemp="${authPg}";
					var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp, param, "740","620");
// 					if(rv != null){
// 						if(rv["fileCheck"] == "exist"){
// 							sheet1.SetCellValue(Row, "btnFile", '<a class="basic">다운로드</a>');
// 							sheet1.SetCellValue(Row, "fileSeq", rv["fileSeq"]);
// 						}else{
// 							sheet1.SetCellValue(Row, "btnFile", '<a class="basic">첨부</a>');
// 							sheet1.SetCellValue(Row, "fileSeq", "");
// 						}
// 					}
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	//파일 신청 끝
	
	function empInfoPopup(objid, popuptype){
		pGubun = {"objid":objid};
		switch(popuptype){
			case "POST":
				let url = '/ZipCodePopup.do?cmd=viewZipCodeLayer&authPg=${authPg}';
				let postArgs = null;

				// 영문 주소 입력인 경우
				if($("#searchTableName").val() === 'THRM123' && sheet1.GetCellValue(gPRow, "addType") === '4')
					postArgs = {"engAddrUseStatus": 'Y'};

				let postLayer = new window.top.document.LayerModal({
					id : 'zipCodeLayer'
					, url : url
					, parameters: postArgs
					, width : 740
					, height : 620
					, title : '우편번호 검색'
					, trigger :[
						{
							name : 'zipCodeLayerTrigger'
							, callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				postLayer.show();
				break;
			case "JOB":
				let jobLayer = new window.top.document.LayerModal({
					id : 'jobSchemeLayer'
					, url : '/Popup.do?cmd=viewJobSchemeLayer&authPg=R'
					, parameters : {
						searchJobType : '10030'
					}
					, width : 740
					, height : 520
					, title : '직무분류표 조회'
					, trigger :[
						{
							name : 'jobSchemeTrigger'
							, callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				jobLayer.show();
				break;
			case "ORG":
				let orgArgs = { searchEnterCd: sheet1.GetCellValue("1", "enterCd") };
				let orgLayer = new window.top.document.LayerModal({
					id : 'orgTreeLayer',
					url : '/Popup.do?cmd=viewOrgTreeLayer',
					parameters: orgArgs,
					width : 740,
					height : 520,
					title : '조직도 조회',
					trigger: [
						{
							name: 'orgTreeLayerTrigger',
							callback: function(rv) {
								getReturnValue(rv)
							}
						}
					]
				});
				orgLayer.show();

				break;
			case "LOCATION":
				openPopup("/LocationCodePopup.do?cmd=viewLocationCodePopup&authPg=R", "", "740","520");
				break;
			default:
				let defaultArgs = {"codeNm" : $("#"+objid).val(),"grpCd":popuptype};
				if(popuptype.indexOf(".")==-1) {
					let layerModal = new window.top.document.LayerModal({
						id : 'commonCodeLayer',
						url : '/CommonCodeLayer.do?cmd=viewCommonCodeLayer&authPg=R',
						parameters: defaultArgs,
						width : 740,
						height : 620,
						title : "코드검색",
						trigger :[
							{
								name : 'commonCodeTrigger',
								callback : function(result){
									getReturnValue(result);
								}
							}
						]
					});
					layerModal.show();
				} else {
					empInfoDynamicPopup(objid,popuptype);
				}
		}
	}
	
	function empInfoDynamicPopup(objid,popuptype){
		var pobjid = convCamel(popuptype.substring(0,popuptype.indexOf(".")));

		if($("#"+pobjid).val() == ""){
			alert(($("#"+pobjid).attr("title"))+"을(를) 먼저 입력후 수행하세요.");
			$("#"+pobjid).select();
		}else{
			//$("#"+pobjid).
			//empInfoPopup(objid,)
		}
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet1.GetCellValue(i, "retYmd") != null && sheet1.GetCellValue(i, "retYmd") != "") {
				var sdate = sheet1.GetCellValue(i, "empYmd");
				var edate = sheet1.GetCellValue(i, "retYmd");
				if (parseInt(sdate) > parseInt(edate)) {
					alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
					sheet1.SelectCell(i, "retYmd");
					return false;
				}
			}
		}
		return true;
	}
</script>


</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" />
				
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span>구분</span>
				<select id="searchTableName" name="searchTableName" onChange="initDynamicSheetInfo();"></select>
				<span><tit:txt mid='104472' mdef='재직상태'/></span>
				<select id="searchStatusCd" name="searchStatusCd" multiple></select>
				<span>사번/성명</span>
				<input id="searchSaNm" name="searchSaNm" type="text" class="text"/>
				<a href="javascript:doAction1('Search');" class="button">조회</a>
			</td>
		</tr>
		<tr id="searchMenu"></tr>
		</table>
		</div>
	</div>
	
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">인사정보(업로드)</li>
			<li class="btn">
				<a href="javascript:doAction1('DownTemplate')" 	class="btn outline_gray authR">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="btn outline_gray authR">업로드</a>
				<a href="javascript:doAction1('Insert');" 		class="btn outline_gray authA" id="btnInsert">입력</a>
<!-- 				<a href="javascript:doAction1('Copy');" 		class="basic authA">복사</a> -->
				<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline_gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>