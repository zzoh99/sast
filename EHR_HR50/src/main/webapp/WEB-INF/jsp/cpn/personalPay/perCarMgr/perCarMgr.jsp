<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchDate").datepicker2();
		$("#searchDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:8};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"사번",			Type:"Text",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sabun",              KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"성명",			Type:"Text",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"name",               KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"소속",			Type:"Text",		Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",              KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:15 },
			{Header:"직급",			Type:"Text",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:15 },
			{Header:"직책",			Type:"Text",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"직구분",		Type:"Text",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"worktypeNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"계약유형",		Type:"Text",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"manageNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"차량소유여부",	Type:"Combo",		Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"carYn",          	 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"시작일자",    	Type:"Date",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sdate",              KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"종료일자",    	Type:"Date",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"edate",              KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"비고",        	Type:"Text",		Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"bigo",               KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"사업장코드",  	Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"businessPlaceCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
			];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		// 조회조건
		sheet1.SetColProperty("carYn",      {ComboText:"|Y|N", ComboCode:"|Y|N"} );
		// 계약유형
		var manageCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "");
		$("#searchManageCd").html(manageCdList[2]);
		$("#searchManageCd").select2({
			placeholder: "선택"
		});
		

		$("#searchOrgNm,#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
		//setSheetAutocompleteEmp( "sheet1", "name");
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						//sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						//sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						sheet1.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
						//sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						//sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
						sheet1.SetCellValue(gPRow, "manageNm",   rv["manageNm"] );
					}
				}
			]
		});	
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	
			
			$("#searchManageCdHidden").val(getMultiSelectValue($("#searchManageCd").val()));
			
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getPerCarMgrList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/SaveData.do?cmd=savePerCarMgr", $("#sheetForm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|11|12|13|14"});
			break;
		case "LoadExcel":
				// 업로드
				var params = {};
				sheet1.LoadExcel(params);
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}


    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          var rv = null;

          if(colName == "name") {
        	  if(!isPopup()) {return;}
        	  gPRow = Row;
        	  pGubun = "employeePopup";
              var rv = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "740","520");
              /*
              if(rv!=null){

                  sheet1.SetCellValue(Row, "name",   rv["name"] );
            	  sheet1.SetCellValue(Row, "sabun",  rv["sabun"] );
            	  sheet1.SetCellValue(Row, "orgNm",  rv["orgNm"] );
            	  sheet1.SetCellValue(Row, "manageNm",  rv["manageNm"] );            	  
            	  sheet1.SetCellValue(Row, "jikgubNm",  rv["jikgubNm"] );            	  
            	  sheet1.SetCellValue(Row, "statusNm",  rv["statusNm"] );

              }
              */
          }
          else if(colName == "elementNm"){
        	  if(!isPopup()) {return;}
        	  gPRow = Row;
        	  pGubun = "payElementPopup";
        	  var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "740","520");
              /*
        	  if(rv!=null){
                  sheet1.SetCellValue(Row, "elementCd",   rv["elementCd"] );
                  sheet1.SetCellValue(Row, "elementNm",   rv["elementNm"] );
              }
              */
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
            sheet1.SetCellValue(gPRow, "name",   	rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",   	rv["sabun"] );
            sheet1.SetCellValue(gPRow, "orgNm",   	rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "manageNm",   rv["manageNm"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "statusNm",   rv["statusNm"] );
	    }else if(pGubun == "orgBasicPopup"){
        	$("#searchOrgNm").val(rv["orgNm"]);
        	$("#searchOrgCd").val(rv["orgCd"]);	    	
	    }
	    
	    /* if(pGubun == "sheetAutocompleteEmp"){
            sheet1.SetCellValue(gPRow, "name",   	rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",   	rv["sabun"] );
            sheet1.SetCellValue(gPRow, "orgNm",   	rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "manageNm",   rv["manageNm"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "statusNm",   rv["statusNm"] );
	    } */
	}    
    
    //  소속 조회 팝입
    function openOrgSchemePopup(){
        try{

        	var args    = new Array();
        	if(!isPopup()) {return;}
        	gPRow = "";
        	pGubun = "orgBasicPopup";
            var rv = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=${authPg}", args, "740","520");
            /*
            if(rv!=null){

            	$("#searchOrgNm").val(rv["orgNm"]);
            	$("#searchOrgCd").val(rv["orgCd"]);
            }
            */
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    // 숫자입력
    function checkNumber(event){
        if($(this).val()!="" && $(this).val().match(/[^0-9]/g) != null){
            $(this).val($(this).val().replace(/[^0-9]/g, ''));
            $(this).focus();
        }
    }
    
    // 멀티체크
    function getMultiSelectValue( value ) {
    	if( value == null || value == "" ) return "";
    	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
    	//return "'"+String(value).split(",").join("','")+"'";
		return value;
    }
    
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<!-- 조회조건 -->
	<input type="hidden" id="searchElemCd" name="searchElemCd" value =""/>
	<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
	<input type="hidden" id="searchManageCdHidden" name="searchManageCdHidden" value="" />
	<!-- 조회조건 -->
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>기준일자</th>
						<td>
							<input type="text" id="searchDate" name="searchDate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<td><th>소속</th>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" style="ime-mode:active;" />
						</td>
						<td><th>사번/성명</th>
							<input id="searchSabunName" name ="searchSabunName" type="text" class="text" style="ime-mode:active;"/>
						</td>
					</tr>
					<tr>
						<th>계약유형 </th>
						<td>
							<select id="searchManageCd" name ="searchManageCd" multiple=""></select>
						</td>
						<td>
							<input id="statusCd" name="statusCd" type="radio" value="RA" checked> 퇴직자 제외
								&nbsp;
								<input id="statusCd" name="statusCd"  type="radio" value="" > 퇴직자 포함
							</td>
						</td>
						<td><a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a></td>
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
							<li id="txt" class="txt">차량소유여부관리</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')" class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('LoadExcel')" class="basic authA">업로드</a>
								<a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
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
