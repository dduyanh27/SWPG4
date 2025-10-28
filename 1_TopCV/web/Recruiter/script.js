// Initialize Chart.js pie chart
document.addEventListener('DOMContentLoaded', function() {
    try {
        const statusChartElement = document.getElementById('statusChart');
        if (!statusChartElement) {
            console.log('statusChart element not found, skipping chart initialization');
            return;
        }
        const ctx = statusChartElement.getContext('2d');
    
    const statusChart = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: [
                'Nhận hồ sơ',
                'Duyệt hồ sơ', 
                'Kiểm Tra Năng Lực',
                'Đỗ tuyển',
                'Không đạt'
            ],
            datasets: [{
                data: [42.9, 32.8, 5.9, 4.2, 14.3],
                backgroundColor: [
                    '#87CEEB', // Light blue
                    '#FFB6C1', // Pink/Magenta
                    '#4169E1', // Dark blue
                    '#90EE90', // Green
                    '#FF6B6B'  // Red
                ],
                borderWidth: 2,
                borderColor: '#fff',
                hoverBorderWidth: 3,
                hoverBorderColor: '#333'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        usePointStyle: true,
                        font: {
                            size: 12
                        }
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.label + ': ' + context.parsed + '%';
                        }
                    }
                }
            },
            animation: {
                animateRotate: true,
                duration: 2000
            }
        }
    });

    // Add click event to chart segments
    statusChart.canvas.addEventListener('click', function(event) {
        const points = statusChart.getElementsAtEventForMode(event, 'nearest', { intersect: true }, true);
        if (points.length) {
            const firstPoint = points[0];
            const label = statusChart.data.labels[firstPoint.index];
            const value = statusChart.data.datasets[0].data[firstPoint.index];
            // Bạn đã click vào chart
        }
    });
    } catch (error) {
        console.error('Chart initialization error:', error);
    }
});

// Dropdown functionality
document.addEventListener('DOMContentLoaded', function() {
    // Handle all dropdowns
    const dropdowns = document.querySelectorAll('.dropdown');
    
    dropdowns.forEach(dropdown => {
        const trigger = dropdown.querySelector('a, button');
        const content = dropdown.querySelector('.dropdown-content');
        
        if (trigger && content) {
            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!dropdown.contains(event.target)) {
                    content.style.display = 'none';
                }
            });
            
            // Toggle dropdown on click
            trigger.addEventListener('click', function(event) {
                // Only prevent default for dropdown triggers, not for links inside dropdown content
                if (event.target === trigger || trigger.contains(event.target)) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                
                // Close other dropdowns
                dropdowns.forEach(otherDropdown => {
                    if (otherDropdown !== dropdown) {
                        otherDropdown.querySelector('.dropdown-content').style.display = 'none';
                    }
                });
                
                // Toggle current dropdown
                if (content.style.display === 'block') {
                    content.style.display = 'none';
                } else {
                    content.style.display = 'block';
                }
            });
        }
    });
});

