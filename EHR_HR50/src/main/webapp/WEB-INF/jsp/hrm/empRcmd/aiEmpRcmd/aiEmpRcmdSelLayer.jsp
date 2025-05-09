<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>대상자 검색</title>
	<script type="text/javascript">
		var gPRow = "";
		var pGubun = "";
		var sltSch 	= "";

		$(function() {
			const modal = window.top.document.LayerModalUtility.getModal('aiEmpRcmdSelLayer');
			modal.makeFull();

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
							pGubun = "orgTreePopup";
							getReturnValue(rv);
						}
					}
				]
			});
			layerModal.show();
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
				case "6" :
					$("#statusNm").val("재직,휴직");
					$("#statusCd").val("AA,CA");
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
		}
	</script>

	<!-- sheet1 -->
	<script type="text/javascript">
		$(function() {
			createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");

			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='check' mdef='선택'/>",				Type:"DummyCheck",  Hidden:0,   Width:50,    Align:"Center", ColMerge:0, SaveName:"checkYn",	KeyField:0, UpdateEdit:1,   InsertEdit:0,   EditLen:100, },
				//{Header:"<sht:txt mid='photoV1' mdef='사진'/>",       	Type:"Image",   Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
				{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
				{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
				{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
				{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
				{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
				{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",				Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
				{Header:"<sht:txt mid='applJobJikgunNmV1' mdef='직군'/>",	Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
				{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"Ymd" },
				{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",				Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"Ymd" },
				{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"IdNo" },
				{Header:"<sht:txt mid='retYmd' mdef='퇴직일'/>",				Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"Ymd" },
				{Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	Format:"Ymd" },
				{Header:"<sht:txt mid='handPhone_V6736' mdef='핸드폰번호'/>",	Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"handPhone",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
				{Header:"<sht:txt mid='mailId' mdef='메일주소'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"mailId",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(0);
			sheet1.SetAutoRowHeight(0);
			sheet1.SetDataRowHeight(60);
			$(window).smartresize(sheetResize);
			sheetInit();
		});

		function addAiEmpRcmd(){
			var sRow = sheet1.FindCheckedRow("checkYn");
			if( sRow == "" ){
				alert("대상을 선택 해주세요.");
				return;
			}
			var arrRows = sRow.split("|");
			var sabuns = [];
			for( var i = 0; i < arrRows.length ; i++ ) {
				var row = arrRows[i];
				sabuns.push(sheet1.GetCellValue(row, "sabun"));
			}
			$('#sabuns').val(sabuns);
			const modal = window.top.document.LayerModalUtility.getModal('aiEmpRcmdSelLayer');
			$('#rGubun').val(modal.parameters.rGubun);
			$('#rType').val(modal.parameters.rType);
			var result = ajaxCall("${ctx}/AiEmpRcmd.do?cmd=saveAiEmpRcmd", $("#saveFrm").serialize(), false);

			alert('대상자가 추가 되었습니다.');
			modal.fire('aiEmpRcmdSelLayerTrigger');
			closeCommonLayer('aiEmpRcmdSelLayer');
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
		function doActionSelLayer(sAction) {
			switch (sAction) {
				case "Search":
					sheet1.DoSearch( "${ctx}/SpecificEmpSrch.do?cmd=getSpecificEmpList", $("#searchFrm").serialize() );
					break;
				case "Clear":
					sheet1.RemoveAll();
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
			} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
			} finally {
				closeLayerPop('popWait');
			}
		}


	</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="searchFrm" name="searchFrm">
			<input type="hidden" id="srchSeq" name="srchSeq" value="" />
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<tr>
					<td class="top">
						<table class="table" style="height:230px">
							<colgroup>
								<col width="30%" />
								<col width="" />
							</colgroup>
							<tr>
								<th><tit:txt mid='104279' mdef='소속'/></th>
								<td>
									<input id="searchOrgNm" name="searchOrgNm" type="text" class="text w50p readonly" readonly/>
									<input id="searchOrgCd" name="searchOrgCd" type="hidden" class="text"/>
									<a href="javascript:showOrgPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('1')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
									<input type="checkbox" class="checkbox" name="searchOrgType" value="Y" checked/><b><tit:txt mid='112471' mdef='하위포함'/></b>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='104471' mdef='직급'/></th>
								<td>
									<input id="jikgubNm" name="jikgubNm" type="text" class="text w70p readonly" readonly/>
									<input id="jikgubCd" name="jikgubCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('jikgub');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('2')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='104104' mdef='직위'/></th>
								<td>
									<input id="jikweeNm" name="jikweeNm" type="text" class="text w70p readonly" readonly/>
									<input id="jikweeCd" name="jikweeCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('jikwee');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('3')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='103785' mdef='직책'/></th>
								<td>
									<input id="jikchakNm" name="jikchakNm" type="text" class="text w70p readonly" readonly/>
									<input id="jikchakCd" name="jikchakCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('jikchak');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('4')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='103973' mdef='직무'/></th>
								<td>
									<input id="jikmooNm" name="jikmooNm" type="text" class="text w70p readonly" readonly/>
									<input id="jikmooCd" name="jikmooCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('jikmoo');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('5')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='103881' mdef='입사일'/></th>
								<td>
									<input id="empSYmd" name="empSYmd" type="text" size="10" class="date2" value=""/> ~
									<input id="empEYmd" name="empEYmd" type="text" size="10" class="date2" value=""/>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='104090' mdef='퇴사일'/></th>
								<td>
									<input id="retSYmd" name="retSYmd" type="text" size="10" class="date2" value=""/> ~
									<input id="retEYmd" name="retEYmd" type="text" size="10" class="date2" value=""/>
								</td>
							</tr>
						</table>
					</td>
					<td class="top">
						<table class="table" style="height:230px">
							<colgroup>
								<col width="30%" />
								<col width="" />
							</colgroup>
							<tr>
								<th><tit:txt mid='104472' mdef='재직상태'/></th>
								<td>
									<input id="statusNm" name="statusNm" type="text" class="text w70p readonly" readonly/>
									<input id="statusCd" name="statusCd" type="hidden" class="text"/>
									<a href="javascript:showConditionPopup('status');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('6')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='114622' mdef='출신학교'/></th>
								<td> <select id="sltSch" name ="sltSch">
									<!-- 					            <option value="">전체</option>
                                                                    <option value="11">대학원(박사)</option>
                                                                    <option value="12">대학원(석사)</option>
                                                                    <option value="21" selected>대학교</option>
                                                                    <option value="31">전문대학</option>
                                                                    <option value="41">고등학교</option> -->
								</select>
									<input id="searchSchCode" name="searchSchCode" type="hidden" class="text w50p"/>
									<input id="searchSch" name="searchSch" type="text" class="text w50p"/>
									<span id="searchSchButton" class="">
 							<a href="javascript:uniPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
 							</span>
									<a href="javascript:clearCode('8')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='103903' mdef='전공'/></th>
								<td>
									<input id="searchMjrCd" name="searchMjrCd" type="text" class="text w70p hide"/>
									<input id="searchMjrNm" name="searchMjrNm" type="text" class="text w70p readonly" readonly/>
									<a href="javascript:showConditionPopup('major');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
									<a href="javascript:clearCode('7')" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='112123' mdef='출신회사'/></th>
								<td> <input id="searchBfCmp" name="searchBfCmp" type="text" class="text w100p"/> </td>
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
								<td>
									<div class="input-wrap">
										<input id="searchSAge" name="searchSAge" type="text" class="text w25p center w-half" maxlength="3"/>세 ~
										<input id="searchEAge" name="searchEAge" type="text" class="text w25p center w-half" maxlength="3"/>세
									</div>
								</td>
							</tr>
							<tr>
								<th><tit:txt mid='114623' mdef='남녀구분'/></th>
								<td>
									<select id="searchSex" name ="searchSex">
										<option value="">전체</option>
										<option value="1">남</option>
										<option value="2">여</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<form id="saveFrm" name="saveFrm">
			<input type="hidden" id="sabuns" name="sabuns" value="" />
			<input type="hidden" id="rGubun" name="rGubun" value="" />
			<input type="hidden" id="rType" name="rType" value="" />
		</form>
		<div class="sheet_title">
			<ul>
				<li><span style="color:orange";> *검색조건에 따라 검색결과 속도가 <strong>저하</strong>될 수 있습니다. </font></li>
				<li class="btn">
					<a href="javascript:doActionSelLayer('Search');" class="pink large"><tit:txt mid='114401' mdef='검색'/></a>
					<a href="javascript:setDefaultValue();" class="basic"><tit:txt mid='112391' mdef='초기화'/></a>
				</li>
			</ul>
		</div>
		<div id="sheet1-wrap"></div>
	</div>
	<div class="modal_footer">
		<a href="javascript:addAiEmpRcmd();" class="btn outline_gray">추가</a>
		<a href="javascript:closeCommonLayer('aiEmpRcmdSelLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>