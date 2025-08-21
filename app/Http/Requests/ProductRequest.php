<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProductRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name' => 'required|string|max:255',
            'description' => 'required|string|max:2000',
            'price' => 'required|numeric|min:0|max:999999.99',
            'category' => 'required|string|max:255',
            'image_url' => 'nullable|url|max:500',
            'is_active' => 'boolean'
        ];
    }

    /**
     * Get custom attribute names for validation errors.
     */
    public function attributes(): array
    {
        return [
            'name' => 'product name',
            'description' => 'product description',
            'price' => 'product price',
            'category' => 'product category',
            'image_url' => 'image URL',
            'is_active' => 'product status'
        ];
    }

    /**
     * Get custom error messages for validation rules.
     */
    public function messages(): array
    {
        return [
            'name.required' => 'The product name is required.',
            'name.max' => 'The product name must not exceed 255 characters.',
            'description.required' => 'The product description is required.',
            'description.max' => 'The description must not exceed 2000 characters.',
            'price.required' => 'The product price is required.',
            'price.numeric' => 'The price must be a valid number.',
            'price.min' => 'The price must be at least $0.00.',
            'price.max' => 'The price must not exceed $999,999.99.',
            'category.required' => 'The product category is required.',
            'category.max' => 'The category must not exceed 255 characters.',
            'image_url.url' => 'The image URL must be a valid URL.',
            'image_url.max' => 'The image URL must not exceed 500 characters.'
        ];
    }

    /**
     * Prepare the data for validation.
     */
    protected function prepareForValidation(): void
    {
        $this->merge([
            'is_active' => $this->boolean('is_active')
        ]);
    }
}
