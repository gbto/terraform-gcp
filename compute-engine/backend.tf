terraform {
  backend "gcs" {
    bucket = "gbto-tfstates"
    prefix = "terraform/state"
  }
}
