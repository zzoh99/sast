<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	$(function() {
		$("#searchFromYmd").datepicker2({startdate:"searchFromYmd"});
		$("#searchToYmd").datepicker2({enddate:"searchToYmd"});
		
		$("#searchToYmd, #searchFromYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		 
		var initdata = {};
		initdata.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No' />",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태' />",									Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete' mdef='삭제' />",									Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Edit:0 },
			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",			Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",		Format:"",		Edit:0 },
			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자' />",			Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='applStatusNm' mdef='신청상태' />",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	Format:"",		Edit:0 },
			{Header:"<sht:txt mid='workGubun_V121' mdef='수당구분' />",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workGubun",		Format:"",		Edit:0 },
			{Header:"<sht:txt mid='ymdV5' mdef='근무일자' />",				Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='morningSHm_V121' mdef='아침시작시간\n(야근수당)' />",Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"morningSHm",			Format:"##:##",	Edit:0 },
			{Header:"<sht:txt mid='reqSHm_V121' mdef='근무시작시간' />",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"reqSHm",			Format:"##:##",	Edit:0 },
			{Header:"<sht:txt mid='reqEHm_V121' mdef='근무종료시간' />",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"reqEHm",			Format:"##:##",	Edit:0 },
			{Header:"<sht:txt mid='workHour_V121' mdef='총 시간\n(특근수당)' />",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workHour",			Format:"##:##",	Edit:0 },
			{Header:"<sht:txt mid='golfYn_V121' mdef='골프장여부\n(특근수당)' />",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"golfYn",		Edit:0,	FontColor:"#FF0000" },
			{Header:"<sht:txt mid='reason_V121' mdef='근무내용' />",	Type:"Text",			Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"reason",		Format:"",		Edit:0 },
			//Hidden
			{Header:"신청순번",						Type:"Text",		Hidden:1,	Width:90, 	Align:"Center",	ColMerge:0,	SaveName:"applSeq"},
			{Header:"신청입력자",						Type:"Text",   		Hidden:1, 	Width:80 , 	Align:"Center", ColMerge:0, SaveName:"applInSabun"},
			{Header:"신청자사번",						Type:"Text",   		Hidden:1, 	Width:80 , 	Align:"Center", ColMerge:0, SaveName:"applSabun"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		//세부내역 버튼 이미지
		sheet1.SetImageList(0,"/common/images/icon/icon_info.png");
		sheet1.SetDataLinkMouse("ibsImage",true);
		var arrCol = ["cancelDelCheck", "ibsImage2", "cancelApplYmd", "cancelApplStatusCd", "cancelReason"];
		for( var i=0; i<arrCol.length; i++){
			sheet1.SetCellBackColor(0, arrCol[i], "#ecf3fb");sheet1.SetCellBackColor(1, arrCol[i], "#ecf3fb");
		}
		
		var allText = "<sch:txt mid='all' mdef='전체' />";

		//신청상태
		//var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "전체");
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getApplStatusCdList&applStatusNotCd=98,"), allText);
		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		$("#searchApplStatusCd").html(applStatusCd[2]);
		
		$("#searchApplStatusCd,#searchWorkGubun").change(function(){
			doAction1("Search") ;
		});		
		
		//취소여부
		//sheet1.SetColProperty("updateYn", 		{ComboText:"||취소", ComboCode:"|N|Y"} );
		
		//연장근무구분
		//sheet1.SetColProperty("workGubun", 		{ComboText:"|근로시작시간전|근로종료시간후|휴일근로", ComboCode:"|1|2|3"} );
		
		$(window).smartresize(sheetResize); sheetInit();
		
		setEmpPage();
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 
			var data = sheet1.GetSearchData( "${ctx}/GetDataList.do?cmd=getExWorkDriverAppList", $("#sheetForm").serialize() );
			data = replaceAll( data, "sDeleteEdit", "sDelete#Edit");
			data = replaceAll( data, "cancelDelCheckEdit", "cancelDelCheck#Edit");
			sheet1.LoadSearchData(data)
			
			break;
		case "Save": 		
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveExWorkDriverApp", $("#sheetForm").serialize()); break;
		case "Down2Excel":	
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param); 
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if (Msg != ""){ 
				alert(Msg); 
			} 
			sheetResize(); 
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{ 
			if(Msg != ""){ 
				alert(Msg);
			}
			if(Code > 0) doAction1("Search");
		}catch(ex){ 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	//공통인사헤어에서 사용자 변경 시
	function setEmpPage() {

    	$("#searchSabun").val($("#searchUserId").val());
    	$("#payType").val($("#searchEmpPayType").val());
    	
    	doAction1("Search");
 
    }
	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
    	
		try {
			if( Row < sheet1.HeaderRows() ) return;
			// 연장근로신청
		    if( sheet1.ColSaveName(Col) == "ibsImage" && Value != "") {
		    	showApplPopup("340"
		    			     ,sheet1.GetCellValue(Row,"applSeq")
	    				     ,sheet1.GetCellValue(Row,"applInSabun")
	    				     ,sheet1.GetCellValue(Row,"applYmd")
	    				     ,sheet1.GetCellValue(Row,"applStatusCd"));
		    }
	    	
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	
	//신청 팝업
	function showApplPopup(applCd, applSeq, applInSabun, applYmd, applStatusCd) {
		var auth = "", url = "", initFunc = '';
		
		if(applStatusCd == "" || applStatusCd == "11" ) {
			auth = "A";
			url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		}else{
			auth = "R";
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}
		
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchSabun').val()
			  , searchApplYmd: applYmd 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '근태신청',
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
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}
	
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');
		
		doAction1("Search");
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	
	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<input type="hidden" id="payType" name="payType" value=""/>
		
		<div class="sheet_search sheet_search_s outer">
			<table>
			<tr>
				<th><tit:txt mid="104420" mdef="기간" /></th>
				<td>
					<input id="searchFromYmd" name="searchFromYmd" type="text" size="10" class="date2" value="${curSysYear}-01-01"/> ~
					<input id="searchToYmd" name="searchToYmd" type="text" size="10" class="date2" value="${curSysYear}-12-31"/>
				</td>
				<th><tit:txt mid='112999' mdef='결재상태'/></th>
				<td colspan="2"> 
					<select id="searchApplStatusCd" name="searchApplStatusCd">
					</select> 
			    </td>
				<th><tit:txt mid="202005180000018" mdef="수당구분" /></th>
			    <td> 
			    	<select id="searchWorkGubun" name="searchWorkGubun" >
			    		<option value=""><sch:txt mid='all' mdef='전체' /></option>				
						<option value="N"><tbl:txt mid='searchWorkGubunN_V121' mdef='야근수당' /></option>
						<option value="S"><tbl:txt mid='searchWorkGubunS_V121' mdef='특근수당' /></option>
					</select>
			    </td>
				<td> 
					<btn:a mid="search" mdef="조회" href="javascript:doAction1('Search');" id="btnSearch" css="button" />
				</td>
			</tr>
			</table>
		</div>
	</form>
	<table class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid="202005180000017" mdef="시간외근무(기원)" /></li>
							<li class="btn">
								<btn:a mid="111859" mdef="신청" href="javascript:showApplPopup('340','','${ssnSabun}','${curSysYyyyMMdd}','11');"  css="button authA" />
								<btn:a mid="save" mdef="저장" href="javascript:doAction1('Save');"  css="basic authA" />
								<btn:a mid="download" mdef="다운로드" href="javascript:doAction1('Down2Excel');"  css="basic authR" />
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>