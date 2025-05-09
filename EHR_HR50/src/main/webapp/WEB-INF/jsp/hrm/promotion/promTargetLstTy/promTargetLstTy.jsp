<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var gPRow    = "";
		var pGubun   = "";
		var initdata = {};

		initdata.Cfg = {SearchMode:smGeneral,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No|No|No",										Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제|삭제",									Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태|상태",									Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"승진기준일|승진기준일|승진기준일",						Type:"Date",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"baseYmd",			KeyField:1, CalcLogic:"", Format:"Ymd", PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20 },
			{Header:"본부코드|본부코드|본부코드",							Type:"Text",  		Hidden:1, Width:130,	Align:"Left", 	ColMerge:0, SaveName:"hqOrgCd",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"본부|본부|본부",									Type:"Text",  		Hidden:0, Width:130,	Align:"Left", 	ColMerge:0, SaveName:"hqOrgNm",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"소속코드|소속코드|소속코드",							Type:"Text",  		Hidden:1, Width:130,	Align:"Left", 	ColMerge:0, SaveName:"orgCd",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"소속|소속|소속",									Type:"Text",  		Hidden:0, Width:130,	Align:"Left", 	ColMerge:0, SaveName:"orgNm",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"사번|사번|사번",									Type:"Text",  		Hidden:0, Width:80,		Align:"Center", ColMerge:0, SaveName:"sabun",			KeyField:1, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:30 },			
			{Header:"성명|성명|성명",									Type:"Popup", 		Hidden:0, Width:80,		Align:"Center", ColMerge:0, SaveName:"name",			KeyField:1, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:100},			
			{Header:"현직급코드|현직급코드|현직급코드",						Type:"Text",  		Hidden:1, Width:80,		Align:"Center", ColMerge:0, SaveName:"jikgubCd",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"현직급|현직급|현직급",								Type:"Text",  		Hidden:0, Width:80,		Align:"Center", ColMerge:0, SaveName:"jikgubNm",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"현직급승격일|현직급승격일|현직급승격일",					Type:"Date",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"currJikgubYmd",	KeyField:0, CalcLogic:"", Format:"Ymd", PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:20 },
			{Header:"년차|입사\n인정|입사\n인정",							Type:"Text",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"addJikgubYeoncha",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"년차|근속|근속",									Type:"Text",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"workJikgubYeoncha",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
			{Header:"년차|총|총",										Type:"Text",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"jikgubYeoncha",		KeyField:0, CalcLogic:"|addJikgubYeoncha|+|workJikgubYeoncha|", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			//{Header:"승진\n직급\n코드|승진\n직급\n코드|승진\n직급\n코드",		Type:"Text", 		Hidden:1, Width:80,		Align:"Center", ColMerge:0, SaveName:"tarJikgubCd",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
			{Header:"승진\n직급|승진\n직급|승진\n직급",						Type:"Combo", 		Hidden:0, Width:80,		Align:"Center", ColMerge:0, SaveName:"tarJikgubCd",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
			{Header:"군필여부|군필여부|군필여부",							Type:"Combo",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"armyYn",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 },
			{Header:"지체여부|지체여부|지체여부",							Type:"Text",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"delayGubun",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"생년월일|생년월일|생년월일",							Type:"Date",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"birYmd",			KeyField:0, CalcLogic:"", Format:"Ymd", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20 },
			{Header:"나이|나이|나이",									Type:"Text",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"age",				KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"그룹입사일|그룹입사일|그룹입사일",						Type:"Date",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"gempYmd",			KeyField:0, CalcLogic:"", Format:"Ymd", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20 },
			{Header:"소속입사일|소속입사일|소속입사일",						Type:"Date",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"empYmd",			KeyField:0, CalcLogic:"", Format:"Ymd", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20 },
			{Header:"근속년수|근속년수|근속년수",							Type:"Text",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"workPeriod",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"최종학교명|최종학교명|최종학교명",						Type:"Text",  		Hidden:0, Width:130,	Align:"Center", ColMerge:0, SaveName:"finalAcaNm",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"최종전공명|최종전공명|최종전공명",						Type:"Text",  		Hidden:0, Width:130,	Align:"Center", ColMerge:0, SaveName:"finalAcamajNm",	KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			
			{Header:"승격자격시험 합격여부|한자|여부",						Type:"Text",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"hanjaYn",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"승격자격시험 합격여부|한자|첨부파일",						Type:"Html",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"hanjaBtnFile",	KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"승격자격시험 합격여부|한자|첨부번호",						Type:"Text",		Hidden:1, Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hanjaFileSeq",	KeyField:0,	Format:"",	  PointCount:0,	UpdateEdit:1, InsertEdit:1,	EditLen:35 },
			
			{Header:"승격자격시험 합격여부|한국사|여부",						Type:"Text",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"histYn",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"승격자격시험 합격여부|한국사|첨부파일",					Type:"Html",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"histBtnFile",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"승격자격시험 합격여부|한국사|첨부번호",					Type:"Text",		Hidden:1, Width:100,	Align:"Center",	ColMerge:0,	SaveName:"histFileSeq",		KeyField:0,	Format:"",	  PointCount:0,	UpdateEdit:1, InsertEdit:1,	EditLen:35 },
			
			{Header:"승격자격시험 합격여부|어학|여부",						Type:"Text",  		Hidden:0, Width:60,		Align:"Center", ColMerge:0, SaveName:"langYn",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"승격자격시험 합격여부|어학|첨부파일",						Type:"Html",  		Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"langBtnFile",		KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:100 },
			{Header:"승격자격시험 합격여부|어학|첨부번호",						Type:"Text",		Hidden:1, Width:100,	Align:"Center",	ColMerge:0,	SaveName:"langFileSeq",		KeyField:0,	Format:"",	  PointCount:0,	UpdateEdit:1, InsertEdit:1,	EditLen:35 },
			{Header:"승격자격시험 합격여부|승격교육\n이수여부|승격교육\n이수여부",	Type:"CheckBox",	Hidden:0, Width:100, 	Align:"Center", ColMerge:0, SaveName:"traYn",			KeyField:0, CalcLogic:"", Format:"", 	PointCount:0, UpdateEdit:1, InsertEdit:1, Edit:1, TrueValue:"Y", FalseValue:"N" }
		];

		var curSysYear = "${curSysYear}";
 		var baseYear   = parseInt(curSysYear)+1;
		
		//승진기준일에서 년도에서 1씩 차감(5개년치 표시)
 		var printYear = "";
		for (var i=1; i<=5; i++) {
			printYear = "";
			printYear = parseInt(baseYear)-i;
			
			initdata.Cols.push({Header:"고과현황|"+printYear+"년|고과", Type:"Text", Hidden:0, Width:70, Align:"Center", ColMerge:0, SaveName:"mboPoint"+i, 	 	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 });
			initdata.Cols.push({Header:"고과현황|"+printYear+"년|업적", Type:"Text", Hidden:0, Width:70, Align:"Center", ColMerge:0, SaveName:"compPoint"+i, 	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 });
			initdata.Cols.push({Header:"고과현황|"+printYear+"년|역량", Type:"Text", Hidden:0, Width:70, Align:"Center", ColMerge:0, SaveName:"finalClassNm"+i,	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10 });
		}
		
		initdata.Cols.push({Header:"승진여부|승진여부|승진여부",			Type:"CheckBox",	Hidden:0, Width:100,  Align:"Center", ColMerge:0, SaveName:"targetYn",	KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, Edit:1, TrueValue:"Y", FalseValue:"N" });
		initdata.Cols.push({Header:"가발령\n여부|가발령\n여부|가발령\n여부",	Type:"CheckBox", 	Hidden:0, Width:100,  Align:"Center", ColMerge:0, SaveName:"ordYn",		KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, Edit:0, TrueValue:"Y", FalseValue:"N" });
		initdata.Cols.push({Header:"비고|비고|비고",					Type:"Text", 		Hidden:0, Width:200, Align:"Center",  ColMerge:0, SaveName:"note",		KeyField:0, CalcLogic:"", Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:500, MultiLineText:1 });

		IBS_InitSheet(sheet1, initdata);
		sheet1.SetEditable(true);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		sheet1.SetMergeSheet(msHeaderOnly);

		//군필여부
		sheet1.SetColProperty("armyYn", {ComboText:"Y|N", ComboCode:"Y|N"});
		
		// 직급코드
		var tarJikgubCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTarJikgubCdList", false).codeList, "전체");
		sheet1.SetColProperty("tarJikgubCd", {ComboText:"|"+tarJikgubCdList[0], ComboCode:"|"+tarJikgubCdList[1]});
		$("#searchTarJikgubCd").html(tarJikgubCdList[2]);
		$("#tarJikgubCd").html(tarJikgubCdList[2]);
		
		$(window).smartresize(sheetResize);
		
		sheetInit();

 		$("#searchBaseYmd").datepicker2(); // 조회조건 : 승진기준일
 		$("#baseYmd").datepicker2();	   // 승진기준일

 		$("#searchYear").val(baseYear);
 		$("#searchBaseYmd").val(baseYear+"-02-01");
 		$("#baseYmd").val(baseYear+"-02-01");
 		
		$("#searchYy, #searchBaseYmd, #tarJikgubCd, #searchSabunName").bind("keyup", function(event) {
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		// 숫자만 입력가능
 		$("#searchBaseYmd").keyup(function() {
 		     makeNumber(this, 'A');
 		});

		doAction1("Search");
	});
	
	function chkInVal() {
		if($("#searchYear").val() == "") {
			alert("승진년도를 입력하십시오.");
			$("#searchYear").focus();
			
			return false;
		}

		if($("#searchBaseYmd").val() == "") {
			alert("승진기준일을 입력하십시오.");
			$("#searchBaseYmd").focus();
			
			return false;
		}
		
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
// 			if (!chkInVal()) {
// 				break;
// 			}

			sheet1.DoSearch( "${ctx}/PromTargetLstTy.do?cmd=getPromTargetLstTyList", $("#srchFrm").serialize() );
			
			break;
		case "Save":
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/PromTargetLstTy.do?cmd=savePromTargetLstTy", $("#srchFrm").serialize());
			
			break;
		case "Insert":
			var r = sheet1.DataInsert(0);
			
			//승격자격시험 합격여부
			sheet1.SetCellValue(r, "hanjaBtnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			sheet1.SetCellValue(r, "hanjaYn", 'X');
			sheet1.SetCellValue(r, "histBtnFile",  '<btn:a css="basic" mid='110698' mdef="첨부"/>');
			sheet1.SetCellValue(r, "histYn",  'X');
			sheet1.SetCellValue(r, "langBtnFile",  '<btn:a css="basic" mid='110698' mdef="첨부"/>');
			sheet1.SetCellValue(r, "langYn",  'X');
			
			//군필여부
			sheet1.SetCellValue(r, "armyYn", "N");
			
			sheet1.SetCellValue(r, "sStatus", 'I');
			
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			
			break;
			
        case "callProcHrmPrmCreate": 
        	if( $("#tarJikgubCd").val() == "" ) {
        		alert("승진대상자 생성을 위한 승진대상직급을 선택하여 주십시오."); 
        		
        		break;
        	}
        	
        	if( $("#baseYmd").val() == "" ) {
        		alert("승진대상자 생성을 위한 승진기준일을 입력하여 주십시오."); 
        		
        		break;
        	}
        	
        	var params  = "baseYmd="+$("#baseYmd").val();
        		params += "&tarJikgubCd="+$("#tarJikgubCd").val();
        	if ( confirm("승진대상자를 생성하시겠습니까?") ) {
		    	var data = ajaxCall("${ctx}/PromTargetLstTy.do?cmd=prchrmPrmCreate", params, false);
				
		    	if(data.Result.Code == null) {
					alert("<msg:txt mid='alertCreateOk1' mdef='승진대상자 생성이 완료되었습니다.'/>");
					doAction1("Search");
		    	} else {
			    	alert(data.Result.Message);
		    	}
        	}
		   
		    break;
		    
        case "callProcHrmPrmpostCreate": 
        	if( $("#baseYmd").val() == "" ) {
        		alert("가발령처리를 위한 승진기준일을 입력하여 주십시오."); 
        		
        		break;
        	}
        	
        	var params = "ordYmd="+$("#baseYmd").val();
        	if ( confirm("가발령처리를 하시겠습니까?") ) {
		    	var data = ajaxCall("${ctx}/PromTargetLstTy.do?cmd=prcHrmPrmpostCreate", params, false);
				
		    	if(data.Result.Code == null) {
					alert("<msg:txt mid='alertCreateOk1' mdef='가발령처리가 완료되었습니다.'/>");
					doAction1("Search");
		    	} else {
			    	alert(data.Result.Message);
		    	}
        	}
		   
		    break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
			}

			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++) {
				if(sheet1.GetCellValue(r,  "hanjaFileSeq") == '') {
					sheet1.SetCellValue(r, "hanjaBtnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
					sheet1.SetCellValue(r, "sStatus", 'R');
				} else {
					sheet1.SetCellValue(r, "hanjaBtnFile", '<btn:a css="basic" mid='110922' mdef="다운로드"/>');
					sheet1.SetCellValue(r, "sStatus", 'R');
				}
				
				if(sheet1.GetCellValue(r,  "histFileSeq") == '') {
					sheet1.SetCellValue(r, "histBtnFile",  '<btn:a css="basic" mid='110698' mdef="첨부"/>');
					sheet1.SetCellValue(r, "sStatus", 'R');
				} else {
					sheet1.SetCellValue(r, "histBtnFile",  '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
					sheet1.SetCellValue(r, "sStatus", 'R');
				}
				
				if(sheet1.GetCellValue(r,  "langFileSeq") == '') {
					sheet1.SetCellValue(r, "langBtnFile",  '<btn:a css="basic" mid='110698' mdef="첨부"/>');
					sheet1.SetCellValue(r, "sStatus", 'R');
				} else {
					sheet1.SetCellValue(r, "langBtnFile",  '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
					sheet1.SetCellValue(r, "sStatus", 'R');
				}
			}
			
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}

				var args	= new Array();

				gPRow  = Row;
				pGubun = "employeePopup";

				var rv = openPopup("/Popup.do?cmd=employeePopup", args, "840","520");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
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

	var btnFileYn  = "";
	var btnFile    = "";
	var btnFileSeq = "";
	function sheet1_OnClick(Row, Col, Value) {
		try {
			if(sheet1.ColSaveName(Col) == "hanjaBtnFile"
			|| sheet1.ColSaveName(Col) == "histBtnFile"
			|| sheet1.ColSaveName(Col) == "langBtnFile") 
			{
				btnFileYn  = sheet1.ColSaveName(Col-1);
				btnFile    = sheet1.ColSaveName(Col);
				btnFileSeq = sheet1.ColSaveName(Col+1);
				
 				var param = [];
 					param["fileSeq"] = sheet1.GetCellValue(Row, btnFileSeq);
					
				if(sheet1.GetCellValue(Row, btnFile) != "") {
					if(!isPopup()) {return;}

					gPRow  = Row;
					pGubun = "fileMgrPopup";

					var authPgTemp="${authPg}";
					var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=promote", param, "740","620");
				}
			}
		} catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "employeePopup") {
			sheet1.SetCellValue(gPRow,"hqOrgCd",  	   (rv["hqOrgCd"]));
			sheet1.SetCellValue(gPRow,"hqOrgNm",  	   (rv["hqOrgNm"]));
			sheet1.SetCellValue(gPRow,"orgCd",    	   (rv["orgCd"]));
			sheet1.SetCellValue(gPRow,"orgNm",    	   (rv["orgNm"]));
			sheet1.SetCellValue(gPRow,"name",     	   (rv["name"]));
			sheet1.SetCellValue(gPRow,"sabun",    	   (rv["sabun"]));
			sheet1.SetCellValue(gPRow,"jikgubCd", 	   (rv["jikgubCd"]));
			sheet1.SetCellValue(gPRow,"jikgubNm", 	   (rv["jikgubNm"]));
			sheet1.SetCellValue(gPRow,"currJikgubYmd", (rv["currJikgubYmd"]));
			sheet1.SetCellValue(gPRow,"birYmd", 	   (rv["birYmd"]));
			sheet1.SetCellValue(gPRow,"gempYmd", 	   (rv["gempYmd"]));
			sheet1.SetCellValue(gPRow,"empYmd", 	   (rv["empYmd"]));
		} else if (pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist") {
				sheet1.SetCellValue(gPRow, btnFileYn, 'O');
				sheet1.SetCellValue(gPRow, btnFile, '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, btnFileSeq, rv["fileSeq"]);
			} else {
				sheet1.SetCellValue(gPRow, btnFileYn, 'X');
				sheet1.SetCellValue(gPRow, btnFile, '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, btnFileSeq, "");
			}
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>승진년도</th>
						<td>
<%-- 							<input id="searchYear" name="searchYear" type="text" size="10" value="${curSysYear}" class="date2 required"/> --%>
							<input id="searchYear" name="searchYear" type="text" size="10" value="" class="date2 required"/>
						</td>
						<th>승진기준일</th>
						<td>
<%-- 							<input id="searchBaseYmd" name="searchBaseYmd" type="text" class="text required date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" /></td> --%>
							<input id="searchBaseYmd" name="searchBaseYmd" type="text" class="text required date2" value="" /></td>
						</td>
						<th>직급코드</th>
						<td>
							<select id="searchTarJikgubCd" name="searchTarJikgubCd"></select>
						</td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">승진급대상자</li>

							<li class="btn">
								<span>승진대상직급</span>	<select id="tarJikgubCd" name="tarJikgubCd"></select>
<%-- 								<span>* 승진기준일</span>	<input  id="baseYmd"     name="baseYmd" maxlength="8" type="text" class="text date" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" /> --%>
								<span>승진기준일</span>	<input  id="baseYmd"     name="baseYmd" maxlength="8" type="text" class="text date" value="" />
								<a href="javascript:doAction1('callProcHrmPrmCreate');" 	class="button authA"><tit:txt mid='112692'   mdef='대상자생성'/></a>
								<a href="javascript:doAction1('callProcHrmPrmpostCreate');" class="button authA"><tit:txt mid='112692'   mdef='가발령처리'/></a>
								<a href="javascript:doAction1('Insert');" 		 			class="basic authA"><tit:txt  mid='104267'   mdef='입력'/></a>
								<a href="javascript:doAction1('Save');" 		 			class="basic authA"><tit:txt  mid='104476'   mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel');" 	 			class="basic authR"><tit:txt  mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
