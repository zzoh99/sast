package com.hr.common.excelTxtFilePas;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;

import com.hr.common.logger.Log;

public class TextRead {

	public static String read(String filePath) throws Exception {

		// 버퍼 생성
		BufferedReader br = null;
		// Input 스트림 생성
		InputStreamReader isr = null;
		// File Input 스트림 생성
		FileInputStream fis = null;
		// File 경로
		File file = new File(filePath);
		// 버퍼로 읽어들일 임시 변수
		String temp = "";
		// 최종 내용 출력을 위한 변수
		String content = "";
		try {

			// 파일을 읽어들여 File Input 스트림 객체 생성
			fis = new FileInputStream(file);

			// File Input 스트림 객체를 이용해 Input 스트림 객체를 생서하는데 인코딩을 UTF-8로 지정
			isr = new InputStreamReader(fis, "UTF-8");

			// Input 스트림 객체를 이용하여 버퍼를 생성
			br = new BufferedReader(isr);

			// 버퍼를 한줄한줄 읽어들여 내용 추출
			while ((temp = br.readLine()) != null) {
				content += temp + "|";
			}
			//Log.Debug("================== 파일 내용 출력 ==================");
			//Log.Debug(content);
		} catch (FileNotFoundException e) {
			Log.Debug(e.getLocalizedMessage());
		} catch (Exception e) {
			Log.Debug(e.getLocalizedMessage());
		} finally {
			try {
				if (fis != null) fis.close();
			} catch (IOException e) {
				Log.Debug(e.getLocalizedMessage());
			}
			try {
				if (isr != null) isr.close();
			} catch (IOException e) {
				Log.Debug(e.getLocalizedMessage());
			}
			try {
				if (br != null) br.close();
			} catch (IOException e) {
				Log.Debug(e.getLocalizedMessage());
			}
		}
		return content;
	}
}
