
# LoreKeeper - HTTP API Gateway

resource "aws_apigatewayv2_api" "lorekeeper" {
  name          = "lorekeeper-dev-api"
  protocol_type = "HTTP"

  description = "Secure API for LoreKeeper"
}

# Configure Cognito token verification

resource "aws_apigatewayv2_authorizer" "cognito" {
  api_id          = aws_apigatewayv2_api.lorekeeper.id
  authorizer_type = "JWT"
  name            = "lorekeeper-cognito-authorizer"

  identity_sources = [
    "$request.header.Authorization"
  ]

  jwt_configuration {
    audience = [
      aws_cognito_user_pool_client.web.id
    ]

    issuer = "https://${aws_cognito_user_pool.users.endpoint}"
  }
}

