package model;

public class Category {
    private int categoryID;
    private String categoryName;
    private Integer parentCategoryID;
    
    public Category() {}
    
    public Category(int categoryID, String categoryName, Integer parentCategoryID) {
        this.categoryID = categoryID;
        this.categoryName = categoryName;
        this.parentCategoryID = parentCategoryID;
    }
    
    public int getCategoryID() {
        return categoryID;
    }
    
    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }
    
    public String getCategoryName() {
        return categoryName;
    }
    
    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }
    
    public Integer getParentCategoryID() {
        return parentCategoryID;
    }
    
    public void setParentCategoryID(Integer parentCategoryID) {
        this.parentCategoryID = parentCategoryID;
    }
    
    @Override
    public String toString() {
        return "Category{" +
                "categoryID=" + categoryID +
                ", categoryName='" + categoryName + '\'' +
                ", parentCategoryID=" + parentCategoryID +
                '}';
    }
}
