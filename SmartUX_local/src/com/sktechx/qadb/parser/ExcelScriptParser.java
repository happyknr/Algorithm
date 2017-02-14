package com.sktechx.qadb.parser;


import java.io.Closeable;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelScriptParser 
{
	////////////////
	// cell column define
	public static final char COL_TESTCASE_INFO='B';			// script info
	
	public static final char COL_TESTSTEP_TYPE='A';				// script index
	public static final char COL_TESTSTEP_DESCRIPTION='B';			// script description
	public static final char COL_TESTSTEP_EVENT='C';				// script event
	public static final char COL_TESTSTEP_VALUE='D';				// script value

	public static final char COL_TESTSTEP_NODE_INDEX='E';			// script - node - index
	public static final char COL_TESTSTEP_NODE_TEXT='F';			// script - node - text
	public static final char COL_TESTSTEP_NODE_RESOUCE_ID='G';		// script - node - resource id
	public static final char COL_TESTSTEP_NODE_CONTENT_DESC='H';	// script - node - content desc

	//public static final char CELL_NAME_LOADING_TIME='I';		// script - e2e

	////////////////
	// cell row define
	public static final int ROW_TESTSTEP_START=11;				// script start
	
	public static final int ROW_TESTCASE_NAME=4;			// testcase name
	public static final int ROW_TESTCASE_REPEAT=5;			// repeat count 
	public static final int ROW_TESTCASE_DESCRIPTION=6;		// description

	private static final int ROW_TESTSUITE_NAME=1;
	private static final int ROW_TESTSUITE_LOG_FOLDER=2;
	private static final int ROW_TESTSUITE_PACKAGE_NAME=3;
	private static final int ROW_TESTSUITE_AUTHOR=4;
	private static final int ROW_TESTSUITE_DESCRIPTION=5;
	
	////////////////
	// define event
	public static final String EVENT_TYPE_APP_LAUNCH="AppLaunch";
	public static final String EVENT_TYPE_APP_CLOSE="AppClose";
	public static final String EVENT_TYPE_CLICK_ELEMENT="ClickElement";
//	public static final String EVENT_TYPE_CLICK_ELEMENT_LIST="ClickElementList";
	public static final String EVENT_TYPE_CLICK_POSITION="ClickPosition";
	public static final String EVENT_TYPE_FIND_ELEMENT="FindElement";
	public static final String EVENT_TYPE_DELAY="Delay";
//	public static final String EVENT_TYPE_LOG_MEMINFO="LogMemInfo";
	public static final String EVENT_TYPE_SCRIPT_END="ScriptEnd";
//	public static final String EVENT_TYPE_SCREEN_ROTATE="ScreenRotate";
	public static final String EVENT_TYPE_COMMAND_CUSTOMIZE="Customize";
//	public static final String EVENT_TYPE_CHARGE_STATE="ChargeState";
	public static final String EVENT_TYPE_VOICE_OUTPUT="Voice";
//	public static final String EVENT_TYPE_AUDIO_JACK="AudioJack";
	public static final String EVENT_TYPE_KEY_PRESS="KeyPress";
	public static final String EVENT_TYPE_SWIPE_ELEMENT="SwipeElement";
	public static final String EVENT_TYPE_SWIPE_POSITION="SwipePosition";
	public static final String EVENT_TYPE_LONG_CLICK_ELEMENT="LongClickElement";
//	public static final String EVENT_TYPE_LONG_CLICK_ELEMENT_LIST="LongClickElementList";
	public static final String EVENT_TYPE_LONG_CLICK_POSITION="LongClickPosition";
	public static final String EVENT_TYPE_LONG_KEY_PRESS="LongKeyPress";
	public static final String EVENT_TYPE_INPUT_STRING="InputString";
	public static final String EVENT_TYPE_INPUT_STRING_ALL_CLEAR="InputStringAllClear";
//	public static final String EVENT_TYPE_FIDDLER_CAPTURE_START="FiddlerCaptureStart";
//	public static final String EVENT_TYPE_FIDDLER_CAPTURE_END="FiddlerCaptureEnd";
	public static final String EVENT_TYPE_NETWORK_STAT="NetworkStat";
	
	public static final String SHEET_GUIDE = "Event Description"; 
	public static final String SHEET_INFO = "Test Information"; 
	public static final String TIME_CHECK_START="Start";
	public static final String TIME_CHECK_END="End";

	private XSSFWorkbook workbook = null;

	public int getColumn(char columnName)
	{
		return ((int)columnName)-65;
	}
	
	public int getColumn(String columnName)
	{
		if(columnName.length() > 2) return -1;

		if(columnName.length() == 2)
		{
			char ch0 = columnName.toUpperCase().charAt(0);
			char ch1 = columnName.toUpperCase().charAt(1);

			return ((getColumn(ch0)+1)*26)+getColumn(ch1);
		}
		else
		{
			char ch0 = columnName.toUpperCase().charAt(0);
			return getColumn(ch0);
		}
	}

	public int getRow(int row)
	{
		return row-1;
	}
	
//	public int scriptExcelUpdater()
//	{
//		
//	}
	
	/**
	 * 엑셀 스크립트 정보 파싱 - 테스트 정보, 스크립트 Command 정보 등등
	 * @param filePath 엑셀 파일 경로
	 */
	public TestSuite scriptExcelParser(String filePath) 
	{
		try 
		{
			// for excel file
			FileInputStream file = new FileInputStream(filePath);
			workbook = new XSSFWorkbook(file);

			// initialize test suite ..
			TestSuite ts = new TestSuite();
			
			// initialize test cases ..
			int sheetCount = workbook.getNumberOfSheets();
			
			int i;
			ArrayList<TestCase> testCases = new ArrayList<>();
			
			for(i=0; i<sheetCount ;i++)
			{
				XSSFSheet sheet = workbook.getSheetAt(i);
				
				if(sheet.getSheetName().equals(SHEET_GUIDE)) 
					continue;
				
				if(sheet.getSheetName().equals(SHEET_INFO)) 
				{
					// TEST SUITE
					Cell cellTestSuiteName = sheet.getRow(getRow(ROW_TESTSUITE_NAME)).getCell(getColumn('B'));
					ts.setTestName(getCellValueToString(cellTestSuiteName));
					
					Cell cellTestSuiteLogFolder = sheet.getRow(getRow(ROW_TESTSUITE_LOG_FOLDER)).getCell(getColumn('B'));
					ts.setLogFolder(getCellValueToString(cellTestSuiteLogFolder));
					
					Cell cellTestSuitePackageName = sheet.getRow(getRow(ROW_TESTSUITE_PACKAGE_NAME)).getCell(getColumn('B'));
					ts.setPackageName(getCellValueToString(cellTestSuitePackageName));

					Cell cellTestSuiteAuthor = sheet.getRow(getRow(ROW_TESTSUITE_AUTHOR)).getCell(getColumn('B'));
					ts.setAuthor(getCellValueToString(cellTestSuiteAuthor));
					
					Cell cellTestSuiteDescription = sheet.getRow(getRow(ROW_TESTSUITE_DESCRIPTION)).getCell(getColumn('B'));
					ts.setDescription(getCellValueToString(cellTestSuiteDescription));
										
					continue;
				}
				
				// TEST CASE
				TestCase tc = new TestCase();
				
				// Test Case ID
				tc.setId(i);
				
				// Test Case name
				Cell cellTestCaseName = sheet.getRow(getRow(ROW_TESTCASE_NAME)).getCell(getColumn(COL_TESTCASE_INFO));
				tc.setName(getCellValueToString(cellTestCaseName));
				
				// Test Case repeat
				Cell cellTestCaseRepeat = sheet.getRow(getRow(ROW_TESTCASE_REPEAT)).getCell(getColumn(COL_TESTCASE_INFO));
				tc.setRepeat(Integer.parseInt(getCellValueToString(cellTestCaseRepeat)));
				
				// Test Case Description
				Cell cellTestCaseDesc = sheet.getRow(getRow(ROW_TESTCASE_DESCRIPTION)).getCell(getColumn(COL_TESTCASE_INFO));
				tc.setDescription(getCellValueToString(cellTestCaseDesc));
				
				int rowTotal=sheet.getLastRowNum();
				int j;
				ArrayList<TestStep> testSteps = new ArrayList<>();
				
				
				// TEST STEP
				for(j=ROW_TESTSTEP_START-1; j<=rowTotal; j++)
				{
					TestStep step = new TestStep();				
					Row row = sheet.getRow(j);
					
					// TYPE
					Cell cell = row.getCell(getColumn(COL_TESTSTEP_TYPE));
					try
					{
						step.setType(getCellValueToString(cell));
					}
					catch(Exception E)
					{
						E.printStackTrace();
					}
					
					// DESCRIPTION
					cell = row.getCell(getColumn(COL_TESTSTEP_DESCRIPTION));
					step.setDescription(getCellValueToString(cell));
					
					// EVENT
					cell = row.getCell(getColumn(COL_TESTSTEP_EVENT));
					String event = getCellValueToString(cell);
					step.setEvent(event);
					
					// NODE
					cell = row.getCell(getColumn(COL_TESTSTEP_VALUE));
					step.setValue(getCellValueToString(cell));							
					
					cell = row.getCell(getColumn(COL_TESTSTEP_NODE_INDEX));
					if(!getCellValueToString(cell).equals(""))
						step.index = getCellValueToString(cell);
					
					cell = row.getCell(getColumn(COL_TESTSTEP_NODE_RESOUCE_ID));
					step.resourceId = getCellValueToString(cell);
					
					cell = row.getCell(getColumn(COL_TESTSTEP_NODE_CONTENT_DESC));
					step.contentDesc = getCellValueToString(cell);

					cell = row.getCell(getColumn(COL_TESTSTEP_NODE_TEXT));
					
					if(event.equals("FindElements"))
					{
						int idx = j;
						do
						{
							Row row2 = sheet.getRow(idx);
							Cell cell2 = row2.getCell(getColumn(COL_TESTSTEP_NODE_TEXT));
							step.texts.add(getCellValueToString(cell2));
							
							idx++;
						} while(sheet.getRow(idx).getCell(getColumn(COL_TESTSTEP_EVENT)).getStringCellValue().trim().equals(""));
						
						j=idx-1;
					}
					else
					{
						step.text = getCellValueToString(cell);
					}
					
					testSteps.add(step);
					
					if(event.equals("ScriptEnd"))  break;
				}
				
				tc.setTestSteps(testSteps);
				testCases.add(tc);
			}
			
			ts.setTestCase(testCases);
			ts.setParse(true);

			if(workbook!=null)
			{
				workbook.close();
			}
			
			return ts;
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
			TestSuite fail = new TestSuite();
			return fail;
		} 
	}


	/**
	 * 셀에서 가져온 내용을 문자열로 변환
	 * @param cell 셀
	 * @return 셀에서 가져온 문자열
	 */
	public String getCellValueToString(Cell cell)
	{
		String value = null;
		if(cell == null)
		{
			return "";
		}
		else
		{
			
			switch (cell.getCellType())
			{
			case XSSFCell.CELL_TYPE_FORMULA:
				value = cell.getCellFormula();
				break;
			case XSSFCell.CELL_TYPE_NUMERIC:
				value = "" + (int)cell.getNumericCellValue();
				break;
			case XSSFCell.CELL_TYPE_STRING:
				value = cell.getStringCellValue()+"";
				break;
			case XSSFCell.CELL_TYPE_BLANK:
				value = "";
				break;
			case XSSFCell.CELL_TYPE_ERROR:
				value = cell.getErrorCellValue()+"";
				break;
			case XSSFCell.CELL_TYPE_BOOLEAN:
				value = cell.getBooleanCellValue()+"";
				break;
			default : break;
			}
		}
		return value;
	}
}
