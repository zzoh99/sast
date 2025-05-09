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
		var orgCd  		= arg["orgCd"];
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0, FrozenColRight:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='knowledge_v' mdef='필요지식|필요지식'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",		ColMerge:0,	SaveName:"knowledge",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:400 },
			{Header:"<sht:txt mid='docInfo_v' mdef='문서화된 정보|문서화된 정보'/>",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",		ColMerge:0,	SaveName:"docInfo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='storageType_v' mdef='저장매체|저장매체'/>",			Type:"Combo",     	Hidden:0,   Width:50,    Align:"Center",    ColMerge:0, SaveName:"storageType",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='accessAuthAll_v' mdef='접근권한|전체'/>",			Type:"Text",		Hidden:0,	Width:30,	Align:"Center",		ColMerge:0,	SaveName:"accessAuthAll",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='accessAuthComp_v' mdef='접근권한|전사'/>",			Type:"Text",		Hidden:0,	Width:30,	Align:"Center",		ColMerge:0,	SaveName:"accessAuthComp",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='accessAuthHq_v' mdef='접근권한|본부'/>",				Type:"Text",		Hidden:0,	Width:30,	Align:"Center",		ColMerge:0,	SaveName:"accessAuthHq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='accessAuthTeam_v' mdef='접근권한|팀'/>",				Type:"Text",		Hidden:0,	Width:30,	Align:"Center",		ColMerge:0,	SaveName:"accessAuthTeam",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='accessAuthRelate_v' mdef='접근권한|직무유관'/>",		Type:"Text",		Hidden:0,	Width:30,	Align:"Center",		ColMerge:0,	SaveName:"accessAuthRelate",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='accessAuthCharge_v' mdef='접근권한|직무담당'/>",		Type:"Text",		Hidden:0,	Width:30,	Align:"Center",		ColMerge:0,	SaveName:"accessAuthCharge",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='infoPlan_v' mdef='최신정보\n확보계획|최신정보\n확보계획'/>",Type:"Text",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"infoPlan",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"seq"}
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//sheet1.FocusAfterProcess = false;
		$(window).smartresize(sheetResize); sheetInit();
		
		var storageTypeCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90014"), "");
		sheet1.SetColProperty("storageType", {ComboText:"|"+storageTypeCd[0], ComboCode:"|"+storageTypeCd[1]} );
		
		$("#jobCd").val(jobCd);
		$("#orgCd").val(orgCd);
		
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
		    sheet1.DoSearch( "${ctx}/JobKnowledgePopup.do?cmd=getJobKnowledgePopupList", $("#sheet1Form").serialize());
            break;
        case "Save":
			if (!dupChk(sheet1, "knowledge", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/JobKnowledgePopup.do?cmd=saveJobKnowledgePopup", $("#sheet1Form").serialize());
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
		<input type="hidden" id="orgCd" name="orgCd">
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
