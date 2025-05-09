<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>합격자정보I/F</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
    		{Header:"No",				Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			
   			{Header:"선택",				Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },

   			{Header:"지원번호",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applKey",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"성명",				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명(한자)",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameCn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명(영문)",			Type:"Text",	Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"nameUs",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성별",				Type:"Combo",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"생년월일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"외국인여부",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"foreignYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국적",				Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"휴대폰",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hpTel",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"개인이메일",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"psnlEmail",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"취미",				Type:"Text",	Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"hobby",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			{Header:"특기",				Type:"Text",	Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
			{Header:"입사경로",			Type:"Text",	Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"applPath",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사추천자",			Type:"Text",	Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"recomName",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
			

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//var lunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00030"), " ");	//음양구분
		var sexType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"), " ");	//성별
		//var bloodCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20460"), " ");	//혈액형
		var nationalCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), " ");	//국적
		//var relCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20350"), "");	//종교
		//var stfType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10060"), " ");	//채용구분
		//var empType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F10003"), " ");	//채용경로

		var sabunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10160"), " ");	//사번생성룰

		//sheet1.SetColProperty("lunType", 		{ComboText:"|"+lunType[0], ComboCode:"|"+lunType[1]} );
		sheet1.SetColProperty("sexType", 		{ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]} );
		//sheet1.SetColProperty("bloodCd", 		{ComboText:"|"+bloodCd[0], ComboCode:"|"+bloodCd[1]} );
		//sheet1.SetColProperty("wedYn", 			{ComboText:"|기혼|미혼", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("foreignYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("nationalCd", 	{ComboText:"|"+nationalCd[0], ComboCode:"|"+nationalCd[1]} );
		//sheet1.SetColProperty("relCd", 			{ComboText:"|"+relCd[0], ComboCode:"|"+relCd[1]} );
		//sheet1.SetColProperty("stfType", 		{ComboText:"|"+stfType[0], ComboCode:"|"+stfType[1]} );
		//sheet1.SetColProperty("empType", 		{ComboText:"|"+empType[0], ComboCode:"|"+empType[1]} );

		sheet1.SetColProperty("sabunType", 		{ComboText:"|"+sabunType[0], ComboCode:"|"+sabunType[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });
	});
	
	
	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			sheet1.DoSearch( "${ctx}/RecBasicInfoReg.do?cmd=getRecBasicInfoRegIfPopList", $("#sheet1Form").serialize() );

			break;
		case "Save":
			/*
			if(!confirm("리스트의 모든 데이터를 저장하시겠습니까?")) {
				return;
			}*/

			for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+1; r++){
				if( sheet1.GetCellValue(r,"sStatus") == "U" ) {
					sheet1.SetCellValue(r, "sStatus", "I");
				}
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveRecBasicInfoRegIfPop", $("#sheet1Form").serialize(),-1,0);

			break;
		case "Insert":
			var row = sheet1.DataInsert();
			break;
		case "UploadData":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));

			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			
			/*
			for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+1; r++){
				if( sheet1.GetCellValue(r,"staffingYn") == "Y" ) {
					sheet1.SetRowEditable(r,false);
				}
			}
			*/
			
 			sheetResize();

		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1('Search');
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function changeReqYyyy(){
		// 채용공고명 코드
		var tstf830Cd = convCode(ajaxCall("${ctx}/StfCommonCode.do?cmd=getStfCommonNSCodeList", "queryId=getRecSeqList&searchReqYyyy="+$("#searchReqYyyy").val(), false).codeList, "");
		$("#searchRecruitTitle").html(tstf830Cd[2]);
	}
	
	function getStfApplList() {		
		var returnValue = new Array();
		for(var i=sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++) {
			if(sheet1.GetCellValue(i, "chk") == "1") {
				//console.log(i);
				returnValue.push(sheet1.GetRowJson(i));
				p.popReturnValue(sheet1.GetRowJson(i));
			}
		}
		
		if(returnValue.length == 0) {
			alert("가져올 데이터가 없습니다.");
			return;
		}
		
		p.self.close();
	}
	
</script>
</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>합격자정보I/F</li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
            	<input id="searchStaffingYn" name="searchStaffingYn" type="hidden" value="Y"/>
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
						<th>지원자명</th>
                        <td>
                        	<input id="searchName" name="searchName" type="text" class="text"/>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
                        </td>
					</tr>
                    </table>
                    </div>
                </div>
	        </form>

	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	                <div class="inner">
	                    <div class="sheet_title">
	                    <ul>
	                        <li id="txt" class="txt">채용합격자정보</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel');" class="basic authA">다운로드</a>
							</li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
	                </td>
	            </tr>
	        </table>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:getStfApplList();" class="gray large">가져오기</a>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>