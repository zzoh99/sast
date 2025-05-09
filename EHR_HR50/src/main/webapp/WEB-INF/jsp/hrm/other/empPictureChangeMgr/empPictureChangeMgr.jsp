<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		//sheet1
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:1000,MergeSheet:msAll,FrozenCol:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택", 		Type:"CheckBox",    Hidden:0,   Width:50,  	Align:"Center", ColMerge:0, SaveName:"applSel",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },            			
			{Header:"신청순번", 	Type:"Text",    Hidden:1,   Width:10,  	Align:"Center", ColMerge:0, SaveName:"applSeq",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"신청일", 	Type:"Text",    Hidden:0,   Width:75,  	Align:"Center", ColMerge:0, SaveName:"applYmd",     KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },			
			{Header:"사번", 		Type:"Text",    Hidden:0,   Width:60,  	Align:"Center", ColMerge:0, SaveName:"sabun",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"성명",		Type:"Text",   	Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"name", 		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"소속",		Type:"Text",	Hidden:0,   Width:80,   Align:"Left", ColMerge:0, SaveName:"orgNm",   	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },			
			{Header:"처리\n상태",	Type:"Combo",   Hidden:0,   Width:50,  	Align:"Center", ColMerge:0, SaveName:"applStatusCd",KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			
			
			{Header:"반영일자",	Type:"Text",    Hidden:0,   Width:75,   Align:"Center", ColMerge:0, SaveName:"apprYmd",   	KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"담당자",		Type:"Text",	Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"apprName",  	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"회답",		Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"returnMessage",KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"오류내용",	Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"errorLog",  	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"메모",		Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"memo",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"0",		Type:"Text",   	Hidden:1,   Width:10,  	Align:"Center", ColMerge:0, SaveName:"applStatusCdTmp",KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"1",		Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"imageType",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"2",		Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"fileSeq",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"3",		Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"seqNo",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			//{Header:"4",			Type:"Text",	Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"fileSeq",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			//{Header:"5",			Type:"Text",	Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"seqNo",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"6",			Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"curFileSeq",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"7",			Type:"Text",	Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"curSeqNo",  		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//event정의
		$("#dataTable :input").change(function(){
			var objid = $(this).attr("id");
			//console.log(objid);
			sheet1.SetCellValue(sheet1.GetSelectRow(),objid,$(this).val());
		});
		
		/******************************************************************************************/
		//search zone 정리
		//달력
		$("#searchFromApplYmd").datepicker2({
			startdate:"searchToApplYmd",
			onReturn: getCommonCodeList
		});

		$("#searchToApplYmd").datepicker2({
			enddate:"searchFromApplYmd",
			onReturn: getCommonCodeList
		});

		// 기간 default 값
		$("#searchToApplYmd").val("${curSysYyyyMMddHyphen}");
		$("#searchFromApplYmd").val("<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>");

		getCommonCodeList();

		//event
		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				$(this).parent().find("a").trigger("click");
			}
		});
		/******************************************************************************************/
		$("#searchSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		//search zone 값 setting한 후 조회
		doAction1("Search");

		$(window).smartresize(sheetResize); sheetInit();
		
	});

	function getCommonCodeList() {
		//콤보박스
		let baseSYmd = $("#searchFromApplYmd").val();
		let baseEYmd = $("#searchToApplYmd").val();
		const applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90028", baseSYmd, baseEYmd), "전체");
		sheet1.SetColProperty("applStatusCd", 		{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );
		//처리상태
		$("#searchApplStatusCd").html(applStatusCd[2]);
		$("#searchApplStatusCd").val("1");
	}

	function getParamSave() {
		var param = $("#srchFrm").serialize();
		if($("#mailYn:checked").val() != undefined) {
			param += "&mailYn="+$("#mailYn").val();
		}
		if($("#smsYn:checked").val() != undefined) {
			param += "&smsYn="+$("#smsYn").val();
		}
		if($("#gwYn:checked").val() != undefined) {
			param += "&gwYn="+$("#gwYn").val();
		}
		return param;
	}
	//Sheet1 Action
	function doAction1(sAction) {
		statusRows = [];
		switch (sAction) {
		case "Search": 	 	
			sheet1.DoSearch( "${ctx}/PsnalBasicInf.do?cmd=getEmpPictureChangeMgrList", $("#srchFrm").serialize() );
			//우측 회답, 오류내용, 메모, 이미지 clear			
			$("#dataTable :input").val("");
			$("#photo").attr("src","");
			$("#applPhoto").attr("src","");
			break;
		case "Save": 		
							
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/PsnalBasicInf.do?cmd=saveEmpPictureChangeMgr", getParamSave()); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		case "Accept":
			var cnt = 0;
			for(var i=1 ; i<sheet1.RowCount()+1; i++){
				if(sheet1.GetCellValue(i,"applSel") == "1" && sheet1.GetCellValue(i, "applStatusCdTmp") == "1"){
					cnt ++;
					sheet1.SetCellValue(i, "applStatusCd", "2");
				}
			}
			if(cnt==0){
				alert("반영할 항목을 선택하세요.");
			}else{
				doAction1("Save");
			}
			break;
		case "Reject":
			var cnt = 0;
			for(var i=1 ; i<sheet1.RowCount()+1; i++){
				if(sheet1.GetCellValue(i,"applSel") == "1" && sheet1.GetCellValue(i, "applStatusCdTmp") == "1"){
					cnt ++;
					sheet1.SetCellValue(i, "applStatusCd", "3");
				}
			}
			if(cnt==0){
				alert("반려할 항목을 선택하세요.");
			}else{
				doAction1("Save");
			}			
			
			break;
		}
	}
	
	function doAction2(sAction){
		statusRows = [];
		switch(sAction){
		
		case "Accept":
			//신청인지 체크 
			if(sheet1.GetCellValue(sheet1.GetSelectRow(), "applStatusCdTmp") == "1"){
				//var data = sheet1.GetRowData(sheet1.GetSelectRow());
				
				for(var i=1 ; i<sheet1.RowCount()+1 ; i++){
					if(i==sheet1.GetSelectRow()){
						sheet1.SetCellValue(i,"applStatusCd","2");//반영
					}else if(sheet1.GetCellValue(i,"sStatus")!="R"){
						statusRows.push({"sStatus":sheet1.GetCellValue(i,"sStatus"),"row":i});
						sheet1.SetCellValue(i,"sStatus","R");
					}
				}
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/PsnalBasicInf.do?cmd=saveEmpPictureChangeMgr", getParamSave());
			}else{
				alert("처리상태가 신청상태 일때만 반영처리할 수 있습니다.");
			}
			break;
		case "Reject":
			if(sheet1.GetCellValue(sheet1.GetSelectRow(), "applStatusCdTmp") == "1"){
				for(var i=1 ; i<sheet1.RowCount()+1 ; i++){
					if(i==sheet1.GetSelectRow()){
						sheet1.SetCellValue(i,"applStatusCd","3");//반려
					}else if(sheet1.GetCellValue(i,"sStatus")!="R"){
						statusRows.push({"sStatus":sheet1.GetCellValue(i,"sStatus"),"row":i});
						sheet1.SetCellValue(i,"sStatus","R");
					}
				}
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/PsnalBasicInf.do?cmd=saveEmpPictureChangeMgr", getParamSave());
			}else{
				alert("처리상태가 신청상태 일때만 반려처리할 수 있습니다.");
			}
			break;
		}
	}
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			//신청건만 삭제가능, 처리상태 변경가능 , 체크가능
			for(var i=1 ; i<sheet1.RowCount()+1 ; i++){
				sheet1.SetCellEditable(i,"sDelete",sheet1.GetCellValue(i,"applStatusCdTmp") == "1");
				sheet1.SetCellEditable(i,"applSel",sheet1.GetCellValue(i,"applStatusCdTmp") == "1");
				sheet1.SetCellEditable(i,"applStatusCd",sheet1.GetCellValue(i,"applStatusCdTmp") == "1");
			}
			
			
			sheetResize(); 
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			}
			doAction1("Search"); 
			/* for(var i in statusRows){
				var t = statusRows[i];
				if(t){
					sheet1.SetCellValue(t.row, "sStatus", t.sStatus);
				}
			} */
			
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		
		//사진 show 
		var applStatusCd = sheet1.GetCellValue(NewRow,"applStatusCd");
		var fileSeq = sheet1.GetCellValue(NewRow, "fileSeq");
		var seqNo = sheet1.GetCellValue(NewRow, "seqNo");
		
		//신청 이미지
		$("#applPhoto").attr("src", "${ctx}/EmpPhotoOut.do?t=" + new Date().getTime() + "&fileSeq="+fileSeq+"&seqNo="+seqNo);
