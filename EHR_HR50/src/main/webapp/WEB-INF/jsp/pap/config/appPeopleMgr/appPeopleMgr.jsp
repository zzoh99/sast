<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가대상자생성/관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var vSearchEvlYy = "";
	var gPRow = "";
	var pGubun = "";

	$(function() {
		//평가명 변경 시
		$("#searchAppraisalCd").bind("change",function(event){
			setSearchClear(); //셋팅값 clear
			var appStepCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppStepCdList&searchAppraisalCd=" + $(this).val(),false).codeList, "");
			try{
				if ( appStepCdList == false ){
					$("#searchAppStepCd").html("<option value=''>선택하세요</option>");
				}else if( appStepCdList[1] == "" || appStepCdList[1].split("|").length == 1){
					$("#searchAppStepCd").html(appStepCdList[2]);
					$("#searchAppStepCd").change();

				}else{
					$("#searchAppStepCd").html("<option value=''>선택하세요</option>"+appStepCdList[2]);
				}
				
				$("#btnComp").hide();
				
				// 평가구분에 따른 업적,역량평가대상자여부 컬럼 출력 여부 설정
				var appTypeCd = $(this).val().substring(2,3);
				if( appTypeCd == "C" ){			// 종합평가
					// 화면 출력
					sheet1.SetColHidden("mboTargetYn", 0);
					sheet1.SetColHidden("compTargetYn", 0);
				} else if( appTypeCd == "A" ) {	// 성과평가
					// 화면 출력
					sheet1.SetColHidden("mboTargetYn", 1);
					sheet1.SetColHidden("compTargetYn", 1);
				} else if( appTypeCd == "B" ) {	// 역량평가
					// 화면 출력
					sheet1.SetColHidden("mboTargetYn", 1);
					sheet1.SetColHidden("compTargetYn", 0);
				} else {
					// 화면 출력
					sheet1.SetColHidden("mboTargetYn", 1);
					sheet1.SetColHidden("compTargetYn", 1);
				}
				
				// 평가구분에 따른 업적,역량평가대상자여부 컬럼 편집 여부 설정
				if( appTypeCd == "C" ){			// 종합평가
					sheet1.SetColEditable("mboTargetYn", 1);
					sheet1.SetColEditable("compTargetYn", 1);
				} else {
					sheet1.SetColEditable("mboTargetYn", 0);
					sheet1.SetColEditable("compTargetYn", 0);
				}
				
				var appSeqCdList;
				if (appTypeCd == "D") {	// 다면평가
					appSeqCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", "queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote4=Y", false).codeList, "전체");
				} else {
					appSeqCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", "queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote1=Y", false).codeList, "전체");
				}
				$("#searchAppSeqCd").html(appSeqCdList[2]);
				$("#searchAppSeqCd").change();
				
				sheet1.RemoveAll();
			}catch(e){}
		});

		//평가 단계 변경 시
		$("#searchAppStepCd").bind("change",function(event){
			setSearchClear(); //셋팅값 clear

			var data = ajaxCall("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrMap1"
						, "searchAppraisalCd=" + $("#searchAppraisalCd").val() + "&searchAppStepCd=" + $("#searchAppStepCd").val()
						, false);
			if(data.resultMap != null){
				var appAsYmd = data.resultMap.appAsYmd;
				var appAeYmd = data.resultMap.appAeYmd;
				var dBaseYmd = data.resultMap.dBaseYmd;
				var currymd = data.resultMap.currymd;
				var appTypeCd = data.resultMap.appTypeCd;
				var appraisalYy = data.resultMap.appraisalYy;

				$("#span_searchAppYmd").html(formatDate(appAsYmd,"-")+" ~ "+formatDate(appAeYmd,"-"));
				$("#searchDBaseYmdView").val(dBaseYmd);
				$("#span_searchDBaseYmdView").html(formatDate($('#searchDBaseYmdView').val(),"-"));
				$("#appTypeCd").val(appTypeCd);
				$("#searchAppraisalYy").val(appraisalYy);

				sheet1.RenderSheet(0);
				var shtHdn1 = 0, shtHdn2 = 1;
				if( appTypeCd == "D"){ //다면평가일때
					shtHdn1 = 1, shtHdn2 = 0;
					$("#btnKpi").hide();
				}else if( this.value == "1" ){ //목표등록 일때.
					//$("#btnComp").hide();
					$("#btnComp").show();
					sheet1.SetColHidden("mboTargetYn", 1);
					sheet1.SetColHidden("compTargetYn", 1);
					//sheet1.SetColHidden("compYn", 1);
					//sheet1.SetColHidden("compItemCnt", 1);
					
					var title = "승인자";
					sheet1.SetCellText(0, "detail", title);		
					sheet1.SetCellText(0, "app1stSabunNm", title);	
					sheet1.SetCellText(0, "app1stGroupNm", title);	
					sheet1.SetCellText(0, "app2ndSabunNm", title);	
					sheet1.SetCellText(0, "app2ndGroupNm", title);	
					sheet1.SetCellText(0, "app3rdSabunNm", title);	
					sheet1.SetCellText(0, "app3rdGroupNm", title);	
					sheet1.SetCellText(0, "appBossSabunNm", title);	
					sheet1.SetCellText(0, "appColleagueSabunNm", title);

				}else if( this.value == "3" ){ //중간등록 일때.
					//$("#btnComp").hide();
					$("#btnComp").show();
					sheet1.SetColHidden("mboTargetYn", 1);
					sheet1.SetColHidden("compTargetYn", 1);
					//sheet1.SetColHidden("compYn", 1);
					//sheet1.SetColHidden("compItemCnt", 1);
					
					var title = "승인자";
					sheet1.SetCellText(0, "detail", title);		
					sheet1.SetCellText(0, "app1stSabunNm", title);	
					sheet1.SetCellText(0, "app1stGroupNm", title);	
					sheet1.SetCellText(0, "app2ndSabunNm", title);	
					sheet1.SetCellText(0, "app2ndGroupNm", title);	
					sheet1.SetCellText(0, "app3rdSabunNm", title);	
					sheet1.SetCellText(0, "app3rdGroupNm", title);	
					sheet1.SetCellText(0, "appBossSabunNm", title);	
					sheet1.SetCellText(0, "appColleagueSabunNm", title);
				
				}else if( this.value == "5" ){ //최종평가 일때.
					$("#btnMulti").show();
					$("#btnOrgKpi").show();
					$("#btnKpi").hide(); //KPI생성 버튼 숨김
					$("#btnComp").show();
					sheet1.SetColHidden("mboTargetYn", 0);
					sheet1.SetColHidden("compTargetYn", 0);
					sheet1.SetColHidden("compYn", 0);
					sheet1.SetColHidden("compItemCnt", 0);
					
					var title = "평가자";
					sheet1.SetCellText(0, "detail", title);		
					sheet1.SetCellText(0, "app1stSabunNm", title);	
					sheet1.SetCellText(0, "app1stGroupNm", title);	
					sheet1.SetCellText(0, "app2ndSabunNm", title);	
					sheet1.SetCellText(0, "app2ndGroupNm", title);	
					sheet1.SetCellText(0, "app3rdSabunNm", title);	
					sheet1.SetCellText(0, "app3rdGroupNm", title);	
					sheet1.SetCellText(0, "appBossSabunNm", title);	
					sheet1.SetCellText(0, "appColleagueSabunNm", title);
				}
				sheet1.SetColHidden("app1stSabunNm", shtHdn1);
				sheet1.SetColHidden("app2ndSabunNm", shtHdn1);
				sheet1.SetColHidden("app3rdSabunNm", shtHdn1);
				if( $("#searchAppStepCd").val() == "5"){
					sheet1.SetColHidden("app1stGroupNm", shtHdn1);
					sheet1.SetColHidden("app2ndGroupNm", shtHdn1);
					sheet1.SetColHidden("app3rdGroupNm", shtHdn1);
					sheet1.SetColHidden("mboTargetYn", shtHdn1);
					sheet1.SetColHidden("compTargetYn", shtHdn1);
					/* [190527] 사용안함.
					sheet1.SetColHidden("workTargetYn", shtHdn1);
					sheet1.SetColHidden("appMethodCd", shtHdn1);
					*/
					//sheet1.SetColHidden("mboCloseYn", shtHdn1);
					//sheet1.SetColHidden("compCloseYn", shtHdn1);
				}else{
					sheet1.SetColHidden("app1stGroupNm", 1);
					sheet1.SetColHidden("app2ndGroupNm", 1);
					sheet1.SetColHidden("app3rdGroupNm", 1);
				}
				sheet1.SetColHidden("appBossSabunNm", shtHdn2);
				sheet1.SetColHidden("appColleagueSabunNm", shtHdn2);

				//평가시트구분
				//sheet1.SetColHidden("appSheetType", shtHdn1);
				//KPI/역량 생성여부
				//sheet1.SetColHidden("mboYn", shtHdn1);
				//sheet1.SetColHidden("mboItemCnt", shtHdn1);

				sheet1.RenderSheet(1);
			}else if(this.selectedIndex == 0 ){
				$("#btnMulti").show();
				$("#btnOrgKpi").show();
				$("#btnKpi").hide(); //KPI생성 버튼 숨김
				$("#btnComp").hide();
				sheet1.SetColHidden("mboTargetYn", 0);
				sheet1.SetColHidden("compTargetYn", 0);
				sheet1.SetColHidden("compYn", 0);
				sheet1.SetColHidden("compItemCnt", 0);
				
				var title = "평가자";
				sheet1.SetCellText(0, "detail", title);		
				sheet1.SetCellText(0, "app1stSabunNm", title);	
				sheet1.SetCellText(0, "app1stGroupNm", title);	
				sheet1.SetCellText(0, "app2ndSabunNm", title);	
				sheet1.SetCellText(0, "app2ndGroupNm", title);	
				sheet1.SetCellText(0, "app3rdSabunNm", title);	
				sheet1.SetCellText(0, "app3rdGroupNm", title);	
				sheet1.SetCellText(0, "appBossSabunNm", title);	
				sheet1.SetCellText(0, "appColleagueSabunNm", title);
				
			}

			sheet1.RemoveAll();

			/*평가대상자 집계 표시*/
			var data = ajaxCall("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrMap2"
						, "searchAppraisalCd=" + $("#searchAppraisalCd").val() + "&searchAppStepCd=" + $("#searchAppStepCd").val()
						, false);

			if(data.DATA != null){
				$("#spanTot1").html(data.DATA.tot1);
				$("#spanTot2").html(data.DATA.tot2);
				$("#spanTot3").html(data.DATA.tot3);
				$("#spanTot4").html(data.DATA.tot4);
				$("#spanTot5").html(data.DATA.tot5);
			}

			//doAction1("Search");
		});

		$("#searchAppYn, #searchAppConfirmYn, #searchGroupCd, #searchChgOrgYn").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchSabunName, #searchAppSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		$("#searchAppSeqCd").bind("change",function(event){
			if( $("#searchAppSeqCd").val() == "" ) {
				$("#searchAppSabunName").val("");
				$("#searchGroupCd").html("");

				$("#searchAppSabunName").attr("disabled", true);
				$("#searchGroupCd").attr("disabled", true);
			} else {
				$("#searchAppSabunName").removeAttr("disabled");
				$("#searchGroupCd").removeAttr("disabled");

				var groupCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppGroupCdList"
						+"&searchAppraisalCd="+$("#searchAppraisalCd").val()
						+"&searchAppStepCd="+$("#searchAppStepCd").val()
						+"&searchAppSeqCd="+$("#searchAppSeqCd").val()
						,false).codeList, "전체");
				$("#searchGroupCd").html(groupCdList[2]);
			}
		});
		//총원
		$("#spanTot1Txt, #spanTot1").bind("click",function(event){ doSearchEx("spanTot1"); });
		//평가대상자
		$("#spanTot2Txt, #spanTot2").bind("click",function(event){ doSearchEx("spanTot2&searchAppYn=Y"); });
		//평가제외자
		$("#spanTot3Txt, #spanTot3").bind("click",function(event){ doSearchEx("spanTot3&searchAppYn=N"); });
		//2개이상부서평가대상자 클릭 시
		$("#spanTot4Txt, #spanTot4").bind("click",function(event){ doSearchEx("spanTot4"); });

		//var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y&searchNote1=Y",false).codeList, "전체");
		//$("#searchAppSeqCd").html(appSeqCdList[2]);
		//$("#searchAppSeqCd").change();
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:5, SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제|\n삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete"},
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },

			{Header:"성명|성명",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:1},
			{Header:"사번|사번",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:1,				UpdateEdit:0,	InsertEdit:0},
			{Header:"현소속|현소속",		Type:"Text",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가소속|평가소속",	Type:"Popup",		Hidden:0,					Width:150,	Align:"Left",	ColMerge:1,	SaveName:"appOrgNm",	KeyField:1,				UpdateEdit:0,	InsertEdit:1},
			{Header:"직급|직급",			Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikgubCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:1},
			{Header:"직위|직위",			Type:"Combo",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikweeCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:1},
			{Header:"직책|직책",			Type:"Combo",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikchakCd",	KeyField:0,				UpdateEdit:1,	InsertEdit:1},
			{Header:"직무|직무",			Type:"Combo",		Hidden:1,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jobCd",		KeyField:0,				UpdateEdit:1,	InsertEdit:1},


			{Header:"\n선택|\n선택",								Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"chk",				KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"\n평가\n여부|\n평가\n여부",					Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"appYn",			KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"1차평가\n종료여부|1차평가\n종료여부",			Type:"CheckBox",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"app1stYn",		KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"평가방법|평가방법",							Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appMethodCd",		KeyField:0,		UpdateEdit:1,	InsertEdit:1	},
			{Header:"업적\n평가여부|업적\n평가여부",					Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"mboTargetYn",		KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"역량\n평가여부|역량\n평가여부",					Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"compTargetYn",		KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			
			/* [190527] 사용안함. */
			{Header:"업무개선도\n평가여부|업무개선도\n평가여부",		Type:"CheckBox",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"workTargetYn",	KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			
			{Header:"평가Sheet\n구분|평가Sheet\n구분",				Type:"Combo",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"appSheetType",	KeyField:0,		UpdateEdit:1,	InsertEdit:1	},
			{Header:"제외\n사유|제외\n사유",						Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appExCd",			KeyField:0,		UpdateEdit:1,	InsertEdit:1	},
			{Header:"\n주부서\n여부|\n주부서\n여부",				Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"mainOrgYn",		KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"조직\n이동\n횟수|조직\n이동\n횟수",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"chgOrgCnt",		KeyField:0,		UpdateEdit:0,	InsertEdit:0,	Cursor:"Pointer"},
			{Header:"직위\n변경\n횟수|직위\n변경\n횟수",				Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"chgJikweeCnt",	KeyField:0,		UpdateEdit:0,	InsertEdit:0},
			{Header:"\n평가대상자\n확정여부|\n평가대상자\n확정여부",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appConfirmYn",	KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },

			{Header:"KPI|생성\n여부",								Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"mboYn",				KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"KPI|생성\n개수",								Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"mboItemCnt",			KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"역량|생성\n여부",								Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"compYn",				KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"역량|생성\n개수",								Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"compItemCnt",			KeyField:0,	UpdateEdit:0,	InsertEdit:0 },

			{Header:"마감여부|업적",								Type:"CheckBox",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"mboCloseYn",	KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"마감여부|역량",								Type:"CheckBox",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"compCloseYn",	KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },

			{Header:"평가자|상세",								Type:"Image",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"detail",				KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"평가자|1차",									Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"app1stSabunNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"평가자|1차평가그룹",							Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"app1stGroupNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"평가자|2차",									Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"app2ndSabunNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"평가자|2차평가그룹",							Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"app2ndGroupNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"평가자|3차",									Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"app3rdSabunNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"평가자|3차평가그룹",							Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"app3rdGroupNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },

			{Header:"평가자|상향평가",								Type:"Text",		Hidden:1,   Width:80,   Align:"Center", ColMerge:1, SaveName:"appBossSabunNm",		KeyField:0, UpdateEdit:0,   InsertEdit:0 },
			{Header:"평가자|동료평가",								Type:"Text",		Hidden:1,   Width:80,   Align:"Center", ColMerge:1, SaveName:"appColleagueSabunNm",	KeyField:0, UpdateEdit:0,   InsertEdit:0 },

			{Header:"평가ID|평가ID",								Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd" 	},
			{Header:"평가단계|평가단계",							Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appStepCd" 	},
			{Header:"평가소속코드|평가소속코드",						Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appOrgCd" 	},
			{Header:"직군코드|직군코드",							Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"workType"},
			{Header:"직군|직군",									Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"workTypeNm"},
			{Header:"직무|직무",									Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jobNm"},
			{Header:"사원구분코드|사원구분코드",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"manageCd"},
			{Header:"비고|비고",									Type:"Text",		Hidden:0,	Width:350,	Align:"Left",	ColMerge:1,	SaveName:"note",		KeyField:0,	UpdateEdit:1,	InsertEdit:1 },


		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);
		sheet1.SetColFontUnderline("chgOrgCnt", 1);

		var appSheetTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20005"), "");	//평가SHEET구분
		var appMethodCd		 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10006"), "");	//평가방법
		var appExCdList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00018"), "");	//제외사유
		var jikgubList 	 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");	//직급
		var jikchakList 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "");	//직책
		var jikweeList 	 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "");	//직위
		var jobCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getJobCdList",false).codeList, "");

		sheet1.SetColProperty("appMethodCd",	{ComboText:"|"+appMethodCd[0], 		ComboCode:"|"+appMethodCd[1]} );
		sheet1.SetColProperty("appSheetType",	{ComboText:"|"+appSheetTypeList[0], ComboCode:"|"+appSheetTypeList[1]} );
		sheet1.SetColProperty("appExCd",		{ComboText:"|"+appExCdList[0], 		ComboCode:"|"+appExCdList[1]} );
		sheet1.SetColProperty("jikgubCd",		{ComboText:"|"+jikgubList[0], 		ComboCode:"|"+jikgubList[1]} );
		sheet1.SetColProperty("jikchakCd",		{ComboText:"|"+jikchakList[0], 		ComboCode:"|"+jikchakList[1]} );
		sheet1.SetColProperty("jikweeCd",		{ComboText:"|"+jikweeList[0], 		ComboCode:"|"+jikweeList[1]} );
		sheet1.SetColProperty("jobCd",			{ComboText:"|"+jobCdList[0], 		ComboCode:"|"+jobCdList[1]} );

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"jikgubCd", rv["jikgubCd"]);
						sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow,"gempYmd", rv["gempYmd"]);
						sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);
						sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
						sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
						sheet1.SetCellValue(gPRow,"jobCd", rv["jobCd"]);
						sheet1.SetCellValue(gPRow,"jobNm", rv["jobNm"]);
						sheet1.SetCellValue(gPRow,"manageCd", rv["manageCd"]);
					}
				}
			]
		});

		var appraisalCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();

		$(window).smartresize(sheetResize); sheetInit();

	});
