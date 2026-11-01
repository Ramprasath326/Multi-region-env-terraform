variable "name" {
  description = "Repository name, for example dev-app."
  type        = string
}

variable "force_delete" {
  description = "Allow destroy even if images exist. Keep false in prod."
  type        = bool
  default     = false
}

variable "keep_last" {
  description = "Number of most recent images to keep."
  type        = number
  default     = 20
}

variable "untagged_expire_days" {
  description = "Delete untagged images after this many days."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Extra tags."
  type        = map(string)
  default     = {}
}
