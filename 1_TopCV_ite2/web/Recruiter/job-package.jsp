<%-- 
    Document   : job-package
    Created on : Oct 15, 2025, 7:22:26 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gói Đăng Tin - RecruitPro</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Reset and Base Styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f7fa;
                color: #333;
                line-height: 1.6;
            }

            /* Navigation Bar */
            :root {
                --bg-dark-1: #031428;   /* Very dark left */
                --bg-dark-2: #062446;   /* Mid */
                --bg-bright: #0a67ff;   /* Bright right */
            }

            .navbar {
                background: linear-gradient(110deg, var(--bg-dark-1) 0%, var(--bg-dark-2) 40%, #083d9a 70%, var(--bg-bright) 100%);
                color: white;
                padding: 0;
                box-shadow: 0 4px 20px rgba(0,0,0,0.15);
                position: sticky;
                top: 0;
                z-index: 1000;
                backdrop-filter: blur(10px);
                border-bottom: 1px solid rgba(255,255,255,0.1);
            }

            .nav-container {
                max-width: 1400px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 25px;
                height: 70px;
            }

            .nav-left {
                display: flex;
                align-items: center;
                gap: 15px;
                flex: 1;
            }

            .logo {
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 24px;
                font-weight: 700;
                text-shadow: 0 2px 4px rgba(0,0,0,0.3);
                transition: transform 0.3s ease;
            }

            .logo:hover {
                transform: scale(1.05);
            }

            .logo i {
                font-size: 28px;
                background: linear-gradient(45deg, #0a67ff, #ffffff);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
                filter: drop-shadow(0 2px 4px rgba(0,0,0,0.3));
            }

            .nav-menu {
                display: flex;
                list-style: none;
                gap: 12px;
                align-items: center;
                flex-wrap: nowrap;
            }

            .nav-menu a {
                color: white;
                text-decoration: none;
                padding: 8px 12px;
                border-radius: 4px;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
                font-weight: 500;
                position: relative;
                overflow: hidden;
                white-space: nowrap;
                font-size: 13px;
            }

            .nav-menu a::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
                transition: left 0.5s;
            }

            .nav-menu a:hover::before {
                left: 100%;
            }

            .nav-menu a:hover {
                background: rgba(255,255,255,0.1);
                transform: translateY(-2px);
            }

            .nav-menu a.active {
                background: rgba(255,255,255,0.15);
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            }

            .dropdown {
                position: relative;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                top: 100%;
                left: 0;
                background: white;
                min-width: 200px;
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
                border-radius: 8px;
                z-index: 1000;
                padding: 8px 0;
                margin-top: 5px;
            }

            .dropdown:hover .dropdown-content {
                display: block;
            }

            .dropdown-content a {
                color: #374151;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
                transition: all 0.2s ease;
                font-size: 14px;
            }

            .dropdown-content a:hover {
                background: #f3f4f6;
                color: #1f2937;
            }

            .nav-right {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .nav-icons {
                display: flex;
                align-items: center;
                gap: 20px;
            }

            .nav-icons i {
                color: #6b7280;
                font-size: 18px;
                margin-left: 16px;
                cursor: pointer;
                transition: color 0.2s ease;
            }

            .nav-icons i:hover {
                color: #374151;
            }

            .user-dropdown {
                position: relative;
            }

            .user-avatar {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                overflow: hidden;
                cursor: pointer;
                transition: transform 0.2s ease;
            }

            .user-avatar:hover {
                transform: scale(1.05);
            }

            .avatar-img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .user-menu {
                right: 0;
                left: auto;
                min-width: 280px;
            }

            .user-header {
                display: flex;
                align-items: center;
                padding: 16px;
                border-bottom: 1px solid #e5e7eb;
                gap: 12px;
            }

            .user-header i {
                font-size: 24px;
                color: #6b7280;
            }

            .user-info {
                flex: 1;
            }

            .user-name {
                font-weight: 600;
                color: #1f2937;
                font-size: 14px;
            }

            .close-menu {
                cursor: pointer;
                color: #9ca3af;
            }

            .menu-section {
                padding: 8px 0;
            }

            .section-title {
                font-size: 12px;
                font-weight: 600;
                color: #6b7280;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                padding: 8px 16px;
                margin-bottom: 4px;
            }

            .menu-item {
                display: flex;
                align-items: center;
                gap: 12px;
                padding: 10px 16px;
                color: #374151;
                text-decoration: none;
                transition: all 0.2s ease;
                font-size: 14px;
            }

            .menu-item:hover {
                background: #f3f4f6;
                color: #1f2937;
            }

            .menu-item i {
                width: 16px;
                text-align: center;
                color: #6b7280;
            }

            .menu-footer {
                border-top: 1px solid #e5e7eb;
                padding: 8px 0;
            }

            .logout-item {
                color: #dc2626 !important;
            }

            .logout-item:hover {
                background: #fef2f2 !important;
            }

            /* Job Packages Page Styles */
            .job-packages-page {
                background-color: #f8f9fa;
                min-height: 100vh;
            }

            /* Tab Navigation */
            .tab-navigation {
                background: white;
                border-bottom: 1px solid #e5e7eb;
                padding: 0 20px;
            }

            .tab-container {
                max-width: 1400px;
                margin: 0 auto;
                display: flex;
                gap: 0;
            }

            .tab-item {
                padding: 20px 30px;
                cursor: pointer;
                font-weight: 600;
                font-size: 16px;
                color: #6b7280;
                border-bottom: 2px solid transparent;
                transition: all 0.3s ease;
                position: relative;
            }

            .tab-item.active {
                color: #1e40af;
                border-bottom-color: #1e40af;
            }

            .tab-item:hover {
                color: #1e40af;
            }

            .tab-content {
                display: none;
            }

            .tab-content.active {
                display: block;
            }

            .packages-main {
                padding: 20px 0;
                min-height: calc(100vh - 70px);
            }

            .packages-container {
                max-width: 1400px;
                margin: 0 auto;
                display: grid;
                grid-template-columns: 350px 1fr;
                gap: 30px;
                padding: 0 20px;
            }

            /* Left Sidebar */
            .packages-sidebar {
                background: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                height: fit-content;
                position: sticky;
                top: 90px;
            }

            .sidebar-section {
                margin-bottom: 30px;
            }

            .sidebar-section h3 {
                font-size: 16px;
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 15px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .package-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                margin-bottom: 12px;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .package-item.selected {
                border-color: #3b82f6;
                background-color: #eff6ff;
            }

            .package-item:hover {
                border-color: #3b82f6;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(59, 130, 246, 0.15);
            }

            .package-info h4 {
                font-size: 14px;
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 5px;
                line-height: 1.4;
            }

            .package-price {
                font-size: 16px;
                font-weight: 700;
                color: #dc2626;
            }

            .package-badge {
                background: #3b82f6;
                color: white;
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
                margin: 5px 0;
            }

            .add-to-cart-btn {
                background: #f3f4f6;
                border: none;
                border-radius: 6px;
                padding: 8px 12px;
                color: #6b7280;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .add-to-cart-btn:hover {
                background: #3b82f6;
                color: white;
            }

            .add-to-cart-btn.in-cart {
                background: transparent;
                color: inherit;
                padding: 0;
                border: none;
            }

            .add-to-cart-btn.in-cart .quantity-spinner {
                border: 1px solid #d1d5db;
                border-radius: 20px;
                background: white;
                overflow: hidden;
                display: flex;
                align-items: center;
                width: fit-content;
            }

            .add-to-cart-btn.in-cart .quantity-spinner button {
                width: 32px;
                height: 32px;
                border: none;
                background: white;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                color: #374151;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .add-to-cart-btn.in-cart .quantity-spinner button:hover {
                background: #f3f4f6;
            }

            .add-to-cart-btn.in-cart .quantity-display {
                width: 50px;
                height: 32px;
                border: none;
                text-align: center;
                font-weight: 600;
                color: #1f2937;
                background: white;
                outline: none;
                font-size: 14px;
            }

            .add-to-cart-main-btn.in-cart {
                background: transparent;
                border: none;
                padding: 0;
            }

            .add-to-cart-main-btn.in-cart .quantity-spinner {
                border: 1px solid #d1d5db;
                border-radius: 20px;
                background: white;
                overflow: hidden;
                display: flex;
                align-items: center;
                width: fit-content;
            }

            .add-to-cart-main-btn.in-cart .quantity-spinner button {
                width: 32px;
                height: 32px;
                border: none;
                background: white;
                cursor: pointer;
                font-size: 16px;
                font-weight: 600;
                color: #374151;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .add-to-cart-main-btn.in-cart .quantity-spinner button:hover {
                background: #f3f4f6;
            }

            .add-to-cart-main-btn.in-cart .quantity-display {
                width: 50px;
                height: 32px;
                border: none;
                text-align: center;
                font-weight: 600;
                color: #1f2937;
                background: white;
                outline: none;
                font-size: 14px;
            }

            .support-services {
                max-height: 400px;
                overflow-y: auto;
                padding-right: 10px;
            }

            .support-services::-webkit-scrollbar {
                width: 6px;
            }

            .support-services::-webkit-scrollbar-track {
                background: #f1f5f9;
                border-radius: 3px;
            }

            .support-services::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 3px;
            }

            /* Right Main Content */
            .packages-content {
                background: white;
                border-radius: 12px;
                padding: 30px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }

            .product-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                padding-bottom: 20px;
                border-bottom: 1px solid #e5e7eb;
            }

            .product-header h2 {
                font-size: 24px;
                font-weight: 700;
                color: #1f2937;
            }

            .product-price {
                font-size: 20px;
                font-weight: 700;
                color: #dc2626;
            }

            .warning-message {
                background: #fef3c7;
                border: 1px solid #f59e0b;
                border-radius: 6px;
                padding: 12px 16px;
                margin-top: 15px;
                display: flex;
                align-items: center;
                gap: 10px;
                color: #92400e;
                font-size: 14px;
                font-weight: 500;
            }

            .warning-message i {
                color: #f59e0b;
                font-size: 16px;
            }

            .product-description,
            .product-includes {
                margin-bottom: 30px;
            }

            .product-description h3,
            .product-includes h3 {
                font-size: 18px;
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 15px;
            }

            .product-description p {
                color: #4b5563;
                line-height: 1.6;
                font-size: 15px;
            }

            .product-includes ul {
                list-style: none;
                padding: 0;
            }

            .product-includes li {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
                color: #4b5563;
                font-size: 15px;
            }

            .product-includes li i {
                color: #10b981;
                margin-right: 12px;
                font-size: 16px;
            }

            /* Product Preview */
            .product-preview {
                margin-bottom: 30px;
            }

            .product-preview h3 {
                font-size: 18px;
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 20px;
            }

            .preview-container {
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                overflow: hidden;
                background: #f9fafb;
            }

            .search-bar {
                background: #3b82f6;
                padding: 15px 20px;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .search-bar i {
                color: white;
                font-size: 18px;
                cursor: pointer;
            }

            .search-input {
                background: white;
                border-radius: 6px;
                padding: 8px 12px;
                display: flex;
                align-items: center;
                gap: 8px;
                flex: 1;
            }

            .search-input i {
                color: #6b7280;
                font-size: 14px;
            }

            .search-input span {
                color: #6b7280;
                font-size: 14px;
            }

            .preview-tabs {
                display: flex;
                background: white;
                border-bottom: 1px solid #e5e7eb;
            }

            .tab {
                padding: 12px 20px;
                cursor: pointer;
                color: #6b7280;
                font-weight: 500;
                border-bottom: 2px solid transparent;
                transition: all 0.2s ease;
            }

            .tab.active {
                color: #3b82f6;
                border-bottom-color: #3b82f6;
            }

            .job-listings {
                background: white;
                padding: 20px;
            }

            .job-item {
                display: flex;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #f3f4f6;
                gap: 15px;
            }

            .job-item:last-child {
                border-bottom: none;
            }

            .company-logo {
                width: 40px;
                height: 40px;
                border-radius: 8px;
                background: #3b82f6;
                color: white;
                display: flex;
                align-items: center;
                justify-content: center;
                font-weight: 700;
                font-size: 14px;
            }

            .job-info {
                flex: 1;
            }

            .job-title {
                display: flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 5px;
            }

            .job-title span:first-child {
                font-weight: 600;
                color: #1f2937;
                font-size: 15px;
            }

            .hot-tag {
                background: #dc2626;
                color: white;
                padding: 2px 8px;
                border-radius: 4px;
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
            }

            .company-name {
                color: #6b7280;
                font-size: 13px;
                margin-bottom: 3px;
            }

            .job-location {
                color: #6b7280;
                font-size: 13px;
                margin-bottom: 3px;
            }

            .job-salary {
                color: #059669;
                font-weight: 600;
                font-size: 13px;
            }

            .job-actions {
                color: #d1d5db;
                cursor: pointer;
                transition: color 0.2s ease;
            }

            .job-actions:hover {
                color: #dc2626;
            }

            .discount-link {
                text-align: center;
                padding: 15px;
                border-top: 1px solid #e5e7eb;
            }

            .discount-link a {
                color: #3b82f6;
                text-decoration: none;
                font-weight: 500;
            }

            .discount-link a:hover {
                text-decoration: underline;
            }

            .add-to-cart-section {
                text-align: right;
                margin-top: 20px;
            }

            .add-to-cart-main-btn {
                background: #f97316;
                color: white;
                border: 1px solid #f97316;
                padding: 12px 30px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .add-to-cart-main-btn:hover {
                background: #ea580c;
                border-color: #ea580c;
            }

            /* Footer */
            .packages-footer {
                background: #f3f4f6;
                border-top: 1px solid #e5e7eb;
                padding: 20px 0;
                position: sticky;
                bottom: 0;
                z-index: 100;
            }

            .footer-content {
                max-width: 1400px;
                margin: 0 auto;
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0 20px;
            }

            .total-section {
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .total-label {
                color: #6b7280;
                font-weight: 500;
            }

            .total-amount {
                color: #1f2937;
                font-weight: 700;
                font-size: 18px;
            }

            .footer-actions {
                display: flex;
                gap: 15px;
            }

            .clear-btn {
                background: white;
                color: #6b7280;
                border: 1px solid #d1d5db;
                padding: 10px 20px;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .clear-btn:hover {
                background: #f9fafb;
                border-color: #9ca3af;
            }

            .checkout-btn {
                background: #f97316;
                color: white;
                border: 1px solid #f97316;
                padding: 10px 25px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .checkout-btn:hover {
                background: #ea580c;
                border-color: #ea580c;
            }

            /* Cart Styles */
            .cart-section {
                background: white;
                border-radius: 12px;
                padding: 25px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                margin-bottom: 20px;
            }

            .cart-section h3 {
                font-size: 16px;
                font-weight: 700;
                color: #1f2937;
                margin-bottom: 15px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .cart-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px;
                border: 1px solid #e5e7eb;
                border-radius: 8px;
                margin-bottom: 12px;
                background: #f9fafb;
            }

            .cart-item-info h4 {
                font-size: 14px;
                font-weight: 600;
                color: #1f2937;
                margin-bottom: 5px;
            }

            .cart-item-price {
                font-size: 14px;
                font-weight: 700;
                color: #dc2626;
                margin-bottom: 10px;
            }

            .quantity-controls {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .quantity-btn {
                width: 24px;
                height: 24px;
                border: 1px solid #d1d5db;
                background: white;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 12px;
                font-weight: 600;
                color: #374151;
            }

            .quantity-btn:hover {
                background: #f3f4f6;
                border-color: #9ca3af;
            }

            .quantity {
                min-width: 20px;
                text-align: center;
                font-weight: 600;
                color: #1f2937;
            }

            .remove-btn {
                background: #fef2f2;
                border: 1px solid #fecaca;
                border-radius: 6px;
                padding: 8px;
                color: #dc2626;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .remove-btn:hover {
                background: #fee2e2;
                border-color: #fca5a5;
            }

            .empty-cart {
                text-align: center;
                color: #6b7280;
                font-style: italic;
                padding: 20px;
            }

            .cart-count {
                background: #dc2626;
                color: white;
                border-radius: 50%;
                padding: 2px 6px;
                font-size: 10px;
                font-weight: 600;
                margin-left: 5px;
            }

            /* Cart Dropdown */
            .cart-dropdown {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 2000;
                display: none;
            }

            .cart-dropdown-content {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                border-radius: 12px;
                padding: 25px;
                max-width: 500px;
                width: 90%;
                max-height: 80vh;
                overflow-y: auto;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            }

            .cart-dropdown h3 {
                margin-bottom: 20px;
                color: #1f2937;
                font-size: 18px;
            }

            .cart-dropdown-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px 0;
                border-bottom: 1px solid #e5e7eb;
            }

            .cart-dropdown-item:last-child {
                border-bottom: none;
            }

            .item-info h4 {
                font-size: 14px;
                color: #1f2937;
                margin-bottom: 5px;
            }

            .item-price {
                font-size: 14px;
                color: #dc2626;
                font-weight: 600;
            }

            .item-controls {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .quantity-spinner {
                display: flex;
                align-items: center;
                border: 1px solid #d1d5db;
                border-radius: 20px;
                background: white;
                overflow: hidden;
                width: fit-content;
            }

            .quantity-spinner button {
                width: 32px;
                height: 32px;
                border: none;
                background: white;
                cursor: pointer;
                font-size: 18px;
                font-weight: 600;
                color: #374151;
                display: flex;
                align-items: center;
                justify-content: center;
                min-width: 32px;
            }

            .quantity-spinner button:hover {
                background: #f3f4f6;
            }

            .quantity-spinner .quantity-display {
                width: 50px;
                height: 32px;
                border: none;
                text-align: center;
                font-weight: 600;
                color: #1f2937;
                background: white;
                outline: none;
            }

            .remove-btn {
                background: none;
                border: none;
                cursor: pointer;
                color: #6b7280;
                font-size: 18px;
                padding: 8px;
                border-radius: 4px;
                transition: all 0.2s ease;
            }

            .remove-btn:hover {
                color: #dc2626;
                background: #fef2f2;
            }

            .cart-dropdown-total {
                margin: 20px 0;
                padding: 15px;
                background: #f9fafb;
                border-radius: 8px;
                text-align: center;
                font-size: 16px;
            }

            .cart-dropdown-actions {
                display: flex;
                gap: 15px;
                justify-content: flex-end;
            }

            .cart-dropdown-actions button {
                padding: 10px 20px;
                border-radius: 6px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .cart-dropdown-actions .close-btn {
                background: #f3f4f6;
                color: #374151;
                border: 1px solid #d1d5db;
            }

            .cart-dropdown-actions .close-btn:hover {
                background: #e5e7eb;
            }

            .cart-dropdown-actions .checkout-btn {
                background: #f97316;
                color: white;
                border: 1px solid #f97316;
            }

            .cart-dropdown-actions .checkout-btn:hover {
                background: #ea580c;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .packages-container {
                    grid-template-columns: 1fr;
                    gap: 20px;
                }

                .packages-sidebar {
                    position: static;
                }

                .nav-menu {
                    display: none;
                }
            }
        </style>
    </head>
    <body class="job-packages-page">
        <!-- Top Navigation Bar -->
        <nav class="navbar">
            <div class="nav-container">
                <div class="nav-left">
                    <div class="logo">
                        <i class="fas fa-briefcase"></i>
                        <span>RecruitPro</span>
                    </div>
                    <ul class="nav-menu">
                        <li><a href="<%= request.getContextPath() %>/Recruiter/index.jsp">Dashboard</a></li>
                        <li><a href="#">Việc Làm</a></li>
                        <li class="dropdown">
                            <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="#">Quản lý theo việc đăng tuyển</a>
                                <a href="candidate-folder.html">Quản lý theo thư mục và thẻ</a>
                            </div>
                        </li>
                        <li class="dropdown">
                            <a href="#">Onboarding <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="#">Quy trình onboarding</a>
                                <a href="#">Tài liệu hướng dẫn</a>
                            </div>
                        </li>
                        <li class="dropdown">
                            <a href="#">Đơn hàng <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="#">Quản lý đơn hàng</a>
                                <a href="#">Lịch sử mua</a>
                            </div>
                        </li>
                        <li><a href="#">Báo cáo</a></li>
                        <li><a href="job-packages.html" class="active">Đăng Tuyển Dụng</a></li>
                        <li><a href="${pageContext.request.contextPath}/candidate-search">Tìm Ứng Viên</a></li>
                        <li><a href="shopping-cart.html" class="btn btn-red">Mua</a></li>
                    </ul>
                </div>
                <div class="nav-right">
                    <div class="nav-icons">
                        <i class="fas fa-bell"></i>
                        <i class="fas fa-shopping-cart"></i>
                        <div class="dropdown user-dropdown">
                            <div class="user-avatar">
                                <img src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIHZpZXdCb3g9IjAgMCA0MCA0MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGNpcmNsZSBjeD0iMjAiIGN5PSIyMCIgcj0iMjAiIGZpbGw9IiNGNUY3RkEiLz4KPHN2ZyB4PSIxMCIgeT0iMTAiIHdpZHRoPSIyMCIgaGVpZ2h0PSIyMCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOUNBM0FGIi8+CjxwYXRoIGQ9Ik0xMiAxNEM5LjMzIDE0IDcgMTYuMzMgNyAxOVYyMUgxN1YxOUMxNyAxNi4zMyAxNC42NyAxNCAxMiAxNFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+Cjwvc3ZnPgo=" alt="User Avatar" class="avatar-img">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <main class="packages-main">
            <% if (Boolean.TRUE.equals(request.getAttribute("debug"))) { %>
            <div style="max-width:1400px;margin:10px auto 0; padding:10px 15px; background:#FFF7ED; border:1px solid #FDBA74; color:#9A3412; border-radius:8px;">
                <strong>DEBUG:</strong>
                type=<%= request.getAttribute("debug_selected_type") %> |
                <%= request.getAttribute("debug_counts") %>
            </div>
            <% } %>
            <!-- Navigation Tabs -->
            <div class="tab-navigation">
                <div class="tab-container">
                    <% String selectedType = (String) request.getAttribute("selectedType"); if (selectedType == null || selectedType.isEmpty()) { selectedType = "DANG_TUYEN"; } String ctx = request.getContextPath(); %>
                    <a class="tab-item <%= "DANG_TUYEN".equals(selectedType) ? "active" : "" %>" href="<%= ctx %>/recruiter/job-packages?type=DANG_TUYEN">
                        <span>ĐĂNG TUYỂN</span>
                    </a>
                    <a class="tab-item <%= "TIM_HO_SO".equals(selectedType) ? "active" : "" %>" href="<%= ctx %>/recruiter/job-packages?type=TIM_HO_SO">
                        <span>TÌM HỒ SƠ</span>
                    </a>
                    <a class="tab-item <%= "AI_PREMIUM".equals(selectedType) ? "active" : "" %>" href="<%= ctx %>/recruiter/job-packages?type=AI_PREMIUM">
                        <span>AI PREMIUM</span>
                    </a>
                </div>
            </div>

            <div class="packages-container">
                <!-- Left Sidebar -->
                <div class="packages-sidebar">
                    <!-- ĐĂNG TUYỂN Tab Content -->
                    <div class="tab-content <%= "DANG_TUYEN".equals(selectedType) ? "active" : "" %>" id="dang-tuyen">
                        <div class="sidebar-section">
                            <h3>ĐĂNG TUYỂN</h3>
                            <% java.util.List<model.JobPackage> dangTuyen = (java.util.List<model.JobPackage>) request.getAttribute("dangTuyen"); %>
                            <% if (dangTuyen != null && !dangTuyen.isEmpty()) { for (int i = 0; i < dangTuyen.size(); i++) { model.JobPackage p = dangTuyen.get(i); %>
                            <div class="package-item <%= i==0 ? "selected" : "" %>" data-price-raw="<%= p.getPrice()==null?"0":p.getPrice().toPlainString() %>" data-package-id="<%= p.getPackageID() %>">
                                <div class="package-info">
                                    <h4><%= p.getPackageName() %></h4>
                                    <div class="package-price"><%
                                        String priceStr1 = (p.getPrice() == null) ? "0" : java.text.NumberFormat.getNumberInstance(new java.util.Locale("vi","VN")).format(p.getPrice());
                                        out.print(priceStr1 + " VND");
                                    %></div>
                                    <span class="hidden-desc" style="display:none;"><%= p.getDescription()==null?"":p.getDescription() %></span>
                                    <span class="hidden-features" style="display:none;"><%= p.getFeatures()==null?"":p.getFeatures() %></span>
                                </div>
                                <button class="add-to-cart-btn">
                                    <i class="fas fa-shopping-cart"></i>
                                </button>
                            </div>
                            <% } %>
                            <% } else { %>
                            <div class="package-item">
                                <div class="package-info">
                                    <h4>Không có gói nào</h4>
                                    <div class="package-price">0 VND</div>
                                </div>
                            </div>
                            <% } %>
                        </div>

                        <div class="sidebar-section">
                            <h3>DỊCH VỤ HỖ TRỢ</h3>
                            <div class="support-services">
                                <% java.util.List<model.JobPackage> supportServices = (java.util.List<model.JobPackage>) request.getAttribute("supportServices"); %>
                                <% if (supportServices != null && !supportServices.isEmpty()) { for (model.JobPackage p : supportServices) { %>
                                <div class="package-item" data-price-raw="<%= p.getPrice()==null?"0":p.getPrice().toPlainString() %>" data-package-id="<%= p.getPackageID() %>">
                                    <div class="package-info">
                                        <h4><%= p.getPackageName() %></h4>
                                        <div class="package-price"><%
                                            String priceStr2 = (p.getPrice() == null) ? "0" : java.text.NumberFormat.getNumberInstance(new java.util.Locale("vi","VN")).format(p.getPrice());
                                            out.print(priceStr2 + " VND");
                                        %></div>
                                        <span class="hidden-desc" style="display:none;"><%= p.getDescription()==null?"":p.getDescription() %></span>
                                        <span class="hidden-features" style="display:none;"><%= p.getFeatures()==null?"":p.getFeatures() %></span>
                                    </div>
                                    <button class="add-to-cart-btn">
                                        <i class="fas fa-shopping-cart"></i>
                                    </button>
                                </div>
                                <% } %>
                                <% } else { %>
                                <div class="package-item">
                                    <div class="package-info">
                                        <h4>Không có dịch vụ hỗ trợ</h4>
                                        <div class="package-price">0 VND</div>
                                    </div>
                                </div>
                                <% } %>
                                    </div>
                        </div>
                    </div>

                    <!-- TÌM HỒ SƠ Tab Content -->
                    <div class="tab-content <%= "TIM_HO_SO".equals(selectedType) ? "active" : "" %>" id="tim-ho-so">
                        <div class="sidebar-section">
                            <h3>TÌM HỒ SƠ</h3>
                            <% java.util.List<model.JobPackage> timHoSo = (java.util.List<model.JobPackage>) request.getAttribute("timHoSo"); %>
                            <% if (timHoSo != null && !timHoSo.isEmpty()) { for (model.JobPackage p : timHoSo) { %>
                            <div class="package-item" data-price-raw="<%= p.getPrice()==null?"0":p.getPrice().toPlainString() %>" data-package-id="<%= p.getPackageID() %>">
                                <div class="package-info">
                                    <h4><%= p.getPackageName() %></h4>
                                    <% if (p.getPoints() != null) { %>
                                    <div class="package-badge"><%= p.getPoints() %> điểm</div>
                                    <% } %>
                                    <div class="package-price"><%
                                        String priceStr3 = (p.getPrice() == null) ? "0" : java.text.NumberFormat.getNumberInstance(new java.util.Locale("vi","VN")).format(p.getPrice());
                                        out.print(priceStr3 + " VND");
                                    %></div>
                                    <span class="hidden-desc" style="display:none;"><%= p.getDescription()==null?"":p.getDescription() %></span>
                                    <span class="hidden-features" style="display:none;"><%= p.getFeatures()==null?"":p.getFeatures() %></span>
                                </div>
                                <button class="add-to-cart-btn">
                                    <i class="fas fa-shopping-cart"></i>
                                </button>
                            </div>
                            <% } %>
                            <% } else { %>
                            <div class="package-item">
                                <div class="package-info">
                                    <h4>Không có gói Tìm Hồ Sơ</h4>
                                    <div class="package-price">0 VND</div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <!-- AI PREMIUM Tab Content -->
                    <div class="tab-content <%= "AI_PREMIUM".equals(selectedType) ? "active" : "" %>" id="ai-premium">
                        <div class="sidebar-section">
                            <h3>AI PREMIUM</h3>
                            <% java.util.List<model.JobPackage> aiPremium = (java.util.List<model.JobPackage>) request.getAttribute("aiPremium"); %>
                            <% if (aiPremium != null && !aiPremium.isEmpty()) { for (model.JobPackage p : aiPremium) { %>
                            <div class="package-item" data-price-raw="<%= p.getPrice()==null?"0":p.getPrice().toPlainString() %>" data-package-id="<%= p.getPackageID() %>">
                                <div class="package-info">
                                    <h4><%= p.getPackageName() %></h4>
                                    <div class="package-price"><%
                                        String priceStr4 = (p.getPrice() == null) ? "0" : java.text.NumberFormat.getNumberInstance(new java.util.Locale("vi","VN")).format(p.getPrice());
                                        out.print(priceStr4 + " VND");
                                    %></div>
                                    <span class="hidden-desc" style="display:none;"><%= p.getDescription()==null?"":p.getDescription() %></span>
                                    <span class="hidden-features" style="display:none;"><%= p.getFeatures()==null?"":p.getFeatures() %></span>
                                </div>
                                <button class="add-to-cart-btn">
                                    <i class="fas fa-shopping-cart"></i>
                                </button>
                            </div>
                            <% } %>
                            <% } else { %>
                            <div class="package-item">
                                <div class="package-info">
                                    <h4>Không có gói AI Premium</h4>
                                    <div class="package-price">0 VND</div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Right Main Content -->
                <div class="packages-content">
                    <!-- Product Details -->
                    <div class="product-details">
                        <div class="product-header">
                            <h2 id="pd-title">Chọn gói để xem chi tiết</h2>
                            <div class="product-price" id="pd-price">0 VND</div>
                        </div>

                        <div class="product-description">
                            <h3>Mô tả sản phẩm</h3>
                            <p id="pd-desc">Hãy chọn một gói ở cột trái để xem mô tả và quyền lợi.</p>
                        </div>

                        <div class="product-includes">
                            <h3>Bao gồm</h3>
                            <ul>
                                <li><i class="fas fa-check"></i> Nhận ngay hồ sơ ứng tuyển chất lượng.</li>
                                <li><i class="fas fa-check"></i> Dễ dàng đăng tuyển chỉ trong vài phút.</li>
                                <li><i class="fas fa-check"></i> Tăng khả năng nhận diện trên ứng dụng di động.</li>
                            </ul>
                        </div>

                        <!-- Bỏ phần hiển thị VietnamWorks preview theo yêu cầu -->

                        <div class="add-to-cart-section">
                            <button class="add-to-cart-main-btn">
                                Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="packages-footer">
            <div class="footer-content">
                <div class="total-section">
                    <span class="total-label">TỔNG (kèm 8% VAT):</span>
                    <span class="total-amount">0 VND</span>
                </div>
                <div class="footer-actions">
                    <button class="clear-btn">Xoá hết</button>
                    <form id="vnpayForm" action="<%= request.getContextPath() %>/payment" method="post" style="display:inline;">
                        <input type="hidden" name="amount" id="vnp_amount" value="">
                        <input type="hidden" name="orderInfo" id="vnp_orderInfo" value="">
                        <button type="button" class="checkout-btn" id="btnCheckout">Thanh toán</button>
                    </form>
                </div>
            </div>
        </footer>

        <script>
            // Dữ liệu tham khảo (hiển thị demo UI)
            const packages = {
                'dang-tuyen-30-ngay-m': {
                    title: 'Đăng Tuyển 30-ngày - M',
                    price: '2.160.000 VND',
                    description: 'Là sự kết hợp của các dịch vụ đăng tuyển cơ bản trên trang web vietnamworks.com và ứng dụng di động VietnamWorks. Trên trang web, tin đăng tuyển được hiển thị dưới dạng cơ bản, trong khi trên ứng dụng di động, tin đăng tuyển được đính kèm tag "HOT" và được hiển thị ở khu vực nổi bật trong suốt 30 ngày.',
                    includes: [
                        'Nhận ngay hồ sơ ứng tuyển chất lượng.',
                        'Dễ dàng đăng tuyển chỉ trong vài phút.',
                        'Tăng khả năng nhận diện trên ứng dụng di động.'
                    ]
                },
                'dang-tuyen-30-ngay-co-ban': {
                    title: 'Đăng Tuyển 30-ngày - Cơ Bản',
                    price: '1.953.000 VND',
                    description: 'Tiếp cận gần 5 triệu người truy cập vào website vietnamworks.com mỗi tháng. Có cơ hội được gửi trực tiếp đến ứng viên qua 300.000 email thông báo việc làm mỗi ngày. Là sản phẩm cơ bản nhất giúp tin đăng tuyển của công ty sẽ được hiển thị ngay lập tức trên trang web vietnamworks.com trong 30 ngày.',
                    includes: [
                        'Nhận ngay hồ sơ ứng tuyển chất lượng',
                        'Dễ dàng đăng tuyển chỉ trong vài phút',
                        'Mở rộng tìm kiếm ứng viên hiệu quả trên máy tính và các thiết bị di động'
                    ]
                },
                'uu-tien-hang-dau-30-ngay-m': {
                    title: 'Thêm - Ưu Tiên Hàng Đầu 30 ngày - M',
                    price: '5.805.000 VND',
                    description: 'Là sự kết hợp hiển thị ưu tiên tin tuyển dụng trên cả trang website và ứng dụng di động của VietnamWorks, bao gồm: Trên trang web: Tin tuyển dụng được hiển thị ưu tiên ở vị trí hàng đầu trên trang kết quả tìm kiếm theo nhóm ngành nghề, nghề nghiệp chuyên môn và lĩnh vực kinh doanh của công ty trong 30 ngày. Trên ứng dụng di động: Tin tuyển dụng được đính kèm tag "TOP" và được hiển thị ở khu vực ưu tiên trong suốt 30 ngày trên Trang Kết Quả Tìm Kiếm cũng như mục Việc Làm Nổi Bật. Giúp thu hút nhiều sự chú ý của ứng viên hơn từ đó gia tăng lượt xem tin tuyển dụng. Giữ cho tin đăng tuyển luôn ở trong khu vực ưu tiên đầu Trang Kết Quả Tìm Kiếm để thu hút lượt ứng tuyển của ứng viên. Cạnh tranh với các công ty tuyển dụng cùng nhóm ngành nghề, nghề nghiệp chuyên môn hoặc cùng lĩnh vực kinh doanh của công ty và gia tăng mức độ nhận biết thương hiệu.',
                    includes: [
                        'Trên ứng dụng di động: Tin tuyển dụng được đính kèm tag "TOP" và được hiển thị ở khu vực ưu tiên trong suốt 30 ngày trên Trang Kết Quả Tìm Kiếm cũng như mục Việc Làm Nổi Bật.',
                        'Trên trang web: Tin tuyển dụng được hiển thị ưu tiên ở vị trí hàng đầu trên trang kết quả tìm kiếm theo nhóm ngành nghề, nghề nghiệp chuyên môn và lĩnh vực kinh doanh của công ty trong 30 ngày.'
                    ]
                },
                'uu-tien-hang-dau-15-ngay-m': {
                    title: 'Thêm - Ưu Tiên Hàng Đầu 15 ngày - M',
                    price: '4.392.000 VND',
                    description: 'Là sự kết hợp hiển thị ưu tiên tin tuyển dụng trên cả trang website và ứng dụng di động của VietnamWorks, bao gồm: Trên trang web: Tin tuyển dụng được hiển thị ưu tiên ở vị trí hàng đầu trên trang kết quả tìm kiếm theo nhóm ngành nghề, nghề nghiệp chuyên môn và lĩnh vực kinh doanh của công ty trong 15 ngày. Trên ứng dụng di động: Tin tuyển dụng được đính kèm tag "TOP" và được hiển thị ở khu vực ưu tiên trong suốt 15 ngày trên Trang Kết Quả Tìm Kiếm cũng như mục Việc Làm Nổi Bật. Giúp thu hút nhiều sự chú ý của ứng viên hơn từ đó gia tăng lượt xem tin tuyển dụng. Giữ cho tin đăng tuyển luôn ở trong khu vực ưu tiên đầu Trang Kết Quả Tìm Kiếm để thu hút lượt ứng tuyển của ứng viên. Cạnh tranh với các công ty tuyển dụng cùng nhóm ngành nghề, nghề nghiệp chuyên môn hoặc cùng lĩnh vực kinh doanh của công ty và gia tăng mức độ nhận biết thương hiệu.',
                    includes: [
                        'Trên ứng dụng di động: Tin tuyển dụng được đính kèm tag "TOP" và được hiển thị ở khu vực ưu tiên trong suốt 15 ngày trên Trang Kết Quả Tìm Kiếm cũng như mục Việc Làm Nổi Bật.',
                        'Trên trang web: Tin tuyển dụng được hiển thị ưu tiên ở vị trí hàng đầu trên trang kết quả tìm kiếm theo nhóm ngành nghề, nghề nghiệp chuyên môn và lĩnh vực kinh doanh của công ty trong 15 ngày.'
                    ]
                },
                'uu-tien-hang-dau-30-ngay': {
                    title: 'Thêm - Ưu Tiên Hàng Đầu 30 ngày',
                    price: '5.085.000 VND',
                    description: 'Tin tuyển dụng được hiển thị ưu tiên ở vị trí hàng đầu trên trang kết quả tìm kiếm theo 3 tiêu chí: nhóm ngành nghề, nghề nghiệp chuyên môn và lĩnh vực kinh doanh của công ty trong 30 ngày. Giúp thu hút nhiều sự chú ý của ứng viên hơn từ đó gia tăng lượt xem tin tuyển dụng. Giữ cho tin đăng tuyển luôn ở trong khu vực ưu tiên đầu Trang Kết Quả Tìm Kiếm để thu hút lượt ứng tuyển của ứng viên. Cạnh tranh với các công ty tuyển dụng cùng nhóm ngành nghề, nghề nghiệp chuyên môn hoặc cùng lĩnh vực kinh doanh của công ty và gia tăng mức độ nhận biết thương hiệu.',
                    includes: [
                        'Tin tuyển dụng được hiển thị ưu tiên ở vị trí hàng đầu trên trang kết quả tìm kiếm theo 3 tiêu chí: nhóm ngành nghề, nghề nghiệp chuyên môn và lĩnh vực kinh doanh của công ty trong 30 ngày.'
                    ]
                },
                'uu-tien-hang-dau-15-ngay': {
                    title: 'Thêm - Ưu Tiên Hàng Đầu 15 ngày',
                    price: '3.924.000 VND',
                    description: 'Tin tuyển dụng được hiển thị ưu tiên ở vị trí hàng đầu trên trang kết quả tìm kiếm theo 3 tiêu chí: nhóm ngành nghề, nghề nghiệp chuyên môn và lĩnh vực kinh doanh của công ty trong 15 ngày. Giúp thu hút nhiều sự chú ý của ứng viên hơn từ đó gia tăng lượt xem tin tuyển dụng. Giữ cho tin đăng tuyển luôn ở trong khu vực ưu tiên đầu Trang Kết Quả Tìm Kiếm để thu hút lượt ứng tuyển của ứng viên. Cạnh tranh với các công ty tuyển dụng cùng nhóm ngành nghề, nghề nghiệp chuyên môn hoặc cùng lĩnh vực kinh doanh của công ty và gia tăng mức độ nhận biết thương hiệu.',
                    includes: [
                        'Tin tuyển dụng được hiển thị ưu tiên ở vị trí hàng đầu trên trang kết quả tìm kiếm theo 3 tiêu chí: nhóm ngành nghề, nghề nghiệp chuyên môn và lĩnh vực kinh doanh của công ty trong 15 ngày.'
                    ]
                },
                'viec-can-tuyen-gap': {
                    title: 'Việc Cần Tuyển Gấp',
                    price: '1.134.000 VND',
                    description: 'Tiêu đề tin đăng tuyển được hiển thị với tag "Urgent" trong 3 ngành nghề tương ứng trong suốt 30 ngày. Hiển thị trong danh sách các công việc cần tuyển gấp khi ứng viên lọc theo "Việc cần tuyển gấp" trên đầu trang kết quả tìm kiếm.',
                    includes: [
                        'Tiêu đề tin tuyển dụng được hiển thị tag "Urgent" màu đỏ tại trang kết quả tìm kiếm trong cả 3 ngành nghề.'
                    ]
                },
                'tim-ho-so-1-thang': {
                    title: 'Tìm Hồ Sơ 1 tháng',
                    price: '4.644.000 VND',
                    description: 'Không giới hạn trong việc tìm kiếm và xem hồ sơ ứng viên. Tuyển dụng tài năng ngay từ bây giờ.',
                    includes: [
                        'Tìm kiếm không giới hạn hồ sơ ứng viên',
                        'Xem chi tiết hồ sơ ứng viên',
                        'Tuyển dụng tài năng hiệu quả'
                    ]
                },
                'tim-ho-so-3-thang': {
                    title: 'Tìm Hồ Sơ 3 tháng',
                    price: '12.549.600 VND',
                    description: 'Không giới hạn trong việc tìm kiếm và xem hồ sơ ứng viên. Tuyển dụng tài năng ngay từ bây giờ.',
                    includes: [
                        'Tìm kiếm không giới hạn hồ sơ ứng viên',
                        'Xem chi tiết hồ sơ ứng viên',
                        'Tuyển dụng tài năng hiệu quả'
                    ]
                },
                'tim-ho-so-6-thang': {
                    title: 'Tìm Hồ Sơ 6 tháng',
                    price: '23.706.000 VND',
                    description: 'Không giới hạn trong việc tìm kiếm và xem hồ sơ ứng viên. Tuyển dụng tài năng ngay từ bây giờ.',
                    includes: [
                        'Tìm kiếm không giới hạn hồ sơ ứng viên',
                        'Xem chi tiết hồ sơ ứng viên',
                        'Tuyển dụng tài năng hiệu quả'
                    ]
                },
                'tim-ho-so-12-thang': {
                    title: 'Tìm Hồ Sơ 12 tháng',
                    price: '44.604.000 VND',
                    description: 'Không giới hạn trong việc tìm kiếm và xem hồ sơ ứng viên. Tuyển dụng tài năng ngay từ bây giờ.',
                    includes: [
                        'Tìm kiếm không giới hạn hồ sơ ứng viên',
                        'Xem chi tiết hồ sơ ứng viên',
                        'Tuyển dụng tài năng hiệu quả'
                    ]
                },
                'ai-premium-basic': {
                    title: 'AI Premium Basic',
                    price: '2.500.000 VND',
                    description: 'Gói AI Premium cơ bản với các tính năng AI hỗ trợ tuyển dụng thông minh. Tự động sàng lọc hồ sơ, đề xuất ứng viên phù hợp và tối ưu hóa quy trình tuyển dụng.',
                    includes: [
                        'AI sàng lọc hồ sơ tự động',
                        'Đề xuất ứng viên phù hợp',
                        'Phân tích CV thông minh',
                        'Báo cáo tuyển dụng AI'
                    ]
                },
                'ai-premium-pro': {
                    title: 'AI Premium Pro',
                    price: '5.000.000 VND',
                    description: 'Gói AI Premium nâng cao với đầy đủ tính năng AI. Tự động hóa toàn bộ quy trình tuyển dụng, dự đoán hiệu suất ứng viên và tối ưu hóa chiến lược tuyển dụng.',
                    includes: [
                        'Tất cả tính năng Basic',
                        'Dự đoán hiệu suất ứng viên',
                        'Tự động hóa quy trình tuyển dụng',
                        'Phân tích xu hướng thị trường lao động',
                        'Tư vấn chiến lược tuyển dụng AI'
                    ]
                },
                'ai-premium-enterprise': {
                    title: 'AI Premium Enterprise',
                    price: '10.000.000 VND',
                    description: 'Gói AI Premium doanh nghiệp với các tính năng AI tiên tiến nhất. Hỗ trợ đa ngôn ngữ, tích hợp hệ thống HR hiện có và tư vấn chuyên sâu về AI trong tuyển dụng.',
                    includes: [
                        'Tất cả tính năng Pro',
                        'Hỗ trợ đa ngôn ngữ',
                        'Tích hợp hệ thống HR hiện có',
                        'Tư vấn chuyên sâu AI',
                        'Hỗ trợ 24/7 từ chuyên gia AI',
                        'Báo cáo doanh nghiệp nâng cao'
                    ]
                }
            };
            // Chức năng giỏ hàng - lưu vào sessionStorage để không bị mất khi chuyển tab
            let cart = [];
            
            // Load cart from sessionStorage khi khởi tạo
            function loadCartFromStorage() {
                try {
                    const savedCart = sessionStorage.getItem('topcv_cart');
                    if (savedCart) {
                        cart = JSON.parse(savedCart);
                        console.log('Loaded cart from storage:', cart);
                    }
                } catch (e) {
                    console.error('Error loading cart from storage:', e);
                    cart = [];
                }
            }
            
            // Save cart to sessionStorage
            function saveCartToStorage() {
                try {
                    sessionStorage.setItem('topcv_cart', JSON.stringify(cart));
                    console.log('Saved cart to storage:', cart);
                } catch (e) {
                    console.error('Error saving cart to storage:', e);
                }
            }

            // Initialize page
            document.addEventListener('DOMContentLoaded', function () {
                // Load cart from storage first
                loadCartFromStorage();
                // Update cart display after loading
                updateCartDisplay();
                // Tab switching functionality
                const tabItems = document.querySelectorAll('.tab-item');
                const tabContents = document.querySelectorAll('.tab-content');

                tabItems.forEach(tab => {
                    tab.addEventListener('click', function () {
                        const targetTab = this.getAttribute('data-tab');

                        // Remove active class from all tabs
                        tabItems.forEach(t => t.classList.remove('active'));
                        // Add active class to clicked tab
                        this.classList.add('active');

                        // Hide all tab contents
                        tabContents.forEach(content => content.classList.remove('active'));
                        // Show target tab content
                        document.getElementById(targetTab).classList.add('active');

                        // Re-initialize cart buttons for the new tab
                        initializeCartButtons();
                    });
                });

                // Add click handlers to package items
                const packageItems = document.querySelectorAll('.package-item');
                packageItems.forEach((item, index) => {
                    item.addEventListener('click', function () {
                        // Remove selected class from all items in current tab
                        const currentTab = this.closest('.tab-content');
                        const currentTabItems = currentTab.querySelectorAll('.package-item');
                        currentTabItems.forEach(pkg => pkg.classList.remove('selected'));
                        // Add selected class to clicked item
                        this.classList.add('selected');

                        // Update content based on clicked package
                        updatePackageContent(this);
                    });
                });

                // Initialize cart buttons
                initializeCartButtons();

                // Add click handler to main add to cart button
                const mainAddToCartBtn = document.querySelector('.add-to-cart-main-btn');
                if (mainAddToCartBtn) {
                    mainAddToCartBtn.addEventListener('click', function () {
                        const currentPackage = document.querySelector('.package-item.selected');
                        if (currentPackage) {
                            const packageTitle = currentPackage.querySelector('h4').textContent;
                            const packagePrice = currentPackage.querySelector('.package-price').textContent;

                            // Check if item is already in cart
                            const existingItem = cart.find(item => item.title === packageTitle);
                            if (existingItem) {
                                // If in cart, increase quantity
                                updateQuantity(packageTitle, existingItem.quantity + 1);
                            } else {
                                // If not in cart, add to cart
                                const packageId = currentPackage.dataset.packageId || 0;
                                addToCart(packageTitle, packagePrice, packageId);
                            }
                        }
                    });
                }

                // Add click handlers to footer buttons
                const clearBtn = document.querySelector('.clear-btn');
                const checkoutBtn = document.getElementById('btnCheckout');

                if (clearBtn) {
                    clearBtn.addEventListener('click', function () {
                        cart = [];
                        saveCartToStorage(); // Lưu vào storage
                        updateCartDisplay();
                        alert('Đã xóa tất cả khỏi giỏ hàng!');
                    });
                }

                if (checkoutBtn) {
                    checkoutBtn.addEventListener('click', function () {
                        const totalRaw = getTotalRaw();
                        if (!totalRaw || totalRaw <= 0) {
                            alert('Giỏ hàng trống hoặc tổng tiền không hợp lệ!');
                            return;
                        }
                        
                        // Lưu giỏ hàng vào sessionStorage
                        try {
                            sessionStorage.setItem('topcv_cart', JSON.stringify(cart));
                        } catch(err) {
                            console.error('Error saving cart to storage:', err);
                        }
                        
                        // Chuyển hướng đến shop-cart.jsp
                        window.location.href = '<%= request.getContextPath() %>/Recruiter/shop-cart.jsp';
                    });
                }

                // Add click handler to cart icon
                const cartIcon = document.querySelector('.nav-icons .fa-shopping-cart');
                if (cartIcon) {
                    cartIcon.addEventListener('click', function () {
                        console.log('Cart clicked, cart length:', cart.length);
                        if (cart.length > 0) {
                            showCartDropdown();
                        } else {
                            alert('Giỏ hàng trống!');
                        }
                    });
                }
            });

            // Khởi tạo các nút thêm vào giỏ
            function initializeCartButtons() {
                // Remove existing event listeners by cloning and replacing buttons
                const addToCartBtns = document.querySelectorAll('.add-to-cart-btn');
                addToCartBtns.forEach(btn => {
                    const newBtn = btn.cloneNode(true);
                    btn.parentNode.replaceChild(newBtn, btn);
                });

                // Add new event listeners
                const newAddToCartBtns = document.querySelectorAll('.add-to-cart-btn');
                console.log('Initializing cart buttons:', newAddToCartBtns.length);
                newAddToCartBtns.forEach((btn, index) => {
                    btn.addEventListener('click', function (e) {
                        e.stopPropagation(); // Prevent triggering package selection

                        // Nếu click bên trong spinner thì không thêm mới nữa (tránh + nhảy 2 lần)
                        if (e.target && e.target.closest && e.target.closest('.quantity-spinner')) {
                            return;
                        }

                        const packageItem = this.closest('.package-item');
                        const packageTitle = packageItem.querySelector('h4').textContent;
                        const packagePrice = packageItem.querySelector('.package-price').textContent;

                        console.log('Add to cart clicked:', packageTitle, packagePrice);
                        console.log('Package item:', packageItem);
                        console.log('Button index:', index);

                        // First select this package
                        const allPackageItems = document.querySelectorAll('.package-item');
                        allPackageItems.forEach(pkg => pkg.classList.remove('selected'));
                        packageItem.classList.add('selected');
                        console.log('Selected package:', packageTitle);

                        // Check if item is already in cart
                        const existingItem = cart.find(item => item.title === packageTitle);
                        if (existingItem) {
                            // If in cart, increase quantity
                            updateQuantity(packageTitle, existingItem.quantity + 1);
                        } else {
                            // If not in cart, add to cart
                            const packageId = packageItem.dataset.packageId || 0;
                            addToCart(packageTitle, packagePrice, packageId);
                        }
                    });
                });
            }

            // Hàm giỏ hàng (toàn cục)
            function addToCart(title, price, packageId) {
                const existingItem = cart.find(item => item.title === title);
                if (existingItem) {
                    existingItem.quantity += 1;
                } else {
                    cart.push({
                        title: title,
                        price: price,
                        packageId: packageId || 0, // Lưu PackageID từ database
                        quantity: 1
                    });
                }
                saveCartToStorage(); // Lưu vào storage
                updateCartDisplay();
            }

            function removeFromCart(title) {
                cart = cart.filter(item => item.title !== title);
                saveCartToStorage(); // Lưu vào storage
                updateCartDisplay();
            }

            function updateQuantity(title, newQuantity) {
                console.log('updateQuantity called:', title, 'current quantity:', cart.find(item => item.title === title)?.quantity, 'new quantity:', newQuantity);
                const item = cart.find(item => item.title === title);
                if (item) {
                    if (newQuantity <= 0) {
                        removeFromCart(title);
                    } else {
                        item.quantity = newQuantity;
                        saveCartToStorage(); // Lưu vào storage
                        updateCartDisplay();
                    }
                }
            }

            function updateCartDisplay() {
            // Cập nhật số lượng trên icon giỏ hàng
                const cartCount = cart.reduce((total, item) => total + item.quantity, 0);
                const cartIcon = document.querySelector('.nav-icons .fa-shopping-cart');
                if (cartIcon) {
                    if (cartCount > 0) {
                        // Remove existing cart-count if any
                        const existingCount = cartIcon.querySelector('.cart-count');
                        if (existingCount) {
                            existingCount.remove();
                        }
                        // Add cart count span
                        const countSpan = document.createElement('span');
                        countSpan.className = 'cart-count';
                        countSpan.textContent = cartCount;
                        cartIcon.appendChild(countSpan);
                    } else {
                        // Remove cart count span
                        const existingCount = cartIcon.querySelector('.cart-count');
                        if (existingCount) {
                            existingCount.remove();
                        }
                    }
                }

                // Update add to cart buttons to show quantity
                updateAddToCartButtons();

                // Update total
                updateTotal();
            }

            function updateAddToCartButtons() {
                console.log('updateAddToCartButtons called, cart:', cart);
            // Cập nhật nút "Thêm vào giỏ" thành spinner số lượng
                const addToCartBtns = document.querySelectorAll('.add-to-cart-btn');
                console.log('Updating buttons:', addToCartBtns.length);
                addToCartBtns.forEach((btn, index) => {
                    const packageItem = btn.closest('.package-item');
                    const packageTitle = packageItem.querySelector('h4').textContent;
                    const cartItem = cart.find(item => item.title === packageTitle);

                    console.log(`Button ${index}: ${packageTitle}, cart item:`, cartItem);

                    if (cartItem && cartItem.quantity > 0) {
                        console.log('Found cart item:', cartItem);
                        btn.innerHTML = '<div class="quantity-spinner">'
                            + '<button onclick="event.stopPropagation(); updateQuantity(\'' + packageTitle + '\',' + (cartItem.quantity - 1) + ')">-</button>'
                            + '<input type="text" class="quantity-display" value="' + cartItem.quantity + '" readonly>'
                            + '<button onclick="event.stopPropagation(); updateQuantity(\'' + packageTitle + '\',' + (cartItem.quantity + 1) + ')">+</button>'
                            + '</div>';
                        btn.classList.add('in-cart');
                        console.log('Updated button to spinner for:', packageTitle);
                    } else {
                        btn.innerHTML = '<i class="fas fa-shopping-cart"></i>';
                        btn.classList.remove('in-cart');
                    }
                });

            // Cập nhật nút thêm vào giỏ chính
                const mainAddToCartBtn = document.querySelector('.add-to-cart-main-btn');
                if (mainAddToCartBtn) {
                    const currentPackage = document.querySelector('.package-item.selected');
                    if (currentPackage) {
                        const packageTitle = currentPackage.querySelector('h4').textContent;
                        const cartItem = cart.find(item => item.title === packageTitle);

                        console.log('Main button - current package:', packageTitle, 'cart item:', cartItem);

                        if (cartItem && cartItem.quantity > 0) {
                            mainAddToCartBtn.innerHTML = '<div class="quantity-spinner">'
                                + '<button onclick="event.stopPropagation(); updateQuantity(\'' + packageTitle + '\',' + (cartItem.quantity - 1) + ')">-</button>'
                                + '<input type="text" class="quantity-display" value="' + cartItem.quantity + '" readonly>'
                                + '<button onclick="event.stopPropagation(); updateQuantity(\'' + packageTitle + '\',' + (cartItem.quantity + 1) + ')">+</button>'
                                + '</div>';
                            mainAddToCartBtn.classList.add('in-cart');
                            console.log('Updated main button to spinner for:', packageTitle);
                        } else {
                            mainAddToCartBtn.innerHTML = 'Thêm vào giỏ';
                            mainAddToCartBtn.classList.remove('in-cart');
                        }
                    } else {
                        console.log('No selected package found');
                    }
                }
            }

            function updateTotal() {
                const total = cart.reduce((sum, item) => {
                    const price = parseInt(String(item.price).replace(/[^\d]/g, '')) || 0;
                    return sum + (price * (item.quantity || 0));
                }, 0);

                const totalElement = document.querySelector('.total-amount');
                if (totalElement) {
                    try {
                        totalElement.textContent = total.toLocaleString('vi-VN') + ' VND';
                    } catch(err) {
                        totalElement.textContent = total + ' VND';
                    }
                }
            }

            function getTotalRaw() {
                return cart.reduce(function(sum, item){
                    const price = parseInt(String(item.price).replace(/[^\d]/g, '')) || 0;
                    return sum + (price * (item.quantity || 0));
                }, 0);
            }

            function showCartDropdown() {
                // Create or update cart dropdown
                let cartDropdown = document.querySelector('.cart-dropdown');
                if (!cartDropdown) {
                    cartDropdown = document.createElement('div');
                    cartDropdown.className = 'cart-dropdown';
                    document.body.appendChild(cartDropdown);
                }

                // Close dropdown when clicking outside
                cartDropdown.onclick = function (e) {
                    if (e.target === cartDropdown) {
                        cartDropdown.style.display = 'none';
                    }
                };

                var itemsHtml = '';
                cart.forEach(function(item) {
                    itemsHtml += '<div class="cart-dropdown-item" data-title="' + item.title.replace(/"/g,'&quot;') + '">'
                        + '<div class="item-info">'
                        + '<h4>' + item.title + '</h4>'
                        + '<div class="item-price">' + item.price + '</div>'
                        + '</div>'
                        + '<div class="item-controls">'
                        + '<div class="quantity-spinner">'
                        + '<button class="btn-minus" type="button" style="border: 1px solid red;">-</button>'
                        + '<input type="text" class="quantity-display" value="' + item.quantity + '" readonly>'
                        + '<button class="btn-plus" type="button" style="border: 1px solid red;">+</button>'
                        + '</div>'
                        + '<button class="remove-btn" type="button">'
                        + '<i class="fas fa-trash"></i>'
                        + '</button>'
                        + '</div>'
                        + '</div>';
                });
                var headerCount = cart.reduce(function(total, item){return total + item.quantity;}, 0);
                var totalAmt = cart.reduce(function(sum, item){
                    var price = parseInt(item.price.replace(/[^\d]/g, ''));
                            return sum + (price * item.quantity);
                }, 0).toLocaleString('vi-VN');
                cartDropdown.innerHTML = '<div class="cart-dropdown-content">'
                    + '<h3>Giỏ hàng (' + headerCount + ' sản phẩm)</h3>'
                    + '<div class="cart-dropdown-items">' + itemsHtml + '</div>'
                    + '<div class="cart-dropdown-total"><strong>Tổng: ' + totalAmt + ' VND</strong></div>'
                    + '<div class="cart-dropdown-actions">'
                    + '<button class="close-btn" type="button">Đóng</button>'
                    + '<button class="checkout-btn" type="button">Thanh toán</button>'
                    + '</div>'
                    + '</div>';

                cartDropdown.style.display = 'block';
            }

            // Ủy quyền sự kiện: xử lý + / - / xoá / đóng trong dropdown giỏ hàng
            document.addEventListener('click', function(e){
                var minusBtn = e.target.closest ? e.target.closest('.btn-minus') : null;
                var plusBtn = e.target.closest ? e.target.closest('.btn-plus') : null;
                var removeBtn = e.target.closest ? e.target.closest('.remove-btn') : null;
                var closeBtn = e.target.closest ? e.target.closest('.close-btn') : null;
                var dropdownVisible = document.querySelector('.cart-dropdown') && document.querySelector('.cart-dropdown').style.display === 'block';

                if (minusBtn) {
                    var row1 = minusBtn.closest('.cart-dropdown-item');
                    if (row1) { updateQuantity(row1.getAttribute('data-title'), (getQty(row1) - 1)); }
                    if (dropdownVisible) showCartDropdown();
                } else if (plusBtn) {
                    var row2 = plusBtn.closest('.cart-dropdown-item');
                    if (row2) { updateQuantity(row2.getAttribute('data-title'), (getQty(row2) + 1)); }
                    if (dropdownVisible) showCartDropdown();
                } else if (removeBtn) {
                    var row3 = removeBtn.closest('.cart-dropdown-item');
                    if (row3) { removeFromCart(row3.getAttribute('data-title')); }
                    if (dropdownVisible) showCartDropdown();
                } else if (closeBtn) {
                    var dd = document.querySelector('.cart-dropdown');
                    if (dd) dd.style.display = 'none';
                }
            });

            function getQty(row){
                var v = row.querySelector('.quantity-display') ? parseInt(row.querySelector('.quantity-display').value, 10) : 0;
                return isNaN(v) ? 0 : v;
            }

            function updatePackageContent(selectedItem) {
                const packageTitle = selectedItem.querySelector('h4').textContent;
                const packagePrice = selectedItem.querySelector('.package-price').textContent;

                // Find matching package data
                let packageData = null;
                for (const [key, data] of Object.entries(packages)) {
                    if (data.title === packageTitle) {
                        packageData = data;
                        break;
                    }
                }

                if (packageData) {
                    // Update product header
                    const productHeader = document.querySelector('.product-header');
                    productHeader.querySelector('h2').textContent = packageData.title;
                    productHeader.querySelector('.product-price').textContent = packageData.price;

                    // Add warning for "Việc Cần Tuyển Gấp"
                    let warningDiv = productHeader.querySelector('.warning-message');
                    if (packageData.title === 'Việc Cần Tuyển Gấp') {
                        if (!warningDiv) {
                            warningDiv = document.createElement('div');
                            warningDiv.className = 'warning-message';
                            warningDiv.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Sản phẩm này chỉ làm tăng độ nổi bật của tin đăng. Không bao gồm tính năng đăng tin.';
                            productHeader.appendChild(warningDiv);
                        }
                    } else {
                        if (warningDiv) {
                            warningDiv.remove();
                        }
                    }

                    // Update product description
                    const descriptionSection = document.querySelector('.product-description p');
                    descriptionSection.textContent = packageData.description;

                    // Update includes section
                    const includesList = document.querySelector('.product-includes ul');
                    includesList.innerHTML = '';
                    includesList.innerHTML = '';
                    // Nếu cột Features (JSON hoặc chuỗi ngăn cách) có trong item đang chọn thì ưu tiên dùng
                    var selected = document.querySelector('.package-item.selected');
                    var featuresRaw = selected && selected.querySelector('.hidden-features') ? selected.querySelector('.hidden-features').textContent : '';
                    if (featuresRaw) {
                        try {
                            var arr = JSON.parse(featuresRaw);
                            if (Array.isArray(arr)) {
                                arr.forEach(function(f){
                                    var li = document.createElement('li');
                                    li.innerHTML = '<i class="fas fa-check"></i> ' + f;
                                    includesList.appendChild(li);
                                });
                            }
                        } catch(err) {
                            // fallback: split by ;
                            featuresRaw.split(';').forEach(function(f){
                                if (f.trim().length>0){
                                    var li = document.createElement('li');
                                    li.innerHTML = '<i class="fas fa-check"></i> ' + f.trim();
                                    includesList.appendChild(li);
                                }
                            });
                        }
                    } else if (Array.isArray(packageData.includes)) {
                        packageData.includes.forEach(function(include){
                        const li = document.createElement('li');
                            li.innerHTML = '<i class="fas fa-check"></i> ' + include;
                        includesList.appendChild(li);
                    });
                }
            }
            }
            // Khi click một gói bên trái, cập nhật chi tiết bên phải theo hidden fields
            document.addEventListener('click', function(e){
                var pkg = e.target.closest('.package-item');
                if (!pkg) return;
                var title = pkg.querySelector('h4') ? pkg.querySelector('h4').textContent : '';
                var price = pkg.getAttribute('data-price-raw') || '0';
                var desc = pkg.querySelector('.hidden-desc') ? pkg.querySelector('.hidden-desc').textContent : '';
                // Cập nhật tiêu đề và giá bên phải theo gói được chọn
                var pdTitle = document.getElementById('pd-title');
                var pdPrice = document.getElementById('pd-price');
                var pdDesc  = document.getElementById('pd-desc');
                if (pdTitle) pdTitle.textContent = title;
                if (pdPrice) {
                    try {
                        var n = parseFloat(price);
                        pdPrice.textContent = isNaN(n) ? price + ' VND' : n.toLocaleString('vi-VN') + ' VND';
                    } catch(err) { pdPrice.textContent = price + ' VND'; }
                }
                if (pdDesc) pdDesc.textContent = desc || pdDesc.textContent;
            });
        </script>

    </body>
</html>

