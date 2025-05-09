package com.hr.common.excelTxtFilePas;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.hr.common.logger.Log;

public class ExcelFileType {

	public static Workbook getWorkbook(String fileString){
		FileInputStream fis = null;
		Workbook wb = null;
		
		try {
			fis= new FileInputStream(fileString);
			
			if ( fileString.toUpperCase().endsWith(".XLS")){
				try{
					wb = new HSSFWorkbook(fis);
				}catch(IOException e){
					throw new RuntimeException(e.getMessage(),e);
				}
			}else if ( fileString.toUpperCase().endsWith(".XLSX")){
				try{
					wb = new XSSFWorkbook(fis);
				}catch(IOException e){
					throw new RuntimeException(e.getMessage(),e);
				}
			}
		} catch(FileNotFoundException e){
			throw new RuntimeException(e.getMessage(),e);
		} finally {
			if (fis != null) try { fis.close(); } catch (IOException e) { Log.Debug("NEVER OCCURED ERROR"); }
		}

		return wb;
	}
	
	public static void close(Workbook sb) {
		try {
			sb.close();
		} catch (IOException e) {
			Log.Debug("WORKBOOK CLOSE FAIL");
		}
	}
}
