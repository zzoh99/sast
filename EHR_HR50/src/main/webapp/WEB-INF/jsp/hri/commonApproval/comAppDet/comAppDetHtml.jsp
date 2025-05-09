<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>공통신청 세부내역</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<%--//CkEditor Setting--%>
	<script src="${ctx}/common/plugin/ckeditor5/ckeditor5-41.4.2/ckeditor.js"></script>
	<style>
		/*CkEditor Setting Style*/
		.ck-editor__editable {
			min-height: calc(580px * 0.86);
			max-height: calc(580px * 0.86);
		}
		.ck-source-editing-area textarea{
        	min-height: calc(580px * 0.86);
            max-height: calc(580px * 0.86);
            overflow:auto!important;
        }
	</style>
	<%
		Map<String, Object> editorMap = new HashMap<String, Object>();
		editorMap.put("minusHeight", "50");
		editorMap.put("formNm", "searchForm");
		editorMap.put("contentNm", "contents");
		request.setAttribute("editor", editorMap);
	%>
	<script type="text/javascript">
		//CkEditor Setting
		//getData : window.instanceEditor.getData()
		//modify(setData) : window.instanceEditor.setData()
		//save : window.instanceEditor.customMethods.save(form)

		//CKEDITOR 전역 선언
		window.top.CKEDITOR = CKEDITOR;

		var searchApplCd     = "${searchApplCd}";
		var searchApplSeq    = "${searchApplSeq}";
		var adminYn          = "${adminYn}";
		var authPg           = "${authPg}";
		var searchApplSabun  = "${searchApplSabun}";
		var searchApplInSabun= "${searchApplInSabun}";
		var searchApplYmd    = "${searchApplYmd}";
		var applStatusCd	 = "";
		var pGubun           = "";
		var gPRow = "";
		var adminRecevYn     = "N"; //수신자 여부

		$(function() {

			//----------------------------------------------------------------
			$("#searchApplCd").val(searchApplCd);
			$("#searchApplSeq").val(searchApplSeq);
			$("#searchApplSabun").val(searchApplSabun);
			$("#searchApplYmd").val(searchApplYmd);

			applStatusCd = parent.$("#applStatusCd").val();

			if(applStatusCd == "") {
				applStatusCd = "11";
			}
			//----------------------------------------------------------------

			var iframeHeight = document.body.scrollHeight;
			// 신청, 임시저장
			if(authPg == "A") {
				$("#tdContents").css("height","580px");
				$('#editContents').css("height","100%");

				//에디터
				$("#editContents").show();

				doAction("Search");

			} else if (authPg == "R") {
				$("#tdContents").css("height","auto");
				$("#viewContents").show();
				$("#ifrm1").hide();
				doAction("Search");

			}

			parent.iframeOnLoad(iframeHeight);
		});

		// Action
		function doAction(sAction) {
			switch (sAction) {
				case "Search":
					// 입력 폼 값 셋팅
					var data = ajaxCall( "${ctx}/ComAppDet.do?cmd=getComAppDet", $("#searchForm").serialize(),false);

					if ( data != null && data.DATA != null ){
						$("#title").val(data.DATA.title);
						$("#tmpContents").val(data.DATA.tmpContents);

						if(authPg == "A") {
							let contents = nvlStr(data.DATA.contents);

							//Ckeditor init modifyData
							window.modifyData = contents;
						}else{
							$("#viewContents").html(nvlStr(data.DATA.contents));
						}

					}

					break;
				case "Clear":

					let contents = nvlStr($("#tmpContents").val());
					//Ckeditor SetData
					window.instanceEditor.setData(contents)
					break;
			}
		}

		//--------------------------------------------------------------------------------
		//  저장 시 필수 입력 및 조건 체크
		//--------------------------------------------------------------------------------
		function checkList(status) {
			var ch = true;

			// 화면의 개별 입력 부분 필수값 체크
			$(".required").each(function(index){
				if($(this).val() == null || $(this).val() == ""){
					alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
					$(this).focus();
					ch =  false;
					return false;
				}

				return ch;
			});

			return ch;
		}

		//--------------------------------------------------------------------------------
		//  임시저장 및 신청 시 호출
		//--------------------------------------------------------------------------------
		function setValue(status) {
			var returnValue = false;
			try {


				if ( authPg == "R" )  {
					return true;
				}

				// 항목 체크 리스트
				if ( !checkList() ) {
					return false;
				}
				//Ckeditor SetData
				console.log(window.instanceEditor.getData())
				$("#ckEditorContentArea").val(window.instanceEditor.getData());
				// window.instanceEditor.setData(contents)

				//저장
				var data = ajaxCall("${ctx}/ComAppDet.do?cmd=saveComAppDet",$("#searchForm").serialize(),false);

				if(data.Result.Code < 1) {
					alert(data.Result.Message);
					returnValue = false;
				}else{
					returnValue = true;
				}



			} catch (ex){
				alert("Error!" + ex);
				returnValue = false;
			}

			return returnValue;
		}

		function nvlStr(pVal) {
			if (pVal == null) return "";
			return pVal;
		}
	</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form name="searchForm" id="searchForm" method="post">
		<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
		<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
		<input type="hidden" id="searchApplCd"	    name="searchApplCd"	     value=""/>
		<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
		<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
		<input type="hidden" id="searchAuthPg"		name="searchAuthPg"	     value=""/>
		<input type="hidden" id="tmpContents"		name="tmpContents"	     value=""/>
		<!-- ckEditor -->
		<input type="hidden" id="ckEditorContentArea" name="contents">


		<div class="sheet_title">
			<ul>
				<li class="txt">신청내용</li>
				<li class="btn">
					<a href="javascript:doAction('Clear')" class="btn outline-gray authA" >초기화</a>
				</li>
			</ul>
		</div>
		<table class="table hide">
			<colgroup>
				<col width="80px" />
				<col width="" />
			</colgroup>

			<tr>
				<th>제목</th>
				<td>
					<input type="text" id="title" name="title" class="${textCss}  w100p" ${readonly}/>
				</td>
			</tr>
		</table>
		<div id="tdContents" style="width:100%;margin-top:5px;height: 300px;">
			<div id="editContents" style="display:none;border:1px solid #e0e2e5;">
				<%@ include file="/WEB-INF/jsp/common/plugin/Ckeditor/include_editor.jsp"%>
			</div>
			<div id="viewContents" style="display:none;border:1px solid #e0e2e5;padding:5px;"></div>
		</div>
	</form>
</div>

</body>
</html>