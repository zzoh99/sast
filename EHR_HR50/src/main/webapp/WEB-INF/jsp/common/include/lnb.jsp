<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
    var menuOpenCnt = "${ssnLeftMenuOpenCnt}";
</script>
<nav id="lnb">
	<div class="main_menu_wrap">
		<a href="#" class="open_close_btn">
           <i class="mdi-ico">close_fullscreen</i>
        </a>
		<ul class="main_menu" id="majorMenu">
		</ul>
	</div>
	<div class="sub_menu">
        <div class="sub_menu_header">
          <a href="#" class="all"><i class="mdi-ico">add_circle</i><i class="mdi-ico minus">remove_circle</i></a>
          <a href="#"><i class="mdi-ico line_btn three">menu</i></a>
          <a href="#"><i class="mdi-ico line_btn two">drag_handle</i></a>
          <a href="#"><i class="mdi-ico line_btn one">horizontal_rule</i></a>
    
<!--           <a href="#" class="open_close_btn"> -->
<!--            <i class="mdi-ico round">arrow_back_ios_new</i> -->
<!--         	</a> -->
        </div>
        <div class="sub_menu_body"><ul id="subMenuUl"></ul></div>
	</div>
	
	<!-- 메인 메뉴 hover 시 타이틀 말풍선 표시 -->
    <span class="main_menu_hover_title"></span>
</nav>