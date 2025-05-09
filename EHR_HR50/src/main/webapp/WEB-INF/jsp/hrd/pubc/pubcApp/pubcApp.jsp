<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var fileSeqArr = []; // 행 삭제 후 첨부파일도 삭제 하기 위한 배열
	
	$(function() {
		// sheet1 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"삭제",			Type:"Html",		Hidden:0,					Width:45,           Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },
			
   			{Header:"세부\n내역",		Type:"Image",		Hidden:0, 	Width:45,	Align:"Center", 	ColMerge:0,		SaveName:"detail",			KeyField:0,	Format:"",			Edit:0 },
  			{Header:"신청일자",    	Type:"Date",		Hidden:0,	Width:70,	Align:"Center",		ColMerge:0,		SaveName:"applYmd",			KeyField:0,	CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"결재상태",    	Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",		ColMerge:0,		SaveName:"applStatusCd",	KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			
  			{Header:"공모구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",		ColMerge:0,		SaveName:"pubcDivCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
  			{Header:"공모명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",		ColMerge:0,		SaveName:"pubcNm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
  			{Header:"공모상태",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",		ColMerge:0,		SaveName:"pubcStatCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
  			{Header:"선정여부",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",		ColMerge:0,		SaveName:"choiceYn",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
  			{Header:"선정사유",		Type:"Text",		Hidden:0,	Width:90,	Align:"Left",		ColMerge:0,		SaveName:"choiceRsn",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
  			
  			{Header:"사번", 			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",		ColMerge:0,		SaveName:"sabun",			KeyField:0,	CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"hideHead",   	Type:"Text",      	Hidden:1,  Width:50,  	Align:"Center",  	ColMerge:0,   	SaveName:"applSabun",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
  			{Header:"hideHead",   	Type:"Text",      	Hidden:1,  Width:100,  	Align:"Left",    	ColMerge:0,   	SaveName:"applSeq",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
  			{Header:"hideHead",   	Type:"Text",      	Hidden:1,  Width:100,  	Align:"Left",    	ColMerge:0,   	SaveName:"applCd",         	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
  			{Header:"hideHead",   	Type:"Text",      	Hidden:1,  Width:100,  	Align:"Left",   	ColMerge:0,   	SaveName:"applInSabun",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
  			{Header:"hideHead",   	Type:"Text",      	Hidden:1,  Width:100,  	Align:"Left",   	ColMerge:0,   	SaveName:"fileSeq",	   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
 		
 		var applStatusCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), ""); 	//	결재상태
 		var pubcDivCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1026"), ""); 	//  공모구분
 		var pubcStatCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1027"), "");	//  공모상태
 		
		sheet1.SetColProperty("applStatusCd", 		{ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );
		sheet1.SetColProperty("pubcDivCd",	 		{ComboText:"|"+pubcDivCd[0], ComboCode:"|"+pubcDivCd[1]} );
		sheet1.SetColProperty("pubcStatCd",	 		{ComboText:"|"+pubcStatCd[0], ComboCode:"|"+pubcStatCd[1]} );

		// sheet2 init
		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"세부\n내역",	Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"공모구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pubcDivCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"공모명",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"신청시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStaYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"신청종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applEndYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"공모상태",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pubcStatCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"공모내용",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcContent",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},

			{Header:"공모부서코드",   Type:"Text",      	Hidden:1,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"pubcOrgCd", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"공모부서",    	Type:"Text",      	Hidden:0,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"pubcOrgNm", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"부서장사번",    	Type:"Text",      	Hidden:1,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"pubcChiefSabun", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"부서장성명",    	Type:"Text",      	Hidden:1,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"pubcChiefName", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

			{Header:"비고",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},

			{Header:"공모ID",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcId",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"직무코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"직무명",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"파일",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"공모신청수",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"cnt",				KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:2000},

		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var pubcDivCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1026"), "");	//공모구분
		var pubcStatCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1027"), "");	//공모상태

		sheet2.SetColProperty("pubcDivCd",		{ComboText:"|"+pubcDivCd[0], ComboCode:"|"+pubcDivCd[1]} );	//공모구분
		sheet2.SetColProperty("pubcStatCd",		{ComboText:"|"+pubcStatCd[0], ComboCode:"|"+pubcStatCd[1]} );	//공모상태
		sheet2.SetDataLinkMouse("detail", 1);

		$(window).smartresize(sheetResize); sheetInit();
		setEmpPage();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/PubcApp.do?cmd=getPubcAppList", $("#sheet1Form").serialize());
			break;
        case "Save":
       		IBS_SaveName(document.sheet1Form,sheet1);
       		for(var i=sheet1.HeaderRows(); i<=sheet1.RowCount(); i++) {
       			var sStatus = sheet1.GetCellValue(i, "sStatus");
       			if(sStatus == "D") {
       				fileSeqArr.push(sheet1.GetCellValue(i, "fileSeq"));
       			}
       		}
        	sheet1.DoSave( "${ctx}/PubcApp.do?cmd=deletePubcApp", $("#sheet1Form").serialize()); break;
        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) {
				for(var i=0; i<fileSeqArr.length; i++) {
					$.filedelete($("#uploadType").val(), {"fileSeq" : fileSeqArr[i]});	
				}
				doAction1("Search"); 			
			} 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( sheet1.ColSaveName(Col) == "detail" && Row >= sheet1.HeaderRows() ) {
				var auth = "R";
				if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
					auth = "A"; //신청 팝업
				} else {
					auth = "R"; //결재팝업
				}
				showApplPopup(auth, sheet1.GetCellValue(Row, "applSeq"), sheet1.GetCellValue(Row, "applInSabun"), sheet1.GetCellValue(Row, "applYmd"), Row);
			} else if(sheet1.ColSaveName(Col) == "btnDel" && Value != "") {
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
			}
			
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}


	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch("${ctx}/PubcApp.do?cmd=getPubcAppList2", $("#sheet1Form").serialize());
				break;
		}
	}

	function sheet2_OnClick(Row, Col, Value){
		try{
			if(Row > 0 && sheet2.ColSaveName(Col) == "detail"){
				pubcMgrPopup(Row) ;
			}
		} catch(ex){alert("OnClick Event Error : " + ex);}
	}

    function setEmpPage() {

    	$("#searchSabun").val($("#searchUserId").val());

    	doAction1("Search");
		doAction2("Search");
    }
    
  //신청 팝업
	function showApplPopup(auth,seq,searchSabun,applYmd, Row) {
		if(!isPopup()) {return;}
		
		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}

		const p = {
			searchApplCd : '200',
			searchApplSeq : seq,
			adminYn : 'N',
			authPg : auth,
			searchSabun : searchSabun,
			searchApplSabun : $("#searchUserId").val(),
			searchApplYmd : applYmd,
			etc01: sheet2.GetCellValue(sheet2.GetSelectRow(), "pubcId") // 사내공모id
		};

		var url = "";
		if(auth == "A") {
			url ="/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer&";
		}
		
		var args = new Array();
		if(Row != "") {
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		} else {
			args["applStatusCd"] = "11";
		}
		
		gPRow = "";
		pGubun = "viewApprovalMgr";
		// openPopup(url,args,1000,750);

		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 950,
			height: 800,
			title: '사내공모신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
	}


	/**
	 * 상세내역 window open event
	 */
	function pubcMgrPopup(Row){
		if(!isPopup()) {return;}

		let w 		= 900;
		let h 		= 800;
		let url 	= "${ctx}/PubcMgr.do?cmd=viewPubcMgrLayer&authPg=R";
		let p = {
			pubcDivCd : sheet2.GetCellValue(Row, "pubcDivCd"),
			pubcId : sheet2.GetCellValue(Row, "pubcId"),
			pubcNm : sheet2.GetCellValue(Row, "pubcNm"),
			applStaYmd : sheet2.GetCellText(Row, "applStaYmd"),
			applEndYmd : sheet2.GetCellText(Row, "applEndYmd"),
			pubcStatCd : sheet2.GetCellValue(Row, "pubcStatCd"),
			pubcContent : sheet2.GetCellValue(Row, "pubcContent"),
			note : sheet2.GetCellValue(Row, "note"),
			jobCd	: sheet2.GetCellValue(Row, "jobCd"),
			jobNm	: sheet2.GetCellValue(Row, "jobNm"),
			fileSeq :	sheet2.GetCellValue(Row, "fileSeq"),
			sStatus :	sheet2.GetCellValue(Row, "sStatus"),
			pubcOrgCd : sheet2.GetCellValue(Row, "pubcOrgCd"),
			pubcOrgNm : sheet2.GetCellValue(Row, "pubcOrgNm"),
			pubcChiefSabun : sheet2.GetCellValue(Row, "pubcChiefSabun"),
			pubcChiefName  : sheet2.GetCellValue(Row, "pubcChiefName")
		};

		gPRow = Row;
		pGubun = "pubcMgrPopup";

		//openPopup(url,args,w,h);
		const layerModal = new window.top.document.LayerModal({
			id : 'pubcMgrLayer'
			, url : url
			, parameters : p
			, width : w
			, height : h
			, title : '<tit:txt mid='112392' mdef='사내공모관리 세부내역'/>'
			, trigger :[
				{
					name : 'pubcMgrLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {

        if(pGubun == "viewApprovalMgr"){
    		doAction1("Search");
        }
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<input type="hidden" id="uploadType"  name="uploadType" value=""/>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">사내공모신청
							</li>
							<li class="btn">
								<a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}', '');" class="button" >신청</a>
								<a href="javascript:doAction2('Search');" class="basic authR">조회</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt2" class="txt">사내공모신청내역 &nbsp;&nbsp;
							</li>
							<li class="btn">
								<a href="javascript:doAction1('Search');" class="basic authR">조회</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic" >다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>