</script>

<script type="text/javascript">
/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
	//removeErrMsg();
	switch(sAction){
	case "Search":		//조회
		if ($("#searchAppraisalCd").val() == "") {
			alert("평가명을 선택해 주시기 바랍니다.");
			$("#searchAppraisalCd").focus();
			return;
		}
		if ( $("#searchAppStepCd").val() == "" ) {
			alert("평가단계를 선택해 주시기 바랍니다.");
			$("#searchAppStepCd").focus();
			return;
		}

		var data = ajaxCall("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrMap2"
					, "searchAppraisalCd=" + $("#searchAppraisalCd").val() + "&searchAppStepCd=" + $("#searchAppStepCd").val()
					, false);

		if(data.DATA != null){
			$("#spanTot1").html(data.DATA.tot1);
			$("#spanTot2").html(data.DATA.tot2);
			$("#spanTot3").html(data.DATA.tot3);
			$("#spanTot4").html(data.DATA.tot4);
			$("#spanTot5").html(data.DATA.tot5);
		}

		sheet1.DoSearch("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrList1", $("#sheet1Form").serialize());
		break;

	case "Save":		//저장
		if(sheet1.FindStatusRow("I") != ""){
			if(!dupChk(sheet1,"appraisalCd|appStepCd|sabun|appOrgCd", true, true)){break;}
		}
		IBS_SaveName(document.sheet1Form,sheet1);
		sheet1.DoSave( "${ctx}/AppPeopleMgr.do?cmd=saveAppPeopleMgr1", $("#sheet1Form").serialize());
		break;

	case "Insert":		//입력
		if ($("#searchAppraisalCd").val() == "") {
			alert("평가명을 선택해 주시기 바랍니다.");
			$("#searchAppraisalCd").focus();
			return;
		}
		if ( $("#searchAppStepCd").val() == "" ) {
			alert("평가단계를 선택해 주시기 바랍니다.");
			$("#searchAppStepCd").focus();
			return;
		}

		var Row = sheet1.DataInsert(0);
		sheet1.SetCellValue(Row, "appraisalCd",$("#searchAppraisalCd").val());
		sheet1.SetCellValue(Row, "appStepCd",$("#searchAppStepCd").val());
		sheet1.SetCellValue(Row, "appYn", "Y");
		sheet1.SetCellValue(Row, "mainOrgYn", "Y");
		
		var appTypeCd = $("#searchAppraisalCd").val().substring(2,3);
		if( appTypeCd == "C" ){			// 종합평가
			// 화면 출력
			sheet1.SetCellValue(Row, "mboTargetYn", "Y");
			sheet1.SetCellValue(Row, "compTargetYn", "Y");
		} else if( appTypeCd == "A" ) {
			sheet1.SetCellValue(Row, "mboTargetYn", "Y");
		} else if( appTypeCd == "B" ) {
			sheet1.SetCellValue(Row, "compTargetYn", "Y");
		}
		
		break;

	case "Copy":		//행복사
		var Row = sheet1.DataCopy();
		sheet1.SetCellValue(Row, "mainOrgYn", "N");
		sheet1.SetCellValue(Row, "chgOrgCnt", "");
		sheet1.SetCellValue(Row, "chgJikweeCnt", "");
		sheet1.SetCellValue(Row, "appConfirmYn", "");
		sheet1.SetCellValue(Row, "mboYn", "");
		sheet1.SetCellValue(Row, "mboItemCnt", "");
		sheet1.SetCellValue(Row, "compYn", "");
		sheet1.SetCellValue(Row, "compItemCnt", "");
		sheet1.SetCellValue(Row, "detail", "");
		sheet1.SetCellValue(Row, "app1stSabunNm", "");
		sheet1.SetCellValue(Row, "app1stGroupNm", "");
		sheet1.SetCellValue(Row, "app2ndSabunNm", "");
		sheet1.SetCellValue(Row, "app2ndGroupNm", "");
		sheet1.SetCellValue(Row, "app3rdSabunNm", "");
		sheet1.SetCellValue(Row, "app3rdGroupNm", "");
		sheet1.SetCellValue(Row, "appBossSabunNm", "");
		sheet1.SetCellValue(Row, "appColleagueSabunNm", "");
		break;

	case "Clear":		//Clear
		sheet1.RemoveAll();
		break;

	case "Down2Excel":	//엑셀내려받기
		sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
		break;

	case "LoadExcel":	//엑셀업로드
		var params = {Mode:"HeaderMatch", WorkSheetNo:1};
		sheet1.LoadExcel(params);
		break;
	}
}

