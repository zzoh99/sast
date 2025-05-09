<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>의료비내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=yeaYear%>") ;

        
        
        
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,	Width:"<%=sDelWdt%>",	Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
			{Header:"상태",				Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,    Width:"<%=sSttWdt%>",	Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
			{Header:"대상년도",			Type:"Text",		Hidden:0, Width:60,	Align:"Center",	ColMerge:1,		SaveName:"work_yy",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",			Type:"Combo",		Hidden:0, Width:70,	Align:"Center",	ColMerge:1,		SaveName:"adjust_type",		KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"부서명",			Type:"Text",		Hidden:0, Width:90,	Align:"Left",	ColMerge:1,		SaveName:"org_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",				Type:"Popup",		Hidden:0, Width:70,	Align:"Center",	ColMerge:1,		SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",				Type:"Text",		Hidden:0, Width:80,	Align:"Center",	ColMerge:1,		SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"데이터키값(수정금지)",				Type:"Text",		Hidden:1, Width:0,	Align:"Center",	ColMerge:1,		SaveName:"seq",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"명의인",			Type:"Text",		Hidden:0, Width:70,	Align:"Center",	ColMerge:1,		SaveName:"fam_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"명의인주민번호",		Type:"Text",		Hidden:0, Width:100,	Align:"Center",	ColMerge:1,	SaveName:"famres",			KeyField:1, Format:"Number",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"구분",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"special_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"의료비증빙코드",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:1,	SaveName:"medical_imp_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"상세구분",			Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"restrict_cd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"재가/시설급여",		Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"medical_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사업자번호",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:1,	SaveName:"enter_no",		KeyField:0,	Format:"SaupNo",PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"상호",				Type:"Text",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"firm_nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"의료비내용",		Type:"Text",		Hidden:1,	Width:90,	Align:"Left",	ColMerge:1,	SaveName:"contents",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"건수",				Type:"Text",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"cnt",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"금액자료(직원용)",	Type:"Int",		Hidden:1,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"금액(담당자용)",	Type:"AutoSum",		Hidden:0,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"자료입력유형",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"국세청\n자료수정여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_modify_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0, TrueValue:"Y", FalseValue:"N" },
			{Header:"국세청\n자료원본",	Type:"Int",		Hidden:0,	Width:90,	Align:"Right",	ColMerge:1,	SaveName:"nts_original_appl_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"지급일자",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:1, SaveName:"ymd",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"관계",					Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:1, SaveName:"adj_fam_cd",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"미숙아ㆍ선천성이상아\n해당여부",   Type:"CheckBox",    Hidden:0,   Width:80,   Align:"Center", ColMerge:1, SaveName:"pre_baby_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"난임시술비\n해당여부",   Type:"CheckBox",    Hidden:0,   Width:80,   Align:"Center", ColMerge:1, SaveName:"nanim_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"담당자확인",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center", ColMerge:1, SaveName:"feedback_type",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );
		var medicalImpCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00308"), "");
		var restrictCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00340"), "");
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "전체");

		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("special_yn",		{ComboText:" |65세이상|장애인", ComboCode:" |B|A"} );
		sheet1.SetColProperty("medical_type",	{ComboText:" |재가급여|시설급여", ComboCode:" |1|2"} );
		sheet1.SetColProperty("medical_imp_cd",	{ComboText:"|"+medicalImpCdList[0], ComboCode:"|"+medicalImpCdList[1]} );
		sheet1.SetColProperty("restrict_cd",	{ComboText:"|"+restrictCdList[0], ComboCode:"|"+restrictCdList[1]} );
		sheet1.SetColProperty("adj_input_type",	{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );

		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchInputType").html(adjInputTypeList[2]);

		//담당자확인(2021.10.25)
        var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "전체");
        sheet1.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        $("#searchFeedBackType").html(feedbackTypeList[2]);

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
			sheet1.DoSearch( "<%=jspPath%>/medHisMgr/medHisMgrRst.jsp?cmd=selectMedHisMgrList", $("#sheetForm").serialize() );
			break;
			
		case "Insert":
			if(chkRqr()){
	       		 break;
	       	}
         	
			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#searchAdjustType").val() ) ;
			sheet1.SetCellValue(Row, "adj_input_type", '02' ) ;
			sheet1.SetCellValue( Row, "ymd", $("#searchYear").val()+"1231" ) ;
			
			break;

        case "Save":
        	for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
        		if( sheet1.GetCellValue(i, "sStatus") == "I"){
        			sheet1.SetCellValue( i, "ymd", $("#searchYear").val()+"1231" ) ;
        		}
        	}
            sheet1.DoSave( "<%=jspPath%>/medHisMgr/medHisMgrRst.jsp?cmd=saveMedHisMgr", $("#sheetForm").serialize());
            break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param    = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
			
		case "Copy":
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "adj_input_type") == "07") {
				alert("PDF업로드 자료는 복사할 수 없습니다.");
				return;
			}

			sheet1.DataCopy();
			break;

		case "Down2Template":
			var param  = {DownCols:"work_yy"
				+"|adjust_type"
				+"|name"
				+"|sabun"
				+"|fam_nm"
				+"|famres"
				+"|special_yn"
				+"|medical_imp_cd"
				+"|restrict_cd"
				+"|medical_type"
				+"|enter_no"
				+"|firm_nm"
				+"|cnt"
				+"|appl_mon"
				+"|pre_baby_yn"
				+"|nanim_yn"
				+"|adj_input_type"
				//+"|nts_yn"
				,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:"",menuNm:$(document).find("title").text()};
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

			if (Code == 1) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
					if (sheet1.GetCellValue(i, "adj_input_type") == "07") { //PDF
						sheet1.SetRowEditable(i, 0);
					}
				}
			}
			getMedMonInput();
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

    //값 변경시 발생
    function sheet1_OnChange(Row, Col, Value) {
        try{
        	if( sheet1.ColSaveName(Col) == "sabun" ) {
				if( sheet1.GetCellValue(Row, "sabun") != "" ) {
					setFamList( sheet1.GetCellValue(Row, "sabun") ) ;
				}
			}
			if( sheet1.ColSaveName(Col) == "fam_nm" ) {
				sheet1.SetCellValue(Row, "famres", sheet1.GetCellValue(Row, "fam_nm") ) ;
			}

			if(Row != sheet1.LastRow()) {
            	getMedMonInput();
            }

        } catch(ex){
            alert("OnChange Event Error : " + ex);
        }
    }

    function getMedMonInput(){
    	var mon1 = 0;
    	var mon2 = 0;
    	var totalInputMon = 0;
    	var totalApplMon = 0;
    	var totalCalcMon = 0;

    	sheet1.SetCellValue(sheet1.LastRow(),"input_mon","0");
    	sheet1.SetCellValue(sheet1.LastRow(),"appl_mon","0");

    	for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
			if(sheet1.GetCellValue(i,"appl_mon") != ""){
				if(sheet1.GetCellValue(i,"restrict_cd") == "20"){
	    			mon1 = mon1 + parseInt(sheet1.GetCellValue(i,"appl_mon"), 10);	/* 산후조리원비 */
	            }else if(sheet1.GetCellValue(i,"restrict_cd") == "30"){
	            	mon2 = mon2 + parseInt(sheet1.GetCellValue(i,"appl_mon"), 10);	/* 실손의료보험금 */
	            }

				if(sheet1.GetCellValue(i,"restrict_cd") != "30"){
					totalApplMon = totalApplMon + parseInt(sheet1.GetCellValue(i,"appl_mon"), 10);
				}
			}
			if(sheet1.GetCellValue(i,"input_mon") != ""){
				if(sheet1.GetCellValue(i,"restrict_cd") != "30"){
					totalInputMon = totalInputMon + parseInt(sheet1.GetCellValue(i,"input_mon"), 10);
				}
			}
    	}

    	//totalCalcMon = parseInt(totalApplMon)-parseInt(mon2);
    	totalCalcMon = parseInt(totalApplMon);
    	sheet1.SetCellValue(sheet1.LastRow(),"input_mon",comma(totalInputMon));
    	sheet1.SetCellValue(sheet1.LastRow(),"appl_mon",comma(totalCalcMon));
    }

	function comma(str) {
		if ( str == "" ) return 0;

		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
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
	
	//사원 조회
	function openEmployeePopup(Row){
	    try{
		    var args    = new Array();

		    if(!isPopup()) {return;}
		    gPRow = Row;
		    pGubun = "employeePopup";

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
	
	//명의인 셋팅
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
	
	function chkRqr(){

        var chkSearchAdjustType    = $("#searchAdjustType").val();

        var chkValue = false;

        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }

        return chkValue;
    }

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}%>
				</td>
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')" ></select>
                </td>
				<td><span>자료입력유형</span>
					<select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
			</tr>
			<tr>
                <td>
                    <span>담당자확인</span>
                    <select id="searchFeedBackType" name ="searchFeedBackType" class="box" onChange="javascript:doAction1('Search')"></select>
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
			<li class="txt">의료비내역관리</li>
			<li class="btn">
<!-- 				<a href="javascript:doAction1('Down2Excel')"	class="basic btn-download authR">다운로드/업데이트 양식다운로드</a> -->
 				<a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
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