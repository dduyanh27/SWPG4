// Candidate management page - data is now loaded from server via JSP
// JavaScript chỉ cần xử lý các sự kiện tương tác nếu cần

document.addEventListener('DOMContentLoaded', () => {
    // Auto-hide success alert after 5 seconds
    const successAlert = document.querySelector('.success-alert');
    if (successAlert) {
        setTimeout(() => {
            successAlert.style.transition = 'opacity 0.5s';
            successAlert.style.opacity = '0';
            setTimeout(() => successAlert.remove(), 500);
        }, 5000);
    }
    
    // Select all checkbox functionality (if needed)
    const selectAllCheckbox = document.querySelector('thead input[type="checkbox"]');
    const rowCheckboxes = document.querySelectorAll('tbody input[type="checkbox"]');
    
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            rowCheckboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });
    }
});

// Handle Accept action
function handleAccept(contextPath, applicationID, jobID, candidateName) {
    if (confirm('Bạn có chắc chắn muốn chấp nhận ứng viên "' + candidateName + '"?')) {
        return true;
    }
    return false;
}

// Handle Reject action
function handleReject(contextPath, applicationID, jobID, candidateName) {
    if (confirm('Bạn có chắc chắn muốn từ chối ứng viên "' + candidateName + '"?')) {
        return true;
    }
    return false;
}

// Handle job selection change
function changeJob(jobID) {
    if (jobID && jobID !== '') {
        window.location.href = window.location.pathname + '?jobID=' + jobID;
    }
}