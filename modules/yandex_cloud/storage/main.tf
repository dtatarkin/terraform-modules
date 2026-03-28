resource "yandex_iam_service_account" "storage" {
  name        = var.service_account_name
  description = "Service account for Object Storage access"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "storage_editor" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.storage.id}"
}

resource "yandex_iam_service_account_static_access_key" "storage" {
  service_account_id = yandex_iam_service_account.storage.id
  description        = "Static access key for Object Storage"
}

resource "yandex_kms_symmetric_key" "storage" {
  name              = "storage-encryption-key"
  description       = "KMS key for S3 bucket server-side encryption"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
  folder_id         = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "storage_kms" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.storage.id}"
}

resource "yandex_storage_bucket" "this" {
  for_each = var.buckets

  bucket     = each.key
  max_size   = each.value.max_size
  access_key = yandex_iam_service_account_static_access_key.storage.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage.secret_key

  dynamic "cors_rule" {
    for_each = each.value.cors_rules
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.storage.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  depends_on = [yandex_resourcemanager_folder_iam_member.storage_kms]
}
