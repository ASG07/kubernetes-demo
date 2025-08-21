import './bootstrap';

// Enhanced CRUD application features

document.addEventListener('DOMContentLoaded', function() {
    // Form validation and UX improvements
    initializeFormValidation();

    // Search functionality
    initializeSearch();

    // Image preview functionality
    initializeImagePreview();

    // Confirmation dialogs
    initializeConfirmationDialogs();

    // Loading states
    initializeLoadingStates();
});

/**
 * Form validation and real-time feedback
 */
function initializeFormValidation() {
    const forms = document.querySelectorAll('form');

    forms.forEach(form => {
        const inputs = form.querySelectorAll('input, textarea, select');

        inputs.forEach(input => {
            // Real-time validation feedback
            input.addEventListener('blur', function() {
                validateField(this);
            });

            // Clear validation errors on input
            input.addEventListener('input', function() {
                clearFieldError(this);
            });
        });

        // Enhanced form submission
        form.addEventListener('submit', function(e) {
            const submitButton = this.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.innerHTML = `
                    <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white inline" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Processing...
                `;
            }
        });
    });
}

/**
 * Validate individual form fields
 */
function validateField(field) {
    const value = field.value.trim();
    const fieldName = field.name;
    let isValid = true;
    let errorMessage = '';

    // Required field validation
    if (field.hasAttribute('required') && !value) {
        isValid = false;
        errorMessage = `${getFieldLabel(field)} is required.`;
    }

    // Email validation
    if (field.type === 'email' && value && !isValidEmail(value)) {
        isValid = false;
        errorMessage = 'Please enter a valid email address.';
    }

    // URL validation
    if (field.type === 'url' && value && !isValidUrl(value)) {
        isValid = false;
        errorMessage = 'Please enter a valid URL.';
    }

    // Number validation
    if (field.type === 'number' && value) {
        const num = parseFloat(value);
        if (isNaN(num) || num < 0) {
            isValid = false;
            errorMessage = 'Please enter a valid positive number.';
        }
    }

    // Display validation result
    if (!isValid) {
        showFieldError(field, errorMessage);
    } else {
        clearFieldError(field);
    }

    return isValid;
}

/**
 * Show field validation error
 */
function showFieldError(field, message) {
    clearFieldError(field);

    field.classList.add('border-red-500');

    const errorDiv = document.createElement('p');
    errorDiv.className = 'mt-1 text-sm text-red-600 field-error';
    errorDiv.textContent = message;

    field.parentNode.appendChild(errorDiv);
}

/**
 * Clear field validation error
 */
function clearFieldError(field) {
    field.classList.remove('border-red-500');

    const existingError = field.parentNode.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
}

/**
 * Get field label for validation messages
 */
function getFieldLabel(field) {
    const label = field.parentNode.querySelector('label');
    if (label) {
        return label.textContent.replace('*', '').trim();
    }
    return field.name.charAt(0).toUpperCase() + field.name.slice(1);
}

/**
 * Email validation helper
 */
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

/**
 * URL validation helper
 */
function isValidUrl(url) {
    try {
        new URL(url);
        return true;
    } catch {
        return false;
    }
}

/**
 * Enhanced search functionality
 */
function initializeSearch() {
    const searchForm = document.querySelector('form[method="GET"]');
    if (!searchForm) return;

    const searchInput = searchForm.querySelector('input[name="search"]');
    const categorySelect = searchForm.querySelector('select[name="category"]');
    const statusSelect = searchForm.querySelector('select[name="status"]');

    let searchTimeout;

    // Auto-submit on search input (debounced)
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                searchForm.submit();
            }, 500); // 500ms delay
        });
    }

    // Auto-submit on filter changes
    [categorySelect, statusSelect].forEach(select => {
        if (select) {
            select.addEventListener('change', function() {
                searchForm.submit();
            });
        }
    });
}

/**
 * Image preview functionality
 */
