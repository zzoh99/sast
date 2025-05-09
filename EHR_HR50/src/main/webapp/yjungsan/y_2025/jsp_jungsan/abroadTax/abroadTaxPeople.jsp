<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>외납세대상자관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String dpMode = "1"; // 화면모드 (1:기본모드, 0:확장모드) %>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	
	$(function() {
        $("#menuNm").val($(document).find("title").text());
		//$("#searchYear").val("<%=yeaYear%>") ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
			{Header:"상태|상태",			Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
			
			{Header:"대상정보|성명",			Type:"Popup",		Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상정보|사번",			Type:"Text",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			
			{Header:"대상정보|납부연도",			Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"pay_yy",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"대상정보|국가",       	Type:"Combo",       Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"national_cd",     KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"대상정보|외납구분",		    Type:"Combo",		Hidden:0,  	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"gubun",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
			
			{Header:"국외원천소득|비용차감전\n금액③", Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"tot_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"국외원천소득|대응비용\n④",	  Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"cst_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"국외원천소득|<%=(("1".equals(dpMode))?"(비과세포함)":"비용차감후\\n금액⑤")%>",Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"pay_mon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },//계산식있음
			
			{Header:"감면|적용대상액\n⑥",	Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"reduce_trg",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },//계산식있음
			{Header:"감면|비율(%)\n⑦",	   Type:"Int",			Hidden:<%=dpMode%>,	Width:70,	Align:"Right",	ColMerge:1,	SaveName:"reduce_rate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"감면|감면액\n⑧=⑥*⑦", Type:"Int",			Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"reduce_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			
			{Header:"외납세액|당기<%//\n⑮%>",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"pay_tax_mon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"외납세액|전기이월",	            Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"b_prev_carried_mon",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			
			{Header:"납부연도|공제한도",			Type:"Int",			Hidden:<%=dpMode%>,	Width:70,	Align:"Right",	ColMerge:1,	SaveName:"b_limit_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"납부연도|반영금액",			Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"b_ded_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"납부연도|이월배제액\n(비용) ⑱",Type:"Int",		Hidden:<%=dpMode%>,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"exc_tax_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"납부연도|이월금액",		    Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"b_carried_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			//{Header:"적치금액\n(반영가능금액)",	Type:"Int",			Hidden:1,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"store_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			
			{Header:"최종|반영연도",		Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"c_work_yy",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"최종|정산구분",		Type:"Combo",		Hidden:0, 	Width:140,	Align:"Center",	ColMerge:1,	SaveName:"c_adjust_type",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종|누적반영액",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"c_ded_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"최종|이월금액발생건수",	Type:"Int",			Hidden:1,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"c_cnt_carried",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			
			{Header:"비고|비고",			Type:"Text",		Hidden:0, 	Width:140,	Align:"Left",	ColMerge:1,	SaveName:"memo", KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
		sheet1.SetColProperty("gubun",		{ComboText:"|"+"대납|자납", ComboCode:"|"+"A|B"} );

		var nationalCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20295"), "");
		sheet1.SetColProperty("national_cd",    {ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );

		//양식다운로드용 sheet 정의
		templeteTitle1 += "* 외납구분 : 대납/자납\n\n";
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = nationalCdList[0].split("|"); codeCd = nationalCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "* 국가 : " + codeCdNm + "\n\n";
				
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
			sheet1.DoSearch( "<%=jspPath%>/abroadTax/abroadTaxPeopleRst.jsp?cmd=selectAbroadTaxPeopleList", $("#sheetForm").serialize() );
			break;
			
		case "Insert":
			var Row = sheet1.DataInsert(0) ;
			
			break;	

        case "Save":
            // 중복체크
            if (!dupChk(sheet1, "sabun|pay_yy|national_cd", true, true)) {break;}
            sheet1.DoSave( "<%=jspPath%>/abroadTax/abroadTaxPeopleRst.jsp?cmd=saveAbroadTaxPeople", $("#sheetForm").serialize());
            break;
            
        case "Copy":
			var intRow = sheet1.DataCopy();
			
			sheet1.SetCellValue(intRow, "b_limit_mon", "" ) ; //TCPN886에서 관리하는 값은 빈 값으로 처리
			sheet1.SetCellValue(intRow, "b_ded_mon", "" ) ;
			sheet1.SetCellValue(intRow, "b_carried_mon", "" ) ;
			sheet1.SetCellValue(intRow, "c_work_yy", "" ) ;
			sheet1.SetCellValue(intRow, "c_adjust_type", "" ) ;
			sheet1.SetCellValue(intRow, "c_ded_mon", "" ) ;
			sheet1.SetCellValue(intRow, "c_cnt_carried", "" ) ;
			break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;

		case "Down2Template":
			//var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:"name|sabun|pay_yy|national_cd|gubun|pay_mon|pay_tax_mon|memo",SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
							,TitleText:templeteTitle1
							,UserMerge :"0,0,1,8"
							,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
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
	               + "&searchWorkYy=" + $("#searchYear").val() 
	               + "&searchAdjustType="
	               + "&searchSabun=" ;
		
	    //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {   			
			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
			sheet1.SetColProperty("c_adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<input type="hidden" id="srchYear" name="srchYear" value="<%=yeaYear%>" /><%-- 현재 메뉴의 귀속년도) 삭제 시 과거자료 체크에 사용 --%>
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>납부년도</span>
					<input id="searchYear" name ="searchYear" type="text" class="text center" maxlength="4" style="width:35px"/>
				</td>
				<td style="display: none;"><span>정산구분</span>
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
			<li class="txt">외납세대상자관리</li>
			<li class="btn">
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