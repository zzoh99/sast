<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>사업장예외관리(연말정산)</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ page import="yjungsan.util.DateUtil"%>

<script type="text/javascript">

	var businessPlaceList = "";		//사업장
	businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBusinessPlaceList","",false).codeList, "전체");

	$(function() {
		$("#menuNm").val($(document).find("title").text());
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		$("#searchSabun").val( $("#searchUserId").val() ) ;

		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata0.Cols = [
                {Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
                {Header:"사번",		    Type:"Text",      	Hidden:0,  	Width:60,		Align:"Center",    	ColMerge:0,   	SaveName:"sabun",   		KeyField:1,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                {Header:"성명",  			Type:"Popup",		Hidden:0,  	Width:70,   	Align:"Center",		ColMerge:0,   	SaveName:"name",			KeyField:0,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                {Header:"대상년도",		Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"work_yy",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
				{Header:"작업구분",		Type:"Combo",		Hidden:0,  	Width:60,		Align:"Center",    	ColMerge:0,   	SaveName:"adjust_type",   	KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                {Header:"기존사업장",		Type:"Combo",      	Hidden:0,  	Width:100,		Align:"Center",    	ColMerge:0,   	SaveName:"std_bp_cd",	 	KeyField:0,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"변경사업장",		Type:"Combo",      	Hidden:0,  	Width:100,		Align:"Center",    	ColMerge:0,   	SaveName:"chg_bp_cd", 		KeyField:1,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
                {Header:"입사일",			Type:"Date",      	Hidden:0,  	Width:80,   	Align:"Center",  	ColMerge:0,   	SaveName:"emp_ymd",			KeyField:0,   	CalcLogic:"",   Format:"Ymd",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
                {Header:"퇴사일",			Type:"Date",      	Hidden:0,  	Width:80,   	Align:"Center",  	ColMerge:0,   	SaveName:"ret_ymd",			KeyField:0,   	CalcLogic:"",   Format:"Ymd",   	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
                {Header:"비고",			Type:"Text",		Hidden:0,  	Width:200,		Align:"Left",    	ColMerge:0,   	SaveName:"bigo", 		  	KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"attr1",		Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"attr1",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"attr2",		Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"attr2",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"attr3",		Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"attr3",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"attr4",		Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"attr4",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"변경대상",		Type:"CheckBox",  	Hidden:0,  	Width:80,   	Align:"Center",  	ColMerge:0,   	SaveName:"chg_chk",			KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:0, TrueValue:"Y", FalseValue:"N"},
				{Header:"취소대상",		Type:"CheckBox",  	Hidden:0,  	Width:80,   	Align:"Center",  	ColMerge:0,   	SaveName:"cancel_chk",		KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:0, TrueValue:"Y", FalseValue:"N"},
				{Header:"상태코드",		Type:"Text",  		Hidden:1,  	Width:80,   	Align:"Center",  	ColMerge:0,   	SaveName:"status_cd",		KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:500},
				{Header:"상태",		    Type:"Text",  		Hidden:0,  	Width:80,   	Align:"Center",  	ColMerge:0,   	SaveName:"status_cdnm",		KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500}
		];
		IBS_InitSheet(sheet1, initdata0);
		sheet1.SetEditable("<%=editable%>");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

        /* 현재년도 */
		//$("#searchWorkYy").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;

		/* 작업구분 */
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
        $("#searchAdjustType").html(adjustTypeList[2]+"<option value='7'>퇴직소득</option>").val("1");
		sheet1.SetColProperty("adjust_type", 		{ComboText: "|" + adjustTypeList[0] + "|" + "퇴직소득", ComboCode: "|" + adjustTypeList[1] + "|" + "7"} );

		/* 사업장 */
	    sheet1.SetColProperty("std_bp_cd", 		{ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );
	    sheet1.SetColProperty("chg_bp_cd", 		{ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );
		$("#searchStdBpCd").html(businessPlaceList[2]);
		$("#searchChgBpCd").html(businessPlaceList[2]);

		var bizPlaceCdList = "";
		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "");
        $("#creTarget").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();

		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});

		$("#searchSabunNameAlias").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});
		doAction1("Search");
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
	        case "Search":
	        	if($("#searchAdjustType").val() == "7"){
	        		$("#showBtn").hide();
	        	}else{
	        		$("#showBtn").show();
	        	}
	        	sheet1.DoSearch( "<%=jspPath%>/yeaExBpCdMgr/yeaExBpCdMgrRst.jsp?cmd=getYeaExBpCdMgr", $("#mySheetForm").serialize() );
	        	break;

	        case "Save":
	        	if($("#searchWorkYy").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	// if($("#searchAdjustType").val() == "") { alert("작업구분을 선택해 주십시오."); return ; }

	        	/* 중복 사번 /입사일 체크 */
	        	var sabuns = "";
	        	var adjSYmds = "";

		        for(var i=1; i<=sheet1.LastRow()+1; i++) {
		        	if(sheet1.GetCellValue(i, "sStatus") == "I") {
		        		sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
		        		adjSYmds += "'"+sheet1.GetCellValue( i, "adj_s_ymd" ) + "',";
		        	}
		        }

		        if (sabuns.length > 1) {
					sabuns = sabuns.substr(0,sabuns.length-1);
					adjSYmds = adjSYmds.substr(0,adjSYmds.length-1);
		        }

		        if (!dupChk2(sheet1, "sabun|work_yy|adjust_type|std_bp_cd|adj_s_ymd", true, true)) {break;} // 중복체크
	        	sheet1.DoSave( "<%=jspPath%>/yeaExBpCdMgr/yeaExBpCdMgrRst.jsp?cmd=saveYeaExBpCdMgr", $("#mySheetForm").serialize());
	        	break;

	        case "Insert":
	        	if($("#searchWorkYy").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	// if($("#searchAdjustType").val() == "") { alert("작업구분을 선택해 주십시오."); return ; }
	        	var newRow = sheet1.DataInsert(0) ;

	        	sheet1.SetCellEditable(newRow, "sabun",false);
        		sheet1.SetCellValue(newRow, "sStatus",		"I");

	        	break;
	        case "Copy":
	        	var newRow = sheet1.DataCopy();
	        	sheet1.SetCellValue(newRow, "chg_chk",   "0" );
	        	sheet1.SetCellValue(newRow, "status_cd",   "0" );
	        	sheet1.SetCellValue(newRow, "status_cdnm", "적용전" );
	        	//sheet1.SetCellValue(newRow, "sabun",  "" );
	        	//sheet1.SetCellValue(newRow, "name",   "" );
	        	sheet1.SetCellEditable(newRow, "sabun",false);
	        	sheet1.SetCellEditable(newRow, "sDelete",true);
	        	break;
	        case "Clear":       sheet1.RemoveAll(); break;
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
				sheet1.Down2Excel(param); break;
	        case "Down2Template":
	            var titleText  = "작성방법 \n 1. 사번, 변경사업장 은 필수입니다.\n"+
	            				 "2.저장시 해당 Row 삭제 저장 후 Upload 해주시기 바랍니다.\n"+
	            				 "3.변경대상(Y,N)과 취소대상(Y,N)은 둘 중 하나만 선택해 주십시오.";

	            var param  = {DownCols:"sabun|chg_bp_cd|adj_s_ymd|adj_e_ymd|chg_chk|cancel_chk|bigo",SheetDesign:1,Merge:1,DownRows:0,FileName:'Template',SheetName:'sheet1',UserMerge:"0,0,1,5",TitleText:titleText, ExcelRowHeight:100 ,menuNm:$(document).find("title").text()};
	            sheet1.Down2Excel(param);
				break;
	        case "LoadExcel":
	        	if($("#searchWorkYy").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	if($("#searchAdjustType").val() == "") { alert("작업구분을 선택해 주십시오."); return ; }

	        	//doAction1("Clear") ;
	        	var params = {Mode:"HeaderMatch", WorkSheetNo:1, Append :1};

	        	sheet1.LoadExcel(params);
	        	break;
        }
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	//팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openOwnerPopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//사원 조회
	function openOwnerPopup(Row){
	    try{
	    	if(!isPopup()) {return;}
	    	gPRow = Row;
	    	pGubun = "ownerPopup";
	     	var args    = new Array();
			var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");

	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//팝업 결과
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(rv["result"] == "Y"){
			doAction1("Search");
		}
		if ( pGubun == "ownerPopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "std_bp_cd", 	rv["business_place_cd"] );
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {

		try { if (Msg != "") { alert(Msg); doAction1("Search");}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 복사 프로시저
	function callProc(sts) {
		var params = $("#mySheetForm").serialize();
		var msg = "";

		// 변경적용
		if(sts == "chg") {
			params += "&searchPGubun=1";
			params += "&businessCd="+$("#creTarget").val();
			msg = "변경대상";
		}else if(sts == "can"){
			params += "&searchPGubun=2";
			params += "&businessCd="+$("#creTarget").val();
			msg = "취소대상";
		}else{
			params += "&searchPGubun=0";
			params += "&businessCd="+$("#creTarget").val();
		}

		var text = "";

		//연말정산(1)	퇴직정산(2)
		if($("#searchAdjustType").val() == "1"){
			text = "연말정산";
		}else if($("#searchAdjustType").val() == "3"){
			text = "퇴직정산";
		}

		if(confirm($('#searchWorkYy').val()+"년 "+text+"관리에 등록된 대상자 중 \n"+msg+"에 체크된 인원들에 대해 사업장을 일괄 변경합니다.\n진행하시겠습니까?")){
			var data = ajaxCall("<%=jspPath%>/yeaExBpCdMgr/yeaExBpCdMgrRst.jsp?cmd=P_CPN_YEA_EX_BP_CHG",params,false);

			if(data.Result.Code == 1) {
				doAction1("Search");
			}
			else {
				msg = "처리도중 문제발생 : "+data.Result.Message;
			}
		}
	}

	function dupChk2(objSheet, keyCol, delchk, firchk){

		var duprows = objSheet.ColValueDupRows(keyCol, delchk, true);

		var arrRow=[];
	    var arrCol=duprows.split("|");
	    var sumCnt = 0;

	    if(arrCol[1] && arrCol[1]!=""){
	    	arrRow=arrCol[1].split(",");
	        for(j=0;j<arrRow.length;j++){
	        	if(isNaN(objSheet.GetCellValue(arrRow[j], "sNo")) == true) {
	        		sumCnt++;
	        		continue;
	        	}
	        	objSheet.SetRowBackColor(arrRow[j],"#FACFED");
	        }

	    }else{
	      var j =0;
	    }
	    j = j - sumCnt;
	    if(j>0){
	        alert("중복된 값이 존재 합니다.");
	        return false;
	    }
	    return true;
	}

	// 변경,취소대상 체크
	function sheet1_OnChange(Row, Col, Val){

		if(sheet1.ColSaveName(Col) == "chg_chk"){
			if(sheet1.GetCellValue(Row, "chg_chk") == "Y" && sheet1.GetCellValue(Row, "cancel_chk") == "Y"){
				sheet1.SetCellValue(Row, "cancel_chk","N");
			}
		}
		if(sheet1.ColSaveName(Col) == "cancel_chk"){
			if(sheet1.GetCellValue(Row, "chg_chk") == "Y" && sheet1.GetCellValue(Row, "cancel_chk") == "Y"){
				sheet1.SetCellValue(Row, "chg_chk","N");
			}
		}
	}

    function sheet1_OnLoadExcel() {
        try {
        	var flag = false;
        	for(var i = 1; i < sheet1.RowCount()+1; i++) {
				if(sheet1.GetCellValue(i, "chg_chk") == "Y" && sheet1.GetCellValue(i, "cancel_chk") == "Y"){
					//20250428. 성능저하로 인하여 onChange 이벤트가 가 발생하지 않도록 SetCellValue2 사용
					flag = true;
					sheet1.SetCellValue2(i, "chg_chk","N");
					sheet1.SetCellValue2(i, "cancel_chk","N");
				}
        	}
        	if(flag == true){
        		alert("변경대상과 취소대상은 둘 중 하나만 선택 가능합니다. ");
        	}
        } catch (ex) {
            alert("OnLoadExcel Event Error : " + ex);
        }
    }

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <div class="sheet_search outer">
    <form id="mySheetForm" name="mySheetForm" >
    <input type="hidden" id="searchSabun" 		name="searchSabun" 		value ="" />
    <input type="hidden" id="menuNm" name="menuNm" value="" />
        <div>
        <table>
        <tr>
            <td><span>년도</span>
			<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text" maxlength="4" style= "width:40px; padding-left: 10px;"/> </td>
			<td><span>정산구분</span>
				<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
			<td><span>변경대상</span>
				<select id="searchChgType" name ="searchChgType" onChange="javascript:doAction1('Search')" class="box">
					<option selected="selected" value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</td>
			<td><span>취소대상</span>
				<select id="searchCancleType" name ="searchCancleType" onChange="javascript:doAction1('Search')" class="box">
					<option selected="selected" value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
				</select>
			</td>
			<td><span>상태</span>
				<select id="searchStatusCd" name ="searchStatusCd" onChange="javascript:doAction1('Search')" class="box">
					<option selected="selected" value="">전체</option>
					<option value="0">적용전</option>
					<option value="1">변경완료</option>
					<option value="2">취소완료</option>
				</select>
			</td>
		</tr>
		<tr>
			<td><span>기존사업장</span>
				<select id="searchStdBpCd" name ="searchStdBpCd" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
			<td><span>변경사업장</span>
				<select id="searchChgBpCd" name ="searchChgBpCd" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
			<td><span>사번/성명</span>
				<input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
            <td><a href="javascript:doAction1('Search');" class="button">조회</a></td>
        </tr>
        </table>
        </div>
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">사업장예외관리  <font class="red">(신고파일 작업시 사업장)</font></li>
            <li class="btn">
              <span>기존사업장에서 변경할 사업장</span>
              <select id="creTarget" name ="creTarget" class="box"></select>
			  <a href="javascript:callProc('cretarget');" class="basic btn-red authA" id="showBtn">대상자일괄생성</a>
			  <a href="javascript:callProc('chg');" class="basic btn-white out-line authA">변경적용</a>
			  <a href="javascript:callProc('can');" class="basic btn-white authA">취소적용</a>
              <a href="javascript:doAction1('Down2Template')"   class="basic btn-download authR">양식 다운로드</a>
              <a href="javascript:doAction1('LoadExcel')"   class="basic btn-upload authA">업로드</a>
              <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   class="basic btn-save authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>