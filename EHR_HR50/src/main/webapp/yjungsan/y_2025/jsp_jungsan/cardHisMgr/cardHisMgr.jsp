<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>신용카드내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var adjustTypeList = null;
	var inputTypeList = null; //자료입력유형 adj_input_type
	var halfGubunList = null; //반기구분
	var cardTypeList = null;
	var feedbackTypeList = null;

	//신용카드구분 코드 조회
    var cardTypeList = stfConvCode(ajaxCall("<%=jspPath%>/cardHisMgr/cardHisMgrRst.jsp?cmd=selectYeaDataCardCardType", "searchYyType=0&searchYear=<%=yeaYear%>", false).codeList, "");

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text());
		$("#searchYear").val("<%=yeaYear%>") ;
		$("#searchHalfGubun").bind("change", function(){
			var half_gubun = $(this).val();

			var arrComboText = cardTypeList[0].split("|");
			var arrComboCode = cardTypeList[1].split("|");
			var strComboText = "<option value=''>전체</option>";

			// 당해년도
			if ( half_gubun == "10" || half_gubun == "20" || half_gubun == "30"  ) {
				for(var i=0; i<arrComboCode.length; i++) {
					if ( arrComboCode[i] == "1"
							|| arrComboCode[i] == "2"
							|| arrComboCode[i] == "3"
							|| arrComboCode[i] == "7"
							|| arrComboCode[i] == "11"
							|| arrComboCode[i] == "13"
							|| arrComboCode[i] == "15"
							|| arrComboCode[i] == "17"
					) {
						strComboText += "<option value='"+ arrComboCode[i] +"'>"+ arrComboText[i] +"</option>";
					}
				}

			// 2015
			} /*else if ( half_gubun == "2015"  ) {
				for(var i=0; i<arrComboCode.length; i++) {
					if ( arrComboCode[i] == "51"
							|| arrComboCode[i] == "52"
							|| arrComboCode[i] == "53"
							|| arrComboCode[i] == "54"
							|| arrComboCode[i] == "55"
							|| arrComboCode[i] == "56"
							|| arrComboCode[i] == "57"
							|| arrComboCode[i] == "58"
					) {
						strComboText += "<option value='"+ arrComboCode[i] +"'>"+ arrComboText[i] +"</option>";
					}
				}

			// 2014
			} else if ( half_gubun == "2014"  ) {
				for(var i=0; i<arrComboCode.length; i++) {
					if ( arrComboCode[i] == "41"
							|| arrComboCode[i] == "42"
							|| arrComboCode[i] == "43"
							|| arrComboCode[i] == "44"
							|| arrComboCode[i] == "45"
							|| arrComboCode[i] == "46"
							|| arrComboCode[i] == "47"
							|| arrComboCode[i] == "48"
					) {
						strComboText += "<option value='"+ arrComboCode[i] +"'>"+ arrComboText[i] +"</option>";
					}
				}

			// 2013
			} else if ( half_gubun == "2013"  ) {
				for(var i=0; i<arrComboCode.length; i++) {
					if ( arrComboCode[i] == "21"
							|| arrComboCode[i] == "23"
							|| arrComboCode[i] == "25"
							|| arrComboCode[i] == "27"
							|| arrComboCode[i] == "29"
							|| arrComboCode[i] == "31"
							|| arrComboCode[i] == "33"
					) {
						strComboText += "<option value='"+ arrComboCode[i] +"'>"+ arrComboText[i] +"</option>";
					}
				}
			}
			*/
			$("#searchCardType").html(strComboText);
		});

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
            <%// 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. => initdata 세팅으로 조정
            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.%>
   			{Header:"대상년도",		Type:"Text",      Hidden:0,  Width:50,    Align:"Center",  ColMerge:1,   SaveName:"work_yy",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4, DefaultValue:"<%=yeaYear%>" },
   			{Header:"사용연도",     Type:"Combo",      Hidden:0,  Width:50,    Align:"Center",  ColMerge:1,   SaveName:"use_yyyy",        KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
	        {Header:"정산구분",		Type:"Combo",     Hidden:0,  Width:120,    Align:"Center",  ColMerge:1,   SaveName:"adjust_type",	KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"부서명",			Type:"Text",      Hidden:0,  Width:90,    Align:"Left",    ColMerge:1,   SaveName:"org_nm",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"성명",			Type:"Popup",	  Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"name",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"사번",			Type:"Text",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:1,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"순서",			Type:"Text",      Hidden:1,  Width:0,     Align:"Center",  ColMerge:1,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
	        {Header:"명의인",			Type:"Text",      Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"fam_nm",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"명의인\n주민번호",	Type:"Text",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"famres",			KeyField:1,   CalcLogic:"",   Format:"Number",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"반기구분",       	Type:"Combo",     Hidden:1,  Width:95,    Align:"Center",  ColMerge:1,   SaveName:"half_gubun",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"카드구분",       	Type:"Combo",     Hidden:0,  Width:190,   Align:"Center",  ColMerge:1,   SaveName:"card_type",		KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"카드명",        	Type:"Text",      Hidden:0,  Width:95,    Align:"Center",  ColMerge:1,   SaveName:"card_enter_nm",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"금액자료\n(직원용)",	Type:"Int",       Hidden:1,  Width:70,    Align:"Right",   ColMerge:1,   SaveName:"use_mon",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        // {Header:"사용년도",	Type:"Text",       Hidden:1,  Width:80,    Align:"Center",   ColMerge:1,   SaveName:"use_yyyy",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"금액(담당자용)",	Type:"AutoSum",   Hidden:0,  Width:70,    Align:"Right",   ColMerge:1,   SaveName:"appl_mon",		KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"자료입력유형",		Type:"Combo",     Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"adj_input_type",	KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"국세청\n자료여부",	Type:"CheckBox",  Hidden:0,  Width:40,	Align:"Center",  ColMerge:1,   SaveName:"nts_yn",			KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
	        {Header:"의료기관\n사용액",	Type:"Int",       Hidden:1,  Width:80,    Align:"Right",   ColMerge:1,   SaveName:"med_mon",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"회사지원금",		Type:"Int",       Hidden:1,  Width:80,    Align:"Right",   ColMerge:1,   SaveName:"co_deduct_mon",	KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"담당자확인",      Type:"Text",      Hidden:1,  Width:70,  Align:"Center",  ColMerge:1,   SaveName:"feedback_type",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:160 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
      	//작업구분
        adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
		//자료입력유형
        inputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00325"), "전체" );
        //반기구분
		halfGubunList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&visualYn=Y&useYn=Y&searchYear=<%=yeaYear%>","C00304"), "");
		//월구간 조회
<%-- 		var periodType = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00314"), ""); --%>
// 		sheet1.SetColProperty("period_type",		 {ComboText:"|"+periodType[0], ComboCode:"|"+periodType[1]} );
        cardTypeList = stfConvCode(ajaxCall("<%=jspPath%>/cardHisMgr/cardHisMgrRst.jsp?cmd=selectDataCardType", "searchYyType=0&searchYear=<%=yeaYear%>", false).codeList, "전체");
        $("#searchCardType").html(cardTypeList[2]).val("0");

		sheet1.SetColProperty("card_type", {ComboText:"|"+cardTypeList[0], ComboCode:"|"+cardTypeList[1]});
		sheet1.SetColProperty("half_gubun",		{ComboText:"|"+halfGubunList[0], ComboCode:"|"+halfGubunList[1]} );
		sheet1.SetColProperty("adj_input_type", {ComboText:inputTypeList[0], ComboCode:inputTypeList[1]});
		sheet1.SetColProperty("use_yyyy", {ComboText:"2024|2023", ComboCode:"2024|2023"});

		$("#searchInputType").html(inputTypeList[2]);
		$("#searchHalfGubun").html("<option value=''>전체</option>"+ halfGubunList[2]);
		//$("#searchCardType").html("<option value=''>전체</option>");
		//$("#searchPeriodType").html("<option value=''>전체</option>"+ periodType[2]);

        //담당자확인(2021.10.25)
        feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00329"), "전체");
        sheet1.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        $("#searchFeedBackType").html(feedbackTypeList[2]);

        // 사업장(권한 구분)
		var ssnSearchType  = "<%=ssnSearchType%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();

        getCprBtnChk();	
        			
		//양식다운로드용 sheet 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = cardTypeList[0].split("|"); codeCd = cardTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "카드구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = inputTypeList[0].split("|"); codeCd = inputTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "자료입력유형 : " + codeCdNm + "\n";

		//doAction1("Search");

		// 작년사업관련비용불러오기 버튼 주석처리
        var getYeaBpCardLoad = ajaxCall("<%=jspPath%>/cardHisMgr/cardHisMgrRst.jsp?cmd=getYeaBpCardLoad",$("#sheetForm").serialize()+"&searchAdjustType="+$("#searchAdjustType").val(),false);

        if(getYeaBpCardLoad.Data != null){
              if(getYeaBpCardLoad.Data.cnt > 0){
                  $("#showBtn").show();
              }else{
                  $("#showBtn").hide();
              }
        }
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
			sheet1.DoSearch( "<%=jspPath%>/cardHisMgr/cardHisMgrRst.jsp?cmd=selectCardHisMgrList", $("#sheetForm").serialize() );
			break;
		case "Save":
			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
				if( sheet1.GetCellValue(i, "sStatus") == "U" ||
					sheet1.GetCellValue(i, "sStatus") == "I" ||
					sheet1.GetCellValue(i, "sStatus") == "S"
				) {
					if(sheet1.GetCellValue(i,"adj_input_type")=="07") {
						alert('PDF업로드는 선택할 수 없습니다.');
						sheet1.SelectCell(i, "adj_input_type");
						return;
					}
				}
			}
			sheet1.DoSave( "<%=jspPath%>/cardHisMgr/cardHisMgrRst.jsp?cmd=saveCardHisMgr",$("#sheetForm").serialize());
			break;
		case "Insert":
			if(chkRqr()){
	       		 break;
	       	}

			var Row = sheet1.DataInsert(0) ;
			sheet1.SetCellValue(Row, "seq", "" ) ;
			sheet1.SetCellValue(Row, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(Row, "adjust_type", $("#searchAdjustType").val() ) ;
			sheet1.SetCellValue(Row, "use_yyyy", $("#searchUseYyyy").val() ) ;
			break;
		case "Copy":
			if (sheet1.GetCellValue(sheet1.GetSelectRow(), "adj_input_type") == "07") {
				alert("PDF업로드 자료는 복사할 수 없습니다.");
				return;
			}

			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "seq", "" ) ;
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		case "Down2Template":
			//var param  = {DownCols:"5|6|7|8|9|11|12|14|15|17|18|19|20",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
			var param  = {DownCols:"adjust_type"
                                   +"|use_yyyy|sabun|famres|card_type|card_enter_nm|appl_mon|adj_input_type",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,7",menuNm:$(document).find("title").text()
                ,HiddenColumn:1 //  열숨김 반영 여부 (Default: 0)
                };

			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
			if(chkRqr()){
	       		 break;
	       	}

            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.
            // 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. 
            //              work_yy     => initdata 세팅으로 조정 
            //              adjust_type => 엑셀 양식에서 key-in으로 조정
            //sheet1.SetColProperty(0, "work_yy", { DefaultValue: $("#searchYear").val() } );
            //sheet1.SetColProperty(0, "adjust_type", { DefaultValue: $("#searchAdjustType").val() } );

			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
        case "prcYeaBpCardLoad":
           var thisYear = $("#searchYear").val();
           var lastyear = thisYear - 1;
           var confirmMsg = "귀속 "+lastyear+"년에 등록된 사업관련비용을"
        	   confirmMsg +=" 귀속 "+thisYear+"년, \n사용연도 "+lastyear+"년으로 불러옵니다.(근로자 본인만)"
        	   confirmMsg += "\n기존 귀속 "+thisYear+"년, 사용연도 "+lastyear+"년으로 등록된 사업관련 건들은"
        	   confirmMsg += "\n지우고 재생성됩니다. 진행하시겠습니까?";

           if(confirm(confirmMsg)){
               ajaxCall("<%=jspPath%>/cardHisMgr/cardHisMgrRst.jsp?cmd=prcYeaBpCardLoad",$("#sheetForm").serialize()
                       ,true
                       ,function(){
                           doAction1('Search');
                       }
               );

           }
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
			if(sheet1.ColSaveName(Col) == "sDelete" ) {
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

			if( sheet1.ColSaveName(Col) == "half_gubun" ) {
				sheet1.CellComboItem(Row, "card_type", {ComboText:"|", ComboCode:"|"});
				sheet1.SetCellValue(Row, "card_type", "");
			}
			//신용카드구분
			if( sheet1.ColSaveName(Col) == "card_type" ) {
				if(sheet1.GetCellValue(Row, "appl_mon") < 0){
					if(sheet1.GetCellValue(Row, "card_type") == "3" ||sheet1.GetCellValue(Row, "card_type") == "4"){
						alert("사업관련비용일 경우에는 양수로 기입해주십시오.");
						sheet1.SetCellValue(Row, "appl_mon","0");
					}
				}
			}
			//금액자료
			if(sheet1.ColSaveName(Col) == "appl_mon") {
				if(sheet1.GetCellValue(Row, "appl_mon") < 0){
					if(sheet1.GetCellValue(Row, "card_type") == "3" ||sheet1.GetCellValue(Row, "card_type") == "4"){
						alert("사업관련비용일 경우에는 양수로 기입해주십시오.");
						sheet1.SetCellValue(Row, "appl_mon","0");
					}
				}
			}
		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

// 	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol, isDelete) {
// 		try{
// 			var Row = NewRow;
// 			var Col = NewCol;

// 			if( sheet1.ColSaveName(Col) == "card_type" ) {
// 				var half_gubun = sheet1.GetCellValue(Row,"half_gubun");
// 				var card_type = sheet1.GetCellValue(Row,"card_type");

// 				var arrComboText = cardTypeList[0].split("|");
// 				var arrComboCode = cardTypeList[1].split("|");

// 				var strComboText = "", strComboCode = "";

// 				// 당해년도
// 				if ( half_gubun == "10" || half_gubun == "20" || half_gubun == "30"  ) {
// 					for(var i=0; i<arrComboCode.length; i++) {
// 						if ( arrComboCode[i] == "1"
// 								|| arrComboCode[i] == "2"
// 								|| arrComboCode[i] == "3"
// 								|| arrComboCode[i] == "7"
// 								|| arrComboCode[i] == "11"
// 								|| arrComboCode[i] == "13"
// 								|| arrComboCode[i] == "15"
// 								|| arrComboCode[i] == "17"
// 						) {
// 							strComboText += "|"+ arrComboText[i];
// 							strComboCode += "|"+ arrComboCode[i];
// 						}
// 					}

// 				// 2015
// 				} /*else if ( half_gubun == "2015"  ) {
// 					for(var i=0; i<arrComboCode.length; i++) {
// 						if ( arrComboCode[i] == "51"
// 								|| arrComboCode[i] == "52"
// 								|| arrComboCode[i] == "53"
// 								|| arrComboCode[i] == "54"
// 								|| arrComboCode[i] == "55"
// 								|| arrComboCode[i] == "56"
// 								|| arrComboCode[i] == "57"
// 								|| arrComboCode[i] == "58"
// 						) {
// 							strComboText += "|"+ arrComboText[i];
// 							strComboCode += "|"+ arrComboCode[i];
// 						}
// 					}

// 				// 2014
// 				} else if ( half_gubun == "2014"  ) {
// 					for(var i=0; i<arrComboCode.length; i++) {
// 						if ( arrComboCode[i] == "41"
// 								|| arrComboCode[i] == "42"
// 								|| arrComboCode[i] == "43"
// 								|| arrComboCode[i] == "44"
// 								|| arrComboCode[i] == "45"
// 								|| arrComboCode[i] == "46"
// 								|| arrComboCode[i] == "47"
// 								|| arrComboCode[i] == "48"
// 						) {
// 							strComboText += "|"+ arrComboText[i];
// 							strComboCode += "|"+ arrComboCode[i];
// 						}
// 					}

// 				// 2013
// 				} else if ( half_gubun == "2013"  ) {
// 					for(var i=0; i<arrComboCode.length; i++) {
// 						if ( arrComboCode[i] == "21"
// 								|| arrComboCode[i] == "23"
// 								|| arrComboCode[i] == "25"
// 								|| arrComboCode[i] == "27"
// 								|| arrComboCode[i] == "29"
// 								|| arrComboCode[i] == "31"
// 								|| arrComboCode[i] == "33"
// 						) {
// 							strComboText += "|"+ arrComboText[i];
// 							strComboCode += "|"+ arrComboCode[i];
// 						}
// 					}

// 				} */
// 				/*
// 				else {
// 					alert("반기구분을 먼저 선택해 주세요");
// 					strComboText = "|";
// 					strComboCode = "|";
// 					card_type = "";
// 				}
// 				*/

// 				sheet1.CellComboItem(Row, "card_type", {ComboText: strComboText, ComboCode: strComboCode});
// 				sheet1.SetCellValue(Row, "card_type", card_type);
// 			}

// 		} catch(ex) {
// 			alert("OnChange Event Error : " + ex);
// 		}
// 	}


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

	function sheet1_OnLoadExcel(result) {
		try {
			var msgSts = false;
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
								
	            <%--
				sheet1.GetCellValue( i, "card_type"); //카드구분
				sheet1.GetCellValue( i, "use_mon");	  //금액자료(직원용)
				sheet1.GetCellValue( i, "appl_mon");  //금액자료(담당자용)
				sheet1.GetCellValue( i, "work_yy");  //년도
				--%>
				
				if( sheet1.GetCellValue( i, "use_mon") < 0) {
					if(sheet1.GetCellValue( i, "card_type") == "3" || sheet1.GetCellValue( i, "card_type") == "4"){
						sheet1.SetCellValue2( i, "use_mon","0"); // 20250428. 성능 문제로 인하여 onChange 이벤트가 발생하지 않도록 SetCellValue2 사용
						msgSts = true;
					}
				}
				if( sheet1.GetCellValue( i, "appl_mon") < 0) {
					if(sheet1.GetCellValue( i, "card_type") == "3" || sheet1.GetCellValue( i, "card_type") == "4"){
						sheet1.SetCellValue2( i, "appl_mon","0"); // 20250428. 성능 문제로 인하여 onChange 이벤트가 발생하지 않도록 SetCellValue2 사용
						msgSts = true;
					}
				}
				
				// sheet1.SetCellValue( i, "use_yyyy", sheet1.GetCellValue( i, "work_yy"));
			}
			if(msgSts == true ){
				alert("사업관련비용일 경우에는 양수로 기입해주십시오.");
			}
		} catch(ex) {
			alert("OnLoadExcel Event Error " + ex);
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
   			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
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
				<%-- 무의미한 분기문 주석 처리 20240919
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				--%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%-- 무의미한 분기문 주석 처리 20240919}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}--%>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                </td>
				<td><span>자료입력유형</span>
					<select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
			</tr>
			<tr>
<!--                 <td> -->
<!--                     <span>월구간</span> -->
<!--                     <select id="searchPeriodType" name ="searchPeriodType" class="box" onChange="javascript:doAction1('Search')"></select> -->
<!--                 </td> -->
				<%-- 히든 필드에 대한 조회 조건이므로 숨김 처리 20240919--%>
                <td class="hide"><span>담당자확인</span>
                    <select id="searchFeedBackType" name ="searchFeedBackType" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
                 <td>
	                   <span>사용연도</span> 
	                   <select id="searchUseYyyy" name ="searchUseYyyy" class="box" onChange="javascript:doAction1('Search')"> 
	                       <option value="2024" selected="selected">2024</option>
                           <option value="2023">2023</option>
	                   </select>
	             </td>
                <td colspan=2><span>카드구분</span>
                    <select id="searchCardType" name ="searchCardType" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
				<td class="hide"><span>반기구분</span>
                    <select style="display:none;" id="searchHalfGubun" name ="searchHalfGubun" onChange="javascript:doAction1('Search')" class="box"></select>
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
            <li class="txt">신용카드내역관리</li>
            <li class="btn">
                <a href="javascript:doAction1('prcYeaBpCardLoad')" class="basic btn-white out-line authA" id="showBtn" style="display:none;">23년사업관련비용불러오기</a>
				<a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')" 			class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>