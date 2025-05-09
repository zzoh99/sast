package com.hr.sys.system.tableRptMgr;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod; 
/**
 * 테이블명세서 Controller 
 * 
 * @author JSG
 *
 */
@Controller
@RequestMapping(value="/TableRptMgr.do", method=RequestMethod.POST )
public class TableRptMgrController {
	
	/**
	 * 테이블명세서 View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTableRptMgr", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTableRptMgr() throws Exception {
		return "sys/system/tableRptMgr/tableRptMgr";
	}

	/**
	 * 테이블명세서 Iframe View
	 * 
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(params="cmd=viewTable_report", method = {RequestMethod.POST, RequestMethod.GET} )
	public String viewTable_report() throws Exception {
		return "common/report/sys/TableView_report_view";
	}
}
