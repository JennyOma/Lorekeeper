
# LoreKeeper - KMS encryption key

resource "aws_kms_key" "documents" {
  description = "Encryption key for LoreKeeper documents"

  enable_key_rotation     = true
  deletion_window_in_days = 7

  tags = {
    Purpose = "Document encryption"
  }
}

resource "aws_kms_alias" "documents" {
  name          = "alias/lorekeeper-dev-documents"
  target_key_id = aws_kms_key.documents.key_id
}
