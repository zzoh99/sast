<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
				{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"세부\n내역",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	},
				{Header:"공모구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pubcDivCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"공모명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"신청시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStaYmd",		EndDateCol: "applEndYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"신청종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applEndYmd",		StartDateCol: "applStaYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"공모상태",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pubcStatCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"공모내용",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcContent",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},

				{Header:"공모부서코드",   Type:"Text",      	Hidden:1,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"pubcOrgCd", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"공모부서",    	Type:"Text",      	Hidden:0,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"pubcOrgNm", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"부서장사번",    	Type:"Text",      	Hidden:0,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"pubcChiefSabun", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"부서장성명",    	Type:"Text",      	Hidden:0,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"pubcChiefName", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

				{Header:"비고",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				
				{Header:"공모ID",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"pubcId",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"직무코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"직무명",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"파일",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	},
				{Header:"공모신청수",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"cnt",				KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
				
            ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		var pubcDivCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1026"), "");	//공모구분
		var pubcStatCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1027"), "");	//공모상태

		sheet1.SetColProperty("pubcDivCd",		{ComboText:"|"+pubcDivCd[0], ComboCode:"|"+pubcDivCd[1]} );	//공모구분
		sheet1.SetColProperty("pubcStatCd",		{ComboText:"|"+pubcStatCd[0], ComboCode:"|"+pubcStatCd[1]} );	//공모상태

		$("#searchPubcNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		sheet1.SetDataLinkMouse("detail", 1);
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

var fileSeqArr = []; // 행 삭제 후 첨부파일도 삭제 하기 위한 배열

/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
    switch(sAction){
        case "Search":      //조회

        	sheet1.DoSearch( "${ctx}/PubcMgr.do?cmd=getPubcMgrList", $("#srchFrm").serialize() );
            break;
        case "Save":        //저장
        	// 중복체크
			if (!dupChk(sheet1, "pubcDivCd|pubcNm|applStaYmd", false, true)) {break;}
            IBS_SaveName(document.srchFrm,sheet1);
            for(var i=sheet1.HeaderRows(); i<=sheet1.RowCount(); i++) {
       			var sStatus = sheet1.GetCellValue(i, "sStatus");
       			if(sStatus == "D") {
       				fileSeqArr.push(sheet1.GetCellValue(i, "fileSeq"));
       			}
       		}
            sheet1.DoSave( "${ctx}/PubcMgr.do?cmd=savePubcMgr", $("#srchFrm").serialize() );
            break;

        case "Insert":      //입력

            var Row = sheet1.DataInsert(0);
            pubcMgrPopup(Row) ;
            break;

        case "Copy":        //행복사

            var Row = sheet1.DataCopy();
        	sheet1.SetCellValue(Row, "pubcId", "");
        	sheet1.SetCellValue(Row, "fileSeq", "");
            break;

        case "Down2Excel":  //엑셀내려받기
        	var downcol = makeHiddenSkipCol(sheet1);
        	sheet1.Down2Excel({DownCols:downcol,SheetDesign:1,Merge:1});
            break;

    }
}

<!-- 조회 후 에러 메시지 -->
function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
	try{
	    if (ErrMsg != ""){
	        alert(ErrMsg);
	    }
	    if ( Code != "-1" ) {
	    	for (var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
	            if( sheet1.GetCellValue(i, "cnt") != "0" ) {
	                sheet1.SetCellEditable(i, "sDelete",false);
	            }
	        }	
	    }
	    sheetResize();
	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { 
			alert(Msg); 
		} 
		if( Code > -1 ) {
			for(var i=0; i<fileSeqArr.length; i++) {
				$.filedelete($("#uploadType").val(), {"fileSeq" : fileSeqArr[i]});	
			}
			doAction1("Search"); 			
		}
	} catch (ex) { 
		alert("OnSaveEnd Event Error " + ex); 
	}
}

function sheet1_OnClick(Row, Col, Value){
	try{
	
		if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
			pubcMgrPopup(Row) ;
	  	}
	
	}catch(ex){alert("OnClick Event Error : " + ex);}
}

//  소속 팝업
function orgSearchPopup(){
	try{
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "orgBasicPopup";

		let layerModal = new window.top.document.LayerModal({
			id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
			, parameters : {}
			, width : 740
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result){
						if(!result.length) return;
						$("#searchOrgNm").val(result[0].orgNm);
						$("#searchOrgCd").val(result[0].orgCd);
					}
				}
			]
		});
		layerModal.show();
	}catch(ex){alert("Open Popup Event Error : " + ex);}
}

