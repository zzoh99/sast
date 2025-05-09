<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var cmbLst1 ="";
var cmbLst2 ="";
var cmbLst3 ="";

$(function() {
	$("#searchAppraisalCd").bind("change", function(event) {
		cmbLst1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppPeopleMgrAppGroupCd&searchAppSeqCd=1&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");  //1차평가그룹
		cmbLst2 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppPeopleMgrAppGroupCd&searchAppSeqCd=2&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");  //2차평가그룹
		cmbLst3 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppPeopleMgrAppGroupCd&searchAppSeqCd=6&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, "");  //3차평가그룹
		
		$("#searchAppSeqCd").change();
	});

	$("#searchAppSeqCd").bind("change", function(event) {
		if ($("#searchAppSeqCd").val() == "") {
			$("#searchGroupCd").html("");
			
			$("#searchGroupCd").attr("disabled", true);
		} else {
			$("#searchGroupCd").removeAttr("disabled");
			
			var groupCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", "queryId=getAppGroupCdList"
					+ "&searchAppraisalCd=" + $("#searchAppraisalCd").val()
					+ "&searchAppStepCd=5"
					+ "&searchAppSeqCd=" + $("#searchAppSeqCd").val()
					,false).codeList, "전체");
			$("#searchGroupCd").html(groupCdList[2]);
		}
		
		$("#searchGroupCd").change();
	});

	$("#searchGroupCd").bind("change", function(event) {
		doAction1("Search");
	});

	$("#searchAppSabunName").bind("keyup", function(event) {
		if (event.keyCode == 13) { doAction1("Search"); $(this).focus(); }
	});

	var initdata = {};
	initdata.Cfg = {FrozenCol:20,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"No|No",                Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:1, SaveName:"sNo" },
		{Header:"삭제|삭제",            Type:"${sDelTy}",   Hidden:1,   Width:"${sDelWdt}", Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
		{Header:"상태|상태",            Type:"${sSttTy}",   Hidden:1,   Width:"${sSttWdt}", Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
		{Header:"선택|선택",            Type:"DummyCheck",  Hidden:0,   Width:40,           Align:"Center", ColMerge:1, SaveName:"chk",                 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 },
		{Header:"차수|차수",            Type:"Combo",       Hidden:0,   Width:70,           Align:"Center", ColMerge:1, SaveName:"appSeqCd",        KeyField:1, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"평가자|성명",          Type:"Popup",       Hidden:0,   Width:80,           Align:"Center", ColMerge:0, SaveName:"appName",                KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"평가자|사번",          Type:"Text",        Hidden:0,   Width:80,           Align:"Center", ColMerge:0, SaveName:"appSabun",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"평가자|직책",          Type:"Text",        Hidden:0,   Width:80,           Align:"Center", ColMerge:0, SaveName:"jikchakNm",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"평가자|직위",          Type:"Text",        Hidden:0,   Width:80,           Align:"Center", ColMerge:0, SaveName:"jikweeNm",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"평가자|직급",          Type:"Text",        Hidden:0,   Width:80,           Align:"Center", ColMerge:0, SaveName:"jikgubNm",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"평가자|평가그룹",      Type:"Text",        Hidden:0,   Width:250,          Align:"Left",   ColMerge:0, SaveName:"appGroupCd",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"평가자|평가대상인원",  Type:"Text",        Hidden:0,   Width:50,           Align:"Center", ColMerge:0, SaveName:"cnt",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"평가ID|평가ID",        Type:"Text",        Hidden:1,   Width:100,          Align:"Center", ColMerge:0, SaveName:"appraisalCd",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	var appraisalCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", "queryId=getAppraisalCdList", false).codeList, "");
	$("#searchAppraisalCd").html(appraisalCdList[2]);

	var appSeqCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", "queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote1=Y", false).codeList, "");
	$("#searchAppSeqCd").html("<option value=''>전체</option>" + appSeqCdList[2]);

	sheet1.SetColProperty("appSeqCd", {ComboText:"|" + appSeqCdList[0], ComboCode:"|" + appSeqCdList[1]});

	$(window).smartresize(sheetResize); sheetInit();
	
	$("#searchAppraisalCd").change();
});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AppResultMgr.do?cmd=getAppDirectorResultMgrList", $("#srchFrm").serialize() );
			break;
		case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param = {DownCols:downcol, SheetDesign:1, Merge:1};
            sheet1.Down2Excel(param);
            break;			
		case "Print": //출력
			rdPopup();
			break;
		}
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		var w 		= 1200;
		var h 		= 700;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		var rdMrd   = "pap/progress/App1stResult_HICAR.mrd";
		var rdTitle = "평가집계표출력";
		var rdParam = "";

		var str = "";
        var rowCnt = sheet1.CheckedRows("chk");
        if(rowCnt == 0) {
            alert("대상자를 선택하여 주세요.");
            return;
        }

        var rows = sheet1.FindCheckedRow("chk");
        var arrRow = rows.split("|");

        for(var i = 0; i < arrRow.length; i++) {
            if( i == 0 ) {
            	str       = "('"+sheet1.GetCellValue(arrRow[i],"appSeqCd")+"','"+sheet1.GetCellValue(arrRow[i],"appSabun")+"','"+sheet1.GetCellValue(arrRow[i],"appGroupCd")+"')";
            } else {
            	str       += ",('"+sheet1.GetCellValue(arrRow[i],"appSeqCd")+"','"+sheet1.GetCellValue(arrRow[i],"appSabun")+"','"+sheet1.GetCellValue(arrRow[i],"appGroupCd")+"')";
            }
        } 

        rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
        rdParam  = rdParam +"["+ $("#searchAppraisalCd").val() +"] "; //평가ID
        rdParam  = rdParam +"[5] "; //단계
        rdParam  = rdParam +"["+str+"] "; //피평가자 사번, 평가소속
        rdParam  = rdParam +"[A] "; //평가결과>평가집계표출력에서 출력되는 출력물 구분자값
        
        

        var imgPath = " " ;
        args["rdTitle"] = rdTitle ; //rd Popup제목
        args["rdMrd"] =  rdMrd;     //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
        args["rdParam"] = rdParam;  //rd파라매터
        args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
        args["rdToolBarYn"] = "Y" ; //툴바여부
        args["rdZoomRatio"] = "100";//확대축소비율

        args["rdSaveYn"]    = "Y" ;//기능컨트롤_저장
        args["rdPrintYn"]   = "Y" ;//기능컨트롤_인쇄
        args["rdExcelYn"]   = "Y" ;//기능컨트롤_엑셀
        args["rdWordYn"]    = "Y" ;//기능컨트롤_워드
        args["rdPptYn"]     = "Y" ;//기능컨트롤_파워포인트
        args["rdHwpYn"]     = "Y" ;//기능컨트롤_한글
        args["rdPdfYn"]     = "Y" ;//기능컨트롤_PDF

        gPRow = "";
        pGubun = "rdPopup";

        openPopup(url,args,w,h);//알디출력을 위한 팝업창
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			
			for (var i = sheet1.HeaderRows(); i < sheet1.RowCount() + sheet1.HeaderRows(); i++) {
				switch (sheet1.GetCellValue(i, "appSeqCd")) {
				// 1차평가
				case "1":
					sheet1.InitCellProperty(i, "appGroupCd", {Type:"Combo", ComboCode:"|" + cmbLst1[1], ComboText:"|" + cmbLst1[0], Edit:0});
					break;
				// 2차평가
				case "2":
					sheet1.InitCellProperty(i, "appGroupCd", {Type:"Combo", ComboCode:"|" + cmbLst2[1], ComboText:"|" + cmbLst2[0], Edit:0});
					break;
				// 3차평가
				case "6":
					sheet1.InitCellProperty(i, "appGroupCd", {Type:"Combo", ComboCode:"|" + cmbLst3[1], ComboText:"|" + cmbLst3[0], Edit:0});
					break;
				default:
					sheet1.InitCellProperty(i, "appGroupCd", {Type:"Text", Edit:0});
					break;
				}
			}
			
			sheetResize();

		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function sheet1_OnChange(Row, Col, Value) {
        try{
            if( sheet1.ColSaveName(Col) == "appSeqCd" ) {
                if(sheet1.GetCellValue(Row,"appSeqCd") == "1"){
                   sheet1.InitCellProperty(Row,"appGroupCd", {Type:"Combo", ComboCode:"|"+cmbLst1[1], ComboText:"|"+cmbLst1[0],Edit:0});
                }else if(sheet1.GetCellValue(Row,"appSeqCd") == "2"){
                   sheet1.InitCellProperty(Row,"appGroupCd", {Type:"Combo", ComboCode:"|"+cmbLst2[1], ComboText:"|"+cmbLst2[0],Edit:0});
                }else if(sheet1.GetCellValue(Row,"appSeqCd") == "6"){
                   sheet1.InitCellProperty(Row,"appGroupCd", {Type:"Combo", ComboCode:"|"+cmbLst3[1], ComboText:"|"+cmbLst3[0],Edit:0});
                }else{
               	sheet1.InitCellProperty(Row,"appGroupCd", {Type:"Text", Edit:0});
                }
            }
        }catch(ex){alert("OnChange Event Error : " + ex);}
       }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try{
            if(Msg != ""){
                alert(Msg);
            }
            if ( Code != "-1" ) doAction1("Search");
        }catch(ex){
            alert("OnSaveEnd Event Error " + ex);
        }
    }

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	
	//Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{


        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }


    //팝업 콜백 함수.
    function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');
        
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
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td>
                            <span>평가자명/사번</span>
                            <input id="searchAppSabunName" name="searchAppSabunName" type="text" class="text" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span>평가차수</span>
                            <select name="searchAppSeqCd" id="searchAppSeqCd"></select>
                        </td>
                        <td>
                            <span>평가그룹</span>
                            <select name="searchGroupCd" id="searchGroupCd"></select>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>

    <table class="sheet_main">
        <tr>
            <td>
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt">평가집계표출력</li>
                            <li class="btn">
                            <%-- 
                                <a href="javascript:grpPopup();"        class="button authA">평가그룹결과</a>
                                <a href="javascript:doAction1('Insert')"        class="basic authA" id="btnInsert">입력</a> 
                                <a href="javascript:doAction1('Save')"          class="basic authA" id="btnSave">저장</a>
                                
                                <a href="javascript:doAction1('Down2Excel')"    class="basic authR">다운로드</a>
                                --%>
                                <a href="javascript:doAction1('Print')"         class="btn outline_gray authR">출력</a>
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