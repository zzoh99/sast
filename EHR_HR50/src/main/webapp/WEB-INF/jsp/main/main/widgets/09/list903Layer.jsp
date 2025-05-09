<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
    <%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
    <script type="text/javascript">
        var list903Layer = {id:'list903Layer'};
        $(function() {

        })
    </script>
    <style>
        #myModal {
            position: fixed;
            top: 50%;
            left: 50%;
            width: 100%;
            height: auto;
            transform: translate(-50%, -50%);
            background-color: #fff;
        }
        #myModal .modal-header{display:flex; align-items: center; padding:10px 18px; background-color:#2570f9; color:#ffffff; font-size: 14px;font-weight: bold;}
        #myModal .modal-header .btn-close{margin-left:auto;  color:#ffffff; background-color: transparent;}
        #myModal .modal-body{position:relative; padding: 118px 84px 150px 152px;}
        #myModal .modal-body .img-wrap{position:absolute; top: 110px; left: 44px;}
        #myModal .modal-body .img-wrap img{width:88px; height: auto;}
        #myModal .modal-body .modal-title{font-size: 28px; font-weight: 800; line-height: 1.43; text-align: left; color: #000;}
        #myModal .modal-body .modal-list{margin-top: 56px;}
        #myModal .modal-body .modal-list li{margin-top: 24px;}
        #myModal .modal-body .modal-list li:first-childe{margin-top: 0px;}
        #myModal .modal-body .modal-list li .label{display:inline-block; width:52px; margin-right:12px; font-size: 14px;font-weight: bold;line-height: 1.71;color: #000;}
        #myModal .modal-body .modal-list li .desc{position:relative; padding-left:24px; font-size: 14px; font-weight: 400; line-height: 1.71;color: #666;}
        #myModal .modal-body .modal-list li .desc::before{content:''; position: absolute; top:2px; left:0px; display:inline-block; width:1px; height:16px; background-color: #c7c7c7;}

    </style>
</head>
<body class="bodywrap ">
<div id="myModal" class="wrapper modal_layer">
    <div class="modal-body">
        <div class="modal-title">직원들의 리프레쉬를위해<br>회사에서 은혜적으로 부여하는 휴가입니다</div>
        <div class="img-wrap">
            <img src="/common/images/widget/widget_condolence_2x.png" alt="">
        </div>
        <ul class="modal-list">
            <li><span class="label">대상</span><span class="desc">매년 9월 기준 근속연수 1년 이상 근로자</span></li>
            <li><span class="label">기간</span><span class="desc">4일 (유급, 단PT의 경우 근무시간에 비례해서 지급)</span></li>
            <li><span class="label">신청방법</span><span class="desc">WFS(하기 링크) 접속 🡪 ‘휴무’🡪 ‘내 휴무‘ 🡪 ‘새 요청생성‘ 🡪 “리프레쉬</span></li>
            <li><span class="label">필요서류</span><span class="desc">불필요</span></li>
        </ul>
    </div>
    <div class="modal_footer">
        <btn:a href="javascript:closeCommonLayer('list903Layer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
    </div>
</div>
</body>
</html>
