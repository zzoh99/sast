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
		    $("#searchOrgNm").html(arg["searchOrgNm"]);
		    $("#searchSabunName").val(arg["searchSabunName"]);
	    }

		//평가명 변경 시
		$("#searchAppraisalCd,#searchAppStatus").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});
	});
	
	
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제|\n삭제",		Type:"${sDelTy}",	Hidden:1,				Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			//{Header:"\n선택|\n선택",								Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"chk",				KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1,				Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"조직코드|조직코드",	Type:"Text",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"조직|조직",			Type:"Text",		Hidden:0,					Width:100,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"사번|사번",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:1,				UpdateEdit:0,	InsertEdit:0},
			{Header:"성명|성명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:1},

			{Header:"시작일|시작일",		Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",UpdateEdit:0, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"종료일|종료일",		Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:1,	Format:"Ymd",UpdateEdit:0, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"기준일|기준일",		Type:"Date",		Hidden:0,  					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"cdate",		KeyField:1,	Format:"Ymd",UpdateEdit:0, 	InsertEdit:0,	 PointCount:0,   EditLen:10 },
			{Header:"입사일|입사일",		Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"empYmd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"퇴사일|퇴사일",		Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"retYmd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header:"비고|비고",			Type:"Text",		Hidden:1,					Width:350,	Align:"Left",	ColMerge:1,	SaveName:"note",		KeyField:0,				UpdateEdit:0,	InsertEdit:1, 	 EditLen:1000},
			{Header:"평가ID",				Type:"Text",		Hidden:1,					Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:1 },
			{Header:"mailId|mailId",		Type:"Text",		Hidden:1,					Width:10,	Align:"Left",	ColMerge:1,	SaveName:"mailId",		KeyField:0},
			{Header:"평가대상여부",			Type:"Text",		Hidden:1,					Width:10,	Align:"Left",	ColMerge:1,	SaveName:"targetYn",	KeyField:0},
			//appraisalCd
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		var appStatusList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","P20017"), ""); // 평가상태
		sheet1.SetColProperty("appStatusCd",	{ComboText:"|"+appStatusList[0], 	ComboCode:"|"+appStatusList[1]} );
		$("#searchAppStatus").html("<option value=''>전체</option>"+appStatusList[2]);
		var appraisalCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListByIntern",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();
		
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	function doAction1(sAction){
		//removeErrMsg();
		switch(sAction){
		case "Search":		//조회
			sheet1.DoSearch("${ctx}/InternAppEvaluatorMgr.do?cmd=getInternAppEvaluatorMgrListPop", $("#sheet1Form").serialize());
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
				  "targetYn"	  : sheet1.GetCellValue(arrRow[idx], "targetYn"),
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
	
	function clearCode(num) {
		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
			//doAction1("Search");
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
		<div class="sheet_search outer">
            <div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td>
							<span>평가상태</span>
							<select name="searchAppStatus" id="searchAppStatus">
							</select>
						</td>
						<td>
							<span>조직</span>
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" readonly/>
							<a onclick="javascript:popup('org')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
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