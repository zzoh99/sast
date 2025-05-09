<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>조건검색코드항목관리</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:6, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		    //수정시 줄좀 맞춥시다..
			{Header:"No|No",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태|상태",			Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			
			{Header:"업무코드|업무코드",	Type:"Text",		Hidden:0,  Width:120,  Align:"Center",  ColMerge:0,   SaveName:"bizCd",             KeyField:1,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"업무명|업무명",		Type:"Text",		Hidden:0,  Width:180,  Align:"Center",  ColMerge:0,   SaveName:"bizNm",             KeyField:1,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"업무설명|업무설명",	Type:"Text",		Hidden:0,  Width:230,  Align:"Left",    ColMerge:0,   SaveName:"bizCdDesc",         KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			
			{Header:"메일|사용여부",		Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"useMailYn",         Keyfield:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100,   TrueValue:"Y",   FalseValue:"N" },
			{Header:"메일|등록여부",		Type:"Combo",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"regMailYn",         Keyfield:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"메일|세부내역",		Type:"Image",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"detailMail",        Cursor:"Pointer"},
			
			{Header:"SMS|사용여부",		Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"useSmsYn",          Keyfield:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100,   TrueValue:"Y",   FalseValue:"N" },
			{Header:"SMS|등록여부",		Type:"Combo",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"regSmsYn",          Keyfield:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"SMS|세부내역",		Type:"Image",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"detailSms",         Cursor:"Pointer"},
			
			{Header:"LMS|사용여부",		Type:"CheckBox",	Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"useLmsYn",          Keyfield:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100,   TrueValue:"Y",   FalseValue:"N" },
			{Header:"LMS|등록여부",		Type:"Combo",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"regLmsYn",          Keyfield:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"LMS|세부내역",		Type:"Image",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"detailLms",         Cursor:"Pointer"},
			
			{Header:"메신저|사용여부",		Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"useMessengerYn",    Keyfield:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100,   TrueValue:"Y",   FalseValue:"N" },
			{Header:"메신저|등록여부",		Type:"Combo",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"regMessengerYn",    Keyfield:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"메신저|세부내역",		Type:"Image",		Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"detailMessenger",   Cursor:"Pointer"},
			
			{Header:"전사적용|전사적용",	Type:"Html",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"btnDeploy",         KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }

		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
		
		// Set Combo
		sheet1.SetColProperty("regMailYn",      {ComboText:"미등록|등록", ComboCode:"N|Y"} );
		sheet1.SetColProperty("regSmsYn",       {ComboText:"미등록|등록", ComboCode:"N|Y"} );
		sheet1.SetColProperty("regLmsYn",       {ComboText:"미등록|등록", ComboCode:"N|Y"} );
		sheet1.SetColProperty("regMessengerYn", {ComboText:"미등록|등록", ComboCode:"N|Y"} );
		
		// Set Icon
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(3,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(4,"${ctx}/common/images/icon/icon_popup.png");

		$("#bizCd, #bizNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		$("#srchUseYn").bind("change",function(){
			doAction("Search");
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});
	
	// Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/NoticeTemplateMgr.do?cmd=getNoticeTemplateBizCdList", $("#sheet1Form").serialize());
			break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
				if(!dupChk(sheet1,"bizCd", true, true)){break;}
			}
			
			var isContinues = true;
			if(sheet1.FindStatusRow("D") != ""){
				isContinues = false;
				if(confirm("저장 대상 데이터중 삭제 대상건이 존재합니다.\n\n삭제 대상건을 포함하여 진행하시는 경우\n삭제 대상 업무코드에 해당하는 전체 회사의 서식 데이터가 삭제됩니다.\n\n삭제건을 포함하여 진행하시셌습니까?")) {
					isContinues = true;
				}
			}
			
			if(isContinues) {
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave("${ctx}/NoticeTemplateMgr.do?cmd=saveNoticeTemplateMgr", $("#sheet1Form").serialize() );
			}
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, 2);
			break;
		case "Copy":
			sheet1.DataCopy();break;
		case "Down2Excel":
			sheet1.Down2Excel();
			break;
		}
	}
	
	// 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			
			for(var r = sheet1.HeaderRows(); r < sheet1.LastRow() + sheet1.HeaderRows(); r++){
				if("${authPg}" == 'A'){
					
					// 서식 내용이 등록이 되어 있는 경우 배포 버튼 출력
					if( sheet1.GetCellValue(r, "regMailYn") == "Y"
							|| sheet1.GetCellValue(r, "regSmsYn") == "Y"
							|| sheet1.GetCellValue(r, "regLmsYn") == "Y"
							|| sheet1.GetCellValue(r, "regMessengerYn") == "Y" ) {
						
						sheet1.SetCellValue(r, "btnDeploy", '<btn:a css="basic" mid='deploy' mdef="적용"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
						
					}
				}
				
				// 서식 내용이 등록이 되어 있는 경우 사용여부 체크 박스 활성화함.
				if( sheet1.GetCellValue(r, "regMailYn")      == "N") sheet1.SetCellEditable(r, "useMailYn"     , 0);
				if( sheet1.GetCellValue(r, "regSmsYn")       == "N") sheet1.SetCellEditable(r, "useSmsYn"      , 0);
				if( sheet1.GetCellValue(r, "regLmsYn")       == "N") sheet1.SetCellEditable(r, "useLmsYn"      , 0);
				if( sheet1.GetCellValue(r, "regMessengerYn") == "N") sheet1.SetCellEditable(r, "useMessengerYn", 0);
				
			}
		
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}

	// 클릭시 이벤트
	function sheet1_OnClick(Row, Col, Value) {
		try{
			var status = sheet1.GetCellValue(Row,"sStatus");
			
			// 메일 서색 내용 편집
			if(status != "I" && sheet1.ColSaveName(Col)=="detailMail") {
				templateEditPopup(Row, "MAIL");
			}

			// SMS 서식 내용 편집
			if(status != "I" && sheet1.ColSaveName(Col)=="detailSms") {
				templateEditPopup(Row, "SMS");
			}

			// LMS 서식 내용 편집
			if(status != "I" && sheet1.ColSaveName(Col)=="detailLms") {
				templateEditPopup(Row, "LMS");
			}

			// 메신저 서식 내용 편집
			if(status != "I" && sheet1.ColSaveName(Col)=="detailMessenger") {
				templateEditPopup(Row, "MESSENGER");
			}
			
			// 전사 적용
			if(sheet1.ColSaveName(Col) == "btnDeploy"){
				// 서식 내용이 등록이 되어 있는 경우 배포 버튼 출력
				if( sheet1.GetCellValue(Row, "regMailYn") == "Y"
						|| sheet1.GetCellValue(Row, "regSmsYn") == "Y"
						|| sheet1.GetCellValue(Row, "regLmsYn") == "Y"
						|| sheet1.GetCellValue(Row, "regMessengerYn") == "Y" ) {
					
					deployAll(Row);
					
				}

			}

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	// 체크박스 체크전 체크 이벤트
	function sheet1_OnBeforeCheck(Row, Col) {
		try{

			if(sheet1.ColSaveName(Col)=="useSmsYn") {
				// LMS가 사용하고 있지 않은 경우 진행.
				if(sheet1.GetCellValue(Row, "useSmsYn") == "N" && sheet1.GetCellValue(Row, "useLmsYn") == "Y") {
					sheet1.SetCellValue(Row, "useLmsYn", "N");
				}
			}

			if(sheet1.ColSaveName(Col)=="useLmsYn") {
				// SMS가 사용하고 있지 않은 경우 진행.
				if(sheet1.GetCellValue(Row, "useLmsYn") == "N" && sheet1.GetCellValue(Row, "useSmsYn") == "Y") {
					sheet1.SetCellValue(Row, "useSmsYn", "N");
				}
			}

		}catch(ex){alert("OnBeforeCheck Event Error : " + ex);}
	}

	
	// 서석 편집 팝업 실행
	function templateEditPopup(Row, noticeTypeCd){
		if(!isPopup()) {return;}
		var url 	= "${ctx}/NoticeTemplateMgr.do?cmd=viewNoticeTemplateMgrEditLayer";
		var p = { authPg: "${authPg}",
				  bizCd: sheet1.GetCellValue(Row, "bizCd"),
				  bizNm: sheet1.GetCellValue(Row, "bizNm"),
				  noticeTypeCd: noticeTypeCd };
		var width = 900;
		var height	= 520;
		var title = '알림서식편집';
		
		// set height
		if( noticeTypeCd == "MAIL" ) {
			width = 1050;
			height = 740;
		} else if( noticeTypeCd == "SMS" ) {
			height	= 480;
		} else if( noticeTypeCd == "LMS" ) {
			height	= 430;
		} else if( noticeTypeCd == "MESSENGER" ) {
			height	= 430;
		}

		//openPopup(url,args,900,height);
		var layerModal = new window.top.document.LayerModal({
			  id : 'noticeTemplateMgrEditLayer', 
			  url : url,
			  parameters: p,
			  width : width, 
			  height : height,
			  title : title,
			  trigger: [
				  {
					  name: 'noticeTemplateMgrEditLayerTrigger',
					  callback: function(rv) {
						  if (rv.Code == '1') doAction("Search");
					  }
				  }
			  ]
		});
		layerModal.show();
	}
	
	// 서식 전사 배포
	function deployAll(Row) {
		if(confirm("선택하신 업무코드의 서식 데이터를 전사로 배포하시겠습니까?\n실행하시면 전체회사 내 업무코드에 해당하는 서식의 내용이 변경됩니다.\n\n배포를 진행하시겠습니까?")) {
			var result = ajaxCall("${ctx}/NoticeTemplateMgr.do?cmd=saveNoticeTemplateDeployAll", "bizCd=" + sheet1.GetCellValue(Row, "bizCd"), false);
			if( result != null && result != undefined ) {
				alert(result.Result.Message);
			}
		}
	}

	// 반환값 처리
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(rv["pGubun"] == "templateEditPop") {
			if( rv["Code"] == "1" ) {
				doAction("Search");
			}
		}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>업무코드</th>
							<td>
								<input id="bizCd" name ="bizCd" type="text" class="text"/>
							</td>
							<th>업무명</th>
							<td>
								<input id="bizNm" name ="bizNm" type="text" class="text"/>
							</td>
							<th>사용여부</th>
							<td>
								<select id="srchUseYn" name="srchUseYn" >
									<option value="" >전체 </option>
									<option value="Y">사용</option>
									<option value="N">사용안함</option>
								</select>
							</td>
							<td>
								<a href="javascript:doAction('Search')" id="btnSearch" class="btn dark">조회</a>
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
								<li id="txt" class="txt">알림서식관리</li>
								<li class="btn">
									<a href="javascript:doAction('Down2Excel')" class="btn outline-gray authR">다운로드</a>
									<a href="javascript:doAction('Insert')" class="btn outline-gray authA">입력</a>
									<a href="javascript:doAction('Copy')" class="btn outline-gray authA">복사</a>
									<a href="javascript:doAction('Save')" class="btn filled authA">저장</a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
				</td>
			</tr>
		</table>
</div>
</body>
</html>



