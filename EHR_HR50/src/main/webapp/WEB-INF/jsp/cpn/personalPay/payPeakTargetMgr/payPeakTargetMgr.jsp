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

		$("#searchFromYear, #searchToYear, #searchSaNm").bind("keyup",function(event) {
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:9};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"기준년도",		Type:"Text",        Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"yy",         KeyField:0,   CalcLogic:"",  Format:"Number",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
			{Header:"직군코드",		Type:"Text",     	Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"workType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"직군",			Type:"Text",     	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"workTypeNm", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"소속",			Type:"Text",     	Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",			Type:"Text",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"성명",			Type:"Text", 		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"생년월일", 		Type:"Date", 		Hidden:0,  Width:80,   Align:"Center", 	ColMerge:0,   SaveName:"birYmd",     KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"임금피크제구분코드", Type:"Combo",     	Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"peakCd",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"임금피크\n년차",		Type:"Int",      	Hidden:0,  Width:50,  Align:"Center",  ColMerge:0,   SaveName:"yearSeq",    KeyField:0,   CalcLogic:"",   Format:"Integer",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"직전금액",		Type:"Int",      	Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"bfPeakMon",  KeyField:0,   CalcLogic:"",   Format:"Integer",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"적용금액",		Type:"Int",      	Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"afPeakMon",  KeyField:0,   CalcLogic:"",   Format:"Integer",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"시작일자",		Type:"Date",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sdate",      KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"종료일자",		Type:"Date",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"edate",      KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"비고",			Type:"Text",      	Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"memo",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }  
		];
		
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        // 임금피크제구분코드
        var peakCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C90510"), "");
        sheet1.SetColProperty("peakCd", {ComboText:"|"+peakCdList[0], ComboCode:"|"+peakCdList[1]} );

		// 조회조건

		$("#searchSabunName").bind("keyup",function(event){
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
						//sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						//sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						//sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						//sheet1.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
						//sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						//sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
						//sheet1.SetCellValue(gPRow, "manageNm",   rv["manageNm"] );
					}
				}
			]
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
        	if( $("#searchFromYear").val().length < 4) {
        		alert("기준년도의 시작일자는 4자리로 입력해주세요.");
        		
        		break;
        	}
        	
        	if( $("#searchToYear").val().length < 4) {
        		alert("기준년도의 종료일자는 4자리로 입력해주세요.");
        		
        		break;
        	}
			
			if( parseInt($("#searchFromYear").val()) > parseInt($("#searchToYear").val()) ) {
				alert("기준년도 시작일자가 종료일자보다 큽니다.");
				
				break;
			}
			
			sheet1.DoSearch( "${ctx}/PayPeakTargetMgr.do?cmd=getPayPeakTargetMgrList", $("#sheetForm").serialize() ); 
			
			break;
		case "Save":
 			if(!dupChk(sheet1,"sabun|peakCd|sdate", false, true)) {
 				break;
 			}
			
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PayPeakTargetMgr.do?cmd=savePayPeakTargetMgr", $("#sheetForm").serialize()); 
			break;
			
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "yy", $("#searchFromYear").val());
			sheet1.SelectCell(row, 3);
			
			break;
		case "Copy":		
			sheet1.DataCopy(); 
			
			break;
		case "Clear":		
			sheet1.RemoveAll(); 
			
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			
			break;
		
        case "createPayPeakTarget": 
        	if( $("#searchFromYear").val().length < 4) {
        		alert("기준년도는 4자리로 입력해주세요.");
        		
        		break;
        	}
        	
        	if (confirm( $("#searchFromYear").val()+"년도 임금피크대상자를 생성하시겠습니까?") ) {
		    	var data = ajaxCall("${ctx}/PayPeakTargetMgr.do?cmd=createPayPeakTarget", $("#sheetForm").serialize(), false);
				
		    	if(data.Result.Code == null) {
					alert("<msg:txt mid='alertCreateOk1' mdef='임금피크대상자생성이 완료되었습니다.'/>");
					doAction1("Search");
		    	} else {
			    	alert(data.Result.Message);
		    	}
        	}
		   
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

	function sheet1_OnValidation(Row, Col, Value) {
		try {
		    if ( sheet1.GetCellValue(Row, "yy").length < 4 ) {
				alert("기준년도는 4자리로 입력해주세요.");
		        sheet1.ValidateFail(true);

				return;
		    }
		} catch (ex) {
			alert("OnValidation Event Error " + ex);
		}
	}
	
    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col) {
        try {

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          var rv = null;

          if(colName == "name") {
        	  if(!isPopup()) {
        		  return;
        	  }
        	  
        	  gPRow = Row;
        	  pGubun = "employeePopup";
        	  
              var rv = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
          }
        } catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }
    
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup") {
	    	sheet1.SetCellValue(gPRow, "workType",   rv["workType"] );
	    	sheet1.SetCellValue(gPRow, "workTypeNm", rv["workTypeNm"] );
	    	sheet1.SetCellValue(gPRow, "orgNm",   	 rv["orgNm"] );
	    	sheet1.SetCellValue(gPRow, "sabun",   	 rv["sabun"] );
	    	sheet1.SetCellValue(gPRow, "name",   	 rv["name"] );
	    }
	}
	
	
	
	// 생년월일 변경시 시작일자 설정
	function sheet1_OnChange(Row, Col, Value) {
		try {
			if( Col == sheet1.SaveNameCol("birYmd") ) {
	
				var workType       = sheet1.GetCellValue(Row, "workType");
				if(workType == "") {
					alert("성명을 먼저 검색해주세요.");
					
					return;
				}

				//var birYmd		   = sheet1.GetCellValue(Row, "birYmd");
				var birYmd		   = Value;
				var searchFromYear = $("#searchFromYear").val();
				var sdate		   = "";

				switch (workType) {
				case "A":
					//ex) 20080301 에 8 개월 더하기 ==> addDate("m", 1, "20080301", "");
					sdate = addDate("m", 1, searchFromYear+(birYmd.substring(4, 8)), "");
					sdate = sdate.substr(0, 6)+'01';
					break;
				case "B":
					sdate = searchFromYear+(birYmd.substring(4, 8));
					console.log("@@@B sdate:"+sdate);
					break;
				}

				sheet1.SetCellValue(Row, "sdate", sdate);
			}
		} catch (ex) {
			alert("OnChange Event Error " + ex);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<div>
			<table>
				<tr>
					<th><tit:txt mid='112528' mdef='기준년도'/></th> 
					<td colspan="2"> 
						<input type="text" id="searchFromYear" name="searchFromYear" class="date2" value="${curSysYear}" maxlength="4" class="required" /> ~
						<input type="text" id="searchToYear"   name="searchToYear"   class="date2" value="${curSysYear}" maxlength="4" class="required" />
					</td>
					<th><tit:txt mid='104330' mdef='사번/성명'/></th>
					<td>
						<input id="searchSaNm" name="searchSaNm" type="text" class="text"/>
					</td>
					<td>
						<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
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
							<li id="txt" class="txt"><tit:txt mid='payPeakTargetMgr' mdef='임금피크대상자'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('createPayPeakTarget')"	css="basic authA" mid='110702' mdef="임금피크대상자생성"/>
								<btn:a href="javascript:doAction1('Insert')" 				css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 					css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 					css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 			css="basic authR" mid='110698' mdef="다운로드"/>
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