/**
 * 상세내역 window open event
 */
function pubcMgrPopup(Row){
	if(!isPopup()) {return;}

	let w 		= 900;
	let h 		= 800;
	let url 	= "${ctx}/PubcMgr.do?cmd=viewPubcMgrLayer&authPg=${authPg}";
	let p = {
		pubcDivCd : sheet1.GetCellValue(Row, "pubcDivCd"),
		pubcId : sheet1.GetCellValue(Row, "pubcId"),
		pubcNm : sheet1.GetCellValue(Row, "pubcNm"),
		applStaYmd : sheet1.GetCellText(Row, "applStaYmd"),
		applEndYmd : sheet1.GetCellText(Row, "applEndYmd"),
		pubcStatCd : sheet1.GetCellValue(Row, "pubcStatCd"),
		pubcContent : sheet1.GetCellValue(Row, "pubcContent"),
		note : sheet1.GetCellValue(Row, "note"),
		jobCd	: sheet1.GetCellValue(Row, "jobCd"),
		jobNm	: sheet1.GetCellValue(Row, "jobNm"),
		fileSeq :	sheet1.GetCellValue(Row, "fileSeq"),
		sStatus :	sheet1.GetCellValue(Row, "sStatus"),
		pubcOrgCd : sheet1.GetCellValue(Row, "pubcOrgCd"),
		pubcOrgNm : sheet1.GetCellValue(Row, "pubcOrgNm"),
		pubcChiefSabun : sheet1.GetCellValue(Row, "pubcChiefSabun"),
		pubcChiefName  : sheet1.GetCellValue(Row, "pubcChiefName")
	};
	
	gPRow = Row;
	pGubun = "pubcMgrPopup";

	//openPopup(url,args,w,h);
	const layerModal = new window.top.document.LayerModal({
		id : 'pubcMgrLayer'
		, url : url
		, parameters : p
		, width : w
		, height : h
		, title : '<tit:txt mid='112392' mdef='사내공모관리 세부내역'/>'
		, trigger :[
			{
				name : 'pubcMgrLayerTrigger'
				, callback : function(result){
					getReturnValue(result);
				}
			}
		]
	});
	layerModal.show();

}

//팝업 콜백 함수.
function getReturnValue(rv) {
    if(pGubun == "pubcMgrPopup") {
		sheet1.SetCellValue(gPRow, "pubcId"         ,  rv.pubcId) ;
		sheet1.SetCellValue(gPRow, "pubcNm"         ,  rv.pubcNm) ;
		sheet1.SetCellValue(gPRow, "pubcDivCd"      ,  rv.pubcDivCd) ;
		sheet1.SetCellValue(gPRow, "pubcStatCd"     ,  rv.pubcStatCd) ;
		sheet1.SetCellValue(gPRow, "applStaYmd"     ,  rv.applStaYmd) ;
		sheet1.SetCellValue(gPRow, "applEndYmd"     ,  rv.applEndYmd) ;
		sheet1.SetCellValue(gPRow, "pubcContent"    ,  rv.pubcContent) ;
		sheet1.SetCellValue(gPRow, "note"       	,  rv.note) ;
		sheet1.SetCellValue(gPRow, "jobCd"       	,  rv.jobCd) ;
		sheet1.SetCellValue(gPRow, "fileSeq"       	,  rv.fileSeq) ;
		sheet1.SetCellValue(gPRow, "pubcOrgCd"      ,  rv.pubcOrgCd);
		sheet1.SetCellValue(gPRow, "pubcOrgNm"      ,  rv.pubcOrgNm);
		sheet1.SetCellValue(gPRow, "pubcChiefSabun" ,  rv.pubcChiefSabun);
		sheet1.SetCellValue(gPRow, "pubcChiefName"  ,  rv.pubcChiefName);
    }
}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="uploadType" 	name="uploadType" value="guaranty"/>
	
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>공모부서</td>
						<td>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
							<a onclick="javascript:orgSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<td> <span>사내공모명 </span> <input id="searchPubcNm" name ="searchPubcNm" type="text" class="text w100" /> </td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/> </td>
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
							<li id="txt" class="txt">사내공모관리</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='down2excel' mdef="다운로드"/>
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