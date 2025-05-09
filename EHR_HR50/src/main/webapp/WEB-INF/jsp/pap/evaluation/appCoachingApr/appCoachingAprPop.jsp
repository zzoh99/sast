<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>Coaching 내역 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {
		$(".close, #close").click(function() {
			p.self.close();
		});

		var arg = p.popDialogArgumentAll();
	    if( arg != undefined ) {
	    	$("#searchAppStepCds").val(arg["searchAppStepCds"]);
		    $("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
		    $("#searchSabun").val(arg["searchSabun"]);
		    $("#searchAppOrgCd").val(arg["searchAppOrgCd"]);
		    $("#searchAppSabun").val(arg["searchAppSabun"]);
		    $("#searchAppSeqCd").val(arg["searchAppSeqCd"]);
	    }
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"차수",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCdNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"성명",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"소속",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

			{Header:"입사일",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직위명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직급명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직책명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직급년차",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubYeuncha",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(0);sheet1.SetCountPosition(4);
		sheet1.SetUnicodeByte(3);

		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"차수",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCdNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"Coach",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appName",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"날짜",		Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"coaYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10	},
			{Header:"장소",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"coaPlace",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"내용",		Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1333, Wrap:1, MultiLineText:1},

			{Header:"수정가능여부",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"editable",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가ID",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가사번",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(0);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function doAction1(sAction){
		//removeErrMsg();
		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/AppCoachingApr.do?cmd=getAppCoachingAprList1", $("#sheet1Frm").serialize() ); break;
				break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			if ( Code != -1 && sheet1.RowCount() > 0 ) {
				// 피평가자 정보 setting
				var Row = 1;
				$("#iName").html( sheet1.GetCellValue(Row, "name") +"/"+ sheet1.GetCellValue(Row, "sabun") );
				$("#iOrgnm").html( sheet1.GetCellValue(Row, "appOrgNm"));
				$("#iEmpYmd").html( sheet1.GetCellText(Row, "empYmd"));
				$("#iJikgub").html( sheet1.GetCellValue(Row, "jikgubNm"));
				$("#iJikchak").html( sheet1.GetCellValue(Row, "jikchakNm"));
				$("#iJikgubYeuncha").html( sheet1.GetCellValue(Row, "jikgubYeuncha"));

				doAction2("Search");
			}

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function doAction2(sAction){
		//removeErrMsg();
		switch(sAction){
			case "Search":		//조회
				sheet2.DoSearch( "${ctx}/AppCoachingApr.do?cmd=getAppCoachingAprList2", $("#sheet1Frm").serialize() ); break;
				break;
		}
	}

	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>Coaching 내역</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="sheet1Frm" name="sheet1Frm" >
			<input type="hidden" id="searchAppStepCds" name="searchAppStepCds" value="" />
			<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
			<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
			<input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value=""/>
			<input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
			<input type="hidden" id="searchAppSeqCd" name="searchAppSeqCd" value=""/>
		</form>
		<div class="inner">
			<table class="table w100p" id="htmlTable">
				<colgroup>
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
					<col width="25%" />
					<col width="15%" />
					<col width="%" />
				</colgroup>
				<tr>
					<th>성명/사번</th><td id="iName"></td>
					<th>소속</th><td id="iOrgnm"></td>
					<th>입사일</th><td id="iEmpYmd"></td>
				</tr>
				<tr>
					<th>직급</th><td id="iJikgub"></td>
					<th>직책</th><td id="iJikchak"></td>
					<th>직급년차</th><td id="iJikgubYeuncha"></td>
				</tr>
			</table>
		</div>
		<br/>
		<span style="display:none;">
		<script type="text/javascript">createIBSheet("sheet1", "0%", "0%","kr"); </script>
		</span>
		<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","kr"); </script>

		<div class="popup_button outer">
		<ul>
			<li>
				<a id="close" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>