<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>외납세이월자료업로드</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String dpMode = "1"; // 화면모드 (1:기본모드, 0:확장모드) %>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var nationalCdList = "";

	$(function() {
        $("#menuNm").val($(document).find("title").text());
		$("#searchYear").val(parseInt("<%=yeaYear%>") - 1) ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태|상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			
   			{Header:"대상정보|대상년도",		Type:"Text",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"work_yy",		KeyField:1, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
	        {Header:"대상정보|정산구분",		Type:"Combo",     Hidden:0,  Width:120,    Align:"Center",  ColMerge:1,  SaveName:"adjust_type",	KeyField:1, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"대상정보|성명",		Type:"Popup",	  Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상정보|사번",		Type:"Text",	  Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			
			{Header:"대상정보|납부연도",		Type:"Text",	  Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"pay_yy",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"대상정보|국가",    Type:"Combo",     Hidden:0,  	Width:70,   Align:"Center", ColMerge:0, SaveName:"national_cd",     KeyField:1, Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"대상정보|외납구분",		Type:"Combo",	  Hidden:<%=dpMode%>,  	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"gubun",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 }, //TCPN885자료로 조회만. 저장불가.
			
			{Header:"국외원천소득|비용차감후\n금액⑤",  Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"pay_mon",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"국외원천소득|차감대상\n감면액⑧",	Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"reduce_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"국외원천소득|공제대상\n⑨=⑤-⑧",	Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"trg_mon",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"국외원천소득|결손반영\n기준금액 ⑩",Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"base_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			
			{Header:"공제한도|산출세액\n⑪",		Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"clclte_tax_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"공제한도|근로소득금액\n⑫",	Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"income_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"공제한도|공제한도액\n⑬=⑪*⑩/⑫",Type:"Int",		Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"limit_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			
			{Header:"공제대상세액|전기누적\n공제액",Type:"Int",			Hidden:1,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"prev_ded_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"공제대상세액|전기이월액\n⑭",	Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"prev_carried_mon",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"공제대상세액|외납세액\n⑮",	Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"pay_tax_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"공제대상세액|공제대상액\n⑯=⑭+⑮",Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"cur_ded_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
						
			{Header:"세액공제액\n=min(⑯,⑬)|세액공제액\n=min(⑯,⑬)",Type:"Int",Hidden:<%=dpMode%>,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"ded_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },

			{Header:"이월배제|한도초과액\n⑰=⑮-⑬",	Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"limit_ov_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"이월배제|배제액(비용)\n⑱",Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"exc_tax_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"이월배제|배제액(확정)\n⑲=min(⑰,⑱)",Type:"Int",	Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"no_carried_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			
			{Header:"이월금액|<%=(("1".equals(dpMode))?"이월금액":"당기공제한도\\n=⑯-⑬-⑲")%>",Type:"Int",	Hidden:0,	Width:85,	Align:"Right",	ColMerge:1,	SaveName:"carried_mon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"이월금액|세액공제 중\n산출세액 0",Type:"Int",Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"carried_mon_841",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"소멸금액|소멸금액",			Type:"Int",		Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"extinction_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			
			{Header:"비고|비고",			Type:"Text",		Hidden:0, 	Width:140,	Align:"Left",	ColMerge:1,	SaveName:"memo", KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
		sheet1.SetColProperty("gubun",		{ComboText:"|"+"대납|자납", ComboCode:"|"+"A|B"} );
		
		nationalCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20295"), "");
		sheet1.SetColProperty("national_cd",    {ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
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

		//양식다운로드용 sheet 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		templeteTitle1 += "* 대상정보 외납구분 : A-대납, B-자납 \n\n";
		
		codeCdNm = "";
		codeNm = nationalCdList[0].split("|"); codeCd = nationalCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "* 국가 : " + codeCdNm + "\n\n";
	});

	$(function() {
		
		$("#searchYear, #searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
		$("input[name=searchMon]").change(function(){
			doAction1("Search");
		});
	});
	
	function chkRqr(){

        var chkSearchAdjustType    = $("#searchAdjustType").val();

        var chkValue = false;

        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }

        return chkValue;
    }

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
            if($("#searchYear").val() == "") {
                alert("대상년도를 입력하여 주십시오.");
                return;
            }

            if($("#searchYear").val() >= "<%=yeaYear %>"){
                alert("대상년도는 전년도까지만 조회 가능합니다.");
                $("#searchYear").val("<%=Integer.parseInt(yeaYear)-1%>");
                $("#searchYear").focus();
                return;
            }

			sheet1.DoSearch( "<%=jspPath%>/abroadTax/abroadTaxUploadRst.jsp?cmd=selectAbroadTaxUploadList", $("#sheetForm").serialize() );
			break;
			
		case "Insert":
			if(chkRqr()){
	       		 break;
	       	}
			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#searchAdjustType").val() ) ;
         	
			break;	

        case "Save":
			for(var i=2; i < sheet1.LastRow()+2; i++){
				if(sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U"){
					if(sheet1.GetCellValue(i, "work_yy")*1 > "<%=yeaYear%>"*1) {
						alert("<%=yeaYear%>년 이후 내역은 입력할 수 없습니다.");
						return;
					}
					if(sheet1.GetCellValue(i, "work_yy") == "<%=yeaYear%>"){
						alert('<%=yeaYear%>년 내역은 [외납세대상자관리]에서 등록하시기 바랍니다.');
						return;
					}
				}
			}
            // 중복체크
            if (!dupChk(sheet1, "sabun|pay_yy|national_cd|work_yy|adjust_type", true, true)) {break;}
            sheet1.DoSave( "<%=jspPath%>/abroadTax/abroadTaxUploadRst.jsp?cmd=saveAbroadTaxUpload", $("#sheetForm").serialize());
            break;
            
        case "Copy":
			
			var intRow = sheet1.DataCopy();
			sheet1.SetCellValue(intRow, "gubun", "" ) ; //TCPN885에서 관리하는 값은 빈 값으로 처리
			break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;

		case "Down2Template":
			var param  = {DownCols:"work_yy|adjust_type|sabun|pay_yy|national_cd|carried_mon|memo",SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
									,TitleText:templeteTitle1
									,UserMerge :"0,0,1,7"
									,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
            /* ----------------------------------------------------------------------------------- 
            매뉴얼에서 업로드 관련 양식이 확정 상태기 때문에 아래 로직은 일단 주석처리함. 20241125 
			if(chkRqr()){
	       		 break;
	       	}*/
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}
	
	//조회 후 에러 메시지
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
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	//사원 조회
	function openEmployeePopup(Row){
	    try{
		    var args    = new Array();

		    if(!isPopup()) {return;}
		    gPRow = Row;
		    pGubun = "employeePopup";

		    var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
	    
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
	
	//수정(이력) 관련 세팅
	function getCprBtnChk(){		
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + ( ($("#searchYear").val() == "") ? $("#srchYear").val() : $("#searchYear").val() )
                   + "&searchAdjustType="
                   + "&searchSabun=" ;

        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {   			
 			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
 			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<input type="hidden" id="srchYear" name="srchYear" value="<%=yeaYear%>" /><%-- 현재 메뉴의 귀속년도 --%>
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>대상년도</span>
					<input id="searchYear" name ="searchYear" type="text" class="text center" maxlength="4" style="width:35px"/>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
				<td>
					<label for="searchMon1"><input type="radio" id="searchMon1" name="searchMon" class="radio" value="0" checked /> <span>전체</span></label>
					<label for="searchMon2"><input type="radio" id="searchMon2" name="searchMon" class="radio" value="1"  /> <span>이월금액 발생자</span></label>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')" ></select>
                </td>
                <td><span>사번/성명</span>
					<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td>
				<td>
					<a href="javascript:doAction1('Search')" id="btnSearch" class="button" >조회</a> </td>
				</td> 
			</tr>
		</table>
		</div>
	</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">외납세이월자료업로드</li>
			<li class="btn">
				<font class='blue'>[ <strong><%=yeaYear%>년의 정산계산</strong>을 위하여 이월자료를 등록하실 경우, 다음과 같이 기재하십시오. <strong>대상연도</strong> : 작년인 <%=Integer.parseInt(yeaYear) - 1 %>, <strong>납부연도</strong> : 세액 납부 당시의 연도 ]</font>
            	<a href="javascript:doAction1('Down2Template')"	class="basic btn-download authR">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save');" class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')"	class="basic btn-download authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>