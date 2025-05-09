<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>퇴직전환금관리</title>
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

		$("#searchYmd").datepicker2({onReturn: getStatusCd});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",				Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='licSYmd' mdef='취득일'/>",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"acqYmd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='lossYmd' mdef='상실일'/>",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"lossYmd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"퇴직전환금공제여부",		Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retireRemainYn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N"},
			{Header:"퇴직전환금",			Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"retireRemainMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 재직상태
		getStatusCd();

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		$("#searchYmd, #searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "gempYmd", rv["gempYmd"]);
						sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						sheet1.SetCellValue(gPRow, "retYmd", rv["retYmd"]);
						sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
					}
				}
			]
		});		
		
	});

	function getStatusCd() {
		// 재직상태
		let baseSYmd = $("#searchYmd").val();
		const statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010", baseSYmd), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("statusCd",	{ComboText:"|"+statusCdList[0], ComboCode:"|"+statusCdList[1]} );
		$("#searchStatusCd").html(statusCdList[2]);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						sheet1.DoSearch( "${ctx}/RetPenMgr.do?cmd=getRetPenMgrList", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet1,"sabun", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/RetPenMgr.do?cmd=saveRetPenMgr", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						break;
		case "Copy":
						var row = sheet1.DataCopy();
						//sheet1.SetCellValue(row, "payActionCd", "");
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet1.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|9|10|11|12"});
						break;
		}
	}

	// 조회 후 에러 메시지
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

	//팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {

			var colName = sheet1.ColSaveName(Col);
			var args    = new Array();

			var rv = null;

			if(colName == "name") {

				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "employeePopup";
				openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
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


	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "name",	rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"] );

			sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"] );
			sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"] );
			sheet1.SetCellValue(gPRow, "retYmd",	rv["retYmd"] );
			sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"] );
		}

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
			<th><tit:txt mid='104535' mdef='기준일 '/></th>
			<td>
				<input type="text" id="searchYmd" name="searchYmd"  class="date2 required" value="${curSysYyyyMMddHyphen}" />
			</td>
			<th><tit:txt mid='114198' mdef='재직상태 '/></th>
			<td>
				
				<select id="searchStatusCd" name ="searchStatusCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchNm" name="searchNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">퇴직전환금관리</li>
			<li class="btn">
				<a href="javascript:doAction1('DownTemplate')" 	class="basic authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
				<a href="javascript:doAction1('Save')" 			class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
