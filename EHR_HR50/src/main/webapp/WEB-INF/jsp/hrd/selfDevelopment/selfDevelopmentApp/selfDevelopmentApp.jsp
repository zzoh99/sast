<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112863' mdef='근태신청'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var prevStatusMap = null;
	
	$(function() {
		$("#sYear, #eYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		$("#sYmd").datepicker2({startdate:"eYmd"});
		$("#eYmd").datepicker2({enddate:"sYmd"});

		$("#sYmd, #eYmd").bind("keydown",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo'        mdef='No'			/>", Type:"${sNoTy}" , Hidden:0, Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'			/>", Type:"${sDelTy}", Hidden:0, Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus'    mdef='상태'			/>", Type:"${sSttTy}", Hidden:0, Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='BLANK'      mdef='실행년도'			/>", Type:"Text"     , Hidden:0, Width:40          , Align:"Center", ColMerge:0, SaveName:"activeYyyy"        , KeyField:0, CalcLogic:"", Format:"Integer", PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:4    },
			{Header:"<sht:txt mid='BLANK'      mdef='반기구분'			/>", Type:"Combo"    , Hidden:0, Width:50          , Align:"Center", ColMerge:0, SaveName:"halfGubunType"     , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1    },
			{Header:"<sht:txt mid='BLANK'      mdef='사번'			/>", Type:"Text"     , Hidden:1, Width:0           , Align:"Center", ColMerge:0, SaveName:"sabun"             , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:13   },
			{Header:"<sht:txt mid='BLANK'      mdef='요청일'			/>", Type:"Text"     , Hidden:0, Width:80          , Align:"Center", ColMerge:0, SaveName:"approvalReqYmd"    , KeyField:0, CalcLogic:"", Format:"Ymd"    , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10    },
			{Header:"<sht:txt mid='BLANK'      mdef='승인상태'			/>", Type:"Combo"    , Hidden:0, Width:80          , Align:"Center", ColMerge:0, SaveName:"approvalStatus"    , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1    },
			{Header:"<sht:txt mid='BLANK'      mdef='승인부서코드'		/>", Type:"Text"     , Hidden:1, Width:0           , Align:"Center", ColMerge:0, SaveName:"approvalMainOrgCd" , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='승인부서'			/>", Type:"Text"     , Hidden:1, Width:70          , Align:"Center", ColMerge:0, SaveName:"approvalMainOrgNm" , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='상위부서'			/>", Type:"Text"     , Hidden:0, Width:70          , Align:"Center", ColMerge:0, SaveName:"priorOrgNm"        , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='승인팀코드'		/>", Type:"Text"     , Hidden:1, Width:0           , Align:"Center", ColMerge:0, SaveName:"approvalOrgCd"     , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='승인팀'			/>", Type:"Text"     , Hidden:0, Width:70          , Align:"Center", ColMerge:0, SaveName:"approvalOrgNm"     , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10   },
			{Header:"<sht:txt mid='BLANK'      mdef='승인자사번'		/>", Type:"Text"     , Hidden:0, Width:70          , Align:"Center", ColMerge:0, SaveName:"approvalEmpNo"     , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:13   },
			{Header:"<sht:txt mid='BLANK'      mdef='승인자성명'		/>", Type:"Text"     , Hidden:0, Width:70          , Align:"Center", ColMerge:0, SaveName:"approvalEmpName"   , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:20   },
			{Header:"<sht:txt mid='BLANK'      mdef='승인일'			/>", Type:"Text"     , Hidden:0, Width:80          , Align:"Center", ColMerge:0, SaveName:"approvalYmd"       , KeyField:0, CalcLogic:"", Format:"Ymd"    , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:10    },
			{Header:"<sht:txt mid='BLANK'      mdef='팀원의견'			/>", Type:"Text"     , Hidden:1, Width:90          , Align:"Center", ColMerge:0, SaveName:"approvalReqMemo"   , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'      mdef='팀장의견'			/>", Type:"Text"     , Hidden:1, Width:90          , Align:"Center", ColMerge:0, SaveName:"approvalReturnMemo", KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:4000 },
			{Header:"<sht:txt mid='BLANK'      mdef='자기개발\n계획서'	/>", Type:"Image"    , Hidden:1, Width:60          , Align:"Center", ColMerge:0, SaveName:"note"              , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:8    }
		];
		IBS_InitSheet(sheet1, initdata1);
		sheet1.SetCountPosition(0);
		sheet1.SetEditable(true);
		sheet1.SetVisible(true);

		fnSetCode();
		
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

	});

	function fnSetCode() {
		var grpCds = "D00005,D00007";	// [D00005] 상하반기
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
		sheet1.SetColProperty("halfGubunType" , 	{ComboText:codeLists["D00005"][0], ComboCode:codeLists["D00005"][1]} );
		sheet1.SetColProperty("approvalStatus", 	{ComboText:codeLists["D00007"][0], ComboCode:codeLists["D00007"][1]} );
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if($("#sYear").val() == "") {
					alert("<msg:txt mid='alertVacationApp1' mdef='시작년도를 입력하여 주십시오.'/>");
					$("#sYear").focus();
					return;
				}
				if($("#eYear").val() == "") {
					alert("<msg:txt mid='110116' mdef='종료년도를 입력하여 주십시오.'/>");
					$("#eYear").focus();
					return;
				}
				if($("#sYear").val() > $("#eYear").val() ) {
					alert("<msg:txt mid='109812' mdef='시작년도는 종료년도보다 작아야 합니다.'/>");
					$("#sYear").focus();
					return;
				}
				
				// 이전 단계 진행 여부 데이터 파싱
				setPrevStatusData($("#searchUserId").val());

				var param = "searchSabun="+$("#searchUserId").val() + "&sYear=" + $("#sYear").val() + "&eYear=" + $("#eYear").val();
				sheet1.DoSearch( "${ctx}/SelfDevelopmentApp.do?cmd=getSelfDevelopmentList",param );
				break;
			case "Insert":
				var Row = sheet1.DataInsert(0) ;

				sheet1.SetCellValue(Row,"sabun"         , $("#searchUserId").val());
				sheet1.SetCellValue(Row,"activeYyyy"    , "${curSysYear}"         );
				sheet1.SetCellValue(Row,"approvalStatus", "9"                     );

				// Include File 내 함수
				fnClearSheetInc();
				
				fnSetStatus(Row);

				break;
			case "Save":
				if(sheet1.FindStatusRow("I|S|D|U") != ""){
					IBS_SaveName(document.srchFrm,sheet1);
					sheet1.DoSave( "${ctx}/SelfDevelopmentApp.do?cmd=saveSelfDevelopment", $("#srchFrm").serialize(),-1,0);
				}
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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

			if( sheet1.RowCount() != 0 ) {
				fnBasicAction();
			}else{
				$("#approvalStatus").val("0");
				$("#funcBtnList").find("a").hide();
				if( !$("#approvalReqMemo").hasClass("readonly") ) {
					$("#approvalReqMemo").attr("readonly",true).addClass("readonly");
				}
				if( !$("#approvalReturnMemo").hasClass("readonly") ) {
					$("#approvalReturnMemo").attr("readonly",true).addClass("readonly");
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 셀이 선택 되었을때 발생한다
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow != NewRow) {
				fnBasicAction();
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}
	
	// 값 변경시
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		try {
			var colName = sheet1.CellSaveName(Row, Col);
			
			if( colName == "activeYyyy" ) {
				fnSetStatus(Row);
			} else if( colName == "halfGubunType" ) {
				fnSetStatus(Row);
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			/*if (Msg != "") { alert(Msg);}*/
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function fnBasicAction() {
		var nSelectRow = sheet1.GetSelectRow();
		fnDoActionInc();		// Include File의 Action 실행
		fnSetData(nSelectRow);	// 기본상태정보 설정
		setAuth(nSelectRow);	// 권한및상태에 따라 DOM 상태 설정
		fnSetStatus(nSelectRow);
	}

	function fnSetData(nRow) {
		$("#approvalReqMemo"   ).val(sheet1.GetCellValue(nRow, "approvalReqMemo"   ));
		$("#approvalReturnMemo").val(sheet1.GetCellValue(nRow, "approvalReturnMemo"));
		$("#approvalStatus"    ).val(sheet1.GetCellValue(nRow, "approvalStatus"	));
	}
	
	function fnSetStatus(Row) {
		$(".status_info", "#funcBtnList").remove();
		
		var activeYyyy = sheet1.GetCellValue(Row, "activeYyyy"), halfGubunType = sheet1.GetCellValue(Row, "halfGubunType"), statusData = prevStatusMap[activeYyyy + "_" + halfGubunType];
		if( statusData == undefined || statusData == null ) {
			statusData = {
				  "activeYyyy"       : activeYyyy
				, "halfGubunType"    : halfGubunType
				, "reportCompleteYn" : "N"
				, "ratingCompleteYn" : "N"
			};
		}
		
		$("#funcBtnList").prepend(
			$("<span/>", {
				"class" : "status_info bd_r6 bg_gray_e pad-x-10 pad-y-5 mar10"
			}).text("자기신고서 : ").append(
				$("<i/>", {
					"class" : ((statusData.reportCompleteYn == "N") ? "far fa-times-circle" : "fas fa-check-circle f_point") + " f_s14 mal5"
				})
			)
		);
		$("#funcBtnList .status_info").after(
			$("<span/>", {
				"class" : "status_info bd_r6 bg_gray_e pad-x-10 pad-y-5 mar10"
			}).text("자기평가 : ").append(
				$("<i/>", {
					"class" : ((statusData.ratingCompleteYn == "N") ? "far fa-times-circle" : "fas fa-check-circle f_point") + " f_s14 mal5"
				})
			)
		);
		
		/*
		if( !(statusData.reportCompleteYn == "Y" && statusData.ratingCompleteYn == "Y") ) {
			if( statusData.reportCompleteYn == "N" && statusData.ratingCompleteYn == "N" ) {
				alert("해당 기간에 대한 자기신고서 및 스킬/지식자기평가가 완료되지 않았습니다.")
			} else if( statusData.reportCompleteYn == "Y" && statusData.ratingCompleteYn == "N" ) {
				alert("해당 기간에 대한 스킬/지식자기평가가 완료되지 않았습니다.")
			} else if( statusData.reportCompleteYn == "N" && statusData.ratingCompleteYn == "Y" ) {
				alert("해당 기간에 대한 자기신고서의 작성이 완료되지 않았습니다.")
			}
			$("a", "#funcBtnList").hide();
		}
		*/
	}
	
	function setPrevStatusData(searchSabun) {
		var params = "searchSabun=" + searchSabun;
		var data = ajaxCall("${ctx}/SelfDevelopmentApp.do?cmd=getSelfDevelopmentPrevStepStatusList", params, false);
		
		prevStatusMap = {};
		if( data && data != null && data.DATA && data.DATA != null && data.DATA.length > 0 ) {
			data.DATA.forEach(function(item, idx, arr) {
				prevStatusMap[item.keyNm] = item;
			});
		}
	}

	// 헤더에서 호출
	function setEmpPage() {
		
		// 하단 탭 내용 초기화
		fnClearSheetInc();
		
		// set sabun
		$("#searchSabun").val($("#searchUserId").val());
		
		doAction1("Search");
	}

	function getReturnValue(returnValue) {
		doAction1("Search");
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="srchFrm" name="srchFrm">
		<input type="hidden" id="tabsIndex"      name="tabsIndex"      value=""    />
		<input type="hidden" id="approvalStatus" name="approvalStatus" value=""    />
		<input type="hidden" id="prgType"        name="prgType"        value="App" />
		<input type="hidden" id="searchSabun"    name="searchSabun"    value=""    />
	</form>
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='BLANK' mdef='자기계발 계획서'/></li>
				<li class="btn">
					<tit:txt mid='BLANK' mdef='년도'/> <input id="sYear" name="sYear" type="text"  maxlength="4" class="text required center date" value="${curSysYear}"/> ~
					<input id="eYear" name="eYear" type="text"  maxlength="4" class="text required center date" value="${curSysYear}"/>
					<btn:a href="javascript:doAction1('Search');" css="button"	  mid='110697' mdef="조회"/>
					<btn:a href="javascript:doAction1('Insert');" css="basic" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction1('Save');"   css="basic" mid='110708' mdef="저장"/>
					<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<div class="outer">
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "150px", "${ssnLocaleCd}"); </script>
	</div>

	<%@ include file="/WEB-INF/jsp/hrd/selfDevelopment/selfDevelopmentApp/selfDevelopmentInc.jsp"%>
</div>
</body>
</html>
