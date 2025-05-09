<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script>
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('changeApprovalLineLayer');
		var parameters =  modal.parameters;
	});
    
    $(document).ready(function() {

    	// 결재자변경 내부 탭
        $(".approval_select .tab_container .tab").click(function () {
            var $container = $(this).closest(".tab_container")
            var $bankForm = $(this).closest(".approval_select")
            $container.find(".tab").removeClass("active")
            $(this).addClass("active")
            var tabId = $(this).data("tab")
            $bankForm.find(".tab_content").removeClass("active")
            $bankForm.find("#" + tabId).addClass("active")
        })
        
        // 트리 컨트롤
	    $('.tree_container .tree_toggle').click(function(e) {
	        e.stopPropagation();
	        $(this).closest('li').toggleClass('collapsed');
	    });
	    $('.tree_container .tree_item').click(function(e) {
	        e.stopPropagation();
	        const $li = $(this).closest('li');
	        
	        if ($li.find('> ul').length > 0) {
	            $li.toggleClass('collapsed');
	        } else {
	            $('.tree_container .tree_item').removeClass('active');
	            $(this).addClass('active');
	        }
	    });
	    $('.tree_top .mdi-ico').click(function() {
	        const iconIndex = $(this).index();
	        const $tree = $(this).closest('.card').find('.tree');
	        
	        switch(iconIndex) {
	            case 0:
	                $tree.find('li').removeClass('collapsed');
	                break;
	            case 1:
	                $tree.find('li').addClass('collapsed');
	                break;
	            case 2:
	                $tree.find('li').addClass('collapsed'); 
	                $tree.find('> li').removeClass('collapsed');
	                $tree.find('> li > ul > li').removeClass('collapsed');
	            break;
	            case 3:
	                $tree.find('li').addClass('collapsed');
	                $tree.find('> li').removeClass('collapsed');
	                break;
	        }
	    });
});
</script>
<div class="wrapper modal_layer ux_wrapper">
    <div class="modal_body approval_select">
        <div class="tab_container ma-auto mb-16 w-164">
            <ul>
                <li>
                    <button class="tab active" data-tab="tab1">조직도</button>
                </li>
                <li>
                    <button class="tab" data-tab="tab2">검색</button>
                </li>
            </ul>
        </div>

        <!-- 컨텐츠 -->
        <div class="d-flex gap-16">
            <div class="tab_content active" id="tab1">
                <div class="d-flex gap-16 approval_tab_1">
                    <div class="card rounded-12 pa-8">
                        <div class="tree_top">
                            <i class="mdi-ico">add_circle</i>
                            <i class="mdi-ico">remove_circle</i>
                            <i class="mdi-ico">drag_handle</i>
                            <i class="mdi-ico">remove</i>
                        </div>
                        <div class="tree_container">
                            <ul class="tree">
                                <li>
                                    <div class="tree_item">
                                        <i class="mdi-ico tree_toggle"></i>
                                        <span>이수시스템</span>
                                    </div>
                                    <ul>
                                        <li>
                                            <div class="tree_item">
                                                <i class="mdi-ico tree_toggle"></i>
                                                <span>대표이사</span>
                                            </div>
                                            <ul>
                                                <li>
                                                    <div class="tree_item">
                                                        <i class="mdi-ico tree_toggle"></i>
                                                        <span>디지털사업본부</span>
                                                    </div>
                                                    <ul>
                                                        <li>
                                                            <div class="tree_item">
                                                                <i class="mdi-ico tree_toggle"></i>
                                                                <span>김유진</span>
                                                            </div>
                                                        </li>
                                                        <li>
                                                            <div class="tree_item">
                                                                <i class="mdi-ico tree_toggle"></i>
                                                                <span>김유진</span>
                                                            </div>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li>
                                                    <div class="tree_item">
                                                        <i class="mdi-ico tree_toggle"></i>
                                                        <span>디지털사업본부</span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </li>
                                        <li>
                                            <div class="tree_item">
                                                <i class="mdi-ico tree_toggle"></i>
                                                <span>대표이사</span>
                                            </div>
                                            <ul>
                                                <li>
                                                    <div class="tree_item">
                                                        <i class="mdi-ico tree_toggle"></i>
                                                        <span>디지털사업본부</span>
                                                    </div>
                                                </li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="card rounded-0 bg-white pa-0">
                        <p class="txt_body_sm txt_secondary mb-8">*선택 후 하단에서 추가버튼을 눌러주세요</p>
                        <div class="scroll_table_wrap fixed_h approval_list_table">
                            <table class="custom_table">
                                <thead>
                                    <tr>
                                        <th>No</th>
                                        <th>선택</th>
                                        <th>성명</th>
                                        <th>부서</th>
                                        <th>직책</th>
                                        <th>직위</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>Saas서비스팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex gap-8 all-flex-1 py-24-16 bd-t-c-1">
                            <button class="btn outline">결재자 추가</button>
                            <button class="btn outline">담당자 추가</button>
                            <button class="btn outline">참조자 추가</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="tab_content flex-1" id="tab2">
                <div class="approval_tab_2">
                    <div class="input_search_wrap mb-20">
                        <input id="searchKeyword" name="searchKeyword" type="text" class="input_text w-320" placeholder="성명 또는 소속으로 검색해주세요" />
                        <span class="material-icons-outlined cancel_btn">cancel</span>
                        <span class="material-icons-outlined txt_tertiary">search</span>
                    </div>

                    <div class="card rounded-0 bg-white pa-0">
                        <!-- <div class="d-flex flex-col gap-8 align-center">
                            <i class="icon no_user size-100"></i>
                            <p class="txt_body_sm txt_tertiary">검색결과가 없습니다.</p>
                        </div> -->
                        <p class="txt_body_sm txt_secondary mb-8">*선택 후 하단에서 추가버튼을 눌러주세요</p>
                        <div class="scroll_table_wrap fixed_h approval_list_table">
                            <table class="custom_table">
                                <thead>
                                    <tr>
                                        <th>No</th>
                                        <th>선택</th>
                                        <th>성명</th>
                                        <th>부서</th>
                                        <th>직책</th>
                                        <th>직위</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>Saas서비스팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                    <tr>
                                        <td>1</td>
                                        <td>
                                            <input type="checkbox" class="form-checkbox" id="checkbox1" />
                                        </td>
                                        <td>김이수</td>
                                        <td>솔루션개발팀</td>
                                        <td>대리</td>
                                        <td>차장</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="d-flex gap-8 all-flex-1 py-24-16 bd-t-c-1">
                            <button class="btn outline">결재자 추가</button>
                            <button class="btn outline">담당자 추가</button>
                            <button class="btn outline">참조자 추가</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 하단 버튼 영역 (.footer)가 안보여야 하는 경우에는 .footer_fixed 클래스 제거 + div.footer 제거 -->
            <div class="card pa-0 rounded-12 d-flex flex-col justify-between pt-20 w-386 min-w-386">
                <div class="px-12">
                    <p class="txt_body_sm txt_secondary d-flex align-center gap-4 mb-10">
                        <i class="mdi-ico txt_18">drag_handle</i>
                        드래그 버튼을 클릭하여 순서를 변경할 수 있습니다.
                    </p>

                    <div>
                        <div class="mb-24">
                            <div class="card bg-dark-gray rounded-8 pa-8 mb-8">
                                <p class="txt_body_sm sb">결재자</p>
                            </div>
                            <div class="d-flex flex-col gap-8">
                                <!-- <div class="h-84 d-flex flex-col justify-between align-center">
                                    <i class="icon no_user"></i>
                                    <p class="txt_body_sm txt_tertiary">결재자를 선택해주세요</p>
                                </div> -->
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mb-24">
                            <div class="card bg-dark-gray rounded-8 pa-8 mb-8">
                                <p class="txt_body_sm sb">담당자</p>
                            </div>
                            <div class="d-flex flex-col gap-8">
                                <!-- <div class="h-84 d-flex flex-col justify-between align-center">
                                    <i class="icon no_user"></i>
                                    <p class="txt_body_sm txt_tertiary">담당을 선택해주세요</p>
                                </div> -->
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-24">
                            <div class="card bg-dark-gray rounded-8 pa-8 mb-8">
                                <p class="txt_body_sm sb">참조자</p>
                            </div>
                            <div class="d-flex flex-col gap-8">
                                <!-- <div class="h-84 d-flex flex-col justify-between align-center">
                                    <i class="icon no_user"></i>
                                    <p class="txt_body_sm txt_tertiary">참조를 선택해주세요</p>
                                </div> -->
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                                <div class="card bg-white rounded-8 pa-4-8 d-flex justify-between">
                                    <div class="d-flex align-center gap-4">
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">delete_forever</i>
                                        <div class="desc_divider_wrap dot">
                                            <span class="txt_body_sm sb txt_primary">김이수</span>
                                            <span>팀장</span>
                                            <span>영업관리팀</span>
                                        </div>
                                    </div>
                                    <div class="d-flex align-center gap-8">
                                        <select class="custom_select w-82" name="" id="">
                                            <option value="">결재</option>
                                        </select>
                                        <i class="mdi-ico txt_18 txt_tertiary cursor-pointer">drag_handle</i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="d-flex gap-8 all-flex-1 pa-16-24 bd-t-c-1">
                    <button class="btn m outline dark_gray">취소</button>
                    <button class="btn m primary w-full">
                        <i class="mdi-ico mr-4">check</i>
                        적용
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
