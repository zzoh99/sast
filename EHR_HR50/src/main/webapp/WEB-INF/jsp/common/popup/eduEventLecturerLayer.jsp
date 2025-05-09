<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<script type="text/javascript">

	var eduSeq		=	"";
	var eduCourseNm	=	"";
	var eduEventSeq	=	"";
	var eduEventNm	=	"";
	var gPRow = "";
	var pGubun = "";

	var arg = null;

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('eduEventLecturerLayer');
		arg = modal.parameters;

		if( arg != undefined ) {
			eduSeq			=	arg["eduSeq"		];
			eduCourseNm		=	arg["eduCourseNm"	];
			eduEventSeq		=	arg["eduEventSeq"	];
			eduEventNm		=	arg["eduEventNm"	];
		}

		$("#eduSeq").val(eduSeq);
		$("#eduEventSeq").val(eduEventSeq);
		$("#eduInfo").html(eduCourseNm +" - "+eduEventNm);

		createIBSheet3(document.getElementById('eduEventLecturerLayerSht1-wrap'), "eduEventLecturerLayerSht1", "100%", "100%","${ssnLocaleCd}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='teacherNo' mdef='강사번호'/>",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='teacherNmV1' mdef='강사성명'/>",					Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"teacherNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='lecture' mdef='강의과목'/>",					Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"subjectLecture",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='telNo' mdef='연락처'/>",						Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20, AcceptKeys:"N|[-]" },
			{Header:"강의료",						Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"lectureFee",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",						Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"교육과정별회차_강사순번",			Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
			
		]; IBS_InitSheet(eduEventLecturerLayerSht1, initdata);eduEventLecturerLayerSht1.SetEditable("${editable}");eduEventLecturerLayerSht1.SetVisible(true);eduEventLecturerLayerSht1.SetCountPosition(4);eduEventLecturerLayerSht1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");eduEventLecturerLayerSht1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");eduEventLecturerLayerSht1.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");
		
		$(window).smartresize(sheetResize); sheetInit();
		
		eduEventLecturerLayerAction1("Search");
	});

	/*Sheet1 Action*/
	function eduEventLecturerLayerAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			eduEventLecturerLayerSht1.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduEventLecturerPopupList", $("#eduEventLecturerLayerForm").serialize() );
			break;
		case "Insert": 		//입력
			var Row = eduEventLecturerLayerSht1.DataInsert(0);
			eduEventLecturerLayerSht1.SetCellValue(Row,"eduSeq",		eduSeq		);
			eduEventLecturerLayerSht1.SetCellValue(Row,"eduCourseNm",	eduCourseNm	);
			eduEventLecturerLayerSht1.SetCellValue(Row,"eduEventSeq",	eduEventSeq	);
			eduEventLecturerLayerSht1.SetCellValue(Row,"eduEventNm",	eduEventNm	);
			break;
		case "Save"	:

			IBS_SaveName(document.eduEventLecturerLayerForm,eduEventLecturerLayerSht1);
			eduEventLecturerLayerSht1.DoSave( "${ctx}/EduCourseMgr.do?cmd=saveEduEventLecturerPopup", $("#eduEventLecturerLayerForm").serialize() );
			break;
		case "Copy":        //행복사
			var Row = eduEventLecturerLayerSht1.DataCopy();
			break;
		}
	}

	// 	조회 후 에러 메시지
	function eduEventLecturerLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function eduEventLecturerLayerSht1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { alert(Msg); } 
			if ( Code > -1 ) eduEventLecturerLayerAction1("Search"); 
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function eduEventLecturerLayerSht1_OnPopupClick(Row, Col){
		try{


			if(eduEventLecturerLayerSht1.ColSaveName(Col) == "teacherNm"){
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "viewEduEventLecturerNmPopup";

				var args	= new Array();
				args["eduSeq"]	= eduEventLecturerLayerSht1.GetCellValue( Row, "eduSeq" );

				let modalLayer = new window.top.document.LayerModal({
					id : 'eduEventLecturerNmLayer'
					, url : "${ctx}/Popup.do?cmd=viewEduEventLecturerNmLayer"
					, parameters: args
					, width : 350
					, height : 600
					, title : "강사선택"
					, trigger :[
						{
							name : 'eduEventLecturerNmLayerTrigger'
							, callback : function(rv){
								eduEventLecturerLayerSht1.SetCellValue(gPRow, "teacherSeq",		rv["teacherSeq"] );
								eduEventLecturerLayerSht1.SetCellValue(gPRow, "teacherGb",			rv["teacherGb"] );
								eduEventLecturerLayerSht1.SetCellValue(gPRow, "teacherNo",			rv["teacherNo"] );
								eduEventLecturerLayerSht1.SetCellValue(gPRow, "teacherNm",			rv["teacherNm"] );
								eduEventLecturerLayerSht1.SetCellValue(gPRow, "telNo",				rv["telNo"] );
								eduEventLecturerLayerSht1.SetCellValue(gPRow, "subjectLecture",	rv["subjectLecture"] );
								eduEventLecturerLayerSht1.SetCellValue(gPRow, "lectureFee",		rv["lectureFee"] );
							}
						}
					]
				});
				modalLayer.show();
			}
		}catch(ex){
			alert("OnPopupClick Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<form id="eduEventLecturerLayerForm" name="eduEventLecturerLayerForm" >
	<input type="hidden" id="eduSeq"		 name="eduSeq" value=""/>
	<input type="hidden" id="eduEventSeq"  name="eduEventSeq" value=""/>
</form>
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<div class="sheet_title">
				<ul>
					<li class="txt" id="eduInfo">
					</li>
					<li class="btn">
						<btn:a href="javascript:eduEventLecturerLayerAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
						<btn:a href="javascript:eduEventLecturerLayerAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:eduEventLecturerLayerAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
					</li>
				</ul>
			</div>
			<div id="eduEventLecturerLayerSht1-wrap"></div>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('eduEventLecturerLayer')" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>
