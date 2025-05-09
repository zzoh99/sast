<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		
		//Master Sheet(sheet1)
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,SumPosition:1};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo", Sort:0 },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"고지년월",	 	Type:"Date",        Hidden:0,  	Width:100,   Align:"Center",     ColMerge:0,   SaveName:"ym",    	KeyField:1,   Format:"Ym",  	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:7 },
			{Header:"공제년월",	 	Type:"Date",        Hidden:0,  	Width:100,   Align:"Center",     ColMerge:0,   SaveName:"payYm",   	KeyField:1,   Format:"Ym",  	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:7 },
			{Header:"구분",			Type:"Combo",       Hidden:0,   Width:100,   Align:"Center", 	 ColMerge:0,   SaveName:"secCd",    KeyField:1,   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5},
			{Header:"사번",      		Type:"Text",        Hidden:0,  	Width:60,    Align:"Center",     ColMerge:0,   SaveName:"sabun",   	KeyField:1,   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"성명",      		Type:"Popup",       Hidden:0,  	Width:60,    Align:"Center",     ColMerge:0,   SaveName:"name",    	KeyField:0,   Format:"",  		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"건강보험정산",     Type:"AutoSum",    Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon1", 	KeyField:0,   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"장기요양보험정산",  Type:"AutoSum",    Hidden:0,  	Width:100,   Align:"Right",      ColMerge:0,   SaveName:"mon2", 	KeyField:0,   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetSumText("sNo" ,"합계");

		// 구분
		var secCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B90750"), "");
		sheet1.SetColProperty("secCd", {ComboText:"선택|"+secCdList[0], ComboCode:"|"+secCdList[1]});
		
		$("#searchYm,#searchPayYmS,#searchPayYmE").datepicker2({
			ymonly:true,
			onReturn:function(date){
				//doAction1("Search");
			}
		});

		//숫자만 입력
		/* $("#searchYm,#searchPayYmS,#searchPayYmE").keyup(function() {
			makeNumber(this,'A');
		}); */
		
		$("#searchSabunName").bind("keyup",function(event){
	    	if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		 
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if (!validationChk()) {break;}
			sheet1.DoSearch( "${ctx}/HealthInsEmpDivMgr.do?cmd=getHealthInsEmpDivMgrList2", $("#srchFrm").serialize() ); 
			break;
		case "Save":
			if(!dupChk(sheet1,"ym|payYm|secCd|sabun", false, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/HealthInsEmpDivMgr.do?cmd=saveHealthInsEmpDivMgr2", $("#srchFrm").serialize()); 
			break;
		case "Insert":	
			var newRow = sheet1.DataInsert(0);
			//openEmployeePopup(newRow) ;
			break;
		case "Copy":	var Row = sheet1.DataCopy();
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"}; 
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "DownTemplate":
			// 양식다운로드
			var exCols = "sNo|name";
			var downCols = makeHiddenSkipExCol(sheet1,exCols);
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:downCols});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
			
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
           
        }catch(ex){alert("OnClick Event Error : " + ex);}
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
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
//  사원 조회
	function openEmployeePopup(Row){
	    try{
			if(!isPopup()) {return;}
			var args    = new Array();

			gPRow = Row;
			pGubun = "employeePopup";

			openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
	    }catch(ex){
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	
	function makeHiddenSkipExCol(sobj,excols){
		var lc = sobj.LastCol();
		var colsArr = new Array();
		for(var i=0;i<=lc;i++){
			if(1==sobj.GetColHidden(i) || sobj.GetCellProperty(0, i, "Type")== "Status" || sobj.GetCellProperty(0, i, "Type")== "DelCheck"){
				colsArr.push(i);
			}
		}
		var excolsArr = excols.split("|");

		for(var i=0;i<=lc;i++){
			if($.inArray(sobj.ColSaveName(i),excolsArr) != -1){
				colsArr.push(i);
			}
		}

		var rtnStr = "";
		for(var i=0;i<=lc;i++){
			if($.inArray(i,colsArr) == -1){
				rtnStr += "|"+ i;
			}
		}
		return rtnStr.substring(1);
	}
	
	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup") {
        	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
        	sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
        	sheet1.SetCellValue(gPRow, "name", rv["name"]);
        	sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
        	sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
        	sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
        	sheet1.SetCellValue(gPRow, "statusNm", rv["statusNm"]);
        }else if(pGubun == "searchOrgBasicPopup") {
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
		}
    }
	
	function sheet1_OnChange(Row, Col, Value) {
		try{
			
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 입력시 조건 체크
	function validationChk() {
		var searchYm = $("#searchYm").val(); //고지년월
		var searchPayYmS = $("#searchPayYmS").val();//공제년월
		var searchPayYmE = $("#searchPayYmE").val();

		if(searchYm == ""){
			alert("고지년월을 선택해 주세요.");
			$("#searchYm").focus();
			return false;
		}
		
		if(searchPayYmS == ""){
			alert("공제년월 시작월을 선택해 주세요.");
			$("#searchPayYmS").focus();
			return false;
		}
		
		if(searchPayYmE == ""){
			alert("공제년월 종료월을 선택해 주세요.");
			$("#searchPayYmE").focus();
			return false;
		}
		
		if(searchPayYmE < searchPayYmS){
			alert("공제년월 시작월이 종료월보다 클 수 없습니다.");
			$("#searchPayYmE").focus();
			return false;
		}
		
		return true;
	}
	
	//분납생성
	function partPayPrc(){
		if($("#searchYm").val() == ""){	alert("고지년월을 선택해 주세요."); $("#searchYm").focus();	return; }
		
		if (confirm("분납생성을 실행 하시겠습니까?")) {
			var msg;
			var params = "searchYm="+$("#searchYm").val() ;
			var ajaxCallCmd = "createHealthInsEmpDiv" ;
			var data = ajaxCall("/HealthInsEmpDivMgr.do?cmd="+ajaxCallCmd,params,false);
	    	
	    	if (!data.Result.Code) {
	    		msg = "분납생성 되었습니다." ;
	    		doAction1("Search") ;
	    	} else {
		    	//msg = "분납생성도중 : "+data.Result.Message;
	    		msg = "분납생성에 실패하였습니다.";
	    	}
	    	alert(msg) ;
		}
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td><span>고지년월</span> <input id="searchYm" name="searchYm" type="text" size="10" class="date2 required center" value="${curSysYear}04"/></td>
						<td><span>공제년월</span> 
							<input id="searchPayYmS" name="searchPayYmS" type="text" size="10" class="date2 required center" value="${curSysYear}04"/>~
							<input id="searchPayYmE" name="searchPayYmE" type="text" size="10" class="date2 required center" value="${curSysYear}04"/>
						</td>	
						<td><span><tit:txt mid='112277' mdef='사번/성명 '/></span>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	    <div class="outer">
	        <div class="sheet_title">
	        <ul>
	            <li class="txt">생성</li>
	            <li class="btn">
	            	<a href="javascript:partPayPrc()"				class="basic authA">분납생성</a>
	            	<a href="javascript:doAction1('DownTemplate')" 	class="basic authA">양식다운로드</a>
	            	<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
					<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
					<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
					<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
	            </li>
	        </ul>
	        </div>
	    </div>
    <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
    </form>
</div>
</body>
</html>
