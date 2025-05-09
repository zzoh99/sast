<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='113526' mdef='맞춤인재검색'/></title> <!-- All NEW(4.0) EIS MODULE by JSG -->
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript" src="/common/js/cookie.js"></script>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var sltSch 	= "";
var postItemGrpCd = []; //발령세부항목

$(function() {
	sltSch = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20130"), "<tit:txt mid='103895' mdef='전체'/>");
	$("#sltSch").html(sltSch[2]);

	$("#searchSch").attr("readonly", "readonly");
	$("#searchSch").addClass("readonly");
	$("#searchSchButton").hide();

	//$('#selType > option:selected').change(function() {
	$("#sltSch").change(function() {

		var code = $(this).val();

		if(code == ""){

			$("#searchSch").val("");
			$("#searchSch").attr("readonly", "readonly");
			$("#searchSch").addClass("readonly");
			$("#searchSchButton").hide();
		} else if(code == "04" || code == "05" || code == "06" || code == "07") {

			$("#searchSch").val("");
			$("#searchSch").attr("readonly", false);
			$("#searchSch").removeClass("readonly");
			$("#searchSchButton").show();
		} else {

			$("#searchSch").val("");
			$("#searchSch").attr("readonly", false);
			$("#searchSch").removeClass("readonly");
			$("#searchSchButton").hide();
		}
	});

	/*발령일자*/
	$("#chgOrdYmd").datepicker2();


	/*입사일*/
	$("#empSYmd").datepicker2({
		startdate:"empEYmd",
		onReturn:function(date){
			var num = getDaysBetween(date,$("#empEYmd").val());
		}
	});
	$("#empEYmd").datepicker2({
		enddate:"empSYmd",
		onReturn:function(date){
			var num = getDaysBetween($("#empSYmd").val(),date);
		}
	});
	/*퇴사일*/
	$("#retSYmd").datepicker2({
		startdate:"retEYmd",
		onReturn:function(date){
			var num = getDaysBetween(date,$("#retEYmd").val());
		}
	});
	$("#retEYmd").datepicker2({
		enddate:"retSYmd",
		onReturn:function(date){
			var num = getDaysBetween($("#retSYmd").val(),date);
		}
	});
	/*근속기간*/
	$("#searchSYear").bind("keyup",function(event){
		makeNumber(this,"A");
	});
	$("#searchEYear").bind("keyup",function(event){
		makeNumber(this,"A");
	});
	/*연령*/
	$("#searchSAge").bind("keyup",function(event){
		makeNumber(this,"A");
	});
	$("#searchEAge").bind("keyup",function(event){
		makeNumber(this,"A");
	});
	/*재직상태*/
	$("#statusNm").val("재직,휴직");
	$("#statusCd").val("AA,CA");
	/*소속*/
	$("#searchOrgCd").val('0') ;

	/*계열사*/
	let authEnterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAuthEnterCdList&searchGrpCd=${ssnGrpCd}",false).codeList, "");
	$("#searchAuthEnterCd").html(authEnterCdList[2]);
	$("#searchAuthEnterCd").select2({
		placeholder: "전체"
		, maximumSelectionSize:100
	});
});

var uniPopup = function (){

	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "viewHrmSchoolPopup";

	var code = $("#sltSch > option:selected").val();

	var gubun = "";

	if (code == "04") gubun = "H20149";
	if (code == "05") gubun = "H20150";
	if (code == "06") gubun = "H20150";
	if (code == "07") gubun = "H20150";

	var param = [];
	param["gubun"] = gubun;

    var rst = openPopup("/HrmSchoolPopup.do?cmd=viewHrmSchoolPopup&authPg=${authPg}", param, "540","620");
    /*
    if(rst != null){
		$("#searchSchCode").val(rst["code"]);
		$("#searchSch").val(rst["codeNm"]);
    }
    */
};

// 소속 팝업
function showOrgPopup() {

	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "orgTreePopup";

	// var rst = openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "750","920");

	var w = 750, h = 920;
	var title = "<tit:txt mid='orgTreePop' mdef='조직도 조회'/>";
	var url = "/Popup.do?cmd=viewOrgTreeLayer";

	var layerModal = new window.top.document.LayerModal({
		id : 'orgTreeLayer',
		url : url,
		parameters: {searchEnterCd : ''},
		width : w,
		height : h,
		title : title,
		trigger: [
			{
				name: 'orgTreeLayerTrigger',
				callback: function(rv) {
					$("#chgOrgCd").val(rv.orgCd);
					$("#chgOrgNm").val(rv.orgNm);
				}
			}
		]
	});
	layerModal.show();
    /*
	if(rst != null){
    	$("#searchOrgCd").val(rst["orgCd"]);
    	$("#searchOrgNm").val(rst["orgNm"]);
    }
    */
}

