// Создание бакета с использованием ключа

# Create bucket

resource "yandex_storage_bucket" "backups" {
  bucket        = "nik-2023-dev"
  
  # acl           = "public-read"
  access_key             = yandex_iam_service_account_static_access_key.sa-storage-key.access_key
  secret_key             = yandex_iam_service_account_static_access_key.sa-storage-key.secret_key
  force_destroy          = "true"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.kms-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  website {
    index_document = "index.html"
  }
}

# Create kms symmetric key

resource "yandex_kms_symmetric_key" "kms-a" {
  name              = "kms-a"
  description       = "kms symmetric key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
}