<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기부금내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	
	$(function() {
		$("#searchYear").val("<%=yeaYear%>") ;
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",				Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",				Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",				Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
   			{Header:"대상년도",				Type:"Text",      Hidden:0,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"work_yy",			KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
	        {Header:"정산구분",				Type:"Combo",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:1,   SaveName:"adjust_type",		KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"부서명",				Type:"Text",      Hidden:0,  Width:90,	Align:"Left",    ColMerge:1,   SaveName:"org_nm",			KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"성명",				Type:"Popup",	  Hidden:0,  Width:70,	Align:"Center",  ColMerge:1,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"사번",				Type:"Text",      Hidden:0,  Width:80,	Align:"Center",  ColMerge:1,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"순서",				Type:"Text",      Hidden:1,  Width:0,	Align:"Center",  ColMerge:1,   SaveName:"seq",				KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
	        {Header:"기부자명",				Type:"Text",      Hidden:0,  Width:70,	Align:"Center",  ColMerge:1,   SaveName:"fam_nm",			KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"기부자주민번호",			Type:"Text",      Hidden:0,  Width:100,	Align:"Center",  ColMerge:1,   SaveName:"famres",			KeyField:1,   CalcLogic:"",   Format:"Number",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"기부금영수증\n일련번호",	Type:"Text",      Hidden:1,  Width:10,	Align:"Center",  ColMerge:1,   SaveName:"contribution_no",	KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
	        {Header:"사업자등록번호등",		Type:"Text",      Hidden:0,  Width:100,	Align:"Center",  ColMerge:1,   SaveName:"enter_no",			KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:15 },
	        {Header:"상호(법인명)",			Type:"Text",      Hidden:0,  Width:90,	Align:"Left",    ColMerge:1,   SaveName:"firm_nm",			KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"기부금종류",			Type:"Combo",     Hidden:0,  Width:120,	Align:"Left",    ColMerge:1,   SaveName:"contribution_cd",	KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"건수",				Type:"Int",       Hidden:0,  Width:60,	Align:"Right",   ColMerge:1,   SaveName:"appl_cnt",			KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"기부장려금신청금액",	    Type:"AutoSum",       Hidden:0,  Width:90,	Align:"Right",   ColMerge:1,   SaveName:"contribution_sup_mon",			KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
	        {Header:"기부내용",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"donation_type",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
	        {Header:"기부금액(전체)",		Type:"AutoSum",       Hidden:0,  Width:90,	Align:"Right",   ColMerge:1,   SaveName:"sum_mon",			KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
	        {Header:"금액(직원용)",			Type:"AutoSum",       Hidden:1,  Width:70,	Align:"Right",   ColMerge:1,   SaveName:"input_mon",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"금액(담당자용)",		Type:"AutoSum",       Hidden:0,  Width:90,	Align:"Right",   ColMerge:1,   SaveName:"appl_mon",			KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"자료입력유형",			Type:"Combo",     Hidden:0,  Width:80,	Align:"Center",  ColMerge:1,   SaveName:"adj_input_type",	KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"국세청\n자료\n여부",		Type:"CheckBox",  Hidden:0,  Width:50,	Align:"Center",  ColMerge:1,   SaveName:"nts_yn",			KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
	        {Header:"본인주민번호",			Type:"Text",	  Hidden:1,  Width:70,	Align:"Center",  ColMerge:1,   SaveName:"res_no",			KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:160 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );		
		//자료입력유형
        var inputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00325"), "전체" );
		//기부금종류
        var contributionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y","C00307"), "");
		
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("contribution_cd", {ComboText:"|"+contributionCdList[0], ComboCode:"|"+contributionCdList[1]});
		sheet1.SetColProperty("adj_input_type", {ComboText:inputTypeList[0], ComboCode:inputTypeList[1]});
		sheet1.SetColProperty("donation_type",	{ComboText:"금전|현물", ComboCode:"1|2"} );
		
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchInputType").html(inputTypeList[2]);

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
        
		//doAction1("Search");
		
		//양식다운로드용 sheet 정의
		var templeteTitle = "업로드시 이 행은 삭제 합니다\n\n";
		var codeCdNm = "", codeCd = "", codeNm = "";
		
		codeCdNm = "";
		codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "정산구분 : " + codeCdNm + "\n";
		
		codeCdNm = "";
		codeNm = contributionCdList[0].split("|"); codeCd = contributionCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "기부금종류 : " + codeCdNm + "\n";
		
		codeCdNm = "";
		codeNm = inputTypeList[0].split("|"); codeCd = inputTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "자료입력유형 : " + codeCdNm + "\n";
		
		templeteTitle1 += "국세청 자료여부 : Y, N \n";
	});
	
	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/donationHisMgr/donationHisMgrRst.jsp?cmd=selectDonationHisMgrList", $("#sheetForm").serialize() ); 
			break;
		case "Save":
			//if(!dupChk(sheet1, "work_yy|adjust_type|sabun|seq", false, true)) {break;}
			
			for(row = 1 ; row <= sheet1.LastRow() ; row++) {
				if(sheet1.GetCellValue(row,"sStatus") == "U" || sheet1.GetCellValue(row,"sStatus") == "I") {
				
					//정치자금이나, 우리사주조합기부금일경우에는 본인꺼만 해당된다.
					if(sheet1.GetCellValue(row, "contribution_cd") == "20" || sheet1.GetCellValue(row, "contribution_cd") == "42" ) {
						if(sheet1.GetCellValue(row, "famres") != sheet1.GetCellValue(row, "res_no")){
							alert('정치자금이나 우리사주조합 기부금은 본인만 해당됩니다.');
							return;
						}
					}

					//정치자금을 제외한 나머지는 사업자 등록번호와 상호가 필수사항이다.
					/*
					if(sheet1.GetCellValue(row, "contribution_cd") != "20"  ) {
						
						if(sheet1.GetCellValue(row, "enter_no") =="" ){
							alert('사업자등록번호등은  필수 입력 사항입니다.');
							return;
						}
						
						biz_no = sheet1.GetCellValue(row,"enter_no");
						
						if ( biz_no  < 10 ){
							alert('사업자등록번호등이 잘못 입력되었습니다.');
							return;
						} 
						
						//주민번호 유효성체크
						if(biz_no.length >=13){
							fResNo = biz_no.substring(0,6);
							rResNo = biz_no.substring(6,13);
						}else{
							fResNo ="";
							rResNo ="";
						}
						if(checkBizID(biz_no) == false &&  checkRegNo(fResNo,rResNo) == false){
							alert('사업자등록번호등이 잘못 입력되었습니다.');
							return;
						}
					}
					*/
					
					if(sheet1.GetCellValue(row,"adj_input_type")=="07") {
						alert('PDF업로드는 선택할 수 없습니다.');
						sheet1.SelectCell(row, "adj_input_type");
						return;
					}
				}
			}
			
			sheet1.DoSave( "<%=jspPath%>/donationHisMgr/donationHisMgrRst.jsp?cmd=saveDonationHisMgr"); 
			break;
		case "Insert":
			
			if(chkRqr()){
				break;
			}
			
			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#searchAdjustType").val() ) ;
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		case "Down2Template":
			//var param  = {DownCols:"5|6|9|12|14|15|16|19|20|21|22",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
			var param  = {DownCols:"5|6|9|12|14|15|16|18|19|20|22|23|24",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,13"};
			sheet1.Down2Excel(param); 
			break;
        case "LoadExcel":  
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
			sheet1.LoadExcel(params); 
			break;

		}
	}
	
    function chkRqr(){
        
        var chkSearchAdjustType    = $("#searchAdjustType").val();
        
        var chkValue = false;
        
        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }
        
        return chkValue;
    }

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			
			if (Code == 1) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
					if (sheet1.GetCellValue(i, "adj_input_type") == "07") { //PDF
						sheet1.SetRowEditable(i, 0);
					}
				}
			}
			
			sheetResize(); 
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}

	//저장 후 메시지
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

	var gPRow  = "";
	var pGubun = "";
	
	//팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	//클릭시 발생
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "sDelete") {
				if(sheet1.GetCellValue(Row,"sStatus") != "I" && sheet1.GetCellValue(Row,"adj_input_type")=="07") {
					alert('PDF업로드자료는 PDF등록 탭에서 반영제외하면 현재 화면에서 삭제됩니다.');
					sheet1.SetCellValue(Row,"sDelete", "0");
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try{
			if( sheet1.ColSaveName(Col) == "sabun" ) {
				if( sheet1.GetCellValue(Row, "sabun") != "" ) {
					setFamList( sheet1.GetCellValue(Row, "sabun") ) ;
				}
			}
			if( sheet1.ColSaveName(Col) == "fam_nm" ) {
				sheet1.SetCellValue(Row, "famres", sheet1.GetCellValue(Row, "fam_nm") ) ;
			}
			if( sheet1.ColSaveName(Col) == "adj_input_type" ) {
				if(sheet1.GetCellValue(Row,"adj_input_type")=="07") {
					alert('PDF업로드는 선택할 수 없습니다.');
					sheet1.SetCellValue(Row,"adj_input_type",OldValue);
				}
			}
		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
	}
	
	//기부자명 셋팅
	function setFamList(searchSabun) {
		var params = "searchWorkYy="+$("#searchYear").val()
					+"&searchAdjustType="+$("#searchAdjustType").val()
					+"&searchSabun="+searchSabun
					+"&searchDpndntYn=Y"
					+"&searchFamCd_s=,6,7,8";
					
		//dynamic query 보안 이슈 때문에 queryId=getFamCodeList2 분기 처리
		var famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList2",params,false).codeList, "");
		
		if(famList[0] == null) {
			alert("정산가족사항 데이터가 존재하지 않습니다.") ;
		} else {
			//해당 대상자의 정산가족으로 세팅
			var info = {Type:"Combo", ComboText:"|"+famList[0], ComboCode:"|"+famList[1]} ;
			sheet1.InitCellProperty(sheet1.GetSelectRow(),"fam_nm",info);
			sheet1.SetCellValue(sheet1.GetSelectRow(),"fam_nm","");
			sheet1.SetCellEditable(sheet1.GetSelectRow(),"fam_nm",1);
		}
	}
	
	//사원 조회
	function openEmployeePopup(Row){
	    try{
	    	
	    	if(!isPopup()) {return;}
		    gPRow = Row;
			pGubun = "employeePopup";
			 
		    var args    = new Array();
		    var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
	     /*
	        if(rv!=null){
				sheet1.SetCellValue(Row, "name", 		rv["name"] );
				sheet1.SetCellValue(Row, "sabun", 		rv["sabun"] );
				sheet1.SetCellValue(Row, "org_nm", 		rv["org_nm"] );
				sheet1.SetCellValue(Row, "res_no", 		rv["res_no"] );
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
			sheet1.SetCellValue(gPRow, "res_no", 	rv["res_no"] );
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <div class="sheet_search outer">
        <div>
        <table>
			<tr>
			    <td><span>년도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/>
				<%}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/>
				<%}%>			    
				</td>				
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
				<td><span>자료입력유형</span>
					<select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                </td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">기부금내역관리</li>
            <li class="btn">
				<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>