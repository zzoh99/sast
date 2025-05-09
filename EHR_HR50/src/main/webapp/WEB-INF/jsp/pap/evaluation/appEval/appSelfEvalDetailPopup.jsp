<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>타인평가상세팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var param = {};	
	var convertParam = {};
	var vaViewIds;
	
	$(function() {
		//$("#detailList").css("height", window.innerHeight - 40);
		//$("#detailList").css("height", "95vh");
	})
	
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		var appStatus = convertParam.appStatus;
		var html = "";
		$("#btnExcel,#finInfo").hide();
		if (appStatus == "A0") {
			$("#btnAgree").html("합의요청");
			vaViewIds = ["appSelfMemo"];
			html += makeContainer(1, ["1차 합의자"], ["appSelfMemo"]);
		} else if (appStatus == "D0") {
			$("#btnAgree").html("중간점검제출");
			html += makeContainer(1, ["1차 합의자"], ["appSelfMemo"]);
			vaViewIds = ["appSelfMemo", "mid1stExceMemo", "mid1stSuppMemo", "mid2ndExceMemo", "mid2ndSuppMemo"];
			html += makeContainer(2, ["1차 중간점검자", "우수사항", "보완사항"], ["mid1stExceMemo", "mid1stSuppMemo"]);
			html += makeContainer(2, ["2차 중간점검자", "우수사항", "보완사항"], ["mid2ndExceMemo", "mid2ndSuppMemo"]);
		} else if (appStatus == "C0") {
			$("#btnAgree").html("평가완료");
			$("#txtTotal").hide();
			$("#fileUpload").show();
			vaViewIds = [];
			//vaViewIds = ["appSelfMemo", "mid1stExceMemo", "mid1stSuppMemo", "mid2ndExceMemo", "mid2ndSuppMemo", "app1stExceMemo", "app1stSuppMemo","grade"];
			//html += makeContainer(1, ["1차 합의자"], ["appSelfMemo"]);
			//html += makeContainer(2, ["1차 중간점검자", "우수사항", "보완사항"], ["mid1stExceMemo", "mid1stSuppMemo"]);
			//html += makeContainer(2, ["2차 중간점검자", "우수사항", "보완사항"], ["mid2ndExceMemo", "mid2ndSuppMemo"]);
			//html += makeContainer(2, ["1차 평가자", "우수사항", "보완사항"], ["app1stExceMemo", "app1stSuppMemo"]);
		} else if (appStatus == "G0") {
			$(".sheet_main").hide();
			$("#divInfo").hide();
			$("#finInfo").show();
			$("#btnAgree").html("평가완료");
			vaViewIds = ["appSelfMemo", "mid1stExceMemo", "mid1stSuppMemo", "mid2ndExceMemo", "mid2ndSuppMemo", "app1stExceMemo", "app1stSuppMemo", "app2ndExceMemo", "app2ndSuppMemo"];
			html += makeContainer(1, ["1차 합의자"], ["appSelfMemo"]);
			html += makeContainer(2, ["1차 중간점검자", "우수사항", "보완사항"], ["mid1stExceMemo", "mid1stSuppMemo"]);
			html += makeContainer(2, ["2차 중간점검자", "우수사항", "보완사항"], ["mid2ndExceMemo", "mid2ndSuppMemo"]);
			html += makeContainer(2, ["1차 평가자", "우수사항", "보완사항"], ["app1stExceMemo", "app1stSuppMemo"]);
			html += makeContainer(2, ["2차 평가자", "우수사항", "보완사항"], ["app2ndExceMemo", "app2ndSuppMemo"]);
		} else if (appStatus == "07") {
			$(".btn").hide();
			$("#btnAgree").html("평가완료");
			//$("#layout").css("height", "calc(100% - 196px)");
			vaViewIds = ["appSelfMemo", "mid1stExceMemo", "mid1stSuppMemo", "mid2ndExceMemo", "mid2ndSuppMemo", "app1stExceMemo", "app1stSuppMemo", "app2ndExceMemo", "app2ndSuppMemo"];
			html += makeContainer(1, ["1차 합의자"], ["appSelfMemo"]);
			html += makeContainer(2, ["1차 중간점검자", "우수사항", "보완사항"], ["mid1stExceMemo", "mid1stSuppMemo"]);
			html += makeContainer(2, ["2차 중간점검자", "우수사항", "보완사항"], ["mid2ndExceMemo", "mid2ndSuppMemo"]);
			html += makeContainerAddGrade(2, ["1차 평가자", "우수사항", "보완사항"], ["app1stExceMemo", "app1stSuppMemo"]);
			html += makeContainer(2, ["2차 평가자", "우수사항", "보완사항"], ["app2ndExceMemo", "app2ndSuppMemo"]);
		} 
		html += ""
		$("#tableInfo").html(html);
		$("#divGrade").hide(); //점수박스 (평가)
		
		
		$("#sabun").val(convertParam.sabun)
		$("#appSabun").val(convertParam.appSabun);
		$("#stepCd").val(convertParam.stepCd);
		$("#appStatus").val(convertParam.appStatus);
		$("#appraisalCd").val(convertParam.appraisalCd);
		$("#appGroupCd").val(convertParam.appGroupCd);
		$("#appSeq").val(convertParam.appSeq);
		
		var title = param.title + "|" + param.title;
		var initdata = {};
		initdata.Cfg = {SizeMode:1,FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:1, 	Width:0,	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",    		Type:"${sDelTy}",	Hidden:$("#appStatus").val() == "A0"?0:1,	
																		Width:45,			Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0,		UpdateEdit:0,	InsertEdit:1},
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택|선택",			Type:"DummyCheck",	Hidden:1, 	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"chk",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"지표|지표",								Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"compGrpNm",	KeyField:1,				UpdateEdit:0,	InsertEdit:0,		EditLen:100, Wrap:1},
			{Header:"목표업무(평가항목)|목표업무(평가항목)",	Type:"Text",		Hidden:0,		Width:100,	Align:"Left",	ColMerge:0,	SaveName:"compNm",		KeyField:1,				UpdateEdit:0,	InsertEdit:1,		EditLen:100},
			
			{Header:"항목1",	Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont1",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목2",	Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont2",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목3",	Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont3",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목4",	Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont4",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목5",	Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont5",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목6",	Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont6",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"항목7",	Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"classCont7",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"", Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sabun",			KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"", Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"",	Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"seq",				KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
		];
		if (appStatus == "A0") {
			initdata.Cols.push({Header:"행동지표(세부내용)|행동지표(세부내용)",	Type:"Text",		Hidden:0,		Width:500,	Align:"Left",  ColMerge:0, SaveName:"mboTarget",	KeyField:1,				UpdateEdit:0,	InsertEdit:1,		MultiLineText:1,	Wrap:1});
			initdata.Cols.push({Header:"비중|비중",								Type:"AutoSum",	  	Hidden:0,  		Width:80,	Align:"Right", ColMerge:0, SaveName:"weight",		KeyField:1,   			CalcLogic:"",   Format:"",			PointCount:1,   UpdateEdit:0,   InsertEdit:1,	MaximumValue:50, MinimumValue:5});
			initdata.Cols.push({Header:"순서|순서",								Type:"Int",	  		Hidden:0,  		Width:80,	Align:"Right", ColMerge:0, SaveName:"orderSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1});
		} else if (appStatus == "D0") {
			initdata.Cols.push({Header:"행동지표(세부내용)|행동지표(세부내용)",	Type:"Text",		Hidden:0,		Width:350,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1,	Wrap:1});
			initdata.Cols.push({Header:"중간실적|중간실적",						Type:"Text",		Hidden:0,		Width:350,	Align:"Left",	ColMerge:0,	SaveName:"appMidResult",KeyField:1,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1,	Wrap:1});
			initdata.Cols.push({Header:"자기평가점수|자기평가점수",				Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appSelfPointMid",KeyField:1,				CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:5, 	MaximumValue:100, MinimumValue:60});
			initdata.Cols.push({Header:"비중|비중",								Type:"AutoSum",	  	Hidden:0,  		Width:50,	Align:"Right", 	ColMerge:0, SaveName:"weight",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:1,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 });
		} else if (appStatus == "C0") {
			initdata.Cols.push({Header:"세부내용|세부내용",						Type:"Text",		Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1});
			initdata.Cols.push({Header:"실적|실적",								Type:"Text",		Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"appFinResult",KeyField:1,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1});
			initdata.Cols.push({Header:"중간실적|중간실적",						Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appMidResult",KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1});
			initdata.Cols.push({Header:"중간점검|중간점검",						Type:"Image",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,				Cursor:"Pointer" });
			initdata.Cols.push({Header:"자기평가점수|자기평가점수",				Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appSelfPoint",KeyField:1,				CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MaximumValue:100, MinimumValue: 60});
			initdata.Cols.push({Header:"비중|비중",								Type:"AutoSum",	  	Hidden:0,  		Width:30,	Align:"Right", 	ColMerge:0, SaveName:"weight",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:1,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 });
			initdata.Cols.push({Header:"",										Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		} else if (appStatus == "07") {
			initdata.Cols.push({Header:"세부내용|세부내용",						Type:"Text",		Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1,	Wrap:1});
			initdata.Cols.push({Header:"실적|실적",								Type:"Text",		Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"appFinResult",KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1,	Wrap:1});
			initdata.Cols.push({Header:"중간실적|중간실적",						Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appMidResult",KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"중간점검|중간점검",						Type:"Image",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,				Cursor:"Pointer" });
			initdata.Cols.push({Header:"비중|비중",								Type:"AutoSum",	  	Hidden:0,  		Width:30,	Align:"Right", 	ColMerge:0, SaveName:"weight",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:1,   UpdateEdit:0,   InsertEdit:0,   EditLen:5 });
			initdata.Cols.push({Header:"점수|본인 평가",						Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appSelfPoint",KeyField:0,				CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MaximumValue:100, MinimumValue: 0});
			initdata.Cols.push({Header:"점수|1차 평가자",						Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stPoint", KeyField:0,				CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MaximumValue:100, MinimumValue: 0});
			initdata.Cols.push({Header:"",										Type:"Text",		Hidden:1,		Width:0,	Align:"Left",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,				UpdateEdit:0,	InsertEdit:0});
		}
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(0);sheet1.SetUnicodeByte(3);
		//sheet1.FocusAfterProcess = false;
		//sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		//sheet1.FitColWidth();
        
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);
		sheet1.SetEditArrowBehavior(0);
		$(window).smartresize(sheetResize); sheetInit();
		
		//var param = '${Param}';
		showUserList();
	});
	
	function makeContainer(pnDepth, paDivName, paDivId) {
		var html = "";
		if (pnDepth == 1) {
			html += '<tr>'
			html +=	'	<th colspan="2"><span id="label_' + paDivId[0] + '" class="required">'+paDivName[0]+'</span></th>'
			html +=	'	<td>'
			html +=	'		<textarea id="'+paDivId[0]+'" name="'+paDivId[0]+'" label="label_'+paDivId[0]+'" rows="4" class="${textCss} w90p required" ${readonly}  maxlength="4000"></textarea>'
			html += '	</td>'
			html += '</tr>'
		} else if (pnDepth == 2) {
			html += '<tr>'
			html += '	<th rowspan="2" style="width:100px"><span class="required">'+paDivName[0]+'</span></th>'
			html += '	<th style="width:100px"><span id="label_' + paDivId[0] + '" class="required">'+paDivName[1]+'</th>'
			html += '	<td>'
			html +=	'		<textarea id="'+paDivId[0]+'" name="'+paDivId[0]+'" label="label_'+paDivId[0]+'" rows="4" class="${textCss} w90p required" ${readonly}  maxlength="4000"></textarea>'
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
			var data = ajaxCall("${ctx}/AppEval.do?cmd=getSelfEvalDetailPopupUserList", $("#empForm").serialize(), false);
			//console.log('data', data);
			
			var item = null;
			var key = null; 
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					$("#infoSabunName").html(item.sabun + "/" + item.name);
					$("#infoOrgNm").html(item.orgNm);
					$("#infoAppStatus").html(item.appStatusNm);
					//$("#finInfo")
					for (var i=0; i<vaViewIds.length; i++) {
						var vsViewId = vaViewIds[i];
						$("#"+vsViewId).val(item[vsViewId]);
					}
					if ($("#appStatus").val() == "D0" || $("#appStatus").val() == "G0" || $("#appStatus").val() == "07") {
						Object.keys(item).forEach(function(key) {
							$("#finInfo tr td#"+key).html(item[key]);
							if (!item["mid2ndExceMemo"] && !item["mid2ndSuppMemo"]) { // 2차중간평가 없을시 안보이게 처리
								$("#mid2ndExceMemo").closest("tr").hide();
								$("#mid2ndSuppMemo").closest("tr").hide();
							}
						});
					}
				
					if ($("#appStatus").val() == "07") {
						$("#grade").html(item["grade"]);
					}
				}
			}
			$("#empForm").prepend(html);
			
			showSch()
		} catch (ex) {
			progressBar(false);
			alert("showUserList Event Error : " + ex);
		}
	}	
	
	// 기간조회
	function showSch() {
		try {
			var html = "";
			//$("#detailList").html("");
			var data = ajaxCall("${ctx}/AppEval.do?cmd=getSelfEvalDetailPopupSchList", $("#empForm").serialize(), false);
			//console.log('data', data);
			var item = null;
			
			/* 데이터 세팅 */
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for( var i = 0; i < data.DATA.length; i++) {
					item = data.DATA[i];
					$("#txtSch").html(item.sch);
				}
				$("#txtSch").removeClass("on off");
				if (item != null) {
					$("#txtSch").addClass(item.status);
				}
				
				if (item && item.status == "on") { // 기간및 활성화여부에 따른 입력 컨트롤 활성화
					setVisibleBtns($("#appStatus").val(),"on")
				
					if ($("#appStatus").val() == "C0") {
						$("#filebtn > a").each(function(index) {
							$(this).attr("href", "javascript:attachFile('reg');");
						})
					}
				} else {
					setVisibleBtns($("#appStatus").val(),"off")
					$("#filebtn > a").each(function(index) {
						$(this).attr("href", "javascript:attachFile('mgr');");
					}) 
				}
				doAction1("Search");
			}
		} catch (ex) {
			alert("showSch Event Error : " + ex);
		}		
	}
	
	function setVisibleBtns(psAppStatus, psOnOff) {
		if (psAppStatus == "A0") {
			if (psOnOff == "on") {
				$("#btnInsert,#btnSave,#btnAgree").show();
			} else {
				$("#btnInsert,#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
			}
		} else if(psAppStatus == "D0") {
			if (psOnOff == "on") {
				$("#btnSave,#btnAgree,#btnExcel,#btnUpdate").show();
			} else {
				$("#btnInsert,#btnSave,#btnAgree,#btnReject,#btnExcel,#btnUpdate").hide();
			}
		} else if(psAppStatus == "C0") {
			if (psOnOff == "on") {
				$("#btnSave,#btnAgree,#btnExcel").show();
			} else {
				$("#btnInsert,#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
			}
		} else if(psAppStatus == "G0") {
			if (psOnOff == "on") {
				$("#btnInsert,#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
			} else {
				$("#btnInsert,#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
			}
		} else if(psAppStatus == "07") {
			if (psOnOff == "on") {
				$("#btnInsert,#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
			} else {
				$("#btnInsert,#btnSave,#btnAgree,#btnReject,#btnExcel").hide();
			}
		}
	}
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				//var param = "searchText="+$("#searchText").val();
			    sheet1.DoSearch( "${ctx}/AppEval.do?cmd=getSelfEvalDetailPopupItemList", $("#empForm").serialize());
	            break;
			case "Insert":
	        	var Row = sheet1.DataInsert(sheet1.LastRow() + 1);     	
	            var max = 0;
	            for (var i=sheet1.GetDataFirstRow();i <= sheet1.GetDataLastRow(); i++ ) {
	            	var s = sheet1.GetCellValue(i, "orderSeq");
	            	if (s > max) {
	            		max = s;
	            	}
	            }
	            sheet1.SetCellValue(Row, "compGrpNm", "성과지표");
	            sheet1.SetCellValue(Row, "orderSeq", max + 1);
	            sheet1.SetCellValue(Row, "appraisalCd", $("#appraisalCd").val());
	            sheet1.SetCellValue(Row, "sabun", $("#sabun").val());
	            var data = ajaxCall("${ctx}/AppEval.do?cmd=getAppSelfEvalAppClassList", $("#empForm").serialize(), false);
				var item = null;
				
				/* 데이터 세팅 */
				if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
					for( var i = 0; i < data.DATA.length; i++) {
						item = data.DATA[i];
			            sheet1.SetCellValue(Row, item.classCont, item.note);
					}
				}
				sheet1.SetSelectRow(-1);
				sheet1.SelectCell(Row, "compNm");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param = {DownCols:downcol, SheetDesign:1, Merge:1};
				sheet1.Down2Excel(param);	
				break;
			case "Update":
				if (!$("#txtSch").hasClass("on")) {
					alert("평가를 수정할 수 없는 사용자입니다.");
					return false;
				}
				if (!confirm("목표를 수정하시겠습니까?\n진행상태가 목표작성 상태로 돌아 갑니다.")) return false;
				IBS_SaveName(document.empForm,sheet1); 
				sheet1.DoSave("${ctx}/AppEval.do?cmd=saveSelfEvalDetailPopup&action="+sAction, $("#empForm").serialize(), 0, 0);
				break;
			case "Save":
			case "Agree":
			case "Reject":	
				var btn = sAction == "Save" ? "btnSave" : sAction == "Agree" ? "btnAgree" : "btnReject";
				if (!$("#txtSch").hasClass("on")) {
					alert("평가를 수정할 수 없는 사용자입니다.");
					return false;
				}
				
				if (!confirm($("#"+btn).html() + "을(를) 진행하시겠습니까?")) return false;
				
				if (convertParam.appStatus == "A0") {
					if(sheet1.FindStatusRow("I|U") != ""){
						if (!dupChk(sheet1, "compGrpNm|compNm", false, true)) {break;}
					}
					
					if (sAction == "Agree") {
						var total = 0;
						for (var i=sheet1.GetDataFirstRow();i <= sheet1.GetDataLastRow(); i++ ) {
							if (sheet1.GetCellValue(i, "sStatus") == "D") continue;
			            	total += sheet1.GetCellValue(i, "weight");
			            }
						if (total != 100) {
							alert("비중 합계를[100]으로 조정하십시오.");
							return false;
						} 
					}
				}
				/*
				if (convertParam.appStatus == "05") {
					IBS_SaveName(document.empForm,sheet1);
					sheet1.DoSave("${ctx}/AppEval.do?cmd=saveOtherEvalDetailPopup&action="+sAction, $("#empForm").serialize(), 0, 0);
				} 
				*/
				IBS_SaveName(document.empForm,sheet1);     
				
				sheet1.DoSave("${ctx}/AppEval.do?cmd=saveSelfEvalDetailPopup&action="+sAction, $("#empForm").serialize(), 0, 0);
				break;
		}
    } 
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg); 
			}
			var appStatus = convertParam.appStatus;
			if ($("#txtSch").hasClass("on")) {
				for(var i = sheet1.GetDataFirstRow(); i <= sheet1.GetDataLastRow() ; i++) {
					//sheet1.SetRowEditable(i, 1);
					if (appStatus == "A0") {
						sheet1.SetCellEditable(i, "weight", 1);
						if (sheet1.GetCellValue(i, "compGrpNm") == "성과지표") {
							sheet1.SetCellEditable(i, "sDelete", 1);
							sheet1.SetCellEditable(i, "compNm", 1);
							sheet1.SetCellEditable(i, "mboTarget", 1);
							sheet1.SetCellEditable(i, "orderSeq", 1);
						}
					} else if (appStatus == "D0") {
						sheet1.SetCellEditable(i, "appMidResult", 1);
						sheet1.SetCellEditable(i, "appSelfPointMid", 1);
					} else if (appStatus == "C0") {
						sheet1.SetCellEditable(i, "appFinResult", 1);
						sheet1.SetCellEditable(i, "appSelfPoint", 1);
					}
				}
			}
			if (appStatus == "07") {
				var fileSeq = sheet1.GetCellValue(getSheetMinSeqRowIndex(sheet1), "fileSeq");
				if (fileSeq) {
					$("#fileUpload").show();
				} else {
					$("#fileUpload").hide();
				}
				
			}
			sheetResize();
			sheet1.FitColWidth();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	// 클릭 시 
	function sheet1_OnClick(Row, Col, Value, a, b, c) {
		try{
			if (Row < sheet1.GetDataFirstRow() || Row > sheet1.GetDataLastRow()) return false;
			$("#infoTitle").html("-" + sheet1.GetCellValue(Row, "compNm") + " 목표수준");			
			$("#infoC1").html(sheet1.GetCellValue(Row, "classCont1"));
			$("#infoC2").html(sheet1.GetCellValue(Row, "classCont2"));
			$("#infoC3").html(sheet1.GetCellValue(Row, "classCont3"));
			$("#infoC4").html(sheet1.GetCellValue(Row, "classCont4"));
			$("#infoC5").html(sheet1.GetCellValue(Row, "classCont5"));
			$("#infoC6").html(sheet1.GetCellValue(Row, "classCont6"));
			$("#infoC7").html(sheet1.GetCellValue(Row, "classCont7"));
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
			height += $("#divHeaderInfo").height();
			height += $("#appStatus").val() == "G0" ? $("#finInfo").height() : $("#divInfo").height();
			$("#layout").css("height", "calc(100% - " + height +"px");
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg);
			}
			if (Code == 99) {
				getParentFrame(this).closePopup(this);
				//종료후 후처리함수에 의한 처리 테스트
				//debugger
				//getParentFrame(this).closePopup(this, function() {
				//	debugger
				//	var appStatus = "A0";                            
				//	var title = "목표작성";                              
				//	var src = "";                                    
				//	var height = "";                                 
				//	var width = "";                                  
				//	var calFunc;                                     
				//	var param = {                                    
				//			//appTypeCd: appTypeCd,                  
				//			sabun: $("#sabun").val(),                
				//			title: title,                            
				//			appraisalCd: $("#appraisalCd").val(),    
				//			appStatus: appStatus                     
				//	}                                                
				//	src = "AppEval.do?cmd=viewAppSelfEvalDetailPopup"
				//	width = "99%";                                   
				//	height= "90%";                                   
				//	calFunc = function(window){      
				//		debugger
				//		window.top.frames[2].makeSelfEval();         
				//		window.top.frames[2].makeOtherEval();        
				//	}                       
				//	window.top.frames[2].openModalPopup(src, param, width, height         
				//			, calFunc                                
				//	, {title:title});                                					
				//});
			} else {
				showUserList();
			}
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
			} else if (poParam.type == "appMidResult") {
				width = "700px";
				height = "300px";
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
		var minIndex = getSheetMinSeqRowIndex(sheet1);
		if(rv["fileCheck"] == "exist"){
			
	        sheet1.SetCellValue(minIndex, "fileSeq", rv["fileSeq"]);
		}else{
			sheet1.SetCellValue(minIndex, "fileSeq", "");
		}
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
		height: 100%;
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
		min-width: 400px;
		border:1px solid #ebeef3; 
		padding:10px; 
		height:calc(100% - 25px);
		width:100%;
		display: flow;
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
	}
	
	
	#divHeaderInfo tr th {
		text-align:center;
	}
	
	.tableTarget {
		width: 100%;
		min-height: 65px;  
	}
	
	table#tableFinInfo tr th {
		width: 100px;
	}
	
</style>
</head>
<body>
<div class="wrapper">
	<form id="empForm" name="empForm" style="height:100%;">
		<input type="hidden" id="searchYmd" name="searchYmd" value="${ curSysYyyyMMdd }" />
		<input type="hidden" id="sabun" name="sabun"/>
		<input type="hidden" id="appStatus" name="appStatus"/>
		<input type="hidden" id="appraisalCd" name="appraisalCd"/>
		<div id="timelineBox" border="0" cellspacing="0" cellpadding="0" class="">
			<div name="divContent" id="divContent" class="list_box" style="">
				<table name="divHeaderInfo" id="divHeaderInfo" class="table" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="12%" />
						<col width="*" />
						<col width="12%" />
						<col width="*" />
						<col width="12%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>사번/성명</th><td id="infoSabunName"></td>
						<th>조직</th><td id="infoOrgNm"></td>
						<th>진행상태</th><td id="infoAppStatus"></td>
					</tr>
				</table>				
				<table id="divInfo" class="table" style="padding-right: 0px; border: none;">
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
										<a style="display:none;" href="javascript:doAction1('Update')" id="btnUpdate" class="basic pink">목표수정</a>
										<a style="display:none;" href="javascript:doAction1('Insert')" id="btnInsert" class="basic">추가</a>
										<a style="display:none;" href="javascript:doAction1('Save')" id="btnSave" class="basic pink">임시저장</a>
										<a style="display:none;" href="javascript:doAction1('Agree')" id="btnAgree" class="basic pink">합의</a>
										<a style="display:none;" href="javascript:doAction1('Reject')" id="btnReject" class="basic pink">반려</a>
										<a style="display:none;" href="javascript:doAction1('Down2Excel')" id="btnExcel" class="basic" hide>다운로드</a>
									</li>
								</ul>
						</td>
					</tr>
					<tr>
						<td style="padding-right: 0px;">
							<table class="tableTarget" style="border: 1.1px solid #b7dee8;">
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
									<th style="text-align: center; font-size: 12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH1">100~96<br/>(목표 초과 달성)</span></th>
									<th style="text-align: center; font-size: 12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH2">95~90<br/>(목표 달성)</span></th>
									<th style="text-align: center; font-size: 12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH3">89~86<br/>(현상 유지)</span></th>
									<th style="text-align: center; font-size: 12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH4">85~83</span></th>
									<th style="text-align: center; font-size: 12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH5">82~80<br/>(현상 유지)</span></th>
									<th style="text-align: center; font-size: 12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH6">79~70<br/>(미흡)</span></th>
									<th style="text-align: center; font-size: 12px; line-height:10px; font-weight: normal; padding:2px 3px;"><span id="infoH7">69~60<br/>(매우미흡)</span></th>
								</tr>
								<tr>
									<th style="line-height:12px; font-size: 12px; font-weight: normal; padding:2px 3px;"><span id="infoC1">주요 현안 및 추진과제 수행실적이 귀감이 되고 타 조직 파급효과 지대</span></th>
									<th style="line-height:12px; font-size: 12px; font-weight: normal; padding:2px 3px;"><span id="infoC2">주요 현안 및 추진과제 성공적으로 수행 완료</span></th>
									<th style="line-height:12px; font-size: 12px; font-weight: normal; padding:2px 3px;"><span id="infoC3">업무의 성실한 수행으로 업무공백 최소화</span></th>
									<th style="line-height:12px; font-size: 12px; font-weight: normal; padding:2px 3px;"><span id="infoC4" >업무의 성실한 수행으로 업무공백 최소화</span></th>
									<th style="line-height:12px; font-size: 12px; font-weight: normal; padding:2px 3px;"><span id="infoC5">업무의 성실한 수행으로 업무공백 최소화</span></th>
									<th style="line-height:12px; font-size: 12px; font-weight: normal; padding:2px 3px;"><span id="infoC6">업무 수행 미진으로 업무공백 발생</span></th>
									<th style="line-height:12px; font-size: 12px; font-weight: normal; padding:2px 3px;"><span id="infoC7">업무 수행 미진 및 공백 발생으로 구체적인 사손 초래</span></th>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<div id="finInfo" style="display:none;">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">피드백</li>
						</ul>
					</div>
					<table name="tableFinInfo" id="tableFinInfo" border="0" cellpadding="0" cellspacing="0" class="default">
						<tr>
							<th>소속</th><td id="orgNm" colspan="6"></td>
						</tr>
						<tr>
							<th>직책</th><td id="jikchakNm" ></td><th>직위</th><td id="jikweeNm" ></td><th>성명</th><td id="name" ></td>
						</tr>
						<tr>
							<th>평가등급</th><td id="finClassCd" colspan="6"></td>
						</tr>
						<tr>
							<th>1차평가자</th><td id="appName1" ></td><th >2차평가자</th><td id="appName2" colspan="5"></td>
						</tr>	
					</table>
				</div>
				<div id="layout" style="overflow-y:auto; height:calc(100% - 140px);">
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
								<li id="txtTotal" class="txt">종합의견</li>
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



