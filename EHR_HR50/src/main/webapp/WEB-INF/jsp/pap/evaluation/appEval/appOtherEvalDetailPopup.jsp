<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>타인평가상세팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var param = {};	
	var convertParam = {};
	var vaControlId;
	var vaViewId;
	
	$(function() {
		//$("#detailList").css("height", window.innerHeight - 40);
		//$("#detailList").css("height", "100%");
	})
	
	
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		var appTypeCd = convertParam.appTypeCd;
		var html = "";
		if (appTypeCd == "01") {
			vaControlId = ["appSelfMemo"];
			vaViewId = ["appSelfMemo"]
			html += makeContainer(1, ["1차 합의자"], vaControlId);
		} else if (appTypeCd == "03") {
			$("#btnAgree").html("평가완료");
			html += makeContainer(1, ["1차 합의자"], ["appSelfMemo"]);
			if (convertParam.appSeq == "1") {
				vaViewId = ["appSelfMemo", "mid1stExceMemo", "mid1stSuppMemo", "mid2ndExceMemo", "mid2ndSuppMemo"];
				vaControlId = ["mid1stExceMemo", "mid1stSuppMemo"];
				html += makeContainer(2, ["1차 중간점검자", "우수사항", "보완사항"], vaControlId);
				html += makeContainer(2, ["2차 중간점검자", "우수사항", "보완사항"], ["mid2ndExceMemo", "mid2ndSuppMemo"]);	
			} else {
				vaViewId = ["appSelfMemo", "mid1stExceMemo", "mid1stSuppMemo", "mid2ndExceMemo", "mid2ndSuppMemo"];
				vaControlId = ["mid2ndExceMemo", "mid2ndSuppMemo"];
				html += makeContainer(2, ["1차 중간점검자", "우수사항", "보완사항"], ["mid1stExceMemo", "mid1stSuppMemo"]);
				html += makeContainer(2, ["2차 중간점검자", "우수사항", "보완사항"], vaControlId);
			}
		} else if (appTypeCd == "05") {
			$("#btnAgree").html("평가완료");
			vaViewId = ["appSelfMemo", "mid1stExceMemo", "mid1stSuppMemo", "mid2ndExceMemo", "mid2ndSuppMemo", "app1stExceMemo", "app1stSuppMemo"];
			vaControlId = ["app1stExceMemo", "app1stSuppMemo"];
			html += makeContainer(1, ["1차 합의자"], ["appSelfMemo"]);
			html += makeContainer(2, ["1차 중간점검자", "우수사항", "보완사항"], ["mid1stExceMemo", "mid1stSuppMemo"]);
			html += makeContainer(2, ["2차 중간점검자", "우수사항", "보완사항"], ["mid2ndExceMemo", "mid2ndSuppMemo"]);
			html += makeContainerAddGrade(2, ["1차 평가자", "우수사항", "보완사항"], vaControlId);
			//$("#fileUpload").show();
		}
		$("#tableInfo").html(html);
		$("#divGrade").hide(); //점수박스 (평가)
		
		
		$("#sabun").val(convertParam.sabun)
		$("#appSabun").val(convertParam.appSabun);
		$("#stepCd").val(convertParam.stepCd);
		$("#appTypeCd").val(convertParam.appTypeCd);
		$("#appraisalCd").val(convertParam.appraisalCd);
		$("#appGroupCd").val(convertParam.appGroupCd);
		$("#appSeq").val(convertParam.appSeq);
		
		var title = param.title + "|" + param.title;
		var initdata = {};
		initdata.Cfg = {SizeMode:1,FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:appTypeCd == "05"?0:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택|선택",		Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"지표|지표",								Type:"Text",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:1,	SaveName:"compGrpNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"목표업무(평가항목)|목표업무(평가항목)",	Type:"Text",		Hidden:0,		Width:100,	Align:"Left",	ColMerge:0,	SaveName:"compNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			
			{Header:"항목1",									Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont1",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목2",									Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont2",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목3",									Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont3",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목4",									Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont4",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목5",									Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont5",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목6",									Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont6",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목7",									Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont7",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"sabun",									Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sabun",			KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"appraisalCd",								Type:"Text",	Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"seq",										Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"seq",				KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
		];
		if (appTypeCd == "01") {
			initdata.Cols.push({Header:"세부내용|세부내용",				Type:"Text",		Hidden:0,		Width:350,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",	KeyField:1,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1});
			initdata.Cols.push({Header:"비중|비중",						Type:"AutoSum",	  	Hidden:0,  		Width:50,	Align:"Right", ColMerge:0, SaveName:"weight",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:1,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 });
			initdata.Cols.push({Header:"순서|순서",						Type:"Int",	  		Hidden:0,  		Width:50,	Align:"Right", ColMerge:0, SaveName:"orderSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 });
		} else if (appTypeCd == "03") {
			initdata.Cols.push({Header:"행동지표(세부내용)|행동지표(세부내용)",	Type:"Text",		Hidden:0,		Width:350,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",	KeyField:0,		UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1});
			initdata.Cols.push({Header:"중간실적|중간실적",				Type:"Text",		Hidden:0,		Width:350,	Align:"Left",	ColMerge:0,	SaveName:"appMidResult",KeyField:1,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1});
			initdata.Cols.push({Header:"자기평가점수|자기평가점수",		Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appSelfPointMid",KeyField:1,			CalcLogic:"",	Format:"NullFloat",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 });
			initdata.Cols.push({Header:"비중|비중",						Type:"AutoSum",	  	Hidden:0,  		Width:50,	Align:"Right", 	ColMerge:0, SaveName:"weight",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:1,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 });
		} else if (appTypeCd == "05") {
			initdata.Cols.push({Header:"세부내용|세부내용",				Type:"Text",		Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1});
			initdata.Cols.push({Header:"실적|실적",						Type:"Text",		Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"appFinResult",KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1});
			initdata.Cols.push({Header:"중간실적|중간실적",				Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appMidResult",KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"중간점검|중간점검",				Type:"Image",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,				Cursor:"Pointer" });
			initdata.Cols.push({Header:"비중|비중",						Type:"AutoSum",	  	Hidden:0,  		Width:30,	Align:"Right", 	ColMerge:0, SaveName:"weight",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:1,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 });
			initdata.Cols.push({Header:"점수|본인\n평가",				Type:"Float",		Hidden:0,		Width:40,	Align:"Right",	ColMerge:0,	SaveName:"appSelfPoint",KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MaximumValue:100, MinimumValue: 0});
			initdata.Cols.push({Header:"점수|1차 평가자",				Type:"Float",		Hidden:0,		Width:50,	Align:"Right",	ColMerge:0,	SaveName:"app1stPoint",	KeyField:1,				CalcLogic:"",	Format:"NullFloat",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MaximumValue:100, MinimumValue: 1});
			initdata.Cols.push({Header:"",								Type:"Text",		Hidden:1,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,				CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0});
			$("#divGrade").show();
		}
		
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(0);sheet1.SetUnicodeByte(3);
		
		//sheet1.FocusAfterProcess = false;
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		//sheet1.FitColWidth();
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);
		//sheet1.SetEditArrowBehavior(0);
		
		$(window).smartresize(sheetResize); sheetInit();
		//var param = '${Param}';
		showUserList();
		showSch();
	});
	
	function makeContainer(pnDepth, paDivName, paDivId) {
		var html = "";
		if (pnDepth == 1) {
			html += '<tr>'
			html +=	'	<th colspan="2"><span id="label_' + paDivId[0] + '" class="required">'+paDivName[0]+'</span></th>'
			html +=	'	<td>'
			html +=	'		<textarea id="'+paDivId[0]+'" name="'+paDivId[0]+'" label="label_'+paDivId[0]+'" rows="4" class="${textCss} w90p required" ${readonly}  maxlength="1200"></textarea>'
			html += '	</td>'
			html += '</tr>'
		} else if (pnDepth == 2) {
			html += '<tr>'
			html += '	<th rowspan="2" style="width:100px"><span class="required">'+paDivName[0]+'</span></th>'
			html += '	<th style="width:100px"><span id="label_' + paDivId[0] + '" class="required">'+paDivName[1]+'</th>'
			html += '	<td>'
			html +=	'		<textarea id="'+paDivId[0]+'" name="'+paDivId[0]+'" label="label_'+paDivId[0]+'" rows="4" class="${textCss} w90p required" ${readonly}  maxlength="1200"></textarea>'
			html += '	</td>'
			html += '</tr>'
			html += '<tr>'
			html += '	<th><span id="label_' + paDivId[1] + '" class="required">'+paDivName[2]+'</span></th>'
			html += '	<td>'
			html +=	'		<textarea id="'+paDivId[1]+'" name="'+paDivId[1]+'" label="label_'+paDivId[1]+'" rows="4" class="${textCss} w90p required" ${readonly}  maxlength="1200"></textarea>'
			html += '	</td>'
			html += '</tr>'
			
		}
		return html;
	}
	
	function makeContainerAddGrade(pnDepth, paDivName, paDivId) {
		var html = "";
		if (pnDepth == 2) {
			html += '<tr>'
			html += '	<th rowspan="2" style="width:100px"><span class="required">'+paDivName[0]+'</span></th>'
			html += '	<th style="width:100px"><span id="label_' + paDivId[0] + '" class="required">'+paDivName[1]+'</th>'
			html += '	<td style="display:flex;">'
			html +=	'		<textarea id="'+paDivId[0]+'" name="'+paDivId[0]+'" label="label_'+paDivId[0]+'" rows="4" class="${textCss} w90p required" ${readonly}  maxlength="4000"></textarea>'
			html +=	'        <span id="gradeBox" style="display:block; position:relative; width:60px; border:1px solid black; left:30px; height:100%;">'
			html +=	'        	<dl><dt style="height:25px; background:red; color:white; font-size:15px; display:flex; justify-content:center; align-items:center">점수</dt>'
			html +=	'        	<dd id="grade" style="text-align:center; font-size:18px; color:black; background:white; display:flex; justify-content:center; align-items:center; height:30px;"></dd></span>'
			html += '	</td>'
			html += '</tr>'
			html += '<tr>'
			html += '	<th><span id="label_' + paDivId[1] + '" class="required">'+paDivName[2]+'</span></th>'
			html += '	<td>'
			html +=	'		<textarea id="'+paDivId[1]+'" name="'+paDivId[1]+'" label="label_'+paDivId[1]+'" rows="4" class="${textCss} w90p required" ${readonly}  maxlength="4000"></textarea>'
			html += '	</td>'
			html += '</tr>'
			
		}
		return html;
	}
	
	
	function showUserList() {		
		try {
			var html = "";
			$("#detailList").html("");
			var data = ajaxCall("${ctx}/AppEval.do?cmd=getOtherEvalDetailPopupUserList", $("#empForm").serialize(), false);
			//console.log('data', data);
			
			var item = null;
			var key = null; 
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					keys = Object.keys(item);
					html += "<div class=\'tile-stats card-profile\' sabun='" + item.sabun + "' appTypeCd='"+item.appTypeCd+"' appSeq='"+item.appSeq+"' onclick=\"javascript:showEmpDetailContents('" + item.sabun + "');\">";
					keys.forEach(function(el, index, all) {
						var value = item[el] ? item[el] : "";
						html += "    <input type='hidden' id='item_"+el+"' value='"+ value + "'/>";
					})			
					html += "  <div class=\'profile_img \'>";
					html += "    <img src=\'/common/images/common/img_photo.gif\'  id='photo"+i+"\' alt=\'Avatar\' title=\'Change the avatar\'>";
					html += "  </div>";
					html += "  <div class=\'profile_info\'>";
					html += "   <ul class=\'profile_desc\'>";
					html += "      <li id=\'item1_"+i+"\'></li>";
					//html += "      <li id=\'tdEmpYmd"+i+"\'></li>";
					html += "      <li id=\'item2_"+i+"\'></li>";
					html += "      <li id=\'item3_"+i+"\'></li>";
					html += "    </ul>";
					html += "   <div id=\'info_'"+i+"\'></div>";
					html += "  </div>";
					html += "</div>";
				}
			}
			html += "<br/>"			
			$("#detailList").html(html);
			
			/* 데이터 세팅 */
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					
					setImgFile(item.sabun, i) ;
				 	$("#item1_"+i).html(item.sabun + "/" + item.name) ;
				 	$("#item2_"+i).html(item.orgNm+"/"+item.jikchakNm) ;
				 	$("#item3_"+i).html(item.appStatusNm) ;
				}
				
				if(data.DATA.length > 0){
					//$(".card-profile").eq(0).trigger("click");
					showEmpDetailContents($("#sabun").val());
				}else{
					showEmpDetailContents('-1')
				}
			}
		} catch (ex) {
			alert("showUserList Event Error : " + ex);
		}
	}	
	
	// 기간조회
	function showSch() {
		try {
			var html = "";
			
			//$("#detailList").html("");
			var data = ajaxCall("${ctx}/AppEval.do?cmd=getOtherEvalDetailPopupSchList", $("#empForm").serialize(), false);
			//console.log('data', data);
			var item = null;
			
			/* 데이터 세팅 */
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					$("#txtSch").html(item.sch);
				}
				$("#txtSch").removeClass("on off");
				$("#txtSch").addClass(item.status);
				
				for (var i=0; i<vaControlId.length; i++) {
					var vsContorlId = vaControlId[i];
					if (item.status == "on") { // 기간및 활성화여부에 따른 입력 컨트롤 활성화
						$("#"+vsContorlId).attr("readonly", false);
						$("#"+vsContorlId).removeClass("transparent");		
						setVisibleBtns($("#appTypeCd").val(),"on")
					} else {
						$("#"+vsContorlId).attr("readonly", true);
						$("#"+vsContorlId).addClass("transparent");
						setVisibleBtns($("#appTypeCd").val(),"off")
					}
				}
			}
			doAction1('Search');
		} catch (ex) {
			alert("showSch Event Error : " + ex);
		}		
	}
	
	function setVisibleBtns(psAppTypeCd, psOnOff) {
		if (psAppTypeCd == "01") {
			if (psOnOff == "on") {
				$("#btnSave,#btnAgree,#btnReject,#btnExcel").show();
			} else {
				$("#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
			}
		} else if(psAppTypeCd == "03") {
			if (psOnOff == "on") {
				$("#btnSave,#btnAgree,#btnReject,#btnExcel").show();
			} else {
				$("#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
			}
		} else if(psAppTypeCd == "05") {
			if (psOnOff == "on") {
				$("#btnSave,#btnAgree,#btnExcel").show();
			} else {
				$("#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
				$("#btnExcel").show();
			}
		}
	}	
	
	//사진파일 적용 by
	function setImgFile(sabun, i){
		$("#photo"+i).attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword="+sabun);
	}
		
	// 선택 임직원의 상세 컨텐츠 출력
	function showEmpDetailContents(sabun) {
		$(".card-profile").each(function(){
			var con = $(this);
			if( con.attr("sabun") == sabun ) {
				con.addClass("choose");
				$("#sabun").val(con.attr("sabun"));
				$("#appTypeCd").val(con.attr("appTypeCd"));
				$("#appSeq").val(con.attr("appSeq"));
				
				vaViewId.forEach(function(el, index, all) {
					$("#"+el).val(con.children("#item_"+el).attr("value"));
				});
				if (con.children("#item_grade")) {
					$("#grade").html(con.children("#item_grade").val());
				}
				//if ($("#divGrade").length > 0) {
				//	$("#grade").html(con.children("#item_grade").val());
				//}
				if (con.children("#item_mid2ndExceMemo").val()  && con.children("#item_mid2ndSuppMemo").val()) { // 2차중간평가 없을시 안보이게 처리
					$("#mid2ndExceMemo").closest("tr").show();
					$("#mid2ndSuppMemo").closest("tr").show();
				} else {
					$("#mid2ndExceMemo").closest("tr").hide();
					$("#mid2ndSuppMemo").closest("tr").hide();
				}
				showSch();
			} else {
				$(this).removeClass("choose");
			}
		});
	}
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "searchText="+$("#searchText").val();
			    sheet1.DoSearch( "${ctx}/AppEval.do?cmd=getOtherEvalDetailPopupItemList", $("#empForm").serialize());
	            break;
			case "Insert":
				sheet1.DataInsert(0);
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param = {DownCols:downcol, SheetDesign:1, Merge:1};
				sheet1.Down2Excel(param);	
				break;
			case "Save":
			case "Agree":
			case "Reject":				
				var btn = sAction == "Save" ? "btnSave" : sAction == "Agree" ? "btnAgree" : sAction == "Reject" ? "btnReject" : "";
				if (!$("#txtSch").hasClass("on")) {
					alert("평가를 할 수 없는 피평가자 입니다.");
					return false;
				}
				if (sAction != "Reject") {
					if (!isRequired()) return false;
				}
				if (!confirm($("#"+btn).html() + "를 진행하시겠습니까?")) return false;
				if (convertParam.appTypeCd == "05") {// 1차평가
					IBS_SaveName(document.empForm,sheet1);
					sheet1.DoSave("${ctx}/AppEval.do?cmd=saveOtherEvalDetailPopup&action="+sAction, $("#empForm").serialize(), 0, 0);
				} else {
					var data = ajaxCall("${ctx}/AppEval.do?cmd=saveOtherEvalDetailPopup&action="+sAction, $("#empForm").serialize(), false)
					if (data) {
						alert(data.Result.Message);
						showUserList();
					}
					
				}
				
				break;
		}
    } 
	
	function isRequired() {
		var returnBool = true;
		var appTypeCd = $("#appTypeCd").val();
		vaControlId.forEach(function(el, index, all) {
			if (!returnBool) return;
			var target = $("#"+el);
			if (target.hasClass("required")) {
				if (target.val() == "") {
					alert($("#"+target.attr("label")).html() + "는 필수입력입니다.");
					target.focus();
					returnBool = false;
				}
			}
		});
		return returnBool;
	}
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg); 
				return;
			}
			
			if($("#appTypeCd").val() == "05") { // 1차평가 첨부파일 없으면 첨부파일 안보이게 
		        var fileSeq = sheet1.GetCellValue(getSheetMinSeqRowIndex(sheet1), "fileSeq");
		        if (fileSeq) {
		        	$("#fileUpload").show();
		        } else {
		        	$("#fileUpload").hide();
		        }
			}
			
			if (convertParam.appTypeCd == "05" && $("#txtSch").hasClass("on")) {
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					//sheet1.SetRowEditable(i, 1);
					sheet1.SetCellEditable(i, "app1stPoint", 1);
				}
			}
			
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	// 클릭 시 
	function sheet1_OnClick(Row, Col, Value, a, b, c) {
		try{
			if (Row < sheet1.GetDataFirstRow() || Row > sheet1.GetDataLastRow()) return false;
			
			if (sheet1.ColSaveName(Col) == "detail") { 
				openPopupGuide({type:"appMidResult", text: "<b>&gt; " + sheet1.GetCellValue(Row, "compNm") + "</b>\n" + sheet1.GetCellValue(Row, "appMidResult")});
			} 
			
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
	
	//<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var Row = NewRow;
			if (Row < sheet1.GetDataFirstRow() || Row > sheet1.GetDataLastRow()) return false;
			if ( OldRow == NewRow ) return;
			$("#infoTitle").html("-" + sheet1.GetCellValue(Row, "compNm") + " 목표수준");
			$("#infoC1").html(sheet1.GetCellValue(Row, "classCont1"));
			$("#infoC2").html(sheet1.GetCellValue(Row, "classCont2"));
			$("#infoC3").html(sheet1.GetCellValue(Row, "classCont3"));
			$("#infoC4").html(sheet1.GetCellValue(Row, "classCont4"));
			$("#infoC5").html(sheet1.GetCellValue(Row, "classCont5"));
			$("#infoC6").html(sheet1.GetCellValue(Row, "classCont6"));
			$("#infoC7").html(sheet1.GetCellValue(Row, "classCont7"));
			
			var height = 0;
			height += $("#divInfo").height();
			height += $("#divHeaderInfo").height();
			$("#layout").css("height", "calc(100% - " + height +"px");
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	function sheet1_OnChange(Row, Col, Value) {
		if ($("#appTypeCd").val() == "05") { // 1차평가
			if (sheet1.ColSaveName(Col) == "app1stPoint") { // 1차평가자 점수 작성시 하단 평균점수 변경
				var firstRow = sheet1.GetDataFirstRow();
				var lastRow	 = sheet1.GetDataLastRow();
				var total = 0;
				for (var i=firstRow; i<=lastRow;i++) {
					var weight = sheet1.GetCellValue(i,"weight");
					if (sheet1.GetCellValue(i,"app1stPoint")) {
						//ROUND(SUM(WEIGHT * (APP_1ST_POINT * 0.01)), 1)
						total += weight * (Number(sheet1.GetCellValue(i,"app1stPoint") * 0.01));
					}
				}
				total = Math.round(total * 10) / 10	 
				$("#grade").html(total);
			}
		}
	}
	
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg);
			}
			showUserList();
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}	
	
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg);
			}
			showUserList();
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	
	function onView(){
		//console.log("searchMenuLayer.jsp onView()");
		
		sheetResize();
		//setTimeout(function(){ sheetResize(); $("#searchText").focus();},100);
	}
	
	function openPopupGuide(poParam) {
		if (poParam.type) {
			var src = "";
			var title = "";
			var width = 0;
			var height = 0;
			var param = convertParam;
			param["type"] = poParam.type;
			if (poParam.type == "guide") {
				width = "60%";
				height = "60%";
				title = "작성가이드";
				param["appTypeCd"] = $("#appTypeCd").val();
				param["appraisalCd"] = $("#appraisalCd").val();
			} else if (poParam.type == "appMidResult") {
				width = "700px";
				height = "400px";
				title = "중간점검"
				param["text"] = poParam["text"];
			}
			src = "AppEval.do?cmd=viewAppGuidePopup";
			var args = {};
			openModalPopup(src, param, width, height
					, function(){}
			, {title:title});
		}
	}
	
	function attachFile(type){
		var param = [];
		var popupType = "";
		
        var fileSeq = sheet1.GetCellValue(getSheetMinSeqRowIndex(sheet1), "fileSeq");
		if (type == "reg") {
			param["fileSeq"] = fileSeq;				
			popupType = "A";
		} else if (type == "mgr") {
			param["fileSeq"] = fileSeq;
			popupType = "R";
		}
		this.openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+popupType+"&uploadType=appEval", param, "740","500");
	}	
	
	//팝업 콜백 함수. 	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}	
	
	// seq가 가장낮은 index값을 찾는다.
	function getSheetMinSeqRowIndex(pSheet) {
		var min = 10000;
		var minIndex = 0;
		for (var i=	pSheet.GetDataFirstRow();i <= pSheet.GetDataLastRow(); i++ ) {
        	var seq = pSheet.GetCellValue(i, "seq");
        	if (seq < min) {
        		min = seq;
        		minIndex = i;
        	}
        }
		return minIndex;
	}
