package model;

public class RoleStaff {
    private int roleStaffId;
    private int roleId;
    private int topcvId;
    
    public RoleStaff() {}
    
    public RoleStaff(int roleStaffId, int roleId, int topcvId) {
        this.roleStaffId = roleStaffId;
        this.roleId = roleId;
        this.topcvId = topcvId;
    }
    
    public int getRoleStaffId() {
        return roleStaffId;
    }
    
    public void setRoleStaffId(int roleStaffId) {
        this.roleStaffId = roleStaffId;
    }
    
    public int getRoleId() {
        return roleId;
    }
    
    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }
    
    public int getTopcvId() {
        return topcvId;
    }
    
    public void setTopcvId(int topcvId) {
        this.topcvId = topcvId;
    }
    
    @Override
    public String toString() {
        return "RoleStaff{" +
                "roleStaffId=" + roleStaffId +
                ", roleId=" + roleId +
                ", topcvId=" + topcvId +
                '}';
    }
}
