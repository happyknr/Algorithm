package com.sktechx.qadb.parser;

import java.util.ArrayList;

public class TestCase
{
	private ArrayList<TestStep> testSteps;
	private int id;							// testcase id
	private String name;					// testcase name
	private int repeat;						// repeat
	private String description;				// testcase desc
	
	public TestCase()
	{
		testSteps = new ArrayList<>();
		id = 0;
		name = "";
		repeat = 0;
		description = "";
	}

	public ArrayList<TestStep> getTestSteps()
	{
		return testSteps;
	}

	public void setTestSteps(ArrayList<TestStep> testSteps)
	{
		this.testSteps = testSteps;
 	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public int getRepeat()
	{
		return repeat;
	}

	public void setRepeat(int repeat)
	{
		this.repeat = repeat;
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}
}