</script>
<style type="text/css">
	#timelineBox {
		display: flex;
		width: 100vw;
		height: 100vh;
	}

	.sheet_search, .cbp_tmtimeline * {
		box-sizing:initial;
	}
	
	#detailList {
		background-color:#f7f7f7;
		padding:0px;
		border:0px solid #ebeef3;
		overflow-x:hidden;
		overflow-y:auto;
		min-width:200px;
		height: calc(100vh - 36px);
	}
	
	.tile-stats.card-profile {
		padding:0px;
		cursor:pointer;
		display: flex;
		font-weight: normal;
	}
	
	.tile-stats.card-profile.choose {
		background-color:#fad5e6;
		font-weight: bold;
	}
	
	.tile-stats.card-profile .profile_info {
		width:calc(100% - 81px);
	}
	
	.tile-stats.card-profile .profile_info .profile_desc {
		width:100%;
	}
	
	.profile_desc {
		margin-left: 20px;
		margin-top: 5px;
	}
	
	.profile_desc>li {
		margin-bottom: 2px;
	}
	
	.tile-stats.card-profile .profile_info .profile_desc li.full {
		width:100%;
	}
	
	.tile-stats.card-profile .profile_img img {
		width:50px;
		height:60px;
	}
	
	.table tr:eq(1) tr:eq(0) th {
		text-align: center;
	}
	
	#divSch {
		display: flex;
	}
	
	#txtSch {
		color: #495057;
		font-weight: bold;
		margin-left: auto;
		/*justify-content: flex-end;*/
	}
	
	#divContent {
		height: calc(100vh - 23px);
	}
	
	#txtSch.on {
		color: red;
		animation: blink-effect 1s step-end infinite;
	}
	@keyframes blink-effect {
    50%{
        opacity:0.5;
    	}
	}
	
	span.required::before {
		content: '* ';
	    color: red;
	}
	
	.resizeVertical { 
		resize: vertical;
		overflow: hidden;
		display: flow;
		/*
		overflow-x: auto; 
		overflow-y: hidden;
		*/
	}
	