// Table interactions
document.addEventListener('DOMContentLoaded', function() {
    // Handle status select changes
    const statusSelects = document.querySelectorAll('.status-select');
    statusSelects.forEach(select => {
        select.addEventListener('change', function() {
            const row = this.closest('tr');
            const jobTitle = row.querySelector('.job-title span').textContent;
            const newStatus = this.value;
            
            // Add visual feedback
            row.style.backgroundColor = '#f0f8ff';
            setTimeout(() => {
                row.style.backgroundColor = '';
            }, 1000);
            
            console.log(`Đã thay đổi trạng thái của "${jobTitle}" thành "${newStatus}"`);
        });
    });
    
    // Handle edit buttons
    const editButtons = document.querySelectorAll('.edit-btn');
    editButtons.forEach(button => {
        button.addEventListener('click', function() {
            const row = this.closest('tr');
            const jobTitle = row.querySelector('.job-title span').textContent;
            // Chỉnh sửa tin đăng
        });
    });
    
    // Handle more options buttons
    const moreButtons = document.querySelectorAll('.more-btn');
    moreButtons.forEach(button => {
        button.addEventListener('click', function() {
            const row = this.closest('tr');
            const jobTitle = row.querySelector('.job-title span').textContent;
            
            // Create a simple context menu
            const contextMenu = document.createElement('div');
            contextMenu.className = 'context-menu';
            contextMenu.innerHTML = `
                <div class="context-item" onclick="console.log('Xem chi tiết: ${jobTitle}')">Xem chi tiết</div>
                <div class="context-item" onclick="console.log('Sao chép: ${jobTitle}')">Sao chép</div>
                <div class="context-item" onclick="console.log('Xóa: ${jobTitle}')">Xóa</div>
            `;
            
            // Style the context menu
            contextMenu.style.cssText = `
                position: absolute;
                background: white;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                z-index: 1000;
                min-width: 120px;
            `;
            
            // Position the context menu
            const rect = button.getBoundingClientRect();
            contextMenu.style.left = rect.left + 'px';
            contextMenu.style.top = (rect.bottom + 5) + 'px';
            
            // Add context menu styles
            const style = document.createElement('style');
            style.textContent = `
                .context-item {
                    padding: 10px 15px;
                    cursor: pointer;
                    border-bottom: 1px solid #eee;
                }
                .context-item:hover {
                    background: #f8f9fa;
                }
                .context-item:last-child {
                    border-bottom: none;
                }
            `;
            document.head.appendChild(style);
            
            // Remove existing context menus
            document.querySelectorAll('.context-menu').forEach(menu => menu.remove());
            
            // Add new context menu
            document.body.appendChild(contextMenu);
            
            // Remove context menu when clicking outside
            setTimeout(() => {
                document.addEventListener('click', function removeContextMenu() {
                    contextMenu.remove();
                    document.removeEventListener('click', removeContextMenu);
                });
            }, 100);
        });
    });
});

// Navigation interactions
document.addEventListener('DOMContentLoaded', function() {
    // Handle navigation menu clicks
    const navLinks = document.querySelectorAll('.nav-menu a');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Remove active class from all links
            navLinks.forEach(l => l.classList.remove('active'));
            // Add active class to clicked link
            this.classList.add('active');
        });
    });
    
    // Handle main action buttons
    const postJobBtn = document.querySelector('.btn-orange');
    const findCandidateBtn = document.querySelector('.btn-blue');
    const buyBtn = document.querySelectorAll('.btn-orange')[1];
    
    if (postJobBtn) {
        postJobBtn.addEventListener('click', function() {
            // Mở form đăng tuyển dụng
        });
    }
    
    if (findCandidateBtn) {
        findCandidateBtn.addEventListener('click', function() {
            // Mở trang tìm kiếm ứng viên
        });
    }
    
    if (buyBtn) {
        buyBtn.addEventListener('click', function() {
            // Mở trang mua gói dịch vụ
        });
    }
});

