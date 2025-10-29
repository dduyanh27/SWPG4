package model;

public class GoogleAccount {
    // Google 的 user id 是一个很长的数字字符串，不能用 int 保存
    private String id;
    private String email;
    private String name;
    private String picture;

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPicture() { return picture; }
    public void setPicture(String picture) { this.picture = picture; }
}