function doSearchEx(gubun){
	if ($("#searchAppraisalCd").val() == "") {
		alert("평가명을 선택해 주시기 바랍니다.");
		$("#searchAppraisalCd").focus();
		return;
	}
	if ( $("#searchAppStepCd").val() == "" ) {
		alert("평가단계를 선택해 주시기 바랍니다.");
		$("#searchAppStepCd").focus();
		return;
	}
	var params = "searchAppraisalCd=" + $("#searchAppraisalCd").val()
	           + "&searchAppStepCd=" + $("#searchAppStepCd").val()
	           + "&searchExtType="+gubun;
	sheet1.DoSearch("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrList1", params);

}
//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{
		if(Msg != "") {
			alert(Msg);
		}
		if ( Code != "-1" ) {
			doAction1("Search");
		}
	}catch(ex){
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try{
		if ( Row < sheet1.HeaderRows()   ) return;
		if ( sheet1.ColSaveName(Col) == "detail" ) { //평가자 상세

			if(sheet1.GetCellValue(Row,"sStatus") == "I" ) {
				alert("입력중입니다. 저장후 입력하여 주십시오.");
			} else {
				gPRow = Row
				pGubun = "appPeopleMgrAppSabunPop"

				const p = {
					searchAppraisalCd : sheet1.GetCellValue(Row,"appraisalCd"),
					searchAppStepCd : sheet1.GetCellValue(Row,"appStepCd"),
					searchAppOrgCd : sheet1.GetCellValue(Row,"appOrgCd"),
					searchAppOrgNm : sheet1.GetCellValue(Row,"appOrgNm"),
					searchSabun : sheet1.GetCellValue(Row,"sabun"),
					searchName : sheet1.GetCellValue(Row,"name"),
					appTypeCd : $("#appTypeCd").val(),
					searchAppraisalNm : $("#searchAppraisalCd option:selected").text()
				};

				var layer = new window.top.document.LayerModal({
					id : 'appPeopleMgrAppSabunLayer'
					, url : '/AppPeopleMgr.do?cmd=viewAppPeopleMgrAppSabunLayer&authPg=${authPg}'
					, parameters: p
					, width : 850
					, height : 600
					, title : "평가자상세"
					, trigger :[
						{
							name : 'appPeopleMgrAppSabunTrigger'
							, callback : function(rv){
								getReturnValue(rv);
							}
						}
					]
				});
				layer.show();

				<%--if(!isPopup()) {return;}--%>

				<%--var args	= new Array();--%>
				<%--args["searchAppraisalCd"] = sheet1.GetCellValue(Row,"appraisalCd");--%>
				<%--args["searchAppStepCd"] = sheet1.GetCellValue(Row,"appStepCd");--%>
				<%--args["searchAppOrgCd"] = sheet1.GetCellValue(Row,"appOrgCd");--%>
				<%--args["searchAppOrgNm"] = sheet1.GetCellValue(Row,"appOrgNm");--%>
				<%--args["searchSabun"] = sheet1.GetCellValue(Row,"sabun");--%>
				<%--args["searchName"] = sheet1.GetCellValue(Row,"name");--%>
				<%--args["appTypeCd"] = $("#appTypeCd").val();--%>
				<%--args["searchAppraisalNm"] = $("#searchAppraisalCd option:selected").text();--%>
				<%--gPRow = Row;--%>
				<%--pGubun = "appPeopleMgrAppSabunPop";--%>

				<%--openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrAppSabunPop&authPg=${authPg}", args, "850","520");--%>
			}

		}else if ( sheet1.ColSaveName(Col) == "chgOrgCnt" ) {  //조직이동횟수 클릭 시

			if(sheet1.GetCellValue(Row,"sStatus") == "I" ) {
				alert("입력중입니다. 저장후 입력하여 주십시오.");
			} else {

				gPRow = Row
				pGubun = "appPeopleMgrChgOrgPop"

				const p = {
					searchAppraisalYy : $("#searchAppraisalYy").val(),
					searchSabun : sheet1.GetCellValue(Row,"sabun"),
					searchName : sheet1.GetCellValue(Row,"name"),
					appTypeCd : $("#appTypeCd").val(),
					searchAppraisalNm : $("#searchAppraisalCd option:selected").text()
				};

				var layer = new window.top.document.LayerModal({
					id : 'appPeopleMgrChgOrgLayer'
					, url : '/AppPeopleMgr.do?cmd=viewAppPeopleMgrChgOrgLayer&authPg=${authPg}'
					, parameters: p
					, width : 500
					, height : 400
					, title : "조직이동상세"
					, trigger :[
						{
							name : 'appPeopleMgrChgOrgTrigger'
							, callback : function(rv){
								getReturnValue(rv);
							}
						}
					]
				});
				layer.show();

				<%--if(!isPopup()) {return;}--%>

				<%--var args	= new Array();--%>
				<%--args["searchAppraisalYy"] = $("#searchAppraisalYy").val();--%>
				<%--args["searchSabun"] = sheet1.GetCellValue(Row,"sabun");--%>
				<%--args["searchName"] = sheet1.GetCellValue(Row,"name");--%>
				<%--gPRow = Row;--%>
				<%--pGubun = "appPeopleMgrChgOrgPop";--%>

				<%--openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrChgOrgPop&authPg=R", args, "500","520");--%>
			}
		}
	}catch(ex){
		alert("OnClick Event Error : " + ex);
	}
}

//Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
function sheet1_OnPopupClick(Row, Col){
	try{
		if( sheet1.ColSaveName(Col) == "name" ) {

			gPRow = Row
			pGubun = "employeePopup"

			let layerModal = new window.top.document.LayerModal({
				id : 'employeeLayer'
				, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
				, parameters : {
					name : sheet1.GetCellValue(Row, "name")
					, sabun : sheet1.GetCellValue(Row, "sabun")
				}
				, width : 840
				, height : 520
				, title : '사원조회'
				, trigger :[
					{
						name : 'employeeTrigger'
						, callback : function(result){
							getReturnValue(result);
							// sheet1.SetCellValue(Row, "name",   result.name);
							// sheet1.SetCellValue(Row, "alias",   result.alias);
							// sheet1.SetCellValue(Row, "sabun",   result.sabun);
							// sheet1.SetCellValue(Row, "jikgubNm",   result.jikgubNm);
							// sheet1.SetCellValue(Row, "jikweeNm",   result.jikweeNm);
							// sheet1.SetCellValue(Row, "orgNm",   result.orgNm);
							// sheet1.SetCellValue(Row, "statusCd",   result.statusCd);
						}
					}
				]
			});
			layerModal.show();

			// if(!isPopup()) {return;}
			//
			// var args	= new Array();
			//
			// gPRow = Row;
			// pGubun = "employeePopup";
			//
			// openPopup("/Popup.do?cmd=employeePopup", args, "740","520");


		}else if( sheet1.ColSaveName(Col) == "appOrgNm" ) {
			// if(!isPopup()) {return;}
			//
			// var args	= new Array();
			// args["searchAppraisalCd"] 	= $("#searchAppraisalCd").val();
			// args["searchAppStepCd"] 	= $("#searchAppStepCd").val();
			//
			gPRow = Row;
			pGubun = "orgBasicPapCreatePopup";
			//
			// openPopup("/Popup.do?cmd=orgBasicPapCreatePopup", args, "680","520");

			let layerModal = new window.top.document.LayerModal({
				id : 'orgBasicPapCreateLayer'
				, url : '/AppPeopleMgr.do?cmd=viewOrgBasicPapCreateLayer'
				, parameters : {
					searchAppraisalCd : $("#searchAppraisalCd").val()
					, searchAppStepCd : $("#searchAppStepCd").val()
				}
				, width : 680
				, height : 520
				, title : '조직 리스트 조회'
				, trigger :[
					{
						name : 'orgBasicPapCreateLayerTrigger'
						, callback : function(rv){
							sheet1.SetCellValue(Row,"appOrgNm",(rv["orgNm"]));
							sheet1.SetCellValue(Row,"appOrgCd",(rv["orgCd"]));
						}
					}
				]
			});
			layerModal.show();

		}else if( sheet1.ColSaveName(Col) == "appGroupNm" ) {
			if(!isPopup()) {return;}

			var args = new Array();
			args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");

			gPRow = Row;
			pGubun = "appPeopleMgrPop";

			openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "350","500");
		}else if(sheet1.ColSaveName(Col) == "appSabun1Nm"){
			if(!isPopup()) {return;}

			var args	= new Array();

			gPRow = Row;
			pGubun = "employeePopup1";

			openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
		}else if(sheet1.ColSaveName(Col) == "appSabun2Nm"){
			if(!isPopup()) {return;}

			var args	= new Array();

			gPRow = Row;
			pGubun = "employeePopup2";

			openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
		}

	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
}