// User Dropdown interactions - Updated for all pages
document.addEventListener('DOMContentLoaded', function() {
    const userAvatar = document.querySelector('.user-avatar');
    const userMenu = document.querySelector('.user-menu');
    const closeMenu = document.querySelector('.close-menu');
    
    if (userAvatar && userMenu) {
        // Toggle user menu on avatar click
        userAvatar.addEventListener('click', function(event) {
            event.preventDefault();
            event.stopPropagation();
            
            // Close other dropdowns
            document.querySelectorAll('.dropdown-content').forEach(dropdown => {
                if (dropdown !== userMenu) {
                    dropdown.style.display = 'none';
                }
            });
            
            // Toggle user menu with new class system
            if (userMenu.classList.contains('show')) {
                userMenu.classList.remove('show');
            } else {
                userMenu.classList.add('show');
            }
        });
        
        // Close menu when clicking close button
        if (closeMenu) {
            closeMenu.addEventListener('click', function(event) {
                event.preventDefault();
                event.stopPropagation();
                userMenu.classList.remove('show');
            });
        }
        
        // Close menu when clicking outside
        document.addEventListener('click', function(event) {
            if (!userAvatar.contains(event.target) && !userMenu.contains(event.target)) {
                userMenu.classList.remove('show');
            }
        });
        
        // Handle menu item clicks
        const menuItems = userMenu.querySelectorAll('.menu-item, .logout-item');
        menuItems.forEach(item => {
            item.addEventListener('click', function(event) {
                event.preventDefault();
                const itemText = this.querySelector('span').textContent;
                console.log('Selected menu item:', itemText);
                
                // Handle specific menu items
                if (itemText === 'Thông tin công ty') {
                    window.location.href = 'company-info.jsp';
                } else if (itemText === 'Quản lý tài khoản') {
                    // Navigate to account management
                    console.log('Navigate to account management');
                } else if (itemText === 'Thoát') {
                    // Handle logout
                    console.log('User logout');
                    showNotification('Đã đăng xuất', 'info');
                }
                
                userMenu.classList.remove('show');
            });
        });
    }
});

// Feedback and Chat interactions
document.addEventListener('DOMContentLoaded', function() {
    const feedbackSidebar = document.querySelector('.feedback-sidebar');
    const chatButton = document.querySelector('.chat-button');
    
    if (feedbackSidebar) {
        feedbackSidebar.addEventListener('click', function() {
            // Mở form feedback
        });
    }
    
    if (chatButton) {
        chatButton.addEventListener('click', function() {
            // Mở cửa sổ chat
        });
    }
});

// Welcome section interactions
document.addEventListener('DOMContentLoaded', function() {
    const welcomeLinks = document.querySelectorAll('.welcome-links .link');
    welcomeLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const linkText = this.textContent;
            // Mở link
        });
    });
    
    const viewReportsLink = document.querySelector('.view-reports');
    if (viewReportsLink) {
        viewReportsLink.addEventListener('click', function(e) {
            e.preventDefault();
            // Mở trang báo cáo chi tiết
        });
    }
});

// Status dropdown interactions
document.addEventListener('DOMContentLoaded', function() {
    const statusDropdown = document.querySelector('.status-dropdown');
    if (statusDropdown) {
        statusDropdown.addEventListener('change', function() {
            const selectedValue = this.value;
            console.log(`Đã chọn: ${selectedValue}`);
            
            // Here you would typically filter the chart data
            // Lọc theo giá trị đã chọn
            console.log(`Lọc theo: ${selectedValue}`);
        });
    }
    
    const exportBtn = document.querySelector('.export-btn');
    if (exportBtn) {
        exportBtn.addEventListener('click', function() {
            // Xuất báo cáo ra file Excel
        });
    }
});

// Add some animations and effects
document.addEventListener('DOMContentLoaded', function() {
    // Add hover effects to cards
    const cards = document.querySelectorAll('.point-card, .welcome-section, .status-section, .job-management');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.transition = 'transform 0.3s ease';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
    
    // Add loading animation for chart
    const chartContainer = document.querySelector('.chart-container');
    if (chartContainer) {
        chartContainer.style.opacity = '0';
        setTimeout(() => {
            chartContainer.style.transition = 'opacity 1s ease';
            chartContainer.style.opacity = '1';
        }, 500);
    }
});

