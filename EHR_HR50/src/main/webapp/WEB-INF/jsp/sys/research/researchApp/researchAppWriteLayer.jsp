<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<title><tit:txt mid='112573' mdef='설문지 상세 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<script type="text/javascript">
	var researchSeq	= null;
	var fileSeq = null;
	var memo  = null;
	var research 	= null;

	$(function(){
		createIBSheet3(document.getElementById('researchAppWriteLayerSheet-wrap'), "researchAppWriteLayerSheet", "100%", "100%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('researchAppWriteLayer');
		researchSeq = modal.parameters.researchSeq || '';
		memo = modal.parameters.memo || '';
		fileSeq = modal.parameters.fileSeq || '';

		$("#memo").val(memo);
		$("#researchSeq").val(researchSeq);

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0},
			{Header:"<sht:txt mid='researchSeq' mdef='설문지순번'/>",		Type:"Text",	  Hidden:1,	Width:40 ,  Align:"Left", ColMerge:1,   SaveName:"researchSeq",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='questionSeq' mdef='질문순번'/>",		Type:"Text",	  Hidden:1,	Width:40 ,  Align:"Left", ColMerge:1,   SaveName:"questionSeq",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='itemCdNm' mdef='질문유형'/>",		Type:"Text",	  Hidden:1,	Width:40 ,  Align:"Left", ColMerge:1,   SaveName:"questionItemCd",	KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='202005180000080' mdef='답변순번'/>",		Type:"Text",	  Hidden:1,	Width:60 ,  Align:"Left", ColMerge:1,   SaveName:"answerSeq",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },

			{Header:"<sht:txt mid='title' mdef='상태'/>",			Type:"Text",	  Hidden:0,	Width:250 , Align:"Left", ColMerge:1,   SaveName:"questionNm",		KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:400 },
			{Header:"<sht:txt mid='202005180000081' mdef='작성내용'/>",		Type:"Text",	  Hidden:0,	Width:500 , Align:"Left", ColMerge:1,   SaveName:"answer",			KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 }
		];
		IBS_InitSheet(researchAppWriteLayerSheet, initdata);
		researchAppWriteLayerSheet.SetEditable("${editable}");
		researchAppWriteLayerSheet.SetVisible(true);
		researchAppWriteLayerSheet.SetCountPosition(4);
		researchAppWriteLayerSheet.SetUnicodeByte(3);

		var sheetHeight = $(".modal_body").height() - ($(".sheet_title").height() * 2) - $('#memo').height() - 10;
		researchAppWriteLayerSheet.SetSheetHeight(sheetHeight);

		doAction1("Search");
	});


	// 시트 리사이즈
	function sheetResize() {
		var outer_height = getOuterHeight();
		var inner_height = 0;
		var value = 0;

		$(".ibsheet").each(function() {
			inner_height = getInnerHeight($(this));
			if ($(this).attr("fixed") == "false") {
				value = parseInt(($(window).height() - outer_height) / $(this).attr("sheet_count") - inner_height);
				if (value < 100) {
					value = 100;
				} else {
					value -= 100;
				}
				$(this).height(value);
			}
		});

		clearTimeout(timeout);
		timeout = setTimeout(addTimeOut, 50);
	}


	function doAction1(sAction){
		switch(sAction){
			case "Search":	  //조회
				researchAppWriteLayerSheet.DoSearch( "${ctx}/ResearchApp.do?cmd=getResearchAppWriteList", $("#form").serialize() );
				sheetResize();
				break;
			case "Save":
				if(confirm("저장하시겠습니까?"))
				{
					makeSendData();		  	//sheet Type를 Text로 변환하고 값을 변경
					IBS_SaveName(document.form,researchAppWriteLayerSheet);
					researchAppWriteLayerSheet.DoSave( "${ctx}/ResearchApp.do?cmd=saveResearchAppWrite", $("#form").serialize(),-1,0);
				}
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(researchAppWriteLayerSheet);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				researchAppWriteLayerSheet.Down2Excel(param);
				break;
		}
	}


	function researchAppWriteLayerSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{

			for(var i = researchAppWriteLayerSheet.HeaderRows(); i<researchAppWriteLayerSheet.RowCount()+researchAppWriteLayerSheet.HeaderRows(); i++){

				var questionItemCd = researchAppWriteLayerSheet.GetCellValue(i, "questionItemCd");
				//설문일때
				if (questionItemCd == "10" || questionItemCd == "20"){
					//설문일때 설문 내용을 조회 TSYS605
					var question = ajaxCall("${ctx}/ResearchApp.do?cmd=getResearchAppQuestionList","researchSeq="+researchAppWriteLayerSheet.GetCellValue(i, "researchSeq")+"&questionSeq="+ researchAppWriteLayerSheet.GetCellValue(i, "questionSeq"),false);
					if( null == question)return;
					if(null == question.DATA || question.DATA.length < 1) return;
					question = question.DATA;

					var ItemText ="";
					var ItemCode ="";
					var tempValue =-1;

					for(var j=0; j < question.length; j++){
						//박스 생성
						ItemText += question[j].itemNm;
						ItemCode += question[j].itemSeq;

						if(j+1 != question.length)
						{
							ItemText += "|";
							ItemCode += "|";
						}
						if(question[j].answer != '')
						{
							tempValue = j;
						}
					}

					var info = {Type: "CheckBox", Align: "Left", ItemText: ItemText, ItemCode: ItemCode, MaxCheck: questionItemCd == "20" ? 99 : 1, RadioIcon: 1,ShowMobile: 0};
					researchAppWriteLayerSheet.InitCellProperty( i,"answer" ,info);

					if(tempValue != -1)
					{
						researchAppWriteLayerSheet.SetCellValue(i, "answer", question[tempValue].answer+'|');
					}
				}
			 }
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	 function researchAppWriteLayerSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			var modal = window.top.document.LayerModalUtility.getModal('researchAppWriteLayer');
			modal.hide();
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	//CheckBox로 되어있는 'answer' sheet를 Text로 변환
	function makeSendData(){
		for(var i = researchAppWriteLayerSheet.HeaderRows(); i<researchAppWriteLayerSheet.RowCount()+researchAppWriteLayerSheet.HeaderRows(); i++){
			var questionItemCd = researchAppWriteLayerSheet.GetCellValue(i, "questionItemCd");
			if (questionItemCd == "10"){
				var tempAnswer = researchAppWriteLayerSheet.GetCellValue(i, "answer").split('|');
				for(var j=0; j < tempAnswer.length; j++)
				{
					var tempAnswerValue = tempAnswer[j].split(':');
					if(tempAnswerValue[1] == 1)
					{
						var info = {Type: "Text", Align: "Left"};
						researchAppWriteLayerSheet.InitCellProperty( i,"answer" ,info);
						researchAppWriteLayerSheet.SetCellValue(i, "answer",tempAnswerValue[0]);
					}
				}
			}
		}
	}

	function downloadbtn() {
		try{
			if(!isPopup()) {return;}

			var p = {
				fileSeq : fileSeq
			};

			pGubun = "fileMgrPopup";

			var w = 740;
			var h = 420;
			var url = "/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=R";
			// openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg=R", param, "740","620");

			let layerModal = new window.top.document.LayerModal({
				id : 'fileMgrLayer'
				, url : url
				, parameters : p
				, width : w
				, height : h
				, title : '파일 업로드'
				, trigger :[
					{
						name : 'fileMgrTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			layerModal.show();

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}


	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		// var rv = $.parseJSON('{' + returnValue+ '}');
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<form id="form" name="form" >
		<input id="researchSeq" name="researchSeq"  type="hidden"/>
		<input id="sendData" 	name="sendData" 	type="hidden"/>
	</form>
	<div class="modal_body">
		<table class="sheet_main">
			<tr>
			 <td>
			 	<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='113663' mdef='설문조사 설명 '/></li>
					</ul>
			 	</div>
				<textarea id="memo" name="memo" rows="3" class="readonly" style="width:100%;" readonly></textarea>
			</td>
			</tr>
			<tr>
				<td>
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='survey' mdef='설문조사'/></li>
								<li class="btn">
								<btn:a href="javascript:downloadbtn();" css="btn outline-gray authR" mid='download' mdef="설문조사 첨부파일 다운로드"/>
								<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='download' mdef="엑셀 다운로드"/>
								</li>
							</ul>
						</div>
					</div>
<%--					<script type="text/javascript">createIBSheet("researchAppWriteLayerSheet", "100%", "100%","kr"); </script>--%>
					<div id="researchAppWriteLayerSheet-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('researchAppWriteLayer');" css="btn outline_gray" mid='close' mdef="닫기"/>
		<btn:a href="javascript:doAction1('Save');" css="btn filled" mid='ok' mdef="확인"/>
	</div>
</div>
</body>

</html>
