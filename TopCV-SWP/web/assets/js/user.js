// Interactive functionality for VietnamWorks dashboard

document.addEventListener('DOMContentLoaded', function() {
    // Tab switching functionality
    const tabs = document.querySelectorAll('.tab');
    const tabContent = document.querySelector('.tab-content');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // Remove active class from all tabs
            tabs.forEach(t => t.classList.remove('active'));
            // Add active class to clicked tab
            this.classList.add('active');
            
            // Update tab content based on selected tab
            updateTabContent(this.textContent.trim());
        });
    });
    
    // Function to update tab content
    function updateTabContent(tabName) {
        const emptyState = document.querySelector('.empty-state');
        
        switch(tabName) {
            case 'Việc đã ứng tuyển':
                emptyState.innerHTML = `
                    <div class="empty-illustration">
                        <div class="document-icon">
                            <i class="fas fa-file-alt"></i>
                        </div>
                        <div class="document-icon behind">
                            <i class="fas fa-file-alt"></i>
                        </div>
                    </div>
                    <h3>Bạn chưa ứng tuyển vị trí nào</h3>
                    <a href="#" class="find-jobs-link">Tìm việc làm phù hợp</a>
                `;
                break;
            case 'Việc đã lưu':
                emptyState.innerHTML = `
                    <div class="empty-illustration">
                        <div class="document-icon">
                            <i class="fas fa-bookmark"></i>
                        </div>
                        <div class="document-icon behind">
                            <i class="fas fa-bookmark"></i>
                        </div>
                    </div>
                    <h3>Bạn chưa lưu việc làm nào</h3>
                    <a href="#" class="find-jobs-link">Tìm việc làm phù hợp</a>
                `;
                break;
            case 'Việc làm đã xem':
                emptyState.innerHTML = `
                    <div class="empty-illustration">
                        <div class="document-icon">
                            <i class="fas fa-eye"></i>
                        </div>
                        <div class="document-icon behind">
                            <i class="fas fa-eye"></i>
                        </div>
                    </div>
                    <h3>Bạn chưa xem việc làm nào</h3>
                    <a href="#" class="find-jobs-link">Tìm việc làm phù hợp</a>
                `;
                break;
            case 'Thư mời ứng tuyển':
                emptyState.innerHTML = `
                    <div class="empty-illustration">
                        <div class="document-icon">
                            <i class="fas fa-envelope"></i>
                        </div>
                        <div class="document-icon behind">
                            <i class="fas fa-envelope"></i>
                        </div>
                    </div>
                    <h3>Bạn chưa có thư mời ứng tuyển nào</h3>
                    <a href="#" class="find-jobs-link">Tìm việc làm phù hợp</a>
                `;
                break;
        }
    }
    
    // Navigation menu functionality
    const navItems = document.querySelectorAll('.nav-item');
    
    navItems.forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Remove active class from all nav items
            navItems.forEach(nav => nav.classList.remove('active'));
            // Add active class to clicked item
            this.classList.add('active');
            
            // Update page title based on selected nav item
            const pageTitle = this.querySelector('span').textContent;
            document.querySelector('.content-header h1').textContent = pageTitle;
        });
    });
    
    // Search functionality
    const searchInput = document.querySelector('.search-bar input');
    const searchBtn = document.querySelector('.search-btn');
    
    searchBtn.addEventListener('click', function() {
        const searchTerm = searchInput.value.trim();
        if (searchTerm) {
            // Search functionality without alert
            console.log(`Tìm kiếm: "${searchTerm}"`);
        }
    });
    
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            searchBtn.click();
        }
    });
    
    // Timeline dropdown functionality
    const statusDropdown = document.getElementById('statusDropdown');
    const timelineDropdown = document.getElementById('timelineDropdown');
    
    if (statusDropdown && timelineDropdown) {
        statusDropdown.addEventListener('click', function(e) {
            e.stopPropagation();
            timelineDropdown.classList.toggle('show');
            
            // Rotate chevron icon
            const chevronIcon = this.querySelector('.fa-chevron-down');
            if (timelineDropdown.classList.contains('show')) {
                chevronIcon.style.transform = 'rotate(180deg)';
            } else {
                chevronIcon.style.transform = 'rotate(0deg)';
            }
        });
        
        // Close timeline dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!statusDropdown.contains(e.target) && !timelineDropdown.contains(e.target)) {
                timelineDropdown.classList.remove('show');
                const chevronIcon = statusDropdown.querySelector('.fa-chevron-down');
                chevronIcon.style.transform = 'rotate(0deg)';
            }
        });
    }
    
    // Sticky footer scroll behavior
    const stickyFooter = document.querySelector('.sticky-footer');
    let lastScrollTop = 0;
    let isFooterVisible = true;
    
    if (stickyFooter) {
        window.addEventListener('scroll', function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
            
            // Show footer when scrolling down, hide when scrolling up
            if (scrollTop > lastScrollTop && scrollTop > 100) {
                // Scrolling down
                if (!isFooterVisible) {
                    stickyFooter.style.transform = 'translateY(0)';
                    isFooterVisible = true;
                }
            } else if (scrollTop < lastScrollTop) {
                // Scrolling up
                if (isFooterVisible) {
                    stickyFooter.style.transform = 'translateY(100%)';
                    isFooterVisible = false;
                }
            }
            
            lastScrollTop = scrollTop;
        });
    }
    
    // Application Modal functionality
    const applicationModal = document.getElementById('applicationModal');
    const modalClose = document.getElementById('modalClose');
    const applyButtons = document.querySelectorAll('.apply-btn');
    const submitApplication = document.getElementById('submitApplication');
    const privacyCheck = document.getElementById('privacyCheck');
    
    // Open modal when apply button is clicked
    applyButtons.forEach(button => {
        button.addEventListener('click', function() {
            applicationModal.classList.add('show');
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
        });
    });
    
    // Close modal functionality
    function closeModal() {
        applicationModal.classList.remove('show');
        document.body.style.overflow = 'auto'; // Restore scrolling
    }
    
    modalClose.addEventListener('click', closeModal);
    
    // Close modal when clicking overlay
    applicationModal.addEventListener('click', function(e) {
        if (e.target === applicationModal || e.target.classList.contains('modal-overlay')) {
            closeModal();
        }
    });
    
    // Close modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && applicationModal.classList.contains('show')) {
            closeModal();
        }
    });
    
    // Collapsible form sections
    const collapsibleSections = document.querySelectorAll('.form-section.collapsible');
    collapsibleSections.forEach(section => {
        const header = section.querySelector('h3');
        header.addEventListener('click', function() {
            section.classList.toggle('collapsed');
        });
    });
    
    // Form validation and submission
    submitApplication.addEventListener('click', function() {
        if (!privacyCheck.checked) {
            alert('Vui lòng đồng ý với quy định bảo mật trước khi ứng tuyển.');
            return;
        }
        
        // Here you would typically submit the form data
        alert('Đơn ứng tuyển đã được gửi thành công!');
        closeModal();
    });
    
    // Enable/disable submit button based on privacy checkbox
    privacyCheck.addEventListener('change', function() {
        submitApplication.disabled = !this.checked;
    });
    
    // Initialize submit button state
    submitApplication.disabled = !privacyCheck.checked;
    
    // Account Management Modals
    const passwordModal = document.getElementById('passwordModal');
    const accountSetupModal = document.getElementById('accountSetupModal');
    const passwordModalClose = document.getElementById('passwordModalClose');
    const accountSetupModalClose = document.getElementById('accountSetupModalClose');
    const passwordCancel = document.getElementById('passwordCancel');
    const accountSetupCancel = document.getElementById('accountSetupCancel');
    const passwordSubmit = document.getElementById('passwordSubmit');
    const accountSetupSubmit = document.getElementById('accountSetupSubmit');
    
    // Open password modal
    const changePasswordLink = document.getElementById('changePasswordLink');
    
    if (changePasswordLink) {
        changePasswordLink.addEventListener('click', function(e) {
            e.preventDefault();
            if (passwordModal) {
                passwordModal.classList.add('show');
                document.body.style.overflow = 'hidden';
            }
        });
    }
    
    // Open account setup modal
    const accountSetupLink = document.getElementById('accountSetupLink');
    if (accountSetupLink) {
        accountSetupLink.addEventListener('click', function(e) {
            e.preventDefault();
            if (accountSetupModal) {
                accountSetupModal.classList.add('show');
                document.body.style.overflow = 'hidden';
            }
        });
    }
    
    // Close modals functionality
    function closePasswordModal() {
        if (passwordModal) {
            passwordModal.classList.remove('show');
            document.body.style.overflow = 'auto';
        }
    }
    
    function closeAccountSetupModal() {
        if (accountSetupModal) {
            accountSetupModal.classList.remove('show');
            document.body.style.overflow = 'auto';
        }
    }
    
    // Close button events
    if (passwordModalClose) {
        passwordModalClose.addEventListener('click', function() {
            if (passwordModal) {
                passwordModal.classList.remove('show');
                document.body.style.overflow = 'auto';
            }
        });
    }
    if (accountSetupModalClose) {
        accountSetupModalClose.addEventListener('click', function() {
            if (accountSetupModal) {
                accountSetupModal.classList.remove('show');
                document.body.style.overflow = 'auto';
            }
        });
    }
    
    // Cancel button events
    if (passwordCancel) {
        passwordCancel.addEventListener('click', function() {
            if (passwordModal) {
                passwordModal.classList.remove('show');
                document.body.style.overflow = 'auto';
            }
        });
    }
    if (accountSetupCancel) {
        accountSetupCancel.addEventListener('click', function() {
            if (accountSetupModal) {
                accountSetupModal.classList.remove('show');
                document.body.style.overflow = 'auto';
            }
        });
    }
    
    // Close modal when clicking overlay
    if (passwordModal) {
        passwordModal.addEventListener('click', function(e) {
            if (e.target === passwordModal || e.target.classList.contains('modal-overlay')) {
                closePasswordModal();
            }
        });
    }
    
    if (accountSetupModal) {
        accountSetupModal.addEventListener('click', function(e) {
            if (e.target === accountSetupModal || e.target.classList.contains('modal-overlay')) {
                closeAccountSetupModal();
            }
        });
    }
    
    // Close modals with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (passwordModal && passwordModal.classList.contains('show')) {
                closePasswordModal();
            }
            if (accountSetupModal && accountSetupModal.classList.contains('show')) {
                closeAccountSetupModal();
            }
        }
    });
    
    // Form submission handlers
    if (passwordSubmit) {
        passwordSubmit.addEventListener('click', function() {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (!currentPassword || !newPassword || !confirmPassword) {
                alert('Vui lòng điền đầy đủ thông tin.');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                alert('Mật khẩu mới và xác nhận mật khẩu không khớp.');
                return;
            }
            
            if (newPassword.length < 6) {
                alert('Mật khẩu mới phải có ít nhất 6 ký tự.');
                return;
            }
            
            alert('Mật khẩu đã được thay đổi thành công!');
            closePasswordModal();
        });
    }
    
    if (accountSetupSubmit) {
        accountSetupSubmit.addEventListener('click', function() {
            const currentPassword = document.getElementById('currentPasswordSetup').value;
            const newEmail = document.getElementById('newEmail').value;
            
            if (!currentPassword || !newEmail) {
                alert('Vui lòng điền đầy đủ thông tin.');
                return;
            }
            
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(newEmail)) {
                alert('Vui lòng nhập email hợp lệ.');
                return;
            }
            
            alert('Thông tin tài khoản đã được cập nhật thành công!');
            closeAccountSetupModal();
        });
    }
    
    // Password toggle functionality
    window.togglePassword = function(inputId) {
        const input = document.getElementById(inputId);
        const button = input.nextElementSibling;
        const icon = button.querySelector('i');
        
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    };
    
    // Add hover effects for better UX
    const interactiveElements = document.querySelectorAll('.nav-item, .tab, .job-card, .search-btn, .cta-button');
    
    interactiveElements.forEach(element => {
        element.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-1px)';
        });
        
        element.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
    
    // Add loading animation for better UX
    function showLoading(element) {
        element.style.opacity = '0.6';
        element.style.pointerEvents = 'none';
        
        setTimeout(() => {
            element.style.opacity = '1';
            element.style.pointerEvents = 'auto';
        }, 500);
    }
    
    // File dropdown functionality
    const fileMenuBtns = document.querySelectorAll('.file-menu-btn');
    const fileDropdowns = document.querySelectorAll('.file-dropdown');
    
    fileMenuBtns.forEach((btn, index) => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            
            // Close all other dropdowns
            fileDropdowns.forEach((dropdown, i) => {
                if (i !== index) {
                    dropdown.classList.remove('show');
                }
            });
            
            // Toggle current dropdown
            fileDropdowns[index].classList.toggle('show');
        });
    });
    
    // Close dropdowns when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.file-actions')) {
            fileDropdowns.forEach(dropdown => {
                dropdown.classList.remove('show');
            });
        }
    });
    
    // Profile modal overlay click
    const profileModal = document.getElementById('profileModal');
    if (profileModal) {
        profileModal.addEventListener('click', function(e) {
            if (e.target === profileModal || e.target.classList.contains('modal-overlay')) {
                closeProfileModal();
            }
        });
    }
    
    // Close profile modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            if (profileModal && profileModal.classList.contains('show')) {
                closeProfileModal();
            }
        }
    });
});

