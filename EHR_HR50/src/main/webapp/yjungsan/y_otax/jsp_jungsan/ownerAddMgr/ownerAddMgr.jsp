<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>사업자등록</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
    	initdata.Cols = [
    		{Header:"No|No",					Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
    		{Header:"삭제|삭제",				Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
    		{Header:"상태|상태",				Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
       		{Header:"사업장|사업장",				Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
       		{Header:"Location|Location",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"location_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
       		{Header:"사번|사번",				Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
       		{Header:"성명|성명",				Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
       		{Header:"주민번호\n(외국인등록번호)|주민번호\n(외국인등록번호)",			Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"res_no",			KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
       		// 소득자관리 정보
       		{Header:"시작일자|시작일자",			Type:"Date",		Hidden:1,					Width:95,			Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"종료일자|종료일자",			Type:"Date",		Hidden:1,					Width:95,			Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"소득구분|소득구분",			Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"earner_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
       		{Header:"사업자등록번호|사업자등록번호",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"regino",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"상호|상호",		Type:"Text",		Hidden:0,					Width:110,			Align:"Left",	ColMerge:0,	SaveName:"earner_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"영문명\n(상호or성명)|영문명\n(상호or성명)",	Type:"Text",		Hidden:0,					Width:110,			Align:"Left",	ColMerge:0,	SaveName:"earner_eng_nm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"외국인|외국인",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"citizen_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"비거주자|비거주자",	Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"residency_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"거주지국|거주지국",			Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"residence_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"실명여부|실명여부",		Type:"Combo",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"bi_name_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"전화번호|전화번호",			Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"tel_no",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"주소|주소",			Type:"Text",		Hidden:0,					Width:200,			Align:"Left",	ColMerge:0,	SaveName:"addr",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"은행|은행",			Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"bank_cd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"계좌번호|계좌번호",			Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"account_no",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"이자배당소득의 경우|소득자구분",		Type:"Combo",		Hidden:0,					Width:220,			Align:"Center",	ColMerge:0,	SaveName:"earner_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
       		{Header:"이자배당소득의 경우|비거주자생년월일",	Type:"Date",		Hidden:0,					Width:110,			Align:"Center",	ColMerge:0,	SaveName:"no_resi_birth",	KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
       		{Header:"이자배당소득의 경우|신탁이익여부",		Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sintak_yn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
       		{Header:"비고|비고",			Type:"Text",		Hidden:0,					Width:90,			Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
       	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

		// 사업장(TCPN121)
		var bizPlaceCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "전체");
		sheet1.SetColProperty("business_place_cd", {ComboText:"|"+bizPlaceCd[0], ComboCode:"|"+bizPlaceCd[1]});
		//sheet1.SetColProperty("business_place_cd", {ComboText:"|"+"전체|"+bizPlaceCd[0], ComboCode:"|"+"%|"+bizPlaceCd[1]});
		$("#searchBusinessPlaceCd").html(bizPlaceCd[2]) ;
		
		// Location(TSYS015)
		var locationCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getLocationCdAllList") , "전체");
		sheet1.SetColProperty("location_cd", {ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]});
		$("#searchLocationCd").html(locationCd[2]) ;

		// 소득구분(C00502)
		var earnerCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=","C00502"), "전체");
		sheet1.SetColProperty("earner_cd", {ComboText:earnerCd[0], ComboCode:earnerCd[1]});
		$("#searchEarnerCd").html(earnerCd[2]) ;

		// 소득자구분(C00503)
		var earnerType = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=","C00503"), "");
		sheet1.SetColProperty("earner_type", {ComboText:"|"+earnerType[0], ComboCode:"|"+earnerType[1]});

		// 거주지국(H20290)
		var residenceCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=","H20290"), "");
		sheet1.SetColProperty("residence_cd", {ComboText:"|"+residenceCd[0], ComboCode:"|"+residenceCd[1]});

		// 은행코드(H30001)
		var bankCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=","H30001"), "");
		sheet1.SetColProperty("bank_cd", {ComboText:"|"+bankCd[0], ComboCode:"|"+bankCd[1]});

		//sheet1.SetDataLinkMouse("detail", 1);
		//sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetColProperty("citizen_type", 	{ComboText:"|외국인|내국인", ComboCode:"|9|1"}	);
		sheet1.SetColProperty("residency_type", 	{ComboText:"|비거주자|거주자", ComboCode:"|2|1"}	);
		sheet1.SetColProperty("bi_name_yn", 		{ComboText:"|비실명|실명", ComboCode:"|Y|N"}	);
		sheet1.SetColProperty("sintak_yn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"}	);

		$(window).smartresize(sheetResize);
		sheetInit();

		doAction1("Search");
	});



	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			/*
			if($("#searchYm").val() == "") {
				alert("대상연월은 필수 입력항목입니다.");
			}
			if($("#searchYm").val().length != 7) {
				alert("대상연월 포맷에 맞게 입력해 주십시오.");
			}
			*/
			sheet1.DoSearch( "<%=jspPath%>/ownerAddMgr/ownerAddMgrRst.jsp?cmd=selectOwnerAddMgrList", $("#sheetForm").serialize() );
			break;
        case "Insert":
        	sheet1.DataInsert(0) ;
        	break;
        case "Copy":
        	sheet1.DataCopy();
        	break;
		case "Save":

			var strRow = sheet1.FindStatusRow("I|U");
			var arrRow = strRow.split(";");

			if(strRow != "" && arrRow != null && arrRow.length > 0) {
				for(var i = 0, len = arrRow.length; i < len; i++) {
					var earnerCd = sheet1.GetCellValue(arrRow[i], "earner_cd");
					var resNo = sheet1.GetCellValue(arrRow[i], "res_no");
					var regino = sheet1.GetCellValue(arrRow[i], "regino");

					// 소득자구분(C00503)
					var earnerType = sheet1.GetCellValue(arrRow[i], "earner_type");
					
					if(earnerCd == "9" && earnerType == "999") { 
						; //20240223이자.배당소득 - 공란 또는 비실명 : 주민번호나 사업자번호 미기재
					} else if(earnerCd == "7" || earnerCd == "9") {
						if(resNo == "" && regino == "") {
							alert("주민등록번호 또는 사업자등록번호를 입력하여 주시기 바랍니다");
							sheet1.SelectCell(arrRow[i], "res_no");
							return;
						}
					} else {
						if( resNo == "") {
							alert("주민등록번호를 입력하여 주시기 바랍니다");
							sheet1.SelectCell(arrRow[i], "res_no");
							return;
						}
					}
				}
			}

			sheet1.DoSave( "<%=jspPath%>/ownerAddMgr/ownerAddMgrRst.jsp?cmd=saveOwnerAddMgr", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		case "Down2Template":
			var templeteTitle = "업로드시 이 행은 삭제 합니다.\n*시작일자 : yyyy-mm-dd, *종료일자:yyyy-mm-dd 형식으로 입력하여 주세요.\n일용, 사업, 기타소득의 경우 주민번호(외국인등록번호)를 반드시 입력하여 주시기 바랍니다.";
			var param  = {DownCols:"3|4|5|6|7|10|11|12|13|14|15|16|18|19|20|21|22|23|24|25",SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
				,TitleText:templeteTitle,UserMerge :"0,0,1,22"};
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
	
	//변경시 발생.
	function sheet1_OnChange(Row,Col, Value, OldValue) {
		try {
			if(sheet1.ColSaveName(Col) == "res_no"){
				if(sheet1.GetCellValue(Row,"res_no")!= ""){
					//주민번호 유효성체크
					var rResNo = sheet1.GetCellValue(Row,"res_no");
					var forienerNo = Number(rResNo.substring(6,7));
					
					//외국인 주민번호 체크 [5,6,7,8]
					if(forienerNo > 4 && forienerNo < 9){
						if(fgn_no_chksum(rResNo) == false){
							if ( !confirm("등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?") ) sheet1.SetCellValue(Row,"res_no", "") ;
						}
					} else {
						if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) == false){
						 if ( !confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?") ) sheet1.SetCellValue(Row,"res_no", "") ;
						}
					}
				}
			}
			
		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
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
				sheet1.SetCellValue(Row, "org_nm", 	rv["org_nm"] );
	        }
		    */
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm", 	rv["org_nm"] );
		}
	}

</script>
</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
        <div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>소득구분</span> <select id="searchEarnerCd" name="searchEarnerCd" onChange="javascript:doAction1('Search');"></select> </td>
						<td> <span>사업장</span> <select id="searchBusinessPlaceCd" name="searchBusinessPlaceCd" onChange="javascript:doAction1('Search');"></select> </td>
						<td> <span>Location</span> <select id="searchLocationCd" name="searchLocationCd" onChange="javascript:doAction1('Search');"></select> </td>
						<td> <span>성명/사번</span> <input type="text" id="searchSbNm" name="searchSbNm" class="text" value="" style="ime-mode:active" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">사업자등록</li>
            <li class="btn">
				<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 			class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 	class="basic authR">복사</a>
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