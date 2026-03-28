output "access_key" {
  description = "S3 access key"
  value       = yandex_iam_service_account_static_access_key.storage.access_key
}

output "secret_key" {
  description = "S3 secret key"
  value       = yandex_iam_service_account_static_access_key.storage.secret_key
  sensitive   = true
}

output "bucket_names" {
  description = "Map of bucket keys to their names"
  value       = { for k, b in yandex_storage_bucket.this : k => b.bucket }
}
