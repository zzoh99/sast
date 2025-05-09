<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var ssnSearchType = "${ssnSearchType}";
	$(function() {
		var arrAppraisalCd = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList;
		var conCode		= convCode( arrAppraisalCd, "");
		$("#searchAppraisalCd").html(conCode[2]);
		var grpCds = "H20030";
	    codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
	    $("#searchJikweeCd").html("<option></option>" + codeLists["H20030"][2]);
	    
	    
	    $("#searchAppraisalCd").bind("change", function(e) {
	    	var selectYear = "";
        	var basicInfo = ajaxCall("${ctx}/AppEvalCommissioner.do?cmd=getAppEvalCommissionerAppraisalYy", $("#srchFrm").serialize(), false);
    		if (basicInfo.DATA != null) {
    			selectYear = basicInfo.DATA.appraisalYy;
    		} else {
	    		alert("평가명의 기준정보를 가져올 수 없습니다.")
	    		return false;
	    	}
	    	
	    	initSheet(selectYear)
	    })
	    
	    $("#searchSabunName").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
	    
	    $("#searchAppraisalCd").change();
	});
	
	function initSheet(pSelectYear) {
		sheet1.Reset();
		var initdata = {};
		initdata.Cfg = {FrozenCol:15, SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			//{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			//{Header:"\n삭제|\n삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			//{Header:"\n선택|\n선택",								Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"chk",				KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"선택",		Type:"DummyCheck",	Hidden:1,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"구분",			Type:"Text",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appMethodNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가그룹\nNo",	Type:"Int",		Hidden:0,		Width:50,	Align:"Right",	ColMerge:0,	SaveName:"rn1",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"1차평가\n그룹\nNo",Type:"Int",		Hidden:0,		Width:50,	Align:"Right",	ColMerge:0,	SaveName:"rn2",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가그룹",	Type:"Text",		Hidden:0,		Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appGroupNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},			
			{Header:"본부",		Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm1",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"실",		Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm2",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"팀",		Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm3",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"사번",		Type:"Text",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직책",		Type:"Text",		Hidden:0,		Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직위",		Type:"Text",		Hidden:0,		Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직위년차",	Type:"Text",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeYear",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"체류연한",	Type:"Text",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"stayCnt",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header:"입사일",	Type:"Date",		Hidden:0,		Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,				Format:"Ymd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"1차평가자",Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appSabunNm1",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"2차평가자",Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appSabunNm2",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"1차평가\n(순위)",Type:"Int",	Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"app1stRk",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"2차 평가\n(등급)",Type:"Combo",Hidden:0,		Width:60,	Align:"Center",		ColMerge:0,		SaveName:"app2ndClassCd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"본부\n(조정건의)",Type:"Combo",Hidden:0,		Width:60,	Align:"Center",		ColMerge:0,		SaveName:"appReviClassCd",		UpdateEdit:0,	InsertEdit:0},
			{Header:"전사\n(1차)",Type:"Combo",		Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"appBossClassCd1",		UpdateEdit:0,	InsertEdit:0},
			{Header:"전사\n(최종)",Type:"Combo",	Hidden:0,		Width:60,		Align:"Center",		ColMerge:0,		SaveName:"appBossClassCd2",		UpdateEdit:0,	InsertEdit:0},
			
			{Header:"",		Type:"Text",	Hidden:1,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"userNote",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"",		Type:"Text",	Hidden:1,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"",		Type:"Text",	Hidden:1,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"app2ndPoint",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"",		Type:"Text",	Hidden:1,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appReviPoint",KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"",		Type:"Text",	Hidden:1,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"allPointBak",KeyField:0,				UpdateEdit:0,	InsertEdit:0},
		];
		var year = Number(pSelectYear);
		year = year - 5;
		for (var i=1;i<=5;i++) {
			initdata.Cols.push({Header:(year + i) + "\n평가등급",	Type:"Text",	Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"finClassCd"+i,		KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"직급비고2"+i,				Type:"Text",	Hidden:1,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"note"+i,		KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		}
		initdata.Cols.push({Header:"체류기한\n충족여부",Type:"Text",	Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"stayOx",		KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		for (var i=1;i<=5;i++) {
			initdata.Cols.push({Header:(year + i) + "\n승진포인트",	Type:"Text",	Hidden:0,		Width:70,	Align:"Center",	ColMerge:0,	SaveName:"finPoint"+i,		KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		}
		initdata.Cols.push({Header:"가감",			    Type:"Int",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"addAubtraPoint",KeyField:0,			UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:"승진포인트\n계",	Type:"Text",	Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"allPoint",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:"승진포인트\n기준",	Type:"Text",	Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"maxPoint",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:"승진포인트\n충족여부",Type:"Text",	Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pointOx",		KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:"승진\n후보자",  	Type:"Text",	Hidden:0,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"promotionOx",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:"승진건의\n(우선순위)",Type:"Int",	Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"raiseSuggRk",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:"비고",			    Type:"Text",	Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"",			KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCd&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "전체"); // 평가등급
		sheet1.SetColProperty("app2ndClassCd",	{ComboText:"|"+classCdList[0], 		ComboCode:"|"+classCdList[1]} );
		sheet1.SetColProperty("appReviClassCd",	{ComboText:"|"+classCdList[0], 		ComboCode:"|"+classCdList[1]} );
		sheet1.SetColProperty("appBossClassCd1",{ComboText:"|"+classCdList[0], 		ComboCode:"|"+classCdList[1]} );
		sheet1.SetColProperty("appBossClassCd2",{ComboText:"|"+classCdList[0], 		ComboCode:"|"+classCdList[1]} );
		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!checkList()) return ;
			sheet1.DoSearch( "${ctx}/AppEvalCommissioner.do?cmd=getAppEvalCommissionerList", $("#srchFrm").serialize() );
			break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":  //엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "Save":		//저장
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppEvalCommissioner.do?cmd=saveAppEvalCommissioner", $("#srchFrm").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
    	
        try {
            if (Msg != "") {
                alert(Msg);
            }
            var ssnGrpCd = "${ssnGrpCd}";
			var firstRow = sheet1.GetDataFirstRow();
			var lastRow	 = sheet1.GetDataLastRow();
			for (var i=firstRow; i<=lastRow;i++) {
				var userNote = sheet1.GetCellValue(i,"userNote");
				//var befFinClassCd = sheet1.GetCellValue(i,"finClassCd4");
				var note5 = sheet1.GetCellValue(i,"note5");
				var note4 = sheet1.GetCellValue(i,"note4");
				var note3 = sheet1.GetCellValue(i,"note3");
				var note2 = sheet1.GetCellValue(i,"note2");
				var note1 = sheet1.GetCellValue(i,"note1");
				// 현재 직위에 관련된 평가
				if (userNote) {
					var bcc = "#f7f8e0";
					sheet1.SetCellBackColor(i, "finClassCd5", bcc);
					sheet1.SetCellBackColor(i, "finPoint5", bcc);
					if (userNote == note4) {
						sheet1.SetCellBackColor(i, "finClassCd4", bcc);
						sheet1.SetCellBackColor(i, "finPoint4", bcc);
					} 
					if (userNote == note3) {
						sheet1.SetCellBackColor(i, "finClassCd3", bcc);
						sheet1.SetCellBackColor(i, "finPoint3", bcc);
					} 
					if (userNote == note2) {
						sheet1.SetCellBackColor(i, "finClassCd2", bcc);
						sheet1.SetCellBackColor(i, "finPoint2", bcc);
					} 
					if (userNote == note1) {
						sheet1.SetCellBackColor(i, "finClassCd1", bcc);
						sheet1.SetCellBackColor(i, "finPoint1", bcc);
					} 
				}
				// 본부(조정건의)가 2차평가에서 올랐으면 빨간색 내렸으면 파란색
				var app2ndPoint = sheet1.GetCellValue(i,"app2ndPoint");
				var appReviPoint = sheet1.GetCellValue(i,"appReviPoint");
				if (app2ndPoint < appReviPoint) {
					sheet1.SetCellFontColor(i, "appReviClassCd", "red");
				} else if (app2ndPoint > appReviPoint) {
					sheet1.SetCellFontColor(i, "appReviClassCd", "blue");
				} else {
					sheet1.SetCellFontColor(i, "appReviClassCd", "");
				}
					
				
				if (ssnGrpCd == "11") { // 전사:대표이사
					sheet1.SetCellEditable(i, "appBossClassCd1", 1);
					sheet1.SetCellEditable(i, "appBossClassCd2", 1);
				} else if (ssnGrpCd == "20") { // 본부:임원
					sheet1.SetCellEditable(i, "appReviClassCd", 1);
					sheet1.SetCellEditable(i, "addAubtraPoint", 1);
					sheet1.SetCellEditable(i, "raiseSuggRk", 1);
				}
			}
			
			
            sheetResize();
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }


	function popup(opt){
		pGubun = opt;
		if(opt == "org"){
			openPopup("/Popup.do?cmd=orgTreePopup&authPg=R&authYn=Y", "", "740","520");	
		}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "org") {
	    	$("#searchOrgCd").val(rv["orgCd"]);
	    	$("#searchOrgNm").val(rv["orgNm"]);
	    	$("#searchOrgSdate").val(rv["sdate"]);
	    }
	}
	
	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}

 		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){

				alert($(this).parent().prepend().find("span:first-child").text()+"은 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});

		return ch;
	}
	
	function clearCode(num) {
		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
			//doAction1("Search");
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg);
			}
				//doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function sheet1_OnChange(Row, Col, Value) {
		if (sheet1.ColSaveName(Col) == "appReviClassCd") { // 본부(조정건의):색변경
			if (!Value) {
				return;
			}
			var changePerformancePoint = 0;
			var basicInfo = null;
			if (Value) {
				basicInfo = ajaxCall("${ctx}/AppEvalCommissioner.do?cmd=getAppEvalCommissionerPerformancePoint"+"&appClsasCd="+Value, $("#srchFrm").serialize(), false);
	    		if (basicInfo.DATA != null) {
	    			changePerformancePoint = basicInfo.DATA.performancePoint;
	    		}
			}
    		
			var app2ndPoint = sheet1.GetCellValue(Row,"app2ndPoint") ? sheet1.GetCellValue(Row,"app2ndPoint") : 0;
			var appReviPoint = changePerformancePoint;
			if (app2ndPoint < appReviPoint) {
				sheet1.SetCellFontColor(Row, "appReviClassCd", "red");
			} else if (app2ndPoint > appReviPoint) {
				sheet1.SetCellFontColor(Row, "appReviClassCd","blue");
			} else {
				sheet1.SetCellFontColor(Row, "appReviClassCd","");
			}
		} else if (sheet1.ColSaveName(Col) == "addAubtraPoint") { // 가감:계산
			var allPointBak = sheet1.GetCellValue(Row,"allPointBak");
			var maxPoint = sheet1.GetCellValue(Row,"maxPoint");
			var stayOx = sheet1.GetCellValue(Row,"stayOx");
			var total = 0;
			// 승진포인트계 계산
			total += Value ? Number(Value) : 0;
			total += allPointBak ? Number(allPointBak) : 0;
			sheet1.SetCellValue(Row, "allPoint", total);
			
			if (maxPoint && maxPoint <= total) {
				sheet1.SetCellValue(Row, "pointOx", "O");	
			} else {
				sheet1.SetCellValue(Row, "pointOx", "");
			}
			if (stayOx == "O" && maxPoint && maxPoint <= total) {
				sheet1.SetCellValue(Row, "promotionOx", "O");
			} else if (stayOx == "O") {
				sheet1.SetCellValue(Row, "promotionOx", "X");
			} else {
				sheet1.SetCellValue(Row, "promotionOx", "");
			}
			
		} 
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd"/>		
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" class="required">
							</select>
						</td>
						<td>
							<span>조직</span>
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" readonly/>
							<a onclick="javascript:popup('org')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td>
							<span>직위구분</span>
							<select name="searchJikweeCd" id="searchJikweeCd">
							</select>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
							<li id="txt" class="txt"><tit:txt mid='112487' mdef='인사평가'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Save')" 	class="basic isFin">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic">다운로드</a>
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
