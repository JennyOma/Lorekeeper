
# LoreKeeper - User authentication

resource "aws_cognito_user_pool" "users" {
  name           = "lorekeeper-dev-users"
  user_pool_tier = "LITE"

  # Users will sign in using email addresses
  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  # Do not allow public self-registration
  admin_create_user_config {
    allow_admin_create_user_only = true
  }

  password_policy {
    minimum_length    = 12
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }
}

# Application client for future sign-in
resource "aws_cognito_user_pool_client" "web" {
  name         = "lorekeeper-dev-client"
  user_pool_id = aws_cognito_user_pool.users.id

  # Browser applications cannot safely store client secrets
  generate_secret               = false
  prevent_user_existence_errors = "ENABLED"

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  access_token_validity  = 15
  id_token_validity      = 15
  refresh_token_validity = 1

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}
