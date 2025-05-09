<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>리조트승인</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getComboList});
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getComboList});
		
		$("#searchFrom, #searchTo, #searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchApplStatusCd, #searchSeasonCd, #searchCompanyCd, #searchStatusCd").on("change", function(e) {
			doAction1("Search");
		});
		
		init_sheet();

		doAction1("Search");
	});
	
	function init_sheet(){ 
		
		var initdata = {};
		//initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:4,FrozenColRight:0};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:8,FrozenCol:4,FrozenColRight:10};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		initdata.Cols = [
			
				{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
				{Header:"삭제|삭제",			Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태|상태",			Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				//기본항목
				{Header:"세부\n내역|세부\n내역",Type:"Image",  	Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail",     	Edit:0 },
				{Header:"신청일|신청일",		Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 		Format:"Ymd", Edit:0},
				{Header:"결재상태|결재상태",	Type:"Combo",  	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applStatusCd",	Edit:0 },
				//신청자정보
				{Header:"신청자|사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
				{Header:"신청자|성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
				{Header:"신청자|부서",			Type:"Text",   	Hidden:0, Width:90, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
				{Header:"신청자|직책",			Type:"Text",   	Hidden:0, Width:50, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
				{Header:"신청자|직위",			Type:"Text",   	Hidden:0, Width:50, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
				{Header:"신청자|직급",			Type:"Text",   	Hidden:0, Width:50, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
				{Header:"신청자|직군",			Type:"Text",   	Hidden:0, Width:50, 	Align:"Center", ColMerge:0,  SaveName:"worktypeNm", 	Edit:0},
				
				//신청내용
				{Header:"신청내용|시즌",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seasonCd",	KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|희망순번",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"hopeCd",		KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|리조트명",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"companyCd",	KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|지점명",			Type:"Text",	Hidden:0,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"resortNm",	KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|객실타입",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"roomType",	KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|체크인",			Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	Edit:0 },
				{Header:"신청내용|체크아웃",		Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	Edit:0 },
				{Header:"신청내용|박수",			Type:"Text",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"days",		KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|대기\n여부",		Type:"CheckBox",Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"waitYn",		KeyField:0,	Format:"",		HeaderCheck:0 ,Edit:0, TrueValue:"Y",	FalseValue:"N" },
				{Header:"신청내용|연락처",			Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"phoneNo",		KeyField:0,	Format:"",		Edit:0 },
				{Header:"신청내용|메일주소",		Type:"Text",	Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"mailId",		KeyField:0,	Format:"",		Edit:0 },
				//예약정보
				{Header:"예약정보|선택",			Type:"DummyCheck",Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sendMailYn",	KeyField:0,	Format:"",		UpdateEdit:1, TrueValue:"Y",	FalseValue:"N" },
				{Header:"예약정보|예약상태",		Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		UpdateEdit:1},
				{Header:"예약정보|예약번호",		Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"rsvNo1",		KeyField:0,	Format:"",		UpdateEdit:1},
				{Header:"예약정보|리조트요금",		Type:"Int",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"resortMon",	KeyField:0,	Format:"",		UpdateEdit:1},
				{Header:"예약정보|회사지원금",		Type:"Int",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"comMon",		KeyField:0,	Format:"",		UpdateEdit:1},
				{Header:"예약정보|개인부담금",		Type:"Int",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"psnalMon",	KeyField:0,	Format:"",		UpdateEdit:1},
				{Header:"예약정보|비고",			Type:"Text",	Hidden:0,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		UpdateEdit:1},
				
				//Hidden
  				{Header:"Hidden",	Hidden:1, SaveName:"planSeq"},
	  			{Header:"Hidden",	Hidden:1, SaveName:"applInSabun"},
  				{Header:"Hidden",	Hidden:1, SaveName:"applSeq"}
	  			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet1.SetDataLinkMouse("detail", 1);
		
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetEditableColorDiff(1); //편집불가 배경색 적용안함
		
		//예약정보 헤더 배경색
		var bcc = "#fdf0f5";
		sheet1.SetCellBackColor(0, "sendMailYn", bcc);  sheet1.SetCellBackColor(1, "sendMailYn", bcc);  
		sheet1.SetCellBackColor(0, "statusCd", bcc);  sheet1.SetCellBackColor(1, "statusCd", bcc);  
		sheet1.SetCellBackColor(0, "rsvNo1", bcc);  sheet1.SetCellBackColor(1, "rsvNo1", bcc);  
		sheet1.SetCellBackColor(0, "resortMon", bcc);  sheet1.SetCellBackColor(1, "resortMon", bcc);  
		sheet1.SetCellBackColor(0, "comMon", bcc);  sheet1.SetCellBackColor(1, "comMon", bcc);  
		sheet1.SetCellBackColor(0, "psnalMon", bcc);  sheet1.SetCellBackColor(1, "psnalMon", bcc); 
		sheet1.SetCellBackColor(0, "note", bcc);  sheet1.SetCellBackColor(1, "note", bcc); 

		//==============================================================================================================================
        var applStatusCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAprStatusList",false).codeList, "전체");
		$("#searchApplStatusCd").html(applStatusCdList[2]);
		//==============================================================================================================================
		getComboList();

		$(window).smartresize(sheetResize); sheetInit();
	}

	function getComboList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		let grpCds = "B49530,B49540,B49520";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;

		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "전체");

		$("#searchSeasonCd").html(codeLists["B49540"][2]);
		$("#searchCompanyCd").html(codeLists["B49530"][2]);
		$("#searchStatusCd").html(codeLists["B49520"][2]);
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();

		let grpCds = "R10010,B49530,B49540,B49520,B49550";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;

		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params,false).codeList, "");
		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} ); //결제
		sheet1.SetColProperty("seasonCd",  		{ComboText:"|일반|"+codeLists["B49540"][0], ComboCode:"||"+codeLists["B49540"][1]} ); //시즌
		sheet1.SetColProperty("companyCd",  	{ComboText:"|"+codeLists["B49530"][0], ComboCode:"|"+codeLists["B49530"][1]} ); //리조트명
		sheet1.SetColProperty("statusCd",  		{ComboText:"|"+codeLists["B49520"][0], ComboCode:"|"+codeLists["B49520"][1]} ); //예약상태
		sheet1.SetColProperty("hopeCd",  		{ComboText:"|"+codeLists["B49550"][0], ComboCode:"|"+codeLists["B49550"][1]} ); //희망순번
	}

	function chkInVal() {

		if ($("#searchFrom").val() == "" && $("#searchTo").val() != "") {
			alert('신청기간 시작일을 입력하세요.');
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() == "") {
			alert('신청기간 종료일을 입력하세요.');
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() != "") {
			if (!checkFromToDate($("#searchFrom"),$("#searchTo"),"신청일자","신청일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			getCommonCodeList();
			var sXml = sheet1.GetSearchData("${ctx}/ResortApr.do?cmd=getResortAprList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			break;
        case "Save":   
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/ResortApr.do?cmd=saveResortApr", $("#sheet1Form").serialize()); 
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
	            sheet1.SetCellEditable(i,"sendMailYn",true);
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
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	showApplPopup(Row);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//세부내역 팝업
	function showApplPopup(Row) {
		
		var args = new Array(5);
		
		args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		
		var applCd = ( sheet1.GetCellValue(Row, "planSeq")+'' ? '109' : '108' );
		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: sheet1.GetCellValue(Row,"applSeq")
			  , adminYn: 'Y'
			  , authPg: "R"
			  , searchSabun: sheet1.GetCellValue(Row,"applInSabun")
			  , searchApplSabun: sheet1.GetCellValue(Row, "sabun")
			  , searchApplYmd: sheet1.GetCellValue(Row,"applYmd") 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '리조트신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						//getReturnValue(rv);
						doAction1('Search');
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}
	
	function sendMail(){
		var frm = document.form;
		var sabuns = "";
		
		var sRow = sheet1.FindCheckedRow("sendMailYn");
		
		if( sRow == "" ){
			alert("대상를 선택 해주세요.");
			return;
		}


		var names = "";
		var mailIds = "";
		var arrRow = sRow.split("|");
		for(var i=0; i<arrRow.length ; i++){
			
			names    += sheet1.GetCellValue(arrRow[i], "name") + "|";
			mailIds  += sheet1.GetCellValue(arrRow[i], "mailId") + "|";
		}
		names    = names.substr(0, names.length - 1);
		mailIds  = mailIds.substr(0, mailIds.length - 1);

		fnSendMailPop(names, mailIds);
		
		return;
	}

	/**
	 * Mail 발송 팝업 창 호출
	 */
	function fnSendMailPop(names, mailIds){
		if(!isPopup()) {return;}

		var args 	= new Array();

		args["saveType"] = "insert";
		args["names"] = names;
		args["mailIds"] = mailIds;
		args["sender"] = "${ssnName}";
		args["bizCd"] = "99999"; 
		args["authPg"] = "${authPg}";

		var url = "${ctx}/SendPopup.do?cmd=viewMailMgrLayer";
		//var rv = openPopup(url, args, "900","700");
        let layerModal = new window.top.document.LayerModal({
            id : 'mailMgrLayer'
          , url : url
          , parameters : args
          , width : 900
          , height : 700
          , title : 'MAIL 발신'
          , trigger :[
              {
                    name : 'mailMgrTrigger'
                  , callback : function(result){
                      
                  }
              }
           ]
        });
        layerModal.show();
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th><tit:txt mid="104102" mdef="신청기간" /></th>
			<td>
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
			</td>
			<th><tit:txt mid="112999" mdef="결재상태" /></th>
			<td>
				<select id="searchApplStatusCd" name="searchApplStatusCd"></select>
			</td>
			<th>시즌</th>
			<td colspan="2">
				<select id="searchSeasonCd" name="searchSeasonCd"></select>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid="104279" mdef="소속" /> </th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
			</td>
			<th><tit:txt mid="104330" mdef="사번/성명" /></th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<th>리조트명</th>
			<td>
				<select id="searchCompanyCd" name="searchCompanyCd"></select>
			</td>
			<th>예약상태</th>
			<td>
				<select id="searchStatusCd" name="searchStatusCd"></select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid="L19080600017" mdef="리조트승인" /></li> 
				<li class="btn"> 
					<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
					<a href="javascript:sendMail();" 					class="btn soft authA">메일발송</a>
					<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid='save' mdef="저장"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
