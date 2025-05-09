<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연금계좌 입금내역</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		$("#searchWorkYy").val("<%=curSysYear%>") ;
	
		<%
		String beforeMonth = DateUtil.addMonth(Integer.parseInt(curSysYear), Integer.parseInt(curSysMon), Integer.parseInt(curSysDay), -1);
		String afterMonth = DateUtil.addMonth(Integer.parseInt(curSysYear), Integer.parseInt(curSysMon), Integer.parseInt(curSysDay), 1);
		%>
		
		$("#searchSYmd").datepicker2({startdate:"searchEYmd"});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd"});
		$("#searchSYmd").val(<%=beforeMonth%>);
		$("#searchEYmd").val("<%=afterMonth%>");
		$("#searchSYmd").mask("1111-11-11");		
		$("#searchEYmd").mask("1111-11-11");
		
		$("#searchWorkYy,#searchSbNm,#searchSYmd,#searchEYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
			}
		});
	});
	
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",				Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"삭제",				Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },			
			{Header:"상태",				Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"대상연월",				Type:"Date",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"pay_ym",			KeyField:1,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"급여계산코드",			Type:"Text",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pay_action_cd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"급여계산명",			Type:"Popup",			Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pay_action_nm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"지급일자",				Type:"Date",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"payment_ymd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"구분",				Type:"Combo",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pay_cd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",				Type:"Text",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Popup",     		Hidden:0,  	Width:70,   Align:"Center", ColMerge:1,	SaveName:"name",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:160 },
			{Header:"조직",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"순번",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"연금취급사코드",			Type:"Combo",			Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"bank_cd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"연금계좌\n취급자",		Type:"Text",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"bank_nm",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사업자등록번호",			Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bank_enter_no",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },			
			{Header:"계좌번호",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bank_account",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"입금일",				Type:"Date",			Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"defer_ymd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"계좌입금금액",			Type:"Int",     		Hidden:0,  	Width:80,	Align:"Right",  ColMerge:0, SaveName:"cur_defer_mon",   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"퇴직금신고\n제외여부",		Type:"CheckBox",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"etc_010",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"1", FalseValue:"0" }
        ]; IBS_InitSheet(sheet1, initdata);
        sheet1.SetEditable("<%=editable%>");
        sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//급여코드
	    var retPayCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getCpnRetPayCdList") , "");
		$("#searchRetPayCd").html(retPayCdList[2]);
		sheet1.SetColProperty("pay_cd",    {ComboText:"|"+retPayCdList[0], ComboCode:"|"+retPayCdList[1]} );

	    // 금웅사
	    var bankCdList  = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+$("#searchSYmd").val(),"H30001"), "");
	    sheet1.SetColProperty("bank_cd",             {ComboText:"직접입력|"+ bankCdList[0], ComboCode:"DRCT|"+ bankCdList[1]} );
		
        $(window).smartresize(sheetResize); sheetInit();
        
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
			sheet1.DoSearch( "<%=jspPath%>/retPensionSta/retPensionStaRst.jsp?cmd=selectRetPensionStaList", $("#sheetForm").serialize() ); 
			break;
        case "Insert":    
        	var Row = sheet1.DataInsert(0) ;
        	sheet1.SetCellValue(Row, "seq", "2");
        	break;
        case "Copy":        
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "seq", "2");
			sheet1.SelectCell(Row, 2);
        	break;			
		case "Save":
			sheet1.DoSave( "<%=jspPath%>/retPensionSta/retPensionStaRst.jsp?cmd=saveRetPensionSta", $("#sheetForm").serialize() ); 			
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try{
			var v_CellName = sheet1.ColSaveName(Col);
			if( v_CellName == "bank_cd" ) {
				if( Value == "DRCT" ) {
					sheet1.SetCellValue(Row,"bank_nm","");
					sheet1.SetCellEditable(Row,"bank_nm",1);	 				
				}else{												
					var v_bankNm = sheet1.GetCellText(Row,"bank_cd");
					sheet1.SetCellValue(Row,"bank_nm",v_bankNm);
					sheet1.SetCellEditable(Row,"bank_nm",0);
				}
			}
			return;			
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}	

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") alert(Msg);
			var v_bankCd ;
			
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				v_bankCd = sheet1.GetCellValue(r,"bank_cd");
				if( v_bankCd  == "DRCT" ) {					
					sheet1.SetCellEditable(r,"bank_nm",1);	 				
				}else{										
					sheet1.SetCellEditable(r,"bank_nm",0);			
				}				            	            
		     }
			sheetResize();
		} catch (ex) {
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
	
	var gPRow  = "";
	var pGubun = "";
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
			
			if(sheet1.ColSaveName(Col) == "pay_action_nm") {
				openPayActionCdPopup(Row) ;
			}			
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}	
	
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
	
	// 급여일자 조회
	function openPayActionCdPopup(Row){
	    try{

	    	if(!isPopup()) {return;}
	    	gPRow  = Row;
			pGubun = "payActionCdPopup";
			 
		    var args    = new Array();
		    var runType = "('00004')";
		    var rv = openPopup("<%=jspPath%>/common/payActionCdPopup.jsp?authPg=<%=authPg%>&searchRunType="+runType, args, "740","520");
		    /*
	        if(rv!=null){
				sheet1.SetCellValue(Row, "pay_action_cd", 		rv["pay_action_cd"] );
				sheet1.SetCellValue(Row, "pay_action_nm", 		rv["pay_action_nm"] );
				sheet1.SetCellValue(Row, "payment_ymd", 		rv["payment_ymd"] );
				sheet1.SetCellValue(Row, "pay_ym", 	rv["pay_ym"] );
				sheet1.SetCellValue(Row, "pay_cd", 	rv["pay_cd"] );
	        }
		    */
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "payActionCdPopup" ){
			sheet1.SetCellValue(gPRow, "pay_action_cd", rv["pay_action_cd"] );
			sheet1.SetCellValue(gPRow, "pay_action_nm", rv["pay_action_nm"] );
			sheet1.SetCellValue(gPRow, "payment_ymd", 	rv["payment_ymd"] );
			sheet1.SetCellValue(gPRow, "pay_ym", 		rv["pay_ym"] );
			sheet1.SetCellValue(gPRow, "pay_cd", 		rv["pay_cd"] );
        	
		} else if ( pGubun == "employeePopup" ){
			//사원조회
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
	<input id="searchAdjustType" name ="searchAdjustType" type="hidden" value="1"/>
	<input id="searchPayActionCd" name="searchPayActionCd" type="hidden" value=""/>
    <div class="sheet_search outer">
        <div>
        <table>
			<tr>
			    <td>
			    	<span>대상연월</span>
						<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text w40"/>
						<span>년</span>
						<select id="searchWorkMm" name ="searchWorkMm" onChange="" class="box">
							<option value=""></option>
							<option value="01">01</option>
							<option value="02">02</option>
							<option value="03">03</option>
							<option value="04">04</option>
							<option value="05">05</option>
							<option value="06">06</option>
							<option value="07">07</option>
							<option value="08">08</option>
							<option value="09">09</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
						</select>
						<span>월</span>					
				</td>
				<td>
			    	<span>지급일자</span>
					<input id="searchSYmd" name ="searchSYmd" type="text" class="text"/>
					~
					<input id="searchEYmd" name ="searchEYmd" type="text" class="text"/>
				</td>
				<td>
					<span>사번/성명</span>
					<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
				</td>
				<td>
					<span>구분</span>
					<select id="searchRetPayCd" name ="searchRetPayCd" onChange="" class="box"></select>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="button">조회</a>
				</td>
			</tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">연금계좌 입금내역</li>
            <li class="btn">
                <a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
                <a href="javascript:doAction1('Copy')" 		    class="basic authA">복사</a>
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