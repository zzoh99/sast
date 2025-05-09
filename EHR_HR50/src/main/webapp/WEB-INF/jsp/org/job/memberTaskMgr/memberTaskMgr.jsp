<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!-- <%@ page import="com.hr.common.util.DateUtil" %> -->
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		//IBsheet1 init
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>", 	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>", 	Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},

			{Header:"<sht:txt mid='empSabun' mdef='사번'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"sabun",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='orgCd' mdef='소속'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"orgNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='jikchakCd' mdef='직책'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikchakNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",      Type:"Text",   Hidden:1,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikgubNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='jikweeYn' mdef='직급'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikweeNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='chargeName' mdef='성명'/>",      Type:"Popup",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"name",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"alias",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",      Type:"Date",   Hidden:0,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"sdate",  KeyField:1, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='edate' mdef='종료일'/>",      Type:"Date",   Hidden:0,   Width:100,  Align:"Center",   ColMerge:0, SaveName:"edate",  KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='2017082800628' mdef='공통사무코드'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"taskCd",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='2017082800630' mdef='공통사무명'/>",     Type:"Popup",   Hidden:0,   Width:160,  Align:"Center",   ColMerge:0, SaveName:"taskNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },


		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

		initPage();

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	// 기본 화면설정
	function initPage(){

		//소속 조직 데이터 매핑
		var data = ajaxCall("${ctx}/GetDataMap.do?cmd=getOrgMapMemberTaskMgr","",false).DATA;
		$("#searchOrgCd").val(data.orgCd);
		$("#orgNm").val(data.orgNm);

		$("#searchSabunNameAlias,#searchStdDate,#searchTaskNm").bind("keyup", function(event) {
			if(event.keyCode == '13') {
				doAction1("Search");
			}
		});

		$("#searchStdDate").datepicker2();

	}

	/* IB시트 함수 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getMemberTaskMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			//중복 체크 (변수 : "컬럼명|컬럼명")
        	if(!dupChk(sheet1,"", true, true)){break;}
        	IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveMemberTaskMgr", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SelectCell(row, "name");
			sheet1.SetCellValue(row, "sdate", <%=DateUtil.getCurrentTime("yyyyMMdd")%>);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "sdate", "");
        	//sheet1.SetCellValue( Row, "PK컬럼", "" );
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "DownTemplate":
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|sdate|edate|taskCd"});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업

			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	// 팝업 클릭시 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			//사원검색
			switch(sheet1.ColSaveName(Col)){
				case "name":
					if(!isPopup()) {return;}

					sheet1.SelectCell(Row,"name");

					gPRow = Row;
					pGubun = "employeePopup";

					openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "740","520");
					break;
				case "taskNm":

					gPRow = Row;
					pGubun = "taskPopup";

					openPopup("/Popup.do?cmd=taskPopup&authPg=R", "", "740","520");
					break;
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup") {
        	if(rv["orgCd"] == $("#searchOrgCd").val()) {
        		//같은 조직
            	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
            	sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
            	sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
            	sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
            	sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
            	sheet1.SetCellValue(gPRow, "name", rv["name"]);
            	sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
        	} else {
        		setTimeout(function() {
	        		alert("<msg:txt mid='2017082800645' mdef='타 조직의 조직원은 입력할 수 없습니다.'/>");
        		}, 300);
        	}return;
        } else if(pGubun == "taskPopup") {
        	sheet1.SetCellValue(gPRow, "taskCd", rv["taskCd"]);
        	sheet1.SetCellValue(gPRow, "taskNm", rv["taskNm"]);
        }
    }

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103906' mdef='기준일자 '/> </th>
			<td>
				 <input id="searchStdDate" name="searchStdDate" size="10" type="text" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" />
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/> </th>
			<td>
				 <input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<th><tit:txt mid='2017082800635' mdef='공통사무명'/> </th>
			<td>
				 <input id="searchTaskNm" name="searchTaskNm" type="text" class="text" />
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>
			</td>
			<th><tit:txt mid='104514' mdef='조직명'/> </th>
			<td>
				<input id="searchOrgCd" name="searchOrgCd" type="hidden" />
				<input id="orgNm" name="orgNm" type="text" class="text w100 readonly" style="text-align:center;" readonly />
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
					<li class="txt"><tit:txt mid='2017082800651' mdef='조직원 공통사무관리'/></li>
					<li class="btn">

						<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='down2excel' mdef="다운로드"/>

					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>