<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/common/plugin/treeSortable-master/css/treeSortable.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css" />

<script type="text/javascript">
  $(function () {
    sortable.run();
  });
</script>

<div class="hr-container target-modal p-0">
  <ul id="tree" class="tree-wrap">
    <li class="tree-branch branch-level-1" data-undefined="1" data-level="1">
        <div class="contents">
            <span class="branch-path"></span>
            <div class="branch-wrapper">
                <dl class="md-dot">
                    <dt>대표이사</dt>
                    <dd>전사 목표</dd>
                </dl>
            </div>
        </div>
        <div class="children-bus"></div>
    </li>
    <li class="tree-branch branch-level-2"  data-undefined="2" data-level="2">
        <div class="contents">
            <span class="branch-path"></span>
            <div class="branch-wrapper">
                <dl class="md-dot">
                    <dt>경영지원부문</dt>
                    <dd>네트워킹을 통한 영향력 확대</dd>
                </dl>
            </div>
        </div>
        <div class="children-bus"></div>
    </li>
    <li class="tree-branch branch-level-3 active"  data-undefined="3" data-level="3">
        <div class="contents">
            <span class="branch-path"></span>
            <div class="branch-wrapper">
                <dl class="md-dot">
                    <dt>인사총무실</dt>
                    <dd>사업성장을 위한 미래역량 확보 및 육성 1 <br>
                        사업성장을 위한 미래역량 확보 및 육성 2
                    </dd>
                </dl>
            </div>
        </div>
        <div class="children-bus"></div>
    </li>
</ul>
<ul id="tree" class="tree-wrap">
    <li class="tree-branch branch-level-1" data-undefined="1" data-level="1">
        <div class="contents">
            <span class="branch-path"></span>
            <div class="branch-wrapper">
                <dl class="difference md-dot">
                    <dt>경영지원부문</dt>
                    <dd>전략적 미래역량 확보와 업무/조직문화 개선</dd>
                </dl>
            </div>
        </div>
        <div class="children-bus"></div>
    </li>
    <li class="tree-branch branch-level-1" data-undefined="1" data-level="1">
        <div class="contents">
            <span class="branch-path"></span>
            <div class="branch-wrapper">
                <dl class="difference md-dot">
                    <dt>경영지원부문</dt>
                    <dd>안정적 사업기반 구축을 위한 재무건전성 강화</dd>
                </dl>
            </div>
        </div>
        <div class="children-bus"></div>
    </li>
    <li class="tree-branch branch-level-2 active"  data-undefined="2" data-level="2">
        <div class="contents">
            <span class="branch-path"></span>
            <div class="branch-wrapper">
                <dl class="md-dot">
                    <dt>인사총무실</dt>
                    <dd>일하는 방식의 변화 지원을 통한 업무 몰입도 제고</dd>
                </dl>
            </div>
        </div>
        <div class="children-bus"></div>
    </li>
    <li class="tree-branch branch-level-1 active" data-undefined="1" data-level="1">
        <div class="contents">
            <span class="branch-path"></span>
            <div class="branch-wrapper">
                <dl class="difference md-dot">
                    <dt>인사총무실</dt>
                    <dd>소통/공감/협력기반의 건전한 조직문화 구축</dd>
                </dl>
            </div>
        </div>
        <div class="children-bus"></div>
    </li>
</ul>
</div>

<!-- js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript" src="/common/plugin/treeSortable-master/js/treeSortable.js"></script>

<script type="text/javascript">

  // tree 
    const data = [
    {
        id: 1,
        level: 1,
        parent_id: 0,
        title: 'Branch 1'
    },
    {
        id: 2,
        level: 2,
        parent_id: 1,
        title: 'Branch 2'
    },
    {
        id: 3,
        level: 3,
        parent_id: 2,
        title: 'Branch 3'
    },
]

  const sortable =new TreeSortable({
        depth: 30,
        treeSelector:"#tree",
        branchSelector:".tree-branch",
        branchPathSelector:".branch-path",
        dragHandlerSelector:".branch-drag-handler",
        placeholderName:"sortable-placeholder",
        childrenBusSelector:".children-bus",
        levelPrefix:"branch-level",
        maxLevel: 10,
        dataAttributes: {
            id:"id",
            parent:"parent",
            level:"level",
        },
    });

    const $content = data.map(sortable.createBranch);
    $('#tree').html();
</script>