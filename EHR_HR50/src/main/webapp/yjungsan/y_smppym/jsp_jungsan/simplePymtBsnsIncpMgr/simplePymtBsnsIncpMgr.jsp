<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>사업소득관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ page import="yjungsan.util.DateUtil"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	
	var residencyList = "";			//거주지국
	var businessPlaceList = "";		//사업장
	var citizenTypeList = "";		//내외국인
	var sendTypeList	= "";		//신고구분
	
	var businessIncomeList = "";	//사업소득 업종 

	//2021.07.16 업종코드
	var c00508 = ""; 	
	var searchYM = <%=yjungsan.util.DateUtil.getDateTime("yyyy")%>;
	
	if(searchYM == "2021") {
		searchYM = searchYM + "06"
	} else if(searchYM > "2021") {
		searchYM = searchYM + "01"
	} else {
		searchYM = searchYM + "06"
	}
	
	c00508 = codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+searchYM, "C00508");
	
	residencyList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+searchYM,"H20290"), "");
	citizenTypeList = {ComboText:"내국인|외국인", ComboCode:"1|9"};
	sendTypeList = {ComboText:"정기|수정", ComboCode:"1|2"};
	
	businessIncomeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+searchYM,"C00508"), "");

	// 사업장(권한 구분)
	var ssnSearchType = "<%=removeXSS(ssnSearchType, '1')%>";
	
	if(ssnSearchType == "A"){
		businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBusinessPlaceList","",false).codeList, "전체");	
	}else{
		businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
	}
			
	
	$(function() {

		$("#searchSabun").val( $("#searchUserId").val() ) ;

		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata0.Cols = [
                {Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"마감\n여부",		Type:"CheckBox",  	Hidden:0,  	Width:50,   Align:"Center",  	ColMerge:0,   	SaveName:"final_close_yn",		KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:160},
                {Header:"사번",		    Type:"Text",      	Hidden:0,  	Width:60,	Align:"Center",    	ColMerge:0,   	SaveName:"sabun",   			KeyField:1,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                {Header:"성명",  			Type:"Popup",		Hidden:0,  	Width:70,   Align:"Center",		ColMerge:0,   	SaveName:"name",				KeyField:1,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                {Header:"신고\n구분",  	Type:"Combo",		Hidden:0,  	Width:70,   Align:"Center",		ColMerge:0,   	SaveName:"send_type",			KeyField:1,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                {Header:"사업장",		    Type:"Combo",      	Hidden:0,  	Width:100,	Align:"Center",    	ColMerge:0,   	SaveName:"business_place_cd", 	KeyField:1,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },

                {Header:"주민등록\n번호", 	Type:"Text",		Hidden:0,	Width:110,	Align:"Center",		ColMerge:0,		SaveName:"res_no",				KeyField:0,		CalcLogic:"",	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
                {Header:"전화번호",		Type:"Text",     	Hidden:0,  	Width:110,	Align:"Left",    	ColMerge:0,   	SaveName:"tel_no",   			KeyField:0,   	CalcLogic:"",   Format:"PhoneNo",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:11 },
                {Header:"내/외\n국인",		Type:"Combo",      	Hidden:0,  	Width:60,	Align:"Center",    	ColMerge:0,   	SaveName:"citizen_type",   		KeyField:0,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                {Header:"거주\n지국",		Type:"Combo",      	Hidden:1,  	Width:100,	Align:"Center",    	ColMerge:0,   	SaveName:"residency_cd",   		KeyField:0,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 , Wrap:1},
                {Header:"사업소득\n업종",	Type:"Combo",      	Hidden:0,  	Width:100,	Align:"Center",    	ColMerge:0,   	SaveName:"business_cd",   		KeyField:0,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                
                
                {Header:"지급연도",		Type:"Text",      	Hidden:1,  	Width:100,  Align:"Center",  	ColMerge:0,   	SaveName:"work_yy",				KeyField:0,   	CalcLogic:"",   Format:"",   		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },      
                {Header:"소득\n귀속연도",	Type:"Text",      	Hidden:1,  	Width:100,  Align:"Center",  	ColMerge:0,   	SaveName:"cre_work_yy",			KeyField:0,   	CalcLogic:"",   Format:"",   		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },      
                
                {Header:"지급건수",		Type:"AutoSum",		Hidden:1,  	Width:100,	Align:"Right",    	ColMerge:0,   	SaveName:"pay_cnt",   			KeyField:0,   	CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
				{Header:"지급총액",		Type:"AutoSum",		Hidden:0,  	Width:100,	Align:"Right",    	ColMerge:0,   	SaveName:"tax_mon",   			KeyField:0,   	CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
				
				{Header:"세율%",         Type:"Combo",       Hidden:0,   Width:100,  Align:"Right",      ColMerge:0,     SaveName:"rate",                KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"소득세",         Type:"AutoSum",     Hidden:0,   Width:100,  Align:"Right",      ColMerge:0,     SaveName:"itax_mon",            KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"주민세",         Type:"AutoSum",     Hidden:0,   Width:100,  Align:"Right",      ColMerge:0,     SaveName:"rtax_mon",            KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },

				{Header:"반기구분코드",		Type:"Text",		Hidden:1,  	Width:0,	Align:"Left",    	ColMerge:0,   	SaveName:"half_type",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"소득구분",		Type:"Text",		Hidden:1,  	Width:0,	Align:"Left",    	ColMerge:0,   	SaveName:"income_type",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },

				];

		IBS_InitSheet(sheet1, initdata0);
		sheet1.SetEditable("<%=editable%>");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		
		/* 총계 라인 title명 */
		sheet1.SetSumValue("sNo", "총  계") ;
		/* 총계 라인 bold*/
		sheet1.SetSumFontBold(1); 
		
		
		var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
        initdata2.Cols = [
			{Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"residency_cd" },
			{Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"send_type" },
			{Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"business_place_cd" },
			{Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"citizen_type" },
			{Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"business_cd" }			  
        ];
        
        IBS_InitSheet(sheet2, initdata2);   

        /* 현재년도 */
		$("#searchYear").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;
		
		/* 거주지국 */
		sheet1.SetColProperty("residency_cd", 		{ComboText:"|"+residencyList[0], ComboCode:"|"+residencyList[1]} );

		/* 사업소득 업종 */
		sheet1.SetColProperty("business_cd", 		{ComboText:"|"+businessIncomeList[0], ComboCode:"|"+businessIncomeList[1]} );
		
		/* 내/외국인 */
		sheet1.SetColProperty("citizen_type", citizenTypeList);


		/* 사업장 */
	    sheet1.SetColProperty("business_place_cd", 		{ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );
		$("#searchBusinessPlace").html(businessPlaceList[2]);
		
		/* 신고구분 */
		sheet1.SetColProperty("send_type", sendTypeList);

		sheet1.SetColProperty("rate",        {ComboText:"|3|5|20", ComboCode:"|3|5|20"} );
		
        $(window).smartresize(sheetResize); sheetInit();
        
        
		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});
		
		$("#searchSabunNameAlias").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});
		
		
		var today = new Date();
		var mm = today.getMonth()+1;
		
// 		/* 상반기 (2~7월) */
// 		if(mm > 1 && mm < 8){
// 			$("#searchHalfType01").prop("selected", true);
// 		}
// 		/* 하반기 (8~1월)*/
// 		else{
// 			if(mm == 1) {
// 				$("#searchYear").val($("#searchYear").val()-1);
// 			}
// 			$("#searchHalfType02").prop("selected", true);
// 		}
		
		//2021.07.12 기간구분
		workPartSet();
		doAction1("Search");
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
	        case "Search":
	        	//소계 추가
// 	        	var info = [{StdCol:3 , SumCols:"15|16", CaptionCol:0}];
// 	        	sheet1.ShowSubSum(info) ;
	        	sheet1.DoSearch( "<%=jspPath%>/simplePymtBsnsIncpMgr/simplePymtBsnsIncpMgrRst.jsp?cmd=getSimplePymtBsnsIncpMgr", $("#mySheetForm").serialize() ); 
	        	
	        	break;
	        case "Save":
	        	
	        	if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	if($("#searchHalfType").val() == "") { alert("상/하반기 선택해 주십시오."); return ; }
	        	
				/* 중복 사번 체크 */
	        	var sabuns = "";
	        	
		        for(var i=1; i<=sheet1.LastRow()+1; i++) {
		        	
		        	if(sheet1.GetCellValue(i, "sStatus") == "I") {
		        		sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
		        	}
		        }
		        
		        if (sabuns.length > 1) {
					sabuns = sabuns.substr(0,sabuns.length-1);
		        }
		        
		        <%-- dupChk() 사용으로 변경 - 2020.01.14.
 				for(var j=1; j<=sheet1.LastRow()+1; j++) {
		        	
		        	if(sheet1.GetCellValue(j, "sStatus") == "I") {
		        		var param = "searchYear="+$("#searchYear").val()			// 대상년도
						+"&searchHalfType="+$("#searchHalfType").val()				// 반기구분
						+"&sabuns="+sabuns											// 사번
						+"&searchBusinessPlace="+$("#searchBusinessPlace").val(); 	// 사업장
						
						var data = ajaxCall("<%=jspPath%>/simplePymtBsnsIncpMgr/simplePymtBsnsIncpMgrRst.jsp?cmd=getSabunChk", param,false);
			       
						if(data.Data.cnt > 0){
							alert("중복된 사번 ("+data.Data.sabuns+") 확인 바랍니다.");
							return;
						}
		        	}
		        }
		        --%>
		        
 				if (!dupChk2(sheet1, "send_type|sabun|business_place_cd", true, true)) {break;} // 중복체크
	        	sheet1.DoSave( "<%=jspPath%>/simplePymtBsnsIncpMgr/simplePymtBsnsIncpMgrRst.jsp?cmd=saveSimplePymtBsnsIncpMgr", $("#mySheetForm").serialize());
	        	
	        	break;
	        case "Insert":    
	        	if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	if($("#searchHalfType").val() == "") { alert("상/하반기 선택해 주십시오."); return ; }
	        	var newRow = sheet1.DataInsert(0) ;
        		sheet1.SetCellValue(newRow, "work_yy",		$("#searchYear").val()); 
        		sheet1.SetCellValue(newRow, "sStatus",		"I");
        		sheet1.SetCellEditable(newRow, "sabun",false);
	        	sheet1.SetCellEditable(newRow, "final_close_yn",false);
	        	sheet1.SetCellEditable(newRow, "work_yy",false);
	        	break;
	        case "Copy":        
	        	var newRow = sheet1.DataCopy();
	        	sheet1.SetCellValue(newRow, "final_close_yn",   "0" );
	        	sheet1.SetCellValue(newRow, "sabun",  "" );
	        	sheet1.SetCellValue(newRow, "name",   "" );
	        	sheet1.SetCellValue(newRow, "work_yy",		$("#searchYear").val()); 
        		sheet1.SetCellEditable(newRow, "sabun",false);
	        	sheet1.SetCellEditable(newRow, "final_close_yn",false);
	        	sheet1.SetCellEditable(newRow, "work_yy",false);
	        	sheet1.SetCellEditable(newRow, "sDelete",true);
	        	break;
	        case "Clear":       sheet1.RemoveAll(); break;
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param); break;
	        case "Down2Template":
	        	
	        	//var titleText  = "항목 정보는 sheet2 를 참조하여 주시고 Upload 시에는 해당 Row를 삭제 후 저장 하시기 바랍니다.";
	        	var titleText  = "작성방법 \n 1.거주지국/신고구분/사업장/내외국인/사업소득업종 sheet2를 참조하여 작성\n"+
				                 "2.전화번호 : 셀선택 >마우스 오른쪽 >셀서식 >표시형식>텍스트 변경 후 작성 \n"+
				                 "3.저장시 해당 Row 삭제 저장 후 Upload 해주시기 바랍니다.";
	            var titleText2 = "거주\n지국|신고\n구분|사업장|내/외\n국인|사업소득\n업종" + "\r\n";
	            
	            var residencyArr     	= residencyList[0].split("|");				//거주지국
	            var businessPlaceArr    = businessPlaceList[0].split("|");			//사업장
	            var citizenTypeArr    	= citizenTypeList.ComboText.split("|");		//내/외국인
	            var sendTypeArr    		= sendTypeList.ComboText.split("|");		//신고구분
	            var businessIncomeArr   = businessIncomeList[0].split("|");			//사업소득 업종
	            

	            
	            for(var i = 0; i < residencyArr.length; i++) {
	                titleText2 = titleText2
	                           + (i<residencyArr.length?residencyArr[i]:"")
	                           + "|" + (i<sendTypeArr.length?sendTypeArr[i]:"")
	                           + "|" + (i<businessPlaceArr.length?businessPlaceArr[i]:"")
	                           + "|" + (i<citizenTypeArr.length?citizenTypeArr[i]:"")
	                           + "|" + (i<businessIncomeArr.length?businessIncomeArr[i]:"")
	                           + "\r\n";
	            }
	            
	            var param  = {DownCols:"4|5|6|7|8|9|10|11|12|16",SheetDesign:1,Merge:1,DownRows:0,FileName:'Template',SheetName:'sheet1',UserMerge:"0,0,1,8",ExcelRowHeight:100, TitleText:titleText};
	            var param2 = {DownRows:0,FileName:'Template',SheetName:'sheet2',TitleText:titleText2};
	            
	            sheet1.Down2ExcelBuffer(true);
	            
	            sheet1.Down2Excel(param);
	            sheet2.Down2Excel(param2);
	            
	            sheet1.Down2ExcelBuffer(false);

				break;
	        case "LoadExcel":	
	        	if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	if($("#searchHalfType").val() == "") { alert("상/하반기 선택해 주십시오."); return ; }
	        	//doAction1("Clear") ; 
	        	var params = {Mode:"HeaderMatch", WorkSheetNo:1, Append :1}; 
	        	sheet1.LoadExcel(params);
	        	break;
        }
    }

    

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
				if (Msg != ""){ 
					alert(Msg); 
				} else {  
					for(var i=1; i <= sheet1.LastRow(); i++){
						if(sheet1.GetCellValue(i, "final_close_yn") != "1"){
						
							sheet1.SetCellEditable(i, "res_no",true);
							sheet1.SetCellEditable(i, "tel_no",true);
							sheet1.SetCellEditable(i, "citizen_type",true);
							sheet1.SetCellEditable(i, "residency_cd",true);
							sheet1.SetCellEditable(i, "business_cd",true);
							//sheet1.SetCellEditable(i, "cre_work_yy",true);
							sheet1.SetCellEditable(i, "pay_cnt",true);
							sheet1.SetCellEditable(i, "tax_mon",true);
						}else{
							//sheet1.SetCellEditable(i, "final_close_yn",false);
							sheet1.SetCellEditable(i, "sDelete",false);
							sheet1.SetCellFontColor(i ,"sabun" ,"#0000ff"); 
						}
					}
					
				} 
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
	     	
	     	args["earnerCd"]     = "3";

			var	rv = openPopup("<%=jspPath%>/common/ownerPopup.jsp?authPg=<%=authPg%>",	args, "740","520");

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
        	sheet1.SetCellValue(i, "work_yy",		$("#searchYear").val()); 
    		sheet1.SetCellEditable(i, "sabun",false);
        	sheet1.SetCellEditable(i, "final_close_yn",false);
        	sheet1.SetCellEditable(i, "work_yy",false);
        	
        }
    }
	
	// 생성 프로시저 팝업호출
	function callProcPop() {
		
		if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
    	if($("#searchHalfType").val() == "") { alert("상/하반기 선택해 주십시오."); return ; }
		
		var url 	= "<%=jspPath%>/simplePymtBsnsIncpMgr/simplePymtBsnsIncpMgrPop.jsp";
        var args = new Array();
        
        //정산년도
        args["workYy"]       = $('#searchYear').val();
      	//상/하반기
        args["halfType"]     = $('#searchHalfType').val();        
        //근로/사업/비거주 구분
        args["searchGb"]     = "사업";
        args["businessPlace"] = $('#searchBusinessPlace').val();

        var rv = openPopup(url,args,500,320);
	}
	
	// 전체마감/전체마감취소 
	function finalCloseYnChk(val){
				
		var confirmMsg     = "";
		var closeYn ="";

		if(val == "C"){
			confirmMsg = "[ "+$("#searchYear").val()+"년도 / "+$('#searchHalfType option:selected').text()+" / 사업장("+$('#searchBusinessPlace option:selected').text()+") ]"+" 전체마감하시겠습니까?";
			closeYn    = "Y";
		}else{
			confirmMsg = "[ "+$("#searchYear").val()+"년도 / "+$('#searchHalfType option:selected').text()+" / 사업장("+$('#searchBusinessPlace option:selected').text()+") ]"+" 전체마감 취소하시겠습니까?";
			closeYn    = "N";
		}
		if(confirm(confirmMsg)){
			
			var params = $("#mySheetForm").serialize()+"&final_close_yn="+closeYn;	
			ajaxCall("<%=jspPath%>/simplePymtBsnsIncpMgr/simplePymtBsnsIncpMgrRst.jsp?cmd=updateSimplePymtEarnIncpMgr",params,false);
			                      
			doAction1("Search");
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
    /*
                기간구분 코드 
                    상반기          : 1
                    하반기          : 2
         1월 ~ 12월 : 01 ~ 12
    */
	function workPartSet(){
	       if($("#searchYear").val() == "2021"){
	             $('#searchHalfType').empty();
	             $('#searchHalfType').append("<option value='1'>상반기</option>");	             
	             $('#searchHalfType').append("<option value='07'>7월</option>");
	             $('#searchHalfType').append("<option value='08'>8월</option>");
	             $('#searchHalfType').append("<option value='09'>9월</option>");
	             $('#searchHalfType').append("<option value='10'>10월</option>");
	             $('#searchHalfType').append("<option value='11'>11월</option>");
	             $('#searchHalfType').append("<option value='12'>12월</option>");
	        }else if($("#searchYear").val() > "2021"){
	            $('#searchHalfType').empty();
	            $('#searchHalfType').append("<option value='01'>1월</option>");
	            $('#searchHalfType').append("<option value='02'>2월</option>");
	            $('#searchHalfType').append("<option value='03'>3월</option>");
	            $('#searchHalfType').append("<option value='04'>4월</option>");
	            $('#searchHalfType').append("<option value='05'>5월</option>");
	            $('#searchHalfType').append("<option value='06'>6월</option>");        
	            $('#searchHalfType').append("<option value='07'>7월</option>");
	            $('#searchHalfType').append("<option value='08'>8월</option>");
	            $('#searchHalfType').append("<option value='09'>9월</option>");
	            $('#searchHalfType').append("<option value='10'>10월</option>");
	            $('#searchHalfType').append("<option value='11'>11월</option>");
	            $('#searchHalfType').append("<option value='12'>12월</option>");
	        }else{
	            $('#searchHalfType').empty();
	            $('#searchHalfType').append("<option value='1'>상반기</option>");
	            $('#searchHalfType').append("<option value='2'>하반기</option>");
	        }   
	}
    //값이 바뀔때 발생
    //2021.07.16 업종코드, 지급총액 , 세율 세팅
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{
        	
        	var rate = sheet1.GetCellValue(Row,"rate");
        	
            if( sheet1.ColSaveName(Col) == "business_cd" ) {

                //업종코드 선택시 세율 자동 세팅.
                var businessCd = sheet1.GetCellValue(Row, "business_cd");
                
                if(c00508 != null && c00508.length > 0) {
                    for(var i = 0; i < c00508.length; i++) {
                        if(c00508[i].code == businessCd) {
                            sheet1.SetCellValue(Row, "rate", c00508[i].note1);
                            break;
                        }
                    }
                }
                
                if(rate.length > 0 && sheet1.GetCellValue(Row,"tax_mon") != null){
                    //세율이 세팅되어있을 경우
                    var itax = sheet1.GetCellValue(Row, "tax_mon") * sheet1.GetCellValue(Row, "rate") /   100 ;

					// 소득세법 제86조 [소액 부징수] 가 2024.07.01 부로 시행되어 1천원 미만의 소득세에 대해서도 원천징수 하는 것으로 개정됨.
                    if(itax < 1000 && $("#searchYear").val() + $("#searchHalfType").val() < "202407") {
                        sheet1.SetCellValue(Row,"itax_mon",0);
                    } else {
                        sheet1.SetCellValue(Row,"itax_mon",parseInt(itax/10,10)*10);
                    }                	
                }
                
            } else if( sheet1.ColSaveName(Col) == "tax_mon" || sheet1.ColSaveName(Col) == "rate") {
            	
            	
            	if(rate.length > 0){
            		//세율이 세팅되어있을 경우
            		var itax = sheet1.GetCellValue(Row, "tax_mon") * sheet1.GetCellValue(Row, "rate") /   100 ;

					// 소득세법 제86조 [소액 부징수] 가 2024.07.01 부로 시행되어 1천원 미만의 소득세에 대해서도 원천징수 하는 것으로 개정됨.
            		if(itax < 1000 && $("#searchYear").val() + $("#searchHalfType").val() < "202407") {
                        sheet1.SetCellValue(Row,"itax_mon",0);
                    } else {
                        sheet1.SetCellValue(Row,"itax_mon",parseInt(itax/10,10)*10);
                    }
            	}
            	
            } else if(sheet1.ColSaveName(Col) == "itax_mon") {

                //소득세 변경시   주민세 계산
                if(sheet1.GetCellValue(Row, "itax_mon") != "") {
                    var itax = sheet1.GetCellValue(Row, "itax_mon");
                    sheet1.SetCellValue(Row,"rtax_mon", parseInt(itax*0.1/10,10)*10 );
                } else {
                    sheet1.SetCellValue(Row,"rtax_mon", 0 );
                }

            }
        } catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<%-- <%@ include file="/WEB-INF/jsp/common/include/employeeHeaderYtax.jsp"%> --%>

    <div class="sheet_search outer">
    <form id="mySheetForm" name="mySheetForm" >
    <input type="hidden" id="searchSabun" 		name="searchSabun" 		value ="" />
        <div>
        <table>
        <tr>
            <td><span>년도</span>
			<input id="searchYear" name ="searchYear" type="text" class="text" maxlength="4" style= "width:40px; padding-left: 10px;" onchange="workPartSet();"/> </td>
			<td><span>기간구분</span>
				<select id="searchHalfType" name="searchHalfType" onChange="javascript:doAction1('Search')">
	                <option value="">전체</option>
	            </select>
			</td>
			<td><span>사업장</span>
				<select id="searchBusinessPlace" name ="searchBusinessPlace" onChange="javascript:doAction1('Search')" class="box"></select> 
			</td>
		</tr>
		<tr>
			<td><span>내/외국인</span>
				<select id="searchCitizenType" name ="searchCitizenType" onChange="javascript:doAction1('Search')" class="box">
	                <option selected="selected" value="">전체</option>
	                <option value="1" id="searchCitizenType01">내국인</option>
	                <option value="9" id="searchCitizenType02">외국인</option>					
				</select> 
			</td>
			<td><span>거주자구분</span>
				<select id="searchResidencyType" name ="searchResidencyType" onChange="javascript:doAction1('Search')" class="box">
	                <option selected="selected" value="">전체</option>
	                <option value="1" id="searchResidencyType01">거주자</option>
	                <option value="2" id="searchResidencyType02">비거주자</option>				
				</select> 
			</td>						
			<td><span>금액발생</span>
				<select id="searchTaxMon" name ="searchTaxMon" onChange="javascript:doAction1('Search')" class="box">
	                <option selected="selected" value="">전체</option>
	                <option value="Y" id="searchTaxMon01">Y</option>
	                <option value="N" id="searchTaxMon02">N</option>					
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
            <li class="txt">사업소득관리 <font color='red'>(주민번호/전화번호 숫자만 입력해 주십시오)</font></li>
            <li class="btn">
			  <!-- <a href="javascript:doAction1('Search')" class="basic authA button">조회</a> -->
              <a href="javascript:doAction1('Down2Template')"   class="basic authA">양식 다운로드</a>
              <a href="javascript:doAction1('LoadExcel')"   class="basic authA">업로드</a>
              <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   class="basic authR">다운로드</a>
                            
              <% if("A".equals(session.getAttribute("ssnSearchType"))){ %>
	              <a href="javascript:finalCloseYnChk('C')"   	class="blue authA">전체마감</a>
	              <a href="javascript:finalCloseYnChk()"   		class="blue authA">전체마감취소</a>              	              
              <%}else if("O".equals(session.getAttribute("ssnSearchType")) || "P".equals(session.getAttribute("ssnSearchType"))){%>              
              <%} %>                           
              
              <a href="javascript:callProcPop();" class="pink authA">생성</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
	<tr class="hide">
         <td>
             <script type="text/javascript">createIBSheet("sheet2", "0%", "0%", "kr"); </script>
         </td>
     </tr>
</div>
</body>
</html>