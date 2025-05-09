<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기타소득업로드</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ page import="yjungsan.util.DateUtil"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var residencyList     = "";		//거주지국
	var residencyTypeList = "";		//거주자구분
	var businessPlaceList = "";		//사업장
	var citizenTypeList   = "";		//내외국인
	var sendTypeList	  = "";		//신고구분
    var monthSeq          = "";
	var chkRow;
	var titleList = new Array();    //상.하반기 타이틀리스트

	var searchYM = <%=curSysYear%>;
	
	if(<%=curSysMon%> >= 1 && <%=curSysMon%> < 7){
		searchYM = searchYM + "06";
	}
	else{
		searchYM = searchYM + "12";
	}
	
	residencyList     = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+searchYM,"H20290"), "");
	residencyTypeList = {ComboText:"거주자|비거주자", ComboCode:"1|2"};
	citizenTypeList   = {ComboText:"내국인|외국인" , ComboCode:"1|9"};
	sendTypeList      = {ComboText:"정기|수정"    , ComboCode:"1|2"};

	// 사업장(권한 구분)
	var ssnSearchType = "<%=removeXSS(ssnSearchType, '1')%>";

	if(ssnSearchType == "A"){
		businessPlaceList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
	}else{
		businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
	}

	$(function() {
		$("#menuNm").val($(document).find("title").text()); //엑셀,CURD

		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata0.Cols = [
                {Header:"No|No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제|삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태|상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },				

                {Header:"대상년도|대상년도",       Type:"Text",      Hidden:1,   Width:40,       Align:"Center",    ColMerge:0,     SaveName:"work_yy",            KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
                {Header:"소득귀속년도|소득귀속년도", Type:"Text",      Hidden:1,   Width:40,       Align:"Center",     ColMerge:0,     SaveName:"cre_work_yy",       KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
				{Header:"사번|사번",		      Type:"Text",      Hidden:0,  	Width:60,		Align:"Center",    	ColMerge:0,   	SaveName:"sabun",   		  KeyField:1,     CalcLogic:"",   Format:"",     	  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                {Header:"성명|성명",  			  Type:"Popup",		Hidden:0,  	Width:50,   	Align:"Center",		ColMerge:0,   	SaveName:"name",			  KeyField:0,     CalcLogic:"",   Format:"",      	  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                {Header:"반기구분코드|반기구분코드", Type:"Text",      Hidden:1,   Width:50,       Align:"Center",     ColMerge:0,     SaveName:"half_type",         KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
                {Header:"신고\n구분|신고\n구분",   Type:"Combo",		Hidden:1,  	Width:30,   	Align:"Center",		ColMerge:0,   	SaveName:"send_type",		  KeyField:0,     CalcLogic:"",   Format:"",      	  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                {Header:"소득구분|소득구분",       Type:"Text",      Hidden:1,   Width:50,       Align:"Center",     ColMerge:0,     SaveName:"income_type",       KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                {Header:"근무시작일|근무시작일",    Type:"Date",      Hidden:0,   Width:70,       Align:"Center",     ColMerge:0,     SaveName:"adj_s_ymd",         KeyField:0,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
                {Header:"월 구분|월 구분",         Type:"Combo",      Hidden:0,   Width:40,      Align:"Center",     ColMerge:0,     SaveName:"month_seq",         KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:2 },
				{Header:"합계|급여 등",		      Type:"AutoSum",	Hidden:0,  	Width:70,		Align:"Right",    	ColMerge:1,   	SaveName:"tax_mon",   		  KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 , MinimumValue: 0},
				{Header:"합계|인정상여",	      Type:"AutoSum",	Hidden:0,  	Width:70,		Align:"Right",    	ColMerge:1,   	SaveName:"etc_bonus_mon",     KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 , MinimumValue: 0},
				{Header:"합계|소득합계",	      Type:"AutoSum",	Hidden:0,  	Width:80,		Align:"Right",		ColMerge:0,   	SaveName:"tax_mon_total",	  KeyField:0,     CalcLogic:"",   Format:"Integer",	  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500, CalcLogic:"|tax_mon|+|etc_bonus_mon|" },
                {Header:"비고|비고",            Type:"Text",      Hidden:0,   Width:100,      Align:"Left",       ColMerge:0,     SaveName:"bigo",              KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
		]; IBS_InitSheet(sheet1, initdata0); sheet1.SetEditable("<%=editable%>"); sheet1.SetVisible(true); sheet1.SetCountPosition(4);
		sheet1.SetSumValue("sNo", "총  계") ;
		sheet1.SetSumFontBold(1);

		$("#searchYear").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ; 		

		sheet1.SetColProperty("citizen_type"  , citizenTypeList);
		sheet1.SetColProperty("residency_type", residencyTypeList);

		sheet1.SetColProperty("residency_cd"     , {ComboText:"|"+residencyList[0], ComboCode:"|"+residencyList[1]} );
		sheet1.SetColProperty("business_place_cd", {ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );

		$("#searchBusinessPlace").html(businessPlaceList[2]);
		$("#searchSendType").html(sendTypeList[2]);
		sheet1.SetColProperty("send_type", sendTypeList);

        $(window).smartresize(sheetResize);
        sheetInit();

		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});

		$("#searchSabunNameAlias").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});

		var today = new Date();
		var mm = today.getMonth()+1;

		if(mm > 1 && mm < 8){
			// 상반기 (2~7월)
			$("#searchHalfType01").prop("selected", true);
			monthSeq = {ComboText:"1월|2월|3월|4월|5월|6월", ComboCode:"1|2|3|4|5|6"};
			sheet1.SetColProperty("month_seq", monthSeq);
		}else{
			// 하반기 (8~1월)
			if(mm == 1) {
				$("#searchYear").val($("#searchYear").val()-1);
			}
			$("#searchHalfType02").prop("selected", true);
            monthSeq = {ComboText:"7월|8월|9월|10월|11월|12월", ComboCode:"7|8|9|10|11|12"} ;
            sheet1.SetColProperty("month_seq", monthSeq);
		}
		doAction1("Search");
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {

	        case "Search":
	        	if($("#searchYear").val() < "2021" || ($("#searchYear").val() == "2021" &&  $("#searchHalfType").val() == "1")){
	                $("#halfDivFlag").val("false");
	                //월 구분
	                sheet1.SetColHidden(11,1);
	                sheet1.SetColProperty("month_seq", "0");
	            }else{
	                $("#halfDivFlag").val("true");
                    //월 구분
	                sheet1.SetColHidden(11,0);
	                if($("#searchHalfType").val() == "1"){
	                	monthSeq = {ComboText:"1월|2월|3월|4월|5월|6월", ComboCode:"1|2|3|4|5|6"};
	                    sheet1.SetColProperty("month_seq", monthSeq);
	                }else{
	                	monthSeq = {ComboText:"7월|8월|9월|10월|11월|12월", ComboCode:"7|8|9|10|11|12"} ;
	                    sheet1.SetColProperty("month_seq", monthSeq);
	                }
	            }

	        	sheet1.DoSearch( "<%=jspPath%>/simplePymtEtcIncpMgr/simplePymtEtcIncpMgrRst.jsp?cmd=getsimplePymtEtcIncpMgr", $("#mySheetForm").serialize() ); 
	        	break;

	        case "Save":
	        	var msgSts = false;
	        	if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }

				if (!dupChk2(sheet1, "work_yy|send_type|income_type|half_type|sabun|month_seq", true, true)) {break;} // 중복체크

				if(sheet1.RowCount() > 0){
					for(var i=1; i <= sheet1.LastRow(); i++){
			            if( sheet1.GetCellValue( i, "tax_mon") < 0) {
			                msgSts = true;
			            }
			            if( sheet1.GetCellValue( i, "etc_bonus_mon") < 0) {
			                msgSts = true;
			            }
			        }
			        if(msgSts) {
			            alert("급여와 인정상여는 양수로 기입해주십시오.");
			            return;
			        }
				}
	        	sheet1.DoSave( "<%=jspPath%>/simplePymtEtcIncpMgr/simplePymtEtcIncpMgrRst.jsp?cmd=saveSimplePymtEtcIncpMgr", $("#mySheetForm").serialize());
	        	break;

	        case "Insert":
	        	var newRow = sheet1.DataInsert(0) ;
	            sheet1.SetCellValue(newRow, "sStatus", "I");
	        	break;

	        case "Copy":
	            sheet1.DataCopy();
	        	break;

	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
				sheet1.Down2Excel(param,true); break;

	        case "Down2Template":
	            var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	                templeteTitle1 += "1. 근무시작일 : ex>2021-01-01 \n";

                var codeCdNm = "", codeCd = "", codeNm = "";

                codeCdNm = "";
                codeNm = businessPlaceList[0].split("|"); codeCd = businessPlaceList[1].split("|");
                for ( var i=0; i<codeCd.length; i++ ) {
                	codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
                }
                templeteTitle1 += "2. 사업장 : " + codeCdNm + "\n";
                templeteTitle1 += "3. 신고구분:  1-정기, 2-수정 \n";

                var downCol = "";
                if($("#searchYear").val() < "2021" || ($("#searchYear").val() == "2021" &&  $("#searchHalfType").val() == "1")){
                    downCol = "0|5|6|12|13|15";
                }else{
                	downCol = "0|5|6|11|12|13|15";
                    if($("#searchHalfType").val() == "1"){
                        templeteTitle1 += "4. 월:  1-1월, 2-2월, 3-3월, 4-4월, 5-5월, 6-6월 \n";
                    }else{
                        templeteTitle1 += "4. 월:  7-7월, 8-8월, 9-9월, 10-10월, 11-11월, 12-12월 \n";
                    }
                }
                templeteTitle1 += "5. 저장시 해당 Row 삭제 저장 후 Upload 해주시기 바랍니다.\n";

                var param  = {DownCols:downCol,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9",DownRows:"0|1"
	                ,TitleText:templeteTitle1,UserMerge :"0,0,1,15",menuNm:$(document).find("title").text()};

	            sheet1.Down2ExcelBuffer(true);
	            sheet1.Down2Excel(param);
	            sheet1.Down2ExcelBuffer(false);
				break;

	        case "LoadExcel":
	        	var params = {Mode:"HeaderMatch", WorkSheetNo:1, Append :1};
	        	sheet1.LoadExcel(params);
	        	break;
        }
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
				if (Msg != "") alert(Msg);
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
            sheet1.SetCellValue(gPRow, "name",      rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",     rv["sabun"] );
        }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {

		try { if (Msg != "") { alert(Msg); doAction1("Search");}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 업로드 후 메시지
	function sheet1_OnLoadExcel(result) {
		/* 업로드중 소계row hidden */
		sheet1.HideSubSum();
		
        for(var i=1; i <= sheet1.LastRow(); i++){
    		sheet1.SetCellEditable(i, "sabun",false);
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
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <div class="sheet_search outer">
    <form id="mySheetForm" name="mySheetForm" >
    <input id="menuNm" name="menuNm" type="hidden" value ="" />
    <input type="hidden" id="halfDivFlag" name="halfDivFlag" value ="" />
        <div>
	        <table>
		        <tr>
		            <td><span>년도</span>
					<input id="searchYear" name ="searchYear" type="text" class="text" maxlength="4" style= "width:40px; padding-left: 10px;"/> </td>
					<td><span>반기구분</span>
						<select id="searchHalfType" name="searchHalfType" onChange="javascript:doAction1('Search')" >
			                <option value="1" id="searchHalfType01" selected="selected">상반기</option>
			                <option value="2" id="searchHalfType02">하반기</option>
			            </select>
					</td>
		            <td><span>신고구분</span>
		                <select id="searchSendType" name="searchSendType" onChange="javascript:doAction1('Search')" class="box">
		                    <option value="1" id="searchSendType01" selected="selected">정기</option>
		                    <option value="2" id="searchSendType02">수정</option>
		                </select>
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
            <li class="txt">기타소득</li>
            <li class="btn">
              <a href="javascript:doAction1('Down2Template')"   class="basic authR">양식 다운로드</a>
              <a href="javascript:doAction1('LoadExcel')"   	class="basic authR">업로드</a>
              <a href="javascript:doAction1('Insert')" 			class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   			class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   			class="basic authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   	class="basic authR">다운로드</a>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>