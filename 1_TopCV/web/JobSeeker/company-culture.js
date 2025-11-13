// Company Culture Page JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Initialize all functionality
    initSearchFunctionality();
    initFollowButtons();
    initScrollToTop();
    initSmoothScroll();
    initViewCompanyButtons();
});

// Search Functionality
function initSearchFunctionality() {
    const companySearchInput = document.querySelector('.company-search-input');
    const searchCompanyBtn = document.querySelector('.search-company-btn');
    const headerSearchBtn = document.querySelector('.search-btn');

    // Company search
    if (companySearchInput && searchCompanyBtn) {
        searchCompanyBtn.addEventListener('click', function() {
            const searchTerm = companySearchInput.value.trim();
            if (searchTerm) {
                console.log('Searching for company:', searchTerm);
                // Add your search logic here
                filterCompanies(searchTerm);
            }
        });

        companySearchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchCompanyBtn.click();
            }
        });
    }

    // Header search
    if (headerSearchBtn) {
        headerSearchBtn.addEventListener('click', function() {
            const searchInput = document.querySelector('.search-input');
            if (searchInput) {
                const searchTerm = searchInput.value.trim();
                console.log('Searching for job:', searchTerm);
                // Add your job search logic here
            }
        });
    }
}

// Filter companies by search term
function filterCompanies(searchTerm) {
    const companyCards = document.querySelectorAll('.company-card');
    const searchTermLower = searchTerm.toLowerCase();

    companyCards.forEach(card => {
        const companyName = card.querySelector('.company-name')?.textContent.toLowerCase() || '';
        const isVisible = companyName.includes(searchTermLower);

        if (isVisible) {
            card.style.display = 'block';
            card.style.animation = 'fadeIn 0.3s ease-in';
        } else {
            card.style.display = 'none';
        }
    });
}

// Follow Button Functionality
function initFollowButtons() {
    const followButtons = document.querySelectorAll('.follow-btn');

    followButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const isFollowing = this.classList.contains('following');
            
            if (isFollowing) {
                // Unfollow
                this.classList.remove('following');
                this.innerHTML = '<i class="fas fa-plus"></i> Theo dõi';
                this.style.background = 'var(--secondary-blue)';
                decreaseFollowerCount(this);
            } else {
                // Follow
                this.classList.add('following');
                this.innerHTML = '<i class="fas fa-check"></i> Đã theo dõi';
                this.style.background = '#2e7d32';
                increaseFollowerCount(this);
            }
        });
    });
}

function increaseFollowerCount(button) {
    const followerCountElement = button.parentElement.querySelector('.follower-count');
    if (followerCountElement) {
        const currentCount = parseInt(followerCountElement.textContent.match(/\d+/)?.[0] || '0');
        const newCount = currentCount + 1;
        followerCountElement.textContent = `${newCount} lượt theo dõi`;
    }
}

function decreaseFollowerCount(button) {
    const followerCountElement = button.parentElement.querySelector('.follower-count');
    if (followerCountElement) {
        const currentCount = parseInt(followerCountElement.textContent.match(/\d+/)?.[0] || '0');
        const newCount = Math.max(0, currentCount - 1);
        followerCountElement.textContent = `${newCount} lượt theo dõi`;
    }
}

// Scroll to Top Functionality
function initScrollToTop() {
    const scrollTopBtn = document.querySelector('.scroll-top-btn');
    
    if (scrollTopBtn) {
        // Show/hide button based on scroll position
        window.addEventListener('scroll', function() {
            if (window.pageYOffset > 300) {
                scrollTopBtn.style.opacity = '1';
                scrollTopBtn.style.visibility = 'visible';
            } else {
                scrollTopBtn.style.opacity = '0';
                scrollTopBtn.style.visibility = 'hidden';
            }
        });

        // Scroll to top on click
        scrollTopBtn.addEventListener('click', function() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
}

// Smooth Scroll for Anchor Links
function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// View Company Button Functionality
function initViewCompanyButtons() {
    const viewCompanyButtons = document.querySelectorAll('.view-company-btn');

    viewCompanyButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const companyCard = this.closest('.company-card');
            const companyName = companyCard.querySelector('.company-name')?.textContent || 'Unknown';
            console.log('Viewing company:', companyName);
            // Add your navigation logic here
            // For example: window.location.href = `/company/${companyId}`;
        });
    });
}

// Filter by Industry
const filterDropdown = document.querySelector('.filter-dropdown');
if (filterDropdown) {
    filterDropdown.addEventListener('change', function() {
        const selectedIndustry = this.value;
        console.log('Filtering by industry:', selectedIndustry);
        // Add your filter logic here
    });
}

// View More Button
const viewMoreBtn = document.querySelector('.view-more-btn');
if (viewMoreBtn) {
    viewMoreBtn.addEventListener('click', function() {
        console.log('Loading more companies...');
        // Add your pagination or load more logic here
        // This could fetch more companies from an API
    });
}

// Add fade-in animation CSS
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .scroll-top-btn {
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.3s, visibility 0.3s;
    }
`;
document.head.appendChild(style);
