<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='contractCre' mdef='급여계약서배포'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:8}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
             {Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
             {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       	Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
             {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       	Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
             {Header:"<sht:txt mid='ibsCheck_V2358' mdef='명세서출력'/>",			Type:"CheckBox", 	Hidden:0,  Width:80,   Align:"Center",	ColMerge:0,   SaveName:"ibsCheck",		KeyField:0,	  CalcLogic:"",   Format:"",         PointCount:0,	 UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
             {Header:"<sht:txt mid='ibsCheck2' mdef='신청서출력'/>",			Type:"CheckBox", 	Hidden:0,  Width:80,   Align:"Center",	ColMerge:0,   SaveName:"ibsCheck2",		KeyField:0,	  CalcLogic:"",   Format:"",         PointCount:0,	 UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
             {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",  		Type:"Text",		Hidden:0,  Width:100,  Align:"Left",	ColMerge:1,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
             {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",  		Type:"Text",		Hidden:0,  Width:90,   Align:"Center",	ColMerge:1,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
             {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",  		Type:"Text",		Hidden:0,  Width:70,   Align:"Center",	ColMerge:1,   SaveName:"name",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='famres' mdef='주민등록번호'/>",	Type:"Text",		Hidden:0,  Width:80,   Align:"Center",	ColMerge:1,   SaveName:"resNo",			KeyField:0,   CalcLogic:"",   Format:"######-*******",PointCount:0,  UpdateEdit:1, InsertEdit:1, EditLen:20},
             {Header:"<sht:txt mid='workType_V6028' mdef='취업자유형'/>",		Type:"Combo",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"workType",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='empYmd' mdef='입사일'/>",		Type:"Date",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"entYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },      
             {Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",		Type:"Date",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"birthYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }, 
             {Header:"<sht:txt mid='armyInYmd' mdef='입대일'/>",		Type:"Date",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"armyInYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }, 
             {Header:"<sht:txt mid='armyOutYmd' mdef='전역일'/>",		Type:"Date",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"armyOutYmd",	KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }, 
             {Header:"<sht:txt mid='ageTymd' mdef='취업한연령'/>",		Type:"Text",		Hidden:0,  Width:80,   Align:"Center",	ColMerge:1,   SaveName:"ageTymd",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='armyTymd' mdef='병역복무기간'/>",	Type:"Text",		Hidden:0,  Width:80,   Align:"Center",	ColMerge:1,   SaveName:"armyTymd",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='calTymd_V5584' mdef='차감후연령'/>",		Type:"Text",		Hidden:0,  Width:80,   Align:"Center",	ColMerge:1,   SaveName:"calTymd",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='staYmd' mdef='감면시작일'/>",		Type:"Date",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"staYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }, 
             {Header:"<sht:txt mid='endYmd_V570' mdef='감면종료일'/>",		Type:"Date",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"endYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }, 
             {Header:"<sht:txt mid='taxRate_V4816' mdef='적용세율'/>",  	Type:"Text",		Hidden:0,  Width:80,   Align:"Center",	ColMerge:1,   SaveName:"taxRate",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='payYn_V1559' mdef='급여반영여부'/>",	Type:"Combo",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"payYn",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='payCalYn' mdef='급여계산여부'/>",	Type:"Combo",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"payCalYn",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }

         ] ; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

		//기준일자
		$("#searchDate").datepicker2({
			onReturn: getPayType
		});
		$("#searchDate").mask("1111-11-11");
		$("#searchDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
  		//입사일자
		$("#searchEmpFromDate").datepicker2();
		$("#searchEmpFromDate").mask("1111-11-11");
		$("#searchEmpFromDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$("#searchEmpToDate").datepicker2();
		$("#searchEmpToDate").mask("1111-11-11");
		$("#searchEmpToDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
  		$("#searchPayType").bind("change",function(event){
			doAction("Search");
		});

		getPayType();

		doAction("Search");
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
					}
				}
			]
		});

	});

	function getWorkType() {
		// 취업자유형
		var workType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C70002", $("#searchDate").val()), "");
		sheet1.SetColProperty("workType",	{ComboText:"|"+workType[0], ComboCode:"|"+workType[1]} );
	}

	function getPayType() {
		// 급여유형
		var payTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110", $("#searchDate").val()), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchPayType").html(payTypeList[2]) ;
	}
	
	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 getWorkType(); sheet1.DoSearch( "${ctx}/YouthIncomeExemption.do?cmd=getYouthIncomeExemptionList", $("#sheetForm").serialize() ); break;
		case "Save": 		
			if(!dupChk(sheet1,"sabun", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/YouthIncomeExemption.do?cmd=saveYouthIncomeExemption", $("#sheetForm").serialize());break;
		case "Insert":		
			sheet1.SelectCell(sheet1.DataInsert(0), ""); break;
		case "Copy":		
			sheet1.SelectCell(sheet1.DataCopy(), 4); 
			break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":  	
        	var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":
			// 업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22"});
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
		
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
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
	
	function sheet1_OnChange(Row, Col, Value) {
		try{
			
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	function sheet1_OnPopupClick(Row, Col){
        try{
        
          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();
          /*
          args["name"]   = sheet1.GetCellValue(Row, "name");
          args["sabun"]  = sheet1.GetCellValue(Row, "sabun");
          */
          if(colName == "sabun") {
        	  if(!isPopup()) {return;}

        	  pGubun = "OnPopupClick_sabun";
        	  gPRow = Row;
              var rv = openPopup("/Popup.do?cmd=employeePopup", args, "840","520");   
              /* if(rv!=null){
                  sheet1.SetCellValue(Row, "name",   	rv["name"] );
                  sheet1.SetCellValue(Row, "sabun",  	rv["sabun"] );
                  sheet1.SetCellValue(Row, "orgNm",  	rv["orgNm"] );
                  sheet1.SetCellValue(Row, "payType",	rv["payType"] );
                  sheet1.SetCellValue(Row, "resNo",	    rv["resNo"] );
              } */
          }    
        
        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }
	
	 /**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
    	
	
		if(sheet1.CheckedRows("ibsCheck") == 0) {
			alert("<msg:txt mid='110453' mdef='출력할 데이터를 선택하여 주십시오.'/>");
			return;
		}
		
		
		
		var sRow = sheet1.FindCheckedRow("ibsCheck"); 
		var arrRow = [];
		
		$(sRow.split("|")).each(function(index,value){
			arrRow[index] = sheet1.GetCellValue(value,"sabun");
		});
		
		var searchSabun = "(";
		for(var i=0; i<arrRow.length; i++) {
	        if(i != 0) searchSabun += ",";
	        searchSabun += "'"+arrRow[i]+"'"; 
	    } 
		searchSabun += ")";
		
		
  		var w 		= 800;
		var h 		= 600;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		args["rdTitle"] = "소득세 감면 대상 명세서" ;//rd Popup제목
		args["rdMrd"] = "cpn/youthIncome/youthIncomSta.mrd";//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "['${ssnEnterCd}'] ["+searchSabun+"]" ; //rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
		
		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		pGubun = "rdPopup";
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		/* if(rv!=null){
			//return code is empty
		} */
	}
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup2(){

		if(sheet1.CheckedRows("ibsCheck2") == 0) {
			alert("<msg:txt mid='110453' mdef='출력할 데이터를 선택하여 주십시오.'/>");
			return;
		}
		
		
		
		var sRow = sheet1.FindCheckedRow("ibsCheck2"); 
		var arrRow = [];
		
		$(sRow.split("|")).each(function(index,value){
			arrRow[index] = sheet1.GetCellValue(value,"sabun");
		});
		
		var searchSabun = "(";
		for(var i=0; i<arrRow.length; i++) {
	        if(i != 0) searchSabun += ",";
	        searchSabun += "'"+arrRow[i]+"'"; 
	    } 
		searchSabun += ")";
		
		
  		var w 		= 800;
		var h 		= 600;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		
		args["rdTitle"] = "소득세 감면신청서" ;//rd Popup제목
		args["rdMrd"] = "cpn/youthIncome/youthIncome.mrd";//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "['${ssnEnterCd}'] ["+searchSabun+"] ['${baseURL}']"  ; //rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
		
		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		pGubun = "rdPopup2";
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		if(rv!=null){
			//return code is empty
		}
		
	}

	//모달팝업대체
	function getReturnValue(returnValue){
		var rv = $.parseJSON('{'+ returnValue+'}');
		
		if(pGubun == "OnPopupClick_sabun"){
			if(rv!=null){
				sheet1.SetCellValue(gPRow, "name",   	rv["name"] );
				sheet1.SetCellValue(gPRow, "sabun",  	rv["sabun"] );
				sheet1.SetCellValue(gPRow, "orgNm",  	rv["orgNm"] );
				sheet1.SetCellValue(gPRow, "payType",	rv["payType"] );
				sheet1.SetCellValue(gPRow, "resNo",	    rv["resNo"] );
				sheet1.SetCellValue(gPRow, "entYmd",	rv["empYmd"] );
			}
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						<td><input type="text" id="searchDate" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" name="searchDate" class="date2 input_change" /></td>
						<th><tit:txt mid='104564' mdef='입사일자'/></th>
						<td>
							<input type="text" id="searchEmpFromDate" value="" name="searchEmpFromDate" class="date2" /> ~ <input type="text" id="searchEmpToDate" value="" name="searchEmpToDate" class="date2" />
						</td>
						<th><tit:txt mid='114519' mdef='급여구분 '/></th>
						<td>
							<select id="searchPayType" name="searchPayType"></select>
						</td>
						<td><a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
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
							<li id="txt" class="txt"><tit:txt mid='114649' mdef='청년취업소득감면제도 신고'/></li>
							<li class="btn">
								<a href="javascript:doAction('DownTemplate')" class="basic authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
								<a href="javascript:doAction('LoadExcel')" class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a>
							    <a href="javascript:rdPopup()" 	class="pink authA"><tit:txt mid='113199' mdef='명세서출력'/></a>
							    <a href="javascript:rdPopup2()" 	class="pink authA"><tit:txt mid='112834' mdef='신청서출력'/></a>
								<a href="javascript:doAction('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction('Copy')" class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
                                <a href="javascript:doAction('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