function getReturnValue(rv) {
	// var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "orgTreePopup"){
    	$("#searchOrgCd").val(rv["orgCd"]);
    	$("#searchOrgNm").val(rv["orgNm"]);
    } else if(pGubun == "jikgub") {
    	$("#jikgubNm").val(rv["codeNm"]);
    	$("#jikgubCd").val(rv["code"]);
    } else if(pGubun == "jikwee") {
    	$("#jikweeNm").val(rv["codeNm"]);
    	$("#jikweeCd").val(rv["code"]);
    } else if(pGubun == "jikchak") {
    	$("#jikchakNm").val(rv["codeNm"]);
    	$("#jikchakCd").val(rv["code"]);
    } else if(pGubun == "jikmoo") {
    	$("#jikmooNm").val(rv["codeNm"]);
    	$("#jikmooCd").val(rv["code"]);
    } else if(pGubun == "status") {
    	$("#statusNm").val(rv["codeNm"]);
    	$("#statusCd").val(rv["code"]);
    } else if(pGubun == "major") {
    	$("#searchMjrNm").val(rv["codeNm"]);
    	$("#searchMjrCd").val(rv["code"]);
    } else if(pGubun == "viewHrmSchoolPopup") {
		$("#searchSchCode").val(rv["code"]);
		$("#searchSch").val(rv["codeNm"]);
    } else if(pGubun == "license") {
		$("#searchLicenseCd").val(rv["code"]);
		$("#searchLicenseNm").val(rv["codeNm"]);
	}  else if(pGubun == "searchAppmtConfirmPopup") {
		$("#searchProcessNo").val(rv["processNo"]);
		$("#searchProcessTitle").val(rv["processTitle"]);
	}
}

//직급,직위,직책,직무,재직상태 팝업
function showConditionPopup(gbn) {
	if(!isPopup()) {return;}

	var args    = new Array();
	var p;

    if(gbn == "jikgub") {
    	gPRow = "";
    	pGubun = "jikgub";

		p = {
			sTitle : '직급조회',
			sHeader : '직급',
			sGrpCd : 'H20010',
			sShtTitle : '직급 선택',
			codeList : $("#jikgubCd").val()
		};

	} else if(gbn == "jikwee") {
    	gPRow = "";
    	pGubun = "jikwee";

		p = {
			sTitle : '직위조회',
			sHeader : '직위',
			sGrpCd : 'H20030',
			sShtTitle : '직위 선택',
			codeList : $("#jikweeCd").val()
		};
    } else if(gbn == "jikchak") {
    	gPRow = "";
    	pGubun = "jikchak";

		p = {
			sTitle : '직책조회',
			sHeader : '직책',
			sGrpCd : 'H20020',
			sShtTitle : '직책 선택',
			codeList : $("#jikchakCd").val()
		};
    } else if(gbn == "jikmoo") {
    	gPRow = "";
    	pGubun = "jikmoo";

		p = {
			sTitle : '직무조회',
			sHeader : '직무',
			sGrpCd : 'H10060',
			sShtTitle : '직무 선택',
			codeList : $("#jikmooCd").val()
		};
    } else if(gbn == "status") {
    	gPRow = "";
    	pGubun = "status";

		p = {
			sTitle : '재직상태 조회',
			sHeader : '재직상태',
			sGrpCd : 'H10010',
			sShtTitle : '재직상태 선택',
			codeList : $("#statusCd").val()
		};
    } else if(gbn == "major") {
    	gPRow = "";
    	pGubun = "major";

		p = {
			sTitle : '전공 조회',
			sHeader : '전공',
			sGrpCd : 'H20190',
			sShtTitle : '전공 선택',
			codeList : $("#searchMjrCd").val()
		};
    } else if(gbn == "license") {
		gPRow = "";
		pGubun = "license";

		p = {
			sTitle : '자격증 조회',
			sHeader : '자격증',
			sGrpCd : 'H20160',
			sShtTitle : '자격증 선택',
			codeList : $("#searchLicenseCd").val()
		};
	}

	// var rst = openPopup("/SpecificEmpSrch.do?cmd=viewSelectConditionPopup&authPg=R", args, "400","500");
	var selectConditionLayer = new window.top.document.LayerModal({
		id: 'selectConditionLayer',
		url: '/SpecificEmpSrch.do?cmd=viewSelectConditionLayer&authPg=R',
		parameters: p,
		width: 400,
		height: 500,
		title: '선택',
		trigger: [
			{
				name: 'selectConditionLayerTrigger',
				callback: function(rv) {
					getReturnValue(rv);
				}
			}
		]
	});
	selectConditionLayer.show();

}

