// Form utilities for login forms
document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        // Check if loginType is already set in the form
        const existingLoginType = loginForm.querySelector('input[name="loginType"]');
        if (!existingLoginType) {
            // Add loginType based on current path
            const loginType = getLoginTypeFromPath();
            const hiddenInput = document.createElement('input');
            hiddenInput.type = 'hidden';
            hiddenInput.name = 'loginType';
            hiddenInput.value = loginType;
            loginForm.appendChild(hiddenInput);
        }
    }
});

function getLoginTypeFromPath() {
    const path = window.location.pathname;
    if (path.includes('admin')) {
        return 'admin';
    } else if (path.includes('jobseeker')) {
        return 'jobseeker';
    } else if (path.includes('recruiter')) {
        return 'recruiter';
    }
    return 'jobseeker'; // default
}

function showError(message) {
    // Simple error display
    alert(message);
}
