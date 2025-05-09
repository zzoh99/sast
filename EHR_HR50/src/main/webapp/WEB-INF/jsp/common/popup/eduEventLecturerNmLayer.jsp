<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap"><head><title>강사내역팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<script type="text/javascript">

	var eduSeq		=	"";
	var eduCourseNm	=	"";
	var eduEventSeq	=	"";
	var eduEventNm	=	"";
	var searchTeacherGb = "";

	var arg = null;

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('eduEventLecturerNmLayer');
		var arg = modal.parameters;

		if( arg != undefined ) {
			eduSeq			=	arg["eduSeq"		];
			eduCourseNm		=	arg["eduCourseNm"	];
			eduEventSeq		=	arg["eduEventSeq"	];
			eduEventNm		=	arg["eduEventNm"	];
	    } else {
			if ( arg.eduSeq != null ) { eduSeq = arg.eduSeq }
			if ( arg.eduCourseNm != null ) { eduCourseNm = arg.eduCourseNm }
			if ( arg.eduEventSeq != null ) { eduEventSeq = arg.eduEventSeq }
			if ( arg.eduEventNm != null ) { eduEventNm = arg.eduEventNm }
	    }

		createIBSheet3(document.getElementById('eduEventLecturerNmLayerSht1-wrap'), "eduEventLecturerNmLayerSht1", "100%", "100%","${ssnLocaleCd}");

//===================================================================================================================================================

		var searchTeacherGb = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20020"), "<tit:txt mid='103895' mdef='전체'/>"); // 강사구분(L20020)
		var searchBankCd    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "<tit:txt mid='103895' mdef='전체'/>"); // 은행구분(H30001)

		//$("#searchTeacherGb").html(searchTeacherGb[2]);

//===================================================================================================================================================

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"강사순번",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherSeq",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='teacherGbV1' mdef='강사구분'/>",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"teacherGb",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='teacherNo' mdef='강사번호'/>",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherNo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"강사명",				Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"teacherNm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",				Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"enterNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",				Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='telNoV1' mdef='전화번호'/>",			Type:"Text",		Hidden:1,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	Format:"PhoneNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='hosTelNo' mdef='자택연락처'/>",			Type:"Text",		Hidden:1,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"homeTelNo",		KeyField:0,	Format:"PhoneNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",				Type:"Text",		Hidden:1,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"addr",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"경력",				Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"career",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='lecture' mdef='강의과목'/>",			Type:"Text",		Hidden:1,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"subjectLecture",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"강의료",				Type:"Int",			Hidden:1,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"lectureFee",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='noteV2' mdef='특이사항'/>",			Type:"Text",		Hidden:1,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='bankCdV1' mdef='은행구분'/>",			Type:"Combo",		Hidden:1,	Width:140,	Align:"Left",	ColMerge:0,	SaveName:"bankCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='accountNo' mdef='계좌번호'/>",			Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"accHolder",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"계좌명",				Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"accNo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",		Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
        ]; IBS_InitSheet(eduEventLecturerNmLayerSht1, initdata);eduEventLecturerNmLayerSht1.SetEditable("${editable}");eduEventLecturerNmLayerSht1.SetVisible(true);eduEventLecturerNmLayerSht1.SetCountPosition(4);eduEventLecturerNmLayerSht1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");eduEventLecturerNmLayerSht1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");eduEventLecturerNmLayerSht1.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");

        eduEventLecturerNmLayerSht1.SetColProperty("teacherGb", 		{ComboText:"|"+searchTeacherGb[0], ComboCode:"|"+searchTeacherGb[1]} );
		eduEventLecturerNmLayerSht1.SetColProperty("bankCd", 		{ComboText:"|"+searchBankCd[0], ComboCode:"|"+searchBankCd[1]} );

	    $(window).smartresize(sheetResize); sheetInit();

	    doAction1("Search");

        $("#searchTeacherNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
	});



	/*Sheet1 Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			eduEventLecturerNmLayerSht1.DoSearch( "${ctx}/EduLecturerMgr.do?cmd=getEduLecturerMgrList", $("#eduEventLecturerNmLayerSht1Form").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function eduEventLecturerNmLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function eduEventLecturerNmLayerSht1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var rv = new Array();

		rv["teacherSeq"]		=	eduEventLecturerNmLayerSht1.GetCellValue(Row,"teacherSeq"		);
		rv["teacherGb"]			=	eduEventLecturerNmLayerSht1.GetCellValue(Row,"teacherGb"			);
		rv["teacherNo"]			=	eduEventLecturerNmLayerSht1.GetCellValue(Row,"teacherNo"			);
		rv["teacherNm"]			=	eduEventLecturerNmLayerSht1.GetCellValue(Row,"teacherNm"			);
		rv["telNo"]				=	eduEventLecturerNmLayerSht1.GetCellValue(Row,"telNo"				);
		rv["subjectLecture"]	=	eduEventLecturerNmLayerSht1.GetCellValue(Row,"subjectLecture"	);
		rv["lectureFee"]		=	eduEventLecturerNmLayerSht1.GetCellValue(Row,"lectureFee"		);

		const modal = window.top.document.LayerModalUtility.getModal('eduEventLecturerNmLayer');
		modal.fire('eduEventLecturerNmLayerTrigger', rv).hide();
	}
</script>

</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
	        <div class="sheet_search outer">
				<form id="eduEventLecturerNmLayerSht1Form" name="eduEventLecturerNmLayerSht1Form" >
				<div>
					<input type="hidden" id="searchTeacherGb" name="searchTeacherGb" value="" style="ime-mode:active;" />
					<table>
						<tr>
							<th>강사명</th>
							<td>
								<input type="text" id="searchTeacherNm" name="searchTeacherNm" class="text" value="" />
							</td>
							<td>
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
				</form>
			</div>

			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">강사정보</li>
							</ul>
						</div>
					</div>
					<div id="eduEventLecturerNmLayerSht1-wrap"></div>
				</td>
			</tr>
			</table>
		</div>
		
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('eduEventLecturerNmLayer');" css="gray large" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>
