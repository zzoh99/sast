<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var p = eval("${popUpStatus}");
	
	$(function() {
		
		var arg = p.window.dialogArguments;
		
		var searchEvlYy;
		var promYn;
	    if( arg != undefined ) {
	    	$("#searchAppraisalCd").val(arg["appraisalCd"]);
	    	$("#searchAppStepCd").val(arg["appStepCd"]);
	    	promYn = arg["promYn"];
	    	searchEvlYy   = arg["searchEvlYy"]
	    }
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"				,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center",		ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제"				,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", 	ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태"				,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", 	ColMerge:0,   SaveName:"sStatus" },
			{Header:"평가명"    			,Type:"Combo",     	Hidden:0,  					Width:100,			Align:"Center", 	ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,	UpdateEdit:0,   InsertEdit:0,   EditLen:4 },  
			{Header:"평가단계"			,Type:"Combo",     	Hidden:0,  					Width:70,			Align:"Center", 	ColMerge:0,   SaveName:"appStepCd",		KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }, 
			{Header:"평가차수"			,Type:"Combo",     	Hidden:0,  					Width:70,			Align:"Center", 	ColMerge:0,   SaveName:"appraisalSeq",	KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"평가차수\n시작일"		,Type:"Date",		Hidden:0,  					Width:80,			Align:"Center", 	ColMerge:0,   SaveName:"appAsYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"평가차수\n종료일"		,Type:"Date",		Hidden:0,  					Width:80,			Align:"Center", 	ColMerge:0,   SaveName:"appAeYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		
		var famList;
		if(promYn == null || promYn == "undefined"){
			famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppScheduleCodeList&searchEvlYy="+searchEvlYy,false).codeList, "");	
		}else{
			famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchEvlYy="+searchEvlYy+"&searchAppTypeCd=Z,",false).codeList, "");
		}
		
		sheet1.SetColProperty("appraisalCd", {ComboText:famList[0], ComboCode:famList[1]} );
		
		var codeList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00005"), "");		//평가단계
		sheet1.SetColProperty("appStepCd", {ComboText:codeList1[0], ComboCode:codeList1[1]} );
		
		var codeList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00003"), "");		//평가차수
		sheet1.SetColProperty("appraisalSeq", {ComboText:codeList2[0], ComboCode:codeList2[1]} );
		
		$(".close").click(function() {
			p.self.close();
	    });
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppScheduleMgr.do?cmd=getAppScheduleMgrPopList", $("#srchFrm").serialize() ); break;
		case "Save": 		
			
			if (!dupChk(sheet1, "appraisalCd|appStepCd|appraisalSeq", false, true)) {break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppScheduleMgr.do?cmd=saveAppScheduleMgrPop", $("#srchFrm").serialize()); break;
		case "Insert":		
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
			sheet1.SetCellValue(Row, "appStepCd",   $("#searchAppStepCd").val());
			sheet1.SelectCell(Row, "appraisalSeq");
		break;
		case "Copy":		sheet1.DataCopy(); break;
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
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>평가차수 일정</li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
                <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/> 
                <input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value=""/> 
                
            
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">대상평가 정의</li>
					<li class="btn">
						<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
						<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
						<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>