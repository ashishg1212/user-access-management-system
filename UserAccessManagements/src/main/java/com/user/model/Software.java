package com.user.model;

public class Software {
	private int id;
	private String name;
    private String description;
    private String accessLevels;
    
    public Software() {
		// TODO Auto-generated constructor stub
	}

	public Software(int id, String name, String description, String accessLevels) {
		super();
		this.id = id;
		this.name = name;
		this.description = description;
		this.accessLevels = accessLevels;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAccessLevels() {
		return accessLevels;
	}

	public void setAccessLevels(String accessLevels) {
		this.accessLevels = accessLevels;
	}

	@Override
	public String toString() {
		return "Software [id=" + id + ", name=" + name + ", description=" + description + ", accessLevels="
				+ accessLevels + "]";
	}
    
}
