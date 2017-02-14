package com.sktechx.qadb.parser;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class TestSuite
{
	private ArrayList<TestCase> testCase;
	private	String testName;
	private String packageName;
	private String packageVersion;
	private String logFolder;
	private String author;
	private String description;
	private boolean parse;
	
	public TestSuite()
	{
		testCase = new ArrayList<>();
		testName = new String("");
		packageName = new String("");
		packageVersion = new String("");
		logFolder = new String("");
		author = new String("");
		description = new String("");
		parse = false;
	}

	public ArrayList<TestCase> getTestCase()
	{
		return testCase;
	}

	public void setTestCase(ArrayList<TestCase> testCase)
	{
		this.testCase = testCase;
	}

	public String getTestName()
	{
		return testName;
	}

	public void setTestName(String testName)
	{
		this.testName = testName;
	}

	public String getPackageName()
	{
		return packageName;
	}

	public void setPackageName(String packageName)
	{
		this.packageName = packageName;
	}

	public String getPackageVersion()
	{
		return packageVersion;
	}

	public void setPackageVersion(String packageVersion)
	{
		this.packageVersion = packageVersion;
	}

	public String getLogFolder()
	{
		return logFolder;
	}

	public void setLogFolder(String logFolder)
	{
		this.logFolder = logFolder;
	}

	public String getAuthor()
	{
		return author;
	}

	public void setAuthor(String author)
	{
		this.author = author;
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public boolean isParse()
	{
		return parse;
	}

	public void setParse(boolean parse)
	{
		this.parse = parse;
	}
}

