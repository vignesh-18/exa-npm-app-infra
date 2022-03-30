# data "aws_caller_identity" "current" {}

# data "aws_vpc" "customtvpc" {
#   id = aws_vpc.ecs_vpc.id
# }

# data "aws_subnet_ids" "customsubnet" {
#   vpc_id = data.aws_vpc.customtvpc.id
# }

# data "aws_subnet" "test_subnet" {
#   count = "${length(data.aws_subnet_ids.customsubnet.ids)}"
#   id    = "${tolist(data.aws_subnet_ids.customsubnet.ids)[count.index]}"
# }


# output "subnet_cidr_blocks" {
#   value = ["${data.aws_subnet.test_subnet.*.id}"]
# }