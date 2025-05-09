<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"	},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:0,Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0	},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:0,Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0	},

			{Header:"<sht:txt mid='temp1V3' mdef='결과\n보고'/>",			Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"temp1",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='applStatusCdV2' mdef='신청상태'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='applYmdV5' mdef='신청일'/>",				Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",	KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduSeqV1' mdef='교육순번'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"eduSeq",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduEventSeqV1' mdef='교육회차순번'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"eduEventSeq",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduEventNmV4' mdef='회차(EVENT)명'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduEventNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sabun",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='apApplSeqV2' mdef='신청서순번'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"applSeq",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",			Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduMetodNm' mdef='교육형태'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduMetodNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='mandatoryYnV2' mdef='선택구분'/>",			Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"mandatoryYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduMBranchCdV1' mdef='교육체계'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduMBranchNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduSYmdV1' mdef='교육시작일'/>",			Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSYmd",	KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduEYmdV1' mdef='교육종료일'/>",			Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduEYmd",	KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduCntDate' mdef='교육일수'/>",			Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"eduCntDate",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduHour' mdef='교육시간'/>",			Type:"Text",	Hidden:1,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"eduHour",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduPlace' mdef='교육장소'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"eduPlace",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='itemCnt' mdef='만족도항목수'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"itemCnt",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='eduSurveyYnV1' mdef='만족도결과여부'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"eduSurveyYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='apApplSeq' mdef='결과보고신청서순번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"apApplSeq",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"만족도조사SKIP여부",	Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"eduSatiSkipYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	}
			];	IBS_InitSheet(sheet1,	initdata);sheet1.SetVisible(true);

  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("temp1", 1);

		var list = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20030"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("mandatoryYn", 	{ComboText:"|"+list[0], ComboCode:"|"+list[1]} );

 		//  결재상태
 		var applStatusCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");
		sheet1.SetColProperty("applStatusCd", 			{ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );
		$(window).smartresize(sheetResize); sheetInit();

		setEmpPage();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/EduResultLst.do?cmd=getEduResultLstList", $("#sheet1Form").serialize() ); break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/EduResultLst.do?cmd=saveEduResultLst", $("#sheet1Form").serialize()); break;
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

			for ( var iRow=1; iRow < sheet1.RowCount()+1 ; iRow++) {
				//결재반려(23),수신반려(33),합의반려(43) 건 삭제 가능하도록 체크박스 활성화, 나머지는 비활성화
		    	if(sheet1.GetCellValue(iRow, "applStatusCd") == "23" || sheet1.GetCellValue(iRow, "applStatusCd") == "33" || sheet1.GetCellValue(iRow, "applStatusCd") == "43"){
		    		sheet1.SetCellEditable(iRow, "sDelete",true);
		    	}else{
		    		sheet1.SetCellEditable(iRow, "sDelete",false);
		    	}
			}

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			//결재반려(23),수신반려(33),합의반려(43) 건 삭제 가능하도록 체크박스 활성화, 나머지는 비활성화
			if( sheet1.ColSaveName(Col) == "sDelete"  && Row >= sheet1.HeaderRows()) {
				if(sheet1.GetCellValue(Row,"applStatusCd") != "23" && sheet1.GetCellValue(Row,"applStatusCd") != "33" && sheet1.GetCellValue(Row,"applStatusCd") != "43"){
					alert("<msg:txt mid='alertEduResultLst1' mdef='교육완료보고내역 삭제는 반려된 건만 가능합니다.'/>");
					return false;
				}
			}

		    if( sheet1.ColSaveName(Col) == "temp1"  && Row >= sheet1.HeaderRows() ) {
		    	if(!isPopup()) {return;}

		    	if ( sheet1.GetCellValue(Row, "eduSatiSkipYn") == "N" ){//만족도스킵여부

			    	if(sheet1.GetCellValue(Row,"itemCnt") > 0 && sheet1.GetCellValue(Row,"eduSurveyYn") != "Y" ){//만족도결과여부
						alert("<msg:txt mid='alertEduResultLst2' mdef='해당 교육의 전 수료자의 교육만족도 조사 완료 후 결과보고를 신청하시기 바랍니다.'/>");
	                    return;

						gPRow = "";
						pGubun = "viewEduSurveryPopup";

						const p = {
							searchApplSabun: $("#searchUserId").val(),
							searchApplSeq: sheet1.GetCellValue(Row, "apApplSeq"),
							searchEduSeq: sheet1.GetCellValue(Row, "eduSeq"),
							searchEduEventSeq: sheet1.GetCellValue(Row, "eduEventSeq"),
							searchEduSurveyYn: sheet1.GetCellValue(Row, "eduSurveyYn"),
							authPg: "A"
						};

						let eduSurveryLayer = new window.top.document.LayerModal({
							id : 'eduSurveryLayer',
							url : '${ctx}/EduApp.do?cmd=viewEduSurveryPopup',
							parameters : p,
							width : 880,
							height : 850,
							title : '<tit:txt mid='eduSurvery' mdef='교육만족도조사'/>',
							trigger :[
								{
									name : 'eduSurveryTrigger',
									callback : function(rv){
										getReturnValue(rv);
									}
								}
							]
						});
						eduSurveryLayer.show();
						return;
					}else if (sheet1.GetCellValue(Row,"itemCnt") == 0 && sheet1.GetCellValue(Row,"eduSurveyYn") != "Y" ) {
						alert("해당 교육의 만족도 설문 항목이 없습니다.");
						return;
					}else if(sheet1.GetCellValue(Row,"itemCnt") > 0 && sheet1.GetCellValue(Row,"eduSurveyYn") == "Y" ){

						var auth = "R";
				    	if(sheet1.GetCellValue(Row, "applStatusCd") == "" || sheet1.GetCellValue(Row, "applStatusCd") == "11") {
				    		//신청 팝업
				    		auth = "A";
				    	} else {
				    		//결재팝업
				    		auth = "R";
				    	}

				    	showApplPopup(auth, sheet1.GetCellValue(Row,"applSeq"), $("#searchUserId").val(), $("#searchUserId").val(), '${curSysYyyyMMdd}', Row);
					}

		    	}else if ( sheet1.GetCellValue(Row, "eduSatiSkipYn") == "Y" ){

		    		var auth = "R";
			    	if(sheet1.GetCellValue(Row, "applStatusCd") == "" || sheet1.GetCellValue(Row, "applStatusCd") == "11") {
			    		//신청 팝업
			    		auth = "A";
			    	} else {
			    		//결재팝업
			    		auth = "R";
			    	}

			    	showApplPopup(auth, sheet1.GetCellValue(Row,"applSeq"), $("#searchUserId").val(), $("#searchUserId").val(), '${curSysYyyyMMdd}', Row);

		    	}
		    }

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }

	//신청 팝업, 결과팝업
	function showApplPopup(auth,seq,sabun,applSabun,applYmd, Row) {
    	if(!isPopup()) {return;}

		var p = {
				searchApplCd: '131'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: sabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd
			  , etc01: sheet1.GetCellValue(Row,"apApplSeq")
			  , etc02: sheet1.GetCellValue(Row,"sabun")
			};
		
		var url = '';
		var initFunc = '';
		if(auth == "A") {
			url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}

		var args = new Array(5);
		gPRow = "";
		pGubun = "viewApprovalMgr";

		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '신청서',
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

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
        if(pGubun == "viewEduSurveryPopup" || pGubun == "viewApprovalMgr"){
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
<!-- 		<div class="sheet_search outer"> -->
<!-- 			<div> -->
<!-- 				<table> -->
<!-- 					<tr> -->
<!-- 					</tr> -->
<!-- 				</table> -->
<!-- 			</div> -->
<!-- 		</div> -->
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='eduResultLst' mdef='교육결과보고'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
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
