locals {
  /**
   * Generate network name from network id.
   */
  network_name = element(split("/",var.network),length(split("/",var.network))-1)
}