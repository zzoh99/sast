<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
	.extIncom {
		color: #868686 !important;
		margin-left: 10px !important;
		margin-right: 10px !important;
	}
	.incomingMgrPopup {
		margin-left: 10px !important;
		margin-right: 10px !important;
	}
</style>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		$("#searchBizPlaceCd").on("change", function(e) {
			var orgCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgCdListGrp&ssnSearchType=${ssnSearchType}&ssnGrpCd=${ssnGrpCd}&searchBizPlaceCd="+$("#searchBizPlaceCd").val()+"&searchYmd="+"${curSysYyyyMMHyphen}",false).codeList, "전체");
			$("#searchOrgCd").html(orgCd[2]);
		});
		$("#searchOrgCd").on("change", function(e) {
			doAction1("Search");
		});
		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"대상자|사번",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun", 		KeyField:0,	Format:"",	Edit:0 },
			{Header:"대상자|성명",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name", 		KeyField:0,	Format:"",	Edit:0 },
			{Header:"대상자|부서",		Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"orgNm", 		KeyField:0,	Format:"",	Edit:0 },
			{Header:"대상자|직급",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", 	KeyField:0,	Format:"",	Edit:0 },
			/* 1순위 후임자 */
			{Header:"1순위|후임자",		Type:"Html",	Hidden:0,	Width:205,	Align:"Left",	ColMerge:0,	SaveName:"incom1",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"1순위|세부\n내역",	Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail1",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"1순위|사번",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"incomId1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"1순위|성명",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"incomName1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"1순위|부서",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"incomOrgNm1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"1순위|외부\n영입",	Type:"Text",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"extIncomYn1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			/* 2순위 후임자 */
			{Header:"2순위|후임자",		Type:"Html",	Hidden:0,	Width:205,	Align:"Left",	ColMerge:0,	SaveName:"incom2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	BackColor:"#fdf0f5"	},
			{Header:"2순위|세부\n내역",	Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	BackColor:"#fdf0f5" },
			{Header:"2순위|사번",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"incomId2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10,		BackColor:"#fdf0f5" },
			{Header:"2순위|성명",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"incomName2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	BackColor:"#fdf0f5" },
			{Header:"2순위|부서",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"incomOrgNm2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	BackColor:"#fdf0f5" },
			{Header:"2순위|외부\n영입",	Type:"Text",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"extIncomYn2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	BackColor:"#fdf0f5" },
			/* 3순위 후임자 */
			{Header:"3순위|후임자",		Type:"Html",	Hidden:0,	Width:205,	Align:"Left",	ColMerge:0,	SaveName:"incom3",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"3순위|세부\n내역",	Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail3",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"3순위|사번",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"incomId3",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"3순위|서명",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"incomName3",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"3순위|부서",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"incomOrgNm3",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"3순위|외부\n영입",	Type:"Text",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"extIncomYn3",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			/* hidden */
			{Header:"회사코드|회사코드",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:0,	Format:"",	Edit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail1", 1);
		sheet1.SetDataLinkMouse("detail2", 1);
		sheet1.SetDataLinkMouse("detail3", 1);
		
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var bizPlaceCdList = "";
		var params = "queryId=getBusinessPlaceCdList";
		if("${ssnSearchType}" != "A") {
			params += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", params, false).codeList, "");	//사업장
		} else {
			bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", params, false).codeList, "전체");	//사업장
		}
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		$("#searchBizPlaceCd").trigger("change");
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function doAction1(sAction){
		switch(sAction){
			case "Search":      //조회
				sheet1.DoSearch( "${ctx}/IncomingMgr.do?cmd=getIncomingMgrList", $("#srchFrm").serialize() );
				break;
			case "Down2Excel":  //엑셀내려받기
				var downcol = makeHiddenSkipCol(sheet1);
				sheet1.Down2Excel({DownCols:downcol,SheetDesign:1,Merge:1});
				break;
		}
	}

	// 승계 후임자 출력 html 반환
	function getIncomHtml(Row, Rank) {
		var html = "", incomName, incomOrgNm, extIncomYn;
		if( Row > -1 ) {
			incomName  = sheet1.GetCellValue(Row, "incomName" + Rank);
			incomOrgNm = sheet1.GetCellValue(Row, "incomOrgNm" + Rank);
			extIncomYn = sheet1.GetCellValue(Row, "extIncomYn" + Rank);
			if( extIncomYn != "" ) {
				if( extIncomYn == "Y" ) {
					html = "<span class='extIncom'>외부영입</span>";
				} else {
					html = "<span class='incomingMgrPopup'>" + incomName + "(" + incomOrgNm + ")" + "</span>";
				}
			}
		}
		return html;
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try {
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			
			if(sheet1.RowCount() > 0){
				for(var i = sheet1.HeaderRows(); i < sheet1.LastRow() + 1; i++){
					sheet1.SetCellValue(i, "incom1", getIncomHtml(i, "1"));
					sheet1.SetCellValue(i, "incom2", getIncomHtml(i, "2"));
					sheet1.SetCellValue(i, "incom3", getIncomHtml(i, "3"));
					sheet1.SetCellValue(i, "sStatus","R");
				}
			}
			
			sheetResize();
		} catch(ex) {alert("OnSearchEnd Event Error : " + ex);}
	}
	
	//저장 후 메시지
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
	
	// 시트 클릭 시 이벤트
	function sheet1_OnClick(Row, Col, Value){
		try{
			var colSaveName = sheet1.ColSaveName(Col);
			
			if( colSaveName && colSaveName != null && colSaveName != "" ) {
				if(colSaveName == "detail1"){
					if( sheet1.GetCellValue(Row, "extIncomYn1") == "N" && sheet1.GetCellValue(Row, "incomId1") != "" ) {
						openIncomingMgrPopup(Row, "1");
					}
				}
				if(colSaveName == "detail2"){
					if( sheet1.GetCellValue(Row, "extIncomYn2") == "N" && sheet1.GetCellValue(Row, "incomId2") != "" ) {
						openIncomingMgrPopup(Row, "2");
					}
				}
				if(colSaveName == "detail3"){
					if( sheet1.GetCellValue(Row, "extIncomYn3") == "N" && sheet1.GetCellValue(Row, "incomId3") != "" ) {
						openIncomingMgrPopup(Row, "3");
					}
				}
			}
		} catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}
	
	//후보자(1~3순위) 팝업을 띄운다.
	function openIncomingMgrPopup(Row, rank) {
		if(!isPopup()) {return;}

		gPRow  = Row;
		pGubun = "incomName" + rank;
	
		// openPopup(url,args,w,h);

		let w = 1100;
		let h = 700;
		let url = "${ctx}/IncomingMgr.do?cmd=viewIncomingMgrLayer&authPg=A";
		let p = {
			incomId : sheet1.GetCellValue(Row, "incomId" + rank),
			sabun : sheet1.GetCellValue(Row, "sabun"),
			enterCd : sheet1.GetCellValue(Row, "enterCd"),
			incomSeq : rank
		};

		// openPopup(url,args,w,h);
		let layerModal = new window.top.document.LayerModal({
			id : 'incomingMgrLayer'
			, url : url
			, parameters : p
			, width : w
			, height : h
			, title : '후임자관리 세부내역'
			, trigger :[
				{
					name : 'incomingMgrLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> 
							<span>소속 </span> 
							<select id="searchBizPlaceCd" name="searchBizPlaceCd"></select> 
						</td>
						<td>
							<span>부서</span>
							<select id="searchOrgCd" name="searchOrgCd" class="box"></select>
							<label>
								<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox mal10" value="Y" checked="checked" />
								하위포함
							</label>
							<label>
								<input id="searchExtIncomYn" name="searchExtIncomYn" type="checkbox" class="checkbox mal10" value="Y" />
								후임자 외부영입 여부
							</label>
						</td>
						<td>
							<span>사번/성명</span>
							<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/> </td>
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
							<li id="txt" class="txt">후임자관리</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='down2excel' mdef="다운로드"/>
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