function initializeImagePreview() {
    const imageUrlInputs = document.querySelectorAll('input[name="image_url"]');

    imageUrlInputs.forEach(input => {
        // Create preview container
        const previewContainer = document.createElement('div');
        previewContainer.className = 'mt-2 hidden';
        previewContainer.innerHTML = `
            <img src="" alt="Preview" class="w-32 h-32 object-cover rounded-md border border-gray-300">
            <button type="button" class="mt-1 text-xs text-red-600 hover:text-red-800" onclick="clearImagePreview(this)">
                Clear preview
            </button>
        `;

        input.parentNode.appendChild(previewContainer);

        // Update preview on input change
        input.addEventListener('input', function() {
            updateImagePreview(this, previewContainer);
        });

        // Load initial preview if URL exists
        if (input.value) {
            updateImagePreview(input, previewContainer);
        }
    });
}

/**
 * Update image preview
 */
function updateImagePreview(input, container) {
    const url = input.value.trim();
    const img = container.querySelector('img');

    if (url && isValidUrl(url)) {
        img.src = url;
        img.onload = () => {
            container.classList.remove('hidden');
        };
        img.onerror = () => {
            container.classList.add('hidden');
        };
    } else {
        container.classList.add('hidden');
    }
}

/**
 * Clear image preview
 */
window.clearImagePreview = function(button) {
    const container = button.parentNode;
    const input = container.parentNode.querySelector('input[name="image_url"]');

    input.value = '';
    container.classList.add('hidden');
    input.focus();
};

/**
 * Enhanced confirmation dialogs
 */
function initializeConfirmationDialogs() {
    const deleteButtons = document.querySelectorAll('button[type="submit"]');

    deleteButtons.forEach(button => {
        const form = button.closest('form');
        if (form && form.querySelector('input[name="_method"][value="DELETE"]')) {
            button.addEventListener('click', function(e) {
                e.preventDefault();

                showConfirmationModal(
                    'Delete Product',
                    'Are you sure you want to delete this product? This action cannot be undone.',
                    'Delete',
                    'bg-red-600 hover:bg-red-700',
                    () => form.submit()
                );
            });
        }
    });
}

/**
 * Show custom confirmation modal
 */
function showConfirmationModal(title, message, confirmText, confirmClass, onConfirm) {
    const modal = document.createElement('div');
    modal.className = 'fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full z-50';
    modal.innerHTML = `
        <div class="relative top-20 mx-auto p-5 border w-96 shadow-lg rounded-md bg-white">
            <div class="mt-3 text-center">
                <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
                    <svg class="h-6 w-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"/>
                    </svg>
                </div>
                <h3 class="text-lg leading-6 font-medium text-gray-900 mt-2">${title}</h3>
                <div class="mt-2 px-7 py-3">
                    <p class="text-sm text-gray-500">${message}</p>
                </div>
                <div class="items-center px-4 py-3">
                    <button class="px-4 py-2 ${confirmClass} text-white text-base font-medium rounded-md w-24 mr-2" onclick="confirmAction()">
                        ${confirmText}
                    </button>
                    <button class="px-4 py-2 bg-gray-300 text-black text-base font-medium rounded-md w-24" onclick="closeModal()">
                        Cancel
                    </button>
                </div>
            </div>
        </div>
    `;

    document.body.appendChild(modal);

    // Set up modal functions
    window.confirmAction = () => {
        onConfirm();
        closeModal();
    };

    window.closeModal = () => {
        document.body.removeChild(modal);
        delete window.confirmAction;
        delete window.closeModal;
    };

    // Close on background click
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            window.closeModal();
        }
    });
}

/**
 * Loading states for buttons and forms
 */
function initializeLoadingStates() {
    // Add loading state to all form submissions
    const forms = document.querySelectorAll('form');

    forms.forEach(form => {
        form.addEventListener('submit', function() {
            const submitButtons = this.querySelectorAll('button[type="submit"]');

            submitButtons.forEach(button => {
                if (!button.disabled) {
                    const originalText = button.innerHTML;
                    button.disabled = true;
                    button.classList.add('opacity-75');

                    // Add loading spinner
                    button.innerHTML = `
                        <svg class="animate-spin -ml-1 mr-3 h-4 w-4 text-white inline" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        Processing...
                    `;
                }
            });
        });
    });
}
