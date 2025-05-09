<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수영수증파일다운</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$("#searchWorkYy").mask('0000');

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"출력구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjustType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='receiveNo' mdef='일련\n번호'/>",	Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"seqNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='fileNm' mdef='파일명'/>",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"fileNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='filePath_V6225' mdef='파일경로'/>",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"filePath",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		getCommonCodeList();

		$(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search");
		$("#searchWorkYy").change(function (){
			getCommonCodeList();
		});

		$("#searchWorkYy,#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchAdjustType").bind("change",function(event){
			doAction1("Search");
		});

	});

	function getCommonCodeList() {
		let searchYear = $("#searchWorkYy").val();
		let baseSYmd = "";
		let baseEYmd = "";
		if (searchYear !== "") {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}


		const searchAdjustType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00780", baseSYmd, baseEYmd), "");//(C00780)
		sheet1.SetColProperty("adjustType", 		{ComboText:"|"+searchAdjustType[0], ComboCode:"|"+searchAdjustType[1]} );
		$("#searchAdjustType").html(searchAdjustType[2]);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if (!chkInVal(sAction)) {break;}
						sheet1.DoSearch( "${ctx}/BeforeYearFileDown.do?cmd=getBeforeYearFileDownList", $("#sendForm").serialize() );
						break;
		case "PDF":
						if (!chkInVal(sAction)) {break;}
						var sCheckRow = sheet1.FindCheckedRow("ibsCheck");

						if ( sCheckRow == "" ){
							alert("선택된 내역이 없습니다.");
							break;
						}

						var arrRow = [];

						$(sCheckRow.split("|")).each(function(index,value){
							arrRow[index] = sheet1.GetCellValue(value,"fileNm");
						});

						var checkValues = "";

						for(var i=0; i<arrRow.length; i++) {
							if(i != 0) {
								checkValues += ",";
							}
							checkValues += arrRow[i];
						}
						$("#yyyy").val($("#searchWorkYy").val());
						$("#adjustType").val($("#searchAdjustType").val());
						$("#imgName").val(checkValues);
						$("#pfrm").submit();
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
						sheet1.Down2Excel(param);

						break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				var fileNm = sheet1.GetCellValue(r, "fileNm");
				if ( fileNm == "" ){
					sheet1.SetCellEditable(r,"ibsCheck",0);
				}
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

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}

	function chkInVal(sAction) {
		if ($("#searchWorkYy").val() == "") {
			alert("귀속년도를 입력하십시오.");
			$("#searchWorkYy").focus();
			return false;
		}

		return true;
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='114125' mdef='귀속년도'/></th>
			<td>
				<input id="searchWorkYy" name="searchWorkYy" type="text" class="center required" style="width: 60px;" value="2017" />
			</td>
			<th><tit:txt mid='112806' mdef='출력구분'/></th>
			<td>
				<select id="searchAdjustType" name="searchAdjustType"></select>
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchNm" name="searchNm" type="text" class="text" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<table class="sheet_main">
	<tr>
		<td class="bottom outer">
			<div class="explain">
				<div class="title"><tit:txt mid='114264' mdef='도움말'/></div>
				<div class="txt">2018년 이전 파일 다운로드.
				</div>
			</div>
		</td>
	</tr>
	</table>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul style="margin-top: 10px;">
							<li class="txt">원천징수영수증파일다운</li>
							<li class="btn">
								<a href="javascript:doAction1('PDF');" 			class="button authA">PDF파일다운로드</a>
								<a href="javascript:doAction1('Down2Excel');" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
<iframe name="hiddenIframe" id="hiddenIframe" style="display:none;"></iframe>
<form id="pfrm" name="pfrm" target="hiddenIframe" action="/BeforeYearFileDown.do?cmd=getBeforeYearZipFileDown" method="post" >
<input type="hidden" id="imgName" name="imgName" />
<input type="hidden" id="yyyy" name="yyyy" />
<input type="hidden" id="adjustType" name="adjustType" />
</form>
</body>
</html>
