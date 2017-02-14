package com.sktechx.qadb.parser;

import java.util.ArrayList;

public class TestStep
{
	private String description;
	private String event;
	private String value;
 	private String type;
	
	//private int type;
	// PASS/FAIL, NA, GET TEXT

	public String index;
	public String text;
	public String resourceId;
	public String contentDesc;
	
	public ArrayList<String> texts;
	
	public TestStep()
	{
		description = "default";
		event = "default";
		index = "";
		text = "";
		texts = new ArrayList<>();
		type = "default";
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public String getValue()
	{
		return value;
	}

	public void setValue(String value)
	{
		this.value = value;
	}

	public String getEvent()
	{
		return event;
	}

	public void setEvent(String event)
	{
		this.event = event;
	}

	public String getType()
	{
		return type;
	}

	public void setType(String type)
	{
		this.type = type;
	}
}
