<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>주소변경 관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var templeteTitle1 = "";

	$(function() {	

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
	        {Header:"사번",		Type:"Text",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"성명",		Type:"Text",      	Hidden:0,  Width:40,    Align:"Center", ColMerge:1,   SaveName:"name",			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"재직상태",	Type:"Text",      	Hidden:0,  Width:40,    Align:"Center", ColMerge:1,   SaveName:"status_nm",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"주소구분",	Type:"Combo",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"add_type",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"우편번호",	Type:"Text",      	Hidden:0,  Width:40,    Align:"Center", ColMerge:1,   SaveName:"zip",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"주소",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Left", 	ColMerge:1,   SaveName:"addr1",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"선택",		Type:"DummyCheck",      	Hidden:0,  Width:20,    Align:"Center",	ColMerge:1,   SaveName:"check",			KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:6 , TrueValue:"Y", FalseValue:"N" },
	        {Header:"변경상태",	Type:"Combo",      	Hidden:0,  Width:50,    Align:"Center",	ColMerge:1,   SaveName:"chg_status",	KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:20 },
	        {Header:"변경\n결과",			Type:"Text",		Hidden:0,  Width:50,    Align:"Center",  ColMerge:1,   SaveName:"mod_result",				KeyField:0,   CalcLogic:"",   Format:"", PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"변경\n우편번호",		Type:"PopupEdit",	Hidden:0,  Width:50,    Align:"Center",  ColMerge:1,   SaveName:"mod_zip",				KeyField:0,   CalcLogic:"",   Format:"", PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:7 },
	        {Header:"변경\n주소",			Type:"Text",		Hidden:0,  Width:100,   Align:"Left",  ColMerge:1,   SaveName:"mod_addr1",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:160 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
	        {Header:"사번",		Type:"Text",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"주소구분",	Type:"Combo",      	Hidden:0,  Width:50,    Align:"Center", ColMerge:1,   SaveName:"add_type",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:160 },
	        {Header:"변경상태",	Type:"Combo",      	Hidden:0,  Width:50,    Align:"Center",	ColMerge:1,   SaveName:"chg_status",	KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:20 }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(true);sheet2.SetVisible(false);sheet2.SetCountPosition(4);
		
        var addTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "H20185"), "전체" );
		
		sheet1.SetColProperty("add_type", 	{ComboText:"|"+addTypeList[0], ComboCode:"|"+addTypeList[1]});
		sheet2.SetColProperty("add_type", 	{ComboText:"|"+addTypeList[0], ComboCode:"|"+addTypeList[1]});
		sheet1.SetColProperty("chg_status", 	{ComboText:"|변경요청|변경완료|확인완료", ComboCode:"|1|5|9"});
		sheet2.SetColProperty("chg_status", 	{ComboText:"|변경요청|변경완료|확인완료", ComboCode:"|1|5|9"});
		
		$("#add_type").html(addTypeList[2]);
		$("#chg_status").html("<option value=''>전체</option> <option value='5'>변경완료</option> <option value='1'>변경요청</option> <option value='9'>확인완료</option>");
		$("#chg_status").val('1'); //전체조회시 데이터량이 너무 많을 수 있음
		
        $(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";
		
		templeteTitle1 += "※업로드시 반영되지 않는 부분입니다. 삭제하시면 안됩니다.\n\n";

		codeCdNm = "";
		codeNm = addTypeList[0].split("|"); codeCd = addTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "주소구분 : " + codeCdNm;
		
		templeteTitle1 += "\n변경상태 : " + "1-변경요청\n5-변경완료\n9-확인완료";

	});
	
	$(function() {	

		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search");
			}
		});
		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 
			var param = "cmd=getAddressList&"+$("#srchFrm").serialize();
			sheet1.DoSearch( "<%=jspPath%>/chgAddress/chgAddressRst.jsp", param );
			break;
		case "Save": 		
			// 중복체크
			if (!dupChk(sheet1, "sabun|add_type", true, true)) {break;}
			sheet1.DoSave( "<%=jspPath%>/chgAddress/chgAddressRst.jsp","cmd=saveAddressChgStatus"); 
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}
	
	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Save":
			var tmp = sheet2.GetSaveString(1);
			ajaxCall("<%=jspPath%>/chgAddress/chgAddressRst.jsp?cmd=saveUploadAddressChgStatus"
    				,tmp
   	    			,true
   	    			,function(){
   	    			}
   	    			,function(){
						doAction1('Search');
   	    			}
   	    	);
			break;
		case "Down2Template":
			var param  = {DownCols:"2|3|4",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
						,TitleText:templeteTitle1,UserMerge :"0,0,1,3"};
			sheet2.Down2Excel(param); 
			break;
        case "LoadExcel":  
		    var params = {Mode:"HeaderMatch", WorkSheetNo:1, StartRow:"2"}; 
		    sheet2.LoadExcel(params);
		    break;
		}
	}

	// 조회 후 에러 메시지
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
				doAction1('Search'); 
			}
		} catch(ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "mod_zip") {
				openChgAddressPopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	// 업로드 완료 후
	function sheet2_OnLoadExcel(){
		doAction2('Save');
	}
	
	var gPRow  = "";
	var pGubun = "";
	
	// 주소변경팝업
	function openChgAddressPopup(Row) {
		
 		var w 		= 900;
		var h 		= 600;
		var url 	= "<%=jspPath%>/chgAddress/chgAddressPopup.jsp";
		var args 	= new Array();
		args["sabun"]		= sheet1.GetCellValue(Row,"sabun");
		args["add_type"]	= sheet1.GetCellValue(Row,"add_type");
		args["authPg"]		= "R"; //관리
		
		if(!isPopup()) {return;}
		gPRow  = Row;
		pGubun = "chgAddressPopup";
		openPopup(url,args,w,h);
		
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "chgAddressPopup" ){
			//주소변경팝업
			sheet1.SetCellValue(gPRow, "mod_result",	"선택완료" );
			sheet1.SetCellValue(gPRow, "mod_zip", 		rv["zip"] );
			sheet1.SetCellValue(gPRow, "mod_addr1", 	rv["addr1"] );
		}
	}
	
	function convertSelection(){
		var obj = new Object();
		var cnt = 0;
		var totCnt = 0;

		for(i	= 1; i<=sheet1.LastRow(); i++)	{
			if(sheet1.GetCellValue(i,"check") == "Y"){
				//데이터변환 작업
				var zip = sheet1.GetCellValue(i,"zip");
				var addr1 = sheet1.GetCellValue(i,"addr1");
				var param = "zip="+zip+"&addr1="+encodeURIComponent(addr1)+"&selectRow="+i;

				$.ajax({
						url 		: "<%=jspPath%>/chgAddress/chgAddressRst.jsp?cmd=getSelectAddressMapping",
						type 		: "post",
						dataType 	: "json",
						async 		: "false",
						data 		: param,
						beforeSend	: function(request) {
							if(totCnt==0) sheet1.ShowProcessDlg();
							totCnt++;
							sheet1.SetCellValue(i,"mod_result","변경중");
						},
						success : function(data) {
							obj = data;
							cnt++;
							sheet1.SetSelectRow(obj.selectRow);
							if(Object.keys(obj.Data).length > 0) {
					    		sheet1.SetCellValue(obj.selectRow,"mod_zip",obj.Data.zip);
					    		sheet1.SetCellValue(obj.selectRow,"mod_addr1",obj.Data.addr1);
					    		var result_cnt = obj.Data.cnt;
					    		if(result_cnt>1){
					    			result_message = "확인필요"+"("+result_cnt+")";
					    		}else{
					    			result_message = "변환완료";
					    		}

					    		sheet1.SetCellValue(obj.selectRow,"mod_result",result_message);
					    	}else{
					    		sheet1.SetCellValue(obj.selectRow,"mod_zip","");
					    		sheet1.SetCellValue(obj.selectRow,"mod_addr1","");
					    		sheet1.SetCellValue(obj.selectRow,"mod_result","변환실패");
					    	}

							sheet1.SetCellValue(obj.selectRow,"check","N");

							if(cnt==totCnt) sheet1.HideProcessDlg();
						},
						error : function(jqXHR, ajaxSettings, thrownError) {
							ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
						}
					});
			}
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
        <input type="hidden" id="searchStatusCd" name="searchStatusCd" value="RA"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>주소구분</span>
							<select id="add_type" name ="add_type" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>
						<td>
							<span>변경상태</span>
							<select id="chg_status" name ="chg_status" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>
						<td>
							<span>사번/성명</span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
						</td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('RA');" checked="checked" type="radio"  class="radio"/> 퇴직자 제외</td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('A');" type="radio" class="radio"/> 퇴직자 포함</td>
						<td> 
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> 
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
    <div class="outer">
        <div class="sheet_title">
        <ul>
			<li id="txt" class="txt">주소변경관리</li>
			<li class="btn">
				<a href="javascript:doAction2('Down2Template')" class="basic authA">양식다운로드</a>
				<a href="javascript:doAction2('LoadExcel')" 	class="basic authA">업로드</a>
				<a href="javascript:convertSelection();" 		class="basic authA">선택일괄변경</a>
				<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authA">다운로드</a>
			</li>
        </ul>
        </div>
    </div>
	
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
	<script type="text/javascript">createIBSheet("sheet2", "0%", "0%"); </script>
</div>
</body>
</html>