// General Info Page Interactions
document.addEventListener('DOMContentLoaded', function() {
    const changePasswordLink = document.getElementById('change-password-link');
    const passwordForm = document.getElementById('password-form');
    
    if (!changePasswordLink || !passwordForm) {
        console.log('Password form elements not found, skipping password functionality');
        return;
    }
    const cancelBtn = document.querySelector('.cancel-btn');
    
    if (changePasswordLink && passwordForm) {
        changePasswordLink.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Toggle form visibility and icon
            const isHidden = passwordForm.style.display === 'none' || 
                           passwordForm.style.display === '' || 
                           !passwordForm.style.display;
            
            if (isHidden) {
                passwordForm.style.display = 'block';
                changePasswordLink.classList.remove('active');
            } else {
                passwordForm.style.display = 'none';
                changePasswordLink.classList.add('active');
            }
        });
    }
    
    if (cancelBtn && passwordForm) {
        cancelBtn.addEventListener('click', function(e) {
            e.preventDefault();
            passwordForm.style.display = 'none';
            if (changePasswordLink) {
                changePasswordLink.classList.remove('active');
                changePasswordLink.innerHTML = 'Thay đổi mật khẩu <i class="fas fa-chevron-down"></i>';
            }
        });
    }
    
    // Handle edit button for fullname
    const editBtn = document.querySelector('.edit-btn');
    const fullnameInput = document.getElementById('fullname');
    
    if (editBtn && fullnameInput) {
        editBtn.addEventListener('click', function() {
            if (fullnameInput.readOnly) {
                fullnameInput.readOnly = false;
                fullnameInput.focus();
                fullnameInput.style.background = 'white';
                fullnameInput.style.color = '#374151';
            } else {
                fullnameInput.readOnly = true;
                fullnameInput.style.background = '#f9fafb';
                fullnameInput.style.color = '#6b7280';
            }
        });
    }
    
    // Handle save button in password form
    const savePasswordBtn = document.querySelector('.password-form .save-btn');
    if (savePasswordBtn) {
        savePasswordBtn.addEventListener('click', function(e) {
            e.preventDefault();
            const currentPassword = document.getElementById('current-password').value;
            const newPassword = document.getElementById('new-password').value;
            const confirmPassword = document.getElementById('confirm-password').value;
            
            if (!currentPassword || !newPassword || !confirmPassword) {
                showErrorModal('Vui lòng điền đầy đủ thông tin');
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showErrorModal('Mật khẩu mới và xác nhận mật khẩu không khớp');
                return;
            }
            
            if (newPassword.length < 6) {
                showErrorModal('Mật khẩu mới phải có ít nhất 6 ký tự');
                return;
            }
            
            // Simulate password change (in real app, this would be an API call)
            // For demo purposes, we'll simulate success/failure randomly
            const isSuccess = Math.random() > 0.3; // 70% success rate for demo
            
            if (isSuccess) {
                showSuccessModal();
            } else {
                showErrorModal('Mật khẩu hiện tại không đúng');
            }
        });
    }
    
    // Handle modal interactions
    const successModal = document.getElementById('success-modal');
    const errorModal = document.getElementById('error-modal');
    const loginRedirectBtn = document.getElementById('login-redirect');
    const errorCloseBtn = document.getElementById('error-close');
    
    if (!successModal || !errorModal) {
        console.log('Modal elements not found, skipping modal functionality');
        return;
    }
    
    if (loginRedirectBtn) {
        loginRedirectBtn.addEventListener('click', function() {
            // Redirect to your existing login page
            window.location.href = 'login.html';
        });
    }
    
    if (errorCloseBtn) {
        errorCloseBtn.addEventListener('click', function() {
            hideErrorModal();
        });
    }
    
    // Close modals when clicking outside
    if (successModal) {
        successModal.addEventListener('click', function(e) {
            if (e.target === successModal) {
                hideSuccessModal();
            }
        });
    }
    
    if (errorModal) {
        errorModal.addEventListener('click', function(e) {
            if (e.target === errorModal) {
                hideErrorModal();
            }
        });
    }
});

// Modal functions
function showSuccessModal() {
    const modal = document.getElementById('success-modal');
    if (modal) {
        modal.classList.add('show');
        // Clear form after showing success
        const passwordForm = document.getElementById('password-form');
        const changePasswordLink = document.getElementById('change-password-link');
        
        if (passwordForm) {
            passwordForm.style.display = 'none';
        }
        if (changePasswordLink) {
            changePasswordLink.classList.remove('active');
            changePasswordLink.innerHTML = 'Thay đổi mật khẩu <i class="fas fa-chevron-down"></i>';
        }
        
        // Clear form fields
        document.getElementById('current-password').value = '';
        document.getElementById('new-password').value = '';
        document.getElementById('confirm-password').value = '';
    }
}

