<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104332' mdef='인사기본(가족)'/></title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

	<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

	<%-- ibSheet file 업로드용 --%>
	<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>

	<script type="text/javascript">
		var gPRow = "";
		var pGubun = "";

		$(function() {
			// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
			initIbFileUpload($("#sheet1Form"));

			// 파일 목록 변수의 초기화 작업 시점 정의
			// clearBeforeFunc(function object)
			// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
			//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
			//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
			sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
			sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

			//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
			///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
			// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
			// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
			EMP_INFO_CHANGE_TABLE_SHEET["thrm111"] = sheet1;

			var resType = "######-*******";
			if($("#hdnAuthPg").val() == 'A') {
				resType = "IdNo";
			}

			var initdata = {};
			initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22};
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

			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			$("#hdnSabun").val($("#searchUserId",parent.document).val());
			$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
			if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
				sheet1.SetEditable(0);
				$(".enterAuthBtn").hide();
			}
			var enterCd = "&enterCd="+$("#hdnEnterCd").val();

			var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H20120"), "");
			var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H20135"), "");
			var userCd3 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getlocationGbnList"+enterCd,false).codeList, "");

			sheet1.SetColProperty("famCd", 				{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
			sheet1.SetColProperty("acaCd", 				{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
			sheet1.SetColProperty("locationGbn", 		{ComboText:"|"+userCd3[0], ComboCode:"|"+userCd3[1]} );
			sheet1.SetColProperty("lunType", 			{ComboText:("${ssnLocaleCd}" != "en_US" ? "양력|음력" : "Solar|Lunar"), ComboCode:"1|2"} );
			sheet1.SetColProperty("famYn", 				{ComboText:"Y|N", ComboCode:"Y|N"} );
			sheet1.SetColProperty("sexType", 				{ComboText:"남|여", ComboCode:"1|2"} );

			$(window).smartresize(sheetResize); sheetInit();
			doAction1("Search");

		});

		//Sheet0 Action
		function doAction1(sAction) {
			switch (sAction) {
				case "Search":
					clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
					var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
					sheet1.DoSearch( "${ctx}/PsnalFamily.do?cmd=getPsnalFamilyList", param );
					break;
				case "Save":
					if(!dupChk(sheet1,"famCd|famNm", true, true)){break;}
					IBS_SaveName(document.sheet1Form,sheet1);
					sheet1.DoSave( "${ctx}/PsnalFamily.do?cmd=savePsnalFamily", $("#sheet1Form").serialize());
					break;
				case "Insert":
					var row = sheet1.DataInsert(0);
					sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
					sheet1.SetCellValue(row,"sabun",$("#hdnSabun").val());
					sheet1.SetCellValue(row, "famYn","Y");
					sheet1.SelectCell(row, "famNm");
					break;
				case "Copy":
					var row = sheet1.DataCopy();
					sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
					sheet1.SetCellValue(row, "fileSeq", '');
					break;
				case "Clear":
					sheet1.RemoveAll();
					break;
				case "Down2Excel":
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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
				//파일 첨부 시작
				for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
					if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
						if(sheet1.GetCellValue(r,"fileSeq") == ''){
							sheet1.SetCellValue(r, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
							sheet1.SetCellValue(r, "sStatus", 'R');
						}else{
							sheet1.SetCellValue(r, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
							sheet1.SetCellValue(r, "sStatus", 'R');
						}
					}else{
						if(sheet1.GetCellValue(r,"fileSeq") != ''){
							sheet1.SetCellValue(r, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
							sheet1.SetCellValue(r, "sStatus", 'R');
						}
					}
				}

				sheetResize();

			} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
			}
		}

		// 저장 후 메시지
		function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
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
		function sheet1_OnChange(Row, Col, Value) {
			try{
				if( sheet1.ColSaveName(Col) == "famres"  ) {
					if(sheet1.GetCellValue(Row,"famres") != ""){
						if(isValid_socno(sheet1.GetCellValue(Row,"famres")) == false){
							if(confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) {
								//주민번호체크 생일입력
								var res = sheet1.GetCellValue(Row, "famres");
								if(res.length >= 13 ) {
									if(res.substring(6,7)=="1" || res.substring(6,7)=="2") {
										sheet1.SetCellValue(Row, "famYmd","19"+res.substring(0,6));
									} else if(res.substring(6,7)=="3" || res.substring(6,7)=="4") {
										sheet1.SetCellValue(Row, "famYmd","20"+res.substring(0,6));
									}
									if(res.substring(6,7)=="1" || res.substring(6,7)=="3") {
										sheet1.SetCellValue(Row, "sexType","1");
									} else if(res.substring(6,7)=="2" || res.substring(6,7)=="4") {
										sheet1.SetCellValue(Row, "sexType","2");
									}
									sheet1.SetCellValue(Row, "lunType","1");

								}
							}else{
								sheet1.SetCellValue(Row, "famres","");
								sheet1.SetCellValue(Row, "famYmd","");
							}
						} else {
							//주민번호체크 생일입력
							var res = sheet1.GetCellValue(Row, "famres");
							if(res.length >= 13 ) {
								if(res.substring(6,7)=="1" || res.substring(6,7)=="2") {
									sheet1.SetCellValue(Row, "famYmd","19"+res.substring(0,6));
								} else if(res.substring(6,7)=="3" || res.substring(6,7)=="4") {
									sheet1.SetCellValue(Row, "famYmd","20"+res.substring(0,6));
								}
								if(res.substring(6,7)=="1" || res.substring(6,7)=="3") {
									sheet1.SetCellValue(Row, "sexType","1");
								} else if(res.substring(6,7)=="2" || res.substring(6,7)=="4") {
									sheet1.SetCellValue(Row, "sexType","2");
								}
								sheet1.SetCellValue(Row, "lunType","1");
							}
						}
					}
				}
			}catch(ex){
				alert("OnChange Event Error : " + ex);
			}
		}

		//파일 신청 시작
		function sheet1_OnClick(Row, Col, Value) {
			try{

				if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
					var param = [];
					param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
					if(sheet1.GetCellValue(Row,"btnFile") != ""){
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
	            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=family&authPg=${authPg}'
	            , parameters : {
					fileSeq : sheet1.GetCellValue(Row,"fileSeq"),
					fileInfo: getFileList(sheet1.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
	              }
	            , width : 740
	            , height : 420
	            , title : '파일 업로드'
	            , trigger :[
	                {
	                      name : 'fileMgrTrigger'
	                    , callback : function(result){
							addFileList(sheet1, gPRow, result); // 작업한 파일 목록 업데이트
	                        if(result.fileCheck == "exist"){
	                            sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
	                            sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
	                        }else{
	                            sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
	                            sheet1.SetCellValue(gPRow, "fileSeq", "");
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
					sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
					sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
				}else{
					sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
					sheet1.SetCellValue(gPRow, "fileSeq", "");
				}
			}
		}

	</script>
	<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='family' mdef='가족'/></li>
				<li class="btn _thrm111">
					<btn:a href="javascript:doAction1('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
					<c:if test="${authPg == 'A'}">
						<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA enterAuthBtn" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA enterAuthBtn" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save');" css="btn filled authA enterAuthBtn" mid='110708' mdef="저장"/>
					</c:if>
					<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
