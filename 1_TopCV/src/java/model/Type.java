package model;

public class Type {
    private int typeID;
    private String typeCategory;
    private String typeName;
    
    public Type() {}
    
    public Type(int typeID, String typeCategory, String typeName) {
        this.typeID = typeID;
        this.typeCategory = typeCategory;
        this.typeName = typeName;
    }
    
    public int getTypeID() {
        return typeID;
    }
    
    public void setTypeID(int typeID) {
        this.typeID = typeID;
    }
    
    public String getTypeCategory() {
        return typeCategory;
    }
    
    public void setTypeCategory(String typeCategory) {
        this.typeCategory = typeCategory;
    }
    
    public String getTypeName() {
        return typeName;
    }
    
    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }
    
    @Override
    public String toString() {
        return "Type{" +
                "typeID=" + typeID +
                ", typeCategory='" + typeCategory + '\'' +
                ", typeName='" + typeName + '\'' +
                '}';
    }
}
