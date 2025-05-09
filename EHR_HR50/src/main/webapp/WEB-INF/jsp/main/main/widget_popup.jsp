<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>ISU System</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!-- Jquery -->

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var _widgetType = "${ssnWidgetType}";

	$(function() {
		// 리스트 셋팅
		setList();
		eventInit();
		// 닫기
		$(".close").click(function() {
			clearList();
		});

		if(_widgetType == "A") {
			$("#layout01").addClass("layout01_on");
		} else if(_widgetType == "B") {
			$("#layout02").addClass("layout02_on");
		}
		$("input:radio[name='widget_type'][value='"+ _widgetType +"']").attr("checked",true);
	});
	function eventInit(){
		// ON, OFF
		$("ul.widget_group li a:not(.widget_fixed)").click(function() {
				if( $(this).hasClass("widget_on")) {
				$(this).removeClass("widget_on");
				$(this).addClass("widget_off");
				$(this).text("OFF");
			}
			else {
				$(this).removeClass("widget_off");
				$(this).addClass("widget_on");
				$(this).text("ON");
			}
		});

		// 순서변경
		$("#btn_last").click(function() {
			$("ul.widget_group li").each(function() {
				if( $(this).hasClass("on") == true) {
					$(this).insertAfter(".list:last");
					return;
				}
			});
		});
		$("#btn_next").click(function() {
			$(".list").each(function() {
				if( $(this).hasClass("on") == true) {
					$(this).insertAfter(".list:eq("+($(this).index()+1)+")");
					return;
				}
			});
		});
		$("#btn_prev").click(function() {
			$(".list").each(function() {
				if( $(this).hasClass("on") == true) {
					if( $(this).index() == 0 ) return;
					$(this).insertBefore(".list:eq("+($(this).index()-1)+")");
					return;
				}
			});
		});
		$("#btn_first").click(function() {
			$(".list").each(function() {
				if( $(this).hasClass("on") == true) {
					$(this).insertBefore(".list:first");
					return;
				}
			});
		});

		$("ul.layout_group li a").click(function(e) {
			$(this).parent().parent().find("li input").attr("checked", false);
			$(this).parent().find("input").attr("checked", true);

			$("ul.layout_group li a").each(function(idx, obj) {
				var id = $(obj).attr("id");
				if($(obj).hasClass(id+"_on")) {
					$(obj).removeClass(id+"_on");
				}
			});

			var thisId = $(this).attr("id");
			$(this).addClass(thisId+"_on");
		});
	}

	function eventUnbind(){
		$(".list").unbind("click");
		$(".list a").unbind("click");
		$("#btn_last").unbind("click");
		$("#btn_next").unbind("click");
		$("#btn_prev").unbind("click");
		$("#btn_first").unbind("click");
	}
	function setList() {
		//var opener = window.dialogArguments.list;
// 		for( var i=0;i<opener.length;i++ ) {
// 			$("<div id='"+opener[i].id+"' class='list'></div>").html(
// 					'<ul>'
// 					+'<li>'+opener[i].title+' : <span>'+opener[i].info+'</span></li>'
// 					+'<li class="right"><a  class="' + opener[i].view +'">' + opener[i].view.toUpperCase() +'</a></li>'
// 					+'</ul>'
// 			).appendTo($(".listMain"));
// 		}

		var tmp = "<li id='#TABID#' txt='#TITLE#' seq='#SEQ#'><span class='widget_title'>#TITLE#</span>";
		tmp +="<a href='#' class='widget_#VIEW#'>#VIEWUP#</a></li>";
		var str = "";

		var widgetList  = ajaxCall("${ctx}/getWidgetList.do","",false).DATA;
		for(var i = 0; i<widgetList.length; i++){
			//view 		= widgetList[i].seq==null?"off":"on";
			view 		= widgetList[i].tabOnOff;
			str = tmp.replace(/#TABID#/g,widgetList[i].tabId)
					.replace(/#TITLE#/g,widgetList[i].tabName)
					.replace(/#SEQ#/g,widgetList[i].seq)
					.replace(/#INFO#/g,widgetList[i].tabDetail)
					.replace(/#VIEW#/g,view)
					.replace(/#VIEWUP#/g,view.toUpperCase());
			$(".listMain").append(str);
		}
	}

	// 리스트 초기화
	function clearList() {
// 		var result = [];
// 		var divClass;

// 		var opener = window.dialogArguments.list;
// 		for( var i=0;i<opener.length;i++ ) {
// 			result.push({
// 				id:opener[i].id,
// 				view:opener[i].view
// 			});
// 		}

// 		window.returnValue = result;
		p.self.close();
	}

	var total = $("ul.widget_group").find("li").length;

	// 저장
	function sendValue() {
		var  widgetIds = "";
//  		var result = [];
		$("ul.widget_group").find("li").each(function(index, value) {
			if( $(this).find("a").hasClass("widget_on") || $(this).find("a").hasClass("widget_fixed")){
				//widgetIds+=$(this).attr("id")+"|";
				if ( index == total -1 ){
					widgetIds = widgetIds + ($(this).attr("id") + "|" + $(this).attr("seq"));
				}else{
					widgetIds = widgetIds + ($(this).attr("id") + "|" + $(this).attr("seq")+",");
				}
			}
		});




		var result = new Array(2);
		var saveRtn = saveWidget(widgetIds);
		if(saveRtn) result["result"] = "ok";
		else result["result"] = "fail";
// 		p.window.returnValue = result;
		if(p.popReturnValue) p.popReturnValue(result);
		p.self.close();
	}
	function saveWidget(widgetIds){
		var _widgetType = $("input:radio[name='widget_type']:checked").val();
		if( _widgetType == undefined || _widgetType == null || _widgetType == "" ) {
			_widgetType = "A";
		}
		
		var saveCnt = ajaxCall("${ctx}/saveWidget.do","widgetIds="+widgetIds+"&widgetType="+_widgetType,false);
		var cnt = Number(saveCnt.cnt);
		if( cnt > 0){ return true; }
		return false;
	}
	// 기본설정으로 하기
	function setInit() {
		eventUnbind();
// 		for( var i = 0 ; i < 12 ; i++ ) {
// 			$("#listBox"+i).appendTo( $(".listMain") );
// 			$("#listBox"+i).find("a").text("ON");
// 			$("#listBox"+i).find("a").addClass("on");
// 		}
		var tmp ="<li id='#TABID#' txt='#TITLE#'><span class='widget_title'>#TITLE#</span>";
		tmp +="<a href='#' class='widget_#VIEW#'>#VIEWUP#</a></li>";
		var str = "";
		var widgetList  = ajaxCall("${ctx}/getWidgetDefaultList.do","",false).DATA;
		$(".listMain").empty();
		for(var i = 0; i<widgetList.length; i++){
			str = tmp.replace(/#TABID#/g,widgetList[i].tabId)
					.replace(/#TITLE#/g,widgetList[i].tabName)
					.replace(/#INFO#/g,widgetList[i].tabDetail)
					.replace(/#VIEW#/g,widgetList[i].tabOnOff)
					.replace(/#VIEWUP#/g,widgetList[i].tabOnOff.toUpperCase());
			$(".listMain").append(str);
		}

		var widgetType = ajaxCall("${ctx}/getWidgetType.do", "", false).DATA;
		if(widgetType.Message != null) {
			alert(widgetType.Message);
			eventInit();
			return;
		} else {
			var type = widgetType.widgetType;
			$("input:radio[name='widget_type']").attr("checked", false);
			$("input:radio[name='widget_type']").parent().find("a").removeClass("layout01_on, layout02_on");
			if(type == 'A') {
				$("input:radio[name='widget_type'][value='" + type + "']").attr("checked", true);
				$("input:radio[name='widget_type'][value='" + type + "']").parent().find("a").addClass("layout01_on");
			} else {
				$("input:radio[name='widget_type'][value='" + type + "']").attr("checked", true);
				$("input:radio[name='widget_type'][value='" + type + "']").parent().find("a").addClass("layout02_on");
			}
		}

		eventInit();
	}

	// 미리보기
	function setPreview() {
		try{
	// 		var result = [];
	// 		$(".list").each(function() {
	// 			result.push({
	// 				id:$(this).attr("id"),
	// 				view:$(this).find("a").text().toLowerCase()
	// 			});
	// 		});
	// 		window.dialogArguments.func.call(this,result);
			var viewList = [];
			$(".list").each(function() {
				if( ($(this).find("a").text() == "ON") || ($(this).find("a").text() == "FIXED")){
					viewList.push({
							tabId:	$(this).attr("id")
						, tabName:	$(this).find("li[txt]").attr("txt")
						, tabDetail:$(this>"#info").text()
					});
				}
			});
			var da = dialogArguments;
			da.previewWidget(viewList);
		}catch(e){alert(e);};
	}
</script>

<body>

<div class="popup_widget">
	<div class="popup_title">
		<ul>
			<li>위젯 설정</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<span class="pop_line"></span>
		<p class="pop_top_txt">사용할 위젯을 <span class="f_point">On</span> / Off 버튼으로 설정해 보세요.</p>
		<%-- <div class="layout_group">
			<input type="radio" name="widget_type" value="A" style="background:url(../images/layout1_on.png) 10px 10px no-repeat;" /> 기본형 1
			&nbsp;
			<input type="radio" name="widget_type" value="B" /> 기본형 2
		</div> --%>
		<ul class="layout_group hide">
			<li>
				<input type="radio" name="widget_type" value="A" /><%--  기본형 1 --%>
				<a id="layout01" class="layout01"></a>
			</li>
			<li>
				<input type="radio" name="widget_type" value="B" /><%--  기본형 2 --%>
				<a id="layout02" class="layout02"></a>
			</li>
		</ul>

		<ul class="widget_group listMain">
		</ul>
		<div class="widget_order">
			<div style="display: none;">
				<span class="widget_order_title">순서설정</span>
				<span>각 영역안의 위젯을 선택한 후순서를 설정해 보세요.</span>
				<span class="widget_order_btn">
					<a id="btn_last" class="widget_last">맨아래</a>
					<a id="btn_next" class="widget_down">아래</a>
					<a id="btn_prev" class="widget_up">위</a>
					<a id="btn_first" class="widget_first">맨위</a>
				</span>
			</div>
		</div>
		<%-- <table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<div class="listMain">
					</div>
				</td>
			</tr>
			<tr>
				<td class="buttons">
					<div class="title">순서설정</div>
					<div id="btn_last" class="btn"><span>▼<br/>맨아래</span></div>
					<div id="btn_next" class="btn"><span>▼<br/>아래</span></div>
					<div id="btn_prev" class="btn"><span>▲<br/>위</span></div>
					<div id="btn_first" class="btn"><span>▲<br/>맨위</span></div>
					<div class="widget_info"><span>각 영역안의 위젯을 선택한 후<br />순서를 설정해 보세요.</span></div>
				</td>
			</tr>
		</table> --%>

		<div class="popup_button">
			<ul>
				<li class="center">
					<!-- a href="javascript:setPreview();" class="pink large">미리보기</a-->
					<btn:a href="javascript:sendValue();" css="btn_pointB" mid='save' mdef="저장"/>
					<btn:a href="javascript:clearList();" css="btn_baseB" mid='close' mdef="닫기"/>
				</li>
				<li class="right">
					<%-- <btn:a href="javascript:setInit();" css="widget_reset_btn" mid='111380' mdef="기본설정으로 하기"/> --%>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