function hideSuccessModal() {
    const modal = document.getElementById('success-modal');
    if (modal) {
        modal.classList.remove('show');
    }
}

function showErrorModal(message) {
    const modal = document.getElementById('error-modal');
    const errorMessage = document.getElementById('error-message');
    
    if (modal) {
        if (errorMessage) {
            errorMessage.textContent = message;
        }
        modal.classList.add('show');
    }
}

function hideErrorModal() {
    const modal = document.getElementById('error-modal');
    if (modal) {
        modal.classList.remove('show');
    }
}

// Dropdown toggle functionality
document.addEventListener('DOMContentLoaded', function() {
    const dropdowns = document.querySelectorAll('.dropdown');
    
    dropdowns.forEach(dropdown => {
        const dropdownTrigger = dropdown.querySelector('a, button');
        
        if (dropdownTrigger) {
            dropdownTrigger.addEventListener('click', function(e) {
                // Only prevent default for main dropdown triggers, not for links inside dropdown content
                if (e.target === dropdownTrigger || dropdownTrigger.contains(e.target)) {
                    e.preventDefault();
                }
                
                // Close other dropdowns
                dropdowns.forEach(otherDropdown => {
                    if (otherDropdown !== dropdown) {
                        otherDropdown.classList.remove('active');
                    }
                });
                
                // Toggle current dropdown
                dropdown.classList.toggle('active');
            });
        }
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.dropdown')) {
            dropdowns.forEach(dropdown => {
                dropdown.classList.remove('active');
            });
        }
    });
    
    // Ensure dropdown links work properly
    const dropdownLinks = document.querySelectorAll('.dropdown-content a');
    dropdownLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Don't prevent default for dropdown content links
            console.log('Dropdown link clicked:', this.href);
            // Force navigation if href exists
            if (this.href && this.href !== '#' && this.href !== window.location.href) {
                window.location.href = this.href;
            }
        });
    });
});

// Utility functions
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#4CAF50' : type === 'error' ? '#f44336' : '#2196F3'};
        color: white;
        padding: 15px 20px;
        border-radius: 5px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        z-index: 10000;
        animation: slideIn 0.3s ease;
    `;
    
    // Add animation keyframes
    if (!document.querySelector('#notification-styles')) {
        const style = document.createElement('style');
        style.id = 'notification-styles';
        style.textContent = `
            @keyframes slideIn {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOut {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
    }
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

// Job Posting Page Functionality
document.addEventListener('DOMContentLoaded', function() {
    // Collapsible sections
    const collapsibleHeaders = document.querySelectorAll('.collapsible-header');
    collapsibleHeaders.forEach(header => {
        header.addEventListener('click', function() {
            const section = this.closest('.collapsible');
            section.classList.toggle('active');
        });
    });

    // Counter buttons
    const counterBtns = document.querySelectorAll('.counter-btn');
    counterBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.parentElement.querySelector('input');
            const isPlus = this.classList.contains('plus');
            const isMinus = this.classList.contains('minus');
            
            if (isPlus) {
                input.value = parseInt(input.value) + 1;
            } else if (isMinus && parseInt(input.value) > 0) {
                input.value = parseInt(input.value) - 1;
            }
        });
    });

    // Tag input functionality
    const tagInputs = document.querySelectorAll('.tag-input input');
    tagInputs.forEach(input => {
        input.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                const tagText = this.value.trim();
                if (tagText && this.parentElement.querySelectorAll('.tag').length < 5) {
                    addTag(this.parentElement, tagText);
                    this.value = '';
                }
            }
        });
    });

    // Remove tag functionality
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('fa-times')) {
            e.target.closest('.tag').remove();
        }
    });

    // Add benefit functionality
    const addBenefitBtn = document.querySelector('.btn-secondary');
    if (addBenefitBtn) {
        addBenefitBtn.addEventListener('click', function() {
            addBenefitItem();
        });
    }

    // Remove benefit functionality
    // Package item radio fallback for unsupported :has()
    function updatePackageCheckedState() {
        const items = document.querySelectorAll('.package-item');
        items.forEach(item => {
            const radio = item.querySelector('input[type="radio"]');
            if (radio) {
                if (radio.checked) {
                    item.classList.add('is-checked');
                } else {
                    item.classList.remove('is-checked');
                }
            }
        });
    }

    // Initialize state on load
    updatePackageCheckedState();

    // Delegate change events for radios within package items
    document.addEventListener('change', function(e) {
        if (e.target && e.target.matches('.package-item input[type="radio"]')) {
            // Radios share the same name, clear all then set current
            document.querySelectorAll('.package-item').forEach(item => item.classList.remove('is-checked'));
            updatePackageCheckedState();
        }
    });
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('fa-trash')) {
            e.target.closest('.benefit-item').remove();
        }
    });
});

