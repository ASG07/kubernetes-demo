<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $products = [
            [
                'name' => 'MacBook Pro 14"',
                'description' => 'Apple MacBook Pro 14-inch with M3 chip. Perfect for professionals and creators who need powerful performance in a portable design.',
                'price' => 1999.00,
                'category' => 'electronics',
                'image_url' => 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Wireless Headphones',
                'description' => 'Premium noise-cancelling wireless headphones with 30-hour battery life. Experience crystal clear audio quality.',
                'price' => 299.99,
                'category' => 'electronics',
                'image_url' => 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Classic Denim Jacket',
                'description' => 'Timeless denim jacket made from premium cotton. A versatile piece that complements any wardrobe.',
                'price' => 89.95,
                'category' => 'clothing',
                'image_url' => 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Ceramic Coffee Mug Set',
                'description' => 'Set of 4 handcrafted ceramic coffee mugs. Perfect for your morning brew or afternoon tea.',
                'price' => 45.00,
                'category' => 'home',
                'image_url' => 'https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Smartphone',
                'description' => 'Latest flagship smartphone with advanced camera system and all-day battery life.',
                'price' => 899.00,
                'category' => 'electronics',
                'image_url' => 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Running Shoes',
                'description' => 'High-performance running shoes with advanced cushioning technology for maximum comfort.',
                'price' => 129.99,
                'category' => 'sports',
                'image_url' => 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Organic Cotton T-Shirt',
                'description' => 'Comfortable organic cotton t-shirt available in multiple colors. Sustainably sourced and ethically made.',
                'price' => 24.99,
                'category' => 'clothing',
                'image_url' => 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Desk Lamp',
                'description' => 'Modern LED desk lamp with adjustable brightness and color temperature. Perfect for work or study.',
                'price' => 69.99,
                'category' => 'home',
                'image_url' => 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Yoga Mat',
                'description' => 'Premium non-slip yoga mat made from eco-friendly materials. Ideal for yoga, pilates, and exercise.',
                'price' => 39.95,
                'category' => 'sports',
                'image_url' => 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Leather Wallet',
                'description' => 'Handcrafted genuine leather wallet with multiple card slots and bill compartments.',
                'price' => 59.00,
                'category' => 'accessories',
                'image_url' => 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Bluetooth Speaker',
                'description' => 'Portable Bluetooth speaker with 360-degree sound and waterproof design. Perfect for outdoor adventures.',
                'price' => 79.99,
                'category' => 'electronics',
                'image_url' => 'https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=500&h=300&fit=crop',
                'is_active' => true,
            ],
            [
                'name' => 'Vintage Watch',
                'description' => 'Classic vintage-style watch with automatic movement. A timeless accessory for any occasion.',
                'price' => 249.00,
                'category' => 'accessories',
                'image_url' => 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=500&h=300&fit=crop',
                'is_active' => false,
            ],
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}
