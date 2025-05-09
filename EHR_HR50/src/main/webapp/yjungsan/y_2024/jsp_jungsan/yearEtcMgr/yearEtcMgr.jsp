<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 기타소득</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var adjustTypeList = null;
	var adjTypeCmbList = null;

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
	        {Header:"년도",		Type:"Text",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"work_yy",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
	        {Header:"정산구분",		Type:"Combo",      	Hidden:0,  Width:120,    Align:"Center", ColMerge:1,   SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"부서명",		Type:"Text",      	Hidden:0,  Width:70,    Align:"Center", ColMerge:1,   SaveName:"org_nm",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"성명",		Type:"Popup",      	Hidden:0,  Width:70,    Align:"Center", ColMerge:1,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
	        {Header:"사번",		Type:"Text",      	Hidden:0,  Width:70,    Align:"Center", ColMerge:1,   SaveName:"sabun",				KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
	        {Header:"소득구분명",	Type:"Combo",      	Hidden:0,  Width:145,   Align:"Left",	ColMerge:1,   SaveName:"adj_element_cd",	KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
            {Header:"소득구분명",  Type:"Text",       Hidden:1,  Width:145,   Align:"Left",   ColMerge:1,   SaveName:"adj_element_nm",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
	        {Header:"지급월",		Type:"Date",      	Hidden:0,  Width:100,   Align:"Center",	ColMerge:1,   SaveName:"ym",				KeyField:1,   CalcLogic:"",   Format:"Ym",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:6 },
	        {Header:"총액",		Type:"AutoSum",		Hidden:0,  Width:110,   Align:"Right",  ColMerge:1,   SaveName:"mon",				KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:160 },
	        {Header:"비과세액or감면세액",	Type:"AutoSum",		Hidden:0,  Width:110,   Align:"Right",  ColMerge:1,   SaveName:"notax_mon",			KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"과세액",		Type:"AutoSum",		Hidden:0,  Width:110,   Align:"Right",  ColMerge:1,   SaveName:"tax_mon",			KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"비고",		Type:"Text",        Hidden:0, 	Width:150,	Align:"Left",	ColMerge:0,   SaveName:"memo",   		    KeyField:0,   CalcLogic:"",   Format:"", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 }
	    ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);

        sheet1.SetCountPosition(4);

		//작업구분
		/* 2019. 기존:C00303 -> 원천징수부 신청도 포함 */
		adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchYear="+$("#srchYear").val(),"getEachAdjstTypeList") , "");
	    adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"getYearEndItemList") , "전체");

        sheet1.SetColProperty("adj_element_cd",	{ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );
		sheet1.SetColProperty("adjust_type", 	{ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});

		$("#srchIncomeType").html(adjTypeCmbList[2]);

    	// 사업장(권한 구분)
    	var ssnSearchType = "<%=ssnSearchType%>";
    	var bizPlaceCdList = "";

    	if(ssnSearchType == "A"){
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
    	}else{
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
    	}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();
		getCprBtnChk();
		doAction1("Search");

		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		templeteTitle1 += "지급월 : YYYY-MM   예)2013-01 \n";
	
		codeCdNm = "";
		codeNm = adjTypeCmbList[0].split("|"); codeCd = adjTypeCmbList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "소득구분명 : " + codeCdNm + "\n";

	});

	$(function() {

		$("#srchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}

			if( $("#srchYear").val().length == 4 ) {
		        var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"getYearEndItemList") , "전체");
				$("#srchIncomeType").html(adjTypeCmbList[2]);
		        sheet1.SetColProperty("adj_element_cd", {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );
			}
		});

        $("#srchSbNm,#srchIncomeTypeTxt").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
            }
        });

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "cmd=selectYearEtcMgr&"+$("#srchFrm").serialize();
			sheet1.DoSearch( "<%=jspPath%>/yearEtcMgr/yearEtcMgrRst.jsp", param );
			break;
		case "Save":
			if(!isNumberChk()) {
				/* alert("금액은 정수(양수)만 입력해 주세요."); */
				break;
			}
			
			//출산지원금은 출산지원금내역관리 화면에서 입력 할 수 있도록 체크로직 추가
			var birthYn = 0;
			var birthRow = "";
			for(var i=1; i <= sheet1.LastRow(); i++) {
				if(sheet1.GetCellValue(i,"sStatus") == "I") {
					if(sheet1.GetCellValue(i, "adj_element_cd") == "C010_156" ||
							sheet1.GetCellValue(i, "adj_element_cd") == "C010_157"){
						birthYn++;
						birthRow = i;
					}
				}	
			}
			if(birthYn > 0) {
				if(birthYn > 1) {
					birthYn = birthYn-1;
					alert(birthRow+"번째 행 외"+String(birthYn)+"건 의 출산지원금(Q03, Q04) 관련정보는 [출산지원금내역관리]화면에서 입력해 주시길 바랍니다.");
					return;		
				}
				alert(birthRow+"번째 행의 출산지원금(Q03, Q04) 관련정보는 [출산지원금내역관리]화면에서 입력해 주시길 바랍니다.");
				return;		
			}
			
			/* 2021-01-20 : 저장시 자동 세팅하여 저장 로직으로 xml 변경
			if(!isMonChk()) {
				alert("기타소득(인정상여), 기타소득(급여), 기타소득(상여) 인 경우 비과세액이 존재하거나 총액과 과세액이 일치하지 않습니다.");
				break;
			}*/
			// 중복체크
			if (!dupChk(sheet1, "work_yy|adjust_type|sabun|adj_element_cd|ym", true, true)) {break;}
			sheet1.DoSave( "<%=jspPath%>/yearEtcMgr/yearEtcMgrRst.jsp", $("#srchFrm").serialize() + "&cmd=saveYearEtcMgr");
			break;
		case "Insert":
			if ($("#srchAdjustType").val() == "") {
				alert("정산구분을 먼저 지정하십시오.");
				break;
			}
			
			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "work_yy", $("#srchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#srchAdjustType").val() ) ;
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
       case "Down2Template":
           //var downcol = makeHiddenSkipCol(sheet1);
           var downcol = "sabun|adj_element_cd|ym|mon|memo"; //notax_mon, tax_mon 시스템이 처리함
           var param  = {DownCols:downcol,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
									,TitleText:templeteTitle1,UserMerge :"0,0,1,5",menuNm:$(document).find("title").text()};
		   sheet1.Down2Excel(param);
		   break;
        case "LoadExcel":
			if ($("#srchAdjustType").val() == "") {
				alert("정산구분을 먼저 지정하십시오.");
				break;
			}
			
		    var params = {Mode:"HeaderMatch", WorkSheetNo:1};
		    sheet1.LoadExcel(params);
		    break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {

			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1('Search');
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try{
			if(sheet1.ColSaveName(Col) == "mon"||sheet1.ColSaveName(Col) == "sDelete"){
				if(sheet1.GetCellValue(Row, "adj_element_cd") == "C010_156" ||
						sheet1.GetCellValue(Row, "adj_element_cd") == "C010_157"){
					alert("출산지원금(Q03, Q04) 관련정보는 [출산지원금내역관리]화면에서 입력해 주시길 바랍니다.");
					if(sheet1.ColSaveName(Col) == "mon") {
						sheet1.SetCellValue(Row, "mon", OldValue, 0);	
					} else {
						sheet1.SetCellValue(Row, "sDelete", OldValue, 0);	
					}
					return;
				}
			}

			if(sheet1.ColSaveName(Col) == "ym"){
				if(sheet1.GetCellValue(Row, "ym") != ""){
					if(sheet1.GetCellValue(Row, "ym").substring(0,4) != $("#srchYear").val()){
						alert("대상년도와 지급월이 다릅니다. 확인해 주십시오.");
						sheet1.SetCellValue(Row, "ym", "");
					}
				}
			}

			if(sheet1.ColSaveName(Col) == "mon"	|| sheet1.ColSaveName(Col) == "notax_mon" || sheet1.ColSaveName(Col) == "tax_mon") {
				isNumberChk();
			}
			
			if(sheet1.ColSaveName(Col) == "adj_element_cd"){
				//출산지원금은 출산지원금내역관리 화면에서 입력 할 수 있도록 체크로직 추가
				if(sheet1.GetCellValue(Row, "adj_element_cd") == "C010_156" ||
						sheet1.GetCellValue(Row, "adj_element_cd") == "C010_157"){
					alert("출산지원금(Q03, Q04) 관련정보는 [출산지원금내역관리]화면에서 입력해 주시길 바랍니다.");
					sheet1.SetCellValue(Row, "adj_element_cd", "");
					return;
				}
			}
			
			/* 소득구분 T01, T02 외국인기술자 감면세액에 관한 로직 임시 주석 (2020-11-18)
			if(sheet1.ColSaveName(Col) == "adj_element_cd"){
				if(sheet1.GetCellValue(Row, "adj_element_cd") == "C010_79" || sheet1.GetCellValue(Row, "adj_element_cd") == "C010_80" ){
					alert("해당 소득구분은 자료등록( 세액감면/기타세액공제 )에서 "+"\n등록해 주시기 바랍니다.");
					sheet1.SetCellValue(Row, "adj_element_cd","");
				}
			}
			*/

		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	function adjElementCdOnChange(){

	}


	var gPRow  = "";
	var pGubun = "";

	// 사원 조회
	function openEmployeePopup(Row){
	    try{

	    	if(!isPopup()) {return;}
	    	gPRow  = Row;
			pGubun = "employeePopup";

		    var args    = new Array();
		    var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
	     /*
	        if(rv!=null){
				sheet1.SetCellValue(Row, "name", 		rv["name"] );
				sheet1.SetCellValue(Row, "sabun", 		rv["sabun"] );
				sheet1.SetCellValue(Row, "org_nm", 		rv["org_nm"] );
	        }
	     */
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm", 	rv["org_nm"] );
		}
	}

	function isMonChk() {
		var isMon = true;
		// 기타소득(인정상여), 기타소득(급여), 기타소득(상여) 일때 금액 체크 - 2020.03.06.
		if(sheet1.RowCount() > 0) {
			for(var	i = 1; i < sheet1.RowCount()+1;	i++) {
				if(sheet1.GetCellValue(i, "adj_element_cd") == "C010_20" ||
				    sheet1.GetCellValue(i, "adj_element_cd") == "C010_22" ||
					sheet1.GetCellValue(i, "adj_element_cd") == "C010_15" ){

					//비과세액 체크
					if(sheet1.GetCellValue(i, "notax_mon") != 0) {
						isMon = false;
						break;
					}

					// 총액, 과세액 체크
					if(sheet1.GetCellValue(i, "mon") != sheet1.GetCellValue(i, "tax_mon")) {
						isMon = false;
						break;
					}
				}

			}
		}

		return isMon;
	}


	function isNumberChk() {
		var isNumber = true;
		var reg = /-?\d+$/;

		if(sheet1.RowCount() > 0) {
			for(var	i = 1; i < sheet1.RowCount()+1;	i++) {
				if(sheet1.GetCellValue(i, "sStatus") == 'I' || sheet1.GetCellValue(i, "sStatus") == 'U') {
					//정수가 아닌 경우 체크

					// 총액
					if(reg.test(sheet1.GetCellValue(i,"mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "mon", sheet1.GetCellBackColor(i, "memo") );
					}

					// 비과세액
					if(reg.test(sheet1.GetCellValue(i,"notax_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "notax_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "notax_mon", sheet1.GetCellBackColor(i, "memo") );
					}

					// 과세액
					if(reg.test(sheet1.GetCellValue(i,"tax_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "tax_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "tax_mon", sheet1.GetCellBackColor(i, "memo") );
					}
				}
			}
		}
		return isNumber;
	}
	  //업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
        try {
        	//
        } catch(ex) {
            alert("OnLoadExcel Event Error " + ex);
        }
    }
	  
    //수정(이력) 관련 세팅
	function getCprBtnChk(){
       var params = "&cmbMode=all"
                  + "&searchWorkYy=" + $("#srchYear").val() 
                  + "&searchAdjustType="
                  + "&searchSabun=" ;
       
       //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#srchAdjustType").html("");
		} else {   			
  			$("#srchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
  			$("#srchAdjustType").append("<option value='9'>원천징수부</option>");
  			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0]+"|원천징수부", ComboCode:"|"+searchReCalcSeq[1]+"|9"});
		}
	}	  

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="srchOrgCd" name="srchOrgCd" value =""/>
		<input type="hidden" id="menuNm" name="menuNm" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
					    <td>
					    	<span>년도</span>
							<%-- 무의미한 분기문 주석 처리 20240919
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							--%>
								<input id="srchYear" name ="srchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" value="<%=yeaYear%>" readonly="readonly" />
							<%-- 무의미한 분기문 주석 처리 20240919}else{%>
							    <input id="srchYear" name ="srchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" value="<%=yeaYear%>" readonly="readonly" />
							<%}--%>
						</td>
						<td>
							<span>정산구분</span>
							<select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
                        <td>
                            <span>사업장</span>
                            <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                        </td>
					</tr>
					<tr>
						<td>
							<span>구분</span>
							<select id="srchIncomeType" name ="srchIncomeType" onChange="javascript:doAction1('Search')" class="box"></select>
						</td>
                        <td>
                            <span>소득구분명</span>
                            <input id="srchIncomeTypeTxt" name ="srchIncomeTypeTxt" type="text" class="text" maxlength="15" style="width:150px"/>
                        </td>

						<td>
							<span>사번/성명</span>
							<input id="srchSbNm" name ="srchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
			<li id="txt" class="txt">연말정산 기타소득</li>
			<li class="btn">
				<!-- <font class="blue">[ (-)금액은 '연간소득관리>연간소득_개별' 에서 총금액 확인 및 등록 ]&nbsp;</font> -->
				<a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 			class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic btn-download authA">다운로드</a>
			</li>
        </ul>
        </div>
    </div>

	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>