<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근로소득관리</title>
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

	var chkRow;
	var titleList = new Array();    //상.하반기 타이틀리스트

	residencyList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=<%=curSysYear%><%=curSysMon%>","H20290"), "");
	residencyTypeList = {ComboText:"거주자|비거주자", ComboCode:"1|2"};
	citizenTypeList = {ComboText:"내국인|외국인", ComboCode:"1|9"};
	sendTypeList = {ComboText:"정기|수정", ComboCode:"1|2"};

	// 사업장(권한 구분)
	var ssnSearchType = "<%=ssnSearchType%>";

	if(ssnSearchType == "A"){
		businessPlaceList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
	}else{
		businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
	}

	$(function() {
		$("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchSabun").val( $("#searchUserId").val() ) ;

		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6,MergeSheet:msHeaderOnly};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata0.Cols = [
                {Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
                {Header:"마감\n여부",		    Type:"CheckBox",  	Hidden:0,  	Width:50,   	Align:"Center",  	ColMerge:0,   	SaveName:"final_close_yn",		KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:160},
                {Header:"사번",		            Type:"Text",      	Hidden:0,  	Width:60,		Align:"Center",    	ColMerge:0,   	SaveName:"sabun",   			KeyField:1,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                {Header:"성명",  			        Type:"Popup",		Hidden:0,  	Width:70,   	Align:"Center",		ColMerge:0,   	SaveName:"name",				KeyField:1,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                {Header:"신고\n구분",  	    Type:"Combo",		Hidden:0,  	Width:60,   	Align:"Center",		ColMerge:0,   	SaveName:"send_type",			KeyField:1,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                {Header:"사업장",		        Type:"Combo",      	Hidden:0,  	Width:100,		Align:"Center",    	ColMerge:0,   	SaveName:"business_place_cd", 	KeyField:1,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                {Header:"입사일",			    Type:"Date",      	Hidden:0,  	Width:80,   	Align:"Center",  	ColMerge:0,   	SaveName:"emp_ymd",				KeyField:0,   	CalcLogic:"",   Format:"Ymd",   	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
                {Header:"퇴사일",			    Type:"Date",      	Hidden:0,  	Width:80,   	Align:"Center",  	ColMerge:0,   	SaveName:"ret_ymd",				KeyField:0,   	CalcLogic:"",   Format:"Ymd",   	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
                {Header:"주민등록\n번호", 	Type:"Text",		Hidden:0,	Width:110,		Align:"Center",		ColMerge:0,		SaveName:"res_no",				KeyField:0,		CalcLogic:"",	Format:"IdNo",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
                {Header:"전화번호",		        Type:"Text",      	Hidden:1,  	Width:110,		Align:"Center",    	ColMerge:0,   	SaveName:"tel_no",   			KeyField:0,   	CalcLogic:"",   Format:"PhoneNo", 	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:11 },
                {Header:"내/외\n국인",		Type:"Combo",      	Hidden:0,  	Width:60,		Align:"Center",    	ColMerge:0,   	SaveName:"citizen_type",   		KeyField:0,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                {Header:"거주자\n구분",	    Type:"Combo",      	Hidden:0,  	Width:80,		Align:"Center",    	ColMerge:0,   	SaveName:"residency_type",   	KeyField:0,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
                {Header:"거주\n지국",		    Type:"Combo",      	Hidden:0,  	Width:80,		Align:"Center",    	ColMerge:0,   	SaveName:"residency_cd",   		KeyField:0,   	CalcLogic:"",   Format:"",    		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 , Wrap:1},
                {Header:"근무\n시작일",	    Type:"Date",      	Hidden:0,  	Width:100,   	Align:"Center",  	ColMerge:0,   	SaveName:"adj_s_ymd",			KeyField:1,   	CalcLogic:"",   Format:"Ymd",   	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
                {Header:"근무\n종료일",	    Type:"Date",      	Hidden:0,  	Width:100,   	Align:"Center",  	ColMerge:0,   	SaveName:"adj_e_ymd",			KeyField:0,   	CalcLogic:"",   Format:"Ymd",   	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
                
                //2020.01.01 개정으로 급여 등과 인정상여로 구분. 급여 등은 기존 과세소득 컬럼인 tax_mon 그대로 사용하기로 함
                //{Header:"과세소득",		Type:"AutoSum",		Hidden:0,  	Width:100,		Align:"Right",    	ColMerge:1,   	SaveName:"tax_mon",   			KeyField:0,   	CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
				//{Header:"비과세소득",	Type:"AutoSum",		Hidden:0,  	Width:100,		Align:"Right",    	ColMerge:1,   	SaveName:"non_tax_mon",   		KeyField:0,   	CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },

				{Header:"급여 등",		    Type:"AutoSum",		Hidden:0,  	Width:100,		Align:"Right",    	ColMerge:0,   	SaveName:"tax_mon",   			KeyField:0,   	CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"인정상여",	    Type:"AutoSum",		Hidden:0,  	Width:100,		Align:"Right",    	ColMerge:0,   	SaveName:"etc_bonus_mon",   	KeyField:0,   	CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"소득합계",	    Type:"AutoSum",		Hidden:0,  	Width:100,		Align:"Right",		ColMerge:0,   	SaveName:"tax_mon_total",		KeyField:0,     CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|tax_mon|+|etc_bonus_mon|" },
				{Header:"대상년도",		Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"work_yy",   			KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"지급월",		Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"work_mm",   			KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"반기구분코드",Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"half_type",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				//{Header:"소득귀속년도",	Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"cre_work_yy",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
				{Header:"소득구분",		Type:"Text",		Hidden:1,  	Width:0,		Align:"Left",    	ColMerge:0,   	SaveName:"income_type",   		KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },

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
			{Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"residency_type" },
			{Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"send_type" },
			{Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"residency_cd" },
            {Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"business_place_cd" },
            {Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"citizen_type" }
        ];

        IBS_InitSheet(sheet2, initdata2);

        /* 현재년도 */
		$("#searchYear").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;

		/* 거주지국 */
		sheet1.SetColProperty("residency_cd", 		{ComboText:"|"+residencyList[0], ComboCode:"|"+residencyList[1]} );

		/* 내/외국인 */

		sheet1.SetColProperty("citizen_type", citizenTypeList);

		/* 거주자구분 */
		sheet1.SetColProperty("residency_type", residencyTypeList);

		/* 사업장 */
	    sheet1.SetColProperty("business_place_cd", 		{ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );
		$("#searchBusinessPlace").html(businessPlaceList[2]);

		/* 신고구분 */
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
		
		/* 상반기 (2~7월) */
		if(mm > 1 && mm < 8){
			$("#searchHalfType01").prop("selected", true);
		}
		/* 하반기 (8~1월)*/
		else{
			if(mm == 1) {
				$("#searchYear").val($("#searchYear").val()-1);
			}
			$("#searchHalfType02").prop("selected", true);
		}
		
		$("#searchWorkMm"+mm).prop("selected", true);
		
		doAction1("Search");
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
	        case "Search":
	        	//2021년 하반기 이후에만 월별 시트 적용
	        	searchTitleList();
	        	//소계 추가
// 	        	var info = [{StdCol:3 , SumCols:"17|18", CaptionCol:0}];
// 	        	sheet1.ShowSubSum(info);
	        	//sheet1.DoSearch( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=getSimplePymtEarnIncpMgr", $("#mySheetForm").serialize() );
	        	break;

	        case "Save":

	        	if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	if($("#searchWorkMm").val() == "") { alert("지급월을 선택해 주십시오."); return ; }

	        	/* 중복 사번 /입사일 체크 */

	        	var sabuns = "";
	        	var adjSYmds = "";

		        for(var i=1; i<=sheet1.LastRow()+1; i++) {

		        	if(sheet1.GetCellValue(i, "sStatus") == "I") {
		        		sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
		        		adjSYmds += "'"+sheet1.GetCellValue( i, "adj_s_ymd" ) + "',";
		        	}
		        }

		        if (sabuns.length > 1) {
					sabuns = sabuns.substr(0,sabuns.length-1);
					adjSYmds = adjSYmds.substr(0,adjSYmds.length-1);
		        }

		        <%-- dupChk() 사용으로 변경 - 2020.01.14.
 				for(var j=1; j<=sheet1.LastRow()+1; j++) {

		        	if(sheet1.GetCellValue(j, "sStatus") == "I") {
		        		var param = "searchYear="+$("#searchYear").val()			// 대상년도
						+"&searchHalfType="+$("#searchHalfType").val()				// 반기구분
						+"&sabuns="+sabuns											// 사번
						+"&adjSYmds="+adjSYmds										// 입사일
						+"&searchBusinessPlace="+$("#searchBusinessPlace").val(); 	// 사업장

						var data = ajaxCall("<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=getSabunChk", param,false);

						if(data.Data.cnt > 0){
							alert("동일한 근무일에 중복된 사번 ("+data.Data.sabuns+") 확인 바랍니다.");
							return;
						}
		        	}
		        }
		        --%>

 				/* 중복체크
				   adj_s_ymd(근무시작일)은 회사에 따라서 PK로 잡혀있지 않은 곳도 있어서 일단 중복체크에서 제외
				   work_yy, half_type, income_type 도 각각 searchYear 와 searchHalfType, '77'로 고정값이니 중복체크에서 제외 */
				if (!dupChk2(sheet1, "send_type|sabun|business_place_cd", true, true)) {break;} // 중복체크
	        	sheet1.DoSave( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=saveSimplePymtEarnIncpMgr", $("#mySheetForm").serialize());
	        	break;

	        	/* 거주지국 일괄 변경(해외->대한민국 / 마감상태 :Y) */
		 		<%-- case "EtcSaveAll":

		 			var chkCnt = 0;

		 			for(var j=1; j<=sheet1.LastRow()+1; j++) {
			        	if((sheet1.GetCellValue(j, "final_close_yn") == '1') && (sheet1.GetCellValue(j, "residency_cd") != 'KR')) {
			        		sheet1.SetCellValue(j, "residency_cd", 'KR');
			        		chkCnt++;
			        	}
			        }

		 			if(chkCnt == 0){
		 				alert("저장할 내역이 없습니다.");
		 				return;
		 			}

		        	sheet1.DoSave( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=saveSimplePymtEarnIncpMgr", $("#mySheetForm").serialize());
		        	doAction1("Search");
	        	break; --%>
	        case "Insert":

	        	if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	if($("#searchWorkMm").val() == "") { alert("지급월을 선택해 주십시오."); return ; }
	        	var newRow = sheet1.DataInsert(0) ;
	        	sheet1.SetCellEditable(newRow, "sabun",false);
	        	sheet1.SetCellEditable(newRow, "emp_ymd",false);
	        	sheet1.SetCellEditable(newRow, "ret_ymd",false);
	        	sheet1.SetCellEditable(newRow, "final_close_yn",false);

        		sheet1.SetCellValue(newRow, "sStatus",		"I");
	        	break;
	        case "Copy":
	        	var newRow = sheet1.DataCopy();
	        	sheet1.SetCellValue(newRow, "final_close_yn",   "0" );
	        	sheet1.SetCellValue(newRow, "sabun",  "" );
	        	sheet1.SetCellValue(newRow, "name",   "" );
	        	sheet1.SetCellEditable(newRow, "emp_ymd",false);
	        	sheet1.SetCellEditable(newRow, "ret_ymd",false);
	        	sheet1.SetCellEditable(newRow, "sabun",false);
	        	sheet1.SetCellEditable(newRow, "final_close_yn",false);
	        	sheet1.SetCellEditable(newRow, "sDelete",true);
	        	break;
	        case "Clear":       sheet1.RemoveAll(); break;
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
				sheet1.Down2Excel(param); break;
	        case "Down2Template":
	            var titleText  = "작성방법 \n 1.거주지국/신고구분/거주자구분/사업장/내외구분 sheet2를 참조하여 작성 \n"+
	            				 " 2.근무시작일/종료일 : ex>2019-01-01 \n"+
	            				 " 3.전화번호 : 셀선택 >마우스 오른쪽 >셀서식 >표시형식>텍스트 변경 후 작성 \n "+
	            				 " 4.저장시 해당 Row 삭제 저장 후 Upload 해주시기 바랍니다.";
	            var titleText2 = "거주\n지국|신고\n구분|거주자\n구분|사업장|내/외\n국인" + "\r\n";

	            var residencyArr     	= residencyList[0].split("|");				//거주지국
	            var residencyTypeArr    = residencyTypeList.ComboText.split("|");	//거주자구분
	            var businessPlaceArr    = businessPlaceList[0].split("|");			//사업장
	            var citizenTypeArr    	= citizenTypeList.ComboText.split("|");		//내/외국인
	            var sendTypeArr    		= sendTypeList.ComboText.split("|");		//신고구분

	            for(var i = 0; i < residencyArr.length; i++) {
	                titleText2 = titleText2
	                           + (i<residencyArr.length?residencyArr[i]:"")
	                           + "|" + (i<sendTypeArr.length?sendTypeArr[i]:"")
	                           + "|" + (i<residencyTypeArr.length?residencyTypeArr[i]:"")
	                           + "|" + (i<businessPlaceArr.length?businessPlaceArr[i]:"")
	                           + "|" + (i<citizenTypeArr.length?citizenTypeArr[i]:"")
	                           + "\r\n";
	            }
	            var downcol = makeHiddenSkipCol(sheet1);
	            //var param  = {DownCols:"4|5|6|7|10|12|13|14|15|16|17|18",SheetDesign:1,Merge:1,DownRows:0,FileName:'Template',SheetName:'sheet1',UserMerge:"0,0,1,12",TitleText:titleText, ExcelRowHeight:100 };

	            if($("#halfDivFlag").val() != "true"){
	            	var param  = {DownCols:downcol,SheetDesign:1,Merge:1,DownRows:"0",FileName:'Template',SheetName:'sheet1',UserMerge:"0,0,1,12",TitleText:titleText, ExcelRowHeight:100 };
	            }else{
	            	var param  = {DownCols:downcol,SheetDesign:1,Merge:1,DownRows:"0|1",FileName:'Template',SheetName:'sheet1',UserMerge:"0,0,1,12",TitleText:titleText, ExcelRowHeight:100 };
	            }

	            var downcol = makeHiddenSkipCol(sheet1);
	            var param2 = {DownRows:downcol,FileName:'Template',SheetName:'sheet2',TitleText:titleText2};

	            sheet1.Down2ExcelBuffer(true);

	            //엑셀팝업 방지 param 추가 (true)
	            sheet1.Down2Excel(param,true);
	            //sheet2.Down2Excel(param2,true);

	            sheet1.Down2ExcelBuffer(false);

				break;
	        case "LoadExcel":
	        	if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
	        	if($("#searchWorkMm").val() == "") { alert("지급월을 선택해 주십시오."); return ; }
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
							sheet1.SetCellEditable(i, "residency_type",true);
							sheet1.SetCellEditable(i, "residency_cd",true);
							//sheet1.SetCellEditable(i, "adj_s_ymd",true);
							sheet1.SetCellEditable(i, "adj_e_ymd",true);
							//sheet1.SetCellEditable(i, "tax_mon",true);
							//sheet1.SetCellEditable(i, "non_tax_mon",true);
							//sheet1.SetCellEditable(i, "etc_bonus_mon",true);
							//sheet1.SetCellEditable(i, "ret_ymd",true);
						}else{
							//sheet1.SetCellEditable(i, "final_close_yn",false);
							sheet1.SetCellEditable(i, "sDelete",false);
							sheet1.SetCellFontColor(i ,"sabun" ,"#0000ff");
						}
					}
				}
				if($("#halfDivFlag").val() != "true"){
					sheetResize();
				}

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

			<%-- var	rv = openPopup("<%=jspPath%>/common/ownerPopup.jsp?authPg=<%=authPg%>",	args, "740","520"); --%>
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
        	sheet1.SetCellEditable(i, "final_close_yn",false);
        	sheet1.SetCellEditable(i, "emp_ymd",false);
        	sheet1.SetCellEditable(i, "ret_ymd",false);
        }
    }

	// 생성 프로시저 팝업호출
	function callProcPop() {

		if($("#searchYear").val() == "") { alert("년도를 입력하여 주십시오."); return ; }
    	if($("#searchWorkMm").val() == "") { alert("지급월을 선택해 주십시오."); return ; }

		var url 	= "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrPopMonth.jsp";
        var args = new Array();

        //정산년도
        args["searchYear"]     = $('#searchYear').val();
        //지급월
        args["searchWorkMm"]   = $('#searchWorkMm').val();
        //상/하반기
        args["halfType"]     = $('#searchHalfType').val();
        //근로/사업/비거주 구분
        args["searchGb"]     = "근로";

        var rv = openPopup(url,args,500,320);
	}

	//생성 팝업(2021.11.08)
    function callProcPopNew(Row) {
        if(!isPopup()) {return;}

        var url     = "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrPopMonth2.jsp";

        pGubun = "callProcPopNew";


        var args = new Array();
        args["workYy"]   = $('#searchYear').val();
        args["workMm"]   = $('#searchWorkMm').val();
        args["halfType"] = $('#searchHalfType').val();
        args["sendType"] = $('#searchSendType').val();
        args["incomeType"] = "77";
        args["calcType"] = "";
        args["delYn"]    = "Y";
        args["businessPlace"] = $('#searchBusinessPlace').val();
        openPopup(url, args, "1200","580");

    }
	// 전체마감/전체마감취소
	function finalCloseYnChk(val){

		var confirmMsg     = "";
		var closeYn ="";

		if(val == "C"){
			confirmMsg = "[ "+$("#searchYear").val()+"년 / "+$('#searchWorkMm option:selected').text()+"월 / 사업장("+$('#searchBusinessPlace option:selected').text()+") ]"+" 전체 마감하시겠습니까?";
			closeYn    = "Y";
		}else{
			confirmMsg = "[ "+$("#searchYear").val()+"년 / "+$('#searchWorkMm option:selected').text()+"월 / 사업장("+$('#searchBusinessPlace option:selected').text()+") ]"+" 전체 마감 취소하시겠습니까?";
			closeYn    = "N";
		}
		if(confirm(confirmMsg)){
			var params = $("#mySheetForm").serialize()+"&final_close_yn="+closeYn;
			ajaxCall("<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=updateSimplePymtEarnIncpMgr",params,false);
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
	//2021.07.05(반기구분별 SHEET)
	function searchTitleList() {
		sheet1.Reset();
		sheet2.Reset();
        if($("#searchYear").val() < "2021" || ($("#searchYear").val() == "2021" &&  $("#searchHalfType").val() == "1")){
            $("#halfDivFlag").val("false");
        }else{
            $("#halfDivFlag").val("true");
        }
		if($("#halfDivFlag").val() == "true"){
			var v = 0;
			var initdata1 = {};

			initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:6, MergeSheet:msHeaderOnly};
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

			initdata1.Cols = [];
			initdata1.Cols[v++] = {Header:"No",             Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" };
			initdata1.Cols[v++] = {Header:"삭제",            Type:"<%=sDelTy%>", Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 };
			initdata1.Cols[v++] = {Header:"상태",            Type:"<%=sSttTy%>", Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 };
			initdata1.Cols[v++] = {Header:"마감\n여부",          Type:"CheckBox",    Hidden:0,   Width:50,       Align:"Center",     ColMerge:0,     SaveName:"final_close_yn",      KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:160};
			initdata1.Cols[v++] = {Header:"사번",                   Type:"Text",        Hidden:0,   Width:60,       Align:"Center",     ColMerge:0,     SaveName:"sabun",               KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 };
			initdata1.Cols[v++] = {Header:"성명",                   Type:"Popup",       Hidden:0,   Width:70,       Align:"Center",     ColMerge:0,     SaveName:"name",                KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"신고\n구분",          Type:"Combo",       Hidden:0,   Width:60,       Align:"Center",     ColMerge:0,     SaveName:"send_type",           KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 };
			initdata1.Cols[v++] = {Header:"사업장",                 Type:"Combo",       Hidden:0,   Width:100,      Align:"Center",     ColMerge:0,     SaveName:"business_place_cd",   KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 };
			initdata1.Cols[v++] = {Header:"입사일",                 Type:"Date",        Hidden:0,   Width:80,       Align:"Center",     ColMerge:0,     SaveName:"emp_ymd",             KeyField:0,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 };
			initdata1.Cols[v++] = {Header:"퇴사일",                 Type:"Date",        Hidden:0,   Width:80,       Align:"Center",     ColMerge:0,     SaveName:"ret_ymd",             KeyField:0,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 };
			initdata1.Cols[v++] = {Header:"주민등록\n번호",     Type:"Text",        Hidden:0,   Width:110,      Align:"Center",     ColMerge:0,     SaveName:"res_no",              KeyField:0,     CalcLogic:"",   Format:"IdNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 };
			initdata1.Cols[v++] = {Header:"내/외\n국인",        Type:"Combo",       Hidden:0,   Width:60,       Align:"Center",     ColMerge:0,     SaveName:"citizen_type",        KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 };
			initdata1.Cols[v++] = {Header:"거주자\n구분",       Type:"Combo",       Hidden:0,   Width:80,       Align:"Center",     ColMerge:0,     SaveName:"residency_type",      KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 };
			initdata1.Cols[v++] = {Header:"거주\n지국",          Type:"Combo",       Hidden:0,   Width:80,       Align:"Center",     ColMerge:0,     SaveName:"residency_cd",        KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 , Wrap:1};
			initdata1.Cols[v++] = {Header:"근무\n시작일",       Type:"Date",        Hidden:0,   Width:100,      Align:"Center",     ColMerge:0,     SaveName:"adj_s_ymd",           KeyField:1,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 };
			initdata1.Cols[v++] = {Header:"근무\n종료일",       Type:"Date",        Hidden:0,   Width:100,      Align:"Center",     ColMerge:0,     SaveName:"adj_e_ymd",           KeyField:0,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 };

            initdata1.Cols[v++]  = {Header:"급여 등",     Type:"AutoSum",  Hidden:0,   Width:100,      Align:"Right",      ColMerge:1,     SaveName:"tax_mon",               KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
            initdata1.Cols[v++]  = {Header:"인정상여",    Type:"AutoSum",  Hidden:0,   Width:100,      Align:"Right",      ColMerge:1,     SaveName:"etc_bonus_mon",         KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
            initdata1.Cols[v++]  = {Header:"소득합계",    Type:"AutoSum",  Hidden:0,   Width:100,      Align:"Right",      ColMerge:0,     SaveName:"tax_mon_total",         KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|tax_mon|+|etc_bonus_mon|" };			   
			
			initdata1.Cols[v++] = {Header:"대상년도",       Type:"Text",     Hidden:1,   Width:0,        Align:"Left",       ColMerge:0,     SaveName:"work_yy",             KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
			initdata1.Cols[v++] = {Header:"지급월",       Type:"Text",     Hidden:1,   Width:0,        Align:"Left",       ColMerge:0,     SaveName:"work_mm",             KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
			initdata1.Cols[v++] = {Header:"반기구분코드", Type:"Text",     Hidden:1,   Width:0,        Align:"Left",       ColMerge:0,     SaveName:"half_type",           KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
			initdata1.Cols[v++] = {Header:"소득구분",       Type:"Text",     Hidden:1,   Width:0,        Align:"Left",       ColMerge:0,     SaveName:"income_type",         KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
	        initdata1.Cols[v++] = {Header:"전화번호",              Type:"Text",        Hidden:1,   Width:110,      Align:"Center",     ColMerge:0,     SaveName:"tel_no",              KeyField:0,     CalcLogic:"",   Format:"PhoneNo",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:11 };

			IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(4);
			/* 총계 라인 title명 */
			sheet1.SetSumValue("sNo", "총  계") ;
			/* 총계 라인 bold*/
			sheet1.SetSumFontBold(1);

			// 사업장(권한 구분)
			var ssnSearchType = "<%=ssnSearchType%>";

			if(ssnSearchType == "A"){
			    businessPlaceList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
			}else{
			    businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
			}
			/* 사업장 */
			sheet1.SetColProperty("business_place_cd",      {ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );

			/* 현재년도 */
			//$("#searchYear").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;

			/* 거주지국 */
			residencyList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=<%=curSysYear%><%=curSysMon%>","H20290"), "");
			sheet1.SetColProperty("residency_cd",       {ComboText:"|"+residencyList[0], ComboCode:"|"+residencyList[1]} );

			/* 내/외국인 */
			citizenTypeList = {ComboText:"내국인|외국인", ComboCode:"1|9"};
			sheet1.SetColProperty("citizen_type", citizenTypeList);

			/* 거주자구분 */
			residencyTypeList = {ComboText:"거주자|비거주자", ComboCode:"1|2"};
			sheet1.SetColProperty("residency_type", residencyTypeList);

			/* 신고구분 */
			sheet1.SetColProperty("send_type", sendTypeList);
			sheet1.DoSearch( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=getSimplePymtEarnIncpMgr", $("#mySheetForm").serialize() );
		}else{
			//2021년 상반기 이전
            var v = 0;
            var initdata0 = {};
                initdata0.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:6};
                initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

                initdata0.Cols = [];

                initdata0.Cols[v++] = {Header:"No",          Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" };
                initdata0.Cols[v++] = {Header:"삭제",         Type:"<%=sDelTy%>", Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 };
                initdata0.Cols[v++] = {Header:"상태",         Type:"<%=sSttTy%>", Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 };
                initdata0.Cols[v++] = {Header:"마감\n여부",    Type:"CheckBox",    Hidden:0,   Width:50,       Align:"Center",     ColMerge:0,     SaveName:"final_close_yn",      KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:160};
                initdata0.Cols[v++] = {Header:"사번",         Type:"Text",        Hidden:0,   Width:60,       Align:"Center",     ColMerge:0,     SaveName:"sabun",               KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 };
                initdata0.Cols[v++] = {Header:"성명",         Type:"Popup",       Hidden:0,   Width:70,       Align:"Center",     ColMerge:0,     SaveName:"name",                KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 };
                initdata0.Cols[v++] = {Header:"신고\n구분",    Type:"Combo",       Hidden:0,   Width:60,       Align:"Center",     ColMerge:0,     SaveName:"send_type",           KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 };
                initdata0.Cols[v++] = {Header:"사업장",        Type:"Combo",       Hidden:0,   Width:100,      Align:"Center",     ColMerge:0,     SaveName:"business_place_cd",   KeyField:1,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 };
                initdata0.Cols[v++] = {Header:"입사일",        Type:"Date",        Hidden:0,   Width:80,       Align:"Center",     ColMerge:0,     SaveName:"emp_ymd",             KeyField:0,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 };
                initdata0.Cols[v++] = {Header:"퇴사일",        Type:"Date",        Hidden:0,   Width:80,       Align:"Center",     ColMerge:0,     SaveName:"ret_ymd",             KeyField:0,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 };
                initdata0.Cols[v++] = {Header:"주민등록\n번호",  Type:"Text",        Hidden:0,   Width:110,      Align:"Center",     ColMerge:0,     SaveName:"res_no",              KeyField:0,     CalcLogic:"",   Format:"IdNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 };
                initdata0.Cols[v++] = {Header:"전화번호",       Type:"Text",        Hidden:1,   Width:110,      Align:"Center",     ColMerge:0,     SaveName:"tel_no",              KeyField:0,     CalcLogic:"",   Format:"PhoneNo",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:11 };
                initdata0.Cols[v++] = {Header:"내/외\n국인",    Type:"Combo",       Hidden:0,   Width:60,       Align:"Center",     ColMerge:0,     SaveName:"citizen_type",        KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 };
                initdata0.Cols[v++] = {Header:"거주자\n구분",   Type:"Combo",       Hidden:0,   Width:80,       Align:"Center",     ColMerge:0,     SaveName:"residency_type",      KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 };
                initdata0.Cols[v++] = {Header:"거주\n지국",     Type:"Combo",       Hidden:0,   Width:80,       Align:"Center",     ColMerge:0,     SaveName:"residency_cd",        KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 , Wrap:1};
                initdata0.Cols[v++] = {Header:"근무\n시작일",    Type:"Date",        Hidden:0,   Width:100,      Align:"Center",     ColMerge:0,     SaveName:"adj_s_ymd",           KeyField:1,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 };
                initdata0.Cols[v++] = {Header:"근무\n종료일",    Type:"Date",        Hidden:0,   Width:100,      Align:"Center",     ColMerge:0,     SaveName:"adj_e_ymd",           KeyField:0,     CalcLogic:"",   Format:"Ymd",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 };
                initdata0.Cols[v++] = {Header:"급여 등",        Type:"AutoSum",     Hidden:0,   Width:100,      Align:"Right",      ColMerge:1,     SaveName:"tax_mon",             KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
                initdata0.Cols[v++] = {Header:"인정상여",       Type:"AutoSum",     Hidden:0,   Width:100,      Align:"Right",      ColMerge:1,     SaveName:"etc_bonus_mon",       KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
                initdata0.Cols[v++] = {Header:"소득합계",       Type:"AutoSum",     Hidden:0,   Width:100,      Align:"Right",      ColMerge:0,     SaveName:"tax_mon_total",       KeyField:0,     CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35, CalcLogic:"|tax_mon|+|etc_bonus_mon|" };
                initdata0.Cols[v++] = {Header:"대상년도",       Type:"Text",        Hidden:1,   Width:0,        Align:"Left",       ColMerge:0,     SaveName:"work_yy",             KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
                initdata0.Cols[v++] = {Header:"반기구분코드",    Type:"Text",        Hidden:1,   Width:0,        Align:"Left",       ColMerge:0,     SaveName:"half_type",           KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };
                initdata0.Cols[v++] = {Header:"소득구분",       Type:"Text",        Hidden:1,   Width:0,        Align:"Left",       ColMerge:0,     SaveName:"income_type",         KeyField:0,     CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 };

                IBS_InitSheet(sheet1, initdata0); sheet1.SetCountPosition(4);
                /* 총계 라인 title명 */
                sheet1.SetSumValue("sNo", "총  계") ;
                /* 총계 라인 bold*/
                sheet1.SetSumFontBold(1);

                sheet1.DoSearch( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=getSimplePymtEarnIncpMgr", $("#mySheetForm").serialize() );

                // 사업장(권한 구분)
                var ssnSearchType = "<%=ssnSearchType%>";

                if(ssnSearchType == "A"){
                    businessPlaceList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
                }else{
                    businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
                }
                /* 사업장 */
                sheet1.SetColProperty("business_place_cd",      {ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );

                /* 현재년도 */
                //$("#searchYear").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;

                /* 거주지국 */
                residencyList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=<%=curSysYear%><%=curSysMon%>","H20290"), "");
                sheet1.SetColProperty("residency_cd",       {ComboText:"|"+residencyList[0], ComboCode:"|"+residencyList[1]} );

                /* 내/외국인 */
                citizenTypeList = {ComboText:"내국인|외국인", ComboCode:"1|9"};
                sheet1.SetColProperty("citizen_type", citizenTypeList);

                /* 거주자구분 */
                residencyTypeList = {ComboText:"거주자|비거주자", ComboCode:"1|2"};
                sheet1.SetColProperty("residency_type", residencyTypeList);

                /* 신고구분 */
                sendTypeList = {ComboText:"정기|수정", ComboCode:"1|2"};
                sheet1.SetColProperty("send_type", sendTypeList);
		}
		var v1 = 0;
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
        initdata2.Cols = [];


        initdata2.Cols[v1++] =     {Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"residency_type"      };
        initdata2.Cols[v1++] =     {Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"send_type"           };
        initdata2.Cols[v1++] =     {Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"residency_cd"        };
        initdata2.Cols[v1++] =     {Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"business_place_cd"   };
        initdata2.Cols[v1++] =     {Header:"",   Type:"Text",    Hidden:0,    Width:80,    Align:"Center",    ColMerge:0,    SaveName:"citizen_type"        };


        IBS_InitSheet(sheet2, initdata2);
    }
	//2021.07.05(월별 급여,인정상여 합계 setting)
    function sheet1_OnChange(Row, Col, Value) {
        try {
            var colName = sheet1.ColSaveName(Col);
            /* if($("#searchHalfType").val() == "1"){
                if(colName == "tax_mon_1" || colName == "tax_mon_2" || colName == "tax_mon_3"
                || colName == "tax_mon_4" || colName == "tax_mon_5" || colName == "tax_mon_6"){
                    sheet1.SetCellValue(Row,"tax_mon",sheet1.GetCellValue(Row,"total_tax_mon_1"));
                }
                if(colName == "etc_bonus_mon_1" || colName == "etc_bonus_mon_2" || colName == "etc_bonus_mon_3"
                || colName == "etc_bonus_mon_4" || colName == "etc_bonus_mon_5" || colName == "etc_bonus_mon_6"){
                    sheet1.SetCellValue(Row,"etc_bonus_mon",sheet1.GetCellValue(Row,"total_etc_bonus_mon_1"));
                }
            }else{
                if($("#searchHalfType").val() == "2"){
                    if(colName == "tax_mon_7"  || colName == "tax_mon_8"  || colName == "tax_mon_9"
                    || colName == "tax_mon_10" || colName == "tax_mon_11" || colName == "tax_mon_12"){
                        sheet1.SetCellValue(Row,"tax_mon",sheet1.GetCellValue(Row,"total_tax_mon_2"));
                    }
                    if(colName == "etc_bonus_mon_7"  || colName == "etc_bonus_mon_8"  || colName == "etc_bonus_mon_9"
                    || colName == "etc_bonus_mon_10" || colName == "etc_bonus_mon_11" || colName == "etc_bonus_mon_12"){
                        sheet1.SetCellValue(Row,"etc_bonus_mon",sheet1.GetCellValue(Row,"total_etc_bonus_mon_2"));
                    }
                }
            } */
        } catch (ex) {
            alert("OnChange Event Error : " + ex);
        }
    }
	
	function searchWorkMm_onChange() {
		
		var searchMm = $("#searchWorkMm").val();  
		
		if(searchMm > 1 && searchMm < 8){
			$("#searchHalfType01").prop("selected", true);
		}
		/* 하반기 (8~1월)*/
		else{
			$("#searchHalfType02").prop("selected", true);
		}
		
		doAction1('Search');
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<%-- <%@ include file="/WEB-INF/jsp/common/include/employeeHeaderYtax.jsp"%> --%>

    <div class="sheet_search outer">
    <form id="mySheetForm" name="mySheetForm" >
    <input type="hidden" id="searchSabun" 		name="searchSabun" 		  value ="" />
    <input type="hidden" id="halfDivFlag"       name="halfDivFlag"        value ="" />
    <input id="menuNm" name="menuNm" type="hidden" value ="" />
        <div>
        <table>
        <tr>
            <td><span>년도</span>
			<input id="searchYear" name ="searchYear" type="text" class="text" maxlength="4" style= "width:40px; padding-left: 10px;"/> </td>
			<td><span>월구분</span>
				<select id="searchHalfType" name="searchHalfType" hidden="true" >
	                <option value="1" id="searchHalfType01">상반기</option>
	                <option value="2" id="searchHalfType02">하반기</option>
	            </select>
				<select id="searchWorkMm" name="searchWorkMm" onChange="javascript:searchWorkMm_onChange()" >
	                <option value="01" id="searchWorkMm1" selected="selected">1월</option>
	                <option value="02" id="searchWorkMm2">2월</option>
	                <option value="03" id="searchWorkMm3">3월</option>
	                <option value="04" id="searchWorkMm4">4월</option>
	                <option value="05" id="searchWorkMm5">5월</option>
	                <option value="06" id="searchWorkMm6">6월</option>
	                <option value="07" id="searchWorkMm7">7월</option>
	                <option value="08" id="searchWorkMm8">8월</option>
	                <option value="09" id="searchWorkMm9">9월</option>
	                <option value="10" id="searchWorkMm10">10월</option>
	                <option value="11" id="searchWorkMm11">11월</option>
	                <option value="12" id="searchWorkMm12">12월</option>
	            </select>
			</td>
            <td><span>신고구분</span>
                <select id="searchSendType" name="searchSendType" onChange="javascript:doAction1('Search')" class="box">
                    <option value="1" id="searchSendType01" selected="selected">정기</option>
                    <option value="2" id="searchSendType02">수정</option>
                </select>
            </td>
			<td><span>사업장</span>
				<select id="searchBusinessPlace" name ="searchBusinessPlace" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
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
	                <option value="2" id="searchRㅁesidencyType02">비거주자</option>
				</select>
			</td>
		</tr>
		<tr>
			<td><span>금액발생</span>
				<select id="searchTaxMon" name ="searchTaxMon" onChange="javascript:doAction1('Search')" class="box">
	                <option selected="selected" value="">전체</option>
	                <option value="Y" id="searchTaxMon01">Y</option>
	                <option value="N" id="searchTaxMon02">N</option>
				</select>
			</td>
            <td><span>마감여부</span>
                <select id="searchFinalCloseYn" name ="searchFinalCloseYn" onChange="javascript:doAction1('Search')" class="box">
                    <option selected="selected" value="">전체</option>
                    <option value="Y" id="">Y</option>
                    <option value="N" id="">N</option>
                </select>
            </td>
            <td><span>퇴사여부</span>
                <select id="searchEYmdYn" name ="searchEYmdYn" onChange="javascript:doAction1('Search')" class="box">
                    <option selected="selected" value="">전체</option>
                    <option value="Y" id="">Y</option>
                    <option value="N" id="">N</option>
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
            <li class="txt">근로소득관리  <font color='red'>(주민번호/전화번호 숫자만 입력해 주십시오)</font></li>
            <li class="btn">

			  <!-- <a href="javascript:doAction1('EtcSaveAll')" class="green authB">거주지국 일괄 변경</a> -->

              <a href="javascript:doAction1('Down2Template')"   class="basic authA">양식 다운로드</a>
              <a href="javascript:doAction1('LoadExcel')"   	class="basic authA">업로드</a>
              <a href="javascript:doAction1('Insert')" 			class="basic authA">입력</a>
              <a href="javascript:doAction1('Copy')"   			class="basic authA">복사</a>
              <a href="javascript:doAction1('Save')"   			class="basic authA">저장</a>
              <a href="javascript:doAction1('Down2Excel')"   	class="basic authR">다운로드</a>

              <% if("A".equals(session.getAttribute("ssnSearchType"))){ %>
	              <a href="javascript:finalCloseYnChk('C')"   	class="blue authA">전체마감</a>
	              <a href="javascript:finalCloseYnChk()"   		class="blue authA">전체마감취소</a>
              <%}else if("O".equals(session.getAttribute("ssnSearchType")) || "P".equals(session.getAttribute("ssnSearchType"))){%>
              <%} %>
              <a href="javascript:callProcPopNew();"               class="pink authA">생성</a>
<!--               <a href="javascript:callProcPop();"				class="pink authA">생성</a> -->
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