// 대상자생성
function createRcpt(){
	if(!isPopup()) {return;}

	if ( $("#searchAppraisalCd").val() == "" ) {
		alert("평가명을 선택해 주세요");
		return;
	}

	if ( $("#searchAppStepCd").val() == "" ) {
		alert("평가단계를 선택해 주세요");자
		return;
	}

	if ( $("#searchDBaseYmdView").val() == "" ) {
		alert("대상자생성기준일을 입력해 주세요");
		return;
	}

	<%--var args = new Array();--%>
	<%--args["searchAppraisalCd"] 	= $("#searchAppraisalCd").val();--%>
	<%--args["searchAppStepCd"] 	= $("#searchAppStepCd").val();--%>
	<%--args["searchDBaseYmdView"] 	= $("#searchDBaseYmdView").val();--%>

	<%--gPRow = "";--%>
	<%--pGubun = "appPeopleCreatePop";--%>

	<%--openPopup("${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleCreatePop", args, "900","340");--%>
	var layer = new window.top.document.LayerModal({
		id : 'appPeopleCreateLayer'
		, url : '/AppPeopleMgr.do?cmd=viewAppPeopleCreateLayer'
		, parameters: {
			searchAppraisalCd : $("#searchAppraisalCd").val(),
			searchAppStepCd : $("#searchAppStepCd").val(),
			searchDBaseYmdView : $("#searchDBaseYmdView").val()
		}
		, width : 850
		, height : 450
		, title : "대상자선정"
		, trigger :[
			{
				name : 'appPeopleCreateLayerTrigger'
				, callback : function(rv){
					doAction1("Search");
				}
			}
		]
	});
	layer.show();




	/*
	if(confirm("평가대상자 및 1차평가자 생성 작업을 하시겠습니까? \n 기존 셋업된 데이터가 초기화 됩니다.")){
		if(confirm("기정의된 평가방법, 평가SHEET구분 의 변경사항 존재시 덮어쓰시겠습니까?")){
			$("#updYn").val("Y");
		} else{
			$("#updYn").val("N");
		}

		$("#searchDBaseYmd").val( $("#searchDBaseYmdView").val().replace(/-/g, "") );

		var data = ajaxCall("${ctx}/AppPeopleMgr.do?cmd=prcAppPeopleMgr1",$("#sheet1Form").serialize(),false);
		if(data.Result.Code == null) {
			alert("처리되었습니다.");
			doAction1("Search");
		} else {
	    	alert(data.Result.Message);
		}
	}
	*/
}

