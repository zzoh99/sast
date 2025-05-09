<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>평가자</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var isSave = false;

	$(function() {
		$(".close, #close").click(function() {
			//if(isSave) top.opener.doAction1("Search");
			p.self.close();
		});

		var arg = p.popDialogArgumentAll();
	    if( arg != undefined ) {
		    $("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
		    $("#searchAppStepCd").val(arg["searchAppStepCd"]);
		    $("#searchGroupCd").val(arg["searchGroupCd"]);
		    $("#searchOrgNm").html(arg["searchOrgNm"]);
		    $("#searchSabunName").val(arg["searchSabunName"]);
	    }

	    if ($("#searchAppraisalCd").val() == "") {
			alert("선택한 평가가 존재하지 않습니다. \n팝업을 닫고 평가를 선택하시기 바랍니다.");
			p.self.close();
		}
	    
	    $("#searchSabunName").bind("keyup", function(e) {
	    	if (e.keyCode == "13") {
	    		doAction1("Search");
	    	}
	    })
	});
	
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
			{Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			<!--{Header:"삭제"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },-->
			{Header:"선택"			,Type:"DummyCheck",	Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			<!--{Header:"상태"			,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },-->

			{Header:"사번"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"성명"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"소속"			,Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹"			,Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"직책"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"비고"			,Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			
			
			{Header:"평가ID"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"평가단계"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appStepCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"평가소속코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appOrgCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가소속"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사원번호"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위코드"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikweeCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"직급코드"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikgubCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"직책코드"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikchakCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"직위"			,Type:"Text",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:1,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직코드"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
  		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	function doAction1(sAction){
		//removeErrMsg();
		switch(sAction){
		case "Search":		//조회
			sheet1.DoSearch("${ctx}/AppEvaluatorMgr.do?cmd=getAppEvaluatorMgrListPop", $("#sheet1Form").serialize());
			break;
		case "Down2Excel":	//엑셀내려받기
			sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;
		case "chose":	//선택
			setValue();
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}

	function setValue() {
		var rv = new Array();
		var list = new Array();
		var sRow = sheet1.FindCheckedRow("chk");
		var arrRow = sRow.split("|");
		
		for(var idx = 0; idx < arrRow.length; idx++) {
			list.push({
				  "sabun"	  	  : sheet1.GetCellValue(arrRow[idx], "sabun"),		
				  "name"	  	  : sheet1.GetCellValue(arrRow[idx], "name"),		
				  "orgNm"	 	  : sheet1.GetCellValue(arrRow[idx], "orgNm"),		
				  "appGroupNm"	  : sheet1.GetCellValue(arrRow[idx], "appGroupNm"),
				  "jikchakCd"	  : sheet1.GetCellValue(arrRow[idx], "jikchakCd"),
				  "jikweeCd"	  : sheet1.GetCellValue(arrRow[idx], "jikweeCd"),
				  "jikchakNm"	  : sheet1.GetCellValue(arrRow[idx], "jikchakNm"),
				  "jikweeNm"	  : sheet1.GetCellValue(arrRow[idx], "jikweeNm"),
				  "note"	  	  : sheet1.GetCellValue(arrRow[idx], "note"),		              
				  "appraisalCd"	  : sheet1.GetCellValue(arrRow[idx], "appraisalCd"),
			});
		}
		
		rv["LIST"] = JSON.stringify(list);
		p.popReturnValue(rv);
		p.window.close();
	}
	
	function popup(opt){
		pGubun = opt;
		if(opt == "org"){
			openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");	
		} else if (opt == "group") {
			var args = new Array();
			args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
			//pGubun = "AppPeopleMgrPop";
			openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "550","520");		
			//openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");
		}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "org") {
	    	$("#searchOrgNm").val(rv["orgNm"]);
	    	doAction1("Search");
	    } else if (pGubun == "group") {
	    	$("#searchGroupCd").val(rv["appGroupNm"]);
	    	doAction1("Search");
	    }
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>피평가자</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" name="searchAppraisalCd" id="searchAppraisalCd" value="">
		<input type="hidden" name="searchGroupCd" id="searchGroupCd" value="">
		<input type="hidden" name="searchSabun" id="searchSabun" value="">

		<div class="sheet_search outer">
            <div>
            <table>
            <tr>
				<td>
					<span>성명/사번</span>
					<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
				</td>
				<td>
					<span>평가소속</span>
					<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" readonly/>
					<a onclick="javascript:popup('org')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
				</td>
				</td>
				<td>
					<span>평가그룹</span>
					<input id="searchGroupCd" name="searchGroupCd" type="text" class="text" readonly/>
					<a onclick="javascript:popup('group')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
					<!-- <select name="searchGroupCd" id="searchGroupCd"></select> -->
				</td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
                </td>
            </tr>
            </table>
            </div>
        </div>
		</form>
		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">피평가자</li>
				<li class="btn">
					<!-- <a href="javascript:doAction1('chose')" class="basic authA">선택</a> -->
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr");</script>
		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:setValue();" class="pink large">확인</a>
				<a id="close" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>