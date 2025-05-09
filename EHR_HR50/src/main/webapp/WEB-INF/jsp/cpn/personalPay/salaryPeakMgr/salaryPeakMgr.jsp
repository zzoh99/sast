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

		$("#searchDate").datepicker2({ymonly:true, onReturn: getCommonCodeList});
		$("#searchDate,#searchYear,#searchBigo,#searchSabunName,#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:8};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"계약유형",    Type:"Text",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"manageNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속",        Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",              KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",    		Type:"Text",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",        Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sabun",              KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"성명",        Type:"Text", 		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"name",               KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"생년월",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"birthYm",		KeyField:0,					Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"연차",       	Type:"Combo",       Hidden:0, 					 Width:70,   		Align:"Center",	ColMerge:0,	SaveName:"year",	KeyField:1,   CalcLogic:"", Format:"",   		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
			{Header:"지급율(%)",    Type:"Float",     	Hidden:0,  					Width:75,   		Align:"Center",	ColMerge:1,	SaveName:"rate",	KeyField:1,   CalcLogic:"", Format:"Float",     PointCount:5,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"시작월",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sYm",		KeyField:1,					Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"종료월",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"eYm",		KeyField:1,					Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"비고",			Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"bigo",	KeyField:0,					Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사업장코드",  Type:"Text",      Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"businessPlaceCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }  ];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetColProperty("col5", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
		
		// 연차(TSYS006)
		var year = convCode( ajaxCall("${ctx}/SalaryPeakMgr.do?cmd=getYearCombo","",false).DATA, "선택");
		sheet1.SetColProperty("year", {ComboText:"선택|"+year[0], ComboCode:"|"+year[1]});
		
		//저장시 Code 대신 Text 값이 전달되도록 한다.
	    sheet1.SetSendComboData(0,"year","Text");

		
		// 조회조건
		
		getCommonCodeList();

		$("#searchElemNm,#searchOrgNm,#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "manageNm",	rv["manageNm"]);
						sheet1.SetCellValue(gPRow, "orgNm",	rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",	rv["name"]);
					}
				}
			]
		});	
		
		//setSheetAutocompleteEmp( "sheet1", "name");
	});

	function getCommonCodeList() {
		let searchYm = $("#searchDate").val();
		let baseSYmd = "";
		let baseEYmd = "";

		if(searchYm !== null && searchYm !== "") {
			baseSYmd = searchYm + "-01";
			baseEYmd = getLastDayOfMonth(searchYm);
		}

		// 재직상태
		var statusCdList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010", baseSYmd, baseEYmd), "");
		$("#searchStatusCd").html(statusCdList[2]);
		$("#searchStatusCd").select2({
			placeholder: "선택"
		});


		// 계약유형
		var manageCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030", baseSYmd, baseEYmd), "");
		$("#searchManageCd").html(manageCdList[2]);
		$("#searchManageCd").select2({
			placeholder: "선택"
		});
	}

	function getLastDayOfMonth(yearMonth) {
		const [year, month] = yearMonth.split('-').map(Number);
		const lastDate = new Date(year, month, 0);

		const yearStr = lastDate.getFullYear().toString();
		const monthStr = (lastDate.getMonth() + 1).toString().padStart(2, '0');
		const dayStr = lastDate.getDate().toString().padStart(2, '0');

		return yearStr + '-' + monthStr + '-' + dayStr;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			let searchYm = $("#searchDate").val();
			let baseSYmd = "";
			let baseEYmd = "";

			if(searchYm !== null && searchYm !== "") {
				baseSYmd = searchYm + "-01";
				baseEYmd = getLastDayOfMonth(searchYm);
			}

			var userCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "TST01", baseSYmd, baseEYmd), "전체");
			sheet1.SetColProperty("col6", 			{ComboText:userCd[0], ComboCode:userCd[1]} );
			
			$("#searchManageCdHidden").val(getMultiSelectValue($("#searchManageCd").val()));
			$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));
			
			sheet1.DoSearch( "${ctx}/SalaryPeakMgr.do?cmd=getSalaryPeakMgrList", $("#sheetForm").serialize() ); break;
		case "Save":
			//if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/SalaryPeakMgr.do?cmd=saveSalaryPeakMgr", $("#sheetForm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"6|7|8|9|10|11|12"});
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

          if(colName == "name") {

			  let layerModal = new window.top.document.LayerModal({
				  id : 'employeeLayer'
				  , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
				  , parameters : {}
				  , width : 840
				  , height : 520
				  , title : '사원조회'
				  , trigger :[
					  {
						  name : 'employeeTrigger'
						  , callback : function(result){
							  sheet1.SetCellValue(Row, "name",   result.name);
							  sheet1.SetCellValue(Row, "sabun",   result.sabun);
							  sheet1.SetCellValue(Row, "orgNm",   result.orgNm);
							  sheet1.SetCellValue(Row, "manageNm",   result.manageNm);
							  sheet1.SetCellValue(Row, "jikgubNm",   result.jikgubNm);
							  sheet1.SetCellValue(Row, "statusNm",   result.statusNm);
						  }
					  }
				  ]
			  });
			  layerModal.show();
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
	    
	    if(pGubun == "sheetAutocompleteEmp"){
            sheet1.SetCellValue(gPRow, "name",   	rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",   	rv["sabun"] );
            sheet1.SetCellValue(gPRow, "orgNm",   	rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "manageNm",   rv["manageNm"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "statusNm",   rv["statusNm"] );
	    }
	}    
    
    //  소속 조회 팝입
    function openOrgSchemePopup(){
        try{
			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
				, parameters : parameters
				, width : 800
				, height : 520
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							if(!result.length) return;
							if(result.length === 1){
								$("#searchOrgNm").val(result.orgNm);
								$("#searchOrgCd").val(result.orgCd);
							}
						}
					}
				]
			});
			layerModal.show();
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
	<input type="hidden" id="searchStatusCdHidden" name="searchStatusCdHidden" value="" />
	<!-- 조회조건 -->
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>기준년월</th>
						<td>
							<input type="text" id="searchDate" name="searchDate" class="date2" value=""/>
						</td>
						<th>소속</th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" style="ime-mode:active;" />
						</td>
						<th>연차</th>
						<td>
							<input id="searchYear" name ="searchYear" type="text" class="text" style="ime-mode:active;"/> </td>
						</td>
						<th>비고</th>
						<td>
							<input id="searchBigo" name ="searchBigo" type="text" class="text" style="ime-mode:active;"/> </td>
						</td>
					</tr>
					<tr>
						<th>계약유형</th>
						<td><select id="searchManageCd" name ="searchManageCd" multiple=""></select></td>
						<th>재직상태</th>
						<td><select  id="searchStatusCd" name="searchStatusCd" multiple=""></select></td>
						<th>사번/성명</th>
						<td>
							<input id="searchSabunName" name ="searchSabunName" type="text" class="text" style="ime-mode:active;"/>
						</td>
						<td colspan="2"><a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a></td>
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
							<li id="txt" class="txt">임금피크대상자관리</li>
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
