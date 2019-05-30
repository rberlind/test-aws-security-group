variable "cidr_1" {
  default = "10.100.20.1/32"
}

variable "cidr_2" {
  default = "10.100.20.2/32"
}

variable "cidr_3" {
  default = "10.100.20.7/32"
}

variable "cidr_4" {
  default = "0.0.0.0/0"
}

variable "vpc_id" {
  default = "vpc-0ef62214b4149796f"
}

module "nested" {
  source = "./module"
  cidr_1 = "${var.cidr_1}"
  cidr_2 = "${var.cidr_2}"
  cidr_3 = "${var.cidr_3}"
  cidr_4 = "${var.cidr_4}"
  vpc_id = "${var.vpc_id}"
}


resource "aws_security_group" "test_root" {
  name        = "test_root"
  description = "test"
  vpc_id      = "${var.vpc_id}"

  tags {
    name = "webapp00"
  }

  egress {
    description = "ps remote servers"
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_1}", "${var.cidr_2}"]
    self        = false
  }

  egress {
    description = "ntp servers"
    from_port   = 123
    to_port     = 123
    protocol    = "udp"
    cidr_blocks = ["${var.cidr_3}"]
    self        = false
  }

  egress {
    description = "mail servers"
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_3}"]
    self        = false
  }

  ingress {
    description = "internet facing lbs"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["${var.cidr_4}"]
  }
}
