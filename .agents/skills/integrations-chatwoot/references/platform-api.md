# Chatwoot API Reference: Platform API (Installation Management)

This module is for system administrators managing self-hosted installations.

## Base URL
`https://{domain}/platform/api/v1/`

## Authentication
Requires a **Platform Access Token** generated in the Super Admin Console.
Include in headers: `api_access_token: {PLATFORM_TOKEN}`

---

## 1. Platform Accounts API

### Create an Account
- **Endpoint**: `POST /platform/api/v1/accounts`
- **Body**: `{ "name": "New Account Name" }`
- **Response**: Account object including its new `id`.

### Get Account Details
- **Endpoint**: `GET /platform/api/v1/accounts/{account_id}`

---

## 2. Platform Users API

### Create a User
- **Endpoint**: `POST /platform/api/v1/users`
- **Body**:
  ```json
  {
    "name": "User Name",
    "email": "user@example.com",
    "password": "strongpassword123",
    "custom_attributes": {}
  }
  ```

### Get User Details / SSO Link
- **Endpoint**: `GET /platform/api/v1/users/{user_id}`
- **Endpoint**: `GET /platform/api/v1/users/{user_id}/login` (Returns SSO login URL)

---

## 3. Account Users (Permissions)

### List Account Users
- **Endpoint**: `GET /platform/api/v1/accounts/{account_id}/account_users`

### Create Account User (Assign Role)
- **Endpoint**: `POST /platform/api/v1/accounts/{account_id}/account_users`
- **Body**:
  ```json
  {
    "user_id": 1,
    "role": "administrator"
  }
  ```
  - Roles: `agent`, `administrator`.

### Delete Account User (Revoke Access)
- **Endpoint**: `DELETE /platform/api/v1/accounts/{account_id}/account_users`
- **Body**: `{ "user_id": 1 }`