function addTag(container, text) {
    const tag = document.createElement('span');
    tag.className = 'tag';
    tag.innerHTML = `${text} <i class="fas fa-times"></i>`;
    container.querySelector('.selected-tags').appendChild(tag);
}

function addBenefitItem() {
    const benefitsList = document.querySelector('.benefits-list');
    const benefitItem = document.createElement('div');
    benefitItem.className = 'benefit-item';
    benefitItem.innerHTML = `
        <i class="fas fa-grip-vertical"></i>
        <select>
            <option value="bonus">Thưởng</option>
            <option value="health">Chăm sóc sức khỏe</option>
            <option value="leave">Nghỉ phép có lương</option>
            <option value="training">Đào tạo</option>
            <option value="transport">Phụ cấp đi lại</option>
        </select>
        <textarea placeholder="Mô tả chi tiết..."></textarea>
        <i class="fas fa-trash"></i>
    `;
    benefitsList.appendChild(benefitItem);
}

// Candidate Search Page Functionality
document.addEventListener('DOMContentLoaded', function() {
    // Search functionality
    const searchInput = document.querySelector('.search-input');
    const searchBtn = document.querySelector('.btn-search');
    const filterBtn = document.querySelector('.btn-filter');
    
    if (searchBtn) {
        searchBtn.addEventListener('click', function() {
            const searchTerm = searchInput ? searchInput.value : '';
            console.log('Tìm kiếm:', searchTerm);
            // Here you would typically make an API call to search for candidates
            performSearch(searchTerm);
        });
    }
    
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                const searchTerm = this.value;
                console.log('Tìm kiếm:', searchTerm);
                performSearch(searchTerm);
            }
        });
    }
    
    if (filterBtn) {
        filterBtn.addEventListener('click', function() {
            openFilterModal();
        });
    }
    
    // Search tags functionality
    const searchTags = document.querySelectorAll('.search-tag');
    searchTags.forEach(tag => {
        tag.addEventListener('click', function() {
            const tagText = this.textContent;
            if (searchInput) {
                searchInput.value = tagText;
            }
            console.log('Chọn tag:', tagText);
            performSearch(tagText);
        });
    });
    
    // View controls
    const viewBtns = document.querySelectorAll('.view-btn');
    viewBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            // Remove active class from all buttons
            viewBtns.forEach(b => b.classList.remove('active'));
            // Add active class to clicked button
            this.classList.add('active');
            
            const viewType = this.getAttribute('data-view');
            console.log('Chuyển sang chế độ xem:', viewType);
            toggleView(viewType);
        });
    });
    
    // Bookmark functionality
    const bookmarkBtns = document.querySelectorAll('.bookmark-btn');
    bookmarkBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            this.classList.toggle('active');
            const isBookmarked = this.classList.contains('active');
            console.log('Bookmark:', isBookmarked ? 'Đã lưu' : 'Đã bỏ lưu');
        });
    });
    
    // Profile detail buttons
    const profileBtns = document.querySelectorAll('.btn-primary');
    profileBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const candidateCard = this.closest('.candidate-card');
            const candidateName = candidateCard.querySelector('.candidate-name').textContent;
            console.log('Xem hồ sơ chi tiết của:', candidateName);
            // Here you would typically navigate to the candidate profile page
            window.location.href = 'candidate-profile.html';
        });
    });
    
    // Category dropdown
    const categorySelect = document.querySelector('.search-category');
    if (categorySelect) {
        categorySelect.addEventListener('change', function() {
            const selectedCategory = this.value;
            console.log('Chọn danh mục:', selectedCategory);
        });
    }
});

