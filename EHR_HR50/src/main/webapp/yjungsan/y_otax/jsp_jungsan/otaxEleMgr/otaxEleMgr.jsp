<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>재계산 대상자 관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		$("#searchYmd").datepicker2();		
		$("#searchYmd,#searchEleNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
			}
		});
	});
	
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
    	initdata.Cols = [
					{Header:"No",					Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			    	{Header:"삭제",				Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },			
			    	{Header:"상태",				Type:"<%=sSttTy%>",	Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			       	{Header:"원천세항목코드",Type:"Text",	Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"tax_ele_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		       		{Header:"시작일자",			Type:"Date",	Hidden:0,					Width:85,			Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		       		{Header:"순서",				Type:"Int",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"원천세항목명",	Type:"Text",	Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"tax_ele_nm",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"항목분류",		Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"tax_ele_type",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"대분류",			Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"income_nm1",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"중분류",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"income_nm2",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"소분류",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"income_nm3",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"항목명",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"income_nm4",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"인원여부",		Type:"CheckBox",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"inwon_yn",	TrueValue:"Y", FalseValue:"N",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"총지급액여부",	Type:"CheckBox",	Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"payment_mon_yn",	TrueValue:"Y", FalseValue:"N",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"징수세액\n소득세등여부",	Type:"CheckBox",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"paye_itax_yn",	TrueValue:"Y", FalseValue:"N",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"징수세액\n농특세여부",		Type:"CheckBox",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"paye_atax_yn",	TrueValue:"Y", FalseValue:"N",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"징수세액\n가산세등여부",	Type:"CheckBox",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"paye_addtax_yn",	TrueValue:"Y", FalseValue:"N",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"당월조정\n환급세액여부",	Type:"CheckBox",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"refund_yn",	TrueValue:"Y", FalseValue:"N",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"납부세액\n소득세(가산세포함)여부",	Type:"CheckBox",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"pay_itax_yn",	TrueValue:"Y", FalseValue:"N",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"납부세액\n농특세여부",	Type:"CheckBox",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"pay_atax_yn",	TrueValue:"Y", FalseValue:"N",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"본표합계대상\n원천세항목코드",				Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"m_tax_ele_cd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		       		{Header:"부표합계대상\n원천세항목코드",				Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"att_tax_ele_cd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
       	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);
		
       	sheet1.SetColProperty("tax_ele_type", 	{ComboText:"|본표|부표", ComboCode:"|1|2"}	);
       	
		$(window).smartresize(sheetResize);
		sheetInit();
		
		doAction1("Search");		
	});
	
	

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/otaxEleMgr/otaxEleMgrRst.jsp?cmd=selectOtaxEleMgrList", $("#sheetForm").serialize() ); 
			break;
        case "Insert":    
        	sheet1.DataInsert(0) ;
        	break;
        case "Copy":        
        	sheet1.DataCopy();
        	break;			
		case "Save":
			sheet1.DoSave( "<%=jspPath%>/otaxEleMgr/otaxEleMgrRst.jsp?cmd=saveOtaxEleMgr", $("#sheetForm").serialize() ); 			
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
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
						<td> <span>기준일자</span> <input id="searchYmd" name ="searchYmd" type="text" class="text" value="<%=curSysYyyyMMddHyphen%>" style="ime-mode:active"/> </td>
						<td> <span>항목명</span> <input type="text" id="searchEleNm" name="searchEleNm" class="text" value="" style="ime-mode:active" /> </td>
						<td> <a href="javascript:doAction1('Search')"	class="button authR">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">원천세항목관리</li>
            <li class="btn">
				<a href="javascript:doAction1('Insert')" 			class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>            
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