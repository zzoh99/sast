<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>일용소득 업로드</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	var searchEarnerCd = "";

	$(function() {
		searchEarnerCd = p.popDialogArgument("searchEarnerCd");

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
    	initdata.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",		Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
       		{Header:"성명",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"주민번호",		Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"res_no",			KeyField:1,	Format:"IdNo",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
       		{Header:"사업장",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
       		{Header:"Location",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"location_cd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
       		{Header:"소득구분",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"earner_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		// 기타소득관리 정보
       		{Header:"지급일자",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payment_ymd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
       		{Header:"귀속연월",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"belong_ym",		KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
       		{Header:"소득코드",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Left",	ColMerge:0,	SaveName:"income_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"총지급액",		Type:"Int",			Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"tot_mon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"필요경비",		Type:"Int",			Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"expense_acct",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"소득금액",		Type:"Int",			Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"earn_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"세율(%)",	Type:"Int",			Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"tax_rate",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"소득세",		Type:"Int",			Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"itax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"지방소득세",	Type:"Int",			Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"rtax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
       		{Header:"농특세",		Type:"Int",			Hidden:0,					Width:90,			Align:"Right",	ColMerge:0,	SaveName:"atax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
       	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

		// 사업장(TCPN121)
		var bizPlaceCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "");
		sheet1.SetColProperty("business_place_cd", {ComboText:"|"+bizPlaceCd[0], ComboCode:"|"+bizPlaceCd[1]});
		
		// Location(TSYS015)
		var locationCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getLocationCdAllList") , "전체");
		sheet1.SetColProperty("location_cd", {ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]});

		// 소득구분(C00502)
		var earnerCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=","C00502"), "전체");
		sheet1.SetColProperty("earner_cd", {ComboText:"|"+earnerCd[0], ComboCode:"|"+earnerCd[1]});

		// 소득코드(C00504)
		var incomeCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM=","C00504"), "");
		sheet1.SetColProperty("income_cd", {ComboText:"|"+incomeCd[0], ComboCode:"|"+incomeCd[1]});

		$(window).smartresize(sheetResize);
		sheetInit();
	});

	$(function() {
        $("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction("Search");
			}
		});

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
        case "Insert":
        	var Row = sheet1.DataInsert(0) ;
        	sheet1.SetCellValue(Row, "earner_cd", searchEarnerCd ); //일용소득
        	break;
        case "Copy":
        	sheet1.DataCopy();
        	break;
		case "Save":
			if(!isNumberChk()) {
				alert("금액은 정수만 입력해 주세요.");
				break;
			}
			if(!confirm("반영하시겠습니까?")) {
				return;
			}
			sheet1.DoSave( "<%=jspPath%>/resdntEtcIncomeMgr/resdntEtcIncomeMgrRst.jsp?cmd=saveResdntEtcIncomeMgrPopup", "", -1, 0 );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		case "Down2Template":
			
// 			var templeteTitle = "업로드시 이 행은 삭제 합니다\n*지급일자 : yyyy-mm-dd, *귀속연월:yyyy-mm 형식으로 입력하여 주세요.";
// 			var param  = {DownCols:"3|4|5|8|9|10|11|12|13|14|15|16|17",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
// 				,TitleText:templeteTitle,UserMerge :"0,0,1,13"};
// 			sheet1.Down2Excel(param);
			
			var isHide = false;
			if (sheet1.GetColHidden("sNo") == 0) {
				isHide = true;
				sheet1.SetColHidden("sNo", 1);
			}

			var downcol = makeHiddenSkipCol(sheet1);
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:downcol});

			if (isHide == true) {
				sheet1.SetColHidden("sNo", 0);
			}
			
			break;
        case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
    }

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				p.popReturnValue([]);
				p.self.close();
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		try{
			if(sheet1.ColSaveName(Col) == "tot_mon"	|| sheet1.ColSaveName(Col) == "expense_acct"
				|| sheet1.ColSaveName(Col) == "earn_mon"	|| sheet1.ColSaveName(Col) == "itax_mon"
				|| sheet1.ColSaveName(Col) == "rtax_mon"	|| sheet1.ColSaveName(Col) == "atax_mon") {
				isNumberChk();
			}

		} catch(ex) {
			alert("OnChange	Event Error : "	+ ex);
		}
	}

    //setSheetSize(sheet1);
	function sheet1_OnResize(lWidth, lHeight) {
		try {
			setSheetSize(sheet1);
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}

	function sheet1_OnLoadExcel(result) {
		try {
			if(sheet1.RowCount() > 0) {
				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					sheet1.SetCellValue(i, "earner_cd", searchEarnerCd);
					isNumberChk();
				}
			}
		} catch(ex) {
			alert("OnLoadExcel Event Error : " + ex);
		}
	}
	
	function isNumberChk() {
		var isNumber = true;
		var reg = /^\d+$/;
		
		if(sheet1.RowCount() > 0) {
			for(var	i = 1; i < sheet1.RowCount()+1;	i++) {
				if(sheet1.GetCellValue(i, "sStatus") == 'I' || sheet1.GetCellValue(i, "sStatus") == 'U') {
					//정수가 아닌 경우 체크
					
					// 총지급액
					if(reg.test(sheet1.GetCellValue(i,"tot_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "tot_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "tot_mon", sheet1.GetCellBackColor(i, "tax_rate") );
					}
					
					// 필요경비
					if(reg.test(sheet1.GetCellValue(i,"expense_acct")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "expense_acct", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "expense_acct", sheet1.GetCellBackColor(i, "tax_rate") );
					}
					
					// 소득금액
					if(reg.test(sheet1.GetCellValue(i,"earn_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "earn_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "earn_mon", sheet1.GetCellBackColor(i, "tax_rate") );
					}
					
					// 소득세
					if(reg.test(sheet1.GetCellValue(i,"itax_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "itax_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "itax_mon", sheet1.GetCellBackColor(i, "tax_rate") );
					}
					
					// 지방소득세
					if(reg.test(sheet1.GetCellValue(i,"rtax_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "rtax_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "rtax_mon", sheet1.GetCellBackColor(i, "tax_rate") );
					}
					
					// 농특세
					if(reg.test(sheet1.GetCellValue(i,"atax_mon")) == false) {
						isNumber = false;
						sheet1.SetCellBackColor( i, "atax_mon", "#ffb8b8" );
					} else {
						sheet1.SetCellBackColor( i, "atax_mon", sheet1.GetCellBackColor(i, "tax_rate") );
					}
				}
			}
		}
		
		return isNumber;
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>기타소득 업로드</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
        <div class="popup_main">
        	<div>
				<div class="outer">
					<div class="sheet_title">
			        <ul>
			            <li class="txt">기타소득 업로드</li>
			            <li class="btn">
			              <a href="javascript:doAction1('Down2Template')"   class="basic authR">양식 다운로드</a>
			              <a href="javascript:doAction1('LoadExcel')"   class="basic authR">업로드</a>
			              <!--
			              <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
			              <a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
			               -->
			              <a href="javascript:doAction1('Save')"   class="basic authA">반영</a>
			              <!--
			              <a href="javascript:doAction1('Down2Excel')"   class="basic authR">다운로드</a>
			               -->
			            </li>
			        </ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
        	</div>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>