//역량, KPI생성
function callProc(val){

	var gb = "";
	if(val == "prcAppPeopleMgr3"){//KPI생성
		gb = "KPI를";
	} else if (val == "prcAppPeopleMgr4") { //역량생성
		gb = "역량을";
	}

	var chkRows = sheet1.FindCheckedRow("chk");
	var saveArr = chkRows.split("|");

	var param = "&appraisalCd=" + $("#searchAppraisalCd").val();
	param += "&appStepCd=" 	+ $("#searchAppStepCd").val();
	param += "&sabun=&appOrgCd=";

	if(chkRows == "") {
		if(!confirm("기존 데이터 및 평가점수가 초기화 됩니다.\n전체 대상자의 "+gb+" 생성하시겠습니까?")) return;
		param += "&tmpYn=N";

	}else{
		if(!confirm("기존 데이터 및 평가점수가 초기화 됩니다.\n선택한 대상자의 "+gb+" 생성하시겠습니까?")) return;
		var paramTmp =  "s_SAVENAME=sabun,appOrgCd";
		paramTmp += "&searchAppraisalCd=" + $("#searchAppraisalCd").val();
		paramTmp += "&searchAppStepCd=" 	+ $("#searchAppStepCd").val();
		for(var i=0; i < saveArr.length; i++){
			paramTmp += "&sabun=" 		+ sheet1.GetCellValue(saveArr[i],"sabun");
			paramTmp += "&appOrgCd=" 	+ sheet1.GetCellValue(saveArr[i],"appOrgCd");

		}

		//선택한 대상자 미리 저장.
		var dataTmp = ajaxCall("${ctx}/AppPeopleMgr.do?cmd=saveAppPeopleMgrTmp", paramTmp, false);
		if(dataTmp.Result.Code != null && dataTmp.Result.Code == "0"){
			alert("처리 중 오류가 발생했습니다.");
			return;
		}else{
			param += "&tmpYn=Y";
		}
	}

	var data ;
	if(val == "prcAppPeopleMgr3"){//KPI생성
		data = ajaxCall("${ctx}/AppPeopleMgr.do?cmd=prcAppPeopleMgr3",param,false);
	} else if (val == "prcAppPeopleMgr4") { //역량생성
		data = ajaxCall("${ctx}/AppPeopleMgr.do?cmd=prcAppPeopleMgr4",param,false);
	}

	if(data.Result.Code != null && data.Result.Code != ""){
		alert(data.Result.Message);
	}else{
		alert("처리되었습니다.");
	}

}

