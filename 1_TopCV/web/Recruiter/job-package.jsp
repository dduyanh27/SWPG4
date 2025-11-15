<%-- 
    Document   : job-package
    Created on : Oct 23, 2025, 1:03:48 PM
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

            /* Quantity Spinner Styles */
            .quantity-spinner {
                display: flex;
                align-items: center;
                gap: 5px;
                background: white;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                padding: 2px;
                min-width: 100px;
            }

            .quantity-spinner button {
                width: 24px;
                height: 24px;
                border: none;
                background: #f3f4f6;
                border-radius: 4px;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                font-size: 14px;
                font-weight: 600;
                color: #374151;
                transition: all 0.2s ease;
            }

            .quantity-spinner button:hover {
                background: #e5e7eb;
                color: #1f2937;
            }

            .quantity-spinner button:active {
                background: #d1d5db;
                transform: scale(0.95);
            }

            .quantity-display {
                width: 40px;
                height: 24px;
                border: none;
                text-align: center;
                font-weight: 600;
                color: #1f2937;
                background: transparent;
                font-size: 14px;
            }

            .quantity-display:focus {
                outline: none;
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
                        <li><a href="${pageContext.request.contextPath}/Recruiter/index.jsp">Dashboard</a></li>
                        <li><a href="#">Việc Làm</a></li>
                        <li class="dropdown">
                            <a href="#">Ứng viên <i class="fas fa-chevron-down"></i></a>
                            <div class="dropdown-content">
                                <a href="${pageContext.request.contextPath}/candidate-management">Quản lý theo việc đăng tuyển</a>
                                <a href="${pageContext.request.contextPath}/Recruiter/candidate-folder.html">Quản lý theo thư mục và thẻ</a>
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
                                <a href="${pageContext.request.contextPath}/recruiter/purchase-history">Lịch sử mua</a>
                            </div>
                        </li>
                        <li><a href="#">Báo cáo</a></li>
                        <li><a href="${pageContext.request.contextPath}/Recruiter/job-package.jsp" class="active">Đăng Tuyển Dụng</a></li>
                        <li><a href="${pageContext.request.contextPath}/candidate-search">Tìm Ứng Viên</a></li>
                        <li><a href="${pageContext.request.contextPath}/Recruiter/shop-cart.jsp" class="btn btn-red">Mua</a></li>
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
            <!-- Navigation Tabs: chỉ còn ĐĂNG TUYỂN -->
            <div class="tab-navigation">
                <div class="tab-container">
                    <div class="tab-item active" data-tab="dang-tuyen">
                        <span>ĐĂNG TUYỂN</span>
                    </div>
                </div>
            </div>

            <div class="packages-container">
                <!-- Left Sidebar -->
                <div class="packages-sidebar">
                    <!-- ĐĂNG TUYỂN Tab Content -->
                    <div class="tab-content active" id="dang-tuyen">
                        <div class="sidebar-section">
                            <h3>ĐĂNG TUYỂN</h3>
                            <div class="loading-message">
                                <p>Đang tải dữ liệu...</p>
                                </div>
                        </div>
                    </div>

                    <!-- Đã loại bỏ các tab khác -->
                </div>

                <!-- Right Main Content -->
                <div class="packages-content">
                    <!-- Product Details -->
                    <div class="product-details">
                        <div class="product-header">
                            <h2>Chọn gói dịch vụ</h2>
                            <div class="product-price">0 VND</div>
                        </div>

                        <div class="product-description">
                            <h3>Mô tả sản phẩm</h3>
                            <p>Vui lòng chọn một gói dịch vụ từ danh sách bên trái để xem thông tin chi tiết.</p>
                        </div>

                        <div class="product-includes">
                            <h3>Bao gồm</h3>
                            <ul>
                                <li><i class="fas fa-check"></i> Chọn gói dịch vụ để xem thông tin chi tiết</li>
                            </ul>
                        </div>

                        <div class="product-preview">
                            <h3>Hiển thị trên VietnamWorks cho Người tìm việc</h3>
                            <div class="preview-container">
                                <div class="search-bar">
                                    <i class="fas fa-arrow-left"></i>
                                    <div class="search-input">
                                        <i class="fas fa-search"></i>
                                        <span>admin</span>
                                    </div>
                                </div>
                                <div class="preview-tabs">
                                    <div class="tab active">Jobs</div>
                                    <div class="tab">Interview</div>
                                    <div class="tab">Salary</div>
                                </div>
                                <div class="job-listings">
                                    <div class="job-item">
                                        <div class="company-logo">N</div>
                                        <div class="job-info">
                                            <div class="job-title">
                                                <span>Admin Executive</span>
                                                <span class="hot-tag">HOT</span>
                                            </div>
                                            <div class="company-name">Novus Vision</div>
                                            <div class="job-location">Ho Chi Minh</div>
                                            <div class="job-salary">From $500 to $900</div>
                                        </div>
                                        <div class="job-actions">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                    </div>
                                    <div class="job-item">
                                        <div class="company-logo">I</div>
                                        <div class="job-info">
                                            <div class="job-title">
                                                <span>Admin & HR Department | Hành Chính Nhân Sự</span>
                                                <span class="hot-tag">HOT</span>
                                            </div>
                                            <div class="company-name">Indefol Solar</div>
                                            <div class="job-location">Ho Chi Minh</div>
                                            <div class="job-salary">Negotiable</div>
                                        </div>
                                        <div class="job-actions">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                    </div>
                                    <div class="job-item">
                                        <div class="company-logo">IS</div>
                                        <div class="job-info">
                                            <div class="job-title">
                                                <span>International School</span>
                                                <span class="hot-tag">HOT</span>
                                            </div>
                                            <div class="company-name">International School</div>
                                            <div class="job-location">Ho Chi Minh</div>
                                            <div class="job-salary">Negotiable</div>
                                        </div>
                                        <div class="job-actions">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                    </div>
                                    <div class="job-item">
                                        <div class="company-logo">U</div>
                                        <div class="job-info">
                                            <div class="job-title">
                                                <span>Unique Furniture</span>
                                                <span class="hot-tag">HOT</span>
                                            </div>
                                            <div class="company-name">Unique Furniture</div>
                                            <div class="job-location">Ho Chi Minh</div>
                                            <div class="job-salary">Negotiable</div>
                                        </div>
                                        <div class="job-actions">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                    </div>
                                    <div class="job-item">
                                        <div class="company-logo">K</div>
                                        <div class="job-info">
                                            <div class="job-title">
                                                <span>Korchina Logistics</span>
                                                <span class="hot-tag">HOT</span>
                                            </div>
                                            <div class="company-name">Korchina Logistics</div>
                                            <div class="job-location">Ho Chi Minh</div>
                                            <div class="job-salary">Negotiable</div>
                                        </div>
                                        <div class="job-actions">
                                            <i class="fas fa-heart"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="discount-link">
                                    <a href="#">Chương trình giảm giá</a>
                                </div>
                            </div>
                        </div>

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
                    <button class="checkout-btn">Thanh toán</button>
                </div>
            </div>
        </footer>

        <script>
            // Global variables for packages data
            let packagesData = {};
            let currentTab = 'dang-tuyen';
            // Shopping cart functionality
            let cart = [];

            // Sync cart state from sessionStorage (used when returning from shop-cart)
            function syncCartFromSession() {
                try {
                    const stored = sessionStorage.getItem('cartData');
                    if (stored) {
                        const parsed = JSON.parse(stored);
                        if (Array.isArray(parsed)) {
                            cart = parsed;
                        } else {
                            cart = [];
                        }
                    } else {
                        // If nothing in sessionStorage, ensure in-memory cart is cleared
                        cart = [];
                    }
                    updateCartDisplay();
                } catch (e) {
                    console.error('Failed to sync cart from sessionStorage:', e);
                    cart = [];
                    updateCartDisplay();
                }
            }

            // AJAX functions
            function loadPackagesByType(type) {
                console.log('=== DEBUG: loadPackagesByType() ===');
                console.log('Loading packages for type:', type);
                
                const xhr = new XMLHttpRequest();
                const contextPath = '${pageContext.request.contextPath}';
                const url = contextPath + '/job-package-api?action=getPackagesByType&type=' + encodeURIComponent(type);
                console.log('Context Path:', contextPath);
                console.log('Request URL:', url);
                
                xhr.open('GET', url, true);
                xhr.onreadystatechange = function() {
                    console.log('XHR ReadyState:', xhr.readyState, 'Status:', xhr.status);
                    
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            console.log('Response received:', xhr.responseText);
                            try {
                                const response = JSON.parse(xhr.responseText);
                                console.log('Parsed response:', response);
                                
                                if (response.success) {
                                    console.log('Success! Found', response.packages.length, 'packages');
                                    console.log('Packages data:', response.packages);
                                    packagesData[type] = response.packages;
                                    renderPackages(type, response.packages);
                                } else {
                                    console.error('Error loading packages:', response.message);
                                    showError('Không thể tải dữ liệu gói dịch vụ: ' + response.message);
                                }
                            } catch (e) {
                                console.error('Error parsing response:', e);
                                showError('Lỗi xử lý dữ liệu từ server');
                            }
                        } else {
                            console.error('HTTP Error:', xhr.status);
                            showError('Lỗi kết nối server: ' + xhr.status);
                        }
                    }
                };
                xhr.send();
                console.log('=== END DEBUG: loadPackagesByType() ===');
            }


            function renderPackages(type, packages) {
                console.log('=== DEBUG: renderPackages() ===');
                console.log('Type:', type);
                console.log('Packages received:', packages);
                console.log('Number of packages:', packages.length);
                console.log('First package details:', packages[0]);
                
                const tabContent = document.getElementById(type);
                if (!tabContent) {
                    console.error('Tab content not found for type:', type);
                    return;
                }

                // Clear existing content but preserve cart state
                console.log('Clearing tab content, preserving cart state...');
                console.log('Current cart before render:', cart);
                tabContent.innerHTML = '';

                if (packages.length === 0) {
                    console.log('No packages found, showing empty message');
                    const emptyDiv = document.createElement('div');
                    emptyDiv.className = 'empty-message';
                    emptyDiv.innerHTML = '<p>Không có gói dịch vụ nào cho loại này.</p>';
                    tabContent.appendChild(emptyDiv);
                    return;
                }

                // Group packages by category
                const mainPackages = packages.filter(pkg => !pkg.packageName.toLowerCase().includes('thêm'));
                const supportPackages = packages.filter(pkg => pkg.packageName.toLowerCase().includes('thêm'));
                
                console.log('Main packages:', mainPackages.length);
                console.log('Support packages:', supportPackages.length);

                // Render main packages
                if (mainPackages.length > 0) {
                    console.log('Rendering main packages section');
                    const mainSection = createPackageSection(getTypeDisplayName(type), mainPackages);
                    tabContent.appendChild(mainSection);
                }

                // Render support packages
                if (supportPackages.length > 0) {
                    console.log('Rendering support packages section');
                    const supportSection = createPackageSection('DỊCH VỤ HỖ TRỢ', supportPackages);
                    tabContent.appendChild(supportSection);
                }

                // Re-initialize event listeners
                initializePackageEventListeners();
                
                // Force update cart display after rendering
                setTimeout(function() {
                    console.log('Force updating cart display after render...');
                    updateCartDisplay();
                }, 100);
                
                console.log('=== END DEBUG: renderPackages() ===');
            }

            function createPackageSection(title, packages) {
                console.log('=== DEBUG: createPackageSection() ===');
                console.log('Title:', title);
                console.log('Packages to render:', packages);
                
                const section = document.createElement('div');
                section.className = 'sidebar-section';

                const titleH3 = document.createElement('h3');
                titleH3.textContent = title;
                section.appendChild(titleH3);

                packages.forEach((pkg, index) => {
                    console.log('Creating package item', index + 1, ':', pkg.packageName, '-', pkg.price);
                    
                    const packageItem = document.createElement('div');
                    packageItem.className = 'package-item';
                    if (index === 0) packageItem.classList.add('selected');
                    
                    // Check if this package is in cart
                    const cartItem = cart.find(item => item.title === pkg.packageName);
                    console.log('Package', pkg.packageName, 'in cart:', cartItem);

                    const packageInfo = document.createElement('div');
                    packageInfo.className = 'package-info';

                    const packageName = document.createElement('h4');
                    packageName.textContent = pkg.packageName;
                    packageInfo.appendChild(packageName);

                    if (pkg.points) {
                        const badge = document.createElement('div');
                        badge.className = 'package-badge';
                        badge.textContent = pkg.points + ' điểm';
                        packageInfo.appendChild(badge);
                    }

                    const packagePrice = document.createElement('div');
                    packagePrice.className = 'package-price';
                    packagePrice.textContent = formatPrice(pkg.price);
                    packageInfo.appendChild(packagePrice);

                    const addToCartBtn = document.createElement('button');
                    addToCartBtn.className = 'add-to-cart-btn';
                    
                    // Check if package is in cart and create appropriate button
                    if (cartItem && cartItem.quantity > 0) {
                        console.log('Package', pkg.packageName, 'is in cart with quantity:', cartItem.quantity);
                        // Create quantity spinner for packages in cart
                        const spinnerDiv = document.createElement('div');
                        spinnerDiv.className = 'quantity-spinner';
                        
                        const minusBtn = document.createElement('button');
                        minusBtn.textContent = '-';
                        minusBtn.type = 'button';
                        minusBtn.addEventListener('click', function(e) {
                            e.stopPropagation();
                            console.log('Sidebar minus clicked for:', pkg.packageName);
                            updateQuantity(pkg.packageName, cartItem.quantity - 1);
                        });
                        
                        const quantityInput = document.createElement('input');
                        quantityInput.type = 'text';
                        quantityInput.className = 'quantity-display';
                        quantityInput.value = cartItem.quantity;
                        quantityInput.readOnly = true;
                        
                        const plusBtn = document.createElement('button');
                        plusBtn.textContent = '+';
                        plusBtn.type = 'button';
                        plusBtn.addEventListener('click', function(e) {
                            e.stopPropagation();
                            console.log('Sidebar plus clicked for:', pkg.packageName);
                            updateQuantity(pkg.packageName, cartItem.quantity + 1);
                        });
                        
                        spinnerDiv.appendChild(minusBtn);
                        spinnerDiv.appendChild(quantityInput);
                        spinnerDiv.appendChild(plusBtn);
                        
                        addToCartBtn.appendChild(spinnerDiv);
                        addToCartBtn.classList.add('in-cart');
                    } else {
                        addToCartBtn.innerHTML = '<i class="fas fa-shopping-cart"></i>';
                    }

                    packageItem.appendChild(packageInfo);
                    packageItem.appendChild(addToCartBtn);
                    section.appendChild(packageItem);
                });

                console.log('Created section with', packages.length, 'package items');
                console.log('=== END DEBUG: createPackageSection() ===');
                return section;
            }

            function getTypeDisplayName(type) {
                const typeNames = {
                    'dang-tuyen': 'ĐĂNG TUYỂN'
                };
                return typeNames[type] || 'ĐĂNG TUYỂN';
            }

            function formatPrice(price) {
                if (!price) return '0 VND';
                return new Intl.NumberFormat('vi-VN').format(price) + ' VND';
            }

            function showError(message) {
                // You can implement a proper error display here
                console.error(message);
                alert(message);
            }

            function initializePackageEventListeners() {
                // Add click handlers to package items in the current active tab only
                const activeTab = document.querySelector('.tab-content.active');
                if (activeTab) {
                    const packageItems = activeTab.querySelectorAll('.package-item');
                    packageItems.forEach((item, index) => {
                        // Remove existing event listeners by cloning the element
                        const newItem = item.cloneNode(true);
                        item.parentNode.replaceChild(newItem, item);
                        
                        newItem.addEventListener('click', function () {
                            // Remove selected class from all items in current tab
                            const currentTabContent = this.closest('.tab-content');
                            const currentTabItems = currentTabContent.querySelectorAll('.package-item');
                            currentTabItems.forEach(pkg => pkg.classList.remove('selected'));
                            // Add selected class to clicked item
                            this.classList.add('selected');

                            // Update content based on clicked package
                            updatePackageContent(this);
                        });
                    });
                }

                // Initialize cart buttons
                initializeCartButtons();
            }

            // Initialize page
            document.addEventListener('DOMContentLoaded', function () {
                console.log('=== DEBUG: DOMContentLoaded ===');
                console.log('Page loaded, initializing...');
                // Ensure cart reflects sessionStorage (e.g., after returning from shop-cart)
                syncCartFromSession();
                
                // Force update total on page load
                setTimeout(function() {
                    console.log('Force updating total on page load...');
                    updateTotal();
                }, 100);
                
                // Load initial data
                loadPackagesByType('dang-tuyen');
                
                // Không còn chuyển tab: chỉ dùng 'dang-tuyen'

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
                    // Remove existing event listeners
                    const newMainBtn = mainAddToCartBtn.cloneNode(true);
                    mainAddToCartBtn.parentNode.replaceChild(newMainBtn, mainAddToCartBtn);
                    
                    newMainBtn.addEventListener('click', function (e) {
                        // Check if this is a quantity spinner button click
                        if (e.target.tagName === 'BUTTON' && e.target.closest('.quantity-spinner')) {
                            return; // Let the onclick handler handle it
                        }
                        
                        const currentPackage = document.querySelector('.package-item.selected');
                        if (currentPackage) {
                            const packageTitle = currentPackage.querySelector('h4').textContent;
                            const packagePriceText = currentPackage.querySelector('.package-price').textContent;
                            
                            // Extract numeric price from formatted text
                            const priceStr = packagePriceText.replace(/[^\d]/g, '');
                            const packagePrice = parseInt(priceStr) || 0;
                            console.log('Main button - Original price text:', packagePriceText);
                            console.log('Main button - Extracted price:', packagePrice);

                            // Check if item is already in cart
                            const existingItem = cart.find(item => item.title === packageTitle);
                            if (existingItem) {
                                // If in cart, increase quantity
                                updateQuantity(packageTitle, existingItem.quantity + 1);
                            } else {
                                // If not in cart, add to cart
                                addToCart(packageTitle, packagePrice);
                            }
                        }
                    });
                }

                // Add click handlers to footer buttons
                const clearBtn = document.querySelector('.clear-btn');
                const checkoutBtn = document.querySelector('.checkout-btn');

                if (clearBtn) {
                    clearBtn.addEventListener('click', function () {
                        cart = [];
                        updateCartDisplay();
                        alert('Đã xóa tất cả khỏi giỏ hàng!');
                    });
                }

                if (checkoutBtn) {
                    checkoutBtn.addEventListener('click', function () {
                        console.log('Checkout button clicked');
                        console.log('Current cart:', cart);
                        
                        if (cart.length === 0) {
                            alert('Giỏ hàng trống! Vui lòng thêm sản phẩm trước khi thanh toán.');
                            return;
                        }
                        
                        // Calculate total with VAT
                        const subtotal = cart.reduce((sum, item) => {
                            let price = 0;
                            if (typeof item.price === 'number') {
                                price = item.price;
                            } else if (typeof item.price === 'string') {
                                const priceStr = item.price.replace(/[^\d]/g, '');
                                price = parseInt(priceStr) || 0;
                            }
                            return sum + (price * item.quantity);
                        }, 0);
                        
                        const vatAmount = subtotal * 0.08;
                        const totalWithVAT = subtotal + vatAmount;
                        
                        console.log('Subtotal:', subtotal);
                        console.log('VAT:', vatAmount);
                        console.log('Total with VAT:', totalWithVAT);
                        
                        // Store cart data in sessionStorage
                        sessionStorage.setItem('cartData', JSON.stringify(cart));
                        sessionStorage.setItem('cartSubtotal', subtotal.toString());
                        sessionStorage.setItem('cartVAT', vatAmount.toString());
                        sessionStorage.setItem('cartTotal', totalWithVAT.toString());
                        
                        // Redirect to shop-cart page
                        window.location.href = '${pageContext.request.contextPath}/shop-cart';
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

            // Handle back/forward cache navigation: resync cart
            window.addEventListener('pageshow', function(event) {
                // When navigating back, some browsers restore the page from BFCache; resync cart
                if (event.persisted || document.visibilityState === 'visible') {
                    syncCartFromSession();
                }
            });

            document.addEventListener('visibilitychange', function() {
                if (document.visibilityState === 'visible') {
                    syncCartFromSession();
                }
            });

            // Initialize cart buttons function
            function initializeCartButtons() {
                // Only initialize buttons in the current active tab
                const activeTab = document.querySelector('.tab-content.active');
                if (!activeTab) return;

                // Remove existing event listeners by cloning and replacing buttons
                const addToCartBtns = activeTab.querySelectorAll('.add-to-cart-btn');
                addToCartBtns.forEach(btn => {
                    const newBtn = btn.cloneNode(true);
                    btn.parentNode.replaceChild(newBtn, btn);
                });

                // Add new event listeners
                const newAddToCartBtns = activeTab.querySelectorAll('.add-to-cart-btn');
                console.log('Initializing cart buttons:', newAddToCartBtns.length);
                newAddToCartBtns.forEach((btn, index) => {
                    btn.addEventListener('click', function (e) {
                        e.stopPropagation(); // Prevent triggering package selection

                        // Check if this is a quantity spinner button
                        if (e.target.tagName === 'BUTTON' && e.target.closest('.quantity-spinner')) {
                            return; // Let the onclick handler handle it
                        }

                        const packageItem = this.closest('.package-item');
                        const packageTitle = packageItem.querySelector('h4').textContent;
                        const packagePriceText = packageItem.querySelector('.package-price').textContent;

                        console.log('Add to cart clicked:', packageTitle, packagePriceText);
                        console.log('Package item:', packageItem);
                        console.log('Button index:', index);

                        // Extract numeric price from formatted text
                        // Remove all non-digit characters, then convert to number
                        const priceStr = packagePriceText.replace(/[^\d]/g, '');
                        const packagePrice = parseInt(priceStr) || 0;
                        console.log('Original price text:', packagePriceText);
                        console.log('Cleaned price string:', priceStr);
                        console.log('Extracted price:', packagePrice);

                        // First select this package
                        const allPackageItems = activeTab.querySelectorAll('.package-item');
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
                            addToCart(packageTitle, packagePrice);
                        }
                    });
                });
            }

            // Cart functions (defined globally)
            function addToCart(title, price) {
                console.log('=== DEBUG: addToCart() ===');
                console.log('Adding to cart:', title, 'price:', price);
                console.log('Price type:', typeof price);
                console.log('Current cart before add:', cart);
                // Chỉ cho phép 1 LOẠI gói trong giỏ: nếu khác loại → thay thế; nếu cùng loại → tăng số lượng
                const existing = cart[0];
                if (!existing) {
                    cart = [{ title: title, price: price, quantity: 1 }];
                } else if (existing.title === title) {
                    existing.quantity += 1;
                } else {
                    cart = [{ title: title, price: price, quantity: 1 }];
                }
                console.log('Cart after add:', cart);
                updateCartDisplay();
                console.log('=== END DEBUG: addToCart() ===');
            }

            function removeFromCart(title) {
                cart = cart.filter(item => item.title !== title);
                updateCartDisplay();
            }

            function updateQuantity(title, newQuantity) {
                console.log('=== DEBUG: updateQuantity() ===');
                console.log('updateQuantity called:', title, 'current quantity:', cart.find(item => item.title === title)?.quantity, 'new quantity:', newQuantity);
                console.log('Current cart before update:', cart);
                
                const item = cart.find(item => item.title === title);
                if (item) {
                    if (newQuantity <= 0) {
                        console.log('Removing item from cart:', title);
                        removeFromCart(title);
                    } else {
                        // Cho phép tăng giảm số lượng tự do (>0)
                        item.quantity = newQuantity;
                        console.log('Updated item quantity:', item.title, 'to', item.quantity);
                        console.log('Cart after update:', cart);
                        updateCartDisplay();
                    }
                } else {
                    console.error('Item not found in cart:', title);
                    console.log('Available items in cart:', cart.map(item => item.title));
                }
                console.log('=== END DEBUG: updateQuantity() ===');
            }

            function updateCartDisplay() {
                // Update cart count in header
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
                
                // Debug quantity spinners
                debugQuantitySpinners();
            }

            function updateAddToCartButtons() {
                console.log('updateAddToCartButtons called, cart:', cart);
                // Update all add to cart buttons to show quantity spinner
                const addToCartBtns = document.querySelectorAll('.add-to-cart-btn');
                console.log('Updating buttons:', addToCartBtns.length);
                addToCartBtns.forEach((btn, index) => {
                    const packageItem = btn.closest('.package-item');
                    const packageTitle = packageItem.querySelector('h4').textContent;
                    const cartItem = cart.find(item => item.title === packageTitle);

                    console.log(`Button ${index}: ${packageTitle}, cart item:`, cartItem);

                    if (cartItem && cartItem.quantity > 0) {
                        console.log('Found cart item:', cartItem);
                        console.log('Creating spinner for:', packageTitle, 'quantity:', cartItem.quantity);
                        
                        // Create spinner with proper event handling
                        const spinnerDiv = document.createElement('div');
                        spinnerDiv.className = 'quantity-spinner';
                        
                        const minusBtn = document.createElement('button');
                        minusBtn.textContent = '-';
                        minusBtn.type = 'button';
                        minusBtn.addEventListener('click', function(e) {
                            e.stopPropagation();
                            console.log('Button minus clicked for:', packageTitle);
                            updateQuantity(packageTitle, cartItem.quantity - 1);
                        });
                        
                        const quantityInput = document.createElement('input');
                        quantityInput.type = 'text';
                        quantityInput.className = 'quantity-display';
                        quantityInput.value = cartItem.quantity;
                        quantityInput.readOnly = true;
                        
                        const plusBtn = document.createElement('button');
                        plusBtn.textContent = '+';
                        plusBtn.type = 'button';
                        plusBtn.addEventListener('click', function(e) {
                            e.stopPropagation();
                            console.log('Button plus clicked for:', packageTitle);
                            updateQuantity(packageTitle, cartItem.quantity + 1);
                        });
                        
                        spinnerDiv.appendChild(minusBtn);
                        spinnerDiv.appendChild(quantityInput);
                        spinnerDiv.appendChild(plusBtn);
                        
                        btn.innerHTML = '';
                        btn.appendChild(spinnerDiv);
                        btn.classList.add('in-cart');
                        
                        console.log('Updated button to spinner for:', packageTitle);
                        console.log('Button innerHTML after update:', btn.innerHTML);
                        console.log('Quantity input value:', quantityInput.value);
                        console.log('Spinner div created:', spinnerDiv);
                    } else {
                        btn.innerHTML = '<i class="fas fa-shopping-cart"></i>';
                        btn.classList.remove('in-cart');
                    }
                });

                // Update main add to cart button
                const mainAddToCartBtn = document.querySelector('.add-to-cart-main-btn');
                if (mainAddToCartBtn) {
                    const currentPackage = document.querySelector('.package-item.selected');
                    if (currentPackage) {
                        const packageTitle = currentPackage.querySelector('h4').textContent;
                        const cartItem = cart.find(item => item.title === packageTitle);

                        console.log('Main button - current package:', packageTitle, 'cart item:', cartItem);

                        if (cartItem && cartItem.quantity > 0) {
                            // Create spinner with proper event handling for main button
                            const spinnerDiv = document.createElement('div');
                            spinnerDiv.className = 'quantity-spinner';
                            
                            const minusBtn = document.createElement('button');
                            minusBtn.textContent = '-';
                            minusBtn.type = 'button';
                            minusBtn.addEventListener('click', function(e) {
                                e.stopPropagation();
                                console.log('Main button minus clicked for:', packageTitle);
                                updateQuantity(packageTitle, cartItem.quantity - 1);
                            });
                            
                            const quantityInput = document.createElement('input');
                            quantityInput.type = 'text';
                            quantityInput.className = 'quantity-display';
                            quantityInput.value = cartItem.quantity;
                            quantityInput.readOnly = true;
                            
                            const plusBtn = document.createElement('button');
                            plusBtn.textContent = '+';
                            plusBtn.type = 'button';
                            plusBtn.addEventListener('click', function(e) {
                                e.stopPropagation();
                                console.log('Main button plus clicked for:', packageTitle);
                                updateQuantity(packageTitle, cartItem.quantity + 1);
                            });
                            
                            spinnerDiv.appendChild(minusBtn);
                            spinnerDiv.appendChild(quantityInput);
                            spinnerDiv.appendChild(plusBtn);
                            
                            mainAddToCartBtn.innerHTML = '';
                            mainAddToCartBtn.appendChild(spinnerDiv);
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
                console.log('=== DEBUG: updateTotal() ===');
                console.log('Cart items:', cart);
                console.log('Cart length:', cart.length);
                
                const subtotal = cart.reduce((sum, item) => {
                    console.log('Processing item:', item.title, 'price:', item.price, 'quantity:', item.quantity);
                    console.log('Price type:', typeof item.price);
                    
                    // Handle different price formats
                    let price = 0;
                    if (typeof item.price === 'number') {
                        price = item.price;
                    } else if (typeof item.price === 'string') {
                        // Remove all non-digit characters
                        const priceStr = item.price.replace(/[^\d]/g, '');
                        price = parseInt(priceStr) || 0;
                    }
                    
                    const itemTotal = price * item.quantity;
                    console.log('Calculated price:', price);
                    console.log('Item total:', itemTotal);
                    return sum + itemTotal;
                }, 0);

                // Calculate VAT (8%)
                const vatAmount = subtotal * 0.08;
                const totalWithVAT = subtotal + vatAmount;
                
                console.log('Subtotal:', subtotal);
                console.log('VAT (8%):', vatAmount);
                console.log('Total with VAT:', totalWithVAT);
                console.log('Total with VAT (rounded):', Math.round(totalWithVAT));
                console.log('Total with VAT (as string):', Math.round(totalWithVAT).toString());

                const totalElement = document.querySelector('.total-amount');
                console.log('Total element found:', totalElement);
                
                // Debug total element
                debugTotalElement();
                
                // Test number formatting
                testNumberFormatting();
                if (totalElement) {
                    if (totalWithVAT > 0) {
                        // Use custom formatting function
                        const roundedTotal = Math.round(totalWithVAT);
                        const formattedTotal = formatVietnameseNumber(roundedTotal);
                        console.log('Rounded total:', roundedTotal);
                        console.log('Formatted total:', formattedTotal);
                        totalElement.textContent = formattedTotal + ' VND';
                    } else {
                        totalElement.textContent = '0 VND';
                    }
                    console.log('Updated total element:', totalElement.textContent);
                    console.log('Total element innerHTML:', totalElement.innerHTML);
                } else {
                    console.error('Total element not found!');
                    console.log('Available elements with class total-amount:', document.querySelectorAll('.total-amount'));
                }
                console.log('=== END DEBUG: updateTotal() ===');
            }
            
            // Debug function to check total element
            function debugTotalElement() {
                console.log('=== DEBUG: debugTotalElement() ===');
                const totalElement = document.querySelector('.total-amount');
                console.log('Total element:', totalElement);
                console.log('Total element textContent:', totalElement ? totalElement.textContent : 'null');
                console.log('Total element innerHTML:', totalElement ? totalElement.innerHTML : 'null');
                console.log('Total element style:', totalElement ? totalElement.style.cssText : 'null');
                console.log('Total element computed style:', totalElement ? window.getComputedStyle(totalElement) : 'null');
                console.log('=== END DEBUG: debugTotalElement() ===');
            }
            
            // Debug function to check quantity spinners
            function debugQuantitySpinners() {
                console.log('=== DEBUG: debugQuantitySpinners() ===');
                const spinners = document.querySelectorAll('.quantity-spinner');
                console.log('Found quantity spinners:', spinners.length);
                spinners.forEach((spinner, index) => {
                    console.log(`Spinner ${index}:`, spinner);
                    console.log(`Spinner ${index} innerHTML:`, spinner.innerHTML);
                    const input = spinner.querySelector('.quantity-display');
                    console.log(`Spinner ${index} input value:`, input ? input.value : 'null');
                });
                console.log('=== END DEBUG: debugQuantitySpinners() ===');
            }
            
            // Function to preserve cart state when switching tabs
            function preserveCartState() {
                console.log('=== DEBUG: preserveCartState() ===');
                console.log('Current cart state:', cart);
                console.log('Cart items count:', cart.length);
                cart.forEach((item, index) => {
                    console.log(`Cart item ${index}:`, item.title, 'quantity:', item.quantity);
                });
                console.log('=== END DEBUG: preserveCartState() ===');
            }
            
            // Function to test number formatting
            function testNumberFormatting() {
                console.log('=== DEBUG: testNumberFormatting() ===');
                const testNumbers = [860, 1234, 12345, 123456, 1234567];
                testNumbers.forEach(num => {
                    const formatted = num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
                    console.log(`${num} -> ${formatted}`);
                });
                console.log('=== END DEBUG: testNumberFormatting() ===');
            }
            
            // Function to format Vietnamese number
            function formatVietnameseNumber(num) {
                if (num < 1000) {
                    return num.toString();
                }
                return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
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

                // Calculate total count and amount
                const totalCount = cart.reduce((total, item) => total + item.quantity, 0);
                const totalAmount = cart.reduce((sum, item) => {
                    const price = parseInt(item.price.replace(/[^\d]/g, ''));
                    return sum + (price * item.quantity);
                }, 0);

                // Build cart items HTML
                let cartItemsHTML = '';
                cart.forEach(item => {
                    cartItemsHTML += `
              <div class="cart-dropdown-item">
              <div class="item-info">
              <h4>${item.title}</h4>
              <div class="item-price">${item.price}</div>
              </div>
              <div class="item-controls">
              <div class="quantity-spinner">
              <button onclick="updateQuantity('${item.title}', ${item.quantity - 1})" style="border: 1px solid red;">-</button>
              <input type="text" class="quantity-display" value="${item.quantity}" readonly>
              <button onclick="updateQuantity('${item.title}', ${item.quantity + 1})" style="border: 1px solid red;">+</button>
              </div>
              <button onclick="removeFromCart('${item.title}')" class="remove-btn">
              <i class="fas fa-trash"></i>
              </button>
              </div>
              </div>
                    `;
                });

                cartDropdown.innerHTML = `
                    <div class="cart-dropdown-content">
                        <h3>Giỏ hàng (<span id="cart-total-count">${totalCount}</span> sản phẩm)</h3>
                        <div class="cart-dropdown-items">
                            ${cartItemsHTML}
                        </div>
                        <div class="cart-dropdown-total">
                            <strong>Tổng: <span id="cart-total-amount">${totalAmount.toLocaleString('vi-VN')}</span> VND</strong>
                        </div>
                        <div class="cart-dropdown-actions">
                            <button onclick="document.querySelector('.cart-dropdown').style.display='none'" class="close-btn">Đóng</button>
                            <button onclick="alert('Chuyển đến trang thanh toán...')" class="checkout-btn">Thanh toán</button>
                        </div>
                    </div>
                `;

                cartDropdown.style.display = 'block';
            }

            function updatePackageContent(selectedItem) {
                const packageTitle = selectedItem.querySelector('h4').textContent;
                const packagePrice = selectedItem.querySelector('.package-price').textContent;

                // Find matching package data from current tab data
                let packageData = null;
                if (packagesData[currentTab]) {
                    packageData = packagesData[currentTab].find(pkg => pkg.packageName === packageTitle);
                }

                if (packageData) {
                    // Update product header
                    const productHeader = document.querySelector('.product-header');
                    productHeader.querySelector('h2').textContent = packageData.packageName;
                    productHeader.querySelector('.product-price').textContent = formatPrice(packageData.price);

                    // Add warning for "Việc Cần Tuyển Gấp"
                    let warningDiv = productHeader.querySelector('.warning-message');
                    if (packageData.packageName.toLowerCase().includes('tuyển gấp')) {
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
                    descriptionSection.textContent = packageData.description || 'Không có mô tả chi tiết.';

                    // Update includes section
                    const includesList = document.querySelector('.product-includes ul');
                    includesList.innerHTML = '';
                    
                    // Parse features from database
                    let features = [];
                    if (packageData.features) {
                        try {
                            features = JSON.parse(packageData.features);
                        } catch (e) {
                            // If not JSON, split by newline or comma
                            features = packageData.features.split(/[\n,]/).filter(f => f.trim());
                        }
                    }
                    
                    // Default features if none provided
                    if (features.length === 0) {
                        features = [
                            'Dịch vụ chất lượng cao',
                            'Hỗ trợ 24/7',
                            'Bảo hành đầy đủ'
                        ];
                    }
                    
                    features.forEach(feature => {
                        const li = document.createElement('li');
                        li.innerHTML = `<i class="fas fa-check"></i> ${feature.trim()}`;
                        includesList.appendChild(li);
                    });
                } else {
                    // Fallback if package data not found
                    const productHeader = document.querySelector('.product-header');
                    productHeader.querySelector('h2').textContent = packageTitle;
                    productHeader.querySelector('.product-price').textContent = packagePrice;
                    
                    const descriptionSection = document.querySelector('.product-description p');
                    descriptionSection.textContent = 'Thông tin chi tiết đang được cập nhật.';
                }
            }
        </script>

    </body>
</html>