</style>
</head>
<body>
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" id="searchYmd" name="searchYmd" value="${ curSysYyyyMMdd }" />
		<input type="hidden" id="sabun" name="sabun"/>
		<input type="hidden" id="appSabun" name="appSabun"/>
		<input type="hidden" id="appTypeCd" name="appTypeCd"/>
		<input type="hidden" id="stepCd" name="stepCd"/>
		<input type="hidden" id="appraisalCd" name="appraisalCd"/>
		<input type="hidden" id="appGroupCd" name="appGroupCd"/>
		<input type="hidden" id="appSeq" name="appSeq"/>
		<div id="timelineBox" border="0" cellspacing="0" cellpadding="0" class="">
			<div>
				<div name="detailHeader" id="detailHeader" class="sheet_title">
				<ul>
					<li name="txtList" id="txtList" class="txt">임직원</li>
					<li class="btn"></li>
				</ul>
				</div>
				<div name="detailList" id="detailList" class="list_box">
				</div>
			</div>
			<div name="divContent" id="divContent" class="list_box" style="border:1px solid #ebeef3; padding:10px;;">
				<table id="divInfo" class="table" style="padding-right: 0px; border: none; ">
				<colgroup>
					<col width="100%">
				</colgroup>
					<tr>
						<td style="border-bottom:none;">
								<span style="font-size: 13px; float: left; margin-top: 5px;"><b id="infoTitle">- 목표수준</b></span>
								<ul style="">
									<li class="btn" style="float: right;">
										<span name="txtSch" id="txtSch"></span>
										<!-- <a href="javascript:doAction1('Search')" class="basic">조회</a> -->
										<a href="javascript:openPopupGuide({'type':'guide'})" class="basic">작성가이드</a>
										<a style="display: none;" href="javascript:doAction1('Save')" id="btnSave" class="basic pink">임시저장</a>
										<a style="display: none;" href="javascript:doAction1('Agree')" id="btnAgree" class="basic pink">합의</a>
										<a style="display: none;" href="javascript:doAction1('Reject')" id="btnReject" class="basic pink">반려</a>
										<a style="display: none;" href="javascript:doAction1('Down2Excel')" id="btnExcel" class="basic" hide>다운로드</a>
									</li>
								</ul>
						</td>
					</tr>
					<tr>
						<td style="padding-right: 0px; width:100%;">
							<table class="tableInfo" style="border: 1.1px solid #b7dee8; width:100%;">
							<colgroup>
								<col width="14%">
								<col width="14%">
								<col width="14%">
								<col width="14%">
								<col width="14%">
								<col width="14%">
								<col width="*">
							</colgroup>
								<tr>
									<th style="text-align: center; font-size:12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH1">100~96<br/>(목표 초과 달성)</span></th>
									<th style="text-align: center; font-size:12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH2">95~90<br/>(목표 달성)</span></th>
									<th style="text-align: center; font-size:12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH3">89~86<br/>(현상 유지)</span></th>
									<th style="text-align: center; font-size:12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH4">85~83</span></th>
									<th style="text-align: center; font-size:12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH5">82~80<br/>(현상 유지)</span></th>
									<th style="text-align: center; font-size:12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH6">79~70<br/>(미흡)</span></th>
									<th style="text-align: center; font-size:12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH7">69~60<br/>(매우미흡)</span></th>
								</tr>
								<tr>
									<th style="line-height:12px; font-size:12px; font-weight: normal; padding:2px 3px;"><span id="infoC1">주요 현안 및 추진과제 수행실적이 귀감이 되고 타 조직 파급효과 지대</span></th>
									<th style="line-height:12px; font-size:12px; font-weight: normal; padding:2px 3px;"><span id="infoC2">주요 현안 및 추진과제 성공적으로 수행 완료</span></th>
									<th style="line-height:12px; font-size:12px; font-weight: normal; padding:2px 3px;"><span id="infoC3">업무의 성실한 수행으로 업무공백 최소화</span></th>
									<th style="line-height:12px; font-size:12px; font-weight: normal; padding:2px 3px;"><span id="infoC4" >업무의 성실한 수행으로 업무공백 최소화</span></th>
									<th style="line-height:12px; font-size:12px; font-weight: normal; padding:2px 3px;"><span id="infoC5">업무의 성실한 수행으로 업무공백 최소화</span></th>
									<th style="line-height:12px; font-size:12px; font-weight: normal; padding:2px 3px;"><span id="infoC6">업무 수행 미진으로 업무공백 발생</span></th>
									<th style="line-height:12px; font-size:12px; font-weight: normal; padding:2px 3px;"><span id="infoC7">업무 수행 미진 및 공백 발생으로 구체적인 사손 초래</span></th>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<div id="layout" style="overflow-y:auto; height: calc(100% - 108px)">
					<div style="overflow-y:none;">
						<table border="0" cellspacing="0" cellpadding="0" style="" class="sheet_main">
							<tr>
								<td style="" class="resizeVertical">
									<div>
										<div class="sheet_title">
											<ul>
												<li id="txt" class="txt">목표상세내역</li>
												<li id="sheet_btn" class="btn" hide>
													<!-- <a href="javascript:doAction1('Search')" class="basic">조회</a> -->
												</li>
											</ul>
										</div>
									</div>
									<script type="text/javascript">createIBSheet("sheet1", "100%", "40%","${ssnLocaleCd}"); </script>
								</td>
							</tr>
						</table>	
					</div>
					<table id="fileUpload" border="0" cellpadding="0" cellspacing="0" class="table" style="display:none;">
						<colgroup>
				            <col width="100px" />
				            <col width="80px" />
				            <col width="" />
						</colgroup>
						<tr>
							<th colspan=2>첨부파일</th>
							<td>
								<span id="filebtn"><btn:a href="javascript:attachFile('mgr');" css="basic" mid='attachFile' mdef="첨부파일"/></span>
							</td>
						</tr>
					</table>
					<div>
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">종합의견</li>
							</ul>
						</div>
						<table name="tableInfo" id="tableInfo" border="0" cellpadding="0" cellspacing="0" class="default">
							<colgroup>
								<col width="12%" />
								<col width="12%" />
								<col width="*" />
							</colgroup>
						</table>
					</div>	
				</div>				
			</div>
		</div>
	</form>
</div>
</body>
</html>



