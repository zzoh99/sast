<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var checkType="";

	var arg = p.popDialogArgumentAll();


	$(function() {

		if( arg != "undefined" ) {
			checkType		= arg["checkType"];
			$("#checkType").val(checkType);
			$("#searchApplSabun").val(arg["searchApplSabun"]);
			// 내외부교육구분 1:내부, 2:외부
			$("#searchItemGubun").val(arg["itemGubun"]);



		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",  Hidden:0,	 Width:"${sNoWdt}",		Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}", Hidden:1,	 Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}", Hidden:1,	 Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"selectImg",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",				Type:"Text",      Hidden:0,  Width:100, Align:"Left",    ColMerge:1,   SaveName:"eduCourseNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduEventSeq' mdef='회차순번'/>",			Type:"Text",      Hidden:1,  Width:0,   Align:"Left",    ColMerge:1,   SaveName:"eduEventSeq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduEventNm' mdef='회차명'/>",				Type:"Text",      Hidden:0,  Width:50,  Align:"Left",    ColMerge:1,   SaveName:"eduEventNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduOrgCdV1' mdef='교육기관코드'/>",		Type:"Text",      Hidden:1,  Width:50,  Align:"Left",    ColMerge:1,   SaveName:"eduOrgCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",			Type:"Text",      Hidden:0,  Width:50,  Align:"Left",    ColMerge:1,   SaveName:"eduOrgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='dd' mdef='일'/>",				Type:"Float",     Hidden:0,  Width:30,  Align:"Right",   ColMerge:0,   SaveName:"eduDay",          KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='eduHourV1' mdef='시간'/>",				Type:"Float",     Hidden:0,  Width:30,  Align:"Right",   ColMerge:1,   SaveName:"eduHour",         KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>", 			Type:"Date",      Hidden:0,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduSYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",				Type:"Date",      Hidden:0,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduEYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='laborApplyYnV1' mdef='고용보험적용여부'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"laborApplyYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduBranchCd' mdef='교육구분'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduBranchCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduMBranchCd' mdef='교육분류'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
			{Header:"<sht:txt mid='eduMethodCd' mdef='시행방법'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduMethodCd",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
			{Header:"<sht:txt mid='essentialYn' mdef='필수여부'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"mandatoryYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='inOutTypeV1' mdef='사내외구분'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"inOutType",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='applSYmd' mdef='교육신청일'/>",			Type:"Date",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"applSYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='applEYmd' mdef='교육마감일'/>",			Type:"Date",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"applEYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduStatusCd' mdef='교육과정상태'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduStatusCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='chargeSabunV1' mdef='담당자사번'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"chargeSabun",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='chargeNameV1' mdef='담당자성명'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"chargeName",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='orgCdV14' mdef='담당자소속'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"orgCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmV19' mdef='담당자소속cd'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"orgNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='telNoV3' mdef='담당자연락처'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"telNo",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='lecturerCost' mdef='강사료'/>",				Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"lecturerCost",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='establishmentCost' mdef='시설사용료'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"establishmentCost",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='foodCost' mdef='식비'/>",				Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"foodCost",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='transpCost' mdef='기타비용'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"transpCost",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='laborApplyYnV1' mdef='고용보험적용여부'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"laborApplyYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='maxPerson' mdef='수강인원최대'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"maxPerson",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='minPerson' mdef='수강인원최소'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"minPerson",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduBranchNm' mdef='eduBranchNm'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduBranchNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduMBranchNm' mdef='eduMBranchNm'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduMBranchNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduPlaceV1' mdef='eduPlace'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduPlace",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='perExpenseMonV1' mdef='perExpenseMon'/>",	Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"perExpenseMon",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='laborMonV1' mdef='laborMon'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"laborMon",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduSeqV2' mdef='eduSeq'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduSeq",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduSHm' mdef='eduSHm'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduSHm",         KeyField:0,   CalcLogic:"",   Format:"Hm",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduEHm' mdef='eduEHm'/>",			Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"eduEHm",         KeyField:0,   CalcLogic:"",   Format:"Hm",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='currencyCdV1' mdef='currencyCd'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"currencyCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='realExpenseMon' mdef='realExpenseMon'/>",	Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"realExpenseMon",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduRewardCdV1' mdef='eduRewardCd'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"eduRewardCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduRewardCntV1' mdef='eduRewardCnt'/>",		Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"eduRewardCnt",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },

			{Header:"FILE_SEQ",			Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"fileSeq",    KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");

			sheet1.SetDataLinkMouse("selectImg", 1);

			$(window).smartresize(sheetResize); sheetInit();

			doAction1("Search");

		$(".close").click(function() {
			p.self.close();
		});
	});



	/*Sheet1 Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "${ctx}/TRMManage.do?cmd=getTRMEduPopupList", $("#sheet1Form").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value){
		try{
			if( sheet1.ColSaveName(Col) == "selectImg"	&& Row >= sheet1.HeaderRows() ) {
				eduEventMgrPopup(Row) ;
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		if (Row < sheet1.HeaderRows()) return;

		var rv = new Array(1);

		rv["eduCourseNm"		]	=	sheet1.GetCellValue(Row,"eduCourseNm"		);
		rv["eduEventSeq"		]	=	sheet1.GetCellValue(Row,"eduEventSeq"		);
		rv["eduEventNm"			]	=	sheet1.GetCellValue(Row,"eduEventNm"		);
		rv["eduOrgCd"			]	=	sheet1.GetCellValue(Row,"eduOrgCd"			);
		rv["eduOrgNm"			]	=	sheet1.GetCellValue(Row,"eduOrgNm"			);
		rv["eduDay"				]	=	sheet1.GetCellValue(Row,"eduDay"			);
		rv["eduHour"			]	=	sheet1.GetCellValue(Row,"eduHour"			);
		rv["eduSYmd"			]	=	sheet1.GetCellValue(Row,"eduSYmd"			);
		rv["eduEYmd"			]	=	sheet1.GetCellValue(Row,"eduEYmd"			);
		rv["laborApplyYn"		]	=	sheet1.GetCellValue(Row,"laborApplyYn"		);
		rv["eduBranchCd"		]	=	sheet1.GetCellValue(Row,"eduBranchCd"		);
		rv["eduMBranchCd"		]	=	sheet1.GetCellValue(Row,"eduMBranchCd"		);
		rv["eduMethodCd"		]	=	sheet1.GetCellValue(Row,"eduMethodCd"		);
		rv["mandatoryYn"		]	=	sheet1.GetCellValue(Row,"mandatoryYn"		);
		rv["inOutType"			]	=	sheet1.GetCellValue(Row,"inOutType"			);
		rv["applSYmd"			]	=	sheet1.GetCellValue(Row,"applSYmd"			);
		rv["applEYmd"			]	=	sheet1.GetCellValue(Row,"applEYmd"			);
		rv["eduStatusCd"		]	=	sheet1.GetCellValue(Row,"eduStatusCd"		);
		rv["chargeSabun"		]	=	sheet1.GetCellValue(Row,"chargeSabun"		);
		rv["chargeName"			]	=	sheet1.GetCellValue(Row,"chargeName"		);
		rv["telNo"				]	=	sheet1.GetCellValue(Row,"telNo"				);
		rv["orgCd"				]	=	sheet1.GetCellValue(Row,"orgCd"				);
		rv["orgNm"				]	=	sheet1.GetCellValue(Row,"orgNm"				);
		rv["eduBranchNm"		]	=	sheet1.GetCellValue(Row,"eduBranchNm"		);
		rv["eduMBranchNm"		]	=	sheet1.GetCellValue(Row,"eduMBranchNm"		);
		rv["eduPlace"			]	=	sheet1.GetCellValue(Row,"eduPlace"			);
		rv["perExpenseMon"		]	=	sheet1.GetCellValue(Row,"perExpenseMon"		);
		rv["laborMon"			]	=	sheet1.GetCellValue(Row,"laborMon"			);
		rv["eduSeq"				]	=	sheet1.GetCellValue(Row,"eduSeq"			);

		rv["lecturerCost"		]	=	sheet1.GetCellValue(Row,"lecturerCost"		);
		rv["establishmentCost"	]	=	sheet1.GetCellValue(Row,"establishmentCost"	);
		rv["foodCost"			]	=	sheet1.GetCellValue(Row,"foodCost"			);
		rv["transpCost"			]	=	sheet1.GetCellValue(Row,"transpCost"		);
		rv["laborApplyYn"		]	=	sheet1.GetCellValue(Row,"laborApplyYn"		);
		rv["maxPerson"			]	=	sheet1.GetCellValue(Row,"maxPerson"			);
		rv["minPerson"			]	=	sheet1.GetCellValue(Row,"minPerson"			);
		rv["currencyCd"			]	=	sheet1.GetCellValue(Row,"currencyCd"		);
		rv["perExpenseMon"		]	=	sheet1.GetCellValue(Row,"perExpenseMon"		);
		rv["totExpenseMon"		]	=	sheet1.GetCellValue(Row,"totExpenseMon"		);
		rv["realExpenseMon"		]	=	sheet1.GetCellValue(Row,"realExpenseMon"	);
		rv["innerYn"			]	=	sheet1.GetCellValue(Row,"innerYn"			);
		rv["lecturerNm"			]	=	sheet1.GetCellValue(Row,"lecturerNm"		);
		rv["lecturerTelNo"		]	=	sheet1.GetCellValue(Row,"lecturerTelNo"		);
		rv["eduRewardCd"		]	=	sheet1.GetCellValue(Row,"eduRewardCd"		);
		rv["eduRewardCnt"		]	=	sheet1.GetCellValue(Row,"eduRewardCnt"		);

		p.popReturnValue(rv);
		p.window.close();
	}

	/**
	 * 상세내역 window open event
	 */
	function eduEventMgrPopup(Row){
		if(!isPopup()) {return;}

		//EduCourseDetail.jsp
		var w 		= 1100;
		var h 		= 800;
		var url 	= "${ctx}/EduEventMgr.do?cmd=viewEduEventMgrPopup&authPg=R";
		var args 	= new Array();

		args["eduSeq"] 			= sheet1.GetCellValue(Row, "eduSeq");
		args["eduCourseNm"] 	= sheet1.GetCellValue(Row, "eduCourseNm");
		args["eduCourseSub"] 	= sheet1.GetCellValue(Row, "eduCourseSub");
		args["eduEventSeq"] 	= sheet1.GetCellValue(Row, "eduEventSeq");
		args["eduEventNm"] 		= sheet1.GetCellValue(Row, "eduEventNm");
		args["eduStatusCd"] 	= sheet1.GetCellValue(Row, "eduStatusCd");
		args["eduOrgCd"] 		= sheet1.GetCellValue(Row, "eduOrgCd");
		args["eduOrgNm"] 		= sheet1.GetCellValue(Row, "eduOrgNm");
		args["eduPlace"] 		= sheet1.GetCellValue(Row, "eduPlace");
		args["eduPlaceEtc"] 	= sheet1.GetCellValue(Row, "eduPlaceEtc");
		args["eduDay"] 			= sheet1.GetCellValue(Row, "eduDay");
		args["eduHour"] 		= sheet1.GetCellValue(Row, "eduHour");
		args["eduSYmd"] 		= sheet1.GetCellText(Row, "eduSYmd");
		args["eduSHm"] 			= sheet1.GetCellText(Row, "eduSHm");
		args["eduEYmd"] 		= sheet1.GetCellText(Row, "eduEYmd");
		args["eduEHm"] 			= sheet1.GetCellText(Row, "eduEHm");
		args["applSYmd"] 		= sheet1.GetCellText(Row, "applSYmd");
		args["applEYmd"] 		= sheet1.GetCellText(Row, "applEYmd");
		args["minPerson"] 		= sheet1.GetCellValue(Row, "minPerson");
		args["maxPerson"] 		= sheet1.GetCellValue(Row, "maxPerson");
		args["lecturerCost"] 	= sheet1.GetCellValue(Row, "lecturerCost");    /*	추가	*/
		args["establishmentCost"]= sheet1.GetCellValue(Row, "establishmentCost");	/*	추가	*/
		args["foodCost"] 		= sheet1.GetCellValue(Row, "foodCost");	/*	추가	*/
		args["transpCost"] 		= sheet1.GetCellValue(Row, "transpCost");	/*	추가	*/
		args["currencyCd"] 		= sheet1.GetCellValue(Row, "currencyCd");
		args["perExpenseMon"] 	= sheet1.GetCellValue(Row, "perExpenseMon");
		args["totExpenseMon"] 	= sheet1.GetCellValue(Row, "totExpenseMon");
		args["laborApplyYn"] 	= sheet1.GetCellValue(Row, "laborApplyYn");
		args["laborMon"] 		= sheet1.GetCellValue(Row, "laborMon");
		args["realExpenseMon"] 	= sheet1.GetCellValue(Row, "realExpenseMon");
		args["innerYn"] 		= sheet1.GetCellValue(Row, "innerYn");
		args["chargeSabun"] 	= sheet1.GetCellValue(Row, "chargeSabun");
		args["chargeName"] 		= sheet1.GetCellValue(Row, "chargeName");
		args["orgCd"] 			= sheet1.GetCellValue(Row, "orgCd");
		args["orgNm"] 			= sheet1.GetCellValue(Row, "orgNm");
		args["telNo"] 			= sheet1.GetCellValue(Row, "telNo");
		args["lecturerNm"] 		= sheet1.GetCellValue(Row, "lecturerNm");
		args["lecturerTelNo"] 	= sheet1.GetCellValue(Row, "lecturerTelNo");
		args["eduRewardCd"] 	= sheet1.GetCellValue(Row, "eduRewardCd");
		args["eduRewardCnt"] 	= sheet1.GetCellValue(Row, "eduRewardCnt");
		args["sStatus"] = sheet1.GetCellValue(Row,"sStatus");

		openPopup(url,args,w,h);
	}



</script>


</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchApplSabun"   name="searchApplSabun"  value="" />
	<input type="hidden" id="checkType"         name="checkType"        value="Y"/>
	<input type="hidden" id="searchItemGubun"   name="searchItemGubun"  value="" />
</form>
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='eduAppDetPop' mdef='회차별'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
        	<div id="tabs">
				<ul class="outer tab_bottom">
				</ul>
				<div id="tabs-1">
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</div>

			</div>

			<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>