// Global functions for modal handling
function openPasswordModal() {
    const passwordModal = document.getElementById('passwordModal');
    if (passwordModal) {
        passwordModal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

function openAccountSetupModal() {
    const accountSetupModal = document.getElementById('accountSetupModal');
    if (accountSetupModal) {
        accountSetupModal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

function closePasswordModal() {
    const passwordModal = document.getElementById('passwordModal');
    if (passwordModal) {
        passwordModal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

function closeAccountSetupModal() {
    const accountSetupModal = document.getElementById('accountSetupModal');
    if (accountSetupModal) {
        accountSetupModal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

// Make functions globally available
window.openPasswordModal = openPasswordModal;
window.openAccountSetupModal = openAccountSetupModal;
window.closePasswordModal = closePasswordModal;
window.closeAccountSetupModal = closeAccountSetupModal;

// Profile Modal functions
function openProfileModal() {
    const profileModal = document.getElementById('profileModal');
    if (profileModal) {
        profileModal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

function closeProfileModal() {
    const profileModal = document.getElementById('profileModal');
    if (profileModal) {
        profileModal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

function saveProfile() {
    // Here you would typically save the profile data
    alert('Thông tin đã được lưu thành công!');
    closeProfileModal();
}

    // Make profile functions globally available
    window.openProfileModal = openProfileModal;
    window.closeProfileModal = closeProfileModal;
    window.saveProfile = saveProfile;
    
    // Save button functionality for job detail page
    const saveButtons = document.querySelectorAll('.save-btn');
    
    saveButtons.forEach(button => {
        button.addEventListener('click', function() {
            const icon = this.querySelector('i');
            const textSpan = this.querySelector('span');
            
            // Determine current state based on clicked button
            const isCurrentlyUnsaved = icon.classList.contains('far');
            
            // Toggle state for all save buttons
            saveButtons.forEach(btn => {
                const btnIcon = btn.querySelector('i');
                const btnTextSpan = btn.querySelector('span');
                
                if (isCurrentlyUnsaved) {
                    // Change to saved state
                    btnIcon.classList.remove('far');
                    btnIcon.classList.add('fas');
                    btn.classList.add('saved');
                    if (btnTextSpan) {
                        btnTextSpan.textContent = 'Đã lưu';
                    }
                } else {
                    // Change to unsaved state
                    btnIcon.classList.remove('fas');
                    btnIcon.classList.add('far');
                    btn.classList.remove('saved');
                    if (btnTextSpan) {
                        btnTextSpan.textContent = 'Chưa lưu';
                    }
                }
            });
        });
    });


