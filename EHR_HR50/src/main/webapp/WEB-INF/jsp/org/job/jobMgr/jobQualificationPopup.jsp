<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='schLic' mdef='필요자격'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();

	$(function() {
		var jobCd  		= arg["jobCd"];
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='licenseCd' mdef='자격증코드'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"licenseCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licenseNm' mdef='자격증명'/>", 	Type:"Popup",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"licenseNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='licenseGrade_v' mdef='등급'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"licenseGrade",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='officeCd_v' mdef='발급기관'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"officeCd",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

// 		var grpCds = "H20161,H20175'";
// 		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
// 		sheet1.SetColProperty("licenseGrade",  	{ComboText:"|"+codeLists["H20161"][0], ComboCode:"|"+codeLists["H20161"][1]} ); //자격등급(H20161) 
// 		sheet1.SetColProperty("officeCd",  		{ComboText:"|"+codeLists["H20175"][0], ComboCode:"|"+codeLists["H20175"][1]} ); //발행기관(H20175)
		
		//sheet1.FocusAfterProcess = false;
		$(window).smartresize(sheetResize); sheetInit();
		$("#jobCd").val(jobCd);
		
		doAction1("Search");
	});

	$(function() {

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
		    sheet1.DoSearch( "${ctx}/JobQualificationPopup.do?cmd=getJobQualificationPopupList", $("#sheet1Form").serialize());
            break;
        case "Save":
			if (!dupChk(sheet1, "licenseNm", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/JobQualificationPopup.do?cmd=saveJobQualificationPopup", $("#sheet1Form").serialize());
			break;            
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"code","");
			break;    
		}
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
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
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "licenseNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"licenseCd","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "licenseNm") {

				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "licensePopup";

				var win = openPopup("/HrmLicensePopup.do?cmd=viewHrmLicensePopup&authPg=${authPg}", "", "600","620");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "licensePopup"){
        	sheet1.SetCellValue(gPRow, "licenseCd", rv["code"]);
        	sheet1.SetCellValue(gPRow, "licenseNm", rv["codeNm"]);
        } else if(pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
        }
	}

</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
    <form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="jobCd" name="jobCd">
		<input type="hidden" id="type" name="type" value="1">
	</form>
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='schLic' mdef='필요자격'/></li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	                <div class="inner">
	                    <div class="sheet_title">
	                    <ul>
	                        <li id="txt" class="txt"><tit:txt mid='112832' mdef='필요자격'/></li>
                 	        <li class="btn _thrm115">
	                        <c:if test="${authPg == 'A'}">
								<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='110700' mdef="입력"/>
<%-- 								<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='110696' mdef="복사"/> --%>
								<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
							</c:if>
							</li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	                </td>
	            </tr>
	        </table>
	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
