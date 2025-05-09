<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head><title><tit:txt mid='112371' mdef='도움말 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	var p = eval("${popUpStatus}");
	var arg = p.window.dialogArguments;

	$(function() {
		$(".close").click(function() {
			p.self.close();
		});
		
		$(".ib_product1").css("height", "120px");

	    var surl = "";

		if( arg != undefined ) {
			surl = arg["surl"];
		}else{
	    	if(p.popDialogArgument("surl")!=null)		surl  	= p.popDialogArgument("surl");
	    }
		$("#surl").val(surl);

		doSearch();
	});

	function doSearch(){
		try{
			var data = ajaxCall("${ctx}/HelpPopup.do?cmd=getHelpPopupMap",$("#srchFrm").serialize(),false);

			if(data.map == null){
			} else {
				$("#spanMenuNm").html( nvlStr(data.map.menuNm) );
				$("#fileSeq").val(data.map.fileSeq);
				$("#prgCd").val(data.map.prgCd);

				var helpType = "";
				var helpContent = "";
				if ( "${ssnDataRwType}" == "A" ) {
					helpType = "담당자용";
					$("#btnUpdate").show();

					if ( data.map.mgrHelpYn == "Y" ) {
						helpContent = nvlStr(data.map.mgrHelp);
					}
				} else {
					helpType = "직원용";
					$("#btnUpdate").hide();

					if ( data.map.empHelpYn == "Y" ) {
						helpContent = nvlStr(data.map.empHelp);
					}
				}

				$("#spanHelpType").html( helpType );
				$("#spanHelpContent").html( helpContent );
			}

			if ( $("#spanHelpContent").html() == "" ) {
				$("#btnDownLoad").hide();
			} else {
				$("#btnDownLoad").show();
			}

			upLoadInit($("#fileSeq").val(),"${hrm}");
			//첨부파일 버튼 숨김
			$('.btn table').hide();

		}catch(e){
			alert("doSearch Error:" + e);
		}
	}

	function doDownLoad() {
		var fileName = $("#spanMenuNm").html() + "_" + $("#spanHelpType").html() + "_도움말.html";
		var content = $('#spanHelpContent').html();

		$("#tmpFrm").remove();
		var $frm = $('<form id=tmpFrm></form>');
		$frm.attr('action', '${ctx}/HelpPopup.do?cmd=viewHelpPopupDown');
		$frm.attr('method', 'post');
		//$frm.attr('target', 'iFrm');
		$frm.appendTo('body').append("<textarea name='fileName' style='display:none;'>"+ fileName +"</textarea>");
		$frm.appendTo('body').append("<textarea name='content' style='display:none;'>"+ content +"</textarea>");
		$frm.submit();
	}

	function doUpdate() {
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "viewMainMuPrgPop";

		var args = new Array();
		args["prgCd"]	= $("#prgCd").val();
		args["menuNm"]	= $("#spanMenuNm").html();
		openPopup("${ctx}/MainMuPrg.do?cmd=viewMainMuPrgPop&authPg=A", args, "940","520");
		/*
		if(rv!=null){
			doSearch();
		}
		*/
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "viewMainMuPrgPop"){
			if(rv!=null){
				doSearch();
			}
		}
	}

	function nvlStr(pVal) {
		if (pVal == null) return "";
		return pVal;
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><span id="spanMenuNm"></span> 도움말</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="srchFrm" name="srchFrm" tabindex="1">
		<input type=hidden id="surl"	name="surl" value=""/>
		<input type=hidden id="prgCd"				name="prgCd" value=""/>
		<input type=hidden id="fileSeq"				name="fileSeq" />
		</form>

		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><span id="spanHelpType" style="font-weight:bold;"></span> 도움말</li>
					<li class="btn">
						<a href="javascript:doDownLoad();" class="button" id="btnDownLoad"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
			</div>
		</div>
		<div class="bd_solid pad10">
			<div id="spanHelpContent" class="overflow_auto w100p h300 ma-y-5"></div>
		</div>
		<div  style="clear:both;overflow:hidden;" >
			<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
		</div>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:doUpdate();" class="pink large" id="btnUpdate"><tit:txt mid='112696' mdef='수정'/></a>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>