function performSearch(searchTerm) {
    // Simulate search with loading state
    const candidateCards = document.querySelectorAll('.candidate-card');
    candidateCards.forEach(card => {
        card.style.opacity = '0.5';
    });
    
    // Simulate API delay
    setTimeout(() => {
        candidateCards.forEach(card => {
            card.style.opacity = '1';
        });
        console.log('Kết quả tìm kiếm cho:', searchTerm);
    }, 500);
}

function toggleView(viewType) {
    const candidateList = document.querySelector('.candidate-list');
    if (viewType === 'grid') {
        candidateList.style.display = 'grid';
        candidateList.style.gridTemplateColumns = 'repeat(auto-fill, minmax(300px, 1fr))';
        candidateList.style.gap = '20px';
    } else {
        candidateList.style.display = 'flex';
        candidateList.style.flexDirection = 'column';
        candidateList.style.gap = '15px';
    }
}

// Filter Modal Functions
function openFilterModal() {
    const modal = document.getElementById('filterModal');
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden'; // Prevent background scrolling
    }
}

function closeFilterModal() {
    const modal = document.getElementById('filterModal');
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = ''; // Restore scrolling
    }
}

// Filter Modal Event Listeners
document.addEventListener('DOMContentLoaded', function() {
    const filterModal = document.getElementById('filterModal');
    const closeFilterBtn = document.getElementById('closeFilter');
    
    // Close modal when clicking close button
    if (closeFilterBtn) {
        closeFilterBtn.addEventListener('click', closeFilterModal);
    }
    
    // Close modal when clicking outside
    if (filterModal) {
        filterModal.addEventListener('click', function(e) {
            if (e.target === filterModal) {
                closeFilterModal();
            }
        });
    }
    
    // Close modal with Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && filterModal && filterModal.classList.contains('show')) {
            closeFilterModal();
        }
    });
    
    // Filter tabs functionality
    const filterTabs = document.querySelectorAll('.filter-tab');
    filterTabs.forEach(tab => {
        tab.addEventListener('click', function() {
            // Remove active class from all tabs
            filterTabs.forEach(t => t.classList.remove('active'));
            // Add active class to clicked tab
            this.classList.add('active');
            
            const value = this.getAttribute('data-value');
            console.log('Selected filter tab:', value);
        });
    });
    
    // Counter buttons functionality
    const counterBtns = document.querySelectorAll('.counter-btn');
    counterBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const input = this.parentElement.querySelector('input');
            const isPlus = this.classList.contains('plus');
            const isMinus = this.classList.contains('minus');
            
            if (isPlus) {
                input.value = parseInt(input.value) + 1;
            } else if (isMinus && parseInt(input.value) > 0) {
                input.value = parseInt(input.value) - 1;
            }
        });
    });
    
    // Filter buttons functionality
    const saveSearchBtn = document.querySelector('.btn-save-search');
    const resetBtn = document.querySelector('.btn-reset');
    const searchFilterBtn = document.querySelector('.btn-search-filter');
    
    if (saveSearchBtn) {
        saveSearchBtn.addEventListener('click', function() {
            console.log('Lưu tìm kiếm');
            // Here you would save the current filter settings
            showNotification('Đã lưu tìm kiếm', 'success');
        });
    }
    
    if (resetBtn) {
        resetBtn.addEventListener('click', function() {
            resetFilterForm();
            showNotification('Đã cài đặt lại bộ lọc', 'info');
        });
    }
    
    if (searchFilterBtn) {
        searchFilterBtn.addEventListener('click', function() {
            const filterData = getFilterData();
            console.log('Filter data:', filterData);
            applyFilters(filterData);
            closeFilterModal();
        });
    }
});

