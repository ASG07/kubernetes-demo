# ProductHub - Elegant CRUD Application

A modern, elegant CRUD application built with Laravel 12 and TailwindCSS 4.0 for managing products. This application demonstrates best practices in web development with a beautiful, responsive interface and comprehensive functionality.

## Features

### 🎨 **Modern Design**
- Clean, elegant interface built with TailwindCSS 4.0
- Responsive design that works on all devices
- Professional navigation and layout
- Beautiful product cards with image support
- Smooth animations and transitions

### 📝 **Complete CRUD Operations**
- **Create**: Add new products with detailed information
- **Read**: Browse products with search and filtering
- **Update**: Edit existing product information
- **Delete**: Remove products with confirmation dialogs

### 🔍 **Advanced Search & Filtering**
- Real-time search by product name and description
- Filter by category (Electronics, Clothing, Sports, etc.)
- Filter by status (Active/Inactive)
- Debounced search for better performance
- Clear filters functionality

### ✅ **Form Validation**
- Server-side validation with custom Form Requests
- Client-side validation with real-time feedback
- Comprehensive error messages
- Field validation on blur events

### 🖼️ **Image Management**
- Image URL input with live preview
- Fallback placeholders for products without images
- Image validation and error handling

### 🎯 **User Experience**
- Loading states for all form submissions
- Success/error flash messages with auto-dismiss
- Confirmation dialogs for destructive actions
- Pagination for product listings
- Elegant empty states

### 📱 **Responsive Features**
- Mobile-friendly navigation
- Responsive grid layouts
- Touch-friendly buttons and interactions
- Optimized for all screen sizes

## Technology Stack

- **Backend**: Laravel 12
- **Frontend**: TailwindCSS 4.0
- **Database**: MySQL (via Laravel Sail)
- **Build Tool**: Vite
- **Container**: Docker (Laravel Sail)

## Quick Start

### Prerequisites
- Docker Desktop
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd laravel-sail-app
   ```

2. **Install dependencies**
   ```bash
   composer install
   npm install
   ```

3. **Start Laravel Sail**
   ```bash
   ./vendor/bin/sail up -d
   ```

4. **Run migrations and seed data**
   ```bash
   ./vendor/bin/sail artisan migrate:fresh --seed
   ```

5. **Build frontend assets**
   ```bash
   npm run build
   ```

6. **Access the application**
   Open your browser and visit: `http://localhost`

## Database Schema

### Products Table
- `id` - Primary key
- `name` - Product name (required, max 255 chars)
- `description` - Product description (required, max 2000 chars)
- `price` - Product price (decimal, min 0, max 999999.99)
- `category` - Product category (required, max 255 chars)
- `image_url` - Optional image URL (max 500 chars)
- `is_active` - Boolean status (default: true)
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

## Sample Data

The application comes with 12 sample products across different categories:
- **Electronics**: MacBook Pro, Smartphones, Headphones, Speakers
- **Clothing**: Denim Jackets, T-Shirts
- **Sports**: Running Shoes, Yoga Mats
- **Home**: Coffee Mugs, Desk Lamps
- **Accessories**: Leather Wallets, Vintage Watches

## Development

### Available Commands

```bash
# Start development server
./vendor/bin/sail up

# Run migrations
./vendor/bin/sail artisan migrate

# Seed database
./vendor/bin/sail artisan db:seed

# Build assets for development
npm run dev

# Build assets for production
npm run build

# Run tests
./vendor/bin/sail artisan test
```

### File Structure

```
app/
├── Http/
│   ├── Controllers/
│   │   └── ProductController.php    # Main CRUD controller
│   └── Requests/
│       └── ProductRequest.php       # Form validation
├── Models/
│   └── Product.php                  # Product model
database/
├── migrations/
│   └── create_products_table.php    # Database schema
└── seeders/
    └── ProductSeeder.php            # Sample data
resources/
├── css/
│   └── app.css                      # TailwindCSS styles
├── js/
│   └── app.js                       # Interactive features
└── views/
    ├── layouts/
    │   └── app.blade.php            # Base layout
    └── products/                    # Product views
        ├── index.blade.php          # Product listing
        ├── create.blade.php         # Create form
        ├── edit.blade.php           # Edit form
        └── show.blade.php           # Product details
```

## Features Showcase

### 🏠 **Index Page**
- Grid layout with product cards
- Search and filter controls
- Pagination
- Responsive design
- Quick actions (View, Edit, Delete)

### ➕ **Create/Edit Forms**
- Comprehensive form validation
- Image URL preview
- Loading states
- Error handling
- Responsive layout

### 👁️ **Product Details**
- Full product information display
- Action buttons
- Related quick actions
- Professional layout

### 🔍 **Search & Filters**
- Real-time search
- Category filtering
- Status filtering
- URL persistence
- Clear filters option

## Contributing

This is a demonstration project showcasing modern Laravel development practices. Feel free to explore the code and use it as a reference for your own projects.

## License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
