<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<style>
	.member_search_wrap {
		position: absolute;
		height:50px !important;
		font-size:12px;
		z-index:30;
		letter-spacing: 0px !important;
		text-align:center;
	}
	.member_search_wrap h1>a {
		display: block;
		position:relative;
		top: 0px;
		cursor: pointer;
	}
	.member_search_wrap .member_search {
		float: left;
		position: absolute;
		margin: 0px 0px 0px 0px;
		width:97%;
	}
	.member_search_wrap .member_search input {
		position:relative;
		box-sizing: border-box;
		border: 1px solid #e3e7ea;
		border-radius: 50px;
		width: 100%;
		padding: 8px 15px;
		color: #95999c;
		font-size: 12px;
		outline: none;
		z-index:31;
	}
	.member_search_wrap .member_search a { display: inline-block; position:absolute; right: 15px; top: 9px; z-index:32; }
	.member_search_wrap .pointer { cursor:pointer;}
</style>
<script type="text/javascript">
	function main_listBox25(title, info , classNm, seq ){
		
		var widgetContent25;
		$("#listBox25").attr("seq", seq);
	
		if ( classNm == undefined || classNm == null || classNm == "undefined" || classNm== "null" || classNm == ""){
			classNm = "box_100";
		}
	
		$("#listBox25").removeClass();
	
		// classNm 1. box_250 , box_400 , box_100
		if(classNm == "box_250"){
			
			widgetContent25 = '<h3 class="main_title_250">키워드검색</h3>'
							+ "<div class='member_search_wrap' style='top:130px; left:25px; width:210px;'>"
							+	"<div class='member_search'>"
							+		"<input type='text' id='searchKeyword' name='searchKeyword' placeholder='검색어를 입력하세요.'>"
							+		"<a class='pointer' href='javascript:doPopup()'><img id='searchUser' src='/common/images/main/btn_search.png' alt='검색하기' style='z-index:999'></a>"
							+	"</div>"
							+ "</div>";
							
		}else if(classNm == "box_400"){
			
			widgetContent25 = '<h3 class="main_title_400">키워드검색</h3>'
							+ "<div class='member_search_wrap' style='top:130px; left:25px; width:210px;'>"
							+	"<div class='member_search'>"
							+		"<input type='text' id='searchKeyword' name='searchKeyword' placeholder='검색어를 입력하세요.'>"
							+		"<a class='pointer' href='javascript:doPopup()'><img id='searchUser' src='/common/images/main/btn_search.png' alt='검색하기' style='z-index:999'></a>"
							+	"</div>"
							+ "</div>";
							
		}else{
			
			widgetContent25 = '<h3 class="main_title_100 img_100_holiday">키워드검색</h3>'
							+ "<div class='member_search_wrap' style='top:30px; left:250px; width:550px;'>"
							+	"<div class='member_search'>"
							+		"<input type='text' id='searchKeyword' name='searchKeyword' placeholder='검색어를 입력하세요.'>"
							+		"<a class='pointer' href='javascript:doPopup()'><img id='searchUser' src='/common/images/main/btn_search.png' alt='검색하기' style='z-index:999'></a>"
							+	"</div>"
							+ "</div>";
							
		}
	
		//alert("classNm  :" + classNm );
		$("#listBox25").addClass(classNm);
		$("#listBox25 > .anchor_of_widget").html(widgetContent25);
	
		$("#searchKeyword").click(function(){
			$(this).focus();
		});
		
		$("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
				$(this).blur();
				if(!isPopup()) {return;}
				var args 	= new Array();
				args["searchKeyword"] = $(this).val();
				openPopup("/Popup.do?cmd=keywordPopup&authPg=R", args, "1300","900");
			}
		});
	}
</script>

<div class="box_250 notice_box" id="listBox25" lv="5" info="키워드 검색" >
	<div class="anchor_of_widget">
	</div>
</div>