<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='pwrSrchCdElemtMgr' mdef='조건검색코드항목관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
	    var grCobmboList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "전체",-1);
	    var grCobmboList2	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W82020"), "",-1);
	    var recevTypeList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R30020"), "",-1);
	    var addressGubun 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20185"), "",-1);
	    sheet1.SetDataLinkMouse("temp1", 1);
	    sheet1.SetDataLinkMouse("temp2", 1);
	    sheet1.SetDataLinkMouse("etcNote", 1);
	    sheet1.SetDataLinkMouse("fileSeq", 1);
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:6, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		    //수정시 줄좀 맞춥시다..
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	       	{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",		Hidden:1,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"temp2",       	 Cursor:"Pointer"},
			{Header:"<sht:txt mid='applCd' mdef='신청서코드'/>",			Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='applNm' mdef='신청서명'/>",			Type:"Text",		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"applNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='note1V1' mdef='약어명'/>",				Type:"Text",		Hidden:0,  Width:130,  Align:"Center",  ColMerge:0,   SaveName:"note1",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='bizCdV1' mdef='업무구분코드'/>",			Type:"Combo",		Hidden:0,  Width:130,  Align:"Center",  ColMerge:0,   SaveName:"bizCd",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='applTitle' mdef='신청/결재\n제목'/>",		Type:"Text",		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"applTitle",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeYn' mdef='결재처리\n필요여부'/>",		Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"agreeYn",        Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N" },
			{Header:"수신처리\n필요여부",		Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"recevYn",        Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='recevType' mdef='수신결재\n등록유형'/>",		Type:"Combo",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"recevType",      Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"수신\n결재자등록",			Type:"Image",		Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"temp1",          Cursor:"Pointer"},

			{Header:"<sht:txt mid='etcNoteYn' mdef='유의사항\n필요여부'/>",		Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"etcNoteYn",        Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='etcNote2' mdef='유의사항\n등록'/>",			Type:"Image",		Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"etcNote2",          Cursor:"Pointer"},
			{Header:"<sht:txt mid='notiYn' mdef='알림여부'/>",					Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"notiYn",         Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='fileYnV2' mdef='첨부파일\n여부'/>",			Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"fileYn",         Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='fileYnV5' mdef='첨부파일\n필수여부'/>",			Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"fileEssentialYn",Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 ,TrueValue:"Y", FalseValue:"N"},
			
			{Header:"<sht:txt mid='reUseYn' mdef='재사용\n가능여부'/>",			Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"reUseYn",Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 ,TrueValue:"Y", FalseValue:"N"},

			{Header:"RD\n출력\n여부",			Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"printYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"RD\n출력가능\n횟수",			Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"prtCnt",         KeyField:0,   CalcLogic:"",   Format:"NullFloat",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:60 },
			{Header:"WEB\n출력\n여부",			Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"webPrintYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 ,TrueValue:"Y", FalseValue:"N"},
			
			{Header:"신청\n주소구분",				Type:"Combo",		Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"applyAddressCd",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100},

			{Header:"<sht:txt mid='orgLevelCd' mdef='결재선LEVEL\n기본값'/>",	Type:"Combo",		Hidden:0,  Width:120,	Align:"Center",  ColMerge:0,   SaveName:"orgLevelCd",     		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 , ToolTipText:"결재 단계 레벨 결재단계가 올라갈수록 결재자가 1명씩 늘어남" },
			{Header:"결재선LEVEL\n조건검색",									Type:"Combo",		Hidden:0,  Width:200,	Align:"Center",  ColMerge:0,   SaveName:"orgLevelSearchSeq",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"결재선LEVEL\n조건검색",									Type:"Image",		Hidden:0,  Width:45,	Align:"Center",  ColMerge:0,   SaveName:"btnSearchSeq",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20  },
			{Header:"결재선LEVEL\n보여주기",									Type:"CheckBox",	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"orgLevelYn",        	Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N" },
			{Header:"결재선변경\n보여주기",									Type:"CheckBox",	Hidden:0,  Width:70,   	Align:"Center",  ColMerge:0,   SaveName:"appPathYn",        	Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"결재완료시\n처리완료여부",									Type:"CheckBox",	Hidden:0,  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"agreeEndYn",     		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"본인결재\n허용여부",			Type:"CheckBox",	Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"pathSelfCloseYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"<sht:txt mid='applSmsYn' mdef='SMS\n발송여부'/>",			Type:"CheckBox",	Hidden:1,  Width:45,   Align:"Center",  ColMerge:0,   SaveName:"applSmsYn",      Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='applMailYn_V3679' mdef='신청(결재)시\n메일발송여부\n(결재자)'/>",	Type:"CheckBox",	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applMailYn",     Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='agreeSmsYn' mdef='결재시SMS\n발송여부'/>",			Type:"Text",		Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"agreeSmsYn",     Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeMailYn_V5704' mdef='처리완료시\n메일발송여부\n(신청자)'/>",	Type:"CheckBox",	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"agreeMailYn",    Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='referMailYn' mdef='처리완료시\n메일발송여부\n(참조자)'/>",	Type:"CheckBox",	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"referMailYn",    Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"제증명서\n여부",			Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"comboViewYn",    Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='visualYnV1' mdef='보여주기\n여부'/>",			Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"visualYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"사용여부",				Type:"CheckBox",	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"useYn",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='personPrintYn' mdef='개인출력\n여부'/>",			Type:"CheckBox",	Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"personPrintYn",  Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"프로시저\n여부",			Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"procExecYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"의견등록\n여부",			Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"commentYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"제목수정\n여부",			Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"titleYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},

			{Header:"<sht:txt mid='note2V1' mdef='그룹웨어\n여부'/>",			Type:"CheckBox",	Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"note2",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",					Type:"Float",		Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"seq",            KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },

			{Header:"신청/결재n프로그램PATH",	Type:"Text",		Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"detailPrgPath",  Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"신청/결재 프로그램ID",	Type:"Text",		Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"detailPrgCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='prtRsc' mdef='출력프로그램'/>",			Type:"Text",		Hidden:0,  Width:200,   Align:"Left",  ColMerge:0,   SaveName:"prtRsc",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:60 },
			{Header:"신청서\n넓이",				Type:"Int",		Hidden:1,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"popWidth",        KeyField:0,   CalcLogic:"",   Format:"NullInteger",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"신청서\n높이",				Type:"Int",		Hidden:1,  Width:55,   Align:"Center",  ColMerge:0,   SaveName:"popHeight",        KeyField:0,   CalcLogic:"",   Format:"NullInteger",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"신청서\n넓이",				Type:"Combo",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"modalWidth",        KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"신청서\n높이",				Type:"Combo",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"modalHeight",        KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='confirmMsg' mdef='신청시\n확인메세지'/>",	Type:"Text",		Hidden:0,  Width:200,  Align:"Left",  ColMerge:0,   SaveName:"confirmMsg",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:999, MultiLineText:1 },
		
			//사용안함
			{Header:"<sht:txt mid='prgCd' mdef='신청프로그램명'/>",			Type:"Text",		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"prgCd",          Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='prgPath' mdef='신청프로그램경로'/>",			Type:"Text",		Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"prgPath",        Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeTitle' mdef='결재제목'/>",			Type:"Text",		Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"agreeTitle",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreePrgCd' mdef='결재프로그램명'/>",		Type:"Text",		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"agreePrgCd",     Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreePrgPath' mdef='결재프로그램경로'/>",		Type:"Text",		Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"agreePrgPath",   Keyfield:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='applWidth' mdef='신청시팝업WIDTH'/>",		Type:"Text",		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"applWidth",      KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='applHeight' mdef='신청시팝업HEIGHT'/>",		Type:"Text",		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"applHeight",     KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='agreeWidth' mdef='결재시팝업WIDTH'/>",		Type:"Text",		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"agreeWidth",     KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='agreeHeight' mdef='결재시팝업HEIGHT'/>",		Type:"Text",		Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"agreeHeight",    KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='note3' mdef='비고3'/>",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"note3",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='note4' mdef='비고4'/>",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"numNote",        KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='memoV4' mdef='메모'/>",				Type:"Text",		Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"memo",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='alarmYn' mdef='알람여부'/>",			Type:"Text",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"alarmYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 } ,
			{Header:"<sht:txt mid='etcNote' mdef='유의사항'/>",			Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"etcNote",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='etcNote' mdef='유의사항'/>",			Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"etcNoteEng",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='fileSeqV2' mdef='유의사항파일'/>",			Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"fileSeq",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
	    sheet1.SetColProperty("bizCd", 		{ComboText:grCobmboList[0], 	ComboCode:grCobmboList[1]} );
	    sheet1.SetColProperty("orgLevelCd", {ComboText:grCobmboList2[0], 	ComboCode:grCobmboList2[1]} );
	    sheet1.SetColProperty("recevType",	{ComboText:recevTypeList[0], 	ComboCode:recevTypeList[1]} );
	    sheet1.SetColProperty("applyAddressCd",	{ComboText:"|"+addressGubun[0], 	ComboCode:"|"+addressGubun[1]} );
		sheet1.SetColProperty("modalWidth", getModalSizeCombo());
		sheet1.SetColProperty("modalHeight", getModalSizeCombo());

	    sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	    sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
	    sheet1.SetEditEnterBehavior("newline");
		sheet1.SetHeaderRowHeight(50); // 헤더행 높이

		let seqList = convCode( ajaxCall("${ctx}/AppCodeMgr.do?cmd=getAppCodeSearchSeqList","",false).DATA, "");
		sheet1.SetColProperty("orgLevelSearchSeq",  	{ComboText:"|"+seqList[0], ComboCode:"|"+seqList[1]} );

	    $("#searchBizCd").html(grCobmboList[2]);

		$("#appCd, #appCdNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$("#searchBizCd, #srchUseYn").bind("change",function(){
			doAction("Search"); 
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	function getModalSizeCombo() {
		let combo = {
			ComboText: "|small|medium|large|xlarge|full",
			ComboCode: "|sm|md|lg|xl|full"
		}

		return combo;
	}
	
	function doAction(sAction) {
		switch (sAction) {
		case "Search":  sheet1.DoSearch( "${ctx}/AppCodeMgr.do?cmd=getAppCodeMgrList", $("#sheet1Form").serialize()); break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
				if(!dupChk(sheet1,"applCd", true, true)){break;}
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/AppCodeMgr.do?cmd=saveAppCodeMgr", $("#sheet1Form").serialize() );
			break;
        case "Insert":
        	var Row = sheet1.DataInsert(0);
        	sheet1.SetCellValue(Row, "agreeEndYn", "Y");
        	sheet1.SelectCell(Row, 2);
        	break;
        case "Copy":
        	var Row = sheet1.DataCopy();
        	sheet1.SelectCell(Row, 2);
			sheet1.SetCellValue(Row, "fileSeq", "");
        	break;
        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
    }
	
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 	셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	function sheet1_OnClick(Row, Col, Value) {
		try{
		    if(sheet1.ColSaveName(Col)=="temp2") {
		        if(sheet1.GetCellValue(Row,"sStatus") == "I"){
		            alert("<msg:txt mid='110454' mdef='입력상태에서는 세부\n내역을 등록 할 수 없습니다. 저장후 등록해 주세요'/>");
		            return;
		        }else{
		        	 appCodeDetailPopup(Row);
		        }
		    }
		    if(sheet1.ColSaveName(Col)=="temp1"){
		    	if( sheet1.GetCellValue(Row,"sStatus") == "I"){
		    		alert("<msg:txt mid='alertInputAfterSaveV2' mdef='입력상태에서는 수신 결재자를 등록 할 수 없습니다. 저장후 등록해 주세요'/>");
		            return;
		    	}else{
		    		if(sheet1.GetCellValue(Row,"recevYn") == "Y"){
			            appCodePopup(Row);
			        }else{
			            alert("<msg:txt mid='109394' mdef='수신처리 필요여부를 선택하시기 바랍니다.'/>");
			        }
		    	}
		    }
		    if(sheet1.ColSaveName(Col)=="etcNote2"){
		    	if( sheet1.GetCellValue(Row,"sStatus") == "I"){
		    		alert("<msg:txt mid='alertInputAfterSaveV3' mdef='입력상태에서는 유의사항을 등록 할 수 없습니다. 저장후 등록해 주세요'/>");
		            return;
		    	}else{
					appEtcNotePopup(Row);
		    	}
		    }
		    <%/*유의사항 첨부파일 사용안함
		    if(sheet1.ColSaveName(Col)=="fileSeq2"){
		    	if( sheet1.GetCellValue(Row,"sStatus") == "I"){
		    		alert("<msg:txt mid='alertInputAfterSaveV4' mdef='입력상태에서는 유의사항 첨부파일을 등록 할 수 없습니다. 저장후 등록해 주세요'/>");
		            return;
		    	}else{
					appEtcFilePopup(Row);
		    	}
		    }*/%>
			if(sheet1.ColSaveName(Col)=="btnSearchSeq" && sheet1.GetCellValue(Row, "orgLevelSearchSeq") != "" && sheet1.GetCellValue(Row,"sStatus") == "R"){
				pwrSrchAdminLayer( sheet1.GetCellValue(Row, "orgLevelSearchSeq") );
			}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	function appCodeDetailPopup(Row){
		if(!isPopup()) {return;}

		var url 	= "${ctx}/AppCodeMgr.do?cmd=viewAppCodeMgrDetailPopup";
		var args 	= new Array();
		args["sheet"] 	= sheet1;
		openPopup(url,args,900,520);

	}
	
	function appCodePopup(Row){
		if(!isPopup()) {return;}
	
		var url 	= "/AppCodeMgr.do?cmd=viewAppCodeMgrLayer";
		var args 	= new Array();
		args["applCd"] 	= sheet1.GetCellValue(Row,"applCd");
		args["recevType"] 	= sheet1.GetCellValue(Row,"recevType");
		
		let layerModal = new window.top.document.LayerModal({
		   	   id : 'appCodeMgrLayer'
			, url : url
			, parameters : args
			, width : 900
			, height :520
			, title : '수신결재자등록'
			, trigger :[
				{
					name : 'appCodeMgrTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();
	}
	
	function appEtcNotePopup(Row){
		if(!isPopup()) {return;}
		gPRow = Row;
		pGubun = "appEtcNotePopup";

		var url 	= "${ctx}/AppCodeMgr.do?cmd=viewAppEtcNoteLayer&authPg=A";
		var args 	= new Array();
		args["etcNote"] 	= sheet1.GetCellValue(Row,"etcNote");
		args["etcNoteEng"] 	= sheet1.GetCellValue(Row,"etcNoteEng");
		args["fileSeq"] 	= sheet1.GetCellValue(Row,"fileSeq");
		args["fileBtnNm"] 	= sheet1.GetCellValue(Row,"fileBtnNm");
		
		let layerModal = new window.top.document.LayerModal({
		   	   id : 'appEtcNoteLayer'
			, url : url
			, parameters : args
			, width : 700
			, height :350
			, title : '유의사항 등록'
			, trigger :[
				{
					name : 'appEtcNoteTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();
	}
	
	function appEtcFilePopup(Row){
		if(!isPopup()) {return;}

		var param = [];
		param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq")

		var authPgTemp="A";
		gPRow = Row;
		pGubun = "appEtcFilePopup";

		openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp, param, "740","620");
	}

	function pwrSrchAdminLayer(searchSeq){
		var searchDesc = "결재선 레벨" ;
		var chartType  = "" ;
		const p = { searchSeq, searchDesc, chartType };
		var pwrSrchAdminLayer = new window.top.document.LayerModal({
			id: 'pwrSrchAdminLayer',
			url: "${ctx}/PwrSrchAdminPopup.do?cmd=viewPwrSrchAdminLayer&authPg=${authPg}",
			parameters: p,
			width: 1000,
			height: 800,
			title: "<tit:txt mid='pwrSrchMgr' mdef='조건검색'/>"
		});
		pwrSrchAdminLayer.show();
	}

	function getReturnValue(rv) {
		//var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "appEtcFilePopup") {
			if(rv["fileCheck"] == "exist"){
				$("#fileSeq").val(rv["fileSeq"]);
				$("#searchApplCd").val(sheet1.GetCellValue(gPRow,"applCd"));
				//fileSeq 저장.
				var data = ajaxCall("${ctx}/AppCodeMgr.do?cmd=saveAppAttFile",$("#sheet1Form").serialize(),false);

				if(data != null && data.Result != null) {
					alert(data.Result.Message);
				}
			}
		}else if(pGubun == "appEtcNotePopup"){
			sheet1.SetCellValue(gPRow,"etcNote",rv["contents"]);
			sheet1.SetCellValue(gPRow,"etcNoteEng",rv["contentsEng"]);
			sheet1.SetCellValue(gPRow,"fileSeq",rv["fileSeq"]);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
			<input type="hidden" name="fileSeq"				id="fileSeq" />
			<input type="hidden" name="searchApplCd"				id="searchApplCd" />
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>업무구분</th>
							<td>
								<select id="searchBizCd" name="searchBizCd"></select>
							</td>
							<th><tit:txt mid='114633' mdef='신청서코드'/></th>
							<td>
								<input id="appCd" name ="appCd" type="text" class="text"/>
							</td>
							<th><tit:txt mid='114237' mdef='신청서코드명'/></th>
							<td>
								<input id="appCdNm" name ="appCdNm" type="text" class="text"/>
							</td>
							<th><tit:txt mid='111965' mdef='사용여부'/></th>
							<td>
								<select id="srchUseYn" name="srchUseYn" >
									<option value="" >전체 </option>
									<option value="Y" selected >사용</option>
									<option value="N">사용안함</option>
								</select>
							</td>
							<td>
								<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
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
								<li id="txt" class="txt"><tit:txt mid='112136' mdef='신청서코드관리'/></li>
								<li class="btn">
									<btn:a href="javascript:doAction('Down2Excel');" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
									<btn:a href="javascript:doAction('Copy');" css="btn outline_gray authA" mid='110696' mdef="복사"/>
									<btn:a href="javascript:doAction('Insert');" css="btn outline_gray authA" mid='110700' mdef="입력"/>
									<btn:a href="javascript:doAction('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
</div>
</body>
</html>