function valChk(value) {
	if(value == null || value == "") return false ;
	else return true ;
}

function resultPopup() {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "viewSrchResultPopup";

	// var args    = new Array();
	// args["frm"] = $("#searchFrm").serialize() ;
	// var rst = openPopup("/SpecificEmpSrch.do?cmd=viewSrchResultPopup&authPg=R", args, "1300","700");

	let p = {
		frm : $("#searchFrm").serialize()
	};
	let srchResultLayer = new window.top.document.LayerModal({
		id : 'srchResultLayer',
		url : '/SpecificEmpSrch.do?cmd=viewSrchResultLayer&authPg=R',
		parameters: p,
		width : 1300,
		height : 700,
		title : "맞춤인재검색 결과",
		trigger :[
			{
				name : 'srchResultLayerTrigger'
				, callback : function(result){
					getReturnValue(result);
				}
			}
		]
	});
	srchResultLayer.show();
}

// 초기화
function clearCode(num) {
	switch(num) {
	case "1" :
		$('#searchOrgNm').val("");
		$('#searchOrgCd').val("");
		break ;
	case "2" :
		$('#jikgubNm').val("");
		$('#jikgubCd').val("");
		break ;
	case "3" :
		$('#jikweeNm').val("");
		$('#jikweeCd').val("");
		break ;
	case "4" :
		$('#jikchakNm').val("");
		$('#jikchakCd').val("");
		break ;
	case "5" :
		$('#jikmooNm').val("");
		$('#jikmooCd').val("");
		break ;
	case "7" :
		$("#searchMjrNm").val("") ;
		$("#searchMjrCd").val("") ;
		break ;
	case "8" :
		$("#sltSch").val("");
		$("#searchSchCode").val("") ;
		$("#searchSch").val("") ;
		$("#searchSch").attr("readonly", "readonly");
		$("#searchSch").addClass("readonly");
		$("#searchSchButton").hide();
		break ;
	case "license" :
		$("#searchLicenseNm").val("") ;
		$("#searchLicenseCd").val("") ;
		break ;
	}
}

function setDefaultValue() {
	$('#searchOrgNm').val("");
	$('#searchOrgCd').val("");
	$('#jikgubNm').val("");
	$('#jikgubCd').val("");
	$('#jikweeNm').val("");
	$('#jikweeCd').val("");
	$('#jikchakNm').val("");
	$('#jikchakCd').val("");
	$('#jikmooNm').val("");
	$('#jikmooCd').val("");
	$("#statusNm").val("재직,휴직");
	$("#statusCd").val("AA,CA");

	$('#empSYmd').val("");
	$('#empEYmd').val("");
	$('#retSYmd').val("");
	$('#retEYmd').val("");
	$('#searchMjr').val("");
	$('#searchMjrNm').val("");
	$('#searchBfCmp').val("");
	$('#searchSYear').val("");
	$('#searchEYear').val("");
	$('#searchSAge').val("");
	$('#searchEAge').val("");
	$('#searchSch').val("");
	$('#searchSch').attr('readonly', true);

	$('#searchSex').val("");
	$("#sltSch").html(sltSch[2]);

	$(':checkbox[name=searchOrgType]').attr('checked', true);


	$('#searchLicenseNm').val("");
	$('#searchLicenseCd').val("");
	$('#searchTypeNm').val("");
	$('#searchKeyword').val("");
	$('#searchAuthEnterCd').val(null).trigger('change');
	$("#searchAuthEnterCd").select2({
		placeholder: "전체"
		, maximumSelectionSize:100
	});
}
</script>

