<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104332' mdef='인사기본(가족)'/></title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
	<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

	<script type="text/javascript">
		var gPRow = "";
		var pGubun = "";
		var searchUserId = '';
		var searchUserEnterCd = '';
		$(function() {
			createIBSheet3(document.getElementById('psnalFamilyLayerSheet-wrap'), "psnalFamilyLayerSheet", "100%", "100%", "${ssnLocaleCd}");

			//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
			///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
			// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
			// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
			EMP_INFO_CHANGE_TABLE_SHEET["thrm111"] = psnalFamilyLayerSheet;

			var resType = "######-*******";
			if($("#hdnAuthPg").val() == 'A') {
				resType = "IdNo";
			}

			const modal = window.top.document.LayerModalUtility.getModal('psnalFamilyLayer');
			searchUserId = modal.parameters.userId || '';
			searchUserEnterCd = modal.parameters.userEnterCd || '';

			$("#hdnSabun").val(searchUserId);
			$("#hdnEnterCd").val(searchUserEnterCd);

			var initdata = {};
			initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",       	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
				{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",       	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='famCd' mdef='가족관계'/>",      	Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"famCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
				{Header:"<sht:txt mid='sdateV1' mdef='SDATE'/>",    	Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
				{Header:"<sht:txt mid='famres' mdef='주민등록번호'/>",  	Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"famres",		KeyField:0,	Format:resType,	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
				{Header:"성별",      										Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
				{Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",      	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"famYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
				{Header:"<sht:txt mid='acaCd' mdef='학력'/>",       	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"acaCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
				{Header:"<sht:txt mid='famYn' mdef='동거여부'/>",      	Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"famYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='famJikweeNm' mdef='직위(학년)'/>",    	Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"famJikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='officeNm' mdef='직장(학교)명'/>",    Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"officeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"학자금지급\n대상자여부",    Type:"CheckBox",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"schYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
				{Header:"가족수당지급\n시작일",      	Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"staYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
				{Header:"가족수당지급\n종료일",      	Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"endYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
				{Header:"건강보험\n피부양자등록여부",    Type:"CheckBox",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"hSupportYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
				{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",       	Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
				{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
				{Header:"가족순번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"famSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },

				{Header:"<sht:txt mid='lunTypeV1' mdef='음양구분'/>",      	Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"lunType",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
				{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",      	Type:"Combo",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"locationGbn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
				{Header:"<sht:txt mid='workNm' mdef='직업'/>",       	Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"workNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"<sht:txt mid='telNo' mdef='연락처'/>",       	Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"telNo",		KeyField:0,	Format:"PhoneNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			]; IBS_InitSheet(psnalFamilyLayerSheet, initdata);psnalFamilyLayerSheet.SetEditable("${editable}");psnalFamilyLayerSheet.SetVisible(true);psnalFamilyLayerSheet.SetCountPosition(0);

			if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
				psnalFamilyLayerSheet.SetEditable(0);
				$(".enterAuthBtn").hide();
			}
			var enterCd = "&enterCd="+$("#hdnEnterCd").val();

			var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H20120"), "");
			var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H20135"), "");
			var userCd3 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getlocationGbnList"+enterCd,false).codeList, "");

			psnalFamilyLayerSheet.SetColProperty("famCd", 				{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
			psnalFamilyLayerSheet.SetColProperty("acaCd", 				{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
			psnalFamilyLayerSheet.SetColProperty("locationGbn", 		{ComboText:"|"+userCd3[0], ComboCode:"|"+userCd3[1]} );
			psnalFamilyLayerSheet.SetColProperty("lunType", 			{ComboText:("${ssnLocaleCd}" != "en_US" ? "양력|음력" : "Solar|Lunar"), ComboCode:"1|2"} );
			psnalFamilyLayerSheet.SetColProperty("famYn", 				{ComboText:"Y|N", ComboCode:"Y|N"} );
			psnalFamilyLayerSheet.SetColProperty("sexType", 				{ComboText:"남|여", ComboCode:"1|2"} );

			let sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
			psnalFamilyLayerSheet.SetSheetHeight(sheetHeight);

			doAction1("Search");

		});

		//Sheet0 Action
		function doAction1(sAction) {
			switch (sAction) {
				case "Search":
					var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
					psnalFamilyLayerSheet.DoSearch( "${ctx}/PsnalFamily.do?cmd=getPsnalFamilyList", param );
					break;
				case "Save":
					if(!dupChk(psnalFamilyLayerSheet,"famCd|famNm", true, true)){break;}
					IBS_SaveName(document.psnalFamilyLayerSheetForm,psnalFamilyLayerSheet);
					psnalFamilyLayerSheet.DoSave( "${ctx}/PsnalFamily.do?cmd=savePsnalFamily", $("#psnalFamilyLayerSheetForm").serialize());
					break;
				case "Insert":
					var row = psnalFamilyLayerSheet.DataInsert(0);
					psnalFamilyLayerSheet.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
					psnalFamilyLayerSheet.SetCellValue(row,"sabun",$("#hdnSabun").val());
					psnalFamilyLayerSheet.SetCellValue(row, "famYn","Y");
					psnalFamilyLayerSheet.SelectCell(row, "famNm");
					break;
				case "Copy":
					var row = psnalFamilyLayerSheet.DataCopy();
					psnalFamilyLayerSheet.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
					psnalFamilyLayerSheet.SetCellValue(row, "fileSeq", '');
					break;
				case "Clear":
					psnalFamilyLayerSheet.RemoveAll();
					break;
				case "Down2Excel":
					var downcol = makeHiddenSkipCol(psnalFamilyLayerSheet);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
					psnalFamilyLayerSheet.Down2Excel(param);
					break;
			}
		}

		// 조회 후 에러 메시지
		function psnalFamilyLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try {
				if (Msg != "") {
					alert(Msg);
				}
				//파일 첨부 시작
				for(var r = psnalFamilyLayerSheet.HeaderRows(); r<psnalFamilyLayerSheet.RowCount()+psnalFamilyLayerSheet.HeaderRows(); r++){
					if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
						if(psnalFamilyLayerSheet.GetCellValue(r,"fileSeq") == ''){
							psnalFamilyLayerSheet.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
							psnalFamilyLayerSheet.SetCellValue(r, "sStatus", 'R');
						}else{
							psnalFamilyLayerSheet.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
							psnalFamilyLayerSheet.SetCellValue(r, "sStatus", 'R');
						}
					}else{
						if(psnalFamilyLayerSheet.GetCellValue(r,"fileSeq") != ''){
							psnalFamilyLayerSheet.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
							psnalFamilyLayerSheet.SetCellValue(r, "sStatus", 'R');
						}
					}
				}

				sheetResize();

			} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
			}
		}

		// 저장 후 메시지
		function psnalFamilyLayerSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try {
				if (Msg != "") {
					alert(Msg);
				}

				doAction1("Search");
			} catch (ex) {
				alert("OnSaveEnd Event Error " + ex);
			}
		}

		// 셀 값이 바뀔때 발생
		function psnalFamilyLayerSheet_OnChange(Row, Col, Value) {
			try{
				if( psnalFamilyLayerSheet.ColSaveName(Col) == "famres"  ) {
					if(psnalFamilyLayerSheet.GetCellValue(Row,"famres") != ""){
						if(isValid_socno(psnalFamilyLayerSheet.GetCellValue(Row,"famres")) == false){
							if(confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) {
								//주민번호체크 생일입력
								var res = psnalFamilyLayerSheet.GetCellValue(Row, "famres");
								if(res.length >= 13 ) {
									if(res.substring(6,7)=="1" || res.substring(6,7)=="2") {
										psnalFamilyLayerSheet.SetCellValue(Row, "famYmd","19"+res.substring(0,6));
									} else if(res.substring(6,7)=="3" || res.substring(6,7)=="4") {
										psnalFamilyLayerSheet.SetCellValue(Row, "famYmd","20"+res.substring(0,6));
									}
									if(res.substring(6,7)=="1" || res.substring(6,7)=="3") {
										psnalFamilyLayerSheet.SetCellValue(Row, "sexType","1");
									} else if(res.substring(6,7)=="2" || res.substring(6,7)=="4") {
										psnalFamilyLayerSheet.SetCellValue(Row, "sexType","2");
									}
									psnalFamilyLayerSheet.SetCellValue(Row, "lunType","1");

								}
							}else{
								psnalFamilyLayerSheet.SetCellValue(Row, "famres","");
								psnalFamilyLayerSheet.SetCellValue(Row, "famYmd","");
							}
						} else {
							//주민번호체크 생일입력
							var res = psnalFamilyLayerSheet.GetCellValue(Row, "famres");
							if(res.length >= 13 ) {
								if(res.substring(6,7)=="1" || res.substring(6,7)=="2") {
									psnalFamilyLayerSheet.SetCellValue(Row, "famYmd","19"+res.substring(0,6));
								} else if(res.substring(6,7)=="3" || res.substring(6,7)=="4") {
									psnalFamilyLayerSheet.SetCellValue(Row, "famYmd","20"+res.substring(0,6));
								}
								if(res.substring(6,7)=="1" || res.substring(6,7)=="3") {
									psnalFamilyLayerSheet.SetCellValue(Row, "sexType","1");
								} else if(res.substring(6,7)=="2" || res.substring(6,7)=="4") {
									psnalFamilyLayerSheet.SetCellValue(Row, "sexType","2");
								}
								psnalFamilyLayerSheet.SetCellValue(Row, "lunType","1");
							}
						}
					}
				}
			}catch(ex){
				alert("OnChange Event Error : " + ex);
			}
		}

		//파일 신청 시작
		function psnalFamilyLayerSheet_OnClick(Row, Col, Value) {
			try{

				if(psnalFamilyLayerSheet.ColSaveName(Col) == "btnFile" && Row >= psnalFamilyLayerSheet.HeaderRows()){
					var param = [];
					param["fileSeq"] = psnalFamilyLayerSheet.GetCellValue(Row,"fileSeq");
					if(psnalFamilyLayerSheet.GetCellValue(Row,"btnFile") != ""){
						if(!isPopup()) {return;}

						gPRow = Row;
						pGubun = "fileMgrPopup";

						var authPgTemp="${authPg}";
						//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp, param, "740","620");
		                fileMgrPopup(Row, Col);

					}
				}
			}catch(ex){alert("OnClick Event Error : " + ex);}
		}
		   // 파일첨부/다운로드 팝입
	    function fileMgrPopup(Row, Col) {
	        let layerModal = new window.top.document.LayerModal({
	              id : 'fileMgrLayer'
	            , url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&uploadType=family&authPg=${authPg}'
	            , parameters : {
	                fileSeq : psnalFamilyLayerSheet.GetCellValue(Row,"fileSeq")
	              }
	            , width : 740
	            , height : 420
	            , title : '파일 업로드'
	            , trigger :[
	                {
	                      name : 'fileMgrTrigger'
	                    , callback : function(result){
	                        if(result.fileCheck == "exist"){
	                            psnalFamilyLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
	                            psnalFamilyLayerSheet.SetCellValue(gPRow, "fileSeq", result.fileSeq);
	                        }else{
	                            psnalFamilyLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
	                            psnalFamilyLayerSheet.SetCellValue(gPRow, "fileSeq", "");
	                        }
	                    }
	                }
	            ]
	        });
	        layerModal.show();
	    }
		//파일 신청 끝

		//팝업 콜백 함수.
		function getReturnValue(returnValue) {
			var rv = $.parseJSON('{' + returnValue+ '}');

			if(pGubun == "fileMgrPopup") {
				if(rv["fileCheck"] == "exist"){
					psnalFamilyLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
					psnalFamilyLayerSheet.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
				}else{
					psnalFamilyLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
					psnalFamilyLayerSheet.SetCellValue(gPRow, "fileSeq", "");
				}
			}
		}

	</script>
	<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<form id="psnalFamilyLayerSheetForm" name="psnalFamilyLayerSheetForm"></form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
		<input id="hdnSabun" name="hdnSabun" type="hidden">
		<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="btn _thrm111">
						<btn:a href="javascript:doAction1('Search');" css="basic authR" mid='110697' mdef="조회"/>
						<c:if test="${authPg == 'A'}">
							<btn:a href="javascript:doAction1('Insert');" css="basic authA enterAuthBtn" mid='110700' mdef="입력"/>
							<btn:a href="javascript:doAction1('Copy');" css="basic authA enterAuthBtn" mid='110696' mdef="복사"/>
							<btn:a href="javascript:doAction1('Save');" css="basic authA enterAuthBtn" mid='110708' mdef="저장"/>
						</c:if>
						<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
			</div>
		</div>
<%--		<script type="text/javascript"> createIBSheet("psnalFamilyLayerSheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
		<div id="psnalFamilyLayerSheet-wrap"></div>
	</div>
</div>
</body>
</html>
