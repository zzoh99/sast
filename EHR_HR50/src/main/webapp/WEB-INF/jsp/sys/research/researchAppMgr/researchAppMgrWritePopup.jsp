<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<title><tit:txt mid='112573' mdef='설문지 상세 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var researchSeq	= null;

var fileSeq = null;
var memo  = null;

var research 	= null;
var p = eval("${popUpStatus}");
$(function(){
	var arg = p.popDialogArgumentAll();
	researchSeq = arg["researchSeq"];
	memo = arg["memo"];
	fileSeq = arg["fileSeq"];
	$("#memo").val(memo);
	$("#researchSeq").val(researchSeq);
	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});

	var initdata = {};
	initdata.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:0,ColResize:0,HeaderCheck:0};

	initdata.Cols = [
		
		{Header:"No",			Type:"${sNoTy}",  Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"상태",			Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0},
		{Header:"설문지순번",		Type:"Text",      Hidden:1,	Width:40 ,  Align:"Left", ColMerge:1,   SaveName:"researchSeq",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"질문순번",		Type:"Text",      Hidden:1,	Width:40 ,  Align:"Left", ColMerge:1,   SaveName:"questionSeq",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"질문유형",		Type:"Text",      Hidden:1,	Width:40 ,  Align:"Left", ColMerge:1,   SaveName:"questionItemCd",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"답변순번",		Type:"Text",      Hidden:1,	Width:60 ,  Align:"Left", ColMerge:1,   SaveName:"answerSeq",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		
		{Header:"제목",			Type:"Text",      Hidden:0,	Width:200 , Align:"Left", ColMerge:1,   SaveName:"questionNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:400 },
		{Header:"작성내용",		Type:"Text",      Hidden:0,	Width:600 , Align:"Left", ColMerge:1,   SaveName:"answer",			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 }
	];
	IBS_InitSheet(sheet1, initdata);
	sheet1.SetEditable("${editable}");
	sheet1.SetVisible(true);
	sheet1.SetCountPosition(4);
	sheet1.SetUnicodeByte(3);

	$(window).smartresize(sheetResize);
	sheetInit();
	doAction1("Search");
});


function doAction1(sAction){
    switch(sAction){
        case "Search":      //조회
        	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getResearchAppWriteList", $("#form").serialize() );
            break;
        case "Save":
        	if(confirm("저장하시겠습니까?"))
			{
        		makeSendData();          	//sheet Type를 Text로 변환하고 값을 변경
    			IBS_SaveName(document.form,sheet1);
    			sheet1.DoSave( "${ctx}/ResearchApp.do?cmd=saveResearchAppWrite", $("#form").serialize(),-1,0); 
			}
        	break;
        case "Down2Excel":	sheet1.Down2Excel(); 
        	break;
    }
}
	

function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
	try{
		
		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){

            var questionItemCd = sheet1.GetCellValue(i, "questionItemCd");
			//설문일때 
            if (questionItemCd == "10"){
            	//설문일때 설문 내용을 조회 TSYS605 
            	var question = ajaxCall("${ctx}/ResearchApp.do?cmd=getResearchAppQuestionList","researchSeq="+sheet1.GetCellValue(i, "researchSeq")+"&questionSeq="+ sheet1.GetCellValue(i, "questionSeq"),false);
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
    			
    	        var info = {Type: "CheckBox", Align: "Left", ItemText: ItemText, ItemCode: ItemCode, MaxCheck: 1, RadioIcon: 1,ShowMobile: 0};
    			sheet1.InitCellProperty( i,"answer" ,info);
    			
    			if(tempValue != -1)
    			{
    				sheet1.SetCellValue(i, "answer",question[tempValue].answer);
    			}
            }
         }
	    if (ErrMsg != ""){
	        alert(ErrMsg) ;
	    }
	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
}

// 저장 후 메시지
 /* function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { alert(Msg); }
		var returnValue = new Array(2);
		returnValue["result"] 	= "ok";
		
		p.popReturnValue(returnValue);
        p.window.close();
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
} */ 

 function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
        p.window.close();
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
} 
	
//CheckBox로 되어있는 'answer' sheet를 Text로 변환
function makeSendData(){
	for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
		var questionItemCd = sheet1.GetCellValue(i, "questionItemCd");
        if (questionItemCd == "10"){
			var tempAnswer = sheet1.GetCellValue(i, "answer").split('|');
			for(var j=0; j < tempAnswer.length; j++)
			{
				var tempAnswerValue = tempAnswer[j].split(':');
				if(tempAnswerValue[1] == 1)
				{
					var info = {Type: "Text", Align: "Left"};
	    			sheet1.InitCellProperty( i,"answer" ,info);
					sheet1.SetCellValue(i, "answer",tempAnswerValue[0]);
				}
			}
        }
	}
}

function downloadbtn() {
	try{
			var param = [];
			param["fileSeq"] = fileSeq;
			if(!isPopup()) {return;}

				pGubun = "fileMgrPopup";

				var authPgTemp="R";
				var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp, param, "740","620");
		
	}catch(ex){alert("OnClick Event Error : " + ex);}
}


//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');
}

</script>
</head>
<body class=bodywrap>
<div class="wrapper">
	<form id="form" name="form" >
		<input id="researchSeq" name="researchSeq"  type="hidden"/>
		<input id="sendData" 	name="sendData" 	type="hidden"/>
	</form>
	<div class="popup_main">
		<table class="sheet_main">
			<tr>
			 <td>
			 	<div class="sheet_title">
			 	<ul>
			 	<li id="txt" class="txt">설문조사 설명</li>
			 	</div>
				<textarea id="memo" name="memo" rows="3" class="readonly" style="width:100%;" readonly></textarea>
				 </ul>
			</td> 
			</tr>
			<tr>
				<td>
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">설문조사</li>
								<li class="btn">
								<btn:a href="javascript:downloadbtn();" css="basic authR" mid='download' mdef="설문조사 첨부파일 다운로드"/>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "70%", "70%","kr"); </script>
				</td>
			</tr>
		</table>
		<%-- <div>
			<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
		</div> --%>
		
		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:doAction1('Save');" css="pink large" mid='ok' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>

</html>
