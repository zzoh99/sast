<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget15 = { size: null };

function init_listBox15(size) {
	widget15.size = size;
	loadWidget15();
}

function loadWidget15() {
	var data = ajaxCall('/getListBox15List.do', '', false).DATA;
	if (widget15.size != 'wide') $('#widget15RenewalTable').addClass('short');

	data.sort((a, b) => a.rnum - b.rnum);
	var html = data.reduce((a, c) => {
		if (c.rnum == 1) c.cnt6 = 1;
		if (c.rnum == 2) c.cnt3 = 2;
		if (c.rnum == 3) c.cnt3 = 4;
		
		var cntsum = Object.keys(c).filter(k => k.indexOf('cnt') > -1).map(k => c[k]).reduce((aa, cc) => aa + cc, 0) ;
		var cnt1 = c.cnt1 == 0 ? '-':c.cnt1;
		var cnt3 = c.cnt3 == 0 ? '-':c.cnt3;
		var cnt6 = c.cnt6 == 0 ? '-':c.cnt6;
		var total = cntsum == 0 ? '-':cntsum;

		a += '<tr>\n'
		  +  '	<td>' + c.codeNm + '</td>\n'
		  +  '	<td>' + cnt6 + '</td>\n'
		  +  '	<td>' + cnt3 + '</td>\n'
		  +  '	<td>' + cnt1 + '</td>\n'
		  +  '	<td class="total">' + total + '</td>\n'
		  +  '</tr>\n';
		
		return a;
	}, '');
	$('#widget15TBody').html(html);
}

</script>
<div class="widget_header">
  <div class="widget_title">
    <i class="mdi-ico filled">account_box</i>갱신사항 안내
  </div>
</div>
<div class="widget_body renewal">
  <table id="widget15RenewalTable" class="renewal_table">
    <thead>
      <tr>
        <td>구분</td>
        <td>6개월</td>
        <td>3개월</td>
        <td>1개월</td>
        <td>합</td>
      </tr>
    </thead>
    <tbody id="widget15TBody">
    </tbody>
  </table>
</div>