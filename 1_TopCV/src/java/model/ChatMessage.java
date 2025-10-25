package model;

import java.util.Date;

public class ChatMessage {
    private int messageID;
    private String senderRole;
    private int senderID;
    private String receiverRole;
    private int receiverID;
    private String messageContent;
    private Date sentAt;

    public ChatMessage() {}

    public ChatMessage(int messageID, String senderRole, int senderID,
                       String receiverRole, int receiverID, String messageContent, Date sentAt) {
        this.messageID = messageID;
        this.senderRole = senderRole;
        this.senderID = senderID;
        this.receiverRole = receiverRole;
        this.receiverID = receiverID;
        this.messageContent = messageContent;
        this.sentAt = sentAt;
    }

    public int getMessageID() {
        return messageID;
    }

    public void setMessageID(int messageID) {
        this.messageID = messageID;
    }

    public String getSenderRole() {
        return senderRole;
    }

    public void setSenderRole(String senderRole) {
        this.senderRole = senderRole;
    }

    public int getSenderID() {
        return senderID;
    }

    public void setSenderID(int senderID) {
        this.senderID = senderID;
    }

    public String getReceiverRole() {
        return receiverRole;
    }

    public void setReceiverRole(String receiverRole) {
        this.receiverRole = receiverRole;
    }

    public int getReceiverID() {
        return receiverID;
    }

    public void setReceiverID(int receiverID) {
        this.receiverID = receiverID;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent;
    }

    public Date getSentAt() {
        return sentAt;
    }

    public void setSentAt(Date sentAt) {
        this.sentAt = sentAt;
    }

    
}
