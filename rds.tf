# AWS RDS with Postgres
resource "aws_db_instance" "pythonapp_db" {
  identifier             = "pythonapp-db"
  engine                 = "postgres"
  engine_version         = "16.4"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.DATABASE_NAME
  username               = var.DATABASE_USER
  password               = var.DATABASE_PASS
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = "pythonapp-db-subnet-group"
  subnet_ids = aws_subnet.subnet.*.id
}
