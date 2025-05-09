<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>본인정보변경</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");

    $(function() {
    	 var arg = p.window.dialogArguments;

    	 var work_yy  = "";
         var fam_cd        = "";
         var sabun         = "";
         var adjust_type   = "";


         if( arg != undefined ) {
        	 searchWorkYy  = arg["searchWorkYy"];
        	 fam_cd        = arg["fam_cd"];
             sabun         = arg["sabun"];
             adjust_type   = arg["adjust_type"];
         }else{
        	 searchWorkYy  = p.popDialogArgument("searchWorkYy");
             fam_cd        = p.popDialogArgument("fam_cd");
             sabun         = p.popDialogArgument("sabun");
             adjust_type   = p.popDialogArgument("adjust_type");
         }
         $("#searchWorkYy").val(searchWorkYy);
         $("#fam_cd").val(fam_cd);
         $("#sabun").val(sabun);
         $("#searchAdjustType").val(adjust_type);

         doAction1("Search");
    });

    $(function(){
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD

    	var initdata1 = {};
    	initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
    	initdata1.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
    	initdata1.Cols = [
    		{Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>")  ,Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제",		Type:"<%=sDelTy%>",	Hidden:1                      ,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"<%=sSttTy%>",	Hidden:1                      ,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"관계",	   Type:"Combo",Hidden:0,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"fam_cd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"성명",	   Type:"Text",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"fam_nm",  KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",	   Type:"Text",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sabun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"주민등록번호",Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famres",	KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"최종수정자", Type:"Text",  Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"chkid",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"최종수정일", Type:"Text",  Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"chkdate",KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(0);

        //가족관계
        var famCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00309"), "");
        sheet1.SetColProperty("fam_cd", {ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );

        sheet1.SetFocusAfterProcess(0);
        $(window).smartresize(sheetResize); sheetInit();

    });

    // 조회
    function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectSelfInfo", $("#sheetForm1").serialize() );
			break;

        case "Save":
        	if( sheet1.GetCellValue(1, "sStatus") == "U" ) {
	        	if(!confirm("본인정보를 변경하시겠습니까?")){
	                break;
	            }
	        	
	        	if(sheet1.GetCellValue(1,"famres").length < 13) {
	        		alert("주민등록번호 형식(13자리)을 확인 바랍니다.");
	        		
	        		return;
	        	};
	        	
	            var params  = "searchWorkYy="+$("#searchWorkYy").val();
	                params += "&searchAdjustType="+$("#searchAdjustType").val();
	                params += "&fam_cd="+$("#fam_cd").val();
	                params += "&sabun="+$("#sabun").val();

	            sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=saveSelfInfo", params);
	            break;
        	}
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				sheetResize();
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
    //저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if(Code == 1) {
            	faqPopupClose();
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
	// 닫기
    function faqPopupClose() {
		var returnValue = "";
		if(p.popReturnValue) p.popReturnValue(returnValue);
    	p.self.close();
    }

</script>

<style type="text/css">
    div.explain {margin: 0px !important;}
	.popup_main TABLE,TH,TD {margin: 0px; padding: 0px; border: 0px; font-size: 12px;}

</style>

</head>

<body class="bodywrap">
<form id="sheetForm1" name="sheetForm1" >
<input type="hidden" id="searchWorkYy" name="searchWorkYy" value=""/>
<input type="hidden" id="searchAdjustType" name="searchAdjustType" value=""/>
<input type="hidden" id="searchValue" name="searchValue" value="1"/>
<input type="hidden" id="searchCdValue" name="searchCdValue" value="1"/>
<input type="hidden" id="fam_cd" name="fam_cd" value=""/>
<input type="hidden" id="sabun" name="sabun" value=""/>


<input type="hidden" id="menuNm" name="menuNm" value="" />
	<div class="wrapper">
		<div class="popup_title">
		     <ul>
		         <li id="strTitle">본인정보변경</li>
		     </ul>
	    </div>
		<div class="outer popup_main">
			</form>
			<div class="outer" >
				<table border="0" cellspacing="0" cellpadding="0"  class="sheet_main">
					<tr>
						<td>
							<div class="sheet_title">
								<ul>
									<li class="txt">본인정보변경</li>
									<li class="btn"><span><a href="javascript:doAction1('Save');" class="basic btn-save" >저장</a></span></li>
								</ul>
							</div>
						</td>
					</tr>
					<tr>
						<td>
							<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
						</td>
					</tr>
				</table>
		      	 <div class="popup_button"  style="clear: both;">
		         	 <ul>
		             	 <li><a href="javascript:faqPopupClose();" class="gray large">닫기</a></li>
		         	 </ul>
			   	</div>
			</div>
       </div>
	</div>

</body>
</html>