<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근무그룹관리</title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <!-- ColorPicker Plugin-->
    <link href="/common/plugin/ColorPicker/evol-colorpicker.css" rel="stylesheet" />
    <script src="/common/js/ui/1.12.1/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="/common/plugin/ColorPicker/evol-colorpicker.js" type="text/javascript"></script>

    <script type="text/javascript">


        $(function() {
            init_data();
        });

        function init_data(){
            const data = ajaxCall("${ctx}/WorkTimeGrpMgr.do?cmd=getWorkPattenMgrGrpList", $("#sheet1Form").serialize(), false);
            //공통코드 한번에 조회
            const grpCds = "T10002,T90200,T11020";
            const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", "grpCd=" + grpCds, false).codeList, "");
            const codeSplit = codeLists['T11020'][0].split("|");
            const codeSplit2 = codeLists['T10002'][0].split("|");

            if(data.Message !== '') return;

            const listContainer = document.querySelector('.list_container');


            for(let i=0; i<data.DATA.length; i++){
                let sdate = data.DATA[i].sdate.replace(/(\d{4})(\d{2})(\d{2})/g, '$1-$2-$3');
                let workNo = data.DATA[i].no;
                let titleType = codeSplit[i].substr(0,2);

                let listWrap = document.createElement('div');
                listWrap.className = 'list_wrap';

                let listItem = document.createElement('div');
                listItem.className = 'list_item';

                let content = document.createElement('div');
                content.className = 'content';

                let customSelect = document.createElement('div');
                customSelect.className = 'custom_select no_style icon btn_more'

                let selectToggle = document.createElement('button');
                selectToggle.className = 'select_toggle';

                let mdiIco = document.createElement('i');
                mdiIco.className = 'mdi-ico">more_vert';

                let selectOptions = document.createElement('div');
                selectOptions.className = 'select_options';

                let options1 = document.createElement('div');
                options1.cassName = 'option';

                let options2 = document.createElement('div');
                options2.className = 'option';

                let title = document.createElement('span');
                title.className = 'title';

                let p = document.createElement('p');
                let team = document.createElement('span');
                team.className = 'team';

                let group = document.createElement('span');
                group.className = 'group';

                let number = document.createElement('span');
                number.className = 'number';

                let workType = document.createElement('span');

                if(titleType === '시차'){
                    workType.className = 'work_type time_differ_work';
                } else if(titleType === '탄력'){
                    workType.className = 'work_type flexible_work';
                } else if(titleType === '선택'){
                    workType.className = 'work_type selective_work';
                }



                let date = document.createElement('span');
                date.className = 'date';

                listContainer.appendChild(listWrap);
                listWrap.appendChild(listItem);
                listItem.appendChild(content);
                content.appendChild(customSelect);
                customSelect.appendChild(selectToggle);
                selectToggle.appendChild(mdiIco);
                customSelect.appendChild(selectOptions);
                selectOptions.appendChild(options1);
                selectOptions.appendChild(options2);
                options1.innerText = '근무그룹수정';
                options2.innetText = '근무그룹삭제';
                content.appendChild(title);
                title.innerText = codeSplit[i];
                title.style.cursor = 'pointer';
                title.addEventListener('click', function(){
                    localStorage.setItem('grpInfo', workNo);
                    callIframe();
                });
                content.appendChild(p);
                p.appendChild(team);
                team.innerText = '근무조 6개';
                p.appendChild(group);
                group.innerText = '10개 조직';
                p.appendChild(number);
                number.innerText = '215명';
                content.appendChild(workType);


                workType.innerText = titleType + '근무';
                content.appendChild(date);
                date.innerText = sdate;

            }

        }

        function callIframe() {
            const uri = '/WorkTimeGrpMgr.do?cmd=viewWorkTimeGrpMgrTabs';
            const top = window.top;
            const name = window.name;
            if (top.parent) {
                if (typeof top.parent.submitCall != 'undefind') {
                    const form = top.parent.$('#subForm');
                    top.parent.submitCall(form, name, 'post', uri);
                }
            }
        }

    </script>
</head>
<body class="iframe_content white">
<div class="main_tab_content main_content white">
    <div class="work_group_list_wrap">
        <div class="header">
            <h3 class="table_title">
                <i class="mdi-ico filled">crisis_alert</i>
                근무그룹관리
            </h3>
            <!-- <button class="btn filled icon_text">
              <i class="mdi-ico">add</i>
              생성하기
            </button> -->
            <a href="" class="btn filled icon_text">
                <i class="mdi-ico">add</i>
                생성하기
            </a>
        </div>
        <div class="list_container"></div>
    </div>

</div>
</body>
</html>