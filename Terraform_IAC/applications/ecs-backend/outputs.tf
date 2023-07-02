output "results_output" {
  description = "generate accessible url based on uat or prod environement"
  value       = {
    back_domain_name = module.back-ecs.back_domain_name
  } 

}