<!-- sheet1 -->
<script type="text/javascript">
	$(function() {
		initSheet1();
	});

	function initSheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"계열사",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"authEnterCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"계열사",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"authEnterNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",       		Type:"Image",   	Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"Ymd" },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"Ymd" },
			{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"IdNo" },
			{Header:"<sht:txt mid='retYmd' mdef='퇴직일'/>",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"Ymd" },
			{Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"Ymd" },
			{Header:"<sht:txt mid='handPhone_V6736' mdef='핸드폰번호'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"handPhone",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='mailId' mdef='메일주소'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mailId",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },

			{Header:"발령형태",	   Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"ordTypeCd",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령종류",	   Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"ordDetailCd", KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령일자",    Type:"Date",      Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"ordYmd",          KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"적용순서",   Type:"Text",      Hidden:1,  Width:35,   Align:"Center",  ColMerge:0,   SaveName:"applySeq",        KeyField:0, Format:"Number",PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"발령소속명",  Type:"Popup",     Hidden:0,   Width:120,  Align:"Center",  ColMerge:0,   SaveName:"ordOrgNm",    KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"발령소속코드", Type:"Text",     Hidden:1,   Width:70,   Align:"Center",  ColMerge:0, SaveName: "ordOrgCd",      KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100},
			{Header:"인사\n기록카드",			Type:"Html",  		Hidden:0,	Width:50, 	Align:"Center", ColMerge:0, SaveName:"btnPrt",		Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"선택",												Type:"DummyCheck",	Hidden:0,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"check",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
		];

		// 발령항목 조회
		var POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;

		// 발령항목 SHEET에 PUSH
		var postItemsNames  = "";
		var grcodeCds = "";
		for(var ind in POST_ITEMS){

			var postItem = POST_ITEMS[ind];
			postItemsNames += ","+postItem.postItem;
			if(postItem.popupType){
				grcodeCds += ",'"+postItem.popupType+"'";
				postItemGrpCd.push({"grpCd":postItem.popupType, "col":convCamel(postItem.postItem+"_VALUE"), "realCol":postItem.columnCd});
			}
			//sheet header init
			if(postItem.columnCd == "ORG_CD"){
				initdata.Cols.push({Header:"발령소속",    Type:"Text",     Hidden:1,   Width:70,   Align:"Center",  ColMerge:0, SaveName: convCamel(postItem.postItem+"_VALUE"),            KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100});
			} else {
				initdata.Cols.push({Header:postItem.postItemNm,   Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:0, SaveName: convCamel(postItem.postItem+"_VALUE"),            KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:postItem.limitLength});
			}
		}

		//저장시 사용할 post item 별 id 값
		$("<input></input>",{id:"s_SAVENAME2",name:"s_SAVENAME2",type:"hidden"}).appendTo($("#searchFrm"));
		$("#searchFrm #s_SAVENAME2").val(postItemsNames);

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);
        sheet1.SetAutoRowHeight(0);
        //sheet1.SetDataRowHeight(60);
		sheet1.SetDataLinkMouse("detail", 1);
		$(window).smartresize(sheetResize); sheetInit();
	}

	function openLayerPop(id, content) {
		var oPop = $("#"+ id);
		var oPopBg = oPop.find(".layerBg");
		var oPopContent = oPop.find(".layerContent");
		oPopBg.css('height', $(document).height());
		if ( content != undefined ) {
			oPopContent.html( content );
		}
		oPop.show();
	}

	function closeLayerPop(id){
		$("#"+ id).hide();
	}
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			//openLayerPop("popWait", "조회 중 입니다.....");
			$("#authEnterCd").val(($("#searchAuthEnterCd").val()==null?"":getMultiSelect($("#searchAuthEnterCd").val())));
			sheet1.DoSearch( "${ctx}/SpecificEmpSrch.do?cmd=getSpecificEmpSrchNewList", $("#searchFrm").serialize() ); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param	= {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		case "ProcessClear":
			$("#searchProcessNo").val("");
			$("#searchProcessTitle").val("");
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if (Code != "-1") {
				sheet1.SetDataRowHeight(60);
			}

			sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex);
		} finally {closeLayerPop('popWait');}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			if( sheet1.ColSaveName(Col) == "btnPrt" ) {
				showRd(Row);
			}
		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	/**
	 * 레포트 열기
	 */
	function showRd(Row){
		var rv = "enterCd="+sheet1.GetCellValue(Row, 'authEnterCd')
				 +"&sabun="+sheet1.GetCellValue(Row, 'sabun');
		var data = ajaxCall("/SpecificEmpSrch.do?cmd=getEmpCardPrtRk", rv, false);
		if ( data != null && data.DATA != null ){
			const rdData = {
				rk : data.DATA.rk
			};
			window.top.showRdLayer('/SpecificEmpSrch.do?cmd=getEncryptRd', rdData, null, "인사카드");
		}
	}

	//비교대상 화면으로 이동
	function goMenu() {

		let sRow = sheet1.FindCheckedRow("check");

		if(sRow == "") {
			alert('비교할 대상이 없습니다.');
			return;
		}
		let arrRow = sRow.split("|");
		if(arrRow.length > 3) {
			alert('인재비교는 최대 3명만 선택 할 수 있습니다.');
			return;
		}

		for(var i = 0; i < arrRow.length; i++) {
			if(arrRow[i] != "") {
				setCookie("CompareEmpN"+(i+1), sheet1.GetCellValue(arrRow[i],"name"), 1000);
				setCookie("CompareEmpS"+(i+1), sheet1.GetCellValue(arrRow[i],"sabun"), 1000);
			}
		}

		// 서브페이지에서 서브페이지 호출
		if(typeof window.top.goOtherSubPage == 'function') {
			window.top.goOtherSubPage("", "", "", "", "CompareEmp.do?cmd=viewCompareEmp");
		}
	}

	// 조건불러오기
	function getCondition() {
		let layerModal = new window.top.document.LayerModal({
			id : 'conditionLayer'
			, url : '/SpecificEmpSrch.do?cmd=viewSpecificEmpSrchNewConditionLayer&authPg=R'
			, parameters : {
				searchDesc : $('#searchTypeNm').val()
			}
			, width : 500
			, height : 420
			, title : '인재탐색 조회조건'
			, trigger :[
				{
					name : 'conditionLayerTrigger'
					, callback : function(result){
						// TODO 로직 적용 후 목데이터 수정
						$('#searchTypeNm').val(result.searchDesc);
						if(result.searchSeq == '1') {
							setDefaultValue();
							$('#searchLicenseCd').val('I0794,I0796,I0800,I0801,I0802');
							$('#searchLicenseNm').val('정보처리기능사,정보처리기사,정보처리기타,정보처리산업기사,정보통신기능사');
						} else if(result.searchSeq == '2') {
							setDefaultValue();
							$('#searchAuthEnterCd').val(['JJA','SKE']).trigger('change');
							$('#jikchakCd').val('D0067,D0068');
							$('#jikchakNm').val('팀장,팀장(파트)');
						} else if(result.searchSeq == '3') {
							setDefaultValue();
							$('#searchKeyword').val('토익점수 우수');
						}

						doAction1('Search');
					}
				}
			]
		});
		layerModal.show();
	}

	// 조건저장
	function setCondition() {
		if($('#searchTypeNm').val() == '') {
			alert('인재유형을 입력하세요.');
			$('#searchTypeNm').focus();
			return;
		}
		alert('저장되었습니다.');
	}

	// keyword layer
	function showKeywordLayer() {
		let layerModal = new window.top.document.LayerModal({
			id : 'keywordLayer'
			, url : '/SpecificEmpSrch.do?cmd=viewSpecificEmpSrchNewKeywordLayer&authPg=R'
			, parameters : {
				searchDesc : $('#searchTypeNm').val()
			}
			, width : 500
			, height : 420
			, title : '키워드'
			, trigger :[
				{
					name : 'keywordLayerTrigger'
					, callback : function(result){
						$('#searchKeyword').val(result.searchDesc);
					}
				}
			]
		});
		layerModal.show();
	}

	// 발령번호 선택 팝업
	function showProcessLayerPop() {
		if(!isPopup()) {return;}
		pGubun = "searchAppmtConfirmPopup";
		//openPopup("/Popup.do?cmd=viewAppmtProcessNoMgrPopup&authPg=R", "", "1000","600");
		let layerModal = new window.top.document.LayerModal({
			id : 'appmtConfirmLayer'
			, url : '/Popup.do?cmd=viewAppmtProcessNoMgrLayer&authPg=R'
			, parameters : ""
			, width : 1000
			, height : 600
			, title : '발령번호 검색'
			, trigger :[
				{
					name : 'appmtConfirmTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();
	}

	function showTransBtn() {
		$(".trans").toggleClass("hide");
	}

	function ordSet() {
		if($("#chgOrgCd").val() == "") {
			alert("발령소속을 선택하세요.");
			return;
		}

		if(sheet1.CheckedRows("check") == 0) {
			alert("직원을 선택하세요.");
			return;
		}

		if($("#chgOrgCd").val() != sheet1.GetCellValue(sheet1.GetSelectRow(), "orgCd")) {
			for( i = sheet1.HeaderRows(); i < sheet1.RowCount() + sheet1.HeaderRows(); i++) {
				if(sheet1.GetCellValue(i,"check") == 'Y'){
					sheet1.SetCellValue(i, "ordOrgCd",$("#chgOrgCd").val());
					sheet1.SetCellValue(i, "ordOrgNm",$("#chgOrgNm").val());
				}
			}
		} else {
			alert("선택하신 소속이 같은 소속입니다. \n 다른 소속을 선택하세요.");
			$("#chgOrgCd").val("");
			$("#chgOrgNm").val("");
			return;
		}

		if($("#chgOrdYmd").val() == "") {
			alert("<msg:txt mid='110185' mdef='발령일자를 지정하세요.'/>");
			return;
		}
		let chgOrdYmd = $("#chgOrdYmd").val().replace(/-/gi,"");
		$("#chgOrdYmd").val(chgOrdYmd);

		setSheet1Param();
		IBS_SaveName(document.searchFrm,sheet1);
		sheet1.DoSave( "${ctx}/SpecificEmpSrch.do?cmd=saveSpecificEmpSrchNewChgOrd", $("#searchFrm").serialize());
	}

	function setSheet1Param() {
		for(var i=sheet1.HeaderRows();i<sheet1.RowCount()+sheet1.HeaderRows();i++) {
			if(sheet1.GetCellValue(i,"sStatus") =="U") {
				sheet1.SetCellValue(i, "ordYmd", $("#chgOrdYmd").val());
				sheet1.SetCellValue(i, "ordDetailCd", $("#chgOrdDetailCd").val());
				sheet1.SetCellValue(i, "ordTypeCd", $("#chgTypeCd").val());

				for (var ind in postItemGrpCd) {
					if (postItemGrpCd[ind].grpCd == "") continue;
					var val = "";
					if (postItemGrpCd[ind].realCol == "ORG_CD") { //조직정보를 발령조직 정보로 전달
						val = sheet1.GetCellValue(i, "ordOrgCd");
					} else {
						val = sheet1.GetCellValue(i, convCamel(postItemGrpCd[ind].realCol));
					}
					if (val != "-1" && val != "") sheet1.SetCellValue(i, postItemGrpCd[ind].col, val);
				}
			}

		}
	}
</script>

</head>
<body class="hidden" onload="">
<div class="wrapper">
<form id="searchFrm" name="searchFrm">
<input type="hidden" id="srchSeq" name="srchSeq" value="" />
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="30%" />
			<col width="70%" />
		</colgroup>
		<tr>
			<td class="top">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">인재탐색/비교</li>
							<li class="btn">
								<a href="javascript:getCondition();" class="basic">불러오기</a>
                                <a href="javascript:setCondition();" class="basic">조건저장</a>
							</li>
						</ul>
					</div>
				</div>
				<div style="height:calc(100vh - 60px); overflow-y:auto;">
					<table class="table">
						<colgroup>
							<col width="30%" />
							<col width="" />
						</colgroup>
	
						<tr>
							<th>인재유형</th>
							<td><input id="searchTypeNm" name="searchTypeNm" type="text" class="text w100p"/> </td>
						</tr>
						<tr>
							<th>계열사</th>
							<td>
								<select id="searchAuthEnterCd" name="searchAuthEnterCd" class="box" multiple></select>
								<input type="hidden" id="authEnterCd" name="authEnterCd" />
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='104104' mdef='직위'/></th>
							<td>
								<div class="input-wrap with-btn">
									<input id="jikweeNm" name="jikweeNm" type="text" class="text w70p readonly " readonly/>
									<input id="jikweeCd" name="jikweeCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('jikwee');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('3')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</div>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='104471' mdef='직급'/></th>
							<td>
								<div class="input-wrap with-btn">
									<input id="jikgubNm" name="jikgubNm" type="text" class="text w70p readonly" readonly/>
									<input id="jikgubCd" name="jikgubCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('jikgub');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('2')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</div>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='103785' mdef='직책'/></th>
							<td>
								<div class="input-wrap with-btn">
									<input id="jikchakNm" name="jikchakNm" type="text" class="text w70p readonly" readonly/>
									<input id="jikchakCd" name="jikchakCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('jikchak');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('4')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</div>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='103973' mdef='직무'/></th>
							<td>
								<div class="input-wrap with-btn">
									<input id="jikmooNm" name="jikmooNm" type="text" class="text w70p readonly" readonly/>
									<input id="jikmooCd" name="jikmooCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('jikmoo');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('5')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</div>
							</td>
						</tr>
						<tr>
							<th>자격증</th>
							<td>
								<div class="input-wrap with-btn">
									<input id="searchLicenseNm" name="searchLicenseNm" type="text" class="text w70p readonly" readonly/>
									<input id="searchLicenseCd" name="searchLicenseCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('license');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('license')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</div>
							</td>
						</tr>
						<tr>
							<th>키워드</th>
							<td>
								<input id="searchKeyword" name="searchKeyword" type="text" class="text w100p"/>
								<a href="javascript:showKeywordLayer();" class="button6"><i class="mdi-ico">help_outline</i></a>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='113531' mdef='근속기간'/></th>
							<td>
								<div class="input-wrap">
									<input id="searchSYear" name="searchSYear" type="text" class="text w25p center w-half" maxlength="4"/>년 ~
									<input id="searchEYear" name="searchEYear" type="text" class="text w25p center w-half" maxlength="4"/>년
								</div>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='112613' mdef='연령'/></th>
							<td class="input-wrap">
								<input id="searchSAge" name="searchSAge" type="text" class="text w25p center w-half" maxlength="3"/>세 ~
								<input id="searchEAge" name="searchEAge" type="text" class="text w25p center w-half" maxlength="3"/>세
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='103881' mdef='입사일'/></th>
							<td>
								<div class="input-wrap"">
									<input id="empSYmd" name="empSYmd" type="text" size="10" class="date2" value=""/> ~
									<input id="empEYmd" name="empEYmd" type="text" size="10" class="date2" value=""/>
								</div>
							</td>
						</tr>
					</table>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><br><font color="orange"> *검색조건에 따라 검색결과 속도가 <b>저하</b>될 수 있습니다. </font></li>
								<li class="btn">
									<a href="javascript:doAction1('Search');" class="btn filled"><tit:txt mid='114401' mdef='검색'/></a>
									<a href="javascript:setDefaultValue();" class="basic"><tit:txt mid='112391' mdef='초기화'/></a>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"></li>
							<li class="btn">
								<input type="hidden" id="chgOrdTypeCd" name="chgOrdTypeCd" value="H">
								<input type="hidden" id="chgOrdDetailCd" name="chgOrdDetailCd" value="H01">
								<span class="trans hide">발령일자 <input id="chgOrdYmd" name="chgOrdYmd" type="text" size="10" class="date2" value=""/></span>
								<span class="trans hide">변경소속
									<input id="chgOrgNm" name="chgOrgNm" type="text" class="text w100 readonly" readonly />
									<input id="chgOrgCd" name="chgOrgCd" type="hidden" class="text" />
									<a href="javascript:showOrgPopup();" class="button6" style="padding: 0px; border: none; margin-left: 0px;"><img src="${ctx}/common/images/common/btn_search2.gif"/></a>
								</span>

								<a href="javascript:ordSet()" class="trans orange btn hide">적용</a>

								<a href="javascript:showTransBtn()" class="basic">인사이동</a>
								<a href="javascript:goMenu()" class="pointer btn filled">인재비교</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "70%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	</form>
<%--	<div class="hide">
		<script type="text/javascript">createIBSheet("sheet1", "100%", "200px","${ssnLocaleCd}"); </script>
	</div>--%>
</div>
<div id="popWait" class="layerPop" style="display:none; position:absolute; left:0; top:0; width:100%; height:100%; z-index:500;">
	<div class="layerBg" onclick="//closeLayerPop('popWait');" style="position:absolute; left:0; top:0; width:100%; height:100%; z-index:400; background:#000; opacity:.1; filter:alpha(opacity:10);"></div>
	<div class="layerBox" style="position:fixed; left:50%; top:300px; width:240px; margin-left:-180px; padding-bottom:20px; z-index:420; background:#fff;" >
		<div class="layerContent" style="position:relative; padding:20px 20px 20px 20px;"></div>
	</div>
</div>
</body>
</html>
