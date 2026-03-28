variable "folder_id" {
  description = "Yandex Cloud folder ID"
  type        = string
}

variable "service_account_name" {
  description = "Name for the storage service account"
  type        = string
  default     = "storage-sa"
}

variable "buckets" {
  description = "Map of S3 buckets to create"
  type = map(object({
    max_size = optional(number, 0)
    cors_rules = optional(list(object({
      allowed_headers = optional(list(string), ["*"])
      allowed_methods = list(string)
      allowed_origins = list(string)
      expose_headers  = optional(list(string), [])
      max_age_seconds = optional(number, 3600)
    })), [])
  }))
  default = {}
}
