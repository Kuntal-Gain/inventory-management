# inventory_management

## Question

Flutter Developer Intern Assignment:

*Task:*
> Create a basic Inventory Management App for a retail store using Flutter.

Requirements:

- Product List Screen:
    - Display a list of products with details like product name, SKU, price, and quantity.
- Add Product Screen:
    - Create a form where the user can add a new product (name, SKU, price, and initial quantity).
    - On successful addition, return to the Product List screen and show the updated list.
- Edit and Delete Product:
    - Allow users to update the details of a product (price, quantity) by tapping on a product in the list.
    - Include a delete option to remove a product from the list.
- Low-Stock Alert:
    - Show a red indicator for products that have a quantity of less than 5 to simulate the low-stock feature.
- Persistent Storage:
    - Use shared_preferences or sqflite to save the list of products locally so the data persists even when the app is closed.

*Bonus Points:*
- Search Functionality: Implement a search bar that allows users to search products by name or SKU.
- Sorting: Add the ability to sort products by name or price.
- State Management: Use a simple state management solution like Provider or Riverpod for handling state.

## Solution

- Keep Track of product / Stocks
- Product List
- Data Persistance
- Provider State Management
- Sorting Functionality
- Search Functionality