/* 		if(applStatusCd == "2"){ */
			var curFileSeq = sheet1.GetCellValue(NewRow, "curFileSeq")+"";
			var curSeqNo = sheet1.GetCellValue(NewRow, "curSeqNo")+"";
			if(curFileSeq != "") {
				$("#photo").attr("src", "${ctx}/EmpPhotoOut.do?t=" + new Date().getTime() + "&fileSeq="+curFileSeq+"&seqNo="+curSeqNo);
			} else {
				$("#photo").attr("src", "${ctx}/common/images/common/img_photo.gif");
			}
			
/* 		 }else{
			//신청전 : 현재이미지 
			$("#photo").attr("src", "${ctx}/EmpPhotoOut.do?t=" + new Date().getTime() + "&searchKeyword="+sheet1.GetCellValue(NewRow,"sabun"));
		}  */
		$("#dataTable :input").each(function(){			
			if(sheet1.GetCellValue(NewRow,$(this).attr("id"))!=-1)$(this).val(sheet1.GetCellValue(NewRow,$(this).attr("id")));
		});
		
	}
	/*******************************************************************************************************/
	function popup(opt){
		pGubun = opt;
		if(opt == "org"){
			openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");	
		}
	}

	//  소속 팝입
	function orgSearchPopup(){
		try{
			pGubun = "org";
			var w = 740, h = 520;
			var p = { searchEnterCd: "${ssnEnterCd}",  findOrg: $("#searchOrgNm").val()};
			var title = "<tit:txt mid='orgTreePop' mdef='조직도 조회'/>";
			var url = "/Popup.do?cmd=viewOrgTreeLayer";
			var layerModal = new window.top.document.LayerModal({
				id : 'orgTreeLayer',
				url : url,
				parameters: p,
				width : w,
				height : h,
				title : title,
				trigger: [
					{
						name: 'orgTreeLayerTrigger',
						callback: function(rv) {
							getReturnValue(rv)
						}
					}
				]
			});
			layerModal.show();
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = returnValue;

		if(pGubun == "org") {
	    	$("#searchOrgCd").val(rv["orgCd"]);
	    	$("#searchOrgNm").val(rv["orgNm"]);
	    	$("#searchOrgSdate").val(rv["sdate"]);
	    }
	
	}

	// 초기화
	function clearCode() {
		$("#searchOrgNm").val('');
		$("#searchOrgSdate").val('');
		$("#searchOrgCd").val('');
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr class="_hideArea">		
						<th>사번/성명</th>	
						<td>  <input type="text" class="text" id="searchSabun" name="searchSabun"/></td>
						<th>소속</th>
						<td colspan=2>  <input id="searchOrgCd" name ="searchOrgCd" type="text" readonly class="text" style="width:60px;"  />
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text"  /> 
							<a onclick="javascript:orgSearchPopup()" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
							<a href="javascript:clearCode()" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
							<input type="checkbox" id="searchIncChldOrg" name="searchIncChldOrg" value="Y"/>하위소속포함
							<input type="hidden" id="searchOrgSdate" name="searchOrgSdate"/>
						</td>
					</tr>
					<tr>
						<th>신청일자</th>
						<td>  <input type="text" class="text date2" id="searchFromApplYmd" name="searchFromApplYmd"/>
							~
							<input type="text" class="text date2" id="searchToApplYmd" name="searchToApplYmd"/>
						</td>
						<th>처리상태</th>
						<td>
							<select id="searchApplStatusCd" name="searchApplStatusCd" style="min-width:100px;"></select>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="65%" />
		<col width="" />
	</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">변경신청내역</li>
							<li class="btn _hideArea">
<!-- 							<input type="checkbox" id="mailYn" name="mailYn" style="margin-bottom:-2px;" value="Y" checked/></td><td>&nbsp;메일&nbsp;&nbsp;
								<input type="checkbox" id="smsYn" name="smsYn" style="margin-bottom:-2px;" value="Y"/></td><td>&nbsp;SMS&nbsp;&nbsp;
								<input type="checkbox" id="gwYn" name="gwYn" style="margin-bottom:-2px;" value="Y" /></td><td>&nbsp;그룹웨어알림&nbsp;&nbsp; -->
								<a href="javascript:doAction1('Save')" 	class="btn soft authA">저장</a>
								<a href="javascript:doAction1('Accept')" class="btn filled authA">일괄반영</a>
								<a href="javascript:doAction1('Reject')" 	class="btn outline authA">일괄반려</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "65%", "100%","kr"); </script>
				
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">상세내역</li>
							<li class="btn _hideArea">
								<a href="javascript:doAction2('Accept')" class="btn filled authA">반영</a>
								<a href="javascript:doAction2('Reject')" 	class="btn outline authA">반려</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="table-wrap" style="height: calc(100vh - 42px - 84px); overflow-y:auto;">
					<table border="0" cellpadding="0" cellspacing="0" class="default" id="dataTable">
						<colgroup>
							<col width="50%" />
							<col width="" />
						</colgroup>
						<tr>						
							<th style="text-align:center;">신청전 이미지</th>
							<th style="text-align:center;">신청 이미지</th>
						</tr>
						<tr>						
							<td align=center>
								<table>
									<tr>
										<td>
											<img src="/common/images/common/img_photo.gif" id="photo" width="110" height="165" onerror="javascript:this.src='/common/images/common/img_photo.gif'">	
										</td>
									</tr>
								</table>
							</td>
							<td align=center>
								<table>
									<tr>
										<td>
											<img src="/common/images/common/img_photo.gif" id="applPhoto" width="110" height="165" onerror="javascript:this.src='/common/images/common/img_photo.gif'">	
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>						
							<th colspan=2>회답</th>
						</tr>
						<tr>						
							<td colspan=2>
								<textarea id="returnMessage" name="returnMessage" style="width:100%;" rows=5></textarea>
							</td>
						</tr>
						<tr class="_hideArea">	
							<th colspan=2>메모</th>
						</tr>
						<tr class="_hideArea">	
							<td colspan=2>
								<textarea id="memo" name="memo" style="width:100%;" rows=5></textarea>
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>	
</div>