function resetFilterForm() {
    // Reset all form elements
    const form = document.querySelector('.filter-modal');
    if (form) {
        // Reset checkboxes
        const checkboxes = form.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(checkbox => checkbox.checked = false);
        
        // Reset radio buttons
        const radioButtons = form.querySelectorAll('input[type="radio"]');
        radioButtons.forEach(radio => {
            if (radio.value === 'any') {
                radio.checked = true;
            } else {
                radio.checked = false;
            }
        });
        
        // Reset selects to first option
        const selects = form.querySelectorAll('select');
        selects.forEach(select => select.selectedIndex = 0);
        
        // Reset inputs
        const inputs = form.querySelectorAll('input[type="text"], input[type="number"]');
        inputs.forEach(input => input.value = '');
        
        // Reset experience counter
        const experienceInput = form.querySelector('.experience-counter input');
        if (experienceInput) {
            experienceInput.value = '0';
        }
        
        // Reset filter tabs
        const filterTabs = form.querySelectorAll('.filter-tab');
        filterTabs.forEach(tab => tab.classList.remove('active'));
        const anyTab = form.querySelector('.filter-tab[data-value="any"]');
        if (anyTab) {
            anyTab.classList.add('active');
        }
    }
}

function getFilterData() {
    const form = document.querySelector('.filter-modal');
    const filterData = {};
    
    if (form) {
        // Get checkbox values
        const filterByJob = form.querySelector('#filterByJob');
        filterData.filterByJob = filterByJob ? filterByJob.checked : false;
        
        // Get job selection
        const jobSelect = form.querySelector('.job-select');
        filterData.jobSelection = jobSelect ? jobSelect.value : '';
        
        // Get active filter tab
        const activeTab = form.querySelector('.filter-tab.active');
        filterData.lastUpdated = activeTab ? activeTab.getAttribute('data-value') : 'any';
        
        // Get all select values
        const selects = form.querySelectorAll('select');
        selects.forEach(select => {
            const label = select.previousElementSibling;
            if (label && label.tagName === 'LABEL') {
                const key = label.textContent.toLowerCase().replace(/\s+/g, '_');
                filterData[key] = select.value;
            }
        });
        
        // Get input values
        const inputs = form.querySelectorAll('input[type="text"], input[type="number"]');
        inputs.forEach(input => {
            const label = input.closest('.filter-item')?.querySelector('label');
            if (label) {
                const key = label.textContent.toLowerCase().replace(/\s+/g, '_');
                filterData[key] = input.value;
            }
        });
        
        // Get radio button values
        const genderRadio = form.querySelector('input[name="gender"]:checked');
        filterData.gender = genderRadio ? genderRadio.value : 'any';
        
        // Get experience value
        const experienceInput = form.querySelector('.experience-counter input');
        filterData.experience = experienceInput ? experienceInput.value : '0';
    }
    
    return filterData;
}

function applyFilters(filterData) {
    console.log('Applying filters:', filterData);
    // Here you would apply the filters to the candidate list
    // This could involve making an API call or filtering the existing data
    
    // Simulate filtering with loading state
    const candidateCards = document.querySelectorAll('.candidate-card');
    candidateCards.forEach(card => {
        card.style.opacity = '0.5';
    });
    
    setTimeout(() => {
        candidateCards.forEach(card => {
            card.style.opacity = '1';
        });
        showNotification('Đã áp dụng bộ lọc', 'success');
    }, 500);
}
