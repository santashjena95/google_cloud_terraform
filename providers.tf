provider "google" {
  credentials = file("./credentials.json")
  project     = "pelagic-magpie-308310"
}