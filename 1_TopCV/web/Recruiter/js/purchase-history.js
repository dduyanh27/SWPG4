// Purchase History - Scoped JS
document.addEventListener('DOMContentLoaded', function() {
    // User dropdown toggle (scoped)
    const user = document.querySelector('.ph-user');
    if (user) {
        const btn = user.querySelector('.ph-user-btn');
        const menu = user.querySelector('.ph-user-menu');
        if (btn && menu) {
            btn.addEventListener('click', function(e) {
                e.stopPropagation();
                menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
            });
            document.addEventListener('click', function() {
                menu.style.display = 'none';
            });
        }
    }
});











