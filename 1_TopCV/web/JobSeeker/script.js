// Interactive functionality for VietnamWorks dashboard

document.addEventListener('DOMContentLoaded', function() {
    // Job-list: Industry filter dropdown
    const industryFilter = document.getElementById('industryFilter');
    const industryDropdown = document.getElementById('industryDropdown');
    const fieldFilter = document.getElementById('fieldFilter');
    const fieldDropdown = document.getElementById('fieldDropdown');
    function openFilterDropdown(target) {
        [industryDropdown, fieldDropdown].forEach(d => { if (d && d !== target) d.classList.remove('show'); });
        if (target) target.classList.add('show');
    }
    if (industryFilter && industryDropdown) {
        const filtersBox = industryFilter.closest('.filters-box');
        const rightPanel = document.getElementById('industryRight');
        const leftItems = document.querySelectorAll('#industryLeft .filter-item-row');

        const subMap = {
            banle: [
                { name: 'Tất cả' },
                { name: 'Quản Lý Cửa Hàng', count: 31 },
                { name: 'Quản Lý Khu Vực', count: 43 },
                { name: 'Thu Mua', count: 18 },
                { name: 'Trợ Lý Bán Lẻ', count: 15 }
            ],
            baohiem: [ { name: 'Tất cả' }, { name: 'Tư Vấn Bảo Hiểm', count: 12 } ],
            bds: [ { name: 'Tất cả' }, { name: 'Môi Giới', count: 54 }, { name: 'Quản Lý Dự Án', count: 9 } ],
            ceo: [ { name: 'Tất cả' } ],
            phiLoiNhuan: [ { name: 'Tất cả' } ],
            cntt: [ { name: 'Tất cả' }, { name: 'Frontend', count: 120 }, { name: 'Backend', count: 140 } ]
        };

        function renderRight(key) {
            const items = subMap[key] || [];
            rightPanel.innerHTML = items.map(i => (
                `<div class="filter-item-row"><div>${i.name}</div>${i.count ? `<div class=\"count\">${i.count}</div>` : ''}</div>`
            )).join('');
        }

        industryFilter.addEventListener('mouseenter', () => {
            openFilterDropdown(industryDropdown);
            renderRight('banle');
        });

        leftItems.forEach(item => {
            item.addEventListener('mouseenter', () => {
                renderRight(item.getAttribute('data-key'));
            });
        });

        if (filtersBox) {
            filtersBox.addEventListener('mouseleave', () => {
                [industryDropdown, fieldDropdown].forEach(d => d && d.classList.remove('show'));
            });
        }

        document.addEventListener('click', (e) => {
            if (!filtersBox.contains(e.target)) {
                [industryDropdown, fieldDropdown].forEach(d => d && d.classList.remove('show'));
            }
        });
    }

    // Company page: jobs per page pagination demo
    const jobListEl = document.getElementById('jobList');
    const prevPageBtn = document.getElementById('prevPage');
    const nextPageBtn = document.getElementById('nextPage');
    const paginationInfo = document.getElementById('paginationInfo');
    const jobsPerPageBtn = document.getElementById('jobsPerPageBtn');
    const jobsPerPageMenu = document.getElementById('jobsPerPageMenu');
    if (jobListEl && prevPageBtn && nextPageBtn && paginationInfo && jobsPerPageBtn && jobsPerPageMenu) {
        // mock 23 jobs
        const allJobs = Array.from({ length: 23 }).map((_, i) => ({
            title: `Trưởng Phòng Sales Tour #${i + 1}`,
            company: 'CÔNG TY CỔ PHẦN DU LỊCH SGOTOURS',
            salary: '35tr-50tr đ/tháng',
            location: 'Hà Nội',
            updated: '06/09/2025'
        }));
        let currentPage = 1;
        let perPage = 20;

        function renderJobs() {
            const start = (currentPage - 1) * perPage;
            const end = start + perPage;
            const pageJobs = allJobs.slice(start, end);
            jobListEl.innerHTML = pageJobs.map(j => `
                <div class="job-item">
                    <div class="logo">SGO</div>
                    <div>
                        <h4 style="margin:0; color:#111827;">${j.title}</h4>
                        <div style="color:#6b7280; margin-top:2px;">${j.company}</div>
                        <div class="meta">
                            <span>${j.salary}</span>
                            <span>${j.location}</span>
                        </div>
                        <div style="display:flex; gap:0.4rem; margin-top:0.4rem; flex-wrap:wrap;">
                            <span class="chip">Quản Lý Đội Nhóm</span>
                            <span class="chip">Bán hàng</span>
                            <span class="chip">Kinh Doanh</span>
                            <span class="chip">+2</span>
                        </div>
                        <div style="color:#6b7280; margin-top:0.4rem; font-size:0.85rem;">Cập nhật: ${j.updated}</div>
                    </div>
                    <div style="display:flex; align-items:center; gap:0.5rem;">
                        <a class="btn" href="job-detail.html">Xem chi tiết</a>
                        <button class="btn-outline" style="width:36px; height:36px; border-radius:10px; display:grid; place-items:center;">
                            <i class="far fa-heart"></i>
                        </button>
                    </div>
                </div>
            `).join('');
            const totalPages = Math.max(1, Math.ceil(allJobs.length / perPage));
            paginationInfo.textContent = `${currentPage} / ${totalPages}`;
            prevPageBtn.style.opacity = currentPage === 1 ? 0.4 : 1;
            nextPageBtn.style.opacity = currentPage === totalPages ? 0.4 : 1;
        }

        prevPageBtn.addEventListener('click', () => {
            if (currentPage > 1) { currentPage -= 1; renderJobs(); }
        });
        nextPageBtn.addEventListener('click', () => {
            const totalPages = Math.ceil(allJobs.length / perPage);
            if (currentPage < totalPages) { currentPage += 1; renderJobs(); }
        });

        // open/close menu
        const perPageMenuEl = jobsPerPageMenu.querySelector('.menu');
        jobsPerPageBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            perPageMenuEl.classList.toggle('show');
        });
        perPageMenuEl.querySelectorAll('.option').forEach(opt => {
            opt.addEventListener('click', () => {
                perPage = parseInt(opt.getAttribute('data-value'), 10);
                currentPage = 1;
                jobsPerPageBtn.innerHTML = `Công việc mỗi trang: ${perPage} <i class=\"fas fa-chevron-down\" style=\"color:#6b7280;\"></i>`;
                perPageMenuEl.classList.remove('show');
                renderJobs();
            });
        });
        document.addEventListener('click', () => perPageMenuEl.classList.remove('show'));

        renderJobs();
    }
    // Field dropdown (simple one column)
    if (fieldFilter && fieldDropdown) {
        const filtersBox2 = fieldFilter.closest('.filters-box');
        fieldFilter.addEventListener('mouseenter', () => {
            openFilterDropdown(fieldDropdown);
        });
        if (filtersBox2) {
            filtersBox2.addEventListener('mouseleave', () => {
                [industryDropdown, fieldDropdown].forEach(d => d && d.classList.remove('show'));
            });
        }
        document.addEventListener('click', (e) => {
            if (!filtersBox2.contains(e.target)) {
                [industryDropdown, fieldDropdown].forEach(d => d && d.classList.remove('show'));
            }
        });
    }
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
    
    // Sticky footer scroll behavior (disabled on pages không có sticky-footer)
    const stickyFooter = document.querySelector('.sticky-footer');
    if (stickyFooter) {
        let lastScrollTop = 0;
        let isFooterVisible = true;
        window.addEventListener('scroll', function() {
            const scrollTop = window.pageYOffset || document.documentElement.scrollTop;
            if (scrollTop > lastScrollTop && scrollTop > 100) {
                if (!isFooterVisible) {
                    stickyFooter.style.transform = 'translateY(0)';
                    isFooterVisible = true;
                }
            } else if (scrollTop < lastScrollTop) {
                if (isFooterVisible) {
                    stickyFooter.style.transform = 'translateY(100%)';
                    isFooterVisible = false;
                }
            }
            lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
        }, { passive: true });
    }
    
    // Application Modal functionality
    const applicationModal = document.getElementById('applicationModal');
    const modalClose = document.getElementById('modalClose');
    const applyButtons = document.querySelectorAll('.apply-btn');
    const submitApplication = document.getElementById('submitApplication');
    const privacyCheck = document.getElementById('privacyCheck');
    
    // Only initialize modal if elements exist
    if (applicationModal && modalClose) {
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
    }
    
    // Collapsible form sections
    const collapsibleSections = document.querySelectorAll('.form-section.collapsible');
    collapsibleSections.forEach(section => {
        const header = section.querySelector('h3');
        if (header) {
            header.addEventListener('click', function() {
                section.classList.toggle('collapsed');
            });
        }
    });
    
    // Form validation and submission
    if (submitApplication && privacyCheck) {
        submitApplication.addEventListener('click', function(e) {
        e.preventDefault();
        
        if (!privacyCheck.checked) {
            alert('Vui lòng đồng ý với quy định bảo mật trước khi ứng tuyển.');
            return;
        }
        
        // Kiểm tra xem có login không
        if (!isLoggedIn) {
            alert('Vui lòng đăng nhập để ứng tuyển.');
            window.location.href = contextPath + '/JobSeeker/jobseeker-login.jsp';
            return;
        }
        
        const form = document.getElementById('applicationForm');
        const formData = new FormData(form);
        
        // Kiểm tra có chọn CV hoặc upload file mới không
        const cvSelect = document.getElementById('cvSelect');
        const newCVFile = document.getElementById('newCVFile');
        
        // Kiểm tra xem có ít nhất một trong hai: CV có sẵn hoặc CV mới
        const hasSelectedCV = cvSelect && cvSelect.value;
        const hasNewCV = newCVFile && newCVFile.files && newCVFile.files.length > 0;
        
        if (!hasSelectedCV && !hasNewCV) {
            if (cvSelect) {
                alert('Vui lòng chọn CV hoặc tải lên CV mới để ứng tuyển.');
            } else {
                alert('Vui lòng tải lên CV để ứng tuyển.');
            }
            return;
        }
        
        // Nếu có cả CV có sẵn và CV mới, hiển thị xác nhận
        if (hasSelectedCV && hasNewCV) {
            if (!confirm('Bạn đã chọn cả CV có sẵn và tải lên CV mới. Hệ thống sẽ sử dụng CV mới được tải lên. Bạn có muốn tiếp tục?')) {
                return;
            }
            // Xóa CV đã chọn để ưu tiên CV mới
            cvSelect.value = '';
        }
        
        // Kiểm tra định dạng file nếu có upload file mới
        if (hasNewCV) {
            const file = newCVFile.files[0];
            const allowedExtensions = ['.pdf', '.doc', '.docx'];
            const fileExtension = file.name.toLowerCase().substring(file.name.lastIndexOf('.'));
            
            if (!allowedExtensions.includes(fileExtension)) {
                alert('Vui lòng chọn file CV có định dạng PDF, DOC hoặc DOCX.');
                return;
            }
            
            // Kiểm tra kích thước file (10MB)
            if (file.size > 10 * 1024 * 1024) {
                alert('Kích thước file CV không được vượt quá 10MB.');
                return;
            }
        }
        
        // Disable submit button và hiển thị loading
        submitApplication.disabled = true;
        submitApplication.textContent = 'Đang gửi...';
        
        // Submit form via AJAX
        fetch(contextPath + '/job-application', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Đơn ứng tuyển đã được gửi thành công!');
                closeModal();
                // Có thể reload trang để update UI
                location.reload();
            } else {
                alert('Lỗi: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Đã xảy ra lỗi khi gửi đơn ứng tuyển. Vui lòng thử lại.');
        })
        .finally(() => {
            // Re-enable submit button
            submitApplication.disabled = !privacyCheck.checked;
            submitApplication.textContent = 'Ứng tuyển';
        });
        });
    
        // Enable/disable submit button based on privacy checkbox
        privacyCheck.addEventListener('change', function() {
            submitApplication.disabled = !this.checked;
        });
        
        // Initialize submit button state
        submitApplication.disabled = !privacyCheck.checked;
    }
    
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

    // Sidebar collapse toggle (account-management)
    const sidebar = document.querySelector('.sidebar');
    const sidebarToggle = document.getElementById('sidebarToggle');
    if (sidebar && sidebarToggle) {
        sidebarToggle.addEventListener('click', function() {
            const icon = sidebarToggle.querySelector('i');
            sidebar.classList.toggle('collapsed');
            const isCollapsed = sidebar.classList.contains('collapsed');
            icon.classList.toggle('fa-angle-left', !isCollapsed);
            icon.classList.toggle('fa-angle-right', isCollapsed);
        });
    }


