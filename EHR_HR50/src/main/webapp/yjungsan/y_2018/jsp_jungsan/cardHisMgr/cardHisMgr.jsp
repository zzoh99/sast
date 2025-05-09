<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>신용카드내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

	//신용카드구분 코드 조회
    var cardTypeList = stfConvCode(ajaxCall("<%=jspPath%>/cardHisMgr/cardHisMgrRst.jsp?cmd=selectYeaDataCardCardType", "searchYyType=0", false).codeList, "");
	
	$(function() {
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
   			{Header:"대상년도",			Type:"Text",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"work_yy",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
	        {Header:"정산구분",			Type:"Combo",     Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"adjust_type",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"부서명",			Type:"Text",      Hidden:0,  Width:90,    Align:"Left",    ColMerge:1,   SaveName:"org_nm",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"성명",			Type:"Popup",	  Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"name",			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"사번",			Type:"Text",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:1,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"순서",			Type:"Text",      Hidden:1,  Width:0,     Align:"Center",  ColMerge:1,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
	        {Header:"명의인",			Type:"Text",      Hidden:0,  Width:70,    Align:"Center",  ColMerge:1,   SaveName:"fam_nm",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"명의인주민번호",		Type:"Text",      Hidden:0,  Width:100,   Align:"Center",  ColMerge:1,   SaveName:"famres",			KeyField:1,   CalcLogic:"",   Format:"Number",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
	        {Header:"반기구분",        	Type:"Combo",     Hidden:1,  Width:95,    Align:"Center",  ColMerge:1,   SaveName:"half_gubun",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"카드구분",        	Type:"Combo",     Hidden:0,  Width:95,    Align:"Center",  ColMerge:1,   SaveName:"card_type",		KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"카드명",        	Type:"Text",      Hidden:0,  Width:95,    Align:"Center",  ColMerge:1,   SaveName:"card_enter_nm",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"금액자료(직원용)",	Type:"Int",       Hidden:1,  Width:80,    Align:"Right",   ColMerge:1,   SaveName:"use_mon",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"금액(담당자용)",	Type:"AutoSum",   Hidden:0,  Width:90,    Align:"Right",   ColMerge:1,   SaveName:"appl_mon",		KeyField:1,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"자료입력유형",		Type:"Combo",     Hidden:0,  Width:80,    Align:"Center",  ColMerge:1,   SaveName:"adj_input_type",	KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"국세청\n자료여부",		Type:"CheckBox",  Hidden:0,  Width:70,	Align:"Center",  ColMerge:1,   SaveName:"nts_yn",			KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
	        {Header:"의료기관\n사용액",	Type:"Int",       Hidden:1,  Width:80,    Align:"Right",   ColMerge:1,   SaveName:"med_mon",		KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
	        {Header:"회사지원금",		Type:"Int",       Hidden:1,  Width:80,    Align:"Right",   ColMerge:1,   SaveName:"co_deduct_mon",	KeyField:0,   CalcLogic:"",   Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );		
		//자료입력유형
        var inputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00325"), "전체" );
        //반기구분
		var halfGubunList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&visualYn=Y&useYn=Y","C00304"), "");
     
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("card_type", {ComboText:"|"+cardTypeList[0], ComboCode:"|"+cardTypeList[1]});
		sheet1.SetColProperty("half_gubun",		{ComboText:"|"+halfGubunList[0], ComboCode:"|"+halfGubunList[1]} );
		sheet1.SetColProperty("adj_input_type", {ComboText:inputTypeList[0], ComboCode:inputTypeList[1]});
		
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchInputType").html(inputTypeList[2]);
		$("#searchHalfGubun").html("<option value=''>전체</option>"+ halfGubunList[2]);
		$("#searchCardType").html("<option value=''>전체</option>");

		// 사업장
        var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
        
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		
        $(window).smartresize(sheetResize); sheetInit();
        
		//doAction1("Search");
		
		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";
		
		codeCdNm = "";
		codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "정산구분 : " + codeCdNm + "\n";
		
		codeCdNm = "";
		codeNm = halfGubunList[0].split("|"); codeCd = halfGubunList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "반기구분 : " + codeCdNm + "\n";
		
		codeCdNm = "";
		codeNm = cardTypeList[0].split("|"); codeCd = cardTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "카드구분 : " + codeCdNm + "\n";

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
			
			sheet1.DoSave( "<%=jspPath%>/cardHisMgr/cardHisMgrRst.jsp?cmd=saveCardHisMgr"); 
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
			var param  = {DownCols:"5|6|7|8|9|11|12|14|15|17|18|19",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,9"};
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
			
		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol, isDelete) {
		try{
			var Row = NewRow;
			var Col = NewCol;
			
			if( sheet1.ColSaveName(Col) == "card_type" ) {
				var half_gubun = sheet1.GetCellValue(Row,"half_gubun");
				var card_type = sheet1.GetCellValue(Row,"card_type");
				
				var arrComboText = cardTypeList[0].split("|");
				var arrComboCode = cardTypeList[1].split("|");
				
				var strComboText = "", strComboCode = "";
				
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
							strComboText += "|"+ arrComboText[i];
							strComboCode += "|"+ arrComboCode[i];
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
							strComboText += "|"+ arrComboText[i];
							strComboCode += "|"+ arrComboCode[i];
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
							strComboText += "|"+ arrComboText[i];
							strComboCode += "|"+ arrComboCode[i];
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
							strComboText += "|"+ arrComboText[i];
							strComboCode += "|"+ arrComboCode[i];
						}
					}
					
				} */
				/*
				else {
					alert("반기구분을 먼저 선택해 주세요");
					strComboText = "|";
					strComboCode = "|";
					card_type = "";
				}
				*/
				
				sheet1.CellComboItem(Row, "card_type", {ComboText: strComboText, ComboCode: strComboCode});
				sheet1.SetCellValue(Row, "card_type", card_type);
			}
			
		} catch(ex) {
			alert("OnChange Event Error : " + ex);
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
				<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/> </td>
				
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
				<td><span>자료입력유형</span>
					<select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box"></select>
                </td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
        </table>
        <table>
			<tr>
			    
				<td><span style="display:none">카드구분</span>
					<select style="display:none;" id="searchCardType" name ="searchCardType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
<!-- 				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td> -->
				
				<td><span style="display:none">반기구분</span>
                    <select style="display:none;" id="searchHalfGubun" name ="searchHalfGubun" onChange="javascript:doAction1('Search')" class="box"></select> 
                </td>
                
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