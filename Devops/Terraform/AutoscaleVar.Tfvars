aws_region             = "us-east-1"
cluster_name           = "counterapp-cluster"                   
service_name           = "counterapp-service"      
min_capacity           = 1 
max_capacity           = 5 
target_cpu_utilization = 80
scale_out_cooldown     = 60 
scale_in_cooldown      = 300