// 전체삭제
function deleteAll(){
	if( !confirm("전체삭제를 하시겠습니까?") ) return;

	if ($("#searchAppraisalCd").val() == "") {
		alert("평가명을 선택해 주시기 바랍니다.");
		$("#searchAppraisalCd").focus();
		return;
	}
	if ($("#searchAppStepCd").val() == "") {
		alert("평가단계를 선택해 주시기 바랍니다.");
		$("#searchAppStepCd").focus();
		return;
	}

	var data = ajaxCall("${ctx}/AppPeopleMgr.do?cmd=deleteAppPeopleMgrAll",$("#sheet1Form").serialize(),false);
	if(data.Result.Message != "") alert(data.Result.Message);
	if(data.Result.Code != "-1") doAction1("Search");

}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	//var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "appPeopleMgrAppSabunPop"){
		doAction1("Search");
    } else if(pGubun == "employeePopup") {
		sheet1.SetCellValue(gPRow,"name",(rv["name"]));
		sheet1.SetCellValue(gPRow,"sabun",(rv["sabun"]));
		sheet1.SetCellValue(gPRow,"alias",(rv["alias"]));
		//sheet1.SetCellValue(gPRow,"appOrgNm",(rv["orgNm"]));
		//sheet1.SetCellValue(gPRow,"appOrgCd",(rv["orgCd"]));
		sheet1.SetCellValue(gPRow,"jikgubNm",(rv["jikgubNm"]));
		sheet1.SetCellValue(gPRow,"jikgubCd",(rv["jikgubCd"]));
		sheet1.SetCellValue(gPRow,"jikweeNm",(rv["jikweeNm"]));
		sheet1.SetCellValue(gPRow,"jikweeCd",(rv["jikweeCd"]));
		sheet1.SetCellValue(gPRow,"jikchakNm",(rv["jikchakNm"]));
		sheet1.SetCellValue(gPRow,"jikchakCd",(rv["jikchakCd"]));
		sheet1.SetCellValue(gPRow,"jobCd",(rv["jobCd"]));
		sheet1.SetCellValue(gPRow,"workType",(rv["workType"]));
		sheet1.SetCellValue(gPRow,"workTypeNm",(rv["workTypeNm"]));
    } else if(pGubun == "employeePopup1") {
		sheet1.SetCellValue(gPRow,"appSabun1Nm",(rv["name"]));
		sheet1.SetCellValue(gPRow,"appSabun1",(rv["sabun"]));
		sheet1.SetCellValue(gPRow,"appOrgCd1",(rv["orgCd"]));
    } else if(pGubun == "employeePopup2") {
		sheet1.SetCellValue(gPRow,"appSabun2Nm",(rv["name"]));
		sheet1.SetCellValue(gPRow,"appSabun2",(rv["sabun"]));
		sheet1.SetCellValue(gPRow,"appOrgCd2",(rv["orgCd"]));
    } else if(pGubun == "orgBasicPapCreatePopup") {
		sheet1.SetCellValue(gPRow,"appOrgNm",(rv["orgNm"]));
		sheet1.SetCellValue(gPRow,"appOrgCd",(rv["orgCd"]));
    } else if(pGubun == "appPeopleMgrPop") {
		sheet1.SetCellValue(gPRow,"appGroupCd",(rv["appGroupCd"]));
		sheet1.SetCellValue(gPRow,"appGroupNm",(rv["appGroupNm"]));
    } else if(pGubun == "appPeopleCreatePop") {
    } else if(pGubun == "sheetAutocompleteEmp") {

    	sheet1.SetCellValue(gPRow,"name", rv["name"]);
    	sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);

    	sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
    	sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);

    	sheet1.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
    	sheet1.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);

    	sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
    	sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);

    	sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
    	sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);

    	sheet1.SetCellValue(gPRow,"jikgubCd", rv["jikgubCd"]);
    	sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);

    	sheet1.SetCellValue(gPRow,"gempYmd", rv["gempYmd"]);
    	sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);

    	sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
    	sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
	}
}
// 날짜 포맷을 적용한다..
function formatDate(strDate, saper) {
	if(strDate == "") {
		return strDate;
	}

	if(strDate.length == 10) {
		return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
	} else if(strDate.length == 8) {
		return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
	}
}
//
function setSearchClear(){
	$("#span_searchAppYmd").html("");
	$("#searchDBaseYmdView").val("");
	$("#span_searchDBaseYmdView").html("");
	$("#btnOrgKpi").hide();
	$("#btnMulti").hide();
	$("#btnKpi").show();
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" name="searchDBaseYmd" id="searchDBaseYmd">
		<input type="hidden" name="updYn" id="updYn">
		<input type="hidden" name="appTypeCd" id="appTypeCd">
		<input type="hidden" name="searchAppraisalYy" id="searchAppraisalYy">

		<div class="sheet_search sheet_search_o outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td>
							<span>평가단계</span>
							<select name="searchAppStepCd" id="searchAppStepCd">
							</select>
						</td>
						<td colspan="2">
							<span>평가시행기간</span>
							<span id="span_searchAppYmd" class="txt" style="font-weight:normal"></span>
						</td>
						<td><span>대상자생성기준일 </span>
							<input type="hidden" id="searchDBaseYmdView" name="searchDBaseYmdView" />
							<span id="span_searchDBaseYmdView" class="txt" style="font-weight:normal"></span>
						</td>
					</tr>
					<tr>
						<td>
							<span>성명/사번</span>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
						</td>
						<td>
							<span>평가소속</span>
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" />
						</td>
						<td>
							<span>평가포함여부</span>
							<select name="searchAppYn" id="searchAppYn">
								<option value="">전체</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
						<td>
							<span>평가대상자확정여부</span>
							<select name="searchAppConfirmYn" id="searchAppConfirmYn">
								<option value="">전체</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
						<td>
							<span>조직이동여부</span>
							<select name="searchChgOrgYn" id="searchChgOrgYn">
								<option value="">전체</option>
								<option value="Y">Y</option>
								<option value="N">N</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<span>평가차수</span>
							<select name="searchAppSeqCd" id="searchAppSeqCd"></select>
						</td>
						<td>
							<span>평가자명/사번</span>
							<input id="searchAppSabunName" name="searchAppSabunName" type="text" class="text" />
						</td>
						<td>
							<span>평가그룹</span>
							<select name="searchGroupCd" id="searchGroupCd"></select>
						</td>
						<td></td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
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
							<li id="txt" class="txt">평가대상자
								<span style="font-size: 8pt;cursor:pointer;">
									<span id="spanTot1Txt">총원</span> <span id="spanTot1" name="spanTot1" type="text" style="color:red;text-decoration: underline;">0</span>
									, <span id="spanTot2Txt">평가대상자</span> <span id="spanTot2" name="spanTot2" type="text" style="color:red;text-decoration: underline;">0</span>
									, <span id="spanTot3Txt">평가제외자</span> <span id="spanTot3" name="spanTot3" type="text" style="color:red;text-decoration: underline;">0</span>
									, <span id="spanTot4Txt">2개이상부서평가대상자</span> <span id="spanTot4" name="spanTot4" type="text" style="color:red;text-decoration: underline;">0</span>
									<span style="display:none;">, 주부서 체크자 <span id="spanTot5" name="spanTot5" type="text" style="color:red;">0</span></span>
								</span>
							</li>
							<li class="btn">
								<!-- a href="javascript:callProc('prcAppPeopleMgr3')" id="btnKpi" class="button authA">KPI생성</a-->
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
								<a href="javascript:doAction1('Copy')" 	class="btn outline-gray authA">복사</a>
								<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
								<a href="javascript:deleteAll()" id="btnDelete" class="btn soft authA">전체삭제</a>
								<a href="javascript:doAction1('Save')" 	class="btn soft authA">저장</a>
								<a href="javascript:callProc('prcAppPeopleMgr4')" id="btnComp" class="btn filled authA">역량생성</a>
								<a href="javascript:createRcpt()" id="btnSearch" class="btn filled authA">대상자생성</a>
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