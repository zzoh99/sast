<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>충원신청</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

	<script type="text/javascript">

		var searchApplSeq    = "${searchApplSeq}";
		var adminYn          = "${adminYn}";
		var authPg           = "${authPg}";
		var searchApplSabun  = "${searchApplSabun}";
		var searchApplInSabun= "${searchApplInSabun}";
		var searchApplYmd    = "${searchApplYmd}";
		var applStatusCd	 = "";
		var pGubun         = "";
		var gPRow = "";
		var reqGubun 	 = "${etc01}";
		var defHeight = 580;
		var rowHeight = 28;
		var dtlHeight = 545;
		var dtlSeq = 0;
		var hdn = 0;

		$(function() {

			parent.iframeOnLoad(defHeight+"px");

			//----------------------------------------------------------------
			$("#searchApplSeq").val(searchApplSeq);
			$("#searchApplSabun").val(searchApplSabun);
			$("#searchApplYmd").val(searchApplYmd);
			$("#searchReqGubun").val(reqGubun);

			applStatusCd = parent.$("#applStatusCd").val();

			if(applStatusCd == "") {
				applStatusCd = "11";
			}
			//----------------------------------------------------------------

			init_sheet();

			//----------------------------------------------------------------

			if(authPg == "A") {
				hdn = 0;
			} else if (authPg == "R") {
				hdn = 1;
				sheet1.SetEditable(0);
				$(".btnIns").hide();
				$(".button6").hide();
				$("input:checkbox").bind("click", function(){
					alert(this.checked);
				});
			}
			if(reqGubun == "1"){
				dtlHeight = 545;
			}else{
				dtlHeight = 555;
			}

			doAction1("Search");
		});
		function init_sheet(){
			var hd = 1;
			if( reqGubun == "1" ){ //인력충원일 때만
				hd = 0;
			}
			var initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, UseNoDataRow:0};
			initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"No|No",		Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0, SaveName:"sNo", Sort:0, Sort:0 },
				{Header:"삭제|삭제",	Type:"${sDelTy}",	Hidden:hdn,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태|상태",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"부서|부서",			Type:"Popup",	Hidden:0,	Width:120,	Align:"Left",	SaveName:"orgNm",		KeyField:1,	Edit:1 },
				{Header:"부서|부서",			Type:"Text",	Hidden:1,	Width:10,	Align:"Center",	SaveName:"orgCd",		KeyField:0,	Edit:0 },
				{Header:"기준인원|기준인원",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	SaveName:"stdCnt",		KeyField:0,	Edit:0 },
				{Header:"현재인원|현재인원",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	SaveName:"curCnt",		KeyField:0,	Edit:0 },

				{Header:"변동예정인원|퇴직",	Type:"Text",	Hidden:hd,	Width:50,	Align:"Center",	SaveName:"raCnt",		KeyField:0,	Format:"Number", Edit:1 },
				{Header:"변동예정인원|이동",	Type:"Text",	Hidden:hd,	Width:50,	Align:"Center",	SaveName:"mvCnt",		KeyField:0,	Format:"Number", Edit:1 },
				{Header:"변동예정인원|휴직",	Type:"Text",	Hidden:hd,	Width:50,	Align:"Center",	SaveName:"caCnt",		KeyField:0,	Format:"Number", Edit:1 },

				{Header:"변동적용\n후 인원|변동적용\n후 인원",
					Type:"Text",	Hidden:hd,	Width:80,	Align:"Center",	SaveName:"calcCnt",		CalcLogic:"|curCnt|-|raCnt|-|mvCnt|-|caCnt|",	Edit:0 },
				{Header:"신청인원|신청인원",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"reqCnt",		KeyField:1,	Edit:1 },
				{Header:"채용완료\n후 총인원|채용완료\n후 총인원",
					Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"totCnt",		CalcLogic:"|calcCnt|+|reqCnt|",	Edit:0 },
			];
			IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

			initdata.Cols = [
				{Header:"상태",					Type:"${sSttTy}",Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				{Header:"dtlSeq",				Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlSeq" },
				{Header:"dtlName",				Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlRsnName" },
				{Header:"dtlRsnOrgCd",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlRsnOrgCd" },
				{Header:"dtlRsnOrgNm",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlRsnOrgNm" },
				{Header:"dtlRsnJikgubCd",		Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlRsnJikgubCd" },
				{Header:"dtlRsnJikgubNm",		Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlRsnJikgubNm" },
				{Header:"dtlRsnSabun",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlRsnSabun" },
				{Header:"dtlRsnGubun",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlRsnGubun" },
				{Header:"dtlRsnNote",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlRsnNote" },
				{Header:"dtlReqCnt",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlReqCnt" },
				{Header:"dtlAcaCd",				Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlAcaCd" },
				{Header:"dtlJikgubCd",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlJikgubCd" },
				{Header:"dtlCareerCd",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlCareerCd" },
				{Header:"dtlCareerNote",		Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlCareerNote" },
				{Header:"dtlAcamajNote",		Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlAcamajNote" },
				{Header:"dtlEtcNote",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlEtcNote" },
				{Header:"dtlJobCd",			    Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlJobCd" },
				{Header:"dtlReqYmd",			Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlReqYmd" },
				{Header:"dtlNote",				Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"dtlNote" },
				{Header:"title",				Type:"Text",		Hidden:0,	Width:10,	Align:"Center",	SaveName:"title" },
			];
			IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(0);

			if(authPg == "A") {
				var info = { FontColor:"#FF0000" };
				sheet1.SetColProperty(0, "raCnt", info);
				sheet1.SetColProperty(0, "mvCnt", info);
				sheet1.SetColProperty(0, "caCnt", info);
				sheet1.SetColProperty(0, "reqCnt", info);
			}
			$(window).smartresize(sheetResize); sheetInit();

		}

		//--------------------------------------------------------------------------------
		//  상세입력 추가
		//--------------------------------------------------------------------------------
		function addDtlTable(){
			try{
				//Iframe 높이 설정
				defHeight = defHeight + dtlHeight;
				parent.iframeOnLoad(defHeight+"px");

				//상세 Html 샘플
				var dtlSample = $("#dtlSample").html();
				dtlSample = replaceAll(dtlSample, "required", "required required2");

				//상세 HTML ID replace
				var arr = ["dtlTable","dtlRsnOrgCd","dtlRsnJikgubCd","span_dtlName","dtlRsnSabun","span_dtlRsnOrgNm","span_dtlRsnJikgubNm"
					,"dtlRsnName","dtlRsnGubun","dtlReqCnt","dtlAcaCd","dtlJikgubCd","dtlCareerCd","dtlRsnNote"
					,"dtlCareerNote","dtlAcamajNote","dtlEtcNote","dtlJobCd","dtlReqYmd","dtlNote"];
				for( var i=0; i < arr.length; i++){
					dtlSample = replaceAll(dtlSample, arr[i], arr[i]+dtlSeq );
				}
				dtlSample = replaceAll(dtlSample, "closeDtl()", "closeDtl("+dtlSeq+")");

				$("#dtlDiv").append(dtlSample+"<div id='dtlTableDiv"+dtlSeq+"' class='h5'>&nbsp;</div>");

				if(authPg == "A") {
					$("#dtlReqYmd"+dtlSeq).datepicker2();
					$("#dtlCareerNote"+dtlSeq).maxbyte(1000);
					$("#dtlAcamajNote"+dtlSeq).maxbyte(1000);
					$("#dtlEtcNote"+dtlSeq).maxbyte(1000);
					//$("#dtlJobNote"+dtlSeq).maxbyte(1000);
					$("#dtlNote"+dtlSeq).maxbyte(1000);
					$("#dtlRsnNote"+dtlSeq).maxbyte(1000);

				}

				//입력 누를때마다 추가 됨.
				dtlSeq = dtlSeq + 1;
			}catch(e){
				alert("addDtlTable() Error");
			}
		}
		//--------------------------------------------------------------------------------
		//  상세 박스 삭제
		//--------------------------------------------------------------------------------
		function closeDtl(seq){
			if( $(".btnClose").length == 2) return; //상세 입력 1개는 있어야함.
			$("#dtlTable"+seq).remove();
			$("#dtlTableDiv"+seq).remove();

			defHeight = defHeight - dtlHeight + 1;
			parent.iframeOnLoad(defHeight+"px");
		}

		//--------------------------------------------------------------------------------
		//  Sheet1 Action
		//--------------------------------------------------------------------------------
		function doAction1(sAction) {
			switch (sAction) {
				case "Search":
					sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getOrgCapaPlanAppDetList1", $("#dataForm").serialize() );
					sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getOrgCapaPlanAppDetList2", $("#dataForm").serialize() );
					break;
				case "Insert":
					var h = sheet1.GetSheetHeight();
					sheet1.SetSheetHeight(h + rowHeight);
					var row = sheet1.DataInsert(-1);
					defHeight = defHeight + rowHeight;
					parent.iframeOnLoad(defHeight+"px");

					gPRow = row;
					pGubun = "orgPopup";
					openLayerPop("org");
					break;

			}
		}

		//--------------------------------------------------------------------------------
		//  sheet1 Events
		//--------------------------------------------------------------------------------
		function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try {
				if (Msg != "") {
					alert(Msg);
				}
				if( sheet1.RowCount() == 0 ){
					var row = sheet1.DataInsert(0);

					//신청자 조직정보 조회
					var data = ajaxCall( "${ctx}/GetDataMap.do?cmd=getOrgCapaPlanAppDetUserMap", $("#dataForm").serialize(),false);

					if ( data != null && data.DATA != null ){
						sheet1.SetCellValue(row, "orgCd", data.DATA.orgCd);
						sheet1.SetCellValue(row, "orgNm", data.DATA.orgNm);
						$("#searchOrgCd").val(data.DATA.orgCd);
						getOrgStdEmpCnt(row);
					}

				}else{
					var h = sheet1.GetSheetHeight();
					var ih = ( sheet1.RowCount() ) * rowHeight;
					sheet1.SetSheetHeight(h + ih);
					defHeight = defHeight + ih;
					parent.iframeOnLoad(defHeight+"px");
				}
				sheetResize();
			} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
			}
		}

		// 팝업 클릭시 발생
		function sheet1_OnPopupClick(Row,Col) {
			try {
				if(sheet1.ColSaveName(Col) == "orgNm") {
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "orgPopup";

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
								, callback : function(rv){
									if(!rv.length) return;
									sheet1.SetCellValue(gPRow, "orgCd", rv["code"]);
									sheet1.SetCellValue(gPRow, "orgNm", rv["codeNm"]);

									//기준인원, 현재인원 조회
									$("#searchOrgCd").val(rv["code"]);
									getOrgStdEmpCnt(gPRow);
								}
							}
						]
					});
					layerModal.show();


					//openLayerPop("org");
				}
			} catch (ex) {
				alert("OnPopupClick Event Error : " + ex);
			}
		}
		//삭제클릭 시 삭제
		function sheet1_OnBeforeCheck(Row,Col) {
			try {
				if( sheet1.ColSaveName(Col) == "sDelete" ){
					sheet1.RowDelete(Row, 0);
				}
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		//--------------------------------------------------------------------------------
		//  sheet2 Events
		//--------------------------------------------------------------------------------
		function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try {
				if (Msg != "") {
					alert(Msg);
				}

				if( sheet2.RowCount() > 0 ){

					var arr = ["dtlRsnName","dtlRsnOrgCd","dtlRsnJikgubCd","dtlRsnSabun","dtlRsnGubun","dtlReqCnt","dtlRsnNote"
						,"dtlCareerNote","dtlAcamajNote","dtlEtcNote","dtlReqYmd","dtlNote"];
					var arr2 = ["dtlAcaCd","dtlJikgubCd","dtlCareerCd","dtlJobCd"];
					var title = "title";
					$("#title").val(sheet2.GetCellValue(1,title));

					dtlSeq = 1;
					for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
						addDtlTable();

						for( var j=0; j < arr.length ; j++ ){
							$("#"+arr[j]+(dtlSeq-1)).val(sheet2.GetCellValue(i, arr[j]));
						}
						$("#span_dtlRsnOrgNm"+(dtlSeq-1)).html(sheet2.GetCellValue(i, "dtlRsnOrgNm")+"&nbsp;");
						$("#span_dtlRsnJikgubNm"+(dtlSeq-1)).html(sheet2.GetCellValue(i, "dtlRsnJikgubNm")+"&nbsp;");
						$("#span_dtlRsnSabun"+(dtlSeq-1)).html("&nbsp;(&nbsp;"+sheet2.GetCellValue(i, "dtlRsnSabun")+"&nbsp;)&nbsp;");

						for( var j=0; j < arr2.length ; j++ ){
							var chkArr = (sheet2.GetCellValue(i, arr2[j])).split(",");
							if( chkArr.length > 0 ){
								for( var k=0; k < chkArr.length ; k++ ){
									$("input:checkbox[name='"+arr2[j]+(dtlSeq-1)+"']:input[value='"+chkArr[k]+"']").attr("checked", true);
								}
							}
						}

						if (authPg == "R") {
							$("#span_dtlName"+(dtlSeq-1)).html(sheet2.GetCellValue(i, "dtlRsnName")+"&nbsp;");
							$("#dtlRsnName"+(dtlSeq-1)).hide();

							//$("#span_dtlRsnJikgubNm"+(dtlSeq-1)).after("<br/>");
							$("#dtlRsnGubun"+(dtlSeq-1)).css("width", "20%");
						}

					}


				}else{
					addDtlTable();
				}
				if (authPg == "R") {
					$("input:checkbox").bind("click", function(){
						this.checked = !this.checked;
					});
				}
				sheetResize();
			} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
			}
		}
		//사원찾기 팝업
		function employeePopup(id){
			var seq = id.split("dtlRsnName")[1];
			gPRow = parseInt(seq);
			pGubun = "empPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'employeeLayer'
				, url : '/Popup.do?cmd=viewEmployeeLayer'
				, parameters : {}
				, width : 740
				, height : 520
				, title : '사원조회'
				, trigger :[
					{
						name : 'employeeTrigger'
						, callback : function(rv){
							$("#span_dtlRsnOrgNm"+(gPRow)).html(rv["orgNm"]+"&nbsp;");
							$("#span_dtlRsnJikgubNm"+(gPRow)).html( rv["jikgubNm"]+"&nbsp;");
							$("#span_dtlRsnSabun"+(gPRow)).html("&nbsp;(&nbsp;"+rv["sabun"]+"&nbsp;)&nbsp;");

							$("#dtlRsnSabun"+(gPRow)).val(rv["sabun"]);
							$("#dtlRsnName"+(gPRow)).val(rv["name"]);
							$("#dtlRsnOrgCd"+(gPRow)).val(rv["orgCd"]);
							$("#dtlRsnJikgubCd"+(gPRow)).val(rv["jikgubCd"]);
						}
					}
				]
			});
			layerModal.show();
		}

		/*기준인원/현재인원 조회*/
		function getOrgStdEmpCnt(Row){
			var data = ajaxCall( "${ctx}/GetDataMap.do?cmd=getOrgCapaPlanAppDetMap", $("#dataForm").serialize(),false);

			if ( data != null && data.DATA != null ){
				sheet1.SetCellValue(Row, "stdCnt", data.DATA.planCnt);
				sheet1.SetCellValue(Row, "curCnt", data.DATA.curCnt);
			}
		}

		//--------------------------------------------------------------------------------
		//  저장 시 필수 입력 및 조건 체크
		//--------------------------------------------------------------------------------
		function checkList(status) {
			var ch = true;

			if( ch && reqGubun != "3" ){//증원신청-2 일때는 기준인원 체크 안함.
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					if( sheet1.GetCellValue(i, "stdCnt") == "" ){
						alert("기준인원이 없습니다.");
						ch = false;
						return false;
					}

					if( parseInt(sheet1.GetCellValue(i, "stdCnt")) < parseInt(sheet1.GetCellValue(i, "totCnt")) ){
						alert("총인원이 기준인원보다 많습니다.");
						ch = false;
						return false;
					}


				}

			}
			//sheet2 체크
			// 충원신청일경우 휴직이면서 계약직이 아니면
			if( reqGubun == "1" ) {
				for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
					if (sheet2.GetCellValue(i,"dtlRsnGubun") =="C" && sheet2.GetCellValue(i,"dtlJikgubCd") !="C02") {
						alert("휴직에 의한 채용은 휴직인원 보충을 위한 채용으로 계약직채용을 지향합니다.");

						//ch = false;
						//return false;
						return true;
					}
				}
			}

			// 화면의 개별 입력 부분 필수값 체크
			$(".required2").each(function(index){
				if($(this).val() == null || $(this).val() == ""){
					alert($(this).parent().prev().text()+"은(는) 필수값입니다.");
					$(this).focus();
					ch =  false;
					return false;
				}

			});



			return ch;
		}

		//--------------------------------------------------------------------------------
		//  임시저장 및 신청 시 호출
		//--------------------------------------------------------------------------------
		function setValue(status) {
			var returnValue = false;
			try {
				sheet1.SelectCell(0,0);
				if ( authPg == "R" )  {
					return true;
				}

				if( sheet1.RowCount()  == 0 ){
					alert("신청내용을 입력 해주세요.");
					return false;
				}
				//상세내역을 시트로 이동
				if ( !setHtmlToSheet2() ) {
					return false;
				}

				if( sheet2.RowCount()  == 0 ){
					alert("신청 상세내용을 입력 해주세요.");
					return false;
				}


				// 항목 체크 리스트
				if ( !checkList() ) {
					return false;
				}

				//전체 삭제 후 다시 저장 하기 때문에 입력으로 변경
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					sheet1.SetCellValue(i, "sStatus", "I", 0);
				}

				var saveStr1 = sheet1.GetSaveString(0);
				if(saveStr1.match("KeyFieldError")) { return false; }

				//증원신청-2 경우 경고메세지 표시
				if( reqGubun == "3"){
					if( !confirm("결재선에 대표이사가 포함되어 있어야 합니다.\n신청 하시겠습니까?") ) return false;
				}


				IBS_SaveName(document.dataForm, sheet1);
				var params = $("#dataForm").serialize()+"&"+saveStr1;
				var rtn = (new Function ('return '+"("+sheet1.GetSaveData("${ctx}/OrgCapaPlanApp.do?cmd=saveOrgCapaPlanAppDet1", params )+")" ))();

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					returnValue = false;
				}else{
					var saveStr2 = sheet2.GetSaveString(0);
					$("#titleValue").val( $("#title").val() );
					IBS_SaveName(document.dataForm, sheet2);
					var params2 = $("#dataForm").serialize()+"&"+saveStr2;

					var rtn2 = (new Function ('return '+"("+sheet1.GetSaveData("${ctx}/OrgCapaPlanApp.do?cmd=saveOrgCapaPlanAppDet2", params2 )+")" ))();

					if(rtn2.Result.Code < 1) {
						alert(rtn2.Result.Message);
						returnValue = false;
					}else{
						returnValue = true;
					}
				}


			} catch (ex){
				alert("저장 중 오류발생." + ex);
				returnValue = false;
			}

			return returnValue;
		}

		//--------------------------------------------------------------------------------
		//  상세내역을 시트로 이동
		//--------------------------------------------------------------------------------
		function setHtmlToSheet2(){
			var ch = true;
			sheet2.RemoveAll();
			var arr = ["dtlRsnOrgCd","dtlRsnJikgubCd","dtlRsnSabun","dtlRsnGubun","dtlReqCnt","dtlRsnNote"
				,"dtlCareerNote","dtlAcamajNote","dtlEtcNote","dtlReqYmd","dtlNote"];

			var arr2 = ["dtlAcaCd","dtlJikgubCd","dtlCareerCd","dtlJobCd"];
			var arr2nm = ["학력","직급","경력유무","직무"];

			var seq = 0;
			for( var i=0; i < dtlSeq ; i++ ){
				if ( $("#dtlTable"+i).length > 0 ){

					var row = sheet2.DataInsert(-1);

					for( var j=0; j < arr.length ; j++ ){
						sheet2.SetCellValue(row, arr[j], $("#"+arr[j]+i).val() );
					}
					for( var j=0; j < arr2.length ; j++ ){
						var tmp = "";
						$('input:checkbox[name="'+arr2[j]+i+'"]:checked').each(function() {
							tmp = tmp + this.value+",";
						});
						tmp = tmp.substr(0, tmp.length-1);

						if( tmp == "" ) {
							alert(arr2nm[j] + "을 선택 해주세요.");
							//$("#"+arr2[j]+"0").focus();
							ch = false;
							return false;

						}
						sheet2.SetCellValue(row, arr2[j], tmp );
					}


				}
			}
			return true;
		}

		function jobMgrPopup(jobCd) {
			if (!isPopup()) {
				return;
			}

			var w = 940;
			var h = 800;
			var url = "/Popup.do?cmd=viewJobMgrLayer&authPg=R";
			var args = new Array();
			args["jobCd"] = jobCd;

			pGubun = "jobMgrPopup";

			var jobMgrLayer = new window.top.document.LayerModal({
				id: 'jobMgrLayer',
				url: url,
				parameters: args,
				width: w,
				height: h,
				title: '직무기술서',
				trigger: [
					{
						name: 'jobMgrLayerTrigger',
						callback: function(rv) {
						}
					}
				]
			});

			jobMgrLayer.show();
		}
	</script>
	<style type="text/css">

		/*---- checkbox ----*/
		input[type="checkbox"]  {
			display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none;
			-moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
			border: 5px solid red;
		}
		label {
			vertical-align:5px;padding-left:5px; padding-right:30px;
		}
		textarea {
			height:30px;
		}
		table.default td input[type="checkbox"], table.table input[type="checkbox"], .sheet_search table td input[type="checkbox"]{margin-bottom:9px;}
	</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="dataForm" name="dataForm" >
		<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
		<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
		<input type="hidden" id="searchApplYmd"	    name="searchApplYmd"	 value=""/>
		<input type="hidden" id="searchOrgCd"		name="searchOrgCd"	     value=""/>
		<input type="hidden" id="searchReqGubun"	name="searchReqGubun"	 value=""/>
		<input type="hidden" id="titleValue"		name ="titleValue"		 value=""/>
	</form>
	<div class="sheet_title">
		<ul>
			<li class="txt">신청내용</li>
			<li class="btn">
				<a href="javascript:doAction1('Search')" 	class="btn dark authR">조회</a>
				<!--  <a href="javascript:doAction1('Insert')"    class="basic authR btnIns">부서추가</a>-->
			</li>
		</ul>
	</div>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "100px"); </script>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100px"); </script>

	<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">신청상세</li>
			<!-- <li class="btn">
				<a href="javascript:addDtlTable()" 	class="basic authR btnIns">신청상세란 추가생성</a>
			</li> -->
		</ul>
	</div>
	<div style="margin-bottom:5px;">
		<table class="table">
			<colgroup>
				<col width="200px"/>
				<col width=""/>
			</colgroup>
			<tr>
				<th>제 목</th>
				<td>
					<input type="text" id="title" name="title" class="textCss required2 required w100p" style="ime-mode:active;"/>
				</td>
			</tr>
		</table>
	</div>
	<div id="dtlDiv"></div>

</div>

<div id="dtlSample" style="display:none;">
	<table class="table" id="dtlTable">
		<colgroup>
			<col width="100px" />
			<col width="100px" />
			<col width="" />
			<col width="150px" />
		</colgroup>
		<tr>
			<th colspan="2">신청사유</th>
			<td colspan="2">

				<c:choose>
					<c:when test="${etc01 == '1'}">
						<input type="hidden" id="dtlRsnOrgCd" name="dtlRsnOrgCd"/>
						<input type="hidden" id="dtlRsnJikgubCd" name="dtlRsnJikgubCd" />
						<input type="hidden" id="dtlRsnSabun" name="dtlRsnSabun" />

						<div style="margin: 0 0 5px 0;">
							<span id="span_dtlRsnOrgNm"></span>
							<span id="span_dtlRsnJikgubNm"></span>
						</div>
						<span id="span_dtlName"></span>
						<input type="text" id="dtlRsnName" name="dtlRsnName" class="${textCss} ${required} w60 ${readonly}" ${readonly} style="ime-mode:active; width: 30% !important; margin: 5px 0 5px 0;" readonly/>
						<a onclick="javascript:employeePopup('dtlRsnName');" href="#" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<span id="span_dtlRsnSabun"></span>&nbsp;
						<select id="dtlRsnGubun" name="dtlRsnGubun" class="${selectCss}" ${disabled} style="padding-top:2px; width: 30%; margin: 0 0 5px 0;">
							<c:forEach items="${rsnGubunList}" var="lst">
								<option value="${lst.code}">${lst.codeNm}</option>
							</c:forEach>
						</select>
						<input type="hidden" id="dtlRsnNote" name="dtlRsnNote" value="충원요청">
						&nbsp;으로 인한 충원
					</c:when>
					<c:otherwise>
						<textarea id="dtlRsnNote" name="dtlRsnNote" class="${textCss} w100p ${required}" ${readonly}  maxlength="1000" style="height:45px;"></textarea>
					</c:otherwise>
				</c:choose>

			</td>
			<!-- <td>
                <a href="javascript:closeDtl()" class="basic authA btnClose">신청항목 삭제</a>
            </td> -->
		</tr>
		<tr>
			<th rowspan="10">신청내용</th>
			<th>신청인원</th>
			<td colspan="2"><input type="text" id="dtlReqCnt" name="dtlReqCnt" class="${textCss} ${required} w30" ${readonly} maxlength="3" numberOnly/>&nbsp;명</td>
		</tr>
		<tr>
			<td colspan="3">※ 학력/직급/신입/경력 여부 중복선택 가능</td>
		</tr>
		<tr>
			<th>학력</th>
			<td colspan="2">
				<c:forEach items="${acaCdList}" var="lst" varStatus="status">
					<input type="checkbox" id="dtlAcaCd${status.index}" name="dtlAcaCd" value="${lst.code}" class="${radioDisabled} ${required}"/>
					<label for="dtlAcaCd${status.index}" style="padding-right: 12px;">${lst.codeNm}</label>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th>직급</th>
			<td colspan="2">
				<c:forEach items="${jikgubCdList}" var="lst" varStatus="status">
					<input type="checkbox" id="dtlJikgubCd${status.index}" name="dtlJikgubCd" value="${lst.code}" class="${radioDisabled} ${required}"/><label for="dtlJikgubCd${status.index}" style="padding-right: 12px;">${lst.codeNm}</label>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th>경력유무</th>
			<td colspan="2">
				<c:forEach items="${careerCdList}" var="lst" varStatus="status">
					<input type="checkbox" id="dtlCareerCd${status.index}" name="dtlCareerCd" value="${lst.code}" class="${radioDisabled} ${required}"/><label for="dtlCareerCd${status.index}" style="padding-right: 12px;">${lst.codeNm}</label>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<th>경력요구수준</th>
			<td colspan="2"><textarea id="dtlCareerNote" name="dtlCareerNote" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
		<tr>
			<th>전공</th>
			<td colspan="2"><textarea id="dtlAcamajNote" name="dtlAcamajNote" class="${textCss} w100p ${required}" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
		<tr>
			<th>기타필요자격</th>
			<td colspan="2"><textarea id="dtlEtcNote" name="dtlEtcNote" class="${textCss} w100p ${required}" ${readonly}  maxlength="1000"></textarea>
				<br>※ 자격증,외국어 등 기타 필요자격 사항
			</td>
		</tr>
		<tr>
			<th>직무</th>
			<td colspan="2">
				<c:forEach items="${jobCdList}" var="lst" varStatus="status">
					<input type="checkbox" id="dtlJobCd${status.index}" name="dtlJobCd" value="${lst.code}" class="${radioDisabled} ${required}"/><label for="dtlJobCd${status.index}">${lst.codeNm}</label>
				</c:forEach>
				<br>직무기술서:
				<c:forEach items="${jobCdList}" var="lst" varStatus="status">
					<input type="button" value=" ${lst.codeNm}" onClick="jobMgrPopup( '${lst.code}')" />


				</c:forEach>

				<br>※ 조직구분등록에 조직별 직무가 등록되어 있어야 합니다.
			</td>
		</tr>
		<tr>
			<th>신청일자</th>
			<td colspan="2"><input type="text" id="dtlReqYmd" name="dtlReqYmd" readonly  size="10" class="${dateCss} w80 ${required}" />
				&nbsp;&nbsp;&nbsp;※ 채용프로세스를 감안하여 진행되나 참고자료로서만 사용됩니다.
			</td>
		</tr>
		<tr>
			<th>비고</th>
			<td colspan="3"><textarea id="dtlNote" name="dtlNote" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
		</tr>
	</table>
</div>
<!-- 공통코드 레이어 팝업 -->
<%@ include file="/WEB-INF/jsp/common/include/layerPopup.jsp"%>
</body>
</html>
