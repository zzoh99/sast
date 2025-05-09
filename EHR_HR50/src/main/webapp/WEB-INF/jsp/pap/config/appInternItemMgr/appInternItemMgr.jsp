<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"대분류",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"itemType",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"항목코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가역량",	Type:"Text",	Hidden:0,	Width:250,	Align:"Center",	ColMerge:0,	SaveName:"seqNm",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:33  },
			{Header:"배점",		Type:"Int",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appBasisPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3 },
			{Header:"평가내용",	Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:330 , MultiLineText:1    },
			{Header:"순서",		Type:"Int",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sunbun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetEditEnterBehavior("newline");

		//평가ID
		var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchAppTypeCd=D,",false).codeList, ""); //평가명
		sheet1.SetColProperty("appraisalCd", 	{ComboText:famList[0], ComboCode:famList[1]} );
		$("#searchAppraisalCd").html(famList[2]);

		//대분류
		var combocdList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10010"), "");
		sheet1.SetColProperty("itemType", 			{ComboText:combocdList1[0], ComboCode:combocdList1[1]} );

		$("#searchAppraisalCd").change(function(){
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppInternItemMgr.do?cmd=getAppInternItemMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							if(chkSave()){
								IBS_SaveName(document.srchFrm,sheet1);
								sheet1.DoSave( "${ctx}/AppInternItemMgr.do?cmd=saveAppInternItemMgr", $("#srchFrm").serialize());
							}
							break;
		case "Insert":
							var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
							sheet1.SelectCell(Row, "itemType");
							break;
		case "Copy":
							var Row = sheet1.DataCopy();
							sheet1.SetCellValue(Row, "seq", "");
							break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{

			var rv = null;
			var args    = new Array();

			args["elementType"] = sheet1.GetCellValue(Row, "elementType");
			args["elementCd"]   = sheet1.GetCellValue(Row, "elementCd");
			args["elementNm"]   = sheet1.GetCellValue(Row, "elementNm");
			args["sdate"]       = sheet1.GetCellValue(Row, "sdate");

			if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
				var rv = openPopup("/PayAllowanceElementPropertyPopup.do?cmd=payAllowanceElementPropertyPopup", args, "1000","520");
				if(rv!=null){
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          args["name"]   = sheet1.GetCellValue(Row, "name");
          args["sabun"]  = sheet1.GetCellValue(Row, "sabun");

          var rv = null;

          if(colName == "name") {

              var rv = openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
              if(rv!=null){
                  sheet1.SetCellValue(Row, "name",   rv["name"] );
                  sheet1.SetCellValue(Row, "sabun",  rv["sabun"] );

                  sheet1.SetCellValue(Row, "resNo",  rv["resNo"].replace(/\//g,'') );
              }
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

    function chkSave(){
    	var totAppBasisPoint=0;
    	for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
    		var v_appBasisPoint = sheet1.GetCellValue(i, "appBasisPoint");
    		totAppBasisPoint += eval(v_appBasisPoint);
    		if(v_appBasisPoint > 100){
				alert("배점의 최대값은 100을 넘을 수 없습니다.");
				return false;
			}
		}
    	if(totAppBasisPoint != "100"){
    		alert("현재 배점의 총합은 "+totAppBasisPoint+"점 입니다. 총합이 100점이 되어야 합니다.");
    	}

    	return true;
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
						<td> <span>평가명 </span> <select id="searchAppraisalCd" name="searchAppraisalCd"> </select> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
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
							<li id="txt" class="txt">촉탁직평가항